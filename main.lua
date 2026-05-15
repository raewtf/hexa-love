-- so the dang thingy can load right
local windows = package.config:sub(1, 1) == '\\'
package.cpath = string.format("%s;%s/?.%s", package.cpath, love.filesystem.getSourceBaseDirectory(), (windows and 'dll' or 'so'))

local sysos = love.system.getOS()
if sysos == 'Linux' then
	package.cpath = love.filesystem.getSourceBaseDirectory() .. '/windows/?.dll;' .. package.cpath
	local ok, mod = pcall(require, 'luasteam')
	if not ok then mod = nil end
	if mod then
		steam = require('luasteam')
		issteam = steam.init()
	else
		steam = nil
		issteam = false
	end
elseif sysos == 'Windows' then
	package.cpath = love.filesystem.getSourceBaseDirectory() .. '/linux/?.so;' .. package.cpath
	local ok, mod = pcall(require, 'luasteam')
	if not ok then mod = nil end
	if mod then
		steam = require('luasteam')
		issteam = steam.init()
	else
		steam = nil
		issteam = false
	end
elseif sysos == 'OS X' then
	package.cpath = love.filesystem.getSourceBaseDirectory() .. '/macos/?.so;' .. package.cpath
	local ok, mod = pcall(require, 'luasteam')
	if not ok then mod = nil end
	if mod then
		steam = require('luasteam')
		issteam = steam.init()
	else
		steam = nil
		issteam = false
	end
else
	steam = nil
	issteam = false
end

if issteam then
	lang = steam.apps.getCurrentGameLanguage()

	function steam.friends.onGameOverlayActivated(a)
		if a then
			if vars ~= nil and (vars.handler == 'game' and not vars.paused) then
				vars.autopause = true
				vars.pause_selections = {'continue'}
				if vars.mode == 'arcade' and vars.can_do_stuff then table.insert(vars.pause_selections, 'restart') end
				table.insert(vars.pause_selections, 'quit')
				vars.paused = true
				vars.handler = 'pause'
				vars.pause_selection = 1
				playsound(assets.sfx_move)
				if music ~= nil then volume = {(save.music / 5) * 0.3} end
			end
		end
	end
end

langs = require 'langs'
function getLocalizedText(key)
	local data
	if save.lang == 'en' then
		data = langs.en
	elseif save.lang == 'fr' then
		data = langs.fr
	elseif save.lang == 'jp' then
		data = langs.jp
	elseif save.lang == 'system' and lang ~= nil then
		if lang == 'english' then
			data = langs.en
		elseif lang == 'french' then
			data = langs.fr
		elseif lang == 'japanese' then
			data = langs.jp
		else
			-- fall back to english
			data = langs.en
		end
	else
		-- fall back to english
		data = langs.en
	end
	return data and data[key] or key
end

scenemanager = require('scenemanager')
gamestate = require 'gamestate'

timer = require 'timer'
easings = require 'easing'

require 'raetimers'
require 'xor'

json = require 'json'
local offsetx, offsety = 0, 0

title = require('title')
langselect = require('langselect')

local gfx = love.graphics
local gamepad = false
local floor = math.floor
local max = math.max
local scale

-- for the sticks
lstick_up = false
lstick_down = false
lstick_left = false
lstick_right = false

version = '2.3.1'

gfx.setLineWidth(3)
gfx.setLineStyle('rough')
gfx.setLineJoin('miter')
gfx.setDefaultFilter('nearest', 'nearest')
love.keyboard.setKeyRepeat(false)

