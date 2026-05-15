local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local statistics = {}

function statistics:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('statistics'))
	setrichpresence('steam_display', '#status_statistics')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒整割振解放画面効果減少', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
	}

	vars = {
		waiting = true,
	}
	afterdelay('input_wait', transitiontime, function()
		vars.waiting = false
	end)
end

function statistics:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'statistics')
		end
	end
end

function statistics:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.print(commalize(save.swaps), 250, 5)
	gfx.print(commalize(save.hexas), 250, 20)
	if save.swaps > 0 and save.hexas > 0 then
		gfx.print(string.format('%.2f', save.swaps / save.hexas) .. ':1', 250, 35)
	else
		gfx.print(text('na'), 250, 35)
	end
	gfx.print(commalize(save.score), 250, 50)
	gfx.print(commalize(save.hard_score), 250, 65)
	local playhours, playmins, playsecs = timecalchour(save.playtime)
	gfx.print(playhours .. 'h ' .. playmins .. 'm ' .. playsecs .. 's', 250, 80)
	local gamehours, gamemins, gamesecs = timecalchour(save.gametime)
	gfx.print(gamehours .. 'h ' .. gamemins .. 'm ' .. gamesecs .. 's', 250, 95)
	gfx.print(commalize(save.total_score), 250, 110)
	gfx.print(commalize(save.black_match), 250, 125)
	gfx.print(commalize(save.gray_match), 250, 140)
	gfx.print(commalize(save.white_match), 250, 155)
	gfx.print(commalize(save.double_match), 250, 170)
	gfx.print(commalize(save.bomb_match), 250, 185)
	gfx.print(commalize(save.wild_match), 250, 200)

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
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

	gfx.printf(text('totalswaps'), 0, 5, 240, 'right')
	gfx.printf(text('totalhexas'), 0, 20, 240, 'right')
	gfx.printf(text('swapshexas'), 0, 35, 240, 'right')
	gfx.printf(text('highscore'), 0, 50, 240, 'right')
	gfx.printf(text('highscorehardmode'), 0, 65, 240, 'right')
	gfx.printf(text('playtime'), 0, 80, 240, 'right')
	gfx.printf(text('gametime'), 0, 95, 240, 'right')
	gfx.printf(text('totalscore'), 0, 110, 240, 'right')
	gfx.printf(text('hexablack'), 0, 125, 240, 'right')
	gfx.printf(text('hexagray'), 0, 140, 240, 'right')
	gfx.printf(text('hexawhite'), 0, 155, 240, 'right')
	gfx.printf(text('hexadouble'), 0, 170, 240, 'right')
	gfx.printf(text('kerplosion'), 0, 185, 240, 'right')
	gfx.printf(text('hexawild'), 0, 200, 240, 'right')

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return statistics