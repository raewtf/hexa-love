-- Wrapper functions for the knife timer library. made by rae

function newtimer(name, duration, startvalue, endvalue, easing, callback, group)
	if vars ~= nil then
		if vars[name] ~= nil then
			vars[name]:remove()
			vars[name] = nil
		end
		if easing == nil then easing = 'linear' end
		vars[name .. 'value'] = startvalue
		vars[name] = timer.tween(duration / 1000, {
			[vars] = {[name .. 'value'] = endvalue}
		})
			:ease(easings[easing])
			:group(group or nil)
		vars[name].timerEndedCallback = callback or nil
		vars[name]:finish(vars[name].timerEndedCallback)
	end
end

function pausetimer(name)
	vars[name]:remove()
end

function playtimer(name)
	vars[name]:register()
end

function timerendedcallback(name, callback)
	vars[name].timerEndedCallback = callback or nil
	vars[name]:finish(vars[name].timerEndedCallback)
end

function timeleft(name)
	if vars[name] ~= nil then
		local elapsed = vars[name].elapsed
		local duration = vars[name].duration
		local timeleft = duration - elapsed
		if timeleft < 0 then timeleft = 0 end
		return (timeleft) * 1000
	elseif vars[name .. 'value'] ~= nil then
		return vars[name .. 'value']
	else
		return 0
	end
end

function value(name)
	return vars[name .. 'value']
end

function resettimer(name, duration, startvalue, endvalue, easing, callback, group)
	if vars ~= nil then
		if vars[name] ~= nil then
			vars[name]:remove()
			vars[name] = nil
		end
		if easing == nil then easing = 'linear' end
		vars[name .. 'value'] = startvalue
		vars[name] = timer.tween(duration / 1000, {
			[vars] = {[name .. 'value'] = endvalue}
		})
			:ease(easings[easing])
			:group(group or nil)
		vars[name].timerEndedCallback = callback or nil
		vars[name]:finish(vars[name].timerEndedCallback)
	end
end

function loopingtimer(name, duration, startvalue, endvalue, easing, callback, group, delay)
	newtimer(name, duration, startvalue, endvalue, easing, function()
		loopingtimer(name, duration, startvalue, endvalue, easing, callback, group)
	end, group)
end

function loopingreversingtimer(name, duration, startvalue, endvalue, easing, callback, group, delay)
	newtimer(name, duration, startvalue, endvalue, easing, function()
		loopingreversingtimer(name, duration, endvalue, startvalue, easing, callback, group)
	end, group)
end

function delaytimer(name, delay, duration, startvalue, endvalue, easing, callback, group)
	if vars ~= nil then
		vars[name .. 'value'] = startvalue
		vars[name .. 'delay'] = timer.after(delay / 1000, function()
			if vars[name .. 'value'] ~= nil then
				newtimer(name, duration, startvalue, endvalue, easing, callback, group)
			end
		end)
	end
end

function loopingdelaytimer(name, delay, duration, startvalue, endvalue, easing, callback, group)
	delaytimer(name, delay, duration, startvalue, endvalue, easing, function()
		loopingdelaytimer(name, delay, duration, startvalue, endvalue, easing, callback, group)
	end, group)
end

function afterdelay(name, duration, callback)
	if vars ~= nil then
		vars[name .. 'gate'] = true
		vars[name] = timer.after(duration / 1000, function()
			if vars[name .. 'gate'] ~= nil then
				callback()
			end
		end)
	end
end