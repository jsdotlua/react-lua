--!strict

--[[
	Paths use \ on Windows and / on Unix. Lune doesn't have a built-in path
	assembler, so this script is used to provide a consistent path format for
	all platforms.
--]]

local process = require("@lune/process")

local Path = {}

function Path.join(...)
	local path = table.concat({ ... }, "/")
	if process.os == "windows" then
		path = path:gsub("/", "\\")
	end
	return path
end

return Path
