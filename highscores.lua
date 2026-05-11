local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local highscores = {}

function highscores:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('highscores'))
	setrichpresence('steam_display', '#status_highscores')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
	}

	vars = {
		mode = args[1] or 'arcade',
		result = {},
		best = {},
		loading = false,
		waiting = true,
	}
	afterdelay('input_wait', transitiontime, function()
		vars.waiting = false
	end)

	self:refreshboards(vars.mode)

	if save.reduceflashing then
		vars.blinkvalue = 1
	else
		loopingtimer('blink', 1000, 1.99, 0.5)
	end
end

function highscores:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.primary then
			if vars.mode == 'arcade' then
				self:refreshboards('dailyrun')
			elseif vars.mode == 'dailyrun' then
				self:refreshboards('arcade')
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'highscores')
		end
	end
end

function highscores:refreshboards(mode)
	if not vars.loading then
		vars.result = {}
		vars.best = {}
		vars.loading = true
		vars.mode = mode
		local time = os.date('!*t')
		steam.userStats.findOrCreateLeaderboard(vars.mode == 'arcade' and ((save.hardmode and 'hard' .. vars.mode) or (vars.mode)) or vars.mode == 'dailyrun' and (((save.hardmode and 'hard' .. vars.mode) or (vars.mode)) .. time.year .. time.month .. time.day), 'Descending', 'Numeric', function(data, err)
			if err then
				vars.result = 'fail'
			else
				steam.userStats.downloadLeaderboardEntries(data.steamLeaderboard, 'Global', 1, 9, function(data2, err)
					if err then
						vars.result = 'fail'
						vars.loading = false
					elseif vars.result ~= nil then
						vars.result.scores = {}
						for _, user in ipairs(data2) do
							table.insert(vars.result.scores, {})
							vars.result.scores[user.globalRank].rank = user.globalRank
							vars.result.scores[user.globalRank].player = steam.friends.getFriendPersonaName(user.steamIDUser)
							vars.result.scores[user.globalRank].value = user.score
						end
						steam.userStats.downloadLeaderboardEntries(data.steamLeaderboard, 'GlobalAroundUser', 0, 0, function(data3, err)
							if not err and vars.best ~= nil then
								for _, user in ipairs(data3) do
									vars.best.rank = user.globalRank
									vars.best.value = user.score
								end
							end
							vars.loading = false
						end)
					end
				end)
			end
		end)
	end
end

function highscores:update()
	local time = os.date('!*t')

	if time.hour == 0 and time.min == 0 and time.sec == 0 and not vars.loading and vars.mode == 'dailyrun' then
		self:refreshboards(vars.mode)
	end
end

function highscores:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if vars.mode == 'arcade' then
		gfx.printf(text('arcade'), 0, 10, 400, 'center')
	elseif vars.mode == 'dailyrun' then
		gfx.printf(text('dailyrun'), 0, 10, 400, 'center')
	end

	if vars.result.scores ~= nil and next(vars.result.scores) ~= nil and not vars.loading then
		for _, v in ipairs(vars.result.scores) do
			gfx.print(v.player,  90, 30 + (15 * v.rank))
		end
	end

	if vars.best.rank ~= nil then
		gfx.printf(text('lbscore1') .. commalize(vars.best.value) .. text('lbscore2') .. ordinal(vars.best.rank) .. text('lbscore3'), 0, 185, 400, 'center')
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if vars.mode == 'arcade' then
		gfx.printf(text('highscores') .. (save.hardmode and text('hard') or ''), 0, 25, 400, 'center')
	elseif vars.mode == 'dailyrun' then
		local time = os.date('!*t')
		if time.hour < 23 then
			gfx.printf(text('todaysscores') .. (save.hardmode and text('hard') or '') .. '   ⏰ ' .. (24 - time.hour) .. text('hrs'), 0, 25, 400, 'center')
		elseif time.min < 59 then
			gfx.printf(text('todaysscores') .. (save.hardmode and text('hard') or '') .. '   ⏰ ' .. (60 - time.min) .. text('mins'), 0, 25, 400, 'center')
		else
			gfx.printf(text('todaysscores') .. (save.hardmode and text('hard') or '') .. '   ⏰ ' .. (60 - time.sec) .. text('secs'), 0, 25, 400, 'center')
		end
	end

	if vars.result.scores ~= nil and next(vars.result.scores) ~= nil and not vars.loading then
		for _, v in ipairs(vars.result.scores) do
			gfx.printf(ordinal(v.rank), 0, 30 + (15 * v.rank), 80, 'right')
			gfx.printf(commalize(v.value), 0, 30 + (15 * v.rank), 340, 'right')
		end
	elseif vars.result == 'fail' then
		gfx.printf(text('failedscores'), 0, 110, 400, 'center')
	else
		if vars.loading then
			gfx.printf(text('gettingscores'), 0, 110, 400, 'center')
		else
			gfx.printf(text('emptyscores_' .. vars.mode), 0, 110, 400, 'center')
		end
	end

	if vars.loading then
		if save.gamepad then -- Gamepad
			if current_vendor == 1356 then -- playstation controller (or otherwise sony)
				gfx.print(text('cross') .. text('inasec'), 65, 205)
			else
				gfx.print(text('a') .. text('inasec'), 65, 205)
			end
		else
			gfx.print(start(save.primary) .. text('inasec'), 65, 205)
		end
	else
		if vars.mode == 'arcade' then
			if save.gamepad then -- Gamepad
				if current_vendor == 1356 then -- playstation controller (or otherwise sony)
					gfx.print(text('cross') .. text('dailyscores'), 65, 205)
				else
					gfx.print(text('a') .. text('dailyscores'), 65, 205)
				end
			else
				gfx.print(start(save.primary) .. text('dailyscores'), 65, 205)
			end

		elseif vars.mode == 'dailyrun' then
			if save.gamepad then -- Gamepad
				if current_vendor == 1356 then -- playstation controller (or otherwise sony)
					gfx.print(text('cross') .. text('arcadescores'), 65, 205)
				else
					gfx.print(text('a') .. text('arcadescores'), 65, 205)
				end
			else
				gfx.print(start(save.primary) .. text('arcadescores'), 65, 205)
			end

		end
	end

	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('circle') .. text('back'), 70, 220)
		else
			gfx.print(text('b') .. text('back'), 70, 220)
		end
	else
		gfx.print(start(save.secondary) .. text('back'), 70, 220)
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return highscores