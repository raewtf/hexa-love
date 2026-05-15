return {
	{
		name = 'HEXA',
		developer = 'rae',
		version = '2.3.1',
		love = '11.5',
		icon = 'images/1/icon.png',
		ignore = {'versions', '.gitignore', '.git', '.nova', 'steam_appid.txt', 'richpresence.json', 'windows/luasteam.dll', 'windows/steam_api64.dll', 'macos/luasteam.so', 'macos/libsteam_api.dylib', 'linux/libsteam_api.so', 'linux/luasteam.so'},
		platforms = {'windows', 'macos', 'steamdeck'},
		libs = {
			windows = {'windows/luasteam.dll', 'windows/steam_api64.dll'},
			macos = {'macos/luasteam.so', 'macos/libsteam_api.dylib'},
			steamdeck = {'linux/luasteam.so', 'linux/libsteam_api.so'},
		},
		identifier = 'wtf.rae.hexa',
	},
}