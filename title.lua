game = require('game')
missions = require('missions')
statistics = require('statistics')
howtoplay = require('howtoplay')
options = require('options')
credits = require('credits')
jukebox = require('jukebox')
highscores = require('highscores')

local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local title = {}

function title:enter(current, ...)
	love.window.setTitle(text('hexa'))
	setrichpresence('steam_display', '')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		title = gfx.newImage('images/' .. tostring(save.color) .. '/title.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		logo = gfx.newImage('images/' .. tostring(save.color) .. '/logo.png'),
		half_1x = gfx.newImage('images/half_1x.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		half = gfx.newImage('images/half.png'),
		modal_small = gfx.newImage('images/' .. tostring(save.color) .. '/modal_small.png'),
		timer = gfx.newImage('images/' .. tostring(save.color) .. '/timer.png'),
	}

	vars = {
		animate = args[1],
		default = args[2],
		dailyrunnable = false,
		waiting = true,
		selection = 0,
		handler = 'title',
		selections = {'arcade', 'zen', 'dailyrun', 'missions'},
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

	if issteam then table.insert(vars.selections, 'highscores') end
	table.insert(vars.selections, 'statistics')
	table.insert(vars.selections, 'howtoplay')
	table.insert(vars.selections, 'options')
	table.insert(vars.selections, 'credits')
	table.insert(vars.selections, 'quit')

	if vars.animate then
		newtimer('title', 500, 200, 0, 'outBack')
	else
		newtimer('title', 0, 0, 0)
	end

	newmusic('audio/music/title.mp3', true)
end

function title:keypressed(key)
	if not transitioning and not vars.waiting then
		if vars.handler == 'title' then
			if key == save.tertiary then
				scenemanager:transitionscene(jukebox)
				fademusic()
				playsound(assets.sfx_select)
				vars.selection = 0
			elseif key == save.up then
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
			elseif key == save.primary then
				if vars.selections[vars.selection] == 'arcade' then
					scenemanager:transitionscene(game, 'arcade')
					fademusic()
				elseif vars.selections[vars.selection] == 'zen' then
					scenemanager:transitionscene(game, 'zen')
					fademusic()
				elseif vars.selections[vars.selection] == 'dailyrun' then
					if vars.dailyrunnable then
						scenemanager:transitionscene(game, 'dailyrun')
						save.lastdaily.score = 0
						fademusic()
						afterdelay('resetlastdaily', 0.5, function()
							save.lastdaily = os.date('!*t')
							save.lastdaily.sent = false
							love.filesystem.write('data.json', json.encode(save))
						end)
					else
						shakies()
						playsound(assets.sfx_bonk)
					end
				elseif vars.selections[vars.selection] == 'missions' then
					scenemanager:transitionscene(missions)
				elseif vars.selections[vars.selection] == 'highscores' then
					scenemanager:transitionscene(highscores, save.lbs_lastmode)
				elseif vars.selections[vars.selection] == 'statistics' then
					scenemanager:transitionscene(statistics)
				elseif vars.selections[vars.selection] == 'howtoplay' then
					scenemanager:transitionscene(howtoplay)
				elseif vars.selections[vars.selection] == 'options' then
					scenemanager:transitionscene(options)
				elseif vars.selections[vars.selection] == 'credits' then
					scenemanager:transitionscene(credits)
				elseif vars.selections[vars.selection] == 'quit' then
					vars.handler = 'quit'
					if music ~= nil then volume = {(save.music / 5) * 0.3} end
					playsound(assets.sfx_select)
				end
				if transitioning then
					playsound(assets.sfx_select)
					vars.selection = 0
				end
			end
		elseif vars.handler == 'quit' then
			if key == save.primary then
				love.event.quit()
			elseif key == save.secondary then
				if music ~= nil then volume = {save.music / 5} end
				vars.handler = 'title'
				playsound(assets.sfx_back)
			end
		end
	end
end

function title:update()
	local time = os.date('!*t')

	if save.lastdaily.year == time.year and save.lastdaily.month == time.month and save.lastdaily.day == time.day then
		vars.dailyrunnable = false
	else
		vars.dailyrunnable = true
	end
end

function title:draw()
	gfx.draw(assets.title, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))

	gfx.draw(assets.half_1x, floor((250 + value('title')) / 2) * 2, floor(212 - (20 * #vars.selections)))

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	for i = 1, #vars.selections do
		if vars.selection == i then
			gfx.printf(text(vars.selections[vars.selection]), 0, (210 - (20 * #vars.selections)) + (20 * i), 385 + floor(value('title')), 'right')
		end
	end

	if vars.selections[vars.selection] == 'arcade' then
		if save.hardmode then
			if save.hard_score ~= 0 then
				gfx.print(text('high') .. text('divvy') .. commalize(save.hard_score), 10 - floor(value('title')), 205)
			end
		else
			if save.score ~= 0 then
				gfx.print(text('high') .. text('divvy') .. commalize(save.score), 10 - floor(value('title')), 205)
			end
		end
	elseif vars.selections[vars.selection] == 'dailyrun' then
		if save.lastdaily.score ~= 0 then
			gfx.print(text('todaysscore') .. text('divvy') .. commalize(save.lastdaily.score or 0), 10 - floor(value('title')), 205)
		end
	elseif vars.selections[vars.selection] == 'missions' then
		if save.highest_mission > 1 then
			gfx.print(text('missions_completed') .. text('divvy') .. commalize(save.highest_mission - 1), 10 - floor(value('title')), 205)
		end
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	local time = os.date('!*t')

	local itext = ''
	for i = 1, #vars.selections do
		if vars.selection ~= i then
			gfx.printf(text(vars.selections[i]), 0, (210 - (20 * #vars.selections)) + (20 * i), 385 + floor(value('title')), 'right')
		end
	end

	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('select'), 10 - floor(value('title')), 220)
		else
			gfx.print(text('dpad') .. text('moves') .. text('a') .. text('select'), 10 - floor(value('title')), 220)
		end
	else
		gfx.print(start(save.up) .. text('slash') .. start(save.down) .. text('move') .. start(save.primary) .. text('select'), 10 - floor(value('title')), 220)
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.logo, 0, 0)

	if vars.selections[vars.selection] == 'dailyrun' then
		local offset = 0
		if issteam then offset = -20 end
		gfx.draw(assets.timer, 206 + floor(value('title')), 82 + offset)

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255))
			gfx.setFont(assets.full_circle_inverted)
		else
			gfx.setFont(assets.half_circle_inverted)
		end

		if time.hour < 23 then
			gfx.printf(((vars.dailyrunnable and '⏰ ') or '🔒 ') .. (24 - time.hour) .. text('hrs'), 0 + floor(value('title')), 90 + offset, 478, 'center')
		else
			if time.min < 59 then
				gfx.printf(((vars.dailyrunnable and '⏰ ') or '🔒 ') .. (60 - time.min) .. text('mins'), 0 + floor(value('title')), 90 + offset, 478, 'center')
			else
				gfx.printf(((vars.dailyrunnable and '⏰ ') or '🔒 ') .. (60 - time.sec) .. text('secs'), 0 + floor(value('title')), 90 + offset, 478, 'center')
			end
		end
	end

	gfx.setColor(1, 1, 1, 1)

	if vars.handler == 'quit' then
		gfx.draw(assets.half, 0, 0)
		gfx.draw(assets.modal_small, 46, 35)

		gfx.setFont(assets.full_circle_inverted)
		if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

		gfx.printf(text('quit_sure_1'), 0, 62, 400, 'center')

		if save.color == 1 then
			gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
		else
			gfx.setFont(assets.half_circle_inverted)
		end

		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.printf(text('quit_sure_2_options'), 0, 103, 400, 'center')
			else
				gfx.printf(text('quit_sure_2_start'), 0, 103, 400, 'center')
			end
		else
			gfx.printf(text('quit_sure_2_esc'), 0, 103, 400, 'center')
		end

		if save.gamepad then
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.printf(text('cross') .. text('quits') .. text('circle') .. text('back'), 0, 160, 400, 'center')
			else
				gfx.printf(text('a') .. text('quits') .. text('b') .. text('back'), 0, 160, 400, 'center')
			end
		else
			gfx.printf(start(save.primary) .. text('quits') .. start(save.secondary) .. text('back'), 0, 160, 400, 'center')
		end

		gfx.setColor(1, 1, 1, 1)
	end

	draw_on_top()
end

return title