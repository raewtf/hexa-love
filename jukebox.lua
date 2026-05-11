local gfx = love.graphics
local floor = math.floor
local text = getLocalizedText
local jukebox = {}

function jukebox:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('jukebox'))
	setrichpresence('steam_display', '#status_jukebox')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png'),
		img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png'),
		stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png'),
		stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png'),
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		ship = newAnimation(gfx.newImage('images/' .. tostring(save.color) .. '/ship.png'), 139, 75, 0.4),
	}

	vars = {
		tunes = {'arcade1', 'arcade2', 'arcade3', 'title', 'zen1', 'zen2'},
		num = 6,
		showtext = true,
		waiting = true,
	}
	afterdelay('input_wait', transitiontime, function()
		vars.waiting = false
	end)

	newtimer('ship_x', 1700, -100, 200, 'outCubic')
	newtimer('text_y', 0, 0, 0)

	if save.music > 0 then
		self:shuffle()
	end
end

function jukebox:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.primary then
			vars.showtext = not vars.showtext
			if vars.showtext then
				resettimer('text_y', 300, value('text_y'), 0, 'outBack')
			else
				resettimer('text_y', 300, value('text_y'), 50, 'inBack')
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			resettimer('ship_x', 700, value('ship_x'), 500, 'inBack')
			afterdelay('delay', 400, function()
				scenemanager:transitionscene(title, false, 'arcade')
			end)
			fademusic()
		end
	end
end

function jukebox:update(dt)
	if music == nil and not transitioning and save.music > 0 then self:shuffle() end
	assets.ship.currentTime = assets.ship.currentTime + dt
	if assets.ship.currentTime >= assets.ship.duration then
		assets.ship.currentTime = assets.ship.currentTime - assets.ship.duration
	end
end

function jukebox:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), 0)
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), 0)
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	if (save.music > 0) and vars.rand ~= nil then
		gfx.print(text('music_' .. vars.tunes[vars.rand]), 10, 205 + floor(value('text_y')))
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('cross') .. text('toggles_text') .. text('circle') .. text('back'), 10, 220 + floor(value('text_y')))
		else
			gfx.print(text('a') .. text('toggles_text') .. text('b') .. text('back'), 10, 220 + floor(value('text_y')))
		end
	else
		gfx.print(start(save.primary) .. text('toggles_text') .. start(save.secondary) .. text('back'), 10, 220 + floor(value('text_y')))
	end

	gfx.setColor(1, 1, 1, 1)

	local spritenum = floor(assets.ship.currentTime / assets.ship.duration * #assets.ship.quads) + 1
	gfx.draw(assets.ship.spriteSheet, assets.ship.quads[spritenum], floor(value('ship_x')), 120, 0, 1, 1, 69, 37)

	draw_on_top()
end

function jukebox:shuffle()
	vars.rand = randInt(1, vars.num)
	newmusic('audio/music/' .. vars.tunes[vars.rand] .. '.mp3')
end

return jukebox