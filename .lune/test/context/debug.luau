--!strict

--[[
	Jest depends on `loadmodule` existing on the `debug` api.
	On Roblox, it's locked behind a feature flag `FFlagDebugLoadModule`, which
	is not enabled by default.

	In Lune, it doesn't exist at all, so this module creates the interface for
	it but is not implemented.

	The _loader function needs to be overridden to be usable. In this project,
		the `lune/test.lua` script implements and sets the _loader function.
--]]

local Debug

Debug = setmetatable({
	_loader = function(_module: any)
		error("The loader for Debug.loadmodule is not implemented")
	end,
	loadmodule = function(module)
		return Debug._loader(module)
	end,
}, { __index = debug })

return Debug
