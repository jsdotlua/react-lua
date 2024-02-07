-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberHostConfigWithNoTestSelectors.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
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
