local gfx = love.graphics
local floor = math.floor
local ceil = math.ceil
local min = math.min
local exp = math.exp
local text = getLocalizedText
local game = {}

local tris_x = {140, 170, 200, 230, 260, 110, 140, 170, 200, 230, 260, 290, 110, 140, 170, 200, 230, 260, 290}
local tris_y = {70, 70, 70, 70, 70, 120, 120, 120, 120, 120, 120, 120, 170, 170, 170, 170, 170, 170, 170}
local tris_flip = {true, false, true, false, true, true, false, true, false, true, false, true, false, true, false, true, false, true, false}

function game:enter(current, ...)
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		cursor = gfx.newImage('images/' ..tostring(save.color) .. '/cursor.png'),
		cursor_pick = gfx.newImage('images/' ..tostring(save.color) .. '/cursor_pick.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		full_circle_outline = gfx.newImageFont('fonts/full-circle-outline.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵', -2),
		clock = gfx.newImageFont('fonts/clock.png', '0123456789:'),
		hexa = gfx.newImage('images/' .. tostring(save.color) .. '/hexa_' .. tostring(save.reduceflashing) .. '.png'),
		sfx_move = love.audio.newSource('audio/sfx/move.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_swap = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_hexa = love.audio.newSource('audio/sfx/hexa.mp3', 'static'),
		sfx_vine = love.audio.newSource('audio/sfx/vine.mp3', 'static'),
		sfx_boom = love.audio.newSource('audio/sfx/boom.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_count = love.audio.newSource('audio/sfx/count.mp3', 'static'),
		sfx_start = love.audio.newSource('audio/sfx/start.mp3', 'static'),
		sfx_end = love.audio.newSource('audio/sfx/end.mp3', 'static'),
		sfx_hexaprep = love.audio.newSource('audio/sfx/hexaprep.mp3', 'static'),
		sfx_mission = love.audio.newSource('audio/sfx/mission.mp3', 'static'),
		powerup_bomb_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_bomb_up.png'),
		powerup_bomb_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_bomb_down.png'),
		powerup_double_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_double_up.png'),
		powerup_double_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_double_down.png'),
		powerup_wild_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_up.png'),
		powerup_wild_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_down.png'),
		label_3 = gfx.newImage('images/' .. tostring(save.color) .. '/label_3.png'),
		label_2 = gfx.newImage('images/' .. tostring(save.color) .. '/label_2.png'),
		label_1 = gfx.newImage('images/' .. tostring(save.color) .. '/label_1.png'),
		label_go = gfx.newImage('images/' .. tostring(save.color) .. '/label_go_' .. tostring(save.lang) .. '.png'),
		label_bomb = gfx.newImage('images/' .. tostring(save.color) .. '/label_bomb_' .. tostring(save.lang) .. '.png'),
		label_double = gfx.newImage('images/' .. tostring(save.color) .. '/label_double_' .. tostring(save.lang) .. '.png'),
		modal = gfx.newImage('images/' .. tostring(save.color) .. '/modal.png'),
		modal_canvas = gfx.newCanvas(400, 240),
		bg_tile = gfx.newImage('images/' .. tostring(save.color) ..'/bg_tile.png'),
		stars = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		half = gfx.newImage('images/half.png'),
		mission_complete = gfx.newImage('images/' .. tostring(save.color) .. '/mission_complete_' .. tostring(save.lang) .. '.png'),
		gray = gfx.newImage('images/' .. tostring(save.color) .. tostring(save.color == 1 and '/tris/' .. save.hexaplex_color or '') .. '/gray.png'),
		grid_up = gfx.newImage('images/grid_up.png'),
		grid_down = gfx.newImage('images/grid_down.png'),
	}

	for i = 1, 11 do
		assets['hexa' .. i] = gfx.newQuad(-400 + (400 * i), 0, 400, 240, 4400, 240)
	end

	for i = 1, 5 do
		assets['powerup' .. i] = gfx.newQuad(-56 + (56 * min(i, 4)), 0, 56, 47, 224, 47)
	end

	vars = {
		mode = args[1], -- 'arcade' or 'zen' or 'dailyrun', or 'picture" or 'time' or 'logic' or 'speedrun'
		mission = args[2], -- number. what mission is this?
		modifier = args[3], -- modifier for whatever, depending on the mission
		start = args[4], -- starting layout
		goal = args[5], -- finishing layout, for picture mode
		seed = args[6], -- number seed, for time attack
		name = args[7], -- name, for picture puzzles
		tris = {},
		slot = 1,
		score = 0,
		combo = 0,
		-- animation data
		hexa = 11,
		cursor_x = 106,
		cursor_y = 42,
		cursor = 1,
		label = 400,
		modal = 240,
		sx = 0,
		sy = 0,
		powerup = 1,
		timer = 45000,
		old_timer = 45000,
		-- OK!
		can_do_stuff = false,
		ended = false,
		moves = 0,
		hexas = 0,
		movesbonus = 5,
		active_hexa = false,
		boomed = false,
		lastdir = false,
		skippedfanfare = false,
		missioncomplete = false,
		time = 0,
		pause_selection = 1,
		pause_selections = {'continue'},
		pos1 = 0,
		pos2 = 0,
		pos3 = 0,
		length1 = 0,
		length2 = 0,
		length3 = 0,
		handlers = 'game', -- can be game, losing, or lose, or pause. or nothing
		messagerand = rng:random(1, 10),
		white_is_white = false,
		-- TODO: vvv remove vvv
		arcade_messages = {'You\'re on your way to\nruler of the universe!', 'Match those HEXAs,\nmatch \'em real good!', 'Hexagons are the\nbestagons.', 'All will bow to their\nnew hexagonal ruler.', 'Hit more Bombs next time!', 'Go for a bigger score;\nconquer more planets!', 'Hit those 2x tris!', 'Those squares never knew\nwhat hit \'em.', 'Mission clear, over.\nReport back to base.', 'Starship HEXA ready for\nthe next launch!'},
		zen_messages = {'Good practice run! Now,\ntime for the real thing!', 'Make sure to take some\ngood, deep breaths.', 'Did you get a good amount\nof sleep last night?', 'Make sure you\'re drinking\nenough water lately!', 'Come back any time for\nchill HEXA-matching!', 'See you later!', 'Have a good day!', 'Have you heard of\n"hexaflexagons"?', 'Let\'s gooooooo!!', 'Go grab a snack or\nsomethin\'!'},
		dailyrun_messages = {'Check back in\ntomorrow!', 'See you later!', 'Good run today!', 'HEXA-good run!', 'Now get out there &\ntake on the day!', 'Nice work today!', 'See you tomorrow!', 'Have a good rest\nof your day!', 'Check how your high\nscores compare!', 'Prepare for the day ahead!'},
	}

	for i = 1, 19 do
		if tris_flip[i] then
			vars['mesh' .. i] = gfx.newMesh({{tris_x[i], tris_y[i] - 25, 0.5, 0}, {tris_x[i] + 30, tris_y[i] + 25, 1, 1}, {tris_x[i] - 30, tris_y[i] + 25, 0, 1}}, 'triangles', 'static')
		else
			vars['mesh' .. i] = gfx.newMesh({{tris_x[i], tris_y[i] + 25, 0.5, 1}, {tris_x[i] + 30, tris_y[i] - 25, 1, 0}, {tris_x[i] - 30, tris_y[i] - 25, 0, 0}}, 'triangles', 'static')
		end
		vars['mesh' .. i]:setTexture(assets.gray)
	end

	vars.anim_sx = timer.tween(10, vars, {sx = -399})
	vars.anim_sy = timer.tween(15, vars, {sy = -239})
	vars.anim_sx_loop = timer.every(10, function()
		vars.sx = 0
		vars.anim_sx = timer.tween(10, vars, {sx = -399})
	end)
	vars.anim_sy_loop = timer.every(15, function()
		vars.sy = 0
		vars.anim_sy = timer.tween(15, vars, {sy = -239})
	end)

	vars.anim_powerup = timer.tween(0.7, vars, {powerup = 4.99})
	vars.anim_powerup_loop = timer.every(0.7, function()
		vars.powerup = 1
		vars.anim_powerup = timer.tween(0.7, vars, {powerup = 4.99})
	end)

	if vars.mode == 'arcade' then
		love.window.setTitle(text('hexa') .. text('dash_long') .. text('arcade'))
	elseif vars.mode == 'zen' then
		love.window.setTitle(text('hexa') .. text('dash_long') .. text('zen'))
	elseif vars.mode == 'dailyrun' then
		love.window.setTitle(text('hexa') .. text('dash_long') .. text('dailyrun'))
	elseif vars.mode == 'picture' or vars.mode == 'time' or vars.mode == 'logic' or vars.mode == 'speedrun' then
		love.window.setTitle(text('hexa') .. text('dash_long') .. text('missions'))
	end

	if vars.mode == 'arcade' then
		table.insert(vars.pause_selections, 'restart')
	end

	table.insert(vars.pause_selections, 'quit')

	if vars.mode == 'dailyrun' or vars.mode == 'arcade' or vars.mode == 'zen' then
		assets.bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg_' .. vars.mode .. '.png')
	else
		assets.bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg_zen.png')
	end

	if vars.mode == 'dailyrun' then
		local time = os.date('!*t')
		rng:setSeed(time.year .. time.month .. time.day)
	elseif vars.mode == 'time' then
		if vars.seed ~= nil and vars.seed ~= 0 then
			rng:setSeed(vars.seed)
		else
			rng:setSeed(123459 * vars.mission)
		end
	else
		rng:setSeed(os.time())
	end

	if vars.mode ~= 'dailyrun' then
		if save.reduceflashing then
			vars.bgx = 0
			vars.bgy = 0
		else
			vars.bgx = 0
			vars.bgy = 0
			vars.anim_bgx = timer.tween(30, vars, {bgx = -399})
			vars.anim_bgy = timer.tween(28, vars, {bgy = -239})
			vars.anim_bgx_loop = timer.every(30, function()
				vars.bgx = 0
				vars.anim_bgx = timer.tween(30, vars, {bgx = -399})
			end)
			vars.anim_bgy_loop = timer.every(28, function()
				vars.bgy = 0
				vars.anim_bgy = timer.tween(28, vars, {bgy = -239})
			end)
		end
	end

	-- CHEEVOS: grant 'chill' if vars.mode == 'zen'

	if vars.mode == 'picture' then
		vars.tris = deepcopy(vars.goal)
	elseif vars.mode == 'speedrun' or vars.mode == 'logic' then
		vars.tris = deepcopy(vars.start)
	else
		local newcolor
		local newpowerup
		for i = 1, 19 do
			newcolor, newpowerup = self:randomizetri()
			vars.tris[i] = {index = i, color = newcolor, powerup = newpowerup}
		end
	end

	if vars.mode == 'arcade' or vars.mode == 'dailyrun' then
		save.lbs_lastmode = vars.mode
		assets.ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_arcade.png')
		vars.countdown3 = timer.after(1, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_3
			vars.label = 350
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown2 = timer.after(2, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_2
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown1 = timer.after(3, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_1
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdowngo = timer.after(4, function()
			playsound(assets.sfx_start)
			assets.draw_label = assets.label_go
			vars.label = 400
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200}, 'linear', function()
				assets.draw_label = nil
			end)
			newmusic('audio/music/arcade' .. rng:random(1, 3) .. '.mp3', true)
			vars.can_do_stuff = true
			self:check()
			vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
				self:endround()
			end)
		end)
	elseif vars.mode == 'zen' then
		assets.ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_zen.png')
		vars.countdowngo = timer.after(1, function()
			newmusic('audio/music/zen' .. rng:random(1, 2) .. '.mp3', true)
			vars.can_do_stuff = true
			self:check()
		end)
	elseif vars.mode == 'picture' then
		vars.cursor_y = 420
		assets.ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_zen.png')
		vars.countdown3 = timer.after(1, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_3
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown2 = timer.after(2, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_2
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown1 = timer.after(3, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_1
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdowngo = timer.after(4, function()
			vars.cursor_y = 42
			vars.tris = deepcopy(vars.start)
			playsound(assets.sfx_start)
			assets.draw_label = assets.label_go
			vars.label = 400
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200}, 'linear', function()
				assets.draw_label = nil
			end)
			newmusic('audio/music/zen' .. rng:random(1, 2) .. '.mp3', true)
			vars.can_do_stuff = true
		end)
	elseif vars.mode == 'logic' then
		assets.ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_zen.png')
		vars.countdowngo = timer.after(1, function()
			newmusic('audio/music/zen' .. rng:random(1, 2) .. '.mp3', true)
			vars.can_do_stuff = true
			self:check()
		end)
	elseif vars.mode == 'speedrun' then
		assets.ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_zen.png')
		vars.countdown3 = timer.after(1, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_3
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown2 = timer.after(2, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_2
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown1 = timer.after(3, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_1
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdowngo = timer.after(4, function()
			playsound(assets.sfx_start)
			assets.draw_label = assets.label_go
			vars.label = 400
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200}, 'linear', function()
				assets.draw_label = nil
			end)
			newmusic('audio/music/arcade' .. rng:random(1, 3) .. '.mp3', true)
			vars.can_do_stuff = true
			self:check()
			vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
				self:endround()
			end)
		end)
	elseif vars.mode == 'time' then
		assets.ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_arcade.png')
		vars.timer = vars.modifier * 1000
		vars.old_timer = vars.modifier * 1000
		vars.countdown3 = timer.after(1, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_3
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown2 = timer.after(2, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_2
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdown1 = timer.after(3, function()
			playsound(assets.sfx_count)
			assets.draw_label = assets.label_1
			vars.label = 350
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200})
		end)
		vars.countdowngo = timer.after(4, function()
			playsound(assets.sfx_start)
			assets.draw_label = assets.label_go
			vars.label = 400
			timer.cancel(vars.anim_label)
			vars.anim_label = timer.tween(1, vars, {label = -200}, 'linear', function()
				assets.draw_label = nil
			end)
			newmusic('audio/music/arcade' .. rng:random(1, 3) .. '.mp3', true)
			vars.can_do_stuff = true
			self:check()
			vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
				self:endround()
			end)
		end)
	else
		assets.ui = gfx.image.new('images/' .. tostring(save.color) .. '/ui_zen.png')
		vars.countdowngo = timer.after(1, function()
			vars.can_do_stuff = true
			self:check()
		end)
	end
end

function game:keypressed(key)
	if vars.handlers == 'game' then
		if key == save.left then
			if vars.can_do_stuff then
				vars.lastdir = false
				if vars.slot == 2 then
					vars.slot = 1
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 106}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 42}, 'out-back')
					playsound(assets.sfx_move)
				elseif vars.slot == 5 then
					vars.slot = 4
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 137}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 92}, 'out-back')
					playsound(assets.sfx_move)
				elseif vars.slot == 4 then
					vars.slot = 3
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 78}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 92}, 'out-back')
					playsound(assets.sfx_move)
				else
					playsound(assets.sfx_bonk)
				end
			end
		elseif key == save.right then
			if vars.can_do_stuff then
				vars.lastdir = true
				if vars.slot == 1 then
					vars.slot = 2
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 166}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 42}, 'out-back')
					playsound(assets.sfx_move)
				elseif vars.slot == 3 then
					vars.slot = 4
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 137}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 92}, 'out-back')
					playsound(assets.sfx_move)
				elseif vars.slot == 4 then
					vars.slot = 5
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 197}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 92}, 'out-back')
					playsound(assets.sfx_move)
				else
					playsound(assets.sfx_bonk)
				end
			end
		elseif key == save.up then
			if vars.can_do_stuff then
				if vars.slot == 3 or vars.slot == 4 or vars.slot == 5 then
					if vars.lastdir then
						vars.slot = 2
						timer.cancel(vars.anim_cursor_x)
						timer.cancel(vars.anim_cursor_y)
						vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 166}, 'out-back')
						vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 42}, 'out-back')
						playsound(assets.sfx_move)
					else
						vars.slot = 1
						timer.cancel(vars.anim_cursor_x)
						timer.cancel(vars.anim_cursor_y)
						vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 106}, 'out-back')
						vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 42}, 'out-back')
						playsound(assets.sfx_move)
					end
				else
					playsound(assets.sfx_bonk)
				end
			end
		elseif key == save.down then
			if vars.can_do_stuff then
				if vars.slot == 1 then
					vars.slot = 3
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 78}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 92}, 'out-back')
					playsound(assets.sfx_move)
				elseif vars.slot == 2 then
					vars.slot = 5
					timer.cancel(vars.anim_cursor_x)
					timer.cancel(vars.anim_cursor_y)
					vars.anim_cursor_x = timer.tween(0.08, vars, {cursor_x = 197}, 'out-back')
					vars.anim_cursor_y = timer.tween(0.08, vars, {cursor_y = 92}, 'out-back')
					playsound(assets.sfx_move)
				else
					playsound(assets.sfx_bonk)
				end
			end
		elseif key == save.primary then
			if vars.can_do_stuff then
				if save.flip then
					self:swap(vars.slot, true)
				else
					self:swap(vars.slot, false)
				end
			end
		elseif key == save.secondary then
			if vars.can_do_stuff then
				if save.flip then
					self:swap(vars.slot, false)
				else
					self:swap(vars.slot, true)
				end
			end
		elseif key == 'escape' then
			if (vars.can_do_stuff and not vars.paused) then
				vars.paused = true
				vars.handlers = 'pause'
				vars.pause_selection = 1
				playsound(assets.sfx_move)
				if music ~= nil then volume = {(save.music / 5) * 0.3} end
			end
		end
	elseif vars.handlers == 'losing' then
		if key == save.primary or key == save.secondary then
			if vars.ended and not vars.skippedfanfare then
				self:ersi()
			end
		end
	elseif vars.handlers == 'lose' then
		if key == save.primary then
			if vars.mode == 'dailyrun' then
				-- LEADERBOARDS: transition to highscores, vars.mode if true
			else
				fademusic()
				scenemanager:transitionscene(game, vars.mode)
			end
		elseif key == save.secondary then
			fademusic(100)
			scenemanager:transitionscene(title, false, vars.mode)
		end
	elseif vars.handlers == 'pause' then
		if key == save.left then
			if vars.pause_selection == 1 then
				playsound(assets.sfx_bonk)
			else
				vars.pause_selection = vars.pause_selection - 1
				playsound(assets.sfx_swap)
			end
		elseif key == save.right then
			if vars.pause_selection == #vars.pause_selections then
				playsound(assets.sfx_bonk)
			else
				vars.pause_selection = vars.pause_selection + 1
				playsound(assets.sfx_swap)
			end
		elseif key == save.primary then
			vars.paused = false
			vars.handlers = 'game'
			if music ~= nil then volume = {save.music / 5} end
			if vars.pause_selections[vars.pause_selection] == 'continue' then
				playsound(assets.sfx_select)
			elseif vars.pause_selections[vars.pause_selection] == 'restart' then
				if vars.mode == 'arcade' then
					self:restart()
				end
			elseif vars.pause_selections[vars.pause_selection] == 'quit' then
				if vars.mode == 'logic' or vars.mode == 'time' or vars.mode == 'picture' or vars.mode == 'speedrun' then
					if vars.anim_timer ~= nil then
						timer.cancel(vars.anim_timer)
					end
					vars.can_do_stuff = false
					if vars.mission ~= nil and vars.mission > 50 then
						scenemanager:transitionscene(missions, true)
					else
						scenemanager:transitionscene(missions)
					end
					fademusic(200)
				elseif vars.mode == 'arcade' or vars.mode == 'dailyrun' or vars.mode == 'zen' then
					self:endround()
				end
			end
		elseif key == save.secondary or key == 'escape' then
			vars.paused = false
			if not vars.active_hexa then
				vars.handlers = 'game'
			end
			if music ~= nil then volume = {save.music / 5} end
			playsound(assets.sfx_back)
		end
	elseif vars.handlers == '' then
		if key == 'escape' then
			if (vars.can_do_stuff and not vars.paused) then
				vars.paused = true
				vars.handlers = 'pause'
				vars.pause_selection = 1
				playsound(assets.sfx_move)
				if music ~= nil then volume = {(save.music / 5) * 0.3} end
			end
		end
	end
