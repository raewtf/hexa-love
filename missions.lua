local gfx = love.graphics
local floor = math.floor
local abs = math.abs
local text = getLocalizedText
missions = {}
missions_list = require 'missions_list'
mission_command = require('mission_command')

function missions:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('missions'))
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		full_circle = gfx.newImageFont('fonts/full-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵ÀÇÉÈÊÎÔÛàçéèêîôû'),
		half_circle = gfx.newImageFont('fonts/half-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒ÀÇÉÈÊÎÔÛàçéèêîôû'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠🎵ÀÇÉÈÊÎÔÛàçéèêîôû'),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]™_`abcdefghijklmnopqrstuvwxyz{|}~≠⏰🔒ÀÇÉÈÊÎÔÛàçéèêîôû'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		check = gfx.newImage('images/' .. tostring(save.color) .. '/check.png'),
		mission_banner = gfx.newImage('images/' .. tostring(save.color) .. '/mission_banner.png'),
		mission_banner_none = gfx.newImage('images/mission_banner_none.png'),
		mission_selected = gfx.newImage('images/' .. tostring(save.color) .. '/mission_selected.png'),
		mission = gfx.newImage('images/' .. tostring(save.color) .. '/mission.png'),
	}

	vars = {
		custom = args[1], -- bool
		sx = 0,
		sy = 0,
		lx = 0,
		ly = 0,
		selections = 50,
		custom_files = 0,
		custom_selection = 1,
		offset = 0,
		custom_missions_enabled = true,
	}
	vars.input_wait = timer.after(transitiontime, function()
		vars.waiting = false
	end)

	vars.selection = math.min((((save.highest_mission > 50) and 1) or (save.highest_mission)), 50)

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

	for i = 1, 50 do
		self:draw_cell(i, false)
	end

	vars.custom_files = love.filesystem.getDirectoryItems('missions/')


	if #vars.custom_files > 0 then
		for i, file in ipairs(vars.custom_files) do
			if not string.find(file, '.json') then
				table.remove(vars.custom_files, i)
			end
		end
		vars.custom_missions = {}
		for i = 1, #vars.custom_files do
			if save.mission_bests['mission' .. string.gsub(tostring(vars.custom_files[i]), ".json", "")] == nil then
				save.mission_bests['mission' .. string.gsub(tostring(vars.custom_files[i]), ".json", "")] = 0
			end
			vars.custom_missions[i] = json.decode(love.filesystem.read('missions/' .. tostring(vars.custom_files[i])))
			if vars.custom_missions[i].type == 'picture' then
				if vars.custom_missions[i].start_point ~= nil then
					vars.custom_missions[i].start = {}
					for n = 1, 19 do
						table.insert(vars.custom_missions[i].start, vars.custom_missions[i].start_point['tri' .. n])
					end
					vars.custom_missions[i].start_point = nil
				end
				if vars.custom_missions[i].goal_point ~= nil then
					vars.custom_missions[i].goal = {}
					for n = 1, 19 do
						table.insert(vars.custom_missions[i].goal, vars.custom_missions[i].goal_point['tri' .. n])
					end
					vars.custom_missions[i].goal_point = nil
				end
			end
		end
		for i = 1, #vars.custom_files do
			self:draw_cell(i, true)
		end
	end

	newmusic('audio/music/title.mp3', true)
end

