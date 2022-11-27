fx_version 'cerulean'
games { 'gta5' }

author 'MoneSuper#0001'
description 'Serrulata-Studios'
repository 'https://github.com/Serrulata-Studios/Serrulata-rental'
license 'GNU General Public License v3.0'
version '1.0.0'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'locales/en.lua',
	'locales/*.lua',
	'config.lua'
}
client_scripts {
  'client/cl_*.lua',
}

server_scripts {
  'config.lua',
  'server/sv_*.lua',
}
lua54 'yes'