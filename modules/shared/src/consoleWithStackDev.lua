-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/consoleWithStackDev.js
--[[*
* Copyright (c) Facebook, Inc. and its affiliates.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
]]
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
<<<<<<< HEAD

local ReactSharedInternals = require("./ReactSharedInternals")
-- In DEV, calls to console.warn and console.error get replaced
=======
local Boolean = LuauPolyfill.Boolean
local exports = {}
local ReactSharedInternals = require(Packages.shared.ReactSharedInternals).default
local suppressWarning = false
local function setSuppressWarning(newSuppressWarning)
	if Boolean.toJSBoolean(__DEV__) then
		suppressWarning = newSuppressWarning
	end
end
exports.setSuppressWarning = setSuppressWarning -- In DEV, calls to console.warn and console.error get replaced
>>>>>>> upstream-apply
-- by calls to these methods by a Babel plugin.
--
-- In PROD (or in packages without access to React internals),
-- they are left as they are instead.
<<<<<<< HEAD

-- deviation: declare this ahead of time so that `warn` and `error` are able to
-- reference it
local printWarning

local exports = {}
exports.warn = function(format, ...)
	if _G.__DEV__ then
		printWarning("warn", format, { ... })
	end
end
exports.error = function(format, ...)
	if _G.__DEV__ then
		printWarning("error", format, { ... })
=======
local function warn_(
	format,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local args = { ... }
	if Boolean.toJSBoolean(__DEV__) then
		if not Boolean.toJSBoolean(suppressWarning) then
			printWarning("warn", format, args)
		end
	end
end
exports.warn_ = warn_
local function error_(
	format,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local args = { ... }
	if Boolean.toJSBoolean(__DEV__) then
		if not Boolean.toJSBoolean(suppressWarning) then
			printWarning("error", format, args)
		end
>>>>>>> upstream-apply
	end
end

function printWarning(level, format, args)
	-- When changing this logic, you might want to also
	-- update consoleWithStackDev.www.js as well.
	if _G.__DEV__ then
		local ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame
		local stack = ReactDebugCurrentFrame.getStackAddendum()

		if stack ~= "" then
			format ..= "%s"
<<<<<<< HEAD
			-- deviation: no array `concat` function in lua
			args = Array.slice(args, 1)
			table.insert(args, stack)
		end

		local argsWithFormat = Array.map(args, tostring)
		-- Careful: RN currently depends on this prefix
		table.insert(argsWithFormat, 1, "Warning: " .. format)
		-- We intentionally don't use spread (or .apply) directly because it
=======
			args = Array.concat(args, { stack }) --[[ ROBLOX CHECK: check if 'args' is an Array ]]
		end -- eslint-disable-next-line react-internal/safe-string-coercion
		local argsWithFormat = Array.map(args, function(item)
			return String(item)
		end) --[[ ROBLOX CHECK: check if 'args' is an Array ]] -- Careful: RN currently depends on this prefix
		table.insert(argsWithFormat, 1, "Warning: " .. tostring(format)) --[[ ROBLOX CHECK: check if 'argsWithFormat' is an Array ]] -- We intentionally don't use spread (or .apply) directly because it
>>>>>>> upstream-apply
		-- breaks IE9: https://github.com/facebook/react/issues/13610
		-- eslint-disable-next-line react-internal/no-production-logging
		console[level](unpack(argsWithFormat))
	end
end

return exports
