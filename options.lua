local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local options = {}

visuals = require('visuals')

function options:holdbuttons()
	vars.heldup = save.up
	vars.helddown = save.down
	vars.heldleft = save.left
	vars.heldright = save.right
	vars.heldprimary = save.primary
	vars.heldsecondary = save.secondary
	vars.heldtertiary = save.tertiary
	vars.heldquaternary = save.quaternary
end

function options:restorebuttons()
	save.up = vars.heldup
	save.down = vars.helddown
	save.left = vars.heldleft
	save.right = vars.heldright
	save.primary = vars.heldprimary
	save.secondary = vars.heldsecondary
	save.tertiary = vars.heldtertiary
	save.quaternary = vars.heldquaternary
end

function options:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('options'))
	setrichpresence('steam_display', '#status_options')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png'),
		fg_hexa_1 = gfx.newImage('images/2/fg_hexa_1.png'),
		fg_hexa_1_1 = gfx.newImage('images/1/fg_hexa_1_1.png'),
		fg_hexa_1_2 = gfx.newImage('images/1/fg_hexa_1_2.png'),
		fg_hexa_1_3 = gfx.newImage('images/1/fg_hexa_1_3.png'),
		fg_hexa_1_4 = gfx.newImage('images/1/fg_hexa_1_4.png'),
		fg_hexa_2 = gfx.newImage('images/2/fg_hexa_2.png'),
		fg_hexa_2_1 = gfx.newImage('images/1/fg_hexa_2_1.png'),
		fg_hexa_2_2 = gfx.newImage('images/1/fg_hexa_2_2.png'),
		fg_hexa_2_3 = gfx.newImage('images/1/fg_hexa_2_3.png'),
		fg_hexa_2_4 = gfx.newImage('images/1/fg_hexa_2_4.png'),
		fg_hexa_2_5 = gfx.newImage('images/1/fg_hexa_2_5.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_boom = love.audio.newSource('audio/sfx/boom.mp3', 'static'),
		half = gfx.newImage('images/half.png'),
		modal_small = gfx.newImage('images/' .. tostring(save.color) .. '/modal_small.png'),
	}

	vars = {
		default = args[1],
		resetprogress = 1,
		selection = 0,
		waiting = true,
		handler = 'options',
		remap_step = 1,
		selections = {'music', 'sfx', 'lang', 'visuals', 'keyboard', 'rumble', 'flip', 'skipfanfare', 'hardmode', 'reset'},
	}
	afterdelay('input_wait', transitiontime, function()
		vars.waiting = false
		if vars.default ~= nil then
			for i = 1, #vars.selections do
				if vars.selections[i] == vars.default then
					vars.selection = i
				end
			end
		end
		if vars.selection == 0 then
			vars.selection = 1
		end
	end)

	loopingreversingtimer('fg_hexa', 3000, 0, 7, 'inOutSine')

	self:holdbuttons()
end

