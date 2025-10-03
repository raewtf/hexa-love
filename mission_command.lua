local utf8 = require("utf8")
local gfx = love.graphics
local floor = math.floor
local min = math.min
local max = math.max
local mission_command = {}

local tris_x = {140, 170, 200, 230, 260, 110, 140, 170, 200, 230, 260, 290, 110, 140, 170, 200, 230, 260, 290}
local tris_y = {70, 70, 70, 70, 70, 120, 120, 120, 120, 120, 120, 120, 170, 170, 170, 170, 170, 170, 170}
local tris_flip = {true, false, true, false, true, true, false, true, false, true, false, true, false, true, false, true, false, true, false}

function mission_command:enter(current, ...)
	love.window.setTitle('HEXA — Mission Command')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {

		full_circle = gfx.newImageFont('fonts/full-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle = gfx.newImageFont('fonts/half-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒'),
		full_circle_outline = gfx.newImageFont('fonts/full-circle-outline.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵', -2),
		full_circle_outline_color = gfx.newImageFont('fonts/full-circle-outline-color.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵', -2),
		mcsel = gfx.newImage('images/mcsel.png'),
		ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_create.png'),
		modal = gfx.newImage('images/' .. tostring(save.color) .. '/modal_small.png'),
		x = gfx.newImage('images/' .. tostring(save.color) .. '/x.png'),
		command_banner = gfx.newImage('images/' .. tostring(save.color) .. '/command_banner.png'),
		command_hide = gfx.newImage('images/' .. tostring(save.color) .. '/command_hide.png'),
		export_complete = gfx.newImage('images/' .. tostring(save.color) .. '/export_complete.png'),
		cursor_white = gfx.newImage('images/' .. tostring(save.color) .. '/cursor_white.png'),
		cursor_black = gfx.newImage('images/' .. tostring(save.color) .. '/cursor_black.png'),
		powerup_bomb_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_bomb_up.png'),
		powerup_bomb_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_bomb_down.png'),
		powerup_double_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_double_up.png'),
		powerup_double_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_double_down.png'),
		powerup_wild_up = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_up.png'),
		powerup_wild_down = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_down.png'),
		powerup_wild_box = gfx.newImage('images/' .. tostring(save.color) .. '/powerup_wild_box.png'),
		error = gfx.newImage('images/' .. tostring(save.color) .. '/error.png'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_move2 = love.audio.newSource('audio/sfx/move.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		gray = gfx.newImage('images/' .. tostring(save.color) .. tostring(save.color == 1 and '/tris/' .. save.hexaplex_color or '') .. '/gray.png'),
		grid_up = gfx.newImage('images/grid_up.png'),
		grid_down = gfx.newImage('images/grid_down.png'),
		box_full = gfx.newImage('images/box_full.png'),
		box_half = gfx.newImage('images/box_half.png'),
		box_none = gfx.newImage('images/' .. tostring(save.color) .. '/box_none.png'),
		select_1 = gfx.newImage('images/' .. tostring(save.color) .. '/select_1.png'),
		select_2 = gfx.newImage('images/' .. tostring(save.color) .. '/select_2.png'),
		select_3 = gfx.newImage('images/' .. tostring(save.color) .. '/select_3.png'),
		selector_hide = gfx.newImage('images/' .. tostring(save.color) .. '/selector_hide.png'),
	}

	for i = 1, 5 do
		assets['powerup' .. i] = gfx.newQuad(-56 + (56 * min(i, 4)), 0, 56, 47, 224, 47)
	end

	vars = {
		custom = args[1],
		mode = 'start', -- 'start', 'edit', or 'save'
		handler = 'start', -- 'start', 'keyboard', 'edit', 'save', 'selector', 'done'
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
		error_x_target = -355,
		error_x = -355,
		modal = 400,
		powerup = 1,
		flash = 1,
		save_selection = 1,
		save_selections = {'picture_name', 'author_name', 'save'},
		picture_name = 'Object',
		author_name = save.author_name ~= '' and save.author_name or 'HEXA MASTR',
		export = {},
		puzzle_exported = false,
		waiting = true,
		selector_opened = false,
		selector_show_powerup = true,
		selector_show_no_color = true,
		selector_rack = 1,
		selector_rack1selection = 1,
		selector_rack2selection = 1,
		can_type = true,
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
	end)

	for i = 1, 19 do
		if tris_flip[i] then
			vars['mesh' .. i] = gfx.newMesh({{tris_x[i], tris_y[i] - 25, 0.5, 0}, {tris_x[i] + 30, tris_y[i] + 25, 1, 1}, {tris_x[i] - 30, tris_y[i] + 25, 0, 1}}, 'triangles', 'static')
		else
			vars['mesh' .. i] = gfx.newMesh({{tris_x[i], tris_y[i] + 25, 0.5, 1}, {tris_x[i] + 30, tris_y[i] - 25, 1, 0}, {tris_x[i] - 30, tris_y[i] - 25, 0, 0}}, 'triangles', 'static')
		end
		vars['mesh' .. i]:setTexture(assets.gray)
	end

	vars.anim_powerup = timer.tween(0.7, vars, {powerup = 4.99})
	vars.anim_powerup_loop = timer.every(0.7, function()
		vars.powerup = 1
		vars.anim_powerup = timer.tween(0.7, vars, {powerup = 4.99})
	end)

	vars.anim_flash = timer.tween(0.5, vars, {flash = 3.99}, 'linear')
	vars.anim_flash_loop = timer.every(0.5, function()
		if vars.flash < 2 then
			vars.anim_flash = timer.tween(0.5, vars, {flash = 3.99}, 'linear')
		elseif vars.flash > 2 then
			vars.anim_flash = timer.tween(0.5, vars, {flash = 1}, 'linear')
		end
	end)

	newmusic('audio/music/zen' .. rng:random(1, 2) .. '.mp3', true)
end

function mission_command:keypressed(key)
	if not transitioning and not vars.waiting then
		if vars.handler == 'start' then
			if (save.keyboard == 1 and key == 'up') or (save.keyboard == 2 and key == 'w') then
				vars.start_selection = vars.start_selection - 1
				if vars.start_selection < 1 then vars.start_selection = #vars.start_selections end
				playsound(assets.sfx_move)
			elseif (save.keyboard == 1 and key == 'down') or (save.keyboard == 2 and key == 's') then
				vars.start_selection = vars.start_selection + 1
				if vars.start_selection > #vars.start_selections then vars.start_selection = 1 end
				playsound(assets.sfx_move)
			elseif (save.keyboard == 1 and key == 'left') or (save.keyboard == 2 and key == 'a') then
				if vars.start_selections[vars.start_selection] == 'type' then
					vars.mission_type = vars.mission_type - 1
					if vars.mission_type < 1 then vars.mission_type = #vars.mission_types end
					playsound(assets.sfx_move)
				elseif vars.start_selections[vars.start_selection] == 'timelimit' then
					if vars.mission_types[vars.mission_type] == 'time' then
						vars.time_limit = vars.time_limit - 1
						if vars.time_limit < 1 then vars.time_limit = #vars.time_limits end
						playsound(assets.sfx_move)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.start_selections[vars.start_selection] == 'cleargoal' then
					if vars.mission_types[vars.mission_type] == 'speedrun' or vars.mission_types[vars.mission_type] == 'logic' then
						vars.clear_goal = vars.clear_goal - 1
						if vars.clear_goal < 1 then vars.clear_goal = #vars.clear_goals end
						playsound(assets.sfx_move)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'right') or (save.keyboard == 2 and key == 'd') then
				if vars.start_selections[vars.start_selection] == 'type' then
					vars.mission_type = vars.mission_type + 1
					if vars.mission_type > #vars.mission_types then vars.mission_type = 1 end
					playsound(assets.sfx_move)
				elseif vars.start_selections[vars.start_selection] == 'timelimit' then
					if vars.mission_types[vars.mission_type] == 'time' then
						vars.time_limit = vars.time_limit + 1
						if vars.time_limit > #vars.time_limits then vars.time_limit = 1 end
						playsound(assets.sfx_move)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.start_selections[vars.start_selection] == 'cleargoal' then
					if vars.mission_types[vars.mission_type] == 'speedrun' or vars.mission_types[vars.mission_type] == 'logic' then
						vars.clear_goal = vars.clear_goal + 1
						if vars.clear_goal > #vars.clear_goals then vars.clear_goal = 1 end
						playsound(assets.sfx_move)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				if vars.start_selections[vars.start_selection] == 'type' then
					vars.mission_type = vars.mission_type + 1
					if vars.mission_type > #vars.mission_types then vars.mission_type = 1 end
					playsound(assets.sfx_move)
				elseif vars.start_selections[vars.start_selection] == 'timelimit' then
					if vars.mission_types[vars.mission_type] == 'time' then
						vars.time_limit = vars.time_limit + 1
						if vars.time_limit > #vars.time_limits then vars.time_limit = 1 end
						playsound(assets.sfx_move)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.start_selections[vars.start_selection] == 'cleargoal' then
					if vars.mission_types[vars.mission_type] == 'speedrun' or vars.mission_types[vars.mission_type] == 'logic' then
						vars.clear_goal = vars.clear_goal + 1
						if vars.clear_goal > #vars.clear_goals then vars.clear_goal = 1 end
						playsound(assets.sfx_move)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.start_selections[vars.start_selection] == 'seed' then
					vars.handler = 'keyboard'
					vars.keyboard = 'seed'
					vars.seed_string = '0'
					love.keyboard.setKeyRepeat(true)
					playsound(assets.sfx_select)
					vars.can_type = false
					vars.can_type_timer = timer.after(0.1, function()
						vars.can_type = true
					end)
				elseif vars.start_selections[vars.start_selection] == 'start' then
					vars.tris = {}
					if vars.mission_types[vars.mission_type] == 'time' then
						rng:setSeed(vars.seed)
						local newcolor
						local newpowerup
						for i = 1, 19 do
							newcolor, newpowerup = self:randomizetri()
							vars.tris[i] = {index = i, color = newcolor, powerup = newpowerup}
						end
					else
						for i = 1, 19 do
							vars.tris[i] = {index = i, color = 'white', powerup = ''}
						end
					end
					vars.tri = 1
					vars.mode = 'edit'
					vars.handler = 'edit'
					vars.scroll_x_target = 800
					playsound(assets.sfx_select)
					if mission_command:check_validity() then
						vars.error_x_target = -355
					elseif vars.error_x_target ~= 5 then
						vars.error_x_target = 5
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
				fademusic()
				playsound(assets.sfx_back)
				scenemanager:transitionscene(missions, vars.custom)
			end
		elseif vars.handler == 'keyboard' then
			if key == 'return' then
				mission_command:hide_keyboard()
			elseif key == 'backspace' then
				if vars.keyboard == 'seed' then
					local byteoffset = utf8.offset(vars.seed_string, -1)
					if byteoffset then
						vars.seed_string = string.sub(vars.seed_string, 1, byteoffset - 1)
					end
					if vars.seed_string == '' then
						vars.seed_string = '0'
					end
				elseif vars.keyboard == 'picture' then
					local byteoffset = utf8.offset(vars.picture_name, -1)
					if byteoffset then
						vars.picture_name = string.sub(vars.picture_name, 1, byteoffset - 1)
					end
				elseif vars.keyboard == 'author' then
					local byteoffset = utf8.offset(vars.author_name, -1)
					if byteoffset then
						vars.author_name = string.sub(vars.author_name, 1, byteoffset - 1)
					end
				end
			end
		elseif vars.handler == 'edit' then
			if (save.keyboard == 1 and key == 'up') or (save.keyboard == 2 and key == 'w') then
				if vars.mission_types[vars.mission_type] ~= 'time' then
					if vars.tri <= 5 then
						shakies_y()
						playsound(assets.sfx_bonk)
					elseif vars.tri == 6 then
						vars.tri = 1
						playsound(assets.sfx_move2)
					elseif vars.tri == 7 then
						vars.tri = 1
						playsound(assets.sfx_move2)
					elseif vars.tri == 8 then
						vars.tri = 2
						playsound(assets.sfx_move2)
					elseif vars.tri == 9 then
						vars.tri = 3
						playsound(assets.sfx_move2)
					elseif vars.tri == 10 then
						vars.tri = 4
						playsound(assets.sfx_move2)
					elseif vars.tri == 11 then
						vars.tri = 5
						playsound(assets.sfx_move2)
					elseif vars.tri == 12 then
						vars.tri = 5
						playsound(assets.sfx_move2)
					elseif vars.tri == 13 then
						vars.tri = 6
						playsound(assets.sfx_move2)
					elseif vars.tri == 14 then
						vars.tri = 7
						playsound(assets.sfx_move2)
					elseif vars.tri == 15 then
						vars.tri = 8
						playsound(assets.sfx_move2)
					elseif vars.tri == 16 then
						vars.tri = 9
						playsound(assets.sfx_move2)
					elseif vars.tri == 17 then
						vars.tri = 10
						playsound(assets.sfx_move2)
					elseif vars.tri == 18 then
						vars.tri = 11
						playsound(assets.sfx_move2)
					elseif vars.tri == 19 then
						vars.tri = 12
						playsound(assets.sfx_move2)
					end
				end
			elseif (save.keyboard == 1 and key == 'down') or (save.keyboard == 2 and key == 's') then
				if vars.mission_types[vars.mission_type] ~= 'time' then
					if vars.tri == 1 then
						vars.tri = 7
						playsound(assets.sfx_move2)
					elseif vars.tri == 2 then
						vars.tri = 8
						playsound(assets.sfx_move2)
					elseif vars.tri == 3 then
						vars.tri = 9
						playsound(assets.sfx_move2)
					elseif vars.tri == 4 then
						vars.tri = 10
						playsound(assets.sfx_move2)
					elseif vars.tri == 5 then
						vars.tri = 11
						playsound(assets.sfx_move2)
					elseif vars.tri == 6 then
						vars.tri = 13
						playsound(assets.sfx_move2)
					elseif vars.tri == 7 then
						vars.tri = 14
						playsound(assets.sfx_move2)
					elseif vars.tri == 8 then
						vars.tri = 15
						playsound(assets.sfx_move2)
					elseif vars.tri == 9 then
						vars.tri = 16
						playsound(assets.sfx_move2)
					elseif vars.tri == 10 then
						vars.tri = 17
						playsound(assets.sfx_move2)
					elseif vars.tri == 11 then
						vars.tri = 18
						playsound(assets.sfx_move2)
					elseif vars.tri == 12 then
						vars.tri = 19
						playsound(assets.sfx_move2)
					elseif vars.tri >= 13 then
						shakies_y()
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'left') or (save.keyboard == 2 and key == 'a') then
				if vars.mission_types[vars.mission_type] ~= 'time' then
					if vars.tri == 1 then
						shakies()
						playsound(assets.sfx_bonk)
					elseif vars.tri == 2 then
						vars.tri = 1
						playsound(assets.sfx_move2)
					elseif vars.tri == 3 then
						vars.tri = 2
						playsound(assets.sfx_move2)
					elseif vars.tri == 4 then
						vars.tri = 3
						playsound(assets.sfx_move2)
					elseif vars.tri == 5 then
						vars.tri = 4
						playsound(assets.sfx_move2)
					elseif vars.tri == 6 then
						shakies()
						playsound(assets.sfx_bonk)
					elseif vars.tri == 7 then
						vars.tri = 6
						playsound(assets.sfx_move2)
					elseif vars.tri == 8 then
						vars.tri = 7
						playsound(assets.sfx_move2)
					elseif vars.tri == 9 then
						vars.tri = 8
						playsound(assets.sfx_move2)
					elseif vars.tri == 10 then
						vars.tri = 9
						playsound(assets.sfx_move2)
					elseif vars.tri == 11 then
						vars.tri = 10
						playsound(assets.sfx_move2)
					elseif vars.tri == 12 then
						vars.tri = 11
						playsound(assets.sfx_move2)
					elseif vars.tri == 13 then
						shakies()
						playsound(assets.sfx_bonk)
					elseif vars.tri == 14 then
						vars.tri = 13
						playsound(assets.sfx_move2)
					elseif vars.tri == 15 then
						vars.tri = 14
						playsound(assets.sfx_move2)
					elseif vars.tri == 16 then
						vars.tri = 15
						playsound(assets.sfx_move2)
					elseif vars.tri == 17 then
						vars.tri = 16
						playsound(assets.sfx_move2)
					elseif vars.tri == 18 then
						vars.tri = 17
						playsound(assets.sfx_move2)
					elseif vars.tri == 19 then
						vars.tri = 18
						playsound(assets.sfx_move2)
					end
				end
			elseif (save.keyboard == 1 and key == 'right') or (save.keyboard == 2 and key == 'd') then
				if vars.mission_types[vars.mission_type] ~= 'time' then
					if vars.tri == 1 then
						vars.tri = 2
						playsound(assets.sfx_move2)
					elseif vars.tri == 2 then
						vars.tri = 3
						playsound(assets.sfx_move2)
					elseif vars.tri == 3 then
						vars.tri = 4
						playsound(assets.sfx_move2)
					elseif vars.tri == 4 then
						vars.tri = 5
						playsound(assets.sfx_move2)
					elseif vars.tri == 5 then
						shakies()
						playsound(assets.sfx_bonk)
					elseif vars.tri == 6 then
						vars.tri = 7
						playsound(assets.sfx_move2)
					elseif vars.tri == 7 then
						vars.tri = 8
						playsound(assets.sfx_move2)
					elseif vars.tri == 8 then
						vars.tri = 9
						playsound(assets.sfx_move2)
					elseif vars.tri == 9 then
						vars.tri = 10
						playsound(assets.sfx_move2)
					elseif vars.tri == 10 then
						vars.tri = 11
						playsound(assets.sfx_move2)
					elseif vars.tri == 11 then
						vars.tri = 12
						playsound(assets.sfx_move2)
					elseif vars.tri == 12 then
						shakies()
						playsound(assets.sfx_bonk)
					elseif vars.tri == 13 then
						vars.tri = 14
						playsound(assets.sfx_move2)
					elseif vars.tri == 14 then
						vars.tri = 15
						playsound(assets.sfx_move2)
					elseif vars.tri == 15 then
						vars.tri = 16
						playsound(assets.sfx_move2)
					elseif vars.tri == 16 then
						vars.tri = 17
						playsound(assets.sfx_move2)
					elseif vars.tri == 17 then
						vars.tri = 18
						playsound(assets.sfx_move2)
					elseif vars.tri == 18 then
						vars.tri = 19
						playsound(assets.sfx_move2)
					elseif vars.tri == 19 then
						shakies()
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				if vars.mission_types[vars.mission_type] ~= 'time' then
					local powerup = false
					local nocolor = true
					if vars.mission_types[vars.mission_type] == 'picture' then
						nocolor = false
					else
						powerup = true
					end
					mission_command:open_selector(vars.tris[vars.tri], powerup, nocolor)
					playsound(assets.sfx_select)
				end
			elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
				vars.mode = 'start'
				vars.handler = 'start'
				vars.scroll_x_target = 400
				vars.error_x_target = -355
				playsound(assets.sfx_back)
			elseif key == 'j' then
				if mission_command:check_validity() then
					vars.mode = 'save'
					vars.handler = 'save'
					vars.scroll_x_target = 1200
					playsound(assets.sfx_select)
				else
					shakies()
					playsound(assets.sfx_bonk)
				end
			end
		elseif vars.handler == 'save' then
			if (save.keyboard == 1 and key == 'up') or (save.keyboard == 2 and key == 'w') then
				vars.save_selection = vars.save_selection - 1
				if vars.save_selection < 1 then vars.save_selection = #vars.save_selections end
				playsound(assets.sfx_move)
			elseif (save.keyboard == 1 and key == 'down') or (save.keyboard == 2 and key == 's') then
				vars.save_selection = vars.save_selection + 1
				if vars.save_selection > #vars.save_selections then vars.save_selection = 1 end
				playsound(assets.sfx_move)
			elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				if vars.save_selections[vars.save_selection] == 'picture_name' then
					if vars.mission_types[vars.mission_type] == 'picture' then
						vars.handler = 'keyboard'
						vars.keyboard = 'picture'
						vars.picture_name = 'Object'
						love.keyboard.setKeyRepeat(true)
						playsound(assets.sfx_select)
						vars.can_type = false
						vars.can_type_timer = timer.after(0.1, function()
							vars.can_type = true
						end)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.save_selections[vars.save_selection] == 'author_name' then
					vars.handler = 'keyboard'
					vars.keyboard = 'author'
					vars.author_name = save.author_name ~= '' and save.author_name or 'HEXA MASTR'
					love.keyboard.setKeyRepeat(true)
					playsound(assets.sfx_select)
					vars.can_type = false
					vars.can_type_timer = timer.after(0.1, function()
						vars.can_type = true
					end)
				elseif vars.save_selections[vars.save_selection] == 'save' then
					mission_command:save()
					playsound(assets.sfx_select)
				end
			elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
				vars.mode = 'edit'
				vars.handler = 'edit'
				vars.scroll_x_target = 800
				playsound(assets.sfx_back)
			end
		elseif vars.handler == 'selector' then
			-- TOOD: selector handlers
			if (save.keyboard == 1 and key == 'up') or (save.keyboard == 2 and key == 'w') then
				if vars.selector_rack ~= 1 then
					vars.selector_rack = 1
					playsound(assets.sfx_move)
				else
					shakies_y()
					playsound(assets.sfx_bonk)
				end
			elseif (save.keyboard == 1 and key == 'down') or (save.keyboard == 2 and key == 's') then
				if vars.selector_show_powerup and vars.selector_rack == 1 then
					vars.selector_rack = 2
					playsound(assets.sfx_move)
				else
					shakies_y()
					playsound(assets.sfx_bonk)
				end
			elseif (save.keyboard == 1 and key == 'left') or (save.keyboard == 2 and key == 'a') then
				if vars.selector_rack == 1 then
					if vars.selector_rack2selection ~= 4 then
						vars.selector_rack1selection = vars.selector_rack1selection - 1
						if vars.selector_rack1selection < 1 then
							vars.selector_rack1selection = 1
							shakies()
							playsound(assets.sfx_bonk)
						else
							playsound(assets.sfx_move)
						end
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				else
					if not (vars.selector_show_no_color and vars.selector_rack1selection == 1) then
						vars.selector_rack2selection = vars.selector_rack2selection - 1
						if vars.selector_rack2selection < 1 then
							vars.selector_rack2selection = 1
							shakies()
							playsound(assets.sfx_bonk)
						else
							playsound(assets.sfx_move)
						end
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'right') or (save.keyboard == 2 and key == 'd') then
				if vars.selector_rack == 1 then
					if vars.selector_rack2selection ~= 4 then
						vars.selector_rack1selection = vars.selector_rack1selection + 1
						local limit = 3
						if vars.selector_show_no_color then
							limit = 4
						end
						if vars.selector_rack1selection > limit then
							vars.selector_rack1selection = limit
							shakies()
							playsound(assets.sfx_bonk)
						else
							playsound(assets.sfx_move)
						end
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				else
					if not (vars.selector_show_no_color and vars.selector_rack1selection == 1) then
						vars.selector_rack2selection = vars.selector_rack2selection + 1
						if vars.selector_rack2selection > 4 then
							vars.selector_rack2selection = 4
							shakies()
							playsound(assets.sfx_bonk)
						else
							playsound(assets.sfx_move)
						end
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				end
			elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				mission_command:close_selector(true)
				playsound(assets.sfx_select)
				if mission_command:check_validity() then
					vars.error_x_target = -355
				elseif vars.error_x_target ~= 5 then
					vars.error_x_target = 5
					playsound(assets.sfx_bonk)
				end
			elseif (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
				mission_command:close_selector(false)
				playsound(assets.sfx_back)
				if mission_command:check_validity() then
					vars.error_x_target = -355
				elseif vars.error_x_target ~= 5 then
					vars.error_x_target = 5
					playsound(assets.sfx_bonk)
				end
			end
		elseif vars.handler == 'done' then
			if (save.keyboard == 1 and key == 'x') or (save.keyboard == 2 and key == '.') then
				scenemanager:transitionscene(missions, vars.custom)
				fademusic()
			elseif (save.keyboard == 1 and key == 'z') or (save.keyboard == 2 and key == ',') then
				local realdir = love.filesystem.getRealDirectory('missions/')
				love.system.openURL('file://' .. realdir .. '/missions/')
			end
		end
	end
end

function mission_command:update(dt)
	vars.scroll_x = vars.scroll_x + ((vars.scroll_x_target - vars.scroll_x) * 0.4)
	if (vars.scroll_x > vars.scroll_x_target - 0.05 and vars.scroll_x < vars.scroll_x_target + 0.05) and vars.scroll_x ~= vars.scroll_x_target then
		vars.scroll_x = vars.scroll_x_target
	end
	vars.error_x = vars.error_x + ((vars.error_x_target - vars.error_x) * 0.4)
end

function mission_command:draw()
	x = -floor(vars.scroll_x) + 400
	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
	else
		gfx.setColor(1, 1, 1, 1)
	end
	gfx.rectangle('fill', 0, 0, 1200, 240)

	gfx.draw(assets.command_banner, 0, 0)

	gfx.setFont(assets.full_circle)

	gfx.setLineWidth(2)

	-- Start

	if save.color == 1 then
		gfx.setFont(assets.full_circle_inverted)
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
	end
	gfx.print('Mission Command', 10 + x, 10)
	if save.color == 1 then
		gfx.setFont(assets.full_circle)
		gfx.setColor(1, 1, 1, 1)
	end

	gfx.print('Mission Type:', 50 + x, 50)

	local text
	if vars.mission_types[vars.mission_type] == 'logic' then
		text = 'Logic'
	elseif vars.mission_types[vars.mission_type] == 'picture' then
		text = 'Picture'
	elseif vars.mission_types[vars.mission_type] == 'speedrun' then
		text = 'Speedrun'
	elseif vars.mission_types[vars.mission_type] == 'time' then
		text = 'Time Attack'
	end
	gfx.printf(text, x, 50, 546, 'center')

	gfx.print('Time Limit:', 50 + x, 93)
	gfx.printf(tostring(vars.time_limits[vars.time_limit]) .. 's', x, 100, 546, 'center')

	gfx.print('Clear Goal:', 50 + x, 123)

	if vars.clear_goals[vars.clear_goal] == 'black' then
		text = 'Dark tris'
	elseif vars.clear_goals[vars.clear_goal] == 'gray' then
		text = 'Dithered tris'
	elseif vars.clear_goals[vars.clear_goal] == 'white' then
		text = 'Light tris'
	elseif vars.clear_goals[vars.clear_goal] == 'wild' then
		text = 'Wild tris'
	elseif vars.clear_goals[vars.clear_goal] == '2x' then
		text = '2x tris'
	elseif vars.clear_goals[vars.clear_goal] == 'bomb' then
		text = 'Bombs'
	elseif vars.clear_goals[vars.clear_goal] == 'board' then
		text = 'HEXAPLEX'
	end
	gfx.printf(text, x, 130, 546, 'center')

	gfx.print('Number Seed:', 50 + x, 153)
	gfx.printf(tonumber(vars.seed_string), x, 160, 546, 'center')

	gfx.printf('Start Editing', x, 195, 400, 'center')

	-- Edit

	if save.color == 1 then
		gfx.setFont(assets.full_circle_inverted)
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
	end
	if vars.error_x < -200 then
		if vars.mission_types[vars.mission_type] == 'picture' then
			gfx.print('Create Picture', 410 + x, 10)
		elseif vars.mission_types[vars.mission_type] == 'time' then
			gfx.print('Review Seeded HEXAPLEX', 410 + x, 10)
		else
			gfx.print('Create Starting HEXAPLEX', 410 + x, 10)
		end
	end
	if save.color == 1 then
		gfx.setFont(assets.full_circle)
		gfx.setColor(1, 1, 1, 1)
	end

	-- Save

	if save.color == 1 then
		gfx.setFont(assets.full_circle_inverted)
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
	end
	gfx.print('Export', 810 + x, 10)
	if save.color == 1 then
		gfx.setFont(assets.full_circle)
		gfx.setColor(1, 1, 1, 1)
	end

	gfx.print('Mission Type:', 850 + x, 50)

	local text
	if vars.mission_types[vars.mission_type] == 'logic' then
		text = 'Logic'
	elseif vars.mission_types[vars.mission_type] == 'picture' then
		text = 'Picture'
	elseif vars.mission_types[vars.mission_type] == 'speedrun' then
		text = 'Speedrun'
	elseif vars.mission_types[vars.mission_type] == 'time' then
		text = 'Time Attack'
	end
	gfx.printf(text, x, 50, 1150, 'right')

	gfx.print('Picture Name:', 850 + x, 93)
	gfx.printf(vars.picture_name, x, 100, 2146, 'center')

	gfx.print('Author Name:', 850 + x, 130)
	gfx.printf(vars.author_name, x, 130, 2146, 'center')

	gfx.printf('Export', x, 180, 2000, 'center')

	gfx.setColor(0, 0, 0, 1)

	-- Start

	gfx.rectangle('line', 195 + x, 47, 155, 20)
	gfx.rectangle('line', 195 + x, 97, 155, 20)
	gfx.rectangle('line', 195 + x, 127, 155, 20)
	if vars.handler == 'keyboard' and vars.keyboard == 'seed' then
		gfx.setLineWidth(4)
		gfx.rectangle('line', 195 + x, 157, 155, 20)
		gfx.setLineWidth(2)
	else
		gfx.rectangle('line', 195 + x, 157, 155, 20)
	end
	gfx.rectangle('line', 100 + x, 190, 200, 25)

	-- Save

	if vars.handler == 'keyboard' and vars.keyboard == 'picture' then
		gfx.setLineWidth(4)
		gfx.rectangle('line', 995 + x, 97, 155, 20)
		gfx.setLineWidth(2)
	else
		gfx.rectangle('line', 995 + x, 97, 155, 20)
	end
	if vars.handler == 'keyboard' and vars.keyboard == 'author' then
		gfx.setLineWidth(4)
		gfx.rectangle('line', 995 + x, 127, 155, 20)
		gfx.setLineWidth(2)
	else
		gfx.rectangle('line', 995 + x, 127, 155, 20)
	end
	gfx.rectangle('line', 900 + x, 175, 200, 25)

	gfx.setColor(1, 1, 1, 1)

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(95, 87, 79, 255))
		gfx.setFont(assets.full_circle_inverted)
	else
		gfx.setFont(assets.half_circle)
	end

	-- Start

	gfx.print('(Time Attack)', 50 + x, 107)
	gfx.print('(Logic/Speedrun)', 50 + x, 137)
	gfx.print('(Time Attack)', 50 + x, 167)

	if vars.mission_types[vars.mission_type] == 'logic' then
		text = 'Clear the stuff in as few Swaps as possible!'
	elseif vars.mission_types[vars.mission_type] == 'picture' then
		text = 'Make the picture in as few Swaps as possible!'
	elseif vars.mission_types[vars.mission_type] == 'speedrun' then
		text = 'Clear the stuff in as little time as possible!'
	elseif vars.mission_types[vars.mission_type] == 'time' then
		text = 'Get as many points as you can in the time limit!'
	end

	gfx.printf(text, 0 + x, 70, 400, 'center')

	if vars.handler == 'keyboard' then
		gfx.print('The keys type. ENTER/Return accepts.', 10 + x, 220)
	else
		if save.gamepad then
			gfx.print('The D-pad moves. A scrolls. B goes back.', 10 + x, 220)
		elseif save.keyboard == 1 then
			gfx.print('The arrows move. Z scrolls. X goes back.', 10 + x, 220)
		elseif save.keyboard == 2 then
			gfx.print('WASD moves. , scrolls. . goes back.', 10 + x, 220)
		end
	end

	-- Edit

	if vars.mission_types[vars.mission_type] == 'time' then
		if save.gamepad then
			gfx.print('B goes back. X exports.', 410 + x, 220)
		elseif save.keyboard == 1 then
			gfx.print('X goes back. J exports.', 410 + x, 220)
		elseif save.keyboard == 2 then
			gfx.print('. goes back. J exports.', 410 + x, 220)
		end
	else
		if save.gamepad then
			gfx.print('The D-pad moves. A picks. B goes back. X exports.', 410 + x, 220)
		elseif save.keyboard == 1 then
			gfx.print('The arrows move. Z picks. X goes back. J exports.', 410 + x, 220)
		elseif save.keyboard == 2 then
			gfx.print('WASD moves. , picks. . goes back. J exports.', 410 + x, 220)
		end
	end

	-- Save

	if vars.mission_types[vars.mission_type] == 'logic' then
		text = 'Clear the stuff in as few Swaps as possible!'
	elseif vars.mission_types[vars.mission_type] == 'picture' then
		text = 'Make the picture in as few Swaps as possible!'
	elseif vars.mission_types[vars.mission_type] == 'speedrun' then
		text = 'Clear the stuff in as little time as possible!'
	elseif vars.mission_types[vars.mission_type] == 'time' then
		text = 'Get as many points as you can in the time limit!'
	end

	gfx.printf(text, 0 + x, 70, 2000, 'center')

	gfx.print('(Picture)', 850 + x, 107)

	if vars.handler == 'keyboard' then
		gfx.print('The keys type. ENTER/Return accepts.', 810 + x, 220)
	else
		if save.gamepad then
			gfx.print('The D-pad moves. A scrolls. B goes back.', 810 + x, 220)
		elseif save.keyboard == 1 then
			gfx.print('The arrows move. Z scrolls. X goes back.', 810 + x, 220)
		elseif save.keyboard == 2 then
			gfx.print('WASD moves. , scrolls. . goes back.', 810 + x, 220)
		end
	end

	gfx.setColor(1, 1, 1, 1)

	-- Start

	if vars.mission_types[vars.mission_type] ~= 'time' then
		gfx.draw(assets.command_hide, x, 89)
		gfx.draw(assets.command_hide, x, 151)
	end
	if vars.mission_types[vars.mission_type] ~= 'speedrun' and vars.mission_types[vars.mission_type] ~= 'logic' then
		gfx.draw(assets.command_hide, x, 119)
	end

	-- Save

	if vars.mission_types[vars.mission_type] ~= 'picture' then
		gfx.draw(assets.command_hide, 800 + x, 89)
	end

	-- Start

	if vars.start_selection == 1 then
		gfx.draw(assets.mcsel, x, 46)
		gfx.draw(assets.mcsel, 400 + x, 46, 0, -1, 1)
	elseif vars.start_selection == 2 then
		gfx.draw(assets.mcsel, x, 96)
		gfx.draw(assets.mcsel, 400 + x, 96, 0, -1, 1)
	elseif vars.start_selection == 3 then
		gfx.draw(assets.mcsel, x, 126)
		gfx.draw(assets.mcsel, 400 + x, 126, 0, -1, 1)
	elseif vars.start_selection == 4 then
		gfx.draw(assets.mcsel, x, 156)
		gfx.draw(assets.mcsel, 400 + x, 156, 0, -1, 1)
	elseif vars.start_selection == 5 then
		gfx.draw(assets.mcsel, x, 192)
		gfx.draw(assets.mcsel, 400 + x, 192, 0, -1, 1)
	end

	-- Save

	if vars.save_selection == 1 then
		gfx.draw(assets.mcsel, 800 + x, 96)
		gfx.draw(assets.mcsel, 1200 + x, 96, 0, -1, 1)
	elseif vars.save_selection == 2 then
		gfx.draw(assets.mcsel, 800 + x, 126)
		gfx.draw(assets.mcsel, 1200 + x, 126, 0, -1, 1)
	elseif vars.save_selection == 3 then
		gfx.draw(assets.mcsel, 800 + x, 176)
		gfx.draw(assets.mcsel, 1200 + x, 176, 0, -1, 1)
	end

	-- Edit

	gfx.draw(assets.ui, 400 + x, 0)
	if vars.tris ~= nil then
		for i = 1, 19 do
			self:tri(i, tris_x[i] + 401 + x, tris_y[i], tris_flip[i], vars.tris[i].color, vars.tris[i].powerup)
		end
		local offset = 0
		if tris_flip[vars.tri] then
			offset = offset + 8
		else
			offset = offset - 8
		end
		if vars.mission_types[vars.mission_type] ~= 'time' then
			if vars.tris[vars.tri].color == 'black' then
				gfx.draw(assets.cursor_white, tris_x[vars.tri] + 389 + x, tris_y[vars.tri] + offset - 11)
			else
				gfx.draw(assets.cursor_black, tris_x[vars.tri] + 389 + x, tris_y[vars.tri] + offset - 11)
			end
		end
	end

	local modal = floor(vars.modal) + 35
	gfx.draw(assets.modal, 46, modal)
	if vars.selector_show_powerup then
		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
		else
			gfx.setColor(1, 1, 1, 1)
		end
		if vars.selector_rack == 1 then
			gfx.rectangle('fill', 96, 11 + modal, 200, 16)
		else
			gfx.rectangle('fill', 96, 90 + modal, 200, 16)
		end
	end
	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end
	if vars.selector_show_powerup then
		if vars.selector_rack == 1 then
			gfx.setFont(assets.full_circle)
			gfx.setColor(1, 1, 1, 1)
		end
		gfx.printf('Choose a tri color:', 0, 12 + modal, 400, 'center')
		if vars.selector_rack == 2 then
			gfx.setFont(assets.full_circle)
			gfx.setColor(1, 1, 1, 1)
		else
			gfx.setFont(assets.full_circle_inverted)
			if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end
		end
		gfx.printf('Choose a tri Power-up:', 0, 90 + modal, 400, 'center')
	else
		gfx.printf('Choose a tri color:', 0, 46 + modal, 400, 'center')
	end
	gfx.setColor(1, 1, 1, 1)
	if vars.selector_show_powerup then
		gfx.draw(assets.x, 96, 116 + modal)
		if save.reduceflashing or assets['powerup' .. floor(vars.powerup)] == nil then
			if assets['powerup_double_up'] ~= nil then gfx.draw(assets['powerup_double_up'], assets['powerup1'], 91 + 46, 104 + modal) end
			if assets['powerup_bomb_up'] ~= nil then gfx.draw(assets['powerup_bomb_up'], assets['powerup1'], 148 + 46, 104 + modal) end
			if assets['powerup_wild_box'] ~= nil then gfx.draw(assets['powerup_wild_box'], assets['powerup1'], 203 + 46, 104 + modal) end
		else
			if assets['powerup_double_up'] ~= nil then gfx.draw(assets['powerup_double_up'], assets['powerup' .. floor(vars.powerup)], 91 + 46, 104 + modal) end
			if assets['powerup_bomb_up'] ~= nil then gfx.draw(assets['powerup_bomb_up'], assets['powerup' .. floor(vars.powerup)], 148 + 46, 104 + modal) end
			if assets['powerup_wild_box'] ~= nil then gfx.draw(assets['powerup_wild_box'], assets['powerup' .. floor(vars.powerup)], 203 + 46, 104 + modal) end
		end
		if vars.selector_show_no_color then
			gfx.draw(assets.x, 96, 38 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_whites[save.hexaplex_color])
			end
			gfx.draw(assets.box_full, 156 - 55 + 46, 35 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 + 46, 35 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(1, 1, 1, 1)
			end
			gfx.draw(assets.box_half, 156 + 46, 35 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 + 55 + 46, 35 + modal)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets.box_none, 156 + 55 + 46, 35 + modal)
		else
			if save.color == 1 then
				gfx.setColor(hexaplex_whites[save.hexaplex_color])
			end
			gfx.draw(assets.box_full, 156 - 77 + 46, 35 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 - 22 + 46, 35 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(1, 1, 1, 1)
			end
			gfx.draw(assets.box_half, 156 - 22 + 46, 35 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 + 33 + 46, 35 + modal)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets.box_none, 156 + 33 + 46, 35 + modal)
		end

		if vars.selector_rack2selection == 4 then
			gfx.draw(assets.selector_hide, 30 + 46, 31 + modal)
		else
			if vars.selector_show_no_color and vars.selector_rack1selection == 1 then
				gfx.draw(assets.selector_hide, 30 + 46, 109 + modal)
			end
		end

		local flash = floor(vars.flash)
		if flash < 1 then flash = 1 end
		if flash > 3 then flash = 3 end
		if vars.selector_rack2selection ~= 4 then
			if vars.selector_show_no_color then
				gfx.draw(assets['select_' .. flash], 152 - 165 + (55 * vars.selector_rack1selection) + 46, 31 + modal)
			else
				gfx.draw(assets['select_' .. flash], 152 - 132 + (55 * vars.selector_rack1selection) + 46, 31 + modal)
			end
		end
		if not (vars.selector_show_no_color and vars.selector_rack1selection == 1) then
			gfx.draw(assets['select_' .. flash], 152 - 165 + (55 * vars.selector_rack2selection) + 46, 109 + modal)
		end
	else
		if vars.selector_show_no_color then
			gfx.draw(assets.x, 96, 78 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_whites[save.hexaplex_color])
			end
			gfx.draw(assets.box_full, 156 - 55 + 46, 75 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 + 46, 75 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(1, 1, 1, 1)
			end
			gfx.draw(assets.box_half, 156 + 46, 75 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 + 55 + 46, 75 + modal)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets.box_none, 156 + 55 + 46, 75 + modal)
		else
			if save.color == 1 then
				gfx.setColor(hexaplex_whites[save.hexaplex_color])
			end
			gfx.draw(assets.box_full, 156 - 77 + 46, 75 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 - 22 + 46, 75 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(1, 1, 1, 1)
			end
			gfx.draw(assets.box_half, 156 - 22 + 46, 75 + modal)
			if save.color == 1 then
				gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			elseif save.color == 2 then
				gfx.setColor(0, 0, 0, 1)
			end
			gfx.draw(assets.box_full, 156 + 33 + 46, 75 + modal)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets.box_none, 156 + 33 + 46, 75 + modal)
		end

		local flash = floor(vars.flash)
		if flash < 1 then flash = 1 end
		if flash > 3 then flash = 3 end
		if vars.selector_show_no_color then
			gfx.draw(assets['select_' .. flash], 152 - 165 + (55 * vars.selector_rack1selection) + 46, 71 + modal)
		else
			gfx.draw(assets['select_' .. flash], 152 - 132 + (55 * vars.selector_rack1selection) + 46, 71 + modal)
		end
	end

	if save.color == 1 then
		gfx.setFont(assets.full_circle_outline_color)
	else
		gfx.setFont(assets.full_circle_outline)
	end
	gfx.draw(assets.error, 5 + floor(vars.error_x), 3)
	gfx.print('Can\'t clear the mission in this state!', 36 + floor(vars.error_x), 8)

	if vars.puzzle_exported then
		gfx.draw(assets.export_complete, 800 + x, 0)

		gfx.setFont(assets.full_circle_inverted)
		if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

		local realdir = love.filesystem.getRealDirectory('missions/')
		gfx.printf('Your Mission\'s been saved to:\n' .. realdir .. '/missions/' .. tostring(vars.export.mission) .. '.json', 800 + x, 128, 400, 'center')

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
		else
			gfx.setFont(assets.half_circle_inverted)
		end

		gfx.printf('Share it! https://rae.wtf/blog/hexa-manual', x, 187, 2000, 'center')

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(95, 87, 79, 255))
			gfx.setFont(assets.full_circle_inverted)
		else
			gfx.setFont(assets.half_circle)
		end

		if save.gamepad then
			gfx.print('A opens Mission directory. B goes back.', 810 + x, 220)
		elseif save.keyboard == 1 then
			gfx.print('Z opens Mission directory. X goes back.', 810 + x, 220)
		elseif save.keyboard == 2 then
			gfx.print(', opens Mission directory. . goes back.', 810 + x, 220)
		end
	end

	draw_on_top()
