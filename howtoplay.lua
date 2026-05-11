local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local howtoplay = {}

function howtoplay:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('howtoplay'))
	setrichpresence('steam_display', '#status_howtoplay')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		manual1 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-1.png'),
		manual2 = gfx.newImage('images/2/manual-table-2.png'),
		manual2_1 = gfx.newImage('images/1/manual-table-2_1.png'),
		manual2_2 = gfx.newImage('images/1/manual-table-2_2.png'),
		manual2_3 = gfx.newImage('images/1/manual-table-2_3.png'),
		manual2_4 = gfx.newImage('images/1/manual-table-2_4.png'),
		manual2_5 = gfx.newImage('images/1/manual-table-2_5.png'),
		manual3 = gfx.newImage('images/2/manual-table-3.png'),
		manual3_1 = gfx.newImage('images/1/manual-table-3_1.png'),
		manual3_2 = gfx.newImage('images/1/manual-table-3_2.png'),
		manual3_3 = gfx.newImage('images/1/manual-table-3_3.png'),
		manual4 = gfx.newImage('images/2/manual-table-4.png'),
		manual4_1 = gfx.newImage('images/1/manual-table-4_1.png'),
		manual4_2 = gfx.newImage('images/1/manual-table-4_2.png'),
		manual4_3 = gfx.newImage('images/1/manual-table-4_3.png'),
		manual4_4 = gfx.newImage('images/1/manual-table-4_4.png'),
		manual4_5 = gfx.newImage('images/1/manual-table-4_5.png'),
		manual5 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-5.png'),
		manual6 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-6.png'),
		manual7 = gfx.newImage('images/' .. tostring(save.color) .. '/manual-table-7.png'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
	}

	vars = {
		page = 1,
		waiting = true,
	}
	afterdelay('input_wait', transitiontime, function()
		vars.waiting = false
	end)
end

function howtoplay:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.left then
			if vars.page > 1 then
				vars.page = vars.page - 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == save.right then
			if vars.page < 7 then
				vars.page = vars.page + 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'howtoplay')
		end
	end
end

function howtoplay:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)

	if vars.page == 2 or vars.page == 4 then
		if save.color == 1 then
			gfx.setColor(hexaplex_blacks[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_1'], 225, 40)
			gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_2'], 225, 40)
			gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_3'], 225, 40)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets['manual' .. vars.page .. '_4'], 225, 40)
			gfx.setColor(hexaplex_whites[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_5'], 225, 40)
		else
			gfx.draw(assets['manual' .. vars.page], 225, 40)
		end
	elseif vars.page == 3 then
		if save.color == 1 then
			gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_1'], 225, 40)
			gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
			gfx.draw(assets['manual' .. vars.page .. '_2'], 225, 40)
			gfx.setColor(1, 1, 1, 1)
			gfx.draw(assets['manual' .. vars.page .. '_3'], 225, 40)
		else
			gfx.draw(assets['manual' .. vars.page], 225, 40)
		end
	else
		gfx.draw(assets['manual' .. vars.page], 225, 40)
	end

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.print(text('manual' .. vars.page), 10, 10)

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('dpad') .. text('pages') .. text('circle') .. text('back'), 10, 220)
		else
			gfx.print(text('dpad') .. text('pages') .. text('b') .. text('back'), 10, 220)
		end
	else
		gfx.print(start(save.left) .. text('slash') .. start(save.right) .. text('page') .. start(save.secondary) .. text('back'), 10, 220)
	end
	gfx.printf(vars.page .. '/7', 0, 220, 390, 'right')

	draw_on_top()
end

return howtoplay