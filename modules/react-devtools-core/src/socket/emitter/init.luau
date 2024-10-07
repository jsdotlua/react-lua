local Event = require("./event")

local Emitter = {}
Emitter.__index = Emitter

function Emitter.new()
	return setmetatable({
		_events = setmetatable({}, {
			__index = function(events, index)
				events[index] = Event.new()
				return events[index]
			end,
		}),
	}, Emitter)
end

function Emitter:Emit(event, ...)
	self._events[event]:Fire(...)
end

function Emitter:On(event, handler)
	return self._events[event]:Connect(handler)
end

function Emitter:Wait(event)
	return self._events[event]:Wait()
end

return Emitter
