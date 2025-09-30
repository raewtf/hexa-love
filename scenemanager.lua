class = require 'class'
local gfx = love.graphics
local floor = math.floor

if not table.unpack then
	table.unpack = unpack
end

sfx_transition = love.audio.newSource('audio/sfx/transition.mp3', 'static')
podbaydoorstatus = {pos1 = -230, pos2 = 410}
transitiontime = 0.7
transitioning = false

scenemanager = class{
	init = function(self, transitiontime, transitioning)
	end
}

function scenemanager:switchscene(scene, ...)
	self.newscene = scene
	self.sceneargs = {...}
	self:loadnewscene()
	transitioning = false
end

function scenemanager:transitionscene(scene, ...)
	if transitioning then return end
	podbaydoor = gfx.newImage('images/' .. tostring(save.color) .. '/podbaydoor.png')
	transitioning = true
	self.newscene = scene
	self.sceneargs = {...}
	playsound(sfx_transition)
	self.timer = timer.tween(transitiontime, podbaydoorstatus, {pos1 = -10, pos2 = 202}, 'in-out-cubic', function()
		self:loadnewscene()
		self.timer = timer.tween(transitiontime, podbaydoorstatus, {pos1 = -230, pos2 = 410}, 'in-out-cubic', function()
			transitioning = false
		end)
	end)
end

function scenemanager:loadnewscene()
	self:cleanupscene()
	love.filesystem.write('data.json', json.encode(save))
	gamestate.switch(self.newscene, table.unpack(self.sceneargs))
end

function scenemanager:cleanupscene()
	quit = 0
	if classes ~= nil then
		for i = #classes, 1, -1 do
			classes[i] = nil
		end
		classes = nil
	end
	classes = {}
	if sprites ~= nil then
		for i = 1, #sprites do
			sprites[i] = nil
		end
	end
	sprites = {}
	if assets ~= nil then
		for i = 1, #assets do
			assets[i] = nil
		end
		assets = nil -- Nil all the assets,
	end
	if vars ~= nil then
		for i = 1, #vars do
			vars[i] = nil
		end
	end
	vars = nil -- and nil all the variables.
	timer.clear()
	collectgarbage('collect') -- and collect the garbage.
end

return scenemanager