end

function game:update(dt)
	if vars.mode == 'arcade' or vars.mode == 'dailyrun' or vars.mode == 'time' then
		if vars.old_timer > 10000 and vars.timer <= 10000 then
			shakies(.5, 1)
			shakies_y(.75, 1)
			playsound(assets.sfx_count)
			rumble(0.1, 0.1, 0.15)
		end
		if vars.old_timer > 9000 and vars.timer <= 9000 then
			shakies(.5, 2)
			shakies_y(.75, 2)
			playsound(assets.sfx_count)
			rumble(0.2, 0.2, 0.15)
		end
		if vars.old_timer > 8000 and vars.timer <= 8000 then
			shakies(.5, 3)
			shakies_y(.75, 3)
			playsound(assets.sfx_count)
			rumble(0.3, 0.3, 0.15)
		end
		if vars.old_timer > 7000 and vars.timer <= 7000 then
			shakies(.5, 4)
			shakies_y(.75, 4)
			playsound(assets.sfx_count)
			rumble(0.4, 0.4, 0.15)
		end
		if vars.old_timer > 6000 and vars.timer <= 6000 then
			shakies(.5, 5)
			shakies_y(.75, 5)
			playsound(assets.sfx_count)
			rumble(0.5, 0.5, 0.15)
		end
		if vars.old_timer > 5000 and vars.timer <= 5000 then
			shakies(.5, 6)
			shakies_y(.75, 6)
			playsound(assets.sfx_count)
			rumble(0.6, 0.6, 0.15)
		end
		if vars.old_timer > 4000 and vars.timer <= 4000 then
			shakies(.5, 7)
			shakies_y(.75, 7)
			playsound(assets.sfx_count)
			rumble(0.7, 0.7, 0.15)
		end
		if vars.old_timer > 3000 and vars.timer <= 3000 then
			shakies(.5, 8)
			shakies_y(.75, 8)
			playsound(assets.sfx_count)
			rumble(0.8, 0.8, 0.15)
		end
		if vars.old_timer > 2000 and vars.timer <= 2000 then
			shakies(.5, 9)
			shakies_y(.75, 9)
			playsound(assets.sfx_count)
			rumble(0.9, 0.9, 0.15)
		end
		if vars.old_timer > 1000 and vars.timer <= 1000 then
			shakies(.5, 10)
			shakies_y(.75, 10)
			playsound(assets.sfx_count)
			rumble(1, 1, 0.15)
		end
		vars.old_timer = vars.timer
	end
	if vars.mode == 'speedrun' and vars.can_do_stuff then
		vars.time = vars.time + 1
	end
	if vars.can_do_stuff then
		save.gametime = save.gametime + 1
	end
