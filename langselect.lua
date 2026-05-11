local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local langselect = {}

function langselect:enter(current, ...)
	love.window.setTitle('HEXA')
	setrichpresence('steam_display', '')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		flag_en = gfx.newImage('images/' .. tostring(save.color) .. '/flag_en.png'),
		flag_fr = gfx.newImage('images/' .. tostring(save.color) .. '/flag_fr.png'),
		flag_jp = gfx.newImage('images/' .. tostring(save.color) .. '/flag_jp.png'),
		flag_select = gfx.newImage('images/' .. tostring(save.color) .. '/flag_select.png'),
	}

	vars = {
		selection = 1,
		selections = {'en', 'fr', 'jp'},
		handler = 'langselect'
	}
end

function langselect:keypressed(key)
	if not transitioning and vars.handler == 'langselect' then
		if key == save.left then
			if vars.selection <= 1 then
				shakies()
				playsound(assets.sfx_bonk)
			else
				vars.selection = vars.selection - 1
				playsound(assets.sfx_move)
			end
		elseif key == save.right then
			if vars.selection >= #vars.selections then
				shakies()
				playsound(assets.sfx_bonk)
			else
				vars.selection = vars.selection + 1
				playsound(assets.sfx_move)
			end
		elseif key == save.primary then
			save.lang = vars.selections[vars.selection]
			vars.handler = ''
			playsound(assets.sfx_select)
			scenemanager:transitionscene(title)
		end
	end
end

function langselect:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	gfx.printf('Please choose a language.\nVeuillez choisir une langue.\n言語を選択してください', 0, 18, 400, 'center')

	if vars.selections[vars.selection] == 'en' then
		gfx.printf('English', 0, 165, 140, 'center')
	elseif vars.selections[vars.selection] == 'fr' then
		gfx.printf('Français', 0, 165, 400, 'center')
	elseif vars.selections[vars.selection] == 'jp' then
		gfx.printf('日本語', 0, 165, 660, 'center')
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print('The D-pad moves. ✕ picks.', 10, 190)
			gfx.print('Croix : déplacer. ✕ : sélectionner. ', 10, 205)
			gfx.print('十字ボタンで選ぶ。 ✕で決める。', 10, 220)
		else
			gfx.print('The D-pad moves. A picks.', 10, 190)
			gfx.print('Croix : déplacer. A : sélectionner. ', 10, 205)
			gfx.print('十字ボタンで選ぶ。 Aで決める。', 10, 220)
		end
	else
		gfx.print(start(save.left) .. '/' .. start(save.right) .. ' moves. ' .. start(save.primary) .. ' picks.', 10, 190)
		gfx.print(start(save.left) .. '/' .. start(save.right) .. ' : déplacer. ' .. start(save.primary) .. ' : sélectionner. ', 10, 205)
		gfx.print(start(save.left) .. '/' .. start(save.right) .. 'で選ぶ。 ' .. start(save.primary) .. 'で決める。', 10, 220)
	end

	if vars.selections[vars.selection] ~= 'en' then
		gfx.printf('English', 0, 165, 140, 'center')
	end
	if vars.selections[vars.selection] ~= 'fr' then
		gfx.printf('Français', 0, 165, 400, 'center')
	end
	if vars.selections[vars.selection] ~= 'jp' then
		gfx.printf('日本語', 0, 165, 660, 'center')
	end

	gfx.setColor(1, 1, 1, 1)

	gfx.draw(assets.flag_en, 6, 80)
	gfx.draw(assets.flag_fr, 137, 80)
	gfx.draw(assets.flag_jp, 268, 80)

	gfx.draw(assets.flag_select, 6 + (131 * (vars.selection - 1)), 80)

	draw_on_top()
end

return langselect