local utf8 = require("utf8")
local gfx = love.graphics
local floor = math.floor
local min = math.min
local max = math.max
local text = getLocalizedText
local mission_command = {}

local tris_x = {140, 170, 200, 230, 260, 110, 140, 170, 200, 230, 260, 290, 110, 140, 170, 200, 230, 260, 290}
local tris_y = {70, 70, 70, 70, 70, 120, 120, 120, 120, 120, 120, 120, 170, 170, 170, 170, 170, 170, 170}
local tris_flip = {true, false, true, false, true, true, false, true, false, true, false, true, false, true, false, true, false, true, false}

function mission_command:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('mission_command'))
	setrichpresence('steam_display', '#status_missioncommand')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		full_circle = gfx.newImageFont('fonts/full-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒整割振解放画面効果減少', 0),
		full_circle_outline = gfx.newImageFont('fonts/full-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 1),
		full_circle_inverted_outline = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 1),
		half_circle = gfx.newImageFont('fonts/half-circle.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0),

		mcsel = gfx.newImage('images/mcsel.png'),
		ui = gfx.newImage('images/' .. tostring(save.color) .. '/ui_create.png'),
		modal = gfx.newImage('images/' .. tostring(save.color) .. '/modal_small.png'),
		x = gfx.newImage('images/' .. tostring(save.color) .. '/x.png'),
		command_banner = gfx.newImage('images/' .. tostring(save.color) .. '/command_banner.png'),
		command_hide = gfx.newImage('images/' .. tostring(save.color) .. '/command_hide.png'),
		export_complete = gfx.newImage('images/' .. tostring(save.color) .. '/export_complete_' .. checklanguage() .. '.png'),
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
		seed_string = '0000000000',
		seed = 0,
		keyboard = 'seed',
		tri = 1,
		scroll_x_target = 400,
		scroll_x = 400,
		error_x_target = -400,
		error_x = -355,
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
		keyboard_symbols = {' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '!', '?', '.', ','},
		seed_symbols = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'},
		keyboard_slot = 1,
		keyboard_slots = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	}
	afterdelay('input_wait', transitiontime, function()
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

	loopingtimer('powerup', 700, 1, 4.99)

	loopingreversingtimer('flash', 500, 1, 3.99)

	newmusic('audio/music/zen' .. randInt(1, 2) .. '.mp3', true)
end

function mission_command:keypressed(key)
	if not transitioning and not vars.waiting then
		if vars.handler == 'start' then
			if key == save.up then
				vars.start_selection = vars.start_selection - 1
				if vars.start_selection < 1 then vars.start_selection = #vars.start_selections end
				playsound(assets.sfx_move)
			elseif key == save.down then
				vars.start_selection = vars.start_selection + 1
				if vars.start_selection > #vars.start_selections then vars.start_selection = 1 end
				playsound(assets.sfx_move)
			elseif key == save.left then
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
			elseif key == save.right then
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
			elseif key == save.primary then
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
					if vars.mission_types[vars.mission_type] == 'time' then
						vars.keyboard = 'seed'
						self:get_slots_from_keyboard()
						vars.keyboard_slot = 1
						vars.handler = 'keyboard'
						playsound(assets.sfx_select)
					end
				elseif vars.start_selections[vars.start_selection] == 'start' then
					vars.tris = {}
					if vars.mission_types[vars.mission_type] == 'time' then
						setRandomSeed(vars.seed)
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
						vars.error_x_target = -400
					elseif vars.error_x_target ~= 5 then
						vars.error_x_target = 5
						playsound(assets.sfx_bonk)
					end
				end
			elseif key == save.secondary then
				fademusic()
				playsound(assets.sfx_back)
				scenemanager:transitionscene(missions, vars.custom)
			end
		elseif vars.handler == 'keyboard' then
			if key == save.up then
				vars.keyboard_slots[vars.keyboard_slot] = vars.keyboard_slots[vars.keyboard_slot] - 1
				if vars.keyboard == 'seed' then
					if vars.keyboard_slots[vars.keyboard_slot] < 1 then
						vars.keyboard_slots[vars.keyboard_slot] = #vars.seed_symbols
					end
				else
					if vars.keyboard_slots[vars.keyboard_slot] < 1 then
						vars.keyboard_slots[vars.keyboard_slot] = #vars.keyboard_symbols
					end
				end
				playsound(assets.sfx_move)
			elseif key == save.down then
				vars.keyboard_slots[vars.keyboard_slot] = vars.keyboard_slots[vars.keyboard_slot] + 1
				if vars.keyboard == 'seed' then
					if vars.keyboard_slots[vars.keyboard_slot] > #vars.seed_symbols then
						vars.keyboard_slots[vars.keyboard_slot] = 1
					end
				else
					if vars.keyboard_slots[vars.keyboard_slot] > #vars.keyboard_symbols then
						vars.keyboard_slots[vars.keyboard_slot] = 1
					end
				end
				playsound(assets.sfx_move)
			elseif key == save.left then
				vars.keyboard_slot = vars.keyboard_slot - 1
				if vars.keyboard_slot < 1 then
					vars.keyboard_slot = 1
					shakies()
					playsound(assets.sfx_bonk)
				else
					playsound(assets.sfx_move)
				end
			elseif key == save.right then
				vars.keyboard_slot = vars.keyboard_slot + 1
				if vars.keyboard_slot > 10 then
					vars.keyboard_slot = 10
					shakies()
					playsound(assets.sfx_bonk)
				else
					playsound(assets.sfx_move)
				end
			elseif key == save.primary then
				self:hide_keyboard(true)
				playsound(assets.sfx_select)
			elseif key == save.secondary then
				self:hide_keyboard(false)
				playsound(assets.sfx_back)
			end
		elseif vars.handler == 'edit' then
			if key == save.up then
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
			elseif key == save.down then
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
			elseif key == save.left then
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
			elseif key == save.right then
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
			elseif key == save.primary then
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
			elseif key == save.secondary then
				vars.mode = 'start'
				vars.handler = 'start'
				vars.scroll_x_target = 400
				vars.error_x_target = -400
				playsound(assets.sfx_back)
			elseif key == save.tertiary then
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
			if key == save.up then
				vars.save_selection = vars.save_selection - 1
				if vars.save_selection < 1 then vars.save_selection = #vars.save_selections end
				playsound(assets.sfx_move)
			elseif key == save.down then
				vars.save_selection = vars.save_selection + 1
				if vars.save_selection > #vars.save_selections then vars.save_selection = 1 end
				playsound(assets.sfx_move)
			elseif key == save.primary then
				if vars.save_selections[vars.save_selection] == 'picture_name' then
					if vars.mission_types[vars.mission_type] == 'picture' then
						vars.keyboard = 'picture'
						self:get_slots_from_keyboard()
						vars.keyboard_slot = 1
						vars.handler = 'keyboard'
						playsound(assets.sfx_select)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.save_selections[vars.save_selection] == 'author_name' then
					vars.keyboard = 'author'
					self:get_slots_from_keyboard()
					vars.keyboard_slot = 1
					vars.handler = 'keyboard'
					playsound(assets.sfx_select)
				elseif vars.save_selections[vars.save_selection] == 'save' then
					mission_command:save()
					playsound(assets.sfx_select)
				end
			elseif key == save.secondary then
				vars.mode = 'edit'
				vars.handler = 'edit'
				vars.scroll_x_target = 800
				playsound(assets.sfx_back)
			end
		elseif vars.handler == 'selector' then
			-- TOOD: selector handlers
			if key == save.up then
				if vars.selector_rack ~= 1 then
					vars.selector_rack = 1
					playsound(assets.sfx_move)
				else
					shakies_y()
					playsound(assets.sfx_bonk)
				end
			elseif key == save.down then
				if vars.selector_show_powerup and vars.selector_rack == 1 then
					vars.selector_rack = 2
					playsound(assets.sfx_move)
				else
					shakies_y()
					playsound(assets.sfx_bonk)
				end
			elseif key == save.left then
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
			elseif key == save.right then
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
			elseif key == save.primary then
				mission_command:close_selector(true)
				playsound(assets.sfx_select)
				if mission_command:check_validity() then
					vars.error_x_target = -400
				elseif vars.error_x_target ~= 5 then
					vars.error_x_target = 5
					playsound(assets.sfx_bonk)
				end
			elseif key == save.secondary then
				mission_command:close_selector(false)
				playsound(assets.sfx_back)
				if mission_command:check_validity() then
					vars.error_x_target = -400
				elseif vars.error_x_target ~= 5 then
					vars.error_x_target = 5
					playsound(assets.sfx_bonk)
				end
			end
		elseif vars.handler == 'done' then
			if key == save.secondary then
				scenemanager:transitionscene(missions, vars.custom)
				fademusic()
			elseif key == save.primary then
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

	self:print_with_outline(text('mission_command'), 10 + x, 8)
	if save.color == 1 then
		gfx.setColor(1, 1, 1, 1)
	end
	gfx.setFont(assets.full_circle)

	gfx.print(text('mission_type'), 50 + x, 50)

	gfx.printf(text('command_' .. vars.mission_types[vars.mission_type]), x, 50, 546, 'center')

	gfx.print(text('time_limit'), 50 + x, 93)
	gfx.printf(tostring(vars.time_limits[vars.time_limit]) .. 's', x, 100, 546, 'center')

	gfx.print(text('clear_goal'), 50 + x, 123)

	gfx.printf(text('command_' .. vars.clear_goals[vars.clear_goal]), x, 130, 546, 'center')

	gfx.print(text('number_seed'), 50 + x, 153)
	if vars.handler == 'keyboard' and vars.keyboard == 'seed' then
		for i = 1, 10 do
			if i == vars.keyboard_slot then
				gfx.setColor(0, 0, 0, 1)
				gfx.rectangle('line', 272 + x + ((i - 6) * 13), 158, 13, 18)
				if save.color == 1 then
					gfx.setColor(love.math.colorFromBytes(95, 87, 79, 255))
					gfx.setFont(assets.full_circle_inverted)
				else
					gfx.setFont(assets.half_circle)
				end
			else
				if save.color == 1 then
					gfx.setColor(0, 0, 0, 1)
				else
					gfx.setFont(assets.full_circle)
				end
			end
			gfx.printf(self:get_keyboard_from_slots():sub(i, i), x + ((i - 5.5) * 13), 160, 546, 'center')
		end
		if save.color == 1 then
			gfx.setColor(0, 0, 0, 1)
		else
			gfx.setFont(assets.full_circle)
		end
	else
		gfx.printf(vars.seed_string, x, 160, 546, 'center')
	end

	gfx.printf(text('start_editing'), x, 195, 400, 'center')

	-- Edit

	if vars.error_x < -200 then
		if vars.mission_types[vars.mission_type] == 'picture' then
			self:print_with_outline(text('create_picture'), 410 + x, 8)
		elseif vars.mission_types[vars.mission_type] == 'time' then
			self:print_with_outline(text('review_seed'), 410 + x, 8)
		else
			self:print_with_outline(text('create_start'), 410 + x, 8)
		end
	end
	if save.color == 1 then
		gfx.setFont(assets.full_circle)
		gfx.setColor(1, 1, 1, 1)
	end

	-- Save

	self:print_with_outline(text('export_puzzle'), 810 + x, 8)
	if save.color == 1 then
		gfx.setFont(assets.full_circle)
		gfx.setColor(1, 1, 1, 1)
	end

	gfx.print(text('mission_type'), 850 + x, 50)

	gfx.printf(text('command_' .. vars.mission_types[vars.mission_type]), x, 50, 1150, 'right')

	gfx.print(text('picture_name'), 850 + x, 93)
	if vars.handler == 'keyboard' and vars.keyboard == 'picture' then
		for i = 1, 10 do
			if i == vars.keyboard_slot then
				gfx.setColor(0, 0, 0, 1)
				gfx.rectangle('line', 1072 + x + ((i - 6) * 13), 98, 13, 18)
				if save.color == 1 then
					gfx.setColor(love.math.colorFromBytes(95, 87, 79, 255))
					gfx.setFont(assets.full_circle_inverted)
				else
					gfx.setFont(assets.half_circle)
				end
			else
				if save.color == 1 then
					gfx.setColor(0, 0, 0, 1)
				else
					gfx.setFont(assets.full_circle)
				end
			end
			gfx.printf(self:get_keyboard_from_slots():sub(i, i), x + ((i - 5.5) * 13), 100, 2146, 'center')
		end
		if save.color == 1 then
			gfx.setColor(0, 0, 0, 1)
		else
			gfx.setFont(assets.full_circle)
		end
	else
		gfx.printf(vars.picture_name, x, 100, 2146, 'center')
	end

	gfx.print(text('author_name'), 850 + x, 130)
	if vars.handler == 'keyboard' and vars.keyboard == 'author' then
		for i = 1, 10 do
			if i == vars.keyboard_slot then
				gfx.setColor(0, 0, 0, 1)
				gfx.rectangle('line', 1072 + x + ((i - 6) * 13), 128, 13, 18)
				if save.color == 1 then
					gfx.setColor(love.math.colorFromBytes(95, 87, 79, 255))
					gfx.setFont(assets.full_circle_inverted)
				else
					gfx.setFont(assets.half_circle)
				end
			else
				if save.color == 1 then
					gfx.setColor(0, 0, 0, 1)
				else
					gfx.setFont(assets.full_circle)
				end
			end
			gfx.printf(self:get_keyboard_from_slots():sub(i, i), x + ((i - 5.5) * 13), 130, 2146, 'center')
		end
		if save.color == 1 then
			gfx.setColor(0, 0, 0, 1)
		else
			gfx.setFont(assets.full_circle)
		end
	else
		gfx.printf(vars.author_name, x, 130, 2146, 'center')
	end

	gfx.printf(text('export_puzzle'), x, 180, 2000, 'center')

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

	gfx.print('(' .. text('command_time') .. ')', 50 + x, 107)
	gfx.print('(' .. text('command_logic') .. text('slash') .. text('command_speedrun') .. ')', 50 + x, 137)
	gfx.print('(' .. text('command_time') .. ')', 50 + x, 167)

	gfx.printf(text('command_' .. vars.mission_types[vars.mission_type] .. '_d'), 0 + x, 70, 400, 'center')

	if vars.handler == 'keyboard' then
		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('select') .. text('circle') .. text('back'), 10 + x, 220)
			else
				gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select') .. text('b') .. text('back'), 10 + x, 220)
			end
		else
			gfx.print(text('directions_move') .. start(save.primary) .. text('select') .. start(save.secondary) .. text('back'), 10 + x, 220)
		end
	else
		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('select') .. text('circle') .. text('back'), 10 + x, 220)
			else
				gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select') .. text('b') .. text('back'), 10 + x, 220)
			end
		else
			gfx.print(start(save.up) .. text('slash') .. start(save.down) .. text('move') .. start(save.primary) .. text('select') .. start(save.secondary) .. text('back'), 10 + x, 220)
		end
	end

	-- Edit

	if vars.mission_types[vars.mission_type] == 'time' then
		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('circle') .. text('back') .. text('square') .. text('exports'), 410 + x, 220)
			else
				gfx.print(text('b') .. text('back') .. text('x') .. text('exports'), 410 + x, 220)
			end
		else
			gfx.print(start(save.secondary) .. text('back') .. start(save.tertiary) .. text('exports'), 410 + x, 220)
		end
	else
		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('select'), 410 + x, 206)
				gfx.print(text('circle') .. text('back') .. text('square') .. text('exports'), 410 + x, 220)
			else
				gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select'), 410 + x, 206)
				gfx.print(text('b') .. text('back') .. text('x') .. text('exports'), 410 + x, 220)
			end
		else
			gfx.print(text('directions_move') .. start(save.primary) .. text('select'), 410 + x, 206)
			gfx.print(start(save.secondary) .. text('back') .. start(save.tertiary) .. text('exports'), 410 + x, 220)
		end
	end

	-- Save

	gfx.printf(text('command_' .. vars.mission_types[vars.mission_type] .. '_d'), 0 + x, 70, 2000, 'center')

	gfx.print('(' .. text('command_picture') .. ')', 850 + x, 107)

	if vars.handler == 'keyboard' then
		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('select') .. text('circle') .. text('back'), 810 + x, 220)
			else
				gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select') .. text('b') .. text('back'), 810 + x, 220)
			end
		else
			gfx.print(text('directions_move') .. start(save.primary) .. text('select') .. start(save.secondary) .. text('back'), 810 + x, 220)
		end
	else
		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('select') .. text('circle') .. text('back'), 810 + x, 220)
			else
				gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select') .. text('b') .. text('back'), 810 + x, 220)
			end
		else
			gfx.print(start(save.up) .. text('slash') .. start(save.down) .. text('move') .. start(save.primary) .. text('select') .. start(save.secondary) .. text('back'), 810 + x, 220)
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

	local modal = floor(value('modal') or 400) + 35
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
		gfx.printf(text('choose_color'), 0, 12 + modal, 400, 'center')
		if vars.selector_rack == 2 then
			gfx.setFont(assets.full_circle)
			gfx.setColor(1, 1, 1, 1)
		else
			gfx.setFont(assets.full_circle_inverted)
			if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end
		end
		gfx.printf(text('choose_powerup'), 0, 90 + modal, 400, 'center')
	else
		gfx.printf(text('choose_color'), 0, 46 + modal, 400, 'center')
	end
	gfx.setColor(1, 1, 1, 1)
	if vars.selector_show_powerup then
		gfx.draw(assets.x, 96, 116 + modal)
		if save.reduceflashing or assets['powerup' .. floor(value('powerup'))] == nil then
			if assets['powerup_double_up'] ~= nil then gfx.draw(assets['powerup_double_up'], assets['powerup1'], 91 + 46, 104 + modal) end
			if assets['powerup_bomb_up'] ~= nil then gfx.draw(assets['powerup_bomb_up'], assets['powerup1'], 148 + 46, 104 + modal) end
			if assets['powerup_wild_box'] ~= nil then gfx.draw(assets['powerup_wild_box'], assets['powerup1'], 203 + 46, 104 + modal) end
		else
			if assets['powerup_double_up'] ~= nil then gfx.draw(assets['powerup_double_up'], assets['powerup' .. floor(value('powerup'))], 91 + 46, 104 + modal) end
			if assets['powerup_bomb_up'] ~= nil then gfx.draw(assets['powerup_bomb_up'], assets['powerup' .. floor(value('powerup'))], 148 + 46, 104 + modal) end
			if assets['powerup_wild_box'] ~= nil then gfx.draw(assets['powerup_wild_box'], assets['powerup' .. floor(value('powerup'))], 203 + 46, 104 + modal) end
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

		local flash = floor(value('flash'))
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

		local flash = floor(value('flash'))
		if flash < 1 then flash = 1 end
		if flash > 3 then flash = 3 end
		if vars.selector_show_no_color then
			gfx.draw(assets['select_' .. flash], 152 - 165 + (55 * vars.selector_rack1selection) + 46, 71 + modal)
		else
			gfx.draw(assets['select_' .. flash], 152 - 132 + (55 * vars.selector_rack1selection) + 46, 71 + modal)
		end
	end

	gfx.draw(assets.error, 5 + floor(vars.error_x), 3)
	self:print_with_outline(text('command_error'), 36 + floor(vars.error_x), 8)

	if vars.puzzle_exported then
		gfx.draw(assets.export_complete, 800 + x, 0)

		gfx.setFont(assets.full_circle_inverted)
		if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

		local realdir = love.filesystem.getRealDirectory('missions/')
		gfx.printf(text('savedto') .. '\n' .. realdir .. '/missions/' .. tostring(vars.export.mission) .. text('missionspath3'), 800 + x, 128, 400, 'center')

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
		else
			gfx.setFont(assets.half_circle_inverted)
		end

		gfx.printf(text('shareit') .. text('nocustommissions_4'), x, 187, 2000, 'center')

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(95, 87, 79, 255))
			gfx.setFont(assets.full_circle_inverted)
		else
			gfx.setFont(assets.half_circle)
		end

		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('circle') .. text('back'), 810 + x, 220)
			else
				gfx.print(text('b') .. text('back'), 810 + x, 220)
			end
		else
			gfx.print(start(save.secondary) .. text('back'), 810 + x, 220)
		end
	end

	draw_on_top()