end

function game:draw()
	gfx.draw(assets.bg, 0, 0)
	if vars.mode ~= 'dailyrun' then
		gfx.draw(assets.bg_tile, (floor(vars.bgx / 2) * 2) - 1, (floor(vars.bgy / 2) * 2) - 1)
	end
	gfx.draw(assets.stars, floor(vars.sx), floor(vars.sy))
	if assets.draw_label ~= nil then gfx.draw(assets.draw_label, floor(vars.label), -13) end
	gfx.draw(assets.ui, 0, 0)
	for i = 1, 19 do
		self:tri(i, tris_x[i], tris_y[i], tris_flip[i], vars.tris[i].color, vars.tris[i].powerup)
	end

	local cursor = floor(vars.cursor)
	if cursor >= 2 then
		gfx.draw(assets.cursor_pick, floor(vars.cursor_x) - 3, floor(vars.cursor_y) - 2)
	else
		gfx.draw(assets.cursor, floor(vars.cursor_x), floor(vars.cursor_y))
	end

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if vars.mode == 'arcade' or vars.mode == 'dailyrun' then
		gfx.print(commalize(vars.score), 10, 25)
		if vars.mode == 'arcade' then
			if save.hardmode then
				gfx.print(commalize((vars.score > save.hard_score and vars.score) or (save.hard_score)), 10, 60)
			else
				gfx.print(commalize((vars.score > save.score and vars.score) or (save.score)), 10, 60)
			end
		else
			local time = os.date('!*t')
			gfx.print(time.year .. time.month .. time.day, 10, 60)
		end
	elseif vars.mode == 'zen' then
		gfx.print(commalize(vars.moves), 10, 25)
		gfx.print(commalize(vars.hexas), 10, 60)
	elseif vars.mode == 'picture' or vars.mode == 'logic' then
		gfx.print(commalize(vars.moves), 10, 25)
		gfx.print(commalize(save.mission_bests['mission' .. vars.mission]), 10, 60)
	elseif vars.mode == 'time' then
		gfx.print(commalize(vars.score), 10, 25)
		gfx.print(commalize((vars.score > save.mission_bests['mission' .. vars.mission] and vars.score) or (save.mission_bests['mission' .. vars.mission])), 10, 60)
	elseif vars.mode == 'speedrun' then
		local mins, secs, mils = timecalc(vars.time)
		local bestmins, bestsecs, bestmils = timecalc(save.mission_bests['mission' .. vars.mission])
		gfx.print(mins .. ':' .. secs .. '.' .. mils, 10, 25)
		gfx.print(bestmins .. ':' .. bestsecs .. '.' .. bestmils, 10, 60)
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if vars.mode == 'arcade' or vars.mode == 'dailyrun' then
		gfx.print(text('score'), 10, 10)
		if vars.mode == 'arcade' then
			gfx.print(text('high'), 10, 45)
		else
			gfx.print(text('seed'), 10, 45)
		end
		if save.hardmode then
			gfx.print(text('hardmodeg'), 10, 80)
		end
	elseif vars.mode == 'zen' then
		gfx.print(text('swaps'), 10, 10)
		gfx.print(text('hexas'), 10, 45)
	elseif vars.mode == 'picture' or vars.mode == 'logic' then
		gfx.print(text('swaps'), 10, 10)
		gfx.print(text('best'), 10, 45)
	elseif vars.mode == 'time' then
		gfx.print(text('score'), 10, 10)
		gfx.print(text('high'), 10, 45)
	elseif vars.mode == 'speedrun' then
		gfx.print(text('time'), 10, 10)
		gfx.print(text('best'), 10, 45)
	end

	gfx.setFont(assets.clock)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if vars.mode == 'arcade' or vars.mode == 'dailyrun' or vars.mode == 'time' then
		gfx.print(ceil(vars.timer / 1000), 305, 55)
	end

	gfx.setColor(1, 1, 1, 1)

	if vars.hexa <= 11 then
		gfx.draw(assets.hexa, assets['hexa' .. floor(vars.hexa)], 0, 0)
	end

	if not vars.can_do_stuff then
		gfx.draw(assets.half, 0, 0)
	end
	if vars.missioncomplete then
		gfx.draw(assets.mission_complete, 0, 0)
	end
	gfx.draw(assets.modal_canvas, 0, floor(vars.modal))

	if vars.paused then
		gfx.draw(assets.half, 0, 0)
		gfx.setColor(0, 0, 0, 1)
		gfx.rectangle('fill', 0, 90, 400, 60)

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
		else
			gfx.setColor(1, 1, 1, 1)
		end

		gfx.setFont(assets.full_circle_inverted)

		if vars.pause_selections[vars.pause_selection] == 'continue' then
			gfx.printf(text('continue'), vars.pos1, 112, vars.length1, 'center')
		elseif vars.pause_selections[vars.pause_selection] == 'restart' then
			gfx.printf(text('restart'), vars.pos2, 112, vars.length2, 'center')
		elseif vars.pause_selections[vars.pause_selection] == 'quit' then
			local pos
			local length
			if #vars.pause_selections == 2 then
				pos = vars.pos2
				length = vars.length2
			elseif #vars.pause_selections == 3 then
				pos = vars.pos3
				length = vars.length3
			end
			if vars.mode == 'logic' or vars.mode == 'time' or vars.mode == 'picture' or vars.mode == 'speedrun' then
				gfx.printf(text('exitmission'), pos, 112, length, 'center')
			elseif vars.mode == 'arcade' or vars.mode == 'dailyrun' then
				gfx.printf(text('endgame'), pos, 112, length, 'center')
			elseif vars.mode == 'zen' then
				gfx.printf(text('imdone'), pos, 112, length, 'center')
			end
		end

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
		else
			gfx.setFont(assets.half_circle_inverted)
		end

		for i = 1, #vars.pause_selections do
			vars['pos' .. i] = floor(400 / #vars.pause_selections) * (i - 1)
			vars['length' .. i] = floor(400 / #vars.pause_selections)
		end

		if vars.pause_selections[vars.pause_selection] ~= 'continue' then
			gfx.printf(text('continue'), vars.pos1, 112, vars.length1, 'center')
		end
		if #vars.pause_selections == 2 then
			if vars.pause_selections[vars.pause_selection] ~= 'quit' then
				if vars.mode == 'logic' or vars.mode == 'time' or vars.mode == 'picture' or vars.mode == 'speedrun' then
					gfx.printf(text('exitmission'), vars.pos2, 112, vars.length2, 'center')
				elseif vars.mode == 'arcade' or vars.mode == 'dailyrun' then
					gfx.printf(text('endgame'), vars.pos2, 112, vars.length2, 'center')
				elseif vars.mode == 'zen' then
					gfx.printf(text('imdone'), vars.pos2, 112, vars.length2, 'center')
				end
			end
		else
			if vars.pause_selections[vars.pause_selection] ~= 'restart' then
				gfx.printf(text('restart'), vars.pos2, 112, vars.length2, 'center')
			end
			if vars.pause_selections[vars.pause_selection] ~= 'quit' then
				if vars.mode == 'logic' or vars.mode == 'time' or vars.mode == 'picture' or vars.mode == 'speedrun' then
					gfx.printf(text('exitmission'), vars.pos3, 112, vars.length3, 'center')
				elseif vars.mode == 'arcade' or vars.mode == 'dailyrun' then
					gfx.printf(text('endgame'), vars.pos3, 112, vars.length3, 'center')
				elseif vars.mode == 'zen' then
					gfx.printf(text('imdone'), vars.pos3, 112, vars.length3, 'center')
				end
			end
		end
	end

	draw_on_top()
end

function game:tri(i, x, y, up, color, powerup)
	if color ~= 'none' then
		if color == 'black' then
			if save.color == 1 then
				gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			else
				gfx.setColor(0, 0, 0, 1)
			end
		elseif color == 'gray' then
			gfx.setColor(1, 1, 1, 1)
		elseif color == 'white' then
			if save.color == 1 then
				gfx.setColor(hexaplex_whites[save.hexaplex_color])
				if save.hexaplex_color == 4 or save.hexaplex_color == 6 or save.hexaplex_color == 10 or save.hexaplex_color == 11 or save.hexaplex_color == 17 or save.hexaplex_color == 18 or save.hexaplex_color == 20 or save.hexaplex_color == 21 or save.hexaplex_color == 22 or save.hexaplex_color == 24 or save.hexaplex_color == 26 then
					vars.white_is_white = true
				end
			else
				gfx.setColor(1, 1, 1, 1)
			end
		elseif color == 'whiter' then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
		end
		if up then
			gfx.polygon('fill', x, y - 25, x + 30, y + 25, x - 30, y + 25)
		else
			gfx.polygon('fill', x, y + 25, x + 30, y - 25, x - 30, y - 25)
		end
		if color == 'gray' then
			gfx.draw(vars['mesh' .. i], 0, 0)
		end
		gfx.setColor(1, 1, 1, 1)
		if up then
			gfx.draw(assets.grid_up, x - 31, y - 26)
		else
			gfx.draw(assets.grid_down, x - 31, y - 26)
		end
	end
	if powerup ~= '' then
		if save.reduceflashing or assets['powerup' .. floor(vars.powerup)] == nil then
			if up then
				if assets['powerup_' .. powerup .. '_up'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_up'], assets['powerup1'], x - 28, y - 23) end
			else
				if assets['powerup_' .. powerup .. '_down'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_down'], assets['powerup1'], x - 28, y - 23) end
			end
		else
			if up then
				if assets['powerup_' .. powerup .. '_up'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_up'], assets['powerup' .. floor(vars.powerup)], x - 28, y - 23) end
			else
				if assets['powerup_' .. powerup .. '_down'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_down'], assets['powerup' .. floor(vars.powerup)], x - 28, y - 23) end
			end
		end
	end
end

function game:swap(slot, dir)
	if not vars.active_hexa then
		vars.movesbonus = vars.movesbonus - 1
		if vars.movesbonus < 0 then vars.movesbonus = 0 end
		vars.cursor = 2.99
		vars.anim_cursor = timer.tween(0.075, vars, {cursor = 1})
		vars.moves = vars.moves + 1
		save.swaps = save.swaps + 1
		playsound(assets.sfx_swap)
		local tochange
		temp1, temp2, temp3, temp4, temp5, temp6 = self:findslot(slot)
		if slot == 1 then
			tochange = {1, 2, 3, 7, 8, 9}
		elseif slot == 2 then
			tochange = {3, 4, 5, 9, 10, 11}
		elseif slot == 3 then
			tochange = {6, 7, 8, 13, 14, 15}
		elseif slot == 4 then
			tochange = {8, 9, 10, 15, 16, 17}
		elseif slot == 5 then
			tochange = {10, 11, 12, 17, 18, 19}
		end
		if dir then
			vars.tris[tochange[2]] = temp1
			vars.tris[tochange[3]] = temp2
			vars.tris[tochange[6]] = temp3
			vars.tris[tochange[1]] = temp4
			vars.tris[tochange[4]] = temp5
			vars.tris[tochange[5]] = temp6
		else
			vars.tris[tochange[4]] = temp1
			vars.tris[tochange[1]] = temp2
			vars.tris[tochange[2]] = temp3
			vars.tris[tochange[5]] = temp4
			vars.tris[tochange[6]] = temp5
			vars.tris[tochange[3]] = temp6
		end
		self:check()
	end
end

function game:check()
	if vars.mode == "picture" then
		local picturetest = true
		for i = 1, 19 do
			local colorcheck1 = vars.tris[i].color
			local colorcheck2 = vars.goal[i].color
			if colorcheck1 ~= colorcheck2 then
				picturetest = false
				return
			end
		end
		if picturetest then
			self:endround()
		end
		return
	end
	if vars.can_do_stuff then
		local temp1
		local temp2
		local temp3
		local temp4
		local temp5
		local temp6
		local bomb_temp1
		local bomb_temp2
		local bomb_temp3
		local bomb_temp4
		local bomb_temp5
		local bomb_temp6
		local bomb_imminent = false
		local color
		for i = 1, 5 do
			temp1, temp2, temp3, temp4, temp5, temp6 = self:findslot(i)
			for i = 1, 3 do
				if i == 1 then
					color = 'white'
				elseif i == 2 then
					color = 'black'
				elseif i == 3 then
					color = 'gray'
				end
				if (temp1.color == color or temp1.powerup == 'wild') and (temp2.color == color or temp2.powerup == 'wild') and (temp3.color == color or temp3.powerup == 'wild') and (temp4.color == color or temp4.powerup == 'wild') and (temp5.color == color or temp5.powerup == 'wild') and (temp6.color == color or temp6.powerup == 'wild') then
					if temp1.powerup == 'bomb' or temp2.powerup == 'bomb' or temp3.powerup == 'bomb' or temp4.powerup == 'bomb' or temp5.powerup == 'bomb' or temp6.powerup == 'bomb' then
						bomb_temp1 = temp1
						bomb_temp2 = temp2
						bomb_temp3 = temp3
						bomb_temp4 = temp4
						bomb_temp5 = temp5
						bomb_temp6 = temp6
						bomb_imminent = true
					else
						self:hexa(temp1, temp2, temp3, temp4, temp5, temp6)
						return
					end
				end
			end
		end
		if bomb_imminent then
			self:hexa(bomb_temp1, bomb_temp2, bomb_temp3, bomb_temp4, bomb_temp5, bomb_temp6)
			return
		end
		if vars.combo > 0 then
			vars.combo = 0
		end
	end
end

function game:colorflip(temp1, temp2, temp3, temp4, temp5, temp6, yes)
	if yes then
		if save.color == 1 then
			if (vars.white_is_white) and ((temp1.color == "white" and temp1.powerup ~= "wild") or (temp2.color == "white" and temp2.powerup ~= "wild") or (temp3.color == "white" and temp3.powerup ~= "wild") or (temp4.color == "white" and temp4.powerup ~= "wild") or (temp5.color == "white" and temp5.powerup ~= "wild") or (temp6.color == "white" and temp6.powerup ~= "wild")) then
				temp1.color = "gray"
				temp2.color = "gray"
				temp3.color = "gray"
				temp4.color = "gray"
				temp5.color = "gray"
				temp6.color = "gray"
			else
				temp1.color = "whiter"
				temp2.color = "whiter"
				temp3.color = "whiter"
				temp4.color = "whiter"
				temp5.color = "whiter"
				temp6.color = "whiter"
			end
		elseif save.color == 2 then
			if (temp1.color == "white" and temp1.powerup ~= "wild") or (temp2.color == "white" and temp2.powerup ~= "wild") or (temp3.color == "white" and temp3.powerup ~= "wild") or (temp4.color == "white" and temp4.powerup ~= "wild") or (temp5.color == "white" and temp5.powerup ~= "wild") or (temp6.color == "white" and temp6.powerup ~= "wild") then
				temp1.color = "gray"
				temp2.color = "gray"
				temp3.color = "gray"
				temp4.color = "gray"
				temp5.color = "gray"
				temp6.color = "gray"
			else
				temp1.color = "white"
				temp2.color = "white"
				temp3.color = "white"
				temp4.color = "white"
				temp5.color = "white"
				temp6.color = "white"
			end
		end
	else
		temp1.color = vars.tempcolor1
		temp2.color = vars.tempcolor2
		temp3.color = vars.tempcolor3
		temp4.color = vars.tempcolor4
		temp5.color = vars.tempcolor5
		temp6.color = vars.tempcolor6
	end
end

function game:hexa(temp1, temp2, temp3, temp4, temp5, temp6)
	vars.handlers = ''
	vars.active_hexa = true
	vars.tempcolor1 = temp1.color
	vars.tempcolor2 = temp2.color
	vars.tempcolor3 = temp3.color
	vars.tempcolor4 = temp4.color
	vars.tempcolor5 = temp5.color
	vars.tempcolor6 = temp6.color
	assets.sfx_hexaprep:setPitch(1 + (0.1 * vars.combo))
	playsound(assets.sfx_hexaprep)
	rumble(0.1 + (0.1 * vars.combo), 0.1 + (0.1 * vars.combo), 0.15)
	self:colorflip(temp1, temp2, temp3, temp4, temp5, temp6, true)
	vars.hexacountdown1 = timer.after(0.1, function()
		if not save.reduceflashing then
			self:colorflip(temp1, temp2, temp3, temp4, temp5, temp6, false)
		end
	end)
	vars.hexacountdown2 = timer.after(0.2, function()
		playsound(assets.sfx_hexaprep)
		rumble(0.1 + (0.1 * vars.combo), 0.1 + (0.1 * vars.combo), 0.15)
		if save.reduceflashing then
			self:colorflip(temp1, temp2, temp3, temp4, temp5, temp6, false)
		else
			self:colorflip(temp1, temp2, temp3, temp4, temp5, temp6, true)
		end
	end)
	vars.hexacountdown3 = timer.after(0.3, function()
		if not save.reduceflashing then
			self:colorflip(temp1, temp2, temp3, temp4, temp5, temp6, false)
		end
	end)
	vars.hexacountdown4 = timer.after(0.4, function()
		if vars.can_do_stuff or (not vars.can_do_stuff and vars.ended) then
			vars.hexas = vars.hexas + 1
			save.hexas = save.hexas + 1
			vars.combo = vars.combo + 1
			shakies()
			shakies_y()
			if temp1.powerup == 'wild' or temp2.powerup == 'wild' or temp3.powerup == 'wild' or temp4.powerup == 'wild' or temp5.powerup == 'wild' or temp6.powerup == 'wild' then
				save.wild_match = save.wild_match + 1
			end
			if temp1.powerup == "double" or temp2.powerup == "double" or temp3.powerup == "double" or temp4.powerup == "double" or temp5.powerup == "double" or temp6.powerup == "double" then
				save.double_match = save.double_match + 1
				if (temp1.color == "white" and temp1.powerup ~= "wild") or (temp2.color == "white" and temp2.powerup ~= "wild") or (temp3.color == "white" and temp3.powerup ~= "wild") or (temp4.color == "white" and temp4.powerup ~= "wild") or (temp5.color == "white" and temp5.powerup ~= "wild") or (temp6.color == "white" and temp6.powerup ~= "wild") then
					vars.score = vars.score + (200 * vars.combo)
					save.total_score = save.total_score + (200 * vars.combo)
					save.white_match = save.white_match + 1
				elseif (temp1.color == "gray" and temp1.powerup ~= "wild") or (temp2.color == "gray" and temp2.powerup ~= "wild") or (temp3.color == "gray" and temp3.powerup ~= "wild") or (temp4.color == "gray" and temp4.powerup ~= "wild") or (temp5.color == "gray" and temp5.powerup ~= "wild") or (temp6.color == "gray" and temp6.powerup ~= "wild") then
					vars.score = vars.score + (300 * vars.combo)
					save.total_score = save.total_score + (300 * vars.combo)
					save.gray_match = save.gray_match + 1
				elseif (temp1.color == "black" and temp1.powerup ~= "wild") or (temp2.color == "black" and temp2.powerup ~= "wild") or (temp3.color == "black" and temp3.powerup ~= "wild") or (temp4.color == "black" and temp4.powerup ~= "wild") or (temp5.color == "black" and temp5.powerup ~= "wild") or (temp6.color == "black" and temp6.powerup ~= "wild") then
					vars.score = vars.score + (400 * vars.combo)
					save.total_score = save.total_score + (400 * vars.combo)
					save.black_match = save.black_match + 1
				end
				playsound(assets.sfx_select)
				assets.draw_label = assets.label_double
				vars.label = 400
				timer.cancel(vars.anim_label)
				vars.anim_label = timer.tween(1.2, vars, {label = -200}, 'linear', function()
					assets.draw_label = nil
				end)
				if (vars.mode == "arcade" or vars.mode == "dailyrun") and vars.can_do_stuff then
					timer.cancel(vars.anim_timer)
					if save.hardmode then
						vars.timer = min(vars.timer + (11000 * exp(-0.105 * vars.hexas)) + 1375, 60000)
						vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
							self:endround()
						end)
					else
						vars.timer = min(vars.timer + (11000 * exp(-0.105 * vars.hexas)) + 2750, 60000)
						vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
							self:endround()
						end)
					end
				end
			else
				if (temp1.color == "white" and temp1.powerup ~= "wild") or (temp2.color == "white" and temp2.powerup ~= "wild") or (temp3.color == "white" and temp3.powerup ~= "wild") or (temp4.color == "white" and temp4.powerup ~= "wild") or (temp5.color == "white" and temp5.powerup ~= "wild") or (temp6.color == "white" and temp6.powerup ~= "wild") then
					vars.score = vars.score + (100 * vars.combo)
					save.total_score = save.total_score + (100 * vars.combo)
					save.white_match = save.white_match + 1
				elseif (temp1.color == "gray" and temp1.powerup ~= "wild") or (temp2.color == "gray" and temp2.powerup ~= "wild") or (temp3.color == "gray" and temp3.powerup ~= "wild") or (temp4.color == "gray" and temp4.powerup ~= "wild") or (temp5.color == "gray" and temp5.powerup ~= "wild") or (temp6.color == "gray" and temp6.powerup ~= "wild") then
					vars.score = vars.score + (150 * vars.combo)
					save.total_score = save.total_score + (150 * vars.combo)
					save.gray_match = save.gray_match + 1
				elseif (temp1.color == "black" and temp1.powerup ~= "wild") or (temp2.color == "black" and temp2.powerup ~= "wild") or (temp3.color == "black" and temp3.powerup ~= "wild") or (temp4.color == "black" and temp4.powerup ~= "wild") or (temp5.color == "black" and temp5.powerup ~= "wild") or (temp6.color == "black" and temp6.powerup ~= "wild") then
					vars.score = vars.score + (200 * vars.combo)
					save.total_score = save.total_score + (200 * vars.combo)
					save.black_match = save.black_match + 1
				end
				if (vars.mode == "arcade" or vars.mode == "dailyrun") and vars.can_do_stuff then
					timer.cancel(vars.anim_timer)
					if save.hardmode then
						vars.timer = min(vars.timer + (7000 * exp(-0.105 * vars.hexas)) + 875, 60000)
						vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
							self:endround()
						end)
					else
						vars.timer = min(vars.timer + (7000 * exp(-0.105 * vars.hexas)) + 1750, 60000)
						vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
							self:endround()
						end)
					end
				end
			end
			vars.score = vars.score + (10 * vars.movesbonus)
			save.total_score = save.total_score + (10 * vars.movesbonus)
			vars.movesbonus = 5
			if temp1.powerup == "bomb" or temp2.powerup == "bomb" or temp3.powerup == "bomb" or temp4.powerup == "bomb" or temp5.powerup == "bomb" or temp6.powerup == "bomb" then
				save.bomb_match = save.bomb_match + 1
				for i = 1, 19 do
					newcolor, newpowerup = self:randomizetri()
					vars.tris[i] = {index = i, color = newcolor, powerup = newpowerup}
				end
				playsound(assets.sfx_boom)
				rumble(1, 1, 0.8)
				assets.draw_label = assets.label_bomb
				vars.label = 400
				timer.cancel(vars.anim_label)
				vars.anim_label = timer.tween(1.2, vars, {label = -200}, 'linear', function()
					assets.draw_label = nil
				end)
			else
				temp1.color, temp1.powerup = self:randomizetri()
				temp2.color, temp2.powerup = self:randomizetri()
				temp3.color, temp3.powerup = self:randomizetri()
				temp4.color, temp4.powerup = self:randomizetri()
				temp5.color, temp5.powerup = self:randomizetri()
				temp6.color, temp6.powerup = self:randomizetri()
				local rand = rng:random(1, 10000)
				if rand == 1 then
					playsound(assets.sfx_vine)
				else
					playsound(assets.sfx_hexa)
				end
				rumble(0.5 + (0.1 * vars.combo), 0.5 + (0.1 * vars.combo), 0.5)
			end
			vars.hexa = 1
			vars.anim_hexa = timer.tween(0.6, vars, {hexa = 13})
			if vars.mode == "logic" or vars.mode == "speedrun" then
				local logictest = true
				if vars.modifier == "board" then
					for i = 1, 19 do
						if vars.tris[i].color ~= "none" then
							logictest = false
						end
					end
				elseif vars.modifier == "black" then
					for i = 1, 19 do
						if vars.tris[i].color == "black" then
							logictest = false
						end
					end
				elseif vars.modifier == "gray" then
					for i = 1, 19 do
						if vars.tris[i].color == "gray" then
							logictest = false
						end
					end
				elseif vars.modifier == "white" then
					for i = 1, 19 do
						if vars.tris[i].color == "white" then
							logictest = false
						end
					end
				elseif vars.modifier == "2x" then
					for i = 1, 19 do
						if vars.tris[i].powerup == "double" then
							logictest = false
						end
					end
				elseif vars.modifier == "bomb" then
					for i = 1, 19 do
						if vars.tris[i].powerup == "bomb" then
							logictest = false
						end
					end
				elseif vars.modifier == "wild" then
					for i = 1, 19 do
						if vars.tris[i].powerup == "wild" then
							logictest = false
						end
					end
				end
				if logictest then
					self:endround()
				end
			end
			timer.after(0.2, function()
				vars.handlers = 'game'
				vars.active_hexa = false
				self:check()
			end)
		end
	end)
end

function game:boom(boomed)
	if vars.mode == 'arcade' or vars.mode == 'dailyrun' or vars.mode == 'zen' then
		if ((boomed and not vars.boomed) or (not boomed)) and vars.can_do_stuff then
			rumble(1, 1, 0.8)
			shakies()
			shakies_y()
			if boomed then
				vars.boomed = true
			end
			for i = 1, 19 do
				newcolor, newpowerup = self:randomizetri()
				vars.tris[i] = {index = i, color = newcolor, powerup = newpowerup}
			end
			playsound(assets.sfx_boom)
			if vars.timer ~= 45000 then
				assets.draw_label = assets.label_bomb
				vars.label = 400
				timer.cancel(vars.anim_label)
				vars.anim_label = timer.tween(1.2, vars, {label = -200}, 'linear', function()
					assets.draw_label = nil
				end)
			end
		end
	end
end

function game:findslot(slot)
	local temp1
	local temp2
	local temp3
	local temp4
	local temp5
	local temp6
	if slot == 1 then
		-- 1, 2, 3, 7, 8, 9
		temp1 = vars.tris[1]
		temp2 = vars.tris[2]
		temp3 = vars.tris[3]
		temp4 = vars.tris[7]
		temp5 = vars.tris[8]
		temp6 = vars.tris[9]
	elseif slot == 2 then
		-- 3, 4, 5, 9, 10, 11
		temp1 = vars.tris[3]
		temp2 = vars.tris[4]
		temp3 = vars.tris[5]
		temp4 = vars.tris[9]
		temp5 = vars.tris[10]
		temp6 = vars.tris[11]
	elseif slot == 3 then
		-- 6, 7, 8, 13, 14, 15
		temp1 = vars.tris[6]
		temp2 = vars.tris[7]
		temp3 = vars.tris[8]
		temp4 = vars.tris[13]
		temp5 = vars.tris[14]
		temp6 = vars.tris[15]
	elseif slot == 4 then
		-- 8, 9, 10, 15, 16, 17
		temp1 = vars.tris[8]
		temp2 = vars.tris[9]
		temp3 = vars.tris[10]
		temp4 = vars.tris[15]
		temp5 = vars.tris[16]
		temp6 = vars.tris[17]
	elseif slot == 5 then
		-- 10, 11, 12, 17, 18, 19
		temp1 = vars.tris[10]
		temp2 = vars.tris[11]
		temp3 = vars.tris[12]
		temp4 = vars.tris[17]
		temp5 = vars.tris[18]
		temp6 = vars.tris[19]
	end
	return temp1, temp2, temp3, temp4, temp5, temp6
end

function game:randomizetri()
	if vars.mode == 'speedrun' or vars.mode == 'logic' then
		color = 'none'
		powerup = ''
		return color, powerup
	else
		local randomcolor = rng:random(1, 3)
		local randompowerup = rng:random(1, 50)
		local color
		local powerup
		if randomcolor == 1 then
			color = 'black'
		elseif randomcolor == 2 then
			color = 'white'
		elseif randomcolor == 3 then
			color = 'gray'
		end
		if vars.mode == 'arcade' or vars.mode == 'dailyrun' or vars.mode == 'time' then
			if randompowerup == 1 or randompowerup == 2 or randompowerup == 3 then
				powerup = 'double'
			elseif randompowerup == 4 then
				powerup = 'bomb'
			elseif randompowerup == 5 then
				powerup = 'wild'
			else
				powerup = ''
			end
		else
			powerup = ''
		end
		return color, powerup
	end
end

function game:restart()
	fademusic(1)
	vars.score = 0
	vars.boomed = false
	vars.moves = 0
	vars.hexas = 0
	timer.cancel(vars.anim_hexa)
	vars.hexa = 11
	vars.active_hexa = false
	vars.slot = 1
	timer.cancel(vars.anim_cursor_x)
	timer.cancel(vars.anim_cursor_y)
	vars.cursor_x = 106
	vars.cursor_y = 42
	timer.cancel(vars.anim_label)
	vars.label = 400
	timer.cancel(vars.anim_timer)
	vars.timer = 45000
	vars.old_timer = 45000
	self:boom(false)
	vars.can_do_stuff = false
	vars.countdown3 = timer.after(1, function()
		playsound(assets.sfx_count)
		assets.draw_label = assets.label_3
		vars.label = 350
		vars.anim_label = timer.tween(1, vars, {label = -200})
	end)
	vars.countdown2 = timer.after(2, function()
		playsound(assets.sfx_count)
		assets.draw_label = assets.label_2
		vars.label = 350
		timer.cancel(vars.anim_label)
		vars.anim_label = timer.tween(1, vars, {label = -200})
	end)
	vars.countdown1 = timer.after(3, function()
		playsound(assets.sfx_count)
		assets.draw_label = assets.label_1
		vars.label = 350
		timer.cancel(vars.anim_label)
		vars.anim_label = timer.tween(1, vars, {label = -200})
	end)
	vars.countdowngo = timer.after(4, function()
		playsound(assets.sfx_start)
		assets.draw_label = assets.label_go
		vars.label = 400
		timer.cancel(vars.anim_label)
		vars.anim_label = timer.tween(1, vars, {label = -200}, 'linear', function()
			assets.draw_label = nil
		end)
		newmusic('audio/music/arcade' .. rng:random(1, 3) .. '.mp3', true)
		vars.can_do_stuff = true
		self:check()
		vars.anim_timer = timer.tween(vars.timer / 1000, vars, {timer = 0}, 'linear', function()
			self:endround()
		end)
	end)
end

function game:ersi()
	vars.skippedfanfare = true
	vars.handlers = 'lose'
	if vars.mode == 'zen' then
		gfx.setCanvas(assets.modal_canvas)
			gfx.push()
			gfx.origin()
			local sx, sy, sw, sh = gfx.getScissor()
			gfx.setScissor()
			gfx.setColor(1, 1, 1, 1)

			gfx.setFont(assets.full_circle_inverted)
			if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

			gfx.printf(text('zen1'), 0, 50, 480, 'center')
			if vars.moves == 1 then
				gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2b'), 0, 90, 480, 'center')
			else
				gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2a'), 0, 90, 480, 'center')
			end
			if vars.hexas == 1 then
				gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4b'), 0, 105, 480, 'center')
			else
				gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4a'), 0, 105, 480, 'center')
			end
			gfx.printf(text(vars.mode .. '_message' .. vars.messagerand), 0, 150, 380, 'center')

			if save.color == 1 then
				gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
			else
				gfx.setFont(assets.half_circle_inverted)
			end

			if save.gamepad then -- Gamepad
				gfx.print(text('a') .. text('newgame') .. text('b') .. text('back'), 40, 205)
			else
				gfx.print(start(save.primary) .. text('newgame') .. start(save.secondary) .. text('back'), 40, 205)
			end
			gfx.setScissor(sx, sy, sw, sh)
			gfx.pop()
		gfx.setCanvas()
	else
		gfx.setCanvas(assets.modal_canvas)
			gfx.push()
			gfx.origin()
			local sx, sy, sw, sh = gfx.getScissor()
			gfx.setScissor()
			gfx.setColor(1, 1, 1, 1)

			gfx.setFont(assets.full_circle_inverted)
			if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

			gfx.printf(text('score1') .. commalize(vars.score) .. text('score2'), 0, 50, 480, 'center')
			if vars.moves == 1 then
				gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2b'), 0, 90, 480, 'center')
			else
				gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2a'), 0, 90, 480, 'center')
			end
			if vars.hexas == 1 then
				gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4b'), 0, 105, 480, 'center')
			else
				gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4a'), 0, 105, 480, 'center')
			end
			gfx.printf(text(vars.mode .. '_message' .. vars.messagerand), 0, 150, 380, 'center')

			if save.color == 1 then
				gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
			else
				gfx.setFont(assets.half_circle_inverted)
			end

			if vars.mode == 'dailyrun' then
				if save.gamepad then -- Gamepad
					gfx.print(text('b') .. text('back'), 40, 205)
				else
					gfx.print(start(save.secondary) .. text('back'), 40, 205)
				end
				-- LEADERBOARDS: "Z shows scores for today. X goes back." if true
			else
				if save.gamepad then -- Gamepad
					gfx.print(text('a') .. text('newgame') .. text('b') .. text('back'), 40, 205)
				else
					gfx.print(start(save.primary) .. text('newgame') .. start(save.secondary) .. text('back'), 40, 205)
				end
			end
			gfx.setScissor(sx, sy, sw, sh)
			gfx.pop()
		gfx.setCanvas()
	end
end

function game:endround()
	fademusic(1)
	if vars.timer <= 0.1 then
		vars.timer = 0
	end
	gfx.setCanvas(assets.modal_canvas)
		gfx.push()
		local sx, sy, sw, sh = gfx.getScissor()
		gfx.setScissor()
		gfx.origin()
		gfx.clear()
		gfx.draw(assets.modal, 0, 0)
		gfx.setScissor(sx, sy, sw, sh)
		gfx.pop()
	gfx.setCanvas()
	if vars.mode == 'arcade' or vars.mode == 'dailyrun' then
		if not vars.ended then
			timer.cancel(vars.anim_timer)
			playsound(assets.sfx_end)
		end
		vars.lose = timer.after(2, function()
			if vars.active_hexa then
				self:endround()
				return
			end
			if not save.skipfanfare then
				vars.handlers = 'losing'
			end
			if vars.mode == 'dailyrun' then
				local time = os.date('!*t')
				if save.lastdaily.year == time.year and save.lastdaily.month == time.month and save.lastdaily.day == time.day then
					save.lastdaily.score = vars.score
					-- LEADERBOARDS: push highscore, depending on hardmode
					-- if successful, set save.lastdaily.sent = true
					-- else, set as false
				end
			else
				-- LEADERBOARDS: push highscore, depending on hardmode
			end
			if save.hardmode then
				if vars.score > save.hard_score and vars.mode == 'arcade' then save.hard_score = vars.score end
			else
				if vars.score > save.score and vars.mode == 'arcade' then save.score = vars.score end
			end
			-- CHEEVOS: update
			love.filesystem.write('data.json', json.encode(save))
			if not transitioning then newmusic('audio/music/lose.mp3') end
			vars.anim_modal = timer.tween(0.5, vars, {modal = 0}, 'out-back')
			if save.skipfanfare then
				self:ersi()
			else
				vars.lose1 = timer.after(0.548, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							gfx.printf(text('score1') .. commalize(vars.score) .. text('score2'), 0, 50, 480, 'center')
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose2 = timer.after(2.146, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							if vars.moves == 1 then
								gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2b'), 0, 90, 480, 'center')
							else
								gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2a'), 0, 90, 480, 'center')
							end
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose3 = timer.after(3.957, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							if vars.hexas == 1 then
								gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4b'), 0, 105, 480, 'center')
							else
								gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4a'), 0, 105, 480, 'center')
							end
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose4 = timer.after(6.138, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							gfx.printf(text(vars.mode .. '_message' .. vars.messagerand), 0, 150, 380, 'center')
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose5 = timer.after(8.976, function()
					if not vars.skippedfanfare then
						vars.handlers = 'lose'
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							if save.color == 1 then
								gfx.setFont(assets.full_circle_inverted)
								gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
							else
								gfx.setFont(assets.half_circle_inverted)
							end

							if vars.mode == 'dailyrun' then
								if save.gamepad then -- Gamepad
									gfx.print(text('b') .. text('back'), 40, 205)
								else
									gfx.print(start(save.secondary) .. text('back'), 40, 205)
								end
								-- LEADERBOARDS: "Z shows scores for today. X goes back.", if true
							else
								if save.gamepad then -- Gamepad
									gfx.print(text('a') .. text('newgame') .. text('b') .. text('back'), 40, 205)
								else
									gfx.print(start(save.primary) .. text('newgame') .. start(save.secondary) .. text('back'), 40, 205)
								end
							end
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
			end
		end)
	elseif vars.mode == 'zen' then
		if not vars.ended then
			playsound(assets.sfx_start)
		end
		vars.lose = timer.after(1, function()
			if vars.active_hexa then
				self:endround()
				return
			end
			if not save.skipfanfare then
				vars.handlers = 'losing'
			end
			love.filesystem.write('data.json', json.encode(save))
			if not transitioning then newmusic('audio/music/zen_end.mp3') end
			vars.anim_modal = timer.tween(0.5, vars, {modal = 0}, 'out-back')
			if save.skipfanfare then
				self:ersi()
			else
				vars.lose1 = timer.after(2.140, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							gfx.printf(text('zen1'), 0, 50, 480, 'center')
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose2 = timer.after(3.296, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							if vars.moves == 1 then
								gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2b'), 0, 90, 480, 'center')
							else
								gfx.printf(text('stats1') .. commalize(vars.moves) .. text('stats2a'), 0, 90, 480, 'center')
							end
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose3 = timer.after(4.152, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							if vars.hexas == 1 then
								gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4b'), 0, 105, 480, 'center')
							else
								gfx.printf(text('stats3') .. commalize(vars.hexas) .. text('stats4a'), 0, 105, 480, 'center')
							end
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose4 = timer.after(5.297, function()
					if not vars.skippedfanfare then
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							gfx.setFont(assets.full_circle_inverted)
							if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

							gfx.printf(text(vars.mode .. '_message' .. vars.messagerand), 0, 150, 380, 'center')
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
				vars.lose5 = timer.after(8.000, function()
					if not vars.skippedfanfare then
						vars.handlers = 'lose'
						gfx.setCanvas(assets.modal_canvas)
							gfx.push()
							gfx.origin()
							local sx, sy, sw, sh = gfx.getScissor()
							gfx.setScissor()
							gfx.setColor(1, 1, 1, 1)

							if save.color == 1 then
								gfx.setFont(assets.full_circle_inverted)
								gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
							else
								gfx.setFont(assets.half_circle_inverted)
							end

							if save.gamepad then -- Gamepad
								gfx.print(text('a') .. text('newgame') .. text('b') .. text('back'), 40, 205)
							else
								gfx.print(start(save.primary) .. text('newgame') .. start(save.secondary) .. text('back'), 40, 205)
							end
							gfx.setScissor(sx, sy, sw, sh)
							gfx.pop()
						gfx.setCanvas()
					end
				end)
			end
		end)
	elseif vars.mode == 'picture' then
		if not vars.ended then
			playsound(assets.sfx_start)
			if vars.mission == save.highest_mission then
				save.highest_mission = save.highest_mission + 1
			end
			if save.mission_bests['mission' .. vars.mission] == 0 or save.mission_bests['mission' .. vars.mission] > vars.moves then
				save.mission_bests['mission' .. vars.mission] = vars.moves
			end
		end
		vars.lose1 = timer.after(1.5, function()
			playsound(assets.sfx_mission)
			vars.missioncomplete = true
			-- CHEEVOS: update
			love.filesystem.write('data.json', json.encode(save))
		end)
		vars.lose2 = timer.after(3, function()
			if vars.mission ~= nil and vars.mission > 50 then
				scenemanager:transitionscene(missions, true)
			else
				scenemanager:transitionscene(missions)
			end
		end)
	elseif vars.mode == 'time' then
		if not vars.ended then
			playsound(assets.sfx_end)
			if vars.mission == save.highest_mission then
				save.highest_mission = save.highest_mission + 1
			end
			if save.mission_bests['mission' .. vars.mission] < vars.score then
				save.mission_bests['mission' .. vars.mission] = vars.score
			end
		end
		vars.lose1 = timer.after(1.5, function()
			if vars.active_hexa then
				self:endround()
				return
			end
			playsound(assets.sfx_mission)
			vars.missioncomplete = true
			-- CHEEVOS: update
			love.filesystem.write('data.json', json.encode(save))
		end)
		vars.lose2 = timer.after(3, function()
			if vars.mission ~= nil and vars.mission > 50 then
				scenemanager:transitionscene(missions, true)
			else
				scenemanager:transitionscene(missions)
			end
		end)
	elseif vars.mode == 'logic' then
		if not vars.ended then
			playsound(assets.sfx_end)
			if vars.mission == save.highest_mission then
				save.highest_mission = save.highest_mission + 1
			end
			if save.mission_bests['mission' .. vars.mission] == 0 or save.mission_bests['mission' .. vars.mission] > vars.moves then
				save.mission_bests['mission' .. vars.mission] = vars.moves
			end
		end
		vars.lose1 = timer.after(1.5, function()
			if vars.active_hexa then
				self:endround()
				return
			end
			playsound(assets.sfx_mission)
			vars.missioncomplete = true
			-- CHEEVOS: update
			love.filesystem.write('data.json', json.encode(save))
		end)
		vars.lose2 = timer.after(3, function()
			if vars.mission ~= nil and vars.mission > 50 then
				scenemanager:transitionscene(missions, true)
			else
				scenemanager:transitionscene(missions)
			end
		end)
	elseif vars.mode == 'speedrun' then
		if not vars.ended then
			playsound(assets.sfx_end)
			if vars.mission == save.highest_mission then
				save.highest_mission = save.highest_mission + 1
			end
			if save.mission_bests['mission' .. vars.mission] == 0 or save.mission_bests['mission' .. vars.mission] > vars.time then
				save.mission_bests['mission' .. vars.mission] = vars.time
			end
		end
		vars.lose1 = timer.after(1.5, function()
			if vars.active_hexa then
				self:endround()
				return
			end
			playsound(assets.sfx_mission)
			vars.missioncomplete = true
			-- CHEEVOS: update
			love.filesystem.write('data.json', json.encode(save))
		end)
		vars.lose2 = timer.after(3, function()
			if vars.mission ~= nil and vars.mission > 50 then
				scenemanager:transitionscene(missions, true)
			else
				scenemanager:transitionscene(missions)
			end
		end)
	end
	vars.can_do_stuff = false
	vars.ended = true
end

return game