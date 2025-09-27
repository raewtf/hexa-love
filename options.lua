local gfx = love.graphics
local floor = math.floor
local options = {}

function options:reload_images()
	assets.stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png')
	assets.stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png')
	assets.fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png')
	assets.fg_hexa_1 = gfx.newImage('images/' .. tostring(save.color) .. '/fg_hexa_1.png')
	assets.fg_hexa_2 = gfx.newImage('images/' .. tostring(save.color) .. '/fg_hexa_2.png')
	assets.img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png')
	assets.bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png')
end

function options:enter(current, ...)
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_boom = love.audio.newSource('audio/sfx/boom.mp3', 'static'),
	}

	self:reload_images()

	vars = {
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		fg_hexa = 0,
		resetprogress = 1,
		waiting = true,
		selection = 0,
		selections = {'music', 'sfx', 'scale', 'color', 'reduceflashing', 'flip', 'skipfanfare', 'hardmode', 'reset'},
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
		vars.selection = 1
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
		if key == 'up' then
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
		elseif key == 'down' then
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
		elseif key == 'x' then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'options')
			vars.selection = 0
		elseif key == 'z' then
			if vars.selections[vars.selection] == "music" then
				save.music = not save.music
				if not save.music then
					fademusic(1)
				else
					newmusic('audio/music/title.mp3', true)
				end
			elseif vars.selections[vars.selection] == "sfx" then
				save.sfx = not save.sfx
			elseif vars.selections[vars.selection] == 'scale' then
				save.scale = save.scale + 1
				if save.scale > 4 then
					save.scale = 1
				end
				rescale(save.scale)
			elseif vars.selections[vars.selection] == 'color' then
				save.color = save.color + 1
				if save.color > 2 then
					save.color = 1
				end
				self:reload_images()
			elseif vars.selections[vars.selection] == 'reduceflashing' then
				save.reduceflashing = not save.reduceflashing
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

	gfx.setFont(assets.half_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(194, 195, 199, 255)) end

	gfx.printf('Swaps: ' .. commalize(save.swaps) .. ' - HEXAs: ' .. commalize(save.hexas), 0, 5, 400, 'center')

	gfx.printf('Music: ' .. tostring(save.music and 'ON' or 'OFF'), 0, 30, 400, 'center')
	gfx.printf('SFX: ' .. tostring(save.sfx and 'ON' or 'OFF'), 0, 50, 400, 'center')
	gfx.printf('Scale: ' .. save.scale, 0, 70, 400, 'center')
	gfx.printf('Visuals: ' .. tostring(save.color == 1 and 'Colorful' or save.color == 2 and 'Classic'), 0, 90, 400, 'center')
	gfx.printf('Reduce Flashing: ' .. tostring(save.reduceflashing and 'ON' or 'OFF'), 0, 110, 400, 'center')
	gfx.printf('Flip Rotation: ' .. tostring(save.flip and 'ON' or 'OFF'), 0, 130, 400, 'center')
	gfx.printf('Skip Fanfare: ' .. tostring(save.skipfanfare and 'ON' or 'OFF'), 0, 150, 400, 'center')
	gfx.printf('Hard Mode: ' .. tostring(save.hardmode and 'ON' or 'OFF'), 0, 170, 400, 'center')
	gfx.printf(vars.resetprogress == 1 and 'Reset Local Stats' or vars.resetprogress == 2 and 'Are you sure?' or vars.resetprogress == 3 and 'Are you really sure?!' or vars.resetprogress == 4 and 'Local stats reset.', 0, 190, 400, 'center')

	gfx.print('v' .. version, 65, 205)
	gfx.print('The arrows move. Z toggles.', 70, 220)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if vars.selections[vars.selection] == 'music' then
		gfx.printf('Music: ' .. tostring(save.music and 'ON' or 'OFF'), 0, 30, 400, 'center')
	elseif vars.selections[vars.selection] == 'sfx' then
		gfx.printf('SFX: ' .. tostring(save.sfx and 'ON' or 'OFF'), 0, 50, 400, 'center')
	elseif vars.selections[vars.selection] == 'scale' then
		gfx.printf('Scale: ' .. save.scale, 0, 70, 400, 'center')
	elseif vars.selections[vars.selection] == 'color' then
		gfx.printf('Visuals: ' .. tostring(save.color == 1 and 'Colorful' or save.color == 2 and 'Classic'), 0, 90, 400, 'center')
	elseif vars.selections[vars.selection] == 'reduceflashing' then
		gfx.printf('Reduce Flashing: ' .. tostring(save.reduceflashing and 'ON' or 'OFF'), 0, 110, 400, 'center')
	elseif vars.selections[vars.selection] == 'flip' then
		gfx.printf('Flip Rotation: ' .. tostring(save.flip and 'ON' or 'OFF'), 0, 130, 400, 'center')
	elseif vars.selections[vars.selection] == 'skipfanfare' then
		gfx.printf('Skip Fanfare: ' .. tostring(save.skipfanfare and 'ON' or 'OFF'), 0, 150, 400, 'center')
	elseif vars.selections[vars.selection] == 'hardmode' then
		gfx.printf('Hard Mode: ' .. tostring(save.hardmode and 'ON' or 'OFF'), 0, 170, 400, 'center')
	elseif vars.selections[vars.selection] == 'reset' then
		gfx.printf(vars.resetprogress == 1 and 'Reset Local Stats' or vars.resetprogress == 2 and 'Are you sure?' or vars.resetprogress == 3 and 'Are you really sure?!' or vars.resetprogress == 4 and 'Local stats reset.', 0, 190, 400, 'center')
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)
	gfx.draw(assets.fg_hexa_1, 0, floor(vars.fg_hexa))
	gfx.draw(assets.fg_hexa_2, 0, floor(vars.fg_hexa * 1.2))
end

return options