end

function mission_command:get_keyboard_from_slots()
	local string = ''
	for i = 1, #vars.keyboard_slots do
		if vars.keyboard == 'seed' then
			string = string .. vars.seed_symbols[vars.keyboard_slots[i]]
		else
			string = string .. vars.keyboard_symbols[vars.keyboard_slots[i]]
		end
	end
	return string
end

function mission_command:get_slots_from_keyboard()
	if vars.keyboard == 'seed' then
		for i = 1, #vars.keyboard_slots do
			vars.keyboard_slots[i] = tonumber(vars.seed_string:sub(i, i)) + 1
		end
	else
		for i = 1, 10 do
			local string
			if vars.keyboard == 'picture' then
				string = vars.picture_name
			elseif vars.keyboard == 'author' then
				string = vars.author_name
			end
			local set = false
			for n = 1, #vars.keyboard_symbols do
				if string:sub(i, i) == vars.keyboard_symbols[n] then
					vars.keyboard_slots[i] = n
					set = true
				end
			end
			if not set then vars.keyboard_slots[i] = 1 end
		end
	end
end

function mission_command:hide_keyboard(save)
	if vars.keyboard == 'seed' then
		if save then
			vars.seed_string = self:get_keyboard_from_slots():gsub('^%s*(.-)%s*$', '%1')
			vars.seed = tonumber(vars.seed_string)
		end
		vars.handler = 'start'
	elseif vars.keyboard == 'picture' then
		if save then
			vars.picture_name = self:get_keyboard_from_slots():gsub('^%s*(.-)%s*$', '%1')
			if vars.picture_name == '' then
				vars.picture_name = 'Object'
			end
		end
		vars.handler = 'save'
	elseif vars.keyboard == 'author' then
		if save then
			vars.author_name = self:get_keyboard_from_slots():gsub('^%s*(.-)%s*$', '%1')
			if vars.author_name == '' then
				vars.author_name = save.author_name ~= '' and save.author_name or 'HEXA MASTR'
			end
		end
		vars.handler = 'save'
	end
