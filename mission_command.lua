local gfx = love.graphics
local floor = math.floor
local random = math.random
local mission_command = {}

local tris_x = {140, 170, 200, 230, 260, 110, 140, 170, 200, 230, 260, 290, 110, 140, 170, 200, 230, 260, 290}
local tris_y = {70, 70, 70, 70, 70, 120, 120, 120, 120, 120, 120, 120, 170, 170, 170, 170, 170, 170, 170}
local tris_flip = {true, false, true, false, true, true, false, true, false, true, false, true, false, true, false, true, false, true, false}

function mission_command:enter(current, ...)
	love.window.setTitle('HEXA — Mission Command')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	-- TODO: re-interpret pause screen buttons
	-- if mode == start then 'go back' to mission screen
	-- if mode == edit then 'go back' to start, if check_validity() is true then 'export'
	-- if mode == save then 'go back' to edit

	assets = {

		full_circle = gfx.newImageFont('fonts/full-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle = gfx.newImageFont('fonts/half-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		full_circle_outline = gfx.newImageFont('fonts/full-circle-outline.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵', -2),
		mcsel = gfx.newImage('images/mcsel.png'), -- TODO: color
		ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_create.png'),
		modal = gfx.newImage('images/' .. tostring(save.color) .. '/modal_small.png'),
		x = gfx.newImage('images/x.png'), -- TODO: color
		export_complete = gfx.newImage('images/export_complete.png'), -- TODO: color
		powerup_bomb_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_bomb_up.png'),
		powerup_bomb_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_bomb_down.png'),
		powerup_double_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_double_up.png'),
		powerup_double_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_double_down.png'),
		powerup_wild_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_up.png'),
		powerup_wild_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_down.png'),
		error = gfx.newImage('images/error.png'), -- TODO: color
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_move2 = love.audio.newSource('audio/sfx/move.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
	}

	for i = 1, 5 do
		assets['powerup' .. i] = gfx.newQuad(-56 + (56 * min(i, 4)), 0, 56, 47, 224, 47)
	end

	vars = {
		custom = args[1],
		mode = 'start', -- 'start', 'edit', or 'save'
		handler = 'start', -- 'start', 'edit', 'save', 'selector', 'done'
		start_selection = 1,
		start_selections = {'type', 'timelimit', 'cleargoal', 'seed', 'start'},
		mission_type = 1,
		mission_types = {'logic', 'picture', 'speedrun', 'time'},
		time_limit = 9,
		time_limits = {'5', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55', '60'},
		clear_goal = 1,
		clear_goals = {'black', 'gray', 'white', 'wild', '2x', 'bomb', 'board'},
		seed_string = '0',
		seed = 0,
		keyboard = 'seed',
		seed_old = '0',
		picture_old = 'Object',
		author_old = save.author_name ~= '' and save.author_name or 'HEXA MASTR',
		tri = 1,
		scroll_x_target = 400,
		scroll_x = 400,
		modal = 400,
		powerup = 1,
		flash = 0.25,
		save_selection = 1,
		save_selections = {'picture_name', 'author_name', 'save'},
		picture_name = 'Object',
		author_name = save.author_name ~= '' and save.author_name or 'HEXA MASTR',
		export = {},
		puzzle_exported = false,
		waiting = true
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
	end)

	vars.anim_powerup = timer.tween(0.7, vars, {powerup = 4.99})
	vars.anim_powerup_loop = timer.every(0.7, function()
		vars.powerup = 1
		vars.anim_powerup = timer.tween(0.7, vars, {powerup = 4.99})
	end)

	-- TODO: flash loop timers

	-- TODO: scene setup
end

function mission_command:keypressed(key)
	-- TODO: input handlers
	if vars.handler == 'start' then
	elseif vars.handler == 'edit' then
	elseif vars.handler == 'save' then
	elseif vars.handler == 'selector' then
	elseif vars.handler == 'done' then
	end
end

function mission_command:update(dt)
	-- TODO: update logic
end

function mission_command:draw()
	-- TODO: draw logic
	draw_on_top()
end

-- TODO: copy in tri drawing code

-- TODO: copy in randomize tri code

-- Shuffly code from https://gist.github.com/Uradamus/10323382
function shuffle(tbl)
  for i = #tbl, 2, -1 do
	local j = math.random(i)
	tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function mission_command:check_validity()
	-- TODO: validity check logic
end

return mission_command