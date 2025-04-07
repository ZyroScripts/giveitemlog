fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Zyro'
description 'ESX (OX) /giveitem Log created by Zyro https://discord.gg/gp4KJFGhU7'
version '1.3.0' 

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib'
}

server_scripts {
    '@ox_lib/init.lua',
    'giveitem_log_sv.lua'
}

convar_category 'Discord Logs' {
    {
        name        = 'zyro_giveitemlog',
        description = 'URL of Discord webhook for logging /giveitem', 
        type        = 'string',
        default     = ''
    }
}
