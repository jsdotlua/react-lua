<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/607148673b3156d051d1fed17cd49e83698dce54/packages/react/src/ReactSharedInternals.js
--[[*
* Copyright (c) Facebook, Inc. and its affiliates.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
]]

--[[
	ROBLOX deviation: ReactSharedInternals captures singleton state across the
	whole workspace. This file and the modules it requires were moved from React
	to untangle a cyclic workspace member dependency.

	Before:
	* ReactSharedInternals (and the 5 associated modules) lived in React
	* React had a dependency on Shared
	* Shared reached into React source to re-export ReactSharedInternals (cycle)

	After:
	* ReactSharedInternals (and the 5 associated modules) live in Shared
	* React depends on Shared
	* Shared has no intra-workspace dependencies (no cycles)
]]
local console = require("@pkg/@jsdotlua/luau-polyfill").console
local function onlyInTestError(functionName: string)
	return function()
		console.error(functionName .. " is only available in tests, not in production")
	end
end

-- import assign from 'object-assign';
local ReactCurrentDispatcher = require("./ReactCurrentDispatcher")
export type Dispatcher = ReactCurrentDispatcher.Dispatcher
local ReactCurrentBatchConfig = require("./ReactCurrentBatchConfig")
local ReactCurrentOwner = require("./ReactCurrentOwner")
local ReactDebugCurrentFrame = require("./ReactDebugCurrentFrame")
local IsSomeRendererActing = require("./IsSomeRendererActing")

=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react/src/ReactSharedInternals.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local exports = {}
local ReactCurrentDispatcher = require(script.Parent.ReactCurrentDispatcher).default
local ReactCurrentBatchConfig = require(script.Parent.ReactCurrentBatchConfig).default
local ReactCurrentActQueue = require(script.Parent.ReactCurrentActQueue).default
local ReactCurrentOwner = require(script.Parent.ReactCurrentOwner).default
local ReactDebugCurrentFrame = require(script.Parent.ReactDebugCurrentFrame).default
local enableServerContext = require(Packages.shared.ReactFeatureFlags).enableServerContext
local ContextRegistry = require(script.Parent.ReactServerContextRegistry).ContextRegistry
>>>>>>> upstream-apply
local ReactSharedInternals = {
	ReactCurrentDispatcher = ReactCurrentDispatcher,
	ReactCurrentBatchConfig = ReactCurrentBatchConfig,
	ReactCurrentOwner = ReactCurrentOwner,
<<<<<<< HEAD
	IsSomeRendererActing = IsSomeRendererActing,
	-- ROBLOX deviation: Luau type checking requires us to have a consistent export shape regardless of __DEV__
	-- ROBLOX TODO: use if-expressions when all clients are on 503+
	ReactDebugCurrentFrame = if _G.__DEV__
		then ReactDebugCurrentFrame
		else {
			setExtraStackFrame = function(_: string?): ()
				onlyInTestError("setExtraStackFrame")
			end,
		},
	-- deviation: We shouldn't have to worry about duplicate bundling here
	-- Used by renderers to avoid bundling object-assign twice in UMD bundles:
	-- assign,
}

return ReactSharedInternals
=======
}
if Boolean.toJSBoolean(__DEV__) then
	ReactSharedInternals.ReactDebugCurrentFrame = ReactDebugCurrentFrame
	ReactSharedInternals.ReactCurrentActQueue = ReactCurrentActQueue
end
if Boolean.toJSBoolean(enableServerContext) then
	ReactSharedInternals.ContextRegistry = ContextRegistry
end
exports.default = ReactSharedInternals
return exports
>>>>>>> upstream-apply
