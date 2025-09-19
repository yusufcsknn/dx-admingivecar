fx_version 'cerulean'
game 'gta5'

author 'DX Development'
description 'DX Admin Give Car'
version '1.0.0'

shared_script '@es_extended/imports.lua'

shared_script 'config.lua'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'config.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}
