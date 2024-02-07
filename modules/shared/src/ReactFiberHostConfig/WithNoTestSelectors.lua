-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberHostConfigWithNoTestSelectors.js
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

-- Renderers that don't support test selectors
-- can re-export everything from this module.

local function shim(...)
	invariant(
		false,
		"The current renderer does not support test selectors. "
			.. "This error is likely caused by a bug in React. "
			.. "Please file an issue."
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local exports = {}
-- Renderers that don't support test selectors
-- can re-export everything from this module.
local function shim(
	...: any --[[ ROBLOX CHECK: check correct type of elements. Upstream type: <any> ]]
)
	local args = { ... }
	error(
		Error.new(
			"The current renderer does not support test selectors. "
				.. "This error is likely caused by a bug in React. "
				.. "Please file an issue."
		)
>>>>>>> upstream-apply
	)
end

-- Test selectors (when unsupported)
return {
	supportsTestSelectors = false,
	findFiberRoot = shim,
	getBoundingRect = shim,
	getTextContent = shim,
	isHiddenSubtree = shim,
	matchAccessibilityRole = shim,
	setFocusIfFocusable = shim,
	setupIntersectionObserver = shim,
}