function missions:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.left then
			if vars.custom and #vars.custom_files > 0 then
				if vars.custom_selection == 1 then
					shakies()
					playsound(assets.sfx_bonk)
				else
					playsound(assets.sfx_move)
					vars.custom_selection = vars.custom_selection - 1
					vars.offset = -211
				end
			elseif not vars.custom then
				if vars.selection == 1 then
					shakies()
					playsound(assets.sfx_bonk)
				else
					playsound(assets.sfx_move)
					vars.selection = vars.selection - 1
					vars.offset = -211
				end
			end
		elseif key == save.right then
			if vars.custom and #vars.custom_files > 0 then
				if vars.custom_selection == #vars.custom_files then
					shakies()
					playsound(assets.sfx_bonk)
				else
					playsound(assets.sfx_move)
					vars.custom_selection = vars.custom_selection + 1
					vars.offset = 211
				end
			elseif not vars.custom then
				if vars.selection == 50 then
					shakies()
					playsound(assets.sfx_bonk)
				else
					playsound(assets.sfx_move)
					vars.selection = vars.selection + 1
					vars.offset = 211
				end
			end
		elseif key == save.up then
			if vars.custom then
				local realdir = love.filesystem.getRealDirectory('missions/')
				love.system.openURL('file://' .. realdir .. '/missions/')
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'missions')
		elseif key == save.primary then
			if vars.custom then
				playsound(assets.sfx_select)
				scenemanager:transitionscene(game, vars.custom_missions[vars.custom_selection].type, vars.custom_missions[vars.custom_selection].mission, vars.custom_missions[vars.custom_selection].modifier or nil, vars.custom_missions[vars.custom_selection].start or nil, vars.custom_missions[vars.custom_selection].goal or nil, vars.custom_missions[vars.custom_selection].seed or nil, vars.custom_missions[vars.custom_selection].name or nil)
				fademusic()
			else
				if vars.selection > save.highest_mission then
					playsound(assets.sfx_bonk)
					shakies()
				else
					playsound(assets.sfx_select)
					scenemanager:transitionscene(game, missions_list[vars.selection].type, vars.selection, missions_list[vars.selection].modifier or nil, missions_list[vars.selection].start or nil, missions_list[vars.selection].goal or nil, nil, missions_list[vars.selection].name or nil)
					fademusic()
				end
			end
		elseif key == save.quaternary then
			vars.custom = not vars.custom
			playsound(assets.sfx_select)
		elseif key == save.tertiary then
			scenemanager:transitionscene(mission_command, vars.custom)
			fademusic()
			playsound(assets.sfx_select)
		end
	end
end

function missions:update()
	vars.offset = vars.offset - vars.offset * 0.5
	if vars.offset ~= 0 and (vars.offset < 1 and vars.offset > -1) then
		vars.offset = 0
	end
end

