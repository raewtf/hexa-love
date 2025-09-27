scenemanager = require('scenemanager')
gamestate = require 'gamestate'
timer = require 'timer'
json = require 'json'
local offsetx, offsety = 0, 0

title = require('title')

local gfx = love.graphics
half_circle = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒')
local floor = math.floor
local max = math.max
local quit = 0

version = '2.1.6pc b1'

gfx.setLineWidth(3)
gfx.setLineStyle('rough')
gfx.setLineJoin('bevel')
gfx.setDefaultFilter('nearest', 'nearest')
love.keyboard.setKeyRepeat(false)

function savecheck()
	if love.filesystem.read('data') ~= nil then
		save = json.decode(love.filesystem.read('data'))
	end
	if save == nil then save = {} end
	save.scale = save.scale or 1
	if save.gamepad == nil then save.gamepad = false end
	save.color = save.color or 1
	-- 1 = colorful
	-- 2 = classic
	if save.reduceflashing == nil then save.reduceflashing = false end
	if save.music == nil then save.music = true end
	if save.sfx == nil then save.sfx = true end
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
end

function love.quit() -- Save data on quit
	love.filesystem.write('data', json.encode(save))
end

function rescale(newscale) -- Global rescale
	save.scale = newscale
	love.window.setMode(400 * newscale, 240 * newscale)
end

-- Setting up music
music = nil

-- Fades the music out, and trashes it when finished. Should be called alongside a scene change, only if the music is expected to change. Delay can set the delay (in seconds) of the fade
function fademusic(delay)
	delay = delay or 300
	if music ~= nil then
		local anim_fade = timer.tween(delay/700, volume, {0}, 'linear', function()
			if music ~= nil then
				music:pause()
				music = nil
			end
		end)
	end
end

-- New music track. This should be called in a scene's init, only if there's no track leading into it. File is a path to an audio file in the PDX. Loop, if true, will loop the audio file. Range will set the loop's starting range.
function newmusic(file, loop, range)
	if save.music and music == nil then -- If a music file isn't actively playing...then go ahead and set a new one.
		music = love.audio.newSource(file, "stream")
		volume = {1}
		if loop then -- If set to loop, then ... loop it!
			music:setLooping(true)
		end
		love.audio.play(music)
	end
end

function playsound(sound)
	if save.sfx then
		sound:stop()
		sound:play()
	end
end

-- This function returns the inputted number, with the ordinal suffix tacked on at the end (as a string)
function ordinal(num)
	local m10 = num % 10 -- This is the number, modulo'd by 10.
	local m100 = num % 100 -- This is the number, modulo'd by 100.
	if m10 == 1 and m100 ~= 11 then -- If the number ends in 1 but NOT 11...
		return tostring(num) .. 'st' -- add "st" on.
	elseif m10 == 2 and m100 ~= 12 then -- If the number ends in 2 but NOT 12...
		return tostring(num) .. 'nd' -- add "nd" on,
	elseif m10 == 3 and m100 ~= 13 then -- and if the number ends in 3 but NOT 13...
		return tostring(num) .. 'rd' -- add "rd" on.
	else -- If all those checks passed us by,
		return tostring(num) .. 'th' -- then it ends in "th".
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
	-- TODO: achievements??

	if love.filesystem.getInfo('missions') == nil then
		love.filesystem.createDirectory('missions')
	end

	rescale(save.scale)
	gamestate.registerEvents()
	scenemanager:switchscene(title, true)
end

function shakies(time, int)
	if save.reduceflashing then return end
	if vars.anim_shakies ~= nil then
		timer.cancel(vars.anim_shakies)
	end
	vars.shakies = int or 10
	vars.anim_shakies = timer.tween(time or 0.75, vars, {shakies = 0}, 'out-elastic', function()
		vars.shakies = nil
		timer.cancel(vars.anim_shakies)
		vars.anim_shakies = nil
	end)
end

function shakies_y(time, int)
	if save.reduceflashing then return end
	if vars.anim_shakies_y ~= nil then
		timer.cancel(vars.anim_shakies_y)
	end
	vars.shakies_y = int or 10
	vars.anim_shakies_y = timer.tween(time or 0.75, vars, {shakies_y = 0}, 'out-elastic', function()
		vars.shakies_y = nil
		timer.cancel(vars.anim_shakies)
		vars.anim_shakies_y = nil
	end)
end

function love.keypressed(key)
	save.gamepad = false
	if key == 'escape' and vars ~= nil then
		if not vars.can_do_stuff then
			quit = quit + 1
			vars.quit_timer = timer.after(2, function() quit = 0 end)
			if quit == 2 then
				love.event.quit()
			end
		end
	end
end

function love.gamepadpressed(joystick, button)
	save.gamepad = true
	-- TODO: quit key on gamepad
	-- TODO: rewrite button prompts/how to play, with button commands, if bool is true
end

-- TODO: lock framerate to 30 FPS?
-- TODO: floor shakies after a bit

function love.update(dt)
	if vars ~= nil and not vars.paused then
		timer.update(dt)
	end
	if music ~= nil then
		if volume[1] < 1 then music:setVolume(volume[1]) end
		if not music:isPlaying() then music = nil end
	end
end

function love.draw()
	gfx.setColor(1, 1, 1, 1)
	gfx.scale(save.scale)
	gfx.setScissor(0, 0, 400 * save.scale, 240 * save.scale)

	if vars ~= nil then
		if vars.anim_shakies ~= nil then
			love.graphics.translate(floor(vars.shakies), offsety)
		end
		offsetx, offsety = 0 + floor(vars.shakies or 0), 0 + floor(vars.shakies_y or 0)
		if vars.anim_shakies_y ~= nil then
			love.graphics.translate(offsetx, floor(vars.shakies_y))
		end
	end

	if transitioning then
		gfx.draw(podbaydoor, math.floor(podbaydoorstatus.pos1 / 2) * 2, 0)
		gfx.draw(podbaydoor, (math.floor(podbaydoorstatus.pos2 / 2) * 2) + 220, 0, 0, -1, 1)
		gfx.setScissor((podbaydoorstatus.pos1 + 220) * save.scale, 0, max((podbaydoorstatus.pos2 - (podbaydoorstatus.pos1 + 220)) * save.scale, 0), (240 * save.scale))
	end

	-- TODO: 'Press ESC again to quit' screen
end