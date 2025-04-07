ESX = exports.es_extended:getSharedObject()

local discordWebhookUrl = GetConvar('zyro_giveitemlog', '')

if discordWebhookUrl == '' then
    print("[zyro_giveitemlog] WARNING: Discord webhook URL for /giveitem logging is not set in server.cfg (set zyro_giveitemlog webhookURL). Discord logging will be disabled.")
end

local function SendToDiscord(message, adminName, adminId, targetName, targetId, itemName, itemCount)
    if discordWebhookUrl == '' then return end 

    local embed = {
        {
            ["color"] = 1752220, -- Aqua Blue (You can change it by yourself: https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812)
            ["title"] = ":package: Command Log: /giveitem",
            ["description"] = message,
            ["fields"] = {
                {["name"] = "Admin", ["value"] = string.format("%s (ID: %d)", adminName, adminId), ["inline"] = true},
                {["name"] = "Player", ["value"] = string.format("%s (ID: %d)", targetName, targetId), ["inline"] = true},
                {["name"] = "Item", ["value"] = string.format("%dx %s", itemCount, itemName), ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = "zyro_giveitemlog - " .. os.date("%Y-%m-%d %H:%M:%S", os.time()) 
            }
        }
    }

    local payload = {
        username = "GiveItem Log Bot", 
        -- avatar_url = "", -- Image URL for bot avatar (optional)
        embeds = embed
    }

    local jsonData = json.encode(payload)
    if not jsonData then
         print("[zyro_giveitemlog] ERROR: json.encode(payload) failed! Unable to send record to Discord.")
         return 
    end

    PerformHttpRequest(discordWebhookUrl, function(err, text, headers)
        if err ~= 200 and err ~= 204 then -- 200 OK, 204 No Content (úspěch)
            print(('[GiveItem Log] Chyba při odesílání logu na Discord: Odpověď serveru: [%s] (HTTP Status: %s)'):format(text or "No response", err or "Unknown ERROR"))
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end

RegisterCommand('giveitem', function(source, args, rawCommand)
    local adminId = source
    local adminName = GetPlayerName(adminId)

    if #args ~= 3 then
        TriggerClientEvent('chat:addMessage', adminId, { color = {255, 0, 0}, args = {"[System]", "Use: /giveitem [ID] [Item] [Amount]"} })
        return
    end

    local targetPlayerId = tonumber(args[1])
    local itemName = tostring(args[2])
    local itemCount = tonumber(args[3])

    if not targetPlayerId or targetPlayerId <= 0 then
        TriggerClientEvent('chat:addMessage', adminId, { color = {255, 0, 0}, args = {"[System]", "Invalid player ID."} })
        return
    end
    if not itemCount or itemCount <= 0 then
        TriggerClientEvent('chat:addMessage', adminId, { color = {255, 0, 0}, args = {"[System]", "Invalid number of items (must be a positive number)."} })
        return
    end
    if itemName == "" then
         TriggerClientEvent('chat:addMessage', adminId, { color = {255, 0, 0}, args = {"[System]", "Item name must not be empty."} })
        return
    end

    local targetName = GetPlayerName(targetPlayerId)
    if not targetName then
        TriggerClientEvent('chat:addMessage', adminId, { color = {255, 0, 0}, args = {"[System]", "Player with ID " .. targetPlayerId .. " not found online."} })
        return
    end

    local success, reason = exports.ox_inventory:AddItem(targetPlayerId, itemName, itemCount)

    if success then
        TriggerClientEvent('chat:addMessage', adminId, { color = {0, 255, 0}, args = {"[System]", string.format("You successfully gave %dx %s player %s (ID: %d).", itemCount, itemName, targetName, targetPlayerId)} })
        TriggerClientEvent('chat:addMessage', targetPlayerId, { color = {0, 255, 0}, args = {"[System]", string.format("You received %dx %s from admin.", itemCount, itemName)} })

        local logMessage = string.format("**Admin %s (ID: %d)** gave **%dx %s** player **%s (ID: %d)**",
                                        adminName, adminId, itemCount, itemName, targetName, targetPlayerId)

        -- You can put debug to server console if you want.
   --     print(("[zyro_giveitemlog] %s"):format(logMessage:gsub("%*","")))

        SendToDiscord(logMessage, adminName, adminId, targetName, targetPlayerId, itemName, itemCount)

    else
        local failReason = reason or "Unknown reason (ox_inventory did not return a reason)."
        TriggerClientEvent('chat:addMessage', adminId, { color = {255, 0, 0}, args = {"[System]", string.format("Failed to give an item to a player %s (ID: %d). Reason: %s", targetName, targetPlayerId, failReason)} })
        print(string.format("[zyro_giveitemlog] Failed to give %dx %s player %s (ID: %d) by admin %s (ID: %d). Reason: %s", itemCount, itemName, targetName, targetPlayerId, adminName, adminId, failReason))
    end

end, true) -- true = restricted command

print("[zyro_giveitemlog] ESX/ox_inventory script for logging /giveitem successfully loaded.")