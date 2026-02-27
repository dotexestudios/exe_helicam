fx_version "cerulean"
game "gta5"
lua54 "yes"

original_author "ZeroFour04"
author "Polaris Labs (filo)"
description "A FiveM helicoper camera script"
discord "https://discord.gg/EWKWXVBHK7"

version "1.0.0"

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
}

server_scripts {
    "version_check.lua",
    "server.lua",
}

client_scripts {
    "client.lua",
}