end

function mission_command:textinput(text)
	if vars.handler == 'keyboard' and vars.can_type then
		if vars.keyboard == 'seed' then
			if vars.seed_string == '' then
				vars.seed_string = '0'
			end
			vars.seed_string = vars.seed_string .. text
			if vars.seed_string ~= tonumber(vars.seed_string) then
				vars.seed_string = vars.seed_string:gsub("%D+", ""):sub(1, 10)
			else
				vars.seed_string = vars.seed_string:sub(1, 10)
			end
		elseif vars.keyboard == 'picture' then
			if vars.picture_name == 'Object' then vars.picture_name = '' end
			vars.picture_name = string.sub(vars.picture_name .. text, 1, 10)
		elseif vars.keyboard == 'author' then
			if vars.author_name == 'HEXA MASTR' then vars.author_name = '' end
			vars.author_name = string.sub(vars.author_name .. text, 1, 10)
		end
	end
end

function mission_command:hide_keyboard()
	love.keyboard.setKeyRepeat(false)
	playsound(assets.sfx_select)
	if vars.keyboard == 'seed' then
		vars.seed = tonumber(vars.seed_string)
		vars.handler = 'start'
	elseif vars.keyboard == 'picture' then
		vars.handler = 'save'
		if vars.picture_name == '' then
			vars.picture_name = 'Object'
		end
	elseif vars.keyboard == 'author' then
		vars.handler = 'save'
		if vars.author_name == '' then
			vars.author_name = save.author_name ~= '' and save.author_name or 'HEXA MASTR'
		end
	end
