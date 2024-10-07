local Timer = {}
Timer.__index = Timer

function Timer.new(handler)
	return setmetatable({
		Handler = handler,
		Active = false,
	}, Timer)
end

function Timer:Start(time)
	self.Active = true
	self.Time = time

	local function stepTimer()
		task.delay(self.Time, function()
			if not self.Active then
				return
			end

			task.spawn(self.Handler)
			stepTimer()
		end)
	end
	stepTimer()

	return self
end

function Timer:Stop()
	self.Active = false
end

return Timer
