local gfx = love.graphics
local floor = math.floor
local howtoplay = {}

function howtoplay:enter(current, ...)
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		manual1 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-1.png'),
		manual2 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-2.png'),
		manual3 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-3.png'),
		manual4 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-4.png'),
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
		if key == 'left' then
			if vars.page > 1 then
				vars.page = vars.page - 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == 'right' then
			if vars.page < 7 then
				vars.page = vars.page + 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == 'x' then
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

	gfx.draw(assets['manual' .. vars.page], 220, 40)

	gfx.setFont(assets.half_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(194, 195, 199, 255)) end

	gfx.print('The arrows turn the page. X goes back.', 10, 220)
	gfx.printf(vars.page .. '/7', 0, 220, 390, 'right')

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if vars.page == 1 then
		gfx.print('You\'re the commander of Starship HEXA,\nthe head of a space fleet dead-set on\ntaking over the universe.\n\nYou\'re well on your way to\nassuming control of everything\nthat is and shall be, but\nyour attack methods\nare a bit...unorthodox.\n\nWe can\'t dwell on it\nfor too long, though, so get out\nthere and match those hexagons!', 10, 10)
	elseif vars.page == 2 then
		gfx.print('\nThe main game board is called the HEXAPLEX.\nThis is where gameplay takes place.\n\nUse the arrows to move your\ncursor along the five\nhexagons within the grid.\n\nUse the Z and X keys to\nturn the hexagon clockwise\nor counter-clockwise.', 10, 10)
	elseif vars.page == 3 then
		gfx.print('\nA full hexagon of like-colored\ntris is called a HEXA.\nMatch these to earn points.\n\nManipulate the HEXAPLEX\nto create as many HEXA\nmatches as you can.\n\nYou\'ll earn a varying amount\nof points depending on\nhow well you perform.', 10, 10)
	elseif vars.page == 4 then
		gfx.print('\nThere are three colors of\ntri in the HEXAPLEX.\n\nDark tris are worth\nthe most points, giving\nyou 200 per HEXA match.\n\nGray tris give you\n150 points per HEXA.\n\nLight tris give only\n100 points per HEXA.', 10, 10)
	elseif vars.page == 5 then
		gfx.print('Various Power-ups are also here\nto give you an advantage.\n\n2x tris reward double\npoints, Bombs blow up the\nwhole grid at once, and Wild\ntris work in any match.\n\nPower-ups won\'t stack among\nthemselves, but will stack\nwith any others.\n\n(By the way, Power-ups aren\'t\navailable in some modes.)', 10, 10)
	elseif vars.page == 6 then
		gfx.print('Remember that you\'re on a timer!\n\nCreating HEXA matches will\nbuy you some more time.\nMatching 2x tris will\nearn you even more time\nthan usual, as well.\n\nTry and keep going for\nas long as you can!\n\n(Oh, depending on the mode,\nthere may be no timer.)', 10, 10)
	elseif vars.page == 7 then
		gfx.print('That should be all you need to\nknow to get started with HEXA!\n\nYou can also consult the manual:\nhttps://rae.wtf/blog/hexa-manual\n...if there\'s something you\'re\nstill confused about.\n\nIf you like this game,\nlet me know on-line!\nhttps://rae.wtf\n\n...and thank you for playing!', 10, 10)
	end

	gfx.setColor(1, 1, 1, 1)
end

return howtoplay