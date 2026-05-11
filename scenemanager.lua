class = require 'class'
local gfx = love.graphics
local floor = math.floor

if not table.unpack then
	table.unpack = unpack
end

sfx_transition = love.audio.newSource('audio/sfx/transition.mp3', 'static')
transitiontime = 700
transitioning = false
transition = {}

scenemanager = class{
	init = function(self)
	end
}

function scenemanager:switchscene(scene, ...)
	if transitioning then return end
	self.newscene = scene
	self.sceneargs = {...}
	if vars ~= nil then
		vars.handler = ''
		vars.waiting = true
	end
	self:loadnewscene()
	transitioning = false
end

function scenemanager:transitionscene(scene, ...)
	if transitioning then return end
	podbaydoor = gfx.newImage('images/' .. tostring(save.color) .. '/podbaydoor.png')
	transitioning = true
	self.newscene = scene
	self.sceneargs = {...}
	if vars ~= nil then
		vars.handler = ''
		vars.waiting = true
	end
	playsound(sfx_transition)
	newtimer('transition', transitiontime, -0.1, 1, 'inOutCubic', function()
		self:loadnewscene()
		newtimer('transition', transitiontime, 1, -0.1, 'inOutCubic', function()
			transitioning = false
		end, transition)
	end, transition)
end

function scenemanager:loadnewscene()
	self:cleanupscene()
	love.filesystem.write('data.json', json.encode(save))
	gamestate.switch(self.newscene, table.unpack(self.sceneargs))
end

function scenemanager:cleanupscene()
	quit = 0
	timer.clear()
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
	collectgarbage('collect') -- and collect the garbage.
end

return scenemanager