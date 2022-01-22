fx_version 'cerulean'
games { 'gta5' }

author 'Blitoka33'
description 'FiveM Anticheat'
version '1.0.0'

shared_script { 
    'clientconfig.lua',
}

client_script { 
    'client.lua'
}

server_script { 
    'serverconfig.lua',
    'webhookconfig.lua',
    'server.lua',
}