end

function mission_command:tri(i, x, y, up, color, powerup)
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
		end
		if up then
			gfx.polygon('fill', x, y - 25, x + 30, y + 25, x - 30, y + 25)
		else
			gfx.polygon('fill', x, y + 25, x + 30, y - 25, x - 30, y - 25)
		end
		if color == 'gray' then
			gfx.draw(vars['mesh' .. i], 0 + -floor(vars.scroll_x) + 800, 0)
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

function mission_command:open_selector(tri, show_powerup, show_no_color)
	vars.selector_show_powerup = show_powerup
	vars.selector_show_no_color = show_no_color
	if vars.selector_show_powerup then
		if tri.powerup == '' then
			vars.selector_rack2selection = 1
		elseif tri.powerup == 'double' then
			vars.selector_rack2selection = 2
		elseif tri.powerup == 'bomb' then
			vars.selector_rack2selection = 3
		elseif tri.powerup == 'wild' then
			vars.selector_rack2selection = 4
		else
			vars.selector_rack2selection = 1
		end
	end
	if vars.selector_show_no_color then
		if tri.color == 'none' then
			vars.selector_rack1selection = 1
		elseif tri.color == 'white' then
			vars.selector_rack1selection = 2
		elseif tri.color == 'gray' then
			vars.selector_rack1selection = 3
		elseif tri.color == 'black' then
			vars.selector_rack1selection = 4
		else
			vars.selector_rack1selection = 1
		end
	else
		if tri.color == 'white' then
			vars.selector_rack1selection = 1
		elseif tri.color == 'gray' then
			vars.selector_rack1selection = 2
		elseif tri.color == 'black' then
			vars.selector_rack1selection = 3
		else
			vars.selector_rack1selection = 1
		end
	end
	vars.selector_rack = 1
	vars.handler = ''
	vars.anim_modal = timer.tween(0.3, vars, {modal = 0}, 'out-back', function()
		vars.selector_opened = true
		vars.handler = 'selector'
	end)
