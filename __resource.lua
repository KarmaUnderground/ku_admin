resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Karma Underground Administration'

version '0.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',

	'config.lua',

	'locales/en.lua',
	'locales/fr.lua',

	'server/callbacks.lua',
	'server/main.lua',

	'ui/tabs/players/server.lua',
}

client_scripts {
	'@es_extended/locale.lua',

	'config.lua',

	'locales/en.lua',
	'locales/fr.lua',

	'client/callbacks.lua',
	'client/main.lua',

	'ui/tabs/players/client.lua',
}

ui_page {
    'ui/index.html'
}

files({
	'ui/index.html',
	'ui/index.js',
	'ui/index.css',
	
	-- jQuery
	'ui/vendor/jquery/jquery-3.3.1.min.js',
	'ui/vendor/jquery/jquery-ui.min.js',

	'ui/vendor/jquery/jquery-ui.min.css',
	'ui/vendor/jquery/jquery-ui.structure.min.css',
	'ui/vendor/jquery/jquery-ui.theme.min.css',

	-- Bootstrap
	'ui/vendor/bootstrap/bootstrap.min.js',
	'ui/vendor/bootstrap/popper.min.js',

	'ui/vendor/bootstrap/bootstrap.min.css',

	-- Iconic
	'ui/vendor/iconic/css/open-iconic-bootstrap.min.css',

	'ui/vendor/iconic/fonts/open-iconic.eot',
	'ui/vendor/iconic/fonts/open-iconic.otf',
	'ui/vendor/iconic/fonts/open-iconic.svg',
	'ui/vendor/iconic/fonts/open-iconic.ttf',
	'ui/vendor/iconic/fonts/open-iconic.woff',

	-- Animate
	'ui/vendor/animate/animate.css',

	-- Underscore
	'ui/vendor/underscore/underscore.min.js',
})

dependencies {

}
