local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local credits = {}

function credits:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('credits'))
	setrichpresence('steam_display', '#status_credits')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg_credits.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒整割振解放画面効果減少', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻整割振解放画面効果減少', 0),
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

function credits:keypressed(key)
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
			if vars.page < 3 then
				vars.page = vars.page + 1
				playsound(assets.sfx_move)
			else
				playsound(assets.sfx_bonk)
				shakies()
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(title, false, 'credits')
		end
	end
end

function credits:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)


	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.printf(text('credits' .. vars.page), 0, 5, 400, 'center')

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		gfx.print(text('dpad') .. text('pages'), 65, 205)
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('circle') .. text('back'), 70, 220)
		else
			gfx.print(text('b') .. text('back'), 70, 220)
		end
	else
		gfx.print(start(save.left) .. '/' .. start(save.right) .. text('page'), 65, 205)
		gfx.print(start(save.secondary) .. text('back'), 70, 220)
	end

	gfx.printf(vars.page .. '/3', 0, 220, 330, 'right')

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return credits