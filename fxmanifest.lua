fx_version("cerulean")
games({ "gta5" })

author("Blitoka33")
description("FiveM Anticheat")
version("1.0.0")

client_script({
	"client.lua",
})

server_script({
	"config/serverconfig.lua",
	"config/webhookconfig.lua",
	"config/clientconfig.lua",
	"server.lua",
})

ui_page("html/index.html")

files({
	"html/index.html",
})
