local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local jukebox = {}

function jukebox:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('jukebox'))
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵ÀÇÉÈÊÎÔÛàçéèêîôû'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒ÀÇÉÈÊÎÔÛàçéèêîôû'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		ship = newAnimation(gfx.newImage('images/' .. tostring(save.color) .. '/ship.png'), 139, 75, 0.4),
	}

	vars = {
		sx = 0,
		lx = 0,
		ship_x = -100,
		tunes = {'arcade1', 'arcade2', 'arcade3', 'title', 'zen1', 'zen2'},
		num = 6,
		showtext = true,
		text_y = 0,
		waiting = true,
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
	end)

	vars.anim_sx = timer.tween(4, vars, {sx = -399})
	vars.anim_lx = timer.tween(2.5, vars, {lx = -399})
	vars.anim_sx_loop = timer.every(4, function()
		vars.sx = 0
		vars.anim_sx = timer.tween(4, vars, {sx = -399})
	end)
	vars.anim_lx_loop = timer.every(2.5, function()
		vars.lx = 0
		vars.anim_lx = timer.tween(2.5, vars, {lx = -399})
	end)

	vars.anim_ship_x = timer.tween(1.7, vars, {ship_x = 200}, 'out-cubic')

	if save.music > 0 then
		self:shuffle()
	end
end

function jukebox:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.primary then
			vars.showtext = not vars.showtext
			if vars.showtext then
				vars.anim_text_y = timer.tween(0.3, vars, {text_y = 0}, 'out-back')
			else
				vars.anim_text_y = timer.tween(0.3, vars, {text_y = 50}, 'in-back')
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			vars.anim_ship_x = timer.tween(0.7, vars, {ship_x = 500}, 'in-back')
			vars.delay = timer.after(0.4, function()
				scenemanager:transitionscene(title, false, 'arcade')
			end)
			fademusic()
		end
	end
end

function jukebox:update(dt)
	if music == nil and not transitioning and save.music > 0 then self:shuffle() end
	assets.ship.currentTime = assets.ship.currentTime + dt
	if assets.ship.currentTime >= assets.ship.duration then
		assets.ship.currentTime = assets.ship.currentTime - assets.ship.duration
	end
end

function jukebox:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), 0)
	gfx.draw(assets.stars_large, floor(vars.lx), 0)
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.print(text('music_' .. vars.tunes[vars.rand]), 10, 205 + floor(vars.text_y))

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		gfx.print(text('a') .. text('toggles_text') .. text('b') .. text('back'), 10, 220 + floor(vars.text_y))
	else
		gfx.print(start(save.primary) .. text('toggles_text') .. start(save.secondary) .. text('back'), 10, 220 + floor(vars.text_y))
	end

	gfx.setColor(1, 1, 1, 1)

	local spritenum = floor(assets.ship.currentTime / assets.ship.duration * #assets.ship.quads) + 1
	gfx.draw(assets.ship.spriteSheet, assets.ship.quads[spritenum], floor(vars.ship_x), 120, 0, 1, 1, 69, 37)

	draw_on_top()
end

function jukebox:shuffle()
	vars.rand = rng:random(1, vars.num)
	newmusic('audio/music/' .. vars.tunes[vars.rand] .. '.mp3')
end

return jukebox