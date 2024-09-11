--!strict

--[[
	Lune instances are tables containing a reference to the instance, but Lune
	creates different tables even for the same instance. Jest's caching behavior
	depends on the instance always being the same to look it up by key, so this
	function serves to always return the same "wrapped" instance when given the
	same instance. It has to also override the `FindFirstChild`, `WaitForChild`,
	and `Instance` property getter to ensure they also return a "wrapped"
	instance.
--]]

local roblox = require("@lune/roblox")

local ReducedInstance = {}
ReducedInstance._cache = {}

function ReducedInstance.once(instance: roblox.Instance): roblox.Instance
	assert(instance, "Instance is nil")

	local fullName = instance:GetFullName()
	if ReducedInstance._cache[fullName] then
		return ReducedInstance._cache[fullName]
	end

	local self = setmetatable({
		instance = instance,
	}, {
		__index = function(self, key): any?
			local value = self.instance[key]
			if type(value) == "function" then
				if key == "FindFirstChild" then
					return function(self, ...): roblox.Instance?
						local child = self.instance:FindFirstChild(...)
						if child then
							return ReducedInstance.once(child :: roblox.Instance)
						end
						return
					end
				elseif key == "WaitForChild" then
					return function(self, ...)
						return ReducedInstance.once(
							self.instance:WaitForChild(...) :: roblox.Instance
						)
					end
				else
					return function(self, ...)
						return value(self.instance, ...)
					end
				end
			elseif typeof(value) == "Instance" then
				return ReducedInstance.once((value :: never) :: roblox.Instance)
			end

			return value
		end,
		__newindex = function(self, key, value)
			self.instance[key] = value
		end,
		__metatable = false,
	})

	ReducedInstance._cache[fullName] = self

	return (self :: any) :: roblox.Instance
end

return ReducedInstance