function missions:draw()
	gfx.draw(assets.bg, 0, 0)
	gfx.draw(assets.stars_small, floor(vars.sx), floor(vars.sy))
	gfx.draw(assets.stars_large, floor(vars.lx), floor(vars.ly))

	if (vars.custom and #vars.custom_files > 0) or (not vars.custom) then
		gfx.draw(assets.mission_banner, 0, 40)
	else
		gfx.draw(assets.mission_banner_none, 0, 40)
	end

	if vars.custom then
		if #vars.custom_files > 0 then
			for i = 1, #vars.custom_files do
				gfx.draw(assets['cell_canvas_custom' .. i], floor((99 + ((i - vars.custom_selection) * 211)) + vars.offset), 50)
			end
			gfx.draw(assets.mission_selected, 99 + floor(vars.offset), 50)
		else
			gfx.setFont(assets.full_circle_inverted)
			if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

			gfx.printf(text('nocustommissions_1'), 0, 70, 400, 'center')
			gfx.printf(text('nocustommissions_2'), 0, 85, 400, 'center')

			if save.color == 1 then
				gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
			else
				gfx.setFont(assets.half_circle_inverted)
			end

			gfx.printf(text('nocustommissions_3'), 0, 120, 400, 'center')
			gfx.printf(text('nocustommissions_4'), 0, 135, 400, 'center')
		end
	else
		for i = 1, 50 do
			gfx.draw(assets['cell_canvas' .. i], floor((99 + ((i - vars.selection) * 211)) + vars.offset), 50)
		end
		gfx.draw(assets.mission_selected, 99 + floor(vars.offset), 50)
		for i = -1, 1 do
			if (i < 0 and vars.selection > abs(i)) or (i >= 0) then
				if save.highest_mission > vars.selection + i then
					gfx.draw(assets.check, 256 + (211 * i) + floor(vars.offset), 125)
				end
			end
		end
	end

	if save.color == 1 then
		gfx.setFont(assets.full_circle_inverted)
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		if vars.custom_missions_enabled then
			gfx.print(text('y') .. text('toggles_missions') .. (vars.custom and text('up') .. text('open_directory') or ''), 10, 190)
			gfx.print(text('x') .. text('open_command'), 10, 205)
		end
		gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select') .. text('b') .. text('back'), 10, 220)
	else
		if vars.custom_missions_enabled then
			gfx.print(start(save.quaternary) .. text('toggles_missions') .. (vars.custom and start(save.up) .. text('open_directory') or ''), 10, 190)
			gfx.print(start(save.tertiary) .. text('open_command'), 10, 205)
		end
		gfx.print(start(save.left) .. text('slash') .. start(save.right) .. text('move') .. start(save.primary) .. text('select') .. start(save.secondary) .. text('back'), 10, 220)
	end

	draw_on_top()
end

function missions:draw_cell(column, custom)
	assets['cell_canvas' .. (custom and '_custom' or '') .. column] = gfx.newCanvas(202, 125)
	gfx.setCanvas(assets['cell_canvas' .. (custom and '_custom' or '') .. column])
		gfx.push()
		gfx.origin()
		sx, sy, sw, sh = gfx.getScissor()
		gfx.setScissor()
		gfx.draw(assets.mission, 0, 0)
		if custom then
			gfx.setFont(assets.full_circle)
			gfx.setColor(0, 0, 0, 1)
			gfx.printf(text('mission_by') .. vars.custom_missions[column].author, 0, 8, 202, 'center')
			if vars.custom_missions[column].type == 'picture' then
				gfx.printf(text('mission_picture1') .. vars.custom_missions[column].name .. text('mission_picture2'), 0, 34, 202, 'center')
				gfx.printf(text('swaps') .. text('divvy') .. commalize(save.mission_bests['mission' .. vars.custom_missions[column].mission] or 0), 0, 103, 202, 'center')
			elseif vars.custom_missions[column].type == 'logic' then
				local mod = vars.custom_missions[column].modifier
				gfx.printf(text('mission_logic_' .. mod), 0, 34, 202, 'center')
				gfx.printf(text('swaps') .. text('divvy') .. commalize(save.mission_bests['mission' .. vars.custom_missions[column].mission] or 0), 0, 103, 202, 'center')
			elseif vars.custom_missions[column].type == 'speedrun' then
				local mod = vars.custom_missions[column].modifier
				gfx.printf(text('mission_speedrun_' .. mod), 0, 34, 202, 'center')
				local mins, secs, mils = timecalc(save.mission_bests['mission' .. vars.custom_missions[column].mission])
				gfx.printf(text('time') .. text('divvy') .. mins .. ':' .. secs .. '.' .. mils, 0, 103, 202, 'center')
			elseif vars.custom_missions[column].type == 'time' then
				gfx.printf(text('mission_time'), 0, 34, 202, 'center')
				gfx.printf(text('score') .. text('divvy') .. commalize(save.mission_bests['mission' .. vars.custom_missions[column].mission] or 0), 0, 103, 202, 'center')
			end
		else
			if column > save.highest_mission then
				gfx.setFont(assets.half_circle)
				gfx.setColor(0, 0, 0, 1)
				gfx.printf('🔒 ' .. text('mission_label') .. column, 0, 8, 202, 'center')
				if save.color == 1 then
					gfx.setFont(assets.full_circle)
					gfx.setColor(0, 0, 0, 0.5)
				else
					gfx.setFont(assets.half_circle)
					gfx.setColor(0, 0, 0, 1)
				end
				gfx.printf(text('mission_locked'), 0, 41, 202, 'center')
			else
				gfx.setFont(assets.full_circle)
				gfx.setColor(0, 0, 0, 1)
				gfx.printf(text('mission_label') .. column, 0, 8, 202, 'center')
				if missions_list[column].type == 'picture' then
					gfx.printf(text('mission_picture1') .. missions_list[column].name .. text('mission_picture2'), 0, 34, 202, 'center')
					gfx.printf(text('swaps') .. text('divvy') .. commalize(save.mission_bests['mission' .. column] or 0), 0, 103, 202, 'center')
				elseif missions_list[column].type == 'logic' then
					local mod = missions_list[column].modifier
					gfx.printf(text('mission_logic_' .. mod), 0, 34, 202, 'center')
					gfx.printf(text('swaps') .. text('divvy') .. commalize(save.mission_bests['mission' .. column] or 0), 0, 103, 202, 'center')
				elseif missions_list[column].type == 'speedrun' then
					local mod = missions_list[column].modifier
					gfx.printf(text('mission_speedrun_' .. mod), 0, 34, 202, 'center')
					local mins, secs, mils = timecalc(save.mission_bests['mission' .. column])
					gfx.printf(text('time') .. text('divvy') .. mins .. ':' .. secs .. '.' .. mils, 0, 103, 202, 'center')
				elseif missions_list[column].type == 'time' then
					gfx.printf(text('mission_time'), 0, 34, 202, 'center')
					gfx.printf(text('score') .. text('divvy') .. commalize(save.mission_bests['mission' .. column] or 0), 0, 103, 202, 'center')
				end
			end
		end
		gfx.setColor(1, 1, 1, 1)
		gfx.setScissor(sx, sy, sw, sh)
		gfx.pop()
	gfx.setCanvas()
end

return missions