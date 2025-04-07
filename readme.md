# Giveitem log for ESX & ox_inventory

This script for FiveM servers running the ESX framework with `ox_inventory` logs the usage of the administrative command `/giveitem` and sends detailed records to your chosen Discord webhook.

## Preview
* Discord log
https://imgur.com/a/f1HPkkC

* Ingame chat 
https://imgur.com/a/iTGftfb

## Dicord

* https://discord.gg/gp4KJFGhU7

## Features

* Logs the usage of the `/giveitem` command.
* Sends logs to a Discord webhook in real-time.
* Formats logs into clear Discord embeds (includes admin, target, item, count, and timestamp).
* Checks for successful item addition via `ox_inventory` before logging to Discord.
* Configurable Discord webhook URL via `server.cfg`.
* Warning message in the server console on startup if the webhook URL is not set.

## Requirements

* **ESX Framework:** A compatible version (e.g., ESX Legacy 1.9.0+).
* **ox_inventory:** A working installation of `ox_inventory`.
* **ox_lib:** A working installation of `ox_lib` (required by `ox_inventory` and for JSON functions).
* **Server:** Must have **Lua 5.4** enabled (see `fxmanifest.lua` of this resource).

## Installation

1.  Download or clone the files for this script (`giveitem_log_sv.lua`, `fxmanifest.lua`, `README.md`).
2.  Create a folder for the resource in your server's `resources` directory (e.g., `[logs]/zyro_giveitemlog`). *Ensure the folder name contains no spaces or special characters*.
3.  Place the downloaded files (`giveitem_log_sv.lua`, `fxmanifest.lua`, `README.md`) into this newly created folder.
4.  Ensure you have installed and started all **Requirements** (ESX, ox_inventory, ox_lib).
5.  Add the following line to your `server.cfg` file:

  * set zyro_giveitemlog "YOUR_DISCORD_WEBHOOK_URL_HERE"

6.  Restart your FiveM server.

## Configuration

### Discord Webhook URL

For logs to be sent to Discord, you must set up a valid webhook URL.

1.  Create a Webhook on your Discord server (Server Settings -> Integrations -> Webhooks -> New Webhook).
2.  Copy the Webhook URL.
3.  Open your `server.cfg` and add (or edit) the following line. Replace `YOUR_DISCORD_WEBHOOK_URL_HERE` with your actual URL:

   * set zyro_giveitemlog "YOUR_DISCORD_WEBHOOK_URL_HERE"

* *If this value is not set correctly, the script will print a warning on startup, and Discord logging will be disabled.*

## Usage

After correct installation and configuration, players with the `command.giveitem` permission can use the command in the game chat:

`/giveitem [Player ID] [Item Name] [Count]`

* `[Player ID]`: The server ID of the player you want to give the item to (visible in the player list, etc.).
* `[Item Name]`: The exact item spawn code known by your `ox_inventory` system (e.g., `water`, `bandage`, `weapon_pistol`).
* `[Count]`: A positive integer specifying the quantity.

Every successful use of the command (i.e., when `ox_inventory` successfully adds the item) will be logged to the server console and also sent as a formatted embed message to your Discord webhook. If adding the item fails (e.g., full inventory), the action will only be logged to the server console with the reason for failure.