hexaplex_blacks = {
	{love.math.colorFromBytes(29, 43, 83, 255)},
	{love.math.colorFromBytes(41, 173, 255, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
	{love.math.colorFromBytes(0, 0, 0, 255)},
	{love.math.colorFromBytes(0, 135, 81, 255)},
	{love.math.colorFromBytes(41, 173, 255, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
	{love.math.colorFromBytes(29, 43, 83, 255)},
	{love.math.colorFromBytes(29, 43, 83, 255)},
	{love.math.colorFromBytes(0, 0, 0, 255)},
	{love.math.colorFromBytes(41, 173, 255, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
	{love.math.colorFromBytes(126, 37, 83, 255)},
	{love.math.colorFromBytes(0, 0, 0, 255)},
	{love.math.colorFromBytes(126, 37, 83, 255)},
	{love.math.colorFromBytes(171, 82, 54, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
	{love.math.colorFromBytes(41, 173, 255, 255)},
	{love.math.colorFromBytes(29, 43, 83, 255)},
	{love.math.colorFromBytes(0, 135, 81, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
	{love.math.colorFromBytes(171, 82, 54, 255)},
	{love.math.colorFromBytes(0, 135, 81, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
	{love.math.colorFromBytes(171, 82, 54, 255)},
	{love.math.colorFromBytes(255, 0, 77, 255)},
}

hexaplex_gray1s = {
	{love.math.colorFromBytes(129, 118, 153, 255)},
	{love.math.colorFromBytes(234, 51, 82, 255)},
	{love.math.colorFromBytes(59, 133, 86, 255)},
	{love.math.colorFromBytes(94, 87, 80, 255)},
	{love.math.colorFromBytes(59, 133, 86, 255)},
	{love.math.colorFromBytes(238, 127, 167, 255)},
	{love.math.colorFromBytes(234, 51, 82, 255)},
	{love.math.colorFromBytes(32, 43, 80, 255)},
	{love.math.colorFromBytes(59, 133, 86, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(86, 171, 248, 255)},
	{love.math.colorFromBytes(238, 127, 167, 255)},
	{love.math.colorFromBytes(160, 87, 61, 255)},
	{love.math.colorFromBytes(116, 44, 82, 255)},
	{love.math.colorFromBytes(234, 51, 82, 255)},
	{love.math.colorFromBytes(234, 51, 82, 255)},
	{love.math.colorFromBytes(59, 133, 86, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(94, 87, 80, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(238, 127, 167, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(86, 171, 248, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(234, 51, 82, 255)},
	{love.math.colorFromBytes(104, 255, 84, 255)},
}

hexaplex_gray2s = {
	{love.math.colorFromBytes(194, 195, 199, 255)},
	{love.math.colorFromBytes(238, 127, 167, 255)},
	{love.math.colorFromBytes(104, 225, 84, 255)},
	{love.math.colorFromBytes(129, 118, 153, 255)},
	{love.math.colorFromBytes(104, 225, 84, 255)},
	{love.math.colorFromBytes(253, 241, 233, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(86, 171, 248, 255)},
	{love.math.colorFromBytes(104, 225, 84, 255)},
	{love.math.colorFromBytes(252, 237, 87, 255)},
	{love.math.colorFromBytes(253, 241, 233, 255)},
	{love.math.colorFromBytes(253, 241, 233, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(234, 51, 82, 255)},
	{love.math.colorFromBytes(238, 127, 167, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(104, 225, 84, 255)},
	{love.math.colorFromBytes(252, 237, 87, 255)},
	{love.math.colorFromBytes(129, 118, 153, 255)},
	{love.math.colorFromBytes(247, 206, 175, 255)},
	{love.math.colorFromBytes(253, 241, 223, 255)},
	{love.math.colorFromBytes(247, 206, 175, 255)},
	{love.math.colorFromBytes(253, 241, 233, 255)},
	{love.math.colorFromBytes(247, 206, 175, 255)},
	{love.math.colorFromBytes(242, 167, 59, 255)},
	{love.math.colorFromBytes(252, 237, 87, 255)},
}

hexaplex_whites = {
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(41, 173, 255, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 204, 170, 255)},
	{love.math.colorFromBytes(255, 119, 168, 255)},
	{love.math.colorFromBytes(0, 228, 54, 255)},
	{love.math.colorFromBytes(255, 163, 0, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(194, 195, 199, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
	{love.math.colorFromBytes(255, 236, 39, 255)},
	{love.math.colorFromBytes(255, 241, 232, 255)},
}

local full_circle = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0)
local half_circle = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0)
local text
icon_color = love.image.newImageData('images/2/icon.png')
icon_peedee = love.image.newImageData('images/1/icon.png')

function savecheck()
	-- old save file check
	if love.filesystem.read('data') ~= nil then
		save = json.decode(love.filesystem.read('data'))
		love.filesystem.write('data.json', json.encode(save))
		love.filesystem.remove('data')
	end

	if love.filesystem.read('data.json') ~= nil then
		save = json.decode(love.filesystem.read('data.json'))
	end
	if save == nil then save = {} end
	save.scale = save.scale or 2
	if save.fullscreen == nil then save.fullscreen = true end
	if save.gamepad == nil then save.gamepad = false end

	if save.keyboard ~= nil then
		if save.keyboard == 1 then
			save.up = 'up'
			save.down = 'down'
			save.left = 'left'
			save.right = 'right'
			save.primary = 'z'
			save.secondary = 'x'
			save.tertiary = 'j'
			save.quaternary = 'c'
		elseif save.keyboard == 2 then
			save.up = 'w'
			save.down = 's'
			save.left = 'a'
			save.right = 'd'
			save.primary = ','
			save.secondary = '.'
			save.tertiary = 'j'
			save.quaternary = 'c'
		end
		save.keyboard = nil
	else
		save.up = save.up or 'up'
		save.down = save.down or 'down'
		save.left = save.left or 'left'
		save.right = save.right or 'right'
		save.primary = save.primary or 'z'
		save.secondary = save.secondary or 'x'
		save.tertiary = save.tertiary or 'j'
		save.quaternary = save.quaternary or 'c'
	end

	save.color = save.color or 1
	-- 1 = colorful
	-- 2 = classic
	save.hexaplex_color = save.hexaplex_color or 1
	if save.clean_scaling == nil then save.clean_scaling = true end
	if save.rumble == nil then save.rumble = true end
	if save.reduceflashing == nil then save.reduceflashing = false end

	if save.music ~= nil then
		if type(save.music) == 'boolean' then
			if save.music then
				save.music = 3
			else
				save.music = 0
			end
		end
	else
		save.music = 3
	end
	if save.sfx ~= nil then
		if type(save.sfx) == 'boolean' then
			if save.sfx then
				save.sfx = 3
			else
				save.sfx = 0
			end
		end
	else
		save.sfx = 3
	end

	if save.lang == nil then save.lang = 'system' end
	if save.flip == nil then save.flip = false end
	if save.skipfanfare == nil then save.skipfanfare = false end
	if save.lastdaily == nil then save.lastdaily = {} end
	save.lastdaily.year = save.lastdaily.year or 0
	save.lastdaily.month = save.lastdaily.month or 0
	save.lastdaily.day = save.lastdaily.day or 0
	save.lastdaily.score = save.lastdaily.score or 0
	if save.lastdaily.sent == nil then save.lastdaily.sent = false end
	save.score = save.score or 0
	save.hard_score = save.hard_score or 0
	save.swaps = save.swaps or 0
	save.hexas = save.hexas or 0
	save.highest_mission = save.highest_mission or 1
	save.lbs_lastmode = save.lbs_lastmode or 'arcade'
	if save.mission_bests == nil then save.mission_bests = {} end
	if save.author_name == nil then save.author_name = '' end
	if save.hardmode == nil then save.hardmode = false end
	if save.exported_mission == nil then save.exported_mission = false end
	for i = 1, 50 do
		if save.mission_bests['mission' .. i] == nil then
			save.mission_bests['mission' .. i] = 0
		end
	end
	for i = 1, #save.mission_bests do
		save.mission_bests[i] = save.mission_bests[i] or 0
	end
	save.playtime = save.playtime or 0
	save.gametime = save.gametime or 0
	save.total_score = save.total_score or 0
	save.black_match = save.black_match or 0
	save.gray_match = save.gray_match or 0
	save.white_match = save.white_match or 0
	save.double_match = save.double_match or 0
	save.bomb_match = save.bomb_match or 0
	save.wild_match = save.wild_match or 0
end

function checklanguage()
	if save.lang == 'en' then
		return 'en'
	elseif save.lang == 'fr' then
		return 'fr'
	elseif save.lang == 'jp' then
		return 'jp'
	elseif save.lang == 'system' and lang ~= nil then
		if lang == 'english' then
			return 'en'
		elseif lang == 'french' then
			return 'fr'
		elseif lang == 'japanese' then
			return 'jp'
		else
			return nil
		end
	else
		return nil
	end
end

function updatecheevos(mission50)
	if issteam then
		steam.userStats.requestCurrentStats()
		local gotscore, score = steam.userStats.getStatInt('score')
		if gotscore then
			if score >= 1000 then steam.userStats.setAchievement('arcade1000') end
			if score >= 5000 then steam.userStats.setAchievement('arcade5000') end
			if score >= 10000 then steam.userStats.setAchievement('arcade10000') end
			if score >= 25000 then steam.userStats.setAchievement('arcade25000') end
		end
		local gothighest_mission, highest_mission = steam.userStats.getStatInt('highest_mission')
		if gothighest_mission then
			if highest_mission >= 1 then steam.userStats.setAchievement('mission1') end
		end
		if mission50 then steam.userStats.setAchievement('mission50') end
		local gotswaps, swaps = steam.userStats.getStatInt('swaps')
		if gotswaps then
			if swaps >= 1000 then steam.userStats.setAchievement('swaps1000') end
			if swaps >= 2500 then steam.userStats.setAchievement('swaps2500') end
			if swaps >= 5000 then steam.userStats.setAchievement('swaps5000') end
			if swaps >= 10000 then steam.userStats.setAchievement('swaps10000') end
		end
		local gothexas, hexas = steam.userStats.getStatInt('hexas')
		if gothexas then
			if hexas >= 250 then steam.userStats.setAchievement('hexas250') end
			if hexas >= 500 then steam.userStats.setAchievement('hexas500') end
			if hexas >= 1000 then steam.userStats.setAchievement('hexas1000') end
			if hexas >= 2500 then steam.userStats.setAchievement('hexas2500') end
		end
		if save.lastdaily ~= nil and (save.lastdaily.score ~= nil and save.lastdaily.score > 0) then steam.userStats.setAchievement('daily') end
		if save.exported_mission then steam.userStats.setAchievement('missioncommand') end
		steam.userStats.storeStats()
	end
end

function updatestat(stat, value)
	if issteam then
		steam.userStats.requestCurrentStats()
		if stat == 'highest_mission' then
			steam.userStats.setStatInt(stat, value - 1)
		else
			steam.userStats.setStatInt(stat, value)
		end
		steam.userStats.storeStats()
		save[stat] = value
	end
end

function setrichpresence(key, value)
	if issteam then
		steam.friends.setRichPresence(key, value)
	end
end

function love.quit() -- Save data on quit
	if issteam then
		steam.shutdown()
	end
	love.filesystem.write('data.json', json.encode(save))
end

function rescale(newscale) -- Global rescale
	if not save.fullscreen then
		scale = newscale
		love.window.updateMode(400 * newscale, 240 * newscale, {minwidth = 400 * newscale, minheight = 240 * newscale, fullscreen = false})
	end
end

-- Setting up music
music = nil

-- Fades the music out, and trashes it when finished. Should be called alongside a scene change, only if the music is expected to change. Delay can set the delay (in seconds) of the fade
function fademusic(delay)
	delay = delay or 300
	if music ~= nil then
		musicfade = timer.tween(delay / 700, {
			[volume] = {[1] = 0}
		})
			:finish(function()
				if music ~= nil then love.audio.stop(music) end
			end)
			:group(transition)
	end
end

-- New music track. This should be called in a scene's init, only if there's no track leading into it. File is a path to an audio file in the PDX. Loop, if true, will loop the audio file. Range will set the loop's starting range.
function newmusic(file, loop, range)
	if save.music > 0 and music == nil then -- If a music file isn't actively playing...then go ahead and set a new one.
		music = love.audio.newSource(file, "stream")
		music:setVolume(save.music / 5)
		volume = {save.music / 5}
		if loop then -- If set to loop, then ... loop it!
			music:setLooping(true)
		end
		love.audio.play(music)
	end
end

function playsound(sound)
	if save.sfx > 0 and sound ~= nil then
		sound:stop()
		sound:setVolume(save.sfx / 5)
		sound:play()
	end
end

-- This function returns the inputted number, with the ordinal suffix tacked on at the end (as a string)
function ordinal(num)
	local m10 = num % 10 -- This is the number, modulo'd by 10.
	local m100 = num % 100 -- This is the number, modulo'd by 100.
	if m10 == 1 and m100 ~= 11 then -- If the number ends in 1 but NOT 11...
		return tostring(num) .. text('st') -- add "st" on.
	elseif m10 == 2 and m100 ~= 12 then -- If the number ends in 2 but NOT 12...
		return tostring(num) .. text('nd') -- add "nd" on,
	elseif m10 == 3 and m100 ~= 13 then -- and if the number ends in 3 but NOT 13...
		return tostring(num) .. text('rd') -- add "rd" on.
	else -- If all those checks passed us by,
		return tostring(num) .. text('th') -- then it ends in "th".
	end
end

-- http://lua-users.org/wiki/FormattingNumbers
function commalize(amount)
  local formatted = amount
  while true do
	formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	if (k==0) then
	  break
	end
  end
  return formatted
end

function start(string)
	return (string:gsub("^%l", string.upper))
end

-- http://lua-users.org/wiki/CopyTable
-- Save copied tables in `copies`, indexed by original table.
function deepcopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
			end
			setmetatable(copy, deepcopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- This function takes a score number as input, and spits out the proper time in minutes, seconds, and milliseconds
function timecalc(num)
	local mins = math.floor((num/30) / 60)
	local secs = math.floor((num/30) - mins * 60)
	local mils = math.floor((num/30)*99 - mins * 5940 - secs * 99)
	if secs < 10 then secs = '0' .. secs end
	if mils < 10 then mils = '0' .. mils end
	return mins, secs, mils
end

function timecalchour(num)
	local hours = math.floor((num/30) / 3600)
	local mins = math.floor((num/30) / 60 - (hours * 60))
	local secs = math.floor((num/30) - (hours * 3600) - (mins * 60))
	return hours, mins, secs
end

-- https://love2d.org/wiki/Tutorial:Animation
function newAnimation(image, width, height, duration)
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end

	animation.duration = duration or 1
	animation.currentTime = 0

	return animation
end

function love.load()
	savecheck()
	love.window.setIcon((save.color == 2 and icon_color or icon_peedee))
	text = getLocalizedText

	if love.filesystem.getInfo('missions') == nil then
		love.filesystem.createDirectory('missions')
	end

	min_dt = 1/30
	next_time = love.timer.getTime()

	scale = save.scale

	love.window.setFullscreen(save.fullscreen)
	if not save.fullscreen then
		love.window.setMode(400 * scale, 240 * scale, {resizable = true, minwidth = 400 * scale, minheight = 240 * scale})
	end

	gamestate.registerEvents()

	if checklanguage() == nil then
		scenemanager:switchscene(langselect)
	else
		scenemanager:switchscene(title, true, 'arcade')
	end
end

function shakies(time, int)
	if time == nil then time = 0.5 end
	if int == nil then int = 20 end
	if save.reduceflashing then return end
	newtimer('shakies', time * 1000, -int, 0, 'outElastic')
end

function shakies_y(time, int)
	if time == nil then time = 0.75 end
	if int == nil then int = 20 end
	if save.reduceflashing then return end
	newtimer('shakies_y', time * 1000, -int, 0, 'outElastic')
end

function love.keypressed(key)
	save.gamepad = gamepad
	gamepad = false
	if vars ~= nil and vars.sequence ~= nil and vars.sequenceindex ~= nil then
		if vars.sequence[vars.sequenceindex] == key then
			vars.sequenceindex = vars.sequenceindex + 1
		else
			vars.sequenceindex = 1
		end
	end
	if key == 'escape' and vars ~= nil and vars.handler == 'remap' then
		options:restorebuttons()
		playsound(assets.sfx_back)
		vars.remap_step = 1
		vars.handler = 'options'
		love.filesystem.write('data.json', json.encode(save))
	end
	if key == 'f11' then
		save.fullscreen = not save.fullscreen
		love.window.setFullscreen(save.fullscreen)
		if not save.fullscreen and scale ~= save.scale then rescale(save.scale) end
	end
end

function love.keyreleased(key)
	save.gamepad = gamepad
	gamepad = false
end

function love.gamepadpressed(joystick, button)
	current_joystick = joystick
	current_vendor = joystick:getDeviceInfo()
	local key = ''
	if button == 'start' then
		key = 'escape'
	end
	if vars.handler ~= "remap" then
		if button == 'x' then
			key = save.tertiary
		elseif button == 'y' then
			key = save.quaternary
		elseif button == 'dpup' then
			key = save.up
		elseif button == 'dpdown' then
			key = save.down
		elseif button == 'dpleft' then
			key = save.left
		elseif button == 'dpright' then
			key = save.right
		elseif button == 'a' then
			key = save.primary
		elseif button == 'b' then
			key = save.secondary
		end
	end
	if key ~= '' then
		gamepad = true
		love.keypressed(key)
	end
end

function love.gamepadreleased(joystick, button)
	current_joystick = joystick
	current_vendor = joystick:getDeviceInfo()
	local key = ''
	if button == 'start' then
		key = 'escape'
	end
	if vars.handler ~= 'remap' then
		if button == 'back' then
			key = 'r'
		elseif button == 'dpup' then
			key = save.up
		elseif button == 'dpdown' then
			key = save.down
		elseif button == 'dpleft' then
			key = save.left
		elseif button == 'dpright' then
			key = save.right
		elseif button == 'a' then
			key = save.primary
		elseif button == 'b' then
			key = save.secondary
		end
	end
	if key ~= '' then
		gamepad = true
		love.keyreleased(key)
	end
end

function love.gamepadaxis(joystick, axis, value)
	if vars.handler ~= 'remap' then
		local pressedkey = ''
		local releasedkey = ''
		if axis == 'lefty' and not (lstick_left or lstick_right) then
			if value > 0.5 then
				if not lstick_down then
					pressedkey = save.down
				end
				lstick_down = true
			else
				if lstick_down then
					releasedkey = save.down
				end
				lstick_down = false
			end
			if value < -0.5 then
				if not lstick_up then
					pressedkey = save.up
				end
				lstick_up = true
			else
				if lstick_up then
					releasedkey = save.up
				end
				lstick_up = false
			end
		elseif axis == 'leftx' and not (lstick_down or lstick_up) then
			if value > 0.5 then
				if not lstick_right then
					pressedkey = save.right
				end
				lstick_right = true
			else
				if lstick_right then
					releasedkey = save.right
				end
				lstick_right = false
			end
			if value < -0.5 then
				if not lstick_left then
					pressedkey = save.left
				end
				lstick_left = true
			else
				if lstick_left then
					releasedkey = save.left
				end
				lstick_left = false
			end
		end
		if pressedkey ~= '' then
			gamepad = true
			current_joystick = joystick
			love.keypressed(pressedkey)
		end
		if releasedkey ~= '' then
			gamepad = true
			current_joystick = joystick
			love.keyreleased(releasedkey)
		end
	end
end

function love.joystickremoved()
	if vars ~= nil and (vars.handler == 'game' and not vars.paused) then
		vars.autopause = true
		vars.pause_selections = {'continue'}
		if vars.mode == 'arcade' and vars.can_do_stuff then table.insert(vars.pause_selections, 'restart') end
		table.insert(vars.pause_selections, 'quit')
		vars.paused = true
		vars.handler = 'pause'
		vars.pause_selection = 1
		playsound(assets.sfx_move)
		if music ~= nil then volume = {(save.music / 5) * 0.3} end
	end
end

function rumble(left, right, duration)
	if save.rumble and save.gamepad and current_joystick:isVibrationSupported() then
		current_joystick:setVibration(left, right, duration)
	end
end

function love.update(dt)
	next_time = next_time + min_dt

	if issteam then
		steam.runCallbacks()
	end

	save.playtime = save.playtime + 1

	local time = os.date('!*t')

	if vars ~= nil and not vars.paused then
		timer.update(dt, transition)
		timer.update(dt)
	end

	if (save.lastdaily.score ~= 0) and not (save.lastdaily.year == time.year and save.lastdaily.month == time.month and save.lastdaily.day == time.day) then
	  	save.lastdaily.score = 0
	 	save.lastdaily.sent = false
	end

	if music ~= nil then
		music:setVolume(volume[1])
		if not music:isPlaying() then music = nil end
	end
end

function love.draw()
	gfx.setColor(1, 1, 1, 1)

	local lbw = false
	local lbh = false

	local ww, wh, flags = love.window.getMode()
	if ww > 400 * scale then lbw = true end
	if wh > 240 * scale then lbh = true end

	if lbw then gfx.translate(((floor(ww / 2) * 2) - (400 * scale)) / 2, 0) end
	if lbh then gfx.translate(0, ((floor(wh / 2) * 2) - (240 * scale)) / 2) end

	gfx.setScissor(((lbw and (((floor(ww / 2) * 2) - (400 * scale)) / 2)) or 0) + (vars.anim_shakies ~= nil and (floor(vars.shakies) * scale) or 0), ((lbh and (((floor(wh / 2) * 2) - (240 * scale)) / 2)) or 0) + (vars.anim_shakies_y ~= nil and (floor(vars.shakies_y) * scale) or 0), 400 * scale, 240 * scale)

	gfx.scale(scale)

	if vars ~= nil then
		if vars.shakies ~= nil then
			gfx.translate(floor(value('shakies') / 2) * 2, 0)
		end
		if vars.shakies_y ~= nil then
			gfx.translate(0, floor(value('shakies_y') / 2) * 2)
		end
	end
end

function love.focus(f)
	if f then
		love.mouse.setVisible(false)
	else
		love.mouse.setVisible(true)
		if vars ~= nil and (vars.handler == 'game' and not vars.paused) then
			vars.autopause = true
			vars.pause_selections = {'continue'}
			if vars.mode == 'arcade' and vars.can_do_stuff then table.insert(vars.pause_selections, 'restart') end
			table.insert(vars.pause_selections, 'quit')
			vars.paused = true
			vars.handler = 'pause'
			vars.pause_selection = 1
			playsound(assets.sfx_move)
			if music ~= nil then volume = {(save.music / 5) * 0.3} end
		end
	end
end

function love.resize(w, h)
	local fw
	local fh
	if save.clean_scaling then
		fw = floor(w / 400)
		fh = floor(h / 240)
	else
		fw = w / 400
		fh = h / 240
	end
	if fw < fh and fw >= save.scale then
		scale = fw
	elseif fh < fw and fh >= save.scale then
		scale = fh
	elseif fw == fh and fw >= save.scale then
		scale = fw
	end
end

function draw_on_top()
	gfx.setColor(1, 1, 1, 1)

	if transitioning and vars.transition ~= nil then
		gfx.draw(podbaydoor, math.floor(((value('transition') * 200) - 219) / 2) * 2, 0)
		gfx.draw(podbaydoor, (math.floor((-(value('transition') * 200) + 398) / 2) * 2) + 220, 0, 0, -1, 1)
	end

	gfx.setScissor()

	local cur_time = love.timer.getTime()
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(next_time - cur_time)
end