end

function mission_command:close_selector(save)
	if save then
		if vars.selector_show_no_color then
			if vars.selector_rack1selection == 1 then
				vars.tris[vars.tri].color = 'none'
			elseif vars.selector_rack1selection == 2 then
				vars.tris[vars.tri].color = 'white'
			elseif vars.selector_rack1selection == 3 then
				vars.tris[vars.tri].color = 'gray'
			elseif vars.selector_rack1selection == 4 then
				vars.tris[vars.tri].color = 'black'
			end
		else
			if vars.selector_rack1selection == 1 then
				vars.tris[vars.tri].color = 'white'
			elseif vars.selector_rack1selection == 2 then
				vars.tris[vars.tri].color = 'gray'
			elseif vars.selector_rack1selection == 3 then
				vars.tris[vars.tri].color = 'black'
			end
		end
		if vars.selector_show_powerup then
			if (vars.selector_show_no_color and vars.selector_rack1selection == 1) then
				vars.tris[vars.tri].powerup = ''
			else
				if vars.selector_rack2selection == 1 then
					vars.tris[vars.tri].powerup = ''
				elseif vars.selector_rack2selection == 2 then
					vars.tris[vars.tri].powerup = 'double'
				elseif vars.selector_rack2selection == 3 then
					vars.tris[vars.tri].powerup = 'bomb'
				elseif vars.selector_rack2selection == 4 then
					vars.tris[vars.tri].powerup = 'wild'
				end
			end
		end
	end
	vars.handler = ''
	vars.anim_modal = timer.tween(0.3, vars, {modal = 400}, 'in-back', function()
		vars.selector_opened = false
		vars.handler = vars.mode
	end)
