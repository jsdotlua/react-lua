-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberHostConfigWithNoPersistence.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
<<<<<<< HEAD
]]

local invariant = require("../invariant")

-- Renderers that don't support persistence
-- can re-export everything from this module.

local function shim(...)
	invariant(
		false,
		"The current renderer does not support persistence. "
			.. "This error is likely caused by a bug in React. "
			.. "Please file an issue."
	)
end

-- Persistence (when unsupported)
return {
	supportsPersistence = false,
	cloneInstance = shim,
	cloneFundamentalInstance = shim,
	createContainerChildSet = shim,
	appendChildToContainerChildSet = shim,
	finalizeContainerChildren = shim,
	replaceContainerChildren = shim,
	cloneHiddenInstance = shim,
	cloneHiddenTextInstance = shim,
}
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local exports = {}
-- Renderers that don't support persistence
-- can re-export everything from this module.
local function shim(
	...: any --[[ ROBLOX CHECK: check correct type of elements. Upstream type: <any> ]]
)
	local args = { ... }
	error(
		Error.new(
			"The current renderer does not support persistence. "
				.. "This error is likely caused by a bug in React. "
				.. "Please file an issue."
		)
	)
end -- Persistence (when unsupported)
local supportsPersistence = false
exports.supportsPersistence = supportsPersistence
local cloneInstance = shim
exports.cloneInstance = cloneInstance
local createContainerChildSet = shim
exports.createContainerChildSet = createContainerChildSet
local appendChildToContainerChildSet = shim
exports.appendChildToContainerChildSet = appendChildToContainerChildSet
local finalizeContainerChildren = shim
exports.finalizeContainerChildren = finalizeContainerChildren
local replaceContainerChildren = shim
exports.replaceContainerChildren = replaceContainerChildren
local cloneHiddenInstance = shim
exports.cloneHiddenInstance = cloneHiddenInstance
local cloneHiddenTextInstance = shim
exports.cloneHiddenTextInstance = cloneHiddenTextInstance
return exports
>>>>>>> upstream-apply
