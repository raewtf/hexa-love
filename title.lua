game = require('game')
missions = require('missions')
statistics = require('statistics')
howtoplay = require('howtoplay')
options = require('options')
credits = require('credits')
jukebox = require('jukebox')

local gfx = love.graphics
local floor = math.floor
local title = {}

function title:enter(current, ...)
	love.window.setTitle('HEXA')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		title = gfx.newImage('images/' .. tostring(save.color) .. '/title.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		logo = gfx.newImage('images/' .. tostring(save.color) .. '/logo.png'),
		half = gfx.newImage('images/half.png'),
		half_1x = gfx.newImage('images/half_1x.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		modal_small = gfx.newImage('images/' .. tostring(save.color) .. '/modal_small.png'),
	}

	vars = {
		animate = args[1],
		default = args[2],
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		dailyrunnable = false,
		waiting = true,
		selection = 0,
		handler = 'title',
		selections = {'arcade', 'zen', 'dailyrun', 'missions', 'statistics', 'howtoplay', 'options', 'credits', 'quit'},
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
		if vars.default ~= nil then
			for i = 1, #vars.selections do
				if vars.selections[i] == vars.default then
					vars.selection = i
				end
			end
		end
		if vars.selection == 0 then
			vars.selection = 1
		end
	end)

	vars.anim_sx = timer.tween(4, vars, {sx = -399})
	vars.anim_sy = timer.tween(2.75, vars, {sy = -239})
	vars.anim_lx = timer.tween(2.5, vars, {lx = -399})
	vars.anim_ly = timer.tween(1.25, vars, {ly = -239})
	vars.anim_sx_loop = timer.every(4, function()
		vars.sx = 0
		vars.anim_sx = timer.tween(4, vars, {sx = -399})
	end)
	vars.anim_sy_loop = timer.every(2.75, function()
		vars.sy = 0
		vars.anim_sy = timer.tween(2.75, vars, {sy = -239})
	end)
	vars.anim_lx_loop = timer.every(2.5, function()
		vars.lx = 0
		vars.anim_lx = timer.tween(2.5, vars, {lx = -399})
	end)
	vars.anim_ly_loop = timer.every(1.25, function()
		vars.ly = 0
		vars.anim_ly = timer.tween(1.25, vars, {ly = -239})
	end)

	if vars.animate then
		vars.title = 200
		vars.anim_title = timer.tween(0.5, vars, {title = 0}, 'out-back')
	else
		vars.title = 0
	end

	newmusic('audio/music/title.mp3', true)
end

function title:keypressed(key)
	if not transitioning and not vars.waiting then
		if vars.handler == 'title' then
			if key == 'j' then
				scenemanager:transitionscene(jukebox)
				fademusic()
				playsound(assets.sfx_select)
				vars.selection = 0
			elseif (save.keyboard == 1 and key == 'up') or (save.keyboard == 2 and key == 'w') then
				if vars.selection ~= 0 then
					if vars.selection > 1 then
						vars.selection = vars.selection - 1
					else
						vars.selection = #vars.selections
					end
					playsound(assets.sfx_move)
				end
			elseif (save.keyboard == 1 and key == 'down') or (save.keyboard == 2 and key == 's') then
				if vars.selection ~= 0 then
					if vars.selection < #vars.selections then
						vars.selection = vars.selection + 1
					else
						vars.selection = 1
					end
					playsound(assets.sfx_move)
				end
			elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				if vars.selections[vars.selection] == 'arcade' then
					scenemanager:transitionscene(game, 'arcade')
					fademusic()
				elseif vars.selections[vars.selection] == 'zen' then
					scenemanager:transitionscene(game, 'zen')
					fademusic()
				elseif vars.selections[vars.selection] == 'dailyrun' then
					if vars.dailyrunnable then
						scenemanager:transitionscene(game, 'dailyrun')
						save.lastdaily.score = 0
						fademusic()
						vars.resetlastdaily = timer.after(0.5, function()
							save.lastdaily = os.date('!*t')
							save.lastdaily.sent = false
							love.filesystem.write('data.json', json.encode(save))
						end)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.selections[vars.selection] == 'missions' then
					scenemanager:transitionscene(missions)
				elseif vars.selections[vars.selection] == 'statistics' then
					scenemanager:transitionscene(statistics)
				elseif vars.selections[vars.selection] == 'howtoplay' then
					scenemanager:transitionscene(howtoplay)
				elseif vars.selections[vars.selection] == 'options' then
					scenemanager:transitionscene(options)
				elseif vars.selections[vars.selection] == 'credits' then
					scenemanager:transitionscene(credits)
				elseif vars.selections[vars.selection] == 'quit' then
					vars.handler = 'quit'
					if music ~= nil then music:setVolume(0.3) end
					playsound(assets.sfx_select)
				end
				if transitioning then
					playsound(assets.sfx_select)
					vars.selection = 0
				end
			end
		elseif vars.handler == 'quit' then
			if (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				love.event.quit()
			elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
				if music ~= nil then music:setVolume(1) end
				vars.handler = 'title'
				playsound(assets.sfx_back)
			end
		end
	end
end

function title:update()
	local time = os.date('!*t')

	if save.lastdaily.year == time.year and save.lastdaily.month == time.month and save.lastdaily.day == time.day then
		vars.dailyrunnable = false
	else
		vars.dailyrunnable = true
	end
end

function title:draw()
	gfx.draw(assets.title, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))

	gfx.draw(assets.half_1x, floor((250 + vars.title) / 2) * 2, 212 - (20 * #vars.selections))

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	for i = 1, #vars.selections do
		if vars.selections[vars.selection] == 'arcade' then
			text = 'Arcade Mode'
		elseif vars.selections[vars.selection] == 'zen' then
			text = 'Chill Mode'
		elseif vars.selections[vars.selection] == 'dailyrun' then
			text = 'Daily Run'
		elseif vars.selections[vars.selection] == 'missions' then
			text = 'Mission Mode'
		elseif vars.selections[vars.selection] == 'statistics' then
			text = 'Statistics'
		elseif vars.selections[vars.selection] == 'howtoplay' then
			text = 'How to Play'
		elseif vars.selections[vars.selection] == 'options' then
			text = 'Options'
		elseif vars.selections[vars.selection] == 'credits' then
			text = 'Credits'
		elseif vars.selections[vars.selection] == 'quit' then
			text = 'Quit Game'
		end
		if vars.selection == i then
			gfx.printf(text, 0, (210 - (20 * #vars.selections)) + (20 * i), 385 + floor(vars.title), 'right')
		end
	end

	if vars.selections[vars.selection] == 'arcade' then
		if save.hardmode then
			if save.hard_score ~= 0 then
				gfx.print('High: ' .. commalize(save.hard_score), 10 - floor(vars.title), 205)
			end
		else
			if save.score ~= 0 then
				gfx.print('High: ' .. commalize(save.score), 10 - floor(vars.title), 205)
			end
		end
	elseif vars.selections[vars.selection] == 'dailyrun' then
		if save.lastdaily.score ~= 0 then
			gfx.print('Today\'s Score: ' .. commalize(save.lastdaily.score), 10 - floor(vars.title), 205)
		end
	elseif vars.selections[vars.selection] == 'missions' then
		if save.highest_mission > 1 then
			gfx.print('Missions Completed: ' .. commalize(save.highest_mission - 1), 10 - floor(vars.title), 205)
		end
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	local time = os.date('!*t')

	local text = ''
	for i = 1, #vars.selections do
		if vars.selections[i] == 'arcade' then
			text = 'Arcade Mode'
		elseif vars.selections[i] == 'zen' then
			text = 'Chill Mode'
		elseif vars.selections[i] == 'dailyrun' then
			text = 'Daily Run'
		elseif vars.selections[i] == 'missions' then
			text = 'Mission Mode'
		elseif vars.selections[i] == 'statistics' then
			text = 'Statistics'
		elseif vars.selections[i] == 'howtoplay' then
			text = 'How to Play'
		elseif vars.selections[i] == 'options' then
			text = 'Options'
		elseif vars.selections[i] == 'credits' then
			text = 'Credits'
		elseif vars.selections[i] == 'quit' then
			text = 'Quit Game'
		end
		if vars.selection ~= i then
			gfx.printf(text, 0, (210 - (20 * #vars.selections)) + (20 * i), 385 + floor(vars.title), 'right')
		end
	end

	if save.gamepad then -- Gamepad
		gfx.print('The D-pad moves. A picks.', 10 - floor(vars.title), 220)
	elseif save.keyboard == 1 then -- Arrows + Z & X
		gfx.print('The arrows move. Z picks.', 10 - floor(vars.title), 220)
	elseif save.keyboard == 2 then -- WASD + , & .
		gfx.print('WASD moves. , picks.', 10 - floor(vars.title), 220)
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
		gfx.setFont(assets.half_circle_inverted)
	end

	if time.hour < 23 then
		gfx.print(((vars.dailyrunnable and '⏰ ') or '🔒 ') .. (24 - time.hour) .. 'h', 265 + floor(vars.title), 90)
	else
		if time.min < 59 then
			gfx.print(((vars.dailyrunnable and '⏰ ') or '🔒 ') .. (60 - time.min) .. 'm', 265 + floor(vars.title), 90)
		else
			gfx.print(((vars.dailyrunnable and '⏰ ') or '🔒 ') .. (60 - time.sec) .. 'w', 265 + floor(vars.title), 90)
		end
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.logo, 0, 0)

	if vars.handler == 'quit' then
		gfx.draw(assets.half, 0, 0)
		gfx.draw(assets.modal_small, 46, 35)

		gfx.setFont(assets.full_circle_inverted)
		if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

		gfx.printf('Are you sure you\'d\nlike to quit?', 0, 62, 400, 'center')

		gfx.setFont(assets.half_circle_inverted)
		if save.color == 1 then gfx.setColor(love.math.colorFromBytes(194, 195, 199, 255)) end

		if save.gamepad then
			gfx.printf('(You can also quit at any time\nby pressing Start twice quickly\noutside of the game.)', 0, 103, 400, 'center')
		else
			gfx.printf('(You can also quit at any time\nby pressing ESC twice quickly\noutside of the game.)', 0, 103, 400, 'center')
		end

		if save.gamepad then
			gfx.printf('A quits. B goes back.', 0, 160, 400, 'center')
		elseif save.keyboard == 1 then
			gfx.printf('Z quits. X goes back.', 0, 160, 400, 'center')
		elseif save.keyboard == 2 then
			gfx.printf(', quits. . goes back.', 0, 160, 400, 'center')
		end

		gfx.setColor(1, 1, 1, 1)
	end

	draw_on_top()
end

return title