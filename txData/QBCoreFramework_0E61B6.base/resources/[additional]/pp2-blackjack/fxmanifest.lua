fx_version 'cerulean'
game 'gta5'

author 'PassPar2'

description 'pp2-blackjack'
version '1.0.0'

shared_scripts {
  'locales/en.lua',
  'config/config.lua'
}

server_script {
  'server/server.lua'
}

client_scripts {
  'client/client.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/blackjack.js',
	'html/img/*.png',
	'html/deck/*.png',
	'html/dist/*.js',
	'html/dist/*.css',
}

lua54 'yes'
