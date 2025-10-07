local gfx = love.graphics
local floor = math.floor
local min = math.min
local text = getLocalizedText
local visuals = {}

function visuals:reload_images()
	assets.stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png')
	assets.stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png')
	assets.fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png')
	assets.img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png')
	assets.bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png')
end

function visuals:enter(current, ...)
	love.window.setTitle('HEXA — Video Options')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		quad = gfx.newQuad(0, 0, 400, 140, 400, 240),
		hexaplex = gfx.newImage('images/2/manual-table-2.png'),
		hexaplex1 = gfx.newImage('images/1/manual-table-2_1.png'),
		hexaplex2 = gfx.newImage('images/1/manual-table-2_2.png'),
		hexaplex3 = gfx.newImage('images/1/manual-table-2_3.png'),
		hexaplex4 = gfx.newImage('images/1/manual-table-2_4.png'),
		hexaplex5 = gfx.newImage('images/1/manual-table-2_5.png'),
	}

	self:reload_images()

	vars = {
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		waiting = true,
		selection = 0,
		selections = {'scale', 'clean_scaling', 'reduceflashing', 'color', 'hexaplex_color'},
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
end

function visuals:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.up then
			if vars.selection ~= 0 then
				if vars.selection > 1 then
					vars.selection = vars.selection - 1
				else
					vars.selection = #vars.selections
				end
				playsound(assets.sfx_move)
			end
		elseif key == save.down then
			if vars.selection ~= 0 then
				if vars.selection < #vars.selections then
					vars.selection = vars.selection + 1
				else
					vars.selection = 1
				end
				playsound(assets.sfx_move)
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(options, 'visuals')
			vars.selection = 0
		elseif key == save.primary then
			if vars.selections[vars.selection] == 'scale' then
				save.scale = save.scale + 1
				if save.scale > 4 then
					save.scale = 1
				end
				rescale(save.scale)
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'clean_scaling' then
				save.clean_scaling = not save.clean_scaling
				playsound(assets.sfx_select)
				local w, h, _ = love.window.getMode()
				love.resize(w, h)
			elseif vars.selections[vars.selection] == 'reduceflashing' then
				save.reduceflashing = not save.reduceflashing
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'color' then
				save.color = save.color + 1
				if save.color > 2 then
					save.color = 1
				end
				self:reload_images()
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'hexaplex_color' then
				if save.color == 1 then
					save.hexaplex_color = save.hexaplex_color + 1
					local score = save.score
					if save.hard_score > save.score then score = save.hard_score end
					if save.hexaplex_color > min(1 + floor(score / 1000), 26) then
						save.hexaplex_color = 1
					end
					self:reload_images()
					playsound(assets.sfx_select)
				elseif save.color == 2 then
					shakies()
					playsound(assets.sfx_bonk)
				end
			end
		end
	end
end

function visuals:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	for i = 1, #vars.selections do
		if vars.selection == i then
			if vars.selections[vars.selection] == 'scale' then
				gfx.printf(text(vars.selections[vars.selection]) .. tostring(save[vars.selections[vars.selection]]), 0, -10 + (20 * i), 400, 'center')
			elseif vars.selections[vars.selection] == 'reduceflashing' then
				gfx.printf(text(vars.selections[vars.selection]) .. text(tostring(save[vars.selections[vars.selection]])), 0, -10 + (20 * i), 400, 'center')
			elseif vars.selections[vars.selection] == 'hexaplex_color' then
				gfx.printf(text('hexaplex_color') .. text('hexaplex_' .. save.hexaplex_color), 0, -10 + (20 * i), 400, 'center')
			else
				gfx.printf(text(vars.selections[vars.selection]) .. text(vars.selections[vars.selection] .. tostring(save[vars.selections[vars.selection]])), 0, -10 + (20 * i), 400, 'center')
			end
		end
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	for i = 1, #vars.selections do
		if vars.selection ~= i then
			if vars.selections[i] == 'scale' then
				gfx.printf(text(vars.selections[i]) .. tostring(save[vars.selections[i]]), 0, -10 + (20 * i), 400, 'center')
			elseif vars.selections[i] == 'reduceflashing' then
				gfx.printf(text(vars.selections[i]) .. text(tostring(save[vars.selections[i]])), 0, -10 + (20 * i), 400, 'center')
			elseif vars.selections[i] == 'hexaplex_color' then
				gfx.printf(text('hexaplex_color') .. text('hexaplex_' .. save.hexaplex_color), 0, -10 + (20 * i), 400, 'center')
			else
				gfx.printf(text(vars.selections[i]) .. text(vars.selections[i] .. tostring(save[vars.selections[i]])), 0, -10 + (20 * i), 400, 'center')
			end
		end
	end

	if save.gamepad then -- Gamepad
		gfx.print(text('dpad') .. text('moves') .. text('a') .. text('toggle'), 70, 220)
	else
		gfx.print(start(save.up) .. text('slash') .. start(save.down) .. text('move') .. start(save.primary) .. text('toggle'), 70, 220)
	end

	if save.color == 1 then
		local score = save.score
		if save.hard_score > save.score then score = save.hard_score end
		gfx.printf(min(1 + floor(score / 1000), 26) .. text('slash') .. 26 .. text('unlocked'), 0, 120, 230, 'center')
		if 1 + floor(score / 1000) >= 26 then
			gfx.printf(text('hexaplex_color_all'), 0, 140, 230, 'center')
		else
			gfx.printf(text('hexaplex_color_locked'), 0, 140, 230, 'center')
		end
	end

	gfx.setColor(1, 1, 1, 1)

	if save.color == 1 then
		gfx.setColor(hexaplex_blacks[save.hexaplex_color])
		gfx.draw(assets.hexaplex1, 165, 80)
		gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
		gfx.draw(assets.hexaplex2, 165, 80)
		gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
		gfx.draw(assets.hexaplex3, 165, 80)
		gfx.setColor(1, 1, 1, 1)
		gfx.draw(assets.hexaplex4, 165, 80)
		gfx.setColor(hexaplex_whites[save.hexaplex_color])
		gfx.draw(assets.hexaplex5, 165, 80)
	else
		gfx.draw(assets.hexaplex, 115, 80)
		gfx.draw(assets.img25, assets.quad, 0, 83)
	end
	gfx.setColor(1, 1, 1, 1)
	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return visuals