function options:keypressed(key)
	if not transitioning and not vars.waiting then
		if vars.handler == 'options' then
			if key == save.up then
				if vars.selection ~= 0 then
					if vars.selection > 1 then
						vars.selection = vars.selection - 1
					else
						vars.selection = #vars.selections
					end
					playsound(assets.sfx_move)
					if vars.resetprogress < 4 then
						vars.resetprogress = 1
					end
				end
			elseif key == save.down then
				if vars.selection ~= 0 then
					if vars.selection < #vars.selections then
						vars.selection = vars.selection + 1
					else
						vars.selection = 1
					end
					playsound(assets.sfx_move)
					if vars.resetprogress < 4 then
						vars.resetprogress = 1
					end
				end
			elseif key == save.secondary then
				playsound(assets.sfx_back)
				scenemanager:transitionscene(title, false, 'options')
				vars.selection = 0
			elseif key == save.primary then
				if vars.selections[vars.selection] == "music" then
					save.music = save.music + 1
					if save.music > 5 then
						save.music = 0
					end
					if save.music > 0 then
						if music ~= nil then
							volume = {save.music / 5}
						else
							newmusic('audio/music/title.mp3', true)
						end
					else
						fademusic(1)
					end
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "sfx" then
					save.sfx = save.sfx + 1
					if save.sfx > 5 then
						save.sfx = 0
					end
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == 'lang' then
					if save.lang == 'en' then
						save.lang = 'fr'
					elseif save.lang == 'fr' then
						save.lang = 'jp'
					elseif save.lang == 'jp' then
						if issteam then
							save.lang = 'system'
						else
							save.lang = 'en'
						end
					elseif save.lang == 'system' then
						save.lang = 'en'
					end
					playsound(assets.sfx_select)
					love.window.setTitle(text('hexa') .. text('dash_long') .. text('options'))
				elseif vars.selections[vars.selection] == 'visuals' then
					scenemanager:transitionscene(visuals)
					playsound(assets.sfx_select)
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == 'keyboard' then
					if save.gamepad then
						playsound(assets.sfx_bonk)
						shakies()
					else
						vars.remap_step = 1
						vars.handler = 'remap'
						playsound(assets.sfx_select)
					end
				elseif vars.selections[vars.selection] == 'rumble' then
					save.rumble = not save.rumble
					rumble(1, 1, 0.2)
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "flip" then
					save.flip = not save.flip
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "skipfanfare" then
					save.skipfanfare = not save.skipfanfare
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "hardmode" then
					save.hardmode = not save.hardmode
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "reset" then
					if vars.resetprogress < 3 then
						playsound(assets.sfx_select)
						vars.resetprogress = vars.resetprogress + 1
					elseif vars.resetprogress == 3 then
						playsound(assets.sfx_boom)
						vars.resetprogress = vars.resetprogress + 1
						save.score = 0
						save.hard_score = 0
						save.swaps = 0
						save.hexas = 0
						save.mission_bests = {}
						save.highest_mission = 1
						for i = 1, #save.mission_bests do
							save.mission_bests[i] = save.mission_bests[i] or 0
						end
						for i = 1, 50 do
							if save.mission_bests['mission' .. i] == nil then
								save.mission_bests['mission' .. i] = 0
							end
						end
						save.author_name = ''
						save.exported_mission = false
						save.playtime = 0
						save.gametime = 0
						save.total_score = 0
						save.black_match = 0
						save.gray_match = 0
						save.white_match = 0
						save.double_match = 0
						save.bomb_match = 0
						save.wild_match = 0
						if issteam then
							steam.userStats.resetAllStats(true)
						end
					end
				end
			elseif key == save.left then
				if vars.selections[vars.selection] == "music" then
					save.music = save.music - 1
					if save.music < 0 then
						save.music = 5
					end
					if save.music > 0 then
						if music ~= nil then
							volume = {save.music / 5}
						else
							newmusic('audio/music/title.mp3', true)
						end
					else
						fademusic(1)
					end
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "sfx" then
					save.sfx = save.sfx - 1
					if save.sfx < 0 then
						save.sfx = 5
					end
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == 'lang' then
					if save.lang == 'en' then
						if issteam then
							save.lang = 'system'
						else
							save.lang = 'jp'
						end
					elseif save.lang == 'fr' then
						save.lang = 'en'
					elseif save.lang == 'jp' then
						save.lang = 'fr'
					elseif save.lang == 'system' then
						save.lang = 'jp'
					end
					playsound(assets.sfx_select)
					love.window.setTitle(text('hexa') .. text('dash_long') .. text('options'))
				elseif vars.selections[vars.selection] == 'rumble' then
					save.rumble = not save.rumble
					rumble(1, 1, 0.2)
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "flip" then
					save.flip = not save.flip
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "skipfanfare" then
					save.skipfanfare = not save.skipfanfare
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "hardmode" then
					save.hardmode = not save.hardmode
					playsound(assets.sfx_select)
				end
			elseif key == save.right then
				if vars.selections[vars.selection] == "music" then
					save.music = save.music + 1
					if save.music > 5 then
						save.music = 0
					end
					if save.music > 0 then
						if music ~= nil then
							volume = {save.music / 5}
						else
							newmusic('audio/music/title.mp3', true)
						end
					else
						fademusic(1)
					end
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "sfx" then
					save.sfx = save.sfx + 1
					if save.sfx > 5 then
						save.sfx = 0
					end
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == 'lang' then
					if save.lang == 'en' then
						save.lang = 'fr'
					elseif save.lang == 'fr' then
						save.lang = 'jp'
					elseif save.lang == 'jp' then
						if issteam then
							save.lang = 'system'
						else
							save.lang = 'en'
						end
					elseif save.lang == 'system' then
						save.lang = 'en'
					end
					playsound(assets.sfx_select)
					love.window.setTitle(text('hexa') .. text('dash_long') .. text('options'))
				elseif vars.selections[vars.selection] == 'rumble' then
					save.rumble = not save.rumble
					rumble(1, 1, 0.2)
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "flip" then
					save.flip = not save.flip
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "skipfanfare" then
					save.skipfanfare = not save.skipfanfare
					playsound(assets.sfx_select)
				elseif vars.selections[vars.selection] == "hardmode" then
					save.hardmode = not save.hardmode
					playsound(assets.sfx_select)
				end
			end
		elseif vars.handler == 'remap' then
			valid = true
			if vars.remap_step == 1 then
				save.up = key
			elseif vars.remap_step == 2 then
				if save.up == key then
					valid = false
				else
					save.down = key
				end
			elseif vars.remap_step == 3 then
				if save.up == key or save.down == key then
					valid = false
				else
					save.left = key
				end
			elseif vars.remap_step == 4 then
				if save.up == key or save.down == key or save.left == key then
					valid = false
				else
					save.right = key
				end
			elseif vars.remap_step == 5 then
				if save.up == key or save.down == key or save.left == key or save.right == key then
					valid = false
				else
					save.primary = key
				end
			elseif vars.remap_step == 6 then
				if save.up == key or save.down == key or save.left == key or save.right == key or save.primary == key then
					valid = false
				else
					save.secondary = key
				end
			elseif vars.remap_step == 7 then
				if save.up == key or save.down == key or save.left == key or save.right == key or save.primary == key or save.secondary == key then
					valid = false
				else
					save.tertiary = key
				end
			elseif vars.remap_step == 8 then
				if save.up == key or save.down == key or save.left == key or save.right == key or save.primary == key or save.secondary == key or save.tertiary == key then
					valid = false
				else
					save.quaternary = key
				end
			end
			-- Great pyramid, am i right?
			if valid then
				playsound(assets.sfx_select)
				vars.remap_step = vars.remap_step + 1
				if vars.remap_step > 8 then
					vars.handler = 'options'
					self:holdbuttons()
					love.filesystem.write('data.json', json.encode(save))
				end
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		end
	end
