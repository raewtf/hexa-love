local gfx = love.graphics
local floor = math.floor
local min = math.min
local text = getLocalizedText
local visuals = {}

function visuals:reload_images()
	assets.stars_small = gfx.newImage('images/' .. tostring(save.color) .. '/stars_small.png')
	assets.stars_large = gfx.newImage('images/' .. tostring(save.color) .. '/stars_large.png')
	assets.fg = gfx.newImage('images/' .. tostring(save.color) .. '/fg.png')
	assets.img25 = gfx.newImage('images/' .. tostring(save.color) .. '/25.png')
	assets.bg = gfx.newImage('images/' .. tostring(save.color) .. '/bg.png')
	love.window.setIcon(save.color == 2 and icon_color or icon_peedee)
end

function visuals:enter(current, ...)
	love.window.setTitle(text('hexa') .. text('dash_long') .. text('options_visuals'))
	setrichpresence('steam_display', '#status_options')
	local args = {...} -- Arguments passed in through the scene management will arrive here

	assets = {
		full_circle_inverted = gfx.newImageFont('fonts/full-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�àçéèêîôÀûÇÉÈÊÎÔÛ゠ーシドトジスズセゼソゾタダサザコゴンマツヅテデナニヌネッハノカガキギクオォエグケゲェホボポミペベヘフブプヒビピバパチヂイゥィウアァムリルレロョヨラユュモメヤャワヮヰヱヲヴヵヷヸヿヾヽ・ヺヶヹしじすずせぜそぞざさこごぐくぎきがかおぉえぇうぅいぃただちぢっつづてでへべぺとどふぶぷのり゛゜ゝゞむみねにげけわゎゟゖゕゔんはばぱまぽぼほひびぴるれろをゑゐぬよょならゆゅもあぁやゃめüúùøËÕÖÓÒØëáâãäåæïíìÏÍÌÜÚÙ×ÁÂÃÄÅÆÐÑÝÞñóòõö÷þýÿðß¿¡¨°®©¯±²³´µ¶·¸¹º»«¼½¾§¥¤£¢¦ª¬制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻⏰🔒', 0),
		half_circle_inverted = gfx.newImageFont('fonts/half-circle-inverted.png', '0123456789 !"#$%&\'()*+,-./:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~�⏰🔒àçéèêîôûÀÇÉÈÊÎÔÛ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヺヹ・ーヽヾヿぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ゛゜ゝゞゟ制回取数替日消作少選今使形得了倍方早明時終🎵色角択中二人開乗間六内動合宇。宙本目転一全向押灰分秒反戻自者語英決！完限表示獲設定音量言（）安黒２十字位誰読込書出切詳細高指前成編集的値名確認起点保存先共有達、統組五図？食来遊変更新登録失敗１５０最大削除当爆発支配土下座負任務四部報告船準備練習物挑戦息忘昨休水補給折紙見元気君長奇妙説『』呼同操繰返利通常盤体重他場残増延基疑問入聞無視△✕º◻', 0),
		sfx_move = love.audio.newSource('audio/sfx/swap.mp3', 'static'),
		sfx_select = love.audio.newSource('audio/sfx/select.mp3', 'static'),
		sfx_back = love.audio.newSource('audio/sfx/back.mp3', 'static'),
		sfx_bonk = love.audio.newSource('audio/sfx/bonk.mp3', 'static'),
		quad = gfx.newQuad(0, 0, 400, 125, 400, 240),
		hexaplex = gfx.newImage('images/2/manual-table-2.png'),
		hexaplex1 = gfx.newImage('images/1/manual-table-2_1.png'),
		hexaplex2 = gfx.newImage('images/1/manual-table-2_2.png'),
		hexaplex3 = gfx.newImage('images/1/manual-table-2_3.png'),
		hexaplex4 = gfx.newImage('images/1/manual-table-2_4.png'),
		hexaplex5 = gfx.newImage('images/1/manual-table-2_5.png'),
	}

	self:reload_images()

	vars = {
		waiting = true,
		selection = 0,
		selections = {'scale', 'clean_scaling', 'fullscreen', 'reduceflashing', 'color', 'hexaplex_color'},
	}
	afterdelay('input_wait', transitiontime, function()
		vars.waiting = false
		vars.selection = 1
	end)
end