end

function mission_command:print_with_outline(newtext, x, y)
	gfx.setFont(assets.full_circle_outline)
	-- 1px outline square
	gfx.print(newtext, x + 1, y + 1)
	gfx.print(newtext, x + 2, y + 1)
	gfx.print(newtext, x + 3, y + 1)
	gfx.print(newtext, x + 3, y + 2)
	gfx.print(newtext, x + 3, y + 3)
	gfx.print(newtext, x + 2, y + 3)
	gfx.print(newtext, x + 1, y + 3)
	gfx.print(newtext, x + 1, y + 2)

	-- 2px outline round
	gfx.print(newtext, x + 0, y + 1)
	gfx.print(newtext, x + 0, y + 2)
	gfx.print(newtext, x + 0, y + 3)

	gfx.print(newtext, x + 1, y + 4)
	gfx.print(newtext, x + 2, y + 4)
	gfx.print(newtext, x + 3, y + 4)

	gfx.print(newtext, x + 4, y + 3)
	gfx.print(newtext, x + 4, y + 2)
	gfx.print(newtext, x + 4, y + 1)

	gfx.print(newtext, x + 1, y + 0)
	gfx.print(newtext, x + 2, y + 0)
	gfx.print(newtext, x + 3, y + 0)
	gfx.setFont(assets.full_circle_inverted_outline)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end
	gfx.print(newtext, x + 2, y + 2)
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
		if save.reduceflashing or assets['powerup' .. floor(value('powerup'))] == nil then
			if up then
				if assets['powerup_' .. powerup .. '_up'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_up'], assets['powerup1'], x - 28, y - 23) end
			else
				if assets['powerup_' .. powerup .. '_down'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_down'], assets['powerup1'], x - 28, y - 23) end
			end
		else
			if up then
				if assets['powerup_' .. powerup .. '_up'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_up'], assets['powerup' .. floor(value('powerup'))], x - 28, y - 23) end
			else
				if assets['powerup_' .. powerup .. '_down'] ~= nil then gfx.draw(assets['powerup_' ..powerup .. '_down'], assets['powerup' .. floor(value('powerup'))], x - 28, y - 23) end
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
	newtimer('modal', 300, value('modal') or 400, 0, 'outBack', function()
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
	newtimer('modal', 300, value('modal') or 0, 400, 'inBack', function()
		vars.selector_opened = false
		vars.handler = vars.mode
	end)
end

function mission_command:randomizetri()
	local randomcolor = randInt(1, 3)
	local randompowerup = randInt(1, 50)
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
	updatecheevos()
end

-- Shuffly code from https://gist.github.com/Uradamus/10323382
function shuffle(tbl)
  for i = #tbl, 2, -1 do
	local j = randInt(1, i)
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