end

function options:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	for i = 1, #vars.selections do
		if vars.selection == i then
			if vars.selections[vars.selection] == 'visuals' or vars.selections[vars.selection] == 'keyboard' then
				gfx.printf(text('options_' .. vars.selections[vars.selection]), 0, -5 + (20 * i), 400, 'center')
			elseif vars.selections[vars.selection] == 'reset' then
				gfx.printf(text('options_' .. vars.selections[vars.selection] .. '_' .. vars.resetprogress), 0, -5 + (20 * i), 400, 'center')
			elseif vars.selections[vars.selection] == 'music' or vars.selections[vars.selection] == 'sfx' then
				gfx.printf(text('options_' .. vars.selections[vars.selection]) .. tostring(save[vars.selections[vars.selection]]), 0, -5 + (20 * i), 400, 'center')
			else
				gfx.printf(text('options_' .. vars.selections[vars.selection]) .. text(tostring(save[vars.selections[vars.selection]])), 0, -5 + (20 * i), 400, 'center')
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
			if vars.selections[i] == 'visuals' or vars.selections[i] == 'keyboard' then
				gfx.printf(text('options_' .. vars.selections[i]), 0, -5 + (20 * i), 400, 'center')
			elseif vars.selections[i] == 'reset' then
				gfx.printf(text('options_' .. vars.selections[i] .. '_' .. vars.resetprogress), 0, -5 + (20 * i), 400, 'center')
			elseif vars.selections[i] == 'music' or vars.selections[i] == 'sfx' then
				gfx.printf(text('options_' .. vars.selections[i]) .. tostring(save[vars.selections[i]]), 0, -5 + (20 * i), 400, 'center')
			else
				gfx.printf(text('options_' .. vars.selections[i]) .. text(tostring(save[vars.selections[i]])), 0, -5 + (20 * i), 400, 'center')
			end
		end
	end

	gfx.print('v' .. version, 65, 205)
	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('toggle'), 70, 220)
		else
			gfx.print(text('dpad') .. text('moves') .. text('a') .. text('toggle'), 70, 220)
		end
	else
		gfx.print(start(save.up) .. text('slash') .. start(save.down) .. text('move') .. start(save.primary) .. text('toggle'), 70, 220)
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	if save.color == 1 then
		gfx.setColor(hexaplex_blacks[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_1_1, 0, floor(value('fg_hexa')))
		gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_1_2, 0, floor(value('fg_hexa')))
		gfx.setColor(hexaplex_whites[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_1_3, 0, floor(value('fg_hexa')))
		gfx.setColor(1, 1, 1, 1)
		gfx.draw(assets.fg_hexa_1_4, 0, floor(value('fg_hexa')))
		gfx.setColor(hexaplex_blacks[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_1, 0, floor(value('fg_hexa') * 1.2))
		gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_2, 0, floor(value('fg_hexa') * 1.2))
		gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_3, 0, floor(value('fg_hexa') * 1.2))
		gfx.setColor(hexaplex_whites[save.hexaplex_color])
		gfx.draw(assets.fg_hexa_2_4, 0, floor(value('fg_hexa') * 1.2))
		gfx.setColor(1, 1, 1, 1)
		gfx.draw(assets.fg_hexa_2_5, 0, floor(value('fg_hexa') * 1.2))
	else
		gfx.draw(assets.fg_hexa_1, 0, floor(value('fg_hexa')))
		gfx.draw(assets.fg_hexa_2, 0, floor(value('fg_hexa') * 1.2))
	end

	if vars.handler == 'remap' then
		gfx.draw(assets.half, 0, 0)
		gfx.draw(assets.modal_small, 46, 35)

		gfx.setFont(assets.full_circle_inverted)
		if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

		button = ''
		if vars.remap_step == 1 then
			button = 'up'
		elseif vars.remap_step == 2 then
			button = 'down'
		elseif vars.remap_step == 3 then
			button = 'left'
		elseif vars.remap_step == 4 then
			button = 'right'
		elseif vars.remap_step == 5 then
			button = 'primary'
		elseif vars.remap_step == 6 then
			button = 'secondary'
		elseif vars.remap_step == 7 then
			button = 'tertiary'
		elseif vars.remap_step == 8 then
			button = 'quaternary'
		end

		gfx.printf(text('remap1') .. text(button .. 'd') .. text('remap2'), 0, 57, 400, 'center')

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
		else
			gfx.setFont(assets.half_circle_inverted)
		end

		gfx.printf(text('remap_desc') .. text(button .. '_desc'), 0, 98, 400, 'center')

		gfx.printf(text('remap_quit_' .. tostring(save.gamepad and 'start' or 'esc')), 0, 153, 400, 'center')

		gfx.setColor(1, 1, 1, 1)
	end

	draw_on_top()
end

return options