--!strict
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 *
 ]]
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local setTimeout = LuauPolyfill.setTimeout

return function(task)
	-- deviation: Replace with setImmediate once we create an equivalent polyfill
	return setTimeout(task, 0)
end
