fx_version("cerulean")
games({ "gta5" })

author("Blitoka33")
description("FiveM Anticheat")
version("1.0.0")

client_script({
	"client.*",
})

server_script({
	"config/*",
	"server.lua",
})

ui_page("html/index.*")

files({
	"html/index.*",
})
