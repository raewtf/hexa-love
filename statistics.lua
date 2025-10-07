local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local statistics = {}

function statistics:enter(current, ...)
	love.window.setTitle('HEXA — Statistics')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
	}

	vars = {
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		fg_hexa = 0,
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

function statistics:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'statistics')
		end
	end
end

function statistics:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.print(commalize(save.swaps), 250, 5)
	gfx.print(commalize(save.hexas), 250, 20)
	gfx.print(string.format('%.2f', save.swaps / save.hexas) .. ':1', 250, 35)
	gfx.print(commalize(save.score), 250, 50)
	gfx.print(commalize(save.hard_score), 250, 65)
	local playhours, playmins, playsecs = timecalchour(save.playtime)
	gfx.print(playhours .. 'h ' .. playmins .. 'm ' .. playsecs .. 's', 250, 80)
	local gamehours, gamemins, gamesecs = timecalchour(save.gametime)
	gfx.print(gamehours .. 'h ' .. gamemins .. 'm ' .. gamesecs .. 's', 250, 95)
	gfx.print(commalize(save.total_score), 250, 110)
	gfx.print(commalize(save.black_match), 250, 125)
	gfx.print(commalize(save.gray_match), 250, 140)
	gfx.print(commalize(save.white_match), 250, 155)
	gfx.print(commalize(save.double_match), 250, 170)
	gfx.print(commalize(save.bomb_match), 250, 185)
	gfx.print(commalize(save.wild_match), 250, 200)

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		gfx.print(text('b') .. text('back'), 70, 220)
	else
		gfx.print(start(save.secondary) .. text('back'), 70, 220)
	end

	gfx.printf(text('totalswaps'), 0, 5, 240, 'right')
	gfx.printf(text('totalhexas'), 0, 20, 240, 'right')
	gfx.printf(text('swapshexas'), 0, 35, 240, 'right')
	gfx.printf(text('highscore'), 0, 50, 240, 'right')
	gfx.printf(text('highscorehardmode'), 0, 65, 240, 'right')
	gfx.printf(text('playtime'), 0, 80, 240, 'right')
	gfx.printf(text('gametime'), 0, 95, 240, 'right')
	gfx.printf(text('totalscore'), 0, 110, 240, 'right')
	gfx.printf(text('hexablack'), 0, 125, 240, 'right')
	gfx.printf(text('hexagray'), 0, 140, 240, 'right')
	gfx.printf(text('hexawhite'), 0, 155, 240, 'right')
	gfx.printf(text('hexadouble'), 0, 170, 240, 'right')
	gfx.printf(text('kerplosion'), 0, 185, 240, 'right')
	gfx.printf(text('hexawild'), 0, 200, 240, 'right')

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return statistics