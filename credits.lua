local gfx = love.graphics
local floor = math.floor
local credits = {}

function credits:enter(current, ...)
	love.window.setTitle('HEXA — Credits')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg_credits.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
	}

	vars = {
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		fg_hexa = 0,
		page = 1,
		waiting = true,
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
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
end

function credits:keypressed(key)
	if not transitioning and not vars.waiting then
		if (save.keyboard == 1 and key == 'left') or (save.keyboard == 2 and key == 'a') then
			if vars.page > 1 then
				vars.page = vars.page - 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif (save.keyboard == 1 and key == 'right') or (save.keyboard == 2 and key == 'd') then
			if vars.page < 2 then
				vars.page = vars.page + 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'credits')
		end
	end
end

function credits:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))
	gfx.draw(assets.img25, 0, 0)


	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if vars.page == 1 then
		gfx.printf('\n\n\n\nProgrammed by Rae\nGraphics stuff drawn by Rae\n\nMusic from MusMus; SFX made with JSFXR\n\nFonts from Panic and Astigmatic\n\nHUMP lib from Matthias Richter', 0, 5, 400, 'center')
	elseif vars.page == 2 then
		gfx.printf('\n\n\n\nThank you to...\nVoxy, Toad, scizzorz, superfunc, mag,\nhunty, Scenic, Schyzo, DRD, Drew-Lo,\nIGDATC, and Panic!\n\nThank you to the wonderful PC testers:\nOrchid, Maddy, Toad, Seb, Winter,\nVoxy, Diego, Roxby, and Scenic Route!', 0, 5, 400, 'center')
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		gfx.print('The D-pad turns the page.', 65, 205)
		gfx.print('B goes back.', 70, 220)
	elseif save.keyboard == 1 then -- Arrows + Z & X
		gfx.print('The arrows turn the page.', 65, 205)
		gfx.print('X goes back.', 70, 220)
	elseif save.keyboard == 2 then -- WASD + , & .
		gfx.print('WASD turns the page.', 65, 205)
		gfx.print('. goes back.', 70, 220)
	end

	gfx.printf(vars.page .. '/2', 0, 220, 330, 'right')

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return credits