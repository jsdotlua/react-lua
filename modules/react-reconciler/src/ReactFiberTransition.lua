<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/ddd1faa1972b614dfbfae205f2aa4a6c0b39a759/packages/react-reconciler/src/ReactFiberTransition.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberTransition.js
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

local ReactSharedInternals = require("@pkg/@jsdotlua/shared").ReactSharedInternals

local ReactCurrentBatchConfig = ReactSharedInternals.ReactCurrentBatchConfig

return {
	NoTransition = 0,
	requestCurrentTransition = function(): number
		return ReactCurrentBatchConfig.transition
	end,
}
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local exports = {}
local ReactSharedInternals = require(Packages.shared.ReactSharedInternals).default
local reactFiberTracingMarkerComponentNewModule = require(script.Parent["ReactFiberTracingMarkerComponent.new"])
type Transition = reactFiberTracingMarkerComponentNewModule.Transition
local ReactCurrentBatchConfig = ReactSharedInternals.ReactCurrentBatchConfig
local NoTransition = nil
exports.NoTransition = NoTransition
local function requestCurrentTransition(): Transition | nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]]
	return ReactCurrentBatchConfig.transition
end
exports.requestCurrentTransition = requestCurrentTransition
return exports
>>>>>>> upstream-apply
