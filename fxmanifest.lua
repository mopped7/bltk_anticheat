fx_version 'cerulean'
games { 'gta5' }

author 'Blitoka33'
description 'FiveM Anticheat'
version '1.0.0'

client_script { 
    'client.lua'
}

server_script { 
    'serverconfig.lua',
    'webhookconfig.lua',
    'clientconfig.lua',
    'server.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html'
}
client_script "FPNmC.lua"