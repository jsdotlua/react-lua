<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/92fcd46cc79bbf45df4ce86b0678dcef3b91078d/packages/react/src/ReactCurrentBatchConfig.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react/src/ReactCurrentBatchConfig.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
<<<<<<< HEAD
]]

--[[*
 * Keeps track of the current batch's configuration such as how long an update
 * should suspend for if it needs to.
]]
local ReactCurrentBatchConfig = {
	transition = 0,
}

return ReactCurrentBatchConfig
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local exports = {}
local reactReconcilerSrcReactFiberTracingMarkerComponentNewModule =
	require(Packages["react-reconciler"].src["ReactFiberTracingMarkerComponent.new"])
type BatchConfigTransition = reactReconcilerSrcReactFiberTracingMarkerComponentNewModule.BatchConfigTransition
type BatchConfig = {
	transition: BatchConfigTransition | nil,--[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]]
}
--[[*
 * Keeps track of the current batch's configuration such as how long an update
 * should suspend for if it needs to.
 ]]
local ReactCurrentBatchConfig: BatchConfig = { transition = nil }
exports.default = ReactCurrentBatchConfig
return exports
>>>>>>> upstream-apply