end

function mission_command:randomizetri()
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
	if randompowerup == 1 or randompowerup == 2 or randompowerup == 3 then
		powerup = 'double'
	elseif randompowerup == 4 then
		powerup = 'bomb'
	elseif randompowerup == 5 then
		powerup = 'wild'
	else
		powerup = ''
	end
	return color, powerup
end

function mission_command:save()
	local epoch = os.time()
	if vars.mission_types[vars.mission_type] == 'picture' then
		vars.export.mission = epoch
		vars.export.type = 'picture'
		vars.export.goal = deepcopy(vars.tris)
		vars.export.start = deepcopy(vars.tris)
		shuffle(vars.export.start)
		for i = 1, 19 do
			vars.export.start[i].index = i
		end
		vars.export.name = vars.picture_name
		vars.export.author = vars.author_name
	elseif vars.mission_types[vars.mission_type] == 'time' then
		vars.export.mission = epoch
		vars.export.type = 'time'
		vars.export.seed = vars.seed
		vars.export.modifier = tonumber(vars.time_limits[vars.time_limit])
		vars.export.author = vars.author_name
	elseif vars.mission_types[vars.mission_type] == 'speedrun' then
		vars.export.mission = epoch
		vars.export.type = 'speedrun'
		vars.export.modifier = vars.clear_goals[vars.clear_goal]
		vars.export.start = vars.tris
		vars.export.author = vars.author_name
	elseif vars.mission_types[vars.mission_type] == 'logic' then
		vars.export.mission = epoch
		vars.export.type = 'logic'
		vars.export.modifier = vars.clear_goals[vars.clear_goal]
		vars.export.start = vars.tris
		vars.export.author = vars.author_name
	end
	love.filesystem.write('missions/' .. tostring(epoch) .. '.json', json.encode(vars.export))
	save.exported_mission = true
	vars.puzzle_exported = true
	vars.handler = 'done'
	save.author_name = vars.author_name
	-- CHEEVOS: update