function visuals:keypressed(key)
	if not transitioning and not vars.waiting then
		if key == save.up then
			if vars.selection ~= 0 then
				if vars.selection > 1 then
					vars.selection = vars.selection - 1
				else
					vars.selection = (#vars.selections - (save.color == 1 and 0 or 1))
				end
				playsound(assets.sfx_move)
			end
		elseif key == save.down then
			if vars.selection ~= 0 then
				if vars.selection < (#vars.selections - (save.color == 1 and 0 or 1)) then
					vars.selection = vars.selection + 1
				else
					vars.selection = 1
				end
				playsound(assets.sfx_move)
			end
		elseif key == save.secondary then
			playsound(assets.sfx_back)
			scenemanager:transitionscene(options, 'visuals')
			vars.selection = 0
		elseif key == save.primary then
			if vars.selections[vars.selection] == 'scale' then
				save.scale = save.scale + 1
				if save.scale > 4 then
					save.scale = 1
				end
				rescale(save.scale)
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'clean_scaling' then
				save.clean_scaling = not save.clean_scaling
				playsound(assets.sfx_select)
				local w, h, _ = love.window.getMode()
				love.resize(w, h)
			elseif vars.selections[vars.selection] == 'fullscreen' then
				save.fullscreen = not save.fullscreen
				playsound(assets.sfx_select)
				love.window.setFullscreen(save.fullscreen)
				if not save.fullscreen and scale ~= save.scale then rescale(save.scale) end
			elseif vars.selections[vars.selection] == 'reduceflashing' then
				save.reduceflashing = not save.reduceflashing
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'color' then
				save.color = save.color + 1
				if save.color > 2 then
					save.color = 1
				end
				self:reload_images()
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'hexaplex_color' then
				if save.color == 1 then
					save.hexaplex_color = save.hexaplex_color + 1
					local score = save.score
					if save.hard_score > save.score then score = save.hard_score end
					if save.hexaplex_color > min(1 + floor(score / 1000), 26) then
						save.hexaplex_color = 1
					end
					playsound(assets.sfx_select)
				elseif save.color == 2 then
					shakies()
					playsound(assets.sfx_bonk)
				end
			end
		elseif key == save.left then
			if vars.selections[vars.selection] == 'scale' then
				save.scale = save.scale - 1
				if save.scale < 1 then
					save.scale = 4
				end
				rescale(save.scale)
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'clean_scaling' then
				save.clean_scaling = not save.clean_scaling
				playsound(assets.sfx_select)
				local w, h, _ = love.window.getMode()
				love.resize(w, h)
			elseif vars.selections[vars.selection] == 'fullscreen' then
				save.fullscreen = not save.fullscreen
				playsound(assets.sfx_select)
				love.window.setFullscreen(save.fullscreen)
				if not save.fullscreen and scale ~= save.scale then rescale(save.scale) end
			elseif vars.selections[vars.selection] == 'reduceflashing' then
				save.reduceflashing = not save.reduceflashing
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'color' then
				save.color = save.color - 1
				if save.color < 1 then
					save.color = 2
				end
				self:reload_images()
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'hexaplex_color' then
				if save.color == 1 then
					save.hexaplex_color = save.hexaplex_color - 1
					local score = save.score
					if save.hard_score > save.score then score = save.hard_score end
					if save.hexaplex_color < 1 then
						save.hexaplex_color = min(1 + floor(score / 1000), 26)
					end
					playsound(assets.sfx_select)
				elseif save.color == 2 then
					shakies()
					playsound(assets.sfx_bonk)
				end
			end
		elseif key == save.right then
			if vars.selections[vars.selection] == 'scale' then
				save.scale = save.scale + 1
				if save.scale > 4 then
					save.scale = 1
				end
				rescale(save.scale)
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'clean_scaling' then
				save.clean_scaling = not save.clean_scaling
				playsound(assets.sfx_select)
				local w, h, _ = love.window.getMode()
				love.resize(w, h)
			elseif vars.selections[vars.selection] == 'fullscreen' then
				save.fullscreen = not save.fullscreen
				playsound(assets.sfx_select)
				love.window.setFullscreen(save.fullscreen)
				if not save.fullscreen and scale ~= save.scale then rescale(save.scale) end
			elseif vars.selections[vars.selection] == 'reduceflashing' then
				save.reduceflashing = not save.reduceflashing
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'color' then
				save.color = save.color + 1
				if save.color > 2 then
					save.color = 1
				end
				self:reload_images()
				playsound(assets.sfx_select)
			elseif vars.selections[vars.selection] == 'hexaplex_color' then
				if save.color == 1 then
					save.hexaplex_color = save.hexaplex_color + 1
					local score = save.score
					if save.hard_score > save.score then score = save.hard_score end
					if save.hexaplex_color > min(1 + floor(score / 1000), 26) then
						save.hexaplex_color = 1
					end
					playsound(assets.sfx_select)
				elseif save.color == 2 then
					shakies()
					playsound(assets.sfx_bonk)
				end
			end
		end
	end
end

function visuals:update()
	save.fullscreen = love.window.getFullscreen()
end

function visuals:draw()
	gfx.draw(assets.bg, 0, 0)
	local counter = save.playtime
	gfx.draw(assets.stars_small, floor(-(counter % 133) * 3), floor(-(counter % 97) * 2.45))
	gfx.draw(assets.stars_large, floor(-(counter % 83) * 4.8), floor(-(counter % 42) * 5.7))
	gfx.draw(assets.img25, 0, 0)

	gfx.setFont(assets.full_circle_inverted)
	if save.color == 1 then gfx.setColor(love.math.colorFromBytes(255, 241, 232, 255)) end

	for i = 1, #vars.selections do
		if vars.selection == i then
			if vars.selections[vars.selection] == 'scale' then
				gfx.printf(text(vars.selections[vars.selection]) .. tostring(save[vars.selections[vars.selection]]), 0, -5 + (15 * i), 400, 'center')
			elseif vars.selections[vars.selection] == 'reduceflashing' or vars.selections[vars.selection] == 'fullscreen' then
				gfx.printf(text(vars.selections[vars.selection]) .. text(tostring(save[vars.selections[vars.selection]])), 0, -5 + (15 * i), 400, 'center')
			elseif vars.selections[vars.selection] == 'hexaplex_color' then
				gfx.printf(text('hexaplex_color') .. text('hexaplex_' .. save.hexaplex_color), 0, -5 + (15 * i), 400, 'center')
			else
				gfx.printf(text(vars.selections[vars.selection]) .. text(vars.selections[vars.selection] .. tostring(save[vars.selections[vars.selection]])), 0, -5 + (15 * i), 400, 'center')
			end
		end
	end

	if save.color == 1 then
		gfx.setColor(love.math.colorFromBytes(255, 241, 232, 127))
	else
		gfx.setFont(assets.half_circle_inverted)
	end

	if save.gamepad then -- Gamepad
		if current_vendor == 1356 then -- playstation controller (or otherwise sony)
			gfx.print(text('dpad') .. text('moves') .. text('cross') .. text('toggle'), 70, 220)
		else
			gfx.print(text('dpad') .. text('moves') .. text('a') .. text('toggle'), 70, 220)
		end
	else
		gfx.print(start(save.up) .. text('slash') .. start(save.down) .. text('move') .. start(save.primary) .. text('toggle'), 70, 220)
	end

	for i = 1, #vars.selections do
		if vars.selection ~= i then
			if vars.selections[i] == 'scale' then
				gfx.printf(text(vars.selections[i]) .. tostring(save[vars.selections[i]]), 0, -5 + (15 * i), 400, 'center')
			elseif vars.selections[i] == 'reduceflashing' or vars.selections[i] == 'fullscreen' then
				gfx.printf(text(vars.selections[i]) .. text(tostring(save[vars.selections[i]])), 0, -5 + (15 * i), 400, 'center')
			elseif vars.selections[i] == 'hexaplex_color' then
				gfx.printf(text('hexaplex_color') .. text('hexaplex_' .. save.hexaplex_color), 0, -5 + (15 * i), 400, 'center')
			else
				gfx.printf(text(vars.selections[i]) .. text(vars.selections[i] .. tostring(save[vars.selections[i]])), 0, -5 + (15 * i), 400, 'center')
			end
		end
	end

	if save.color == 1 then
		local score = save.score
		if save.hard_score > save.score then score = save.hard_score end
		gfx.printf(min(1 + floor(score / 1000), 26) .. text('slash') .. 26 .. text('unlocked'), 0, 120, 230, 'center')
		if 1 + floor(score / 1000) >= 26 then
			gfx.printf(text('hexaplex_color_all'), 0, 140, 230, 'center')
		else
			gfx.printf(text('hexaplex_color_locked'), 0, 140, 230, 'center')
		end
	end

	gfx.setColor(1, 1, 1, 1)

	if save.color == 1 then
		gfx.setColor(hexaplex_blacks[save.hexaplex_color])
		gfx.draw(assets.hexaplex1, 165, 80)
		gfx.setColor(hexaplex_gray1s[save.hexaplex_color])
		gfx.draw(assets.hexaplex2, 165, 80)
		gfx.setColor(hexaplex_gray2s[save.hexaplex_color])
		gfx.draw(assets.hexaplex3, 165, 80)
		gfx.setColor(1, 1, 1, 1)
		gfx.draw(assets.hexaplex4, 165, 80)
		gfx.setColor(hexaplex_whites[save.hexaplex_color])
		gfx.draw(assets.hexaplex5, 165, 80)
	else
		gfx.draw(assets.hexaplex, 115, 80)
		gfx.draw(assets.img25, assets.quad, 0, 86)
	end
	gfx.setColor(1, 1, 1, 1)
	gfx.draw(assets.fg, 0, 0)

	draw_on_top()
end

return visuals