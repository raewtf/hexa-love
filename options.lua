local gfx = love.graphics
local floor = math.floor
local options = {}

visuals = require('visuals')

function options:enter(current, ...)
	love.window.setTitle('HEXA — Options')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png'),
		fg_hexa_1 = gfx.newImage('images/2/fg_hexa_1.png'),
		fg_hexa_1_1 = gfx.newImage('images/1/fg_hexa_1_1.png'),
		fg_hexa_1_2 = gfx.newImage('images/1/fg_hexa_1_2.png'),
		fg_hexa_1_3 = gfx.newImage('images/1/fg_hexa_1_3.png'),
		fg_hexa_1_4 = gfx.newImage('images/1/fg_hexa_1_4.png'),
		fg_hexa_2 = gfx.newImage('images/2/fg_hexa_2.png'),
		fg_hexa_2_1 = gfx.newImage('images/1/fg_hexa_2_1.png'),
		fg_hexa_2_2 = gfx.newImage('images/1/fg_hexa_2_2.png'),
		fg_hexa_2_3 = gfx.newImage('images/1/fg_hexa_2_3.png'),
		fg_hexa_2_4 = gfx.newImage('images/1/fg_hexa_2_4.png'),
		fg_hexa_2_5 = gfx.newImage('images/1/fg_hexa_2_5.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_boom = love.audio.newSource('audio/sfx/boom.mp3', 'static'),
	}

	vars = {
		default = args[1],
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		fg_hexa = 0,
		resetprogress = 1,
		selection = 0,
		waiting = true,
		selections = {'music', 'sfx', 'visuals', 'keyboard', 'rumble', 'flip', 'skipfanfare', 'hardmode', 'reset'},
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

	vars.anim_fg = timer.tween(3, vars, {fg_hexa = 7}, 'in-out-sine')
	vars.anim_fg_loop = timer.every(3, function()
		if vars.fg_hexa < 3 then
			vars.anim_fg = timer.tween(3, vars, {fg_hexa = 7}, 'in-out-sine')
		elseif vars.fg_hexa > 3 then
			vars.anim_fg = timer.tween(3, vars, {fg_hexa = 0}, 'in-out-sine')
		end
	end)
end

function options:keypressed(key)
	if not transitioning and not vars.waiting then
		if (save.keyboard == 1 and key == 'up') or (save.keyboard == 2 and key == 'w') then
			if vars.selection ~= 0 then
				if vars.selection > 1 then
					vars.selection = vars.selection - 1
				else
					vars.selection = #vars.selections
				end
				playsound(assets.sfx_move)
				if vars.resetprogress < 4 then
					vars.resetprogress = 1
				end
			end
		elseif (save.keyboard == 1 and key == 'down') or (save.keyboard == 2 and key == 's') then
			if vars.selection ~= 0 then
				if vars.selection < #vars.selections then
					vars.selection = vars.selection + 1
				else
					vars.selection = 1
				end
				playsound(assets.sfx_move)
				if vars.resetprogress < 4 then
					vars.resetprogress = 1
				end
			end
		elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'options')
			vars.selection = 0
		elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
			if vars.selections[vars.selection] == "music" then
				save.music = save.music + 1
				if save.music > 5 then
					save.music = 0
				end
				if save.music > 0 then
					if music ~= nil then
						volume = {save.music / 5}
					else
						newmusic('audio/music/title.mp3', true)
					end
				else
					fademusic(1)
				end
			elseif vars.selections[vars.selection] == "sfx" then
				save.sfx = save.sfx + 1
				if save.sfx > 5 then
					save.sfx = 0
				end
			elseif vars.selections[vars.selection] == 'visuals' then
				scenemanager:transitionscene(visuals)
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'keyboard' then
				save.keyboard = save.keyboard + 1
				if save.keyboard > 2 then
					save.keyboard = 1
				end
			elseif vars.selections[vars.selection] == 'rumble' then
				save.rumble = not save.rumble
				rumble(1, 1, 0.2)
			elseif vars.selections[vars.selection] == "flip" then
				save.flip = not save.flip
			elseif vars.selections[vars.selection] == "skipfanfare" then
				save.skipfanfare = not save.skipfanfare
			elseif vars.selections[vars.selection] == "hardmode" then
				save.hardmode = not save.hardmode
			elseif vars.selections[vars.selection] == "reset" then
				if vars.resetprogress < 3 then
					vars.resetprogress = vars.resetprogress + 1
				elseif vars.resetprogress == 3 then
					playsound(assets.sfx_boom)
					vars.resetprogress = vars.resetprogress + 1
					save.score = 0
					save.hard_score = 0
					save.swaps = 0
					save.hexas = 0
					save.mission_bests = {}
					save.highest_mission = 1
					for i = 1, #save.mission_bests do
						save.mission_bests[i] = save.mission_bests[i] or 0
					end
					for i = 1, 50 do
						if save.mission_bests['mission' .. i] == nil then
							save.mission_bests['mission' .. i] = 0
						end
					end
					save.author_name = ''
					save.exported_mission = false
				end
			end
			playsound(assets.sfx_select)
		end
	end