end

-- Shuffly code from https://gist.github.com/Uradamus/10323382
function shuffle(tbl)
  for i = #tbl, 2, -1 do
	local j = rng:random(i)
	tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function mission_command:check_validity()
	if vars.mission_types[vars.mission_type] == 'logic' or vars.mission_types[vars.mission_type] == 'speedrun' then
		local black_tiles = 0
		local gray_tiles = 0
		local white_tiles = 0
		local wild_tiles = 0
		local double_black_tiles = 0
		local double_gray_tiles = 0
		local double_white_tiles = 0
		local bomb_black_tiles = 0
		local bomb_gray_tiles = 0
		local bomb_white_tiles = 0
		for i = 1, 19 do
			local tri = vars.tris[i]
			if tri.color == 'black' then
				black_tiles = black_tiles + 1
			elseif tri.color == 'gray' then
				gray_tiles = gray_tiles + 1
			elseif tri.color == 'white' then
				white_tiles = white_tiles + 1
			end
			if tri.powerup == 'wild' then
				wild_tiles = wild_tiles + 1
			elseif tri.powerup == 'double' then
				if tri.color == 'black' then
					double_black_tiles = double_black_tiles + 1
				elseif tri.color == 'gray' then
					double_gray_tiles = double_gray_tiles + 1
				elseif tri.color == 'white' then
					double_white_tiles = double_white_tiles + 1
				end
			elseif tri.powerup == 'bomb' then
				if tri.color == 'black' then
					bomb_black_tiles = bomb_black_tiles + 1
				elseif tri.color == 'gray' then
					bomb_gray_tiles = bomb_gray_tiles + 1
				elseif tri.color == 'white' then
					bomb_white_tiles = bomb_white_tiles + 1
				end
			end
		end
		if vars.clear_goals[vars.clear_goal] == 'black' then
			local exportable = false
			if black_tiles > 0 and ((black_tiles % 6 == 0) or ((black_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if black_tiles == 0 then
				exportable = false
			end
			return exportable
		elseif vars.clear_goals[vars.clear_goal] == 'gray' then
			local exportable = false
			if gray_tiles > 0 and ((gray_tiles % 6 == 0) or ((gray_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if gray_tiles == 0 then
				exportable = false
			end
			return exportable
		elseif vars.clear_goals[vars.clear_goal] == 'white' then
			local exportable = false
			if white_tiles > 0 and ((white_tiles % 6 == 0) or ((white_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if white_tiles == 0 then
				exportable = false
			end
			return exportable
		elseif vars.clear_goals[vars.clear_goal] == 'wild' then
			local exportable = false
			if wild_tiles > 0 and ((wild_tiles % 6 == 0) or ((black_tiles + wild_tiles) % 6 == 0) or ((gray_tiles + wild_tiles) % 6 == 0) or ((white_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if wild_tiles == 0 then
				exportable = false
			end
			return exportable
		elseif vars.clear_goals[vars.clear_goal] == '2x' then
			local exportable = false
			if double_black_tiles > 0 then
				if ((black_tiles % 6 == 0) or ((black_tiles + wild_tiles) % 6 == 0)) then
					exportable = true
				else
					exportable = false
				end
			end
			if double_gray_tiles > 0 then
				if  ((gray_tiles % 6 == 0) or ((gray_tiles + wild_tiles) % 6 == 0)) then
					exportable = true
				else
					exportable = false
				end
			end
			if double_white_tiles > 0 then
				if ((white_tiles % 6 == 0) or ((white_tiles + wild_tiles) % 6 == 0)) then
					exportable = true
				else
					exportable = false
				end
			end
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if double_black_tiles == 0 and double_gray_tiles == 0 and double_white_tiles == 0 then
				exportable = false
			end
			return exportable
		elseif vars.clear_goals[vars.clear_goal] == 'bomb' then
			local exportable = false
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_black_tiles == 0 and bomb_gray_tiles == 0 and bomb_white_tiles == 0 then
				exportable = false
			end
			return exportable
		elseif vars.clear_goals[vars.clear_goal] == 'board' then
			local exportable = false
			if black_tiles > 0 and ((black_tiles % 6 == 0) or ((black_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if gray_tiles > 0 and ((gray_tiles % 6 == 0) or ((gray_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if white_tiles > 0 and ((white_tiles % 6 == 0) or ((white_tiles + wild_tiles) % 6 == 0)) then
				exportable = true
			end
			if bomb_black_tiles > 0 and ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_gray_tiles > 0 and ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if bomb_white_tiles > 0 and ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = true
			end
			if black_tiles > 0 and not ((black_tiles % 6 == 0) or ((black_tiles + wild_tiles) % 6 == 0)) then
				exportable = false
			end
			if gray_tiles > 0 and not ((gray_tiles % 6 == 0) or ((gray_tiles + wild_tiles) % 6 == 0)) then
				exportable = false
			end
			if white_tiles > 0 and not ((white_tiles % 6 == 0) or ((white_tiles + wild_tiles) % 6 == 0)) then
				exportable = false
			end
			if bomb_black_tiles > 0 and not ((black_tiles >= 6) or ((black_tiles + wild_tiles) >= 6)) then
				exportable = false
			end
			if bomb_gray_tiles > 0 and not ((gray_tiles >= 6) or ((gray_tiles + wild_tiles) >= 6)) then
				exportable = false
			end
			if bomb_white_tiles > 0 and not ((white_tiles >= 6) or ((white_tiles + wild_tiles) >= 6)) then
				exportable = false
			end
			return exportable
		end
	else
		return true
	end
end

return mission_command