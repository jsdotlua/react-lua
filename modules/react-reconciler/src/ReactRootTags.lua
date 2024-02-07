<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/c5d2fc7127654e43de59fff865b74765a103c4a5/packages/react-reconciler/src/ReactRootTags.js
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactRootTags.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]

export type RootTag = number
<<<<<<< HEAD

return {
	LegacyRoot = 0,
	BlockingRoot = 1,
	ConcurrentRoot = 2,
}
=======
local LegacyRoot = 0
exports.LegacyRoot = LegacyRoot
local ConcurrentRoot = 1
exports.ConcurrentRoot = ConcurrentRoot
return exports
>>>>>>> upstream-apply
