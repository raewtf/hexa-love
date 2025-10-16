local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local howtoplay = {}

function howtoplay:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('howtoplay'))
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵ÀÇÉÈÊÎÔÛàçéèêîôû'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒ÀÇÉÈÊÎÔÛàçéèêîôû'),
		manual1 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-1.png'),
		manual2 = gfx.newImage('images/2/manual-table-2.png'),
		manual2_1 = gfx.newImage('images/1/manual-table-2_1.png'),
		manual2_2 = gfx.newImage('images/1/manual-table-2_2.png'),
		manual2_3 = gfx.newImage('images/1/manual-table-2_3.png'),
		manual2_4 = gfx.newImage('images/1/manual-table-2_4.png'),
		manual2_5 = gfx.newImage('images/1/manual-table-2_5.png'),
		manual3 = gfx.newImage('images/2/manual-table-3.png'),
		manual3_1 = gfx.newImage('images/1/manual-table-3_1.png'),
		manual3_2 = gfx.newImage('images/1/manual-table-3_2.png'),
		manual3_3 = gfx.newImage('images/1/manual-table-3_3.png'),
		manual4 = gfx.newImage('images/2/manual-table-4.png'),
		manual4_1 = gfx.newImage('images/1/manual-table-4_1.png'),
		manual4_2 = gfx.newImage('images/1/manual-table-4_2.png'),
		manual4_3 = gfx.newImage('images/1/manual-table-4_3.png'),
		manual4_4 = gfx.newImage('images/1/manual-table-4_4.png'),
		manual4_5 = gfx.newImage('images/1/manual-table-4_5.png'),
		manual5 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-5.png'),
		manual6 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-6.png'),
		manual7 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-7.png'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
	}

	vars = {
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
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

function howtoplay:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.left then
			if vars.page > 1 then
				vars.page = vars.page - 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == save.right then
			if vars.page < 7 then
				vars.page = vars.page + 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'howtoplay')
		end
	end
end

function howtoplay:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))
	gfx.draw(assets.img25, 0, 0)

	if vars.page == 2 or vars.page == 4 then
		if save.color == 1 then
			gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_1'], 220, 40)
			gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_2'], 220, 40)
			gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_3'], 220, 40)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets['manual' .. vars.page .. '_4'], 220, 40)
			gfx.setColor(hexaplex_whites[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_5'], 220, 40)
		else
			gfx.draw(assets['manual' .. vars.page], 220, 40)
		end
	elseif vars.page == 3 then
		if save.color == 1 then
			gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_1'], 220, 40)
			gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_2'], 220, 40)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets['manual' .. vars.page .. '_3'], 220, 40)
		else
			gfx.draw(assets['manual' .. vars.page], 220, 40)
		end
	else
		gfx.draw(assets['manual' .. vars.page], 220, 40)
	end

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.print(text('manual' .. vars.page), 10, 10)

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		gfx.print(text('dpad') .. text('pages') .. text('b') .. text('back'), 10, 220)
	else
		gfx.print(start(save.left) .. text('slash') .. start(save.right) .. text('page') .. start(save.secondary) .. text('back'), 10, 220)
	end
	gfx.printf(vars.page .. '/7', 0, 220, 390, 'right')

	draw_on_top()
end

return howtoplay