end

function options:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	local text = ''
	for i = 1, #vars.selections do
		if vars.selections[vars.selection] == 'music' then
			text = 'Music Volume: ' .. tostring(save.music)
		elseif vars.selections[vars.selection] == 'sfx' then
			text = 'SFX Volume: ' .. tostring(save.sfx)
		elseif vars.selections[vars.selection] == 'visuals' then
			text = 'Video Options'
		elseif vars.selections[vars.selection] == 'keyboard' then
			text = 'Keys: ' .. tostring(save.keyboard == 1 and 'Arrows + Z & X' or save.keyboard == 2 and 'WASD + , & .')
		elseif vars.selections[vars.selection] == 'rumble' then
			text = 'Rumble: ' .. tostring(save.rumble and 'ON' or 'OFF')
		elseif vars.selections[vars.selection] == 'flip' then
			text = 'Flip Rotation: ' .. tostring(save.flip and 'ON' or 'OFF')
		elseif vars.selections[vars.selection] == 'skipfanfare' then
			text = 'Skip Fanfare: ' .. tostring(save.skipfanfare and 'ON' or 'OFF')
		elseif vars.selections[vars.selection] == 'hardmode' then
			text = 'Hard Mode: ' .. tostring(save.hardmode and 'ON' or 'OFF')
		elseif vars.selections[vars.selection] == 'reset' then
			text = vars.resetprogress == 1 and 'Reset Local Stats' or vars.resetprogress == 2 and 'Are you sure?' or vars.resetprogress == 3 and 'Are you really sure?!' or vars.resetprogress == 4 and 'Local stats reset.'
		end
		if vars.selection == i then
			gfx.printf(text, 0, 5 + (20 * i), 400, 'center')
		end
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	local text = ''
	for i = 1, #vars.selections do
		if vars.selections[i] == 'music' then
			text = 'Music Volume: ' .. tostring(save.music)
		elseif vars.selections[i] == 'sfx' then
			text = 'SFX Volume: ' .. tostring(save.sfx)
		elseif vars.selections[i] == 'visuals' then
			text = 'Video Options'
		elseif vars.selections[i] == 'keyboard' then
			text = 'Keys: ' .. tostring(save.keyboard == 1 and 'Arrows + Z & X' or save.keyboard == 2 and 'WASD + , & .')
		elseif vars.selections[i] == 'rumble' then
			text = 'Rumble: ' .. tostring(save.rumble and 'ON' or 'OFF')
		elseif vars.selections[i] == 'flip' then
			text = 'Flip Rotation: ' .. tostring(save.flip and 'ON' or 'OFF')
		elseif vars.selections[i] == 'skipfanfare' then
			text = 'Skip Fanfare: ' .. tostring(save.skipfanfare and 'ON' or 'OFF')
		elseif vars.selections[i] == 'hardmode' then
			text = 'Hard Mode: ' .. tostring(save.hardmode and 'ON' or 'OFF')
		elseif vars.selections[i] == 'reset' then
			text = vars.resetprogress == 1 and 'Reset Local Stats' or vars.resetprogress == 2 and 'Are you sure?' or vars.resetprogress == 3 and 'Are you really sure?!' or vars.resetprogress == 4 and 'Local stats reset.'
		end
		if vars.selection ~= i then
			gfx.printf(text, 0, 5 + (20 * i), 400, 'center')
		end
	end

	gfx.print('v' .. version, 65, 205)
	if save.gamepad then -- Gamepad
		gfx.print('The D-pad moves. A toggles.', 70, 220)
	elseif save.keyboard == 1 then -- Arrows + Z & X
		gfx.print('The arrows move. Z toggles.', 70, 220)
	elseif save.keyboard == 2 then -- WASD + , & .
		gfx.print('WASD moves. , toggles.', 70, 220)
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	if save.color == 1 then
		gfx.setColor(hexaplex_blacks[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_1_1, 0, floor(vars.fg_hexa))
		gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_1_2, 0, floor(vars.fg_hexa))
		gfx.setColor(hexaplex_whites[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_1_3, 0, floor(vars.fg_hexa))
		gfx.setColor(1, 1, 1, 1)
		gfx.draw(assets.fg_hexa_1_4, 0, floor(vars.fg_hexa))
		gfx.setColor(hexaplex_blacks[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_1, 0, floor(vars.fg_hexa * 1.2))
		gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_2, 0, floor(vars.fg_hexa * 1.2))
		gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_3, 0, floor(vars.fg_hexa * 1.2))
		gfx.setColor(hexaplex_whites[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_4, 0, floor(vars.fg_hexa * 1.2))
		gfx.setColor(1, 1, 1, 1)
		gfx.draw(assets.fg_hexa_2_5, 0, floor(vars.fg_hexa * 1.2))
	else
		gfx.draw(assets.fg_hexa_1, 0, floor(vars.fg_hexa))
		gfx.draw(assets.fg_hexa_2, 0, floor(vars.fg_hexa * 1.2))
	end

	draw_on_top()
end

return options