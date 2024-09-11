--!strict

--[[
	Lune's `datetime` module uses lowerCamelCase, whereas Roblox's `DateTime`
	module uses UpperCamelCase. To allow for Roblox-style usage of DateTime
	objects, this module wraps Lune's `datetime` module to add Roblox-style
	properties and methods through the use of metatables.

	This module may need to be updated as different properties and methods are
	needed.
--]]

local datetime = require("@lune/datetime")

local DateTime = setmetatable({
	now = function()
		local now = datetime.now()
		return setmetatable({
			UnixTimestampMillis = now.unixTimestampMillis,
			UnixTimestamp = now.unixTimestamp,
		}, { __index = now })
	end,
}, { __index = datetime })

return DateTime
