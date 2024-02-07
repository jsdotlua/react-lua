--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberTransition.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
]]

local ReactSharedInternals = require("@pkg/@jsdotlua/shared").ReactSharedInternals

local ReactCurrentBatchConfig = ReactSharedInternals.ReactCurrentBatchConfig

return {
	NoTransition = 0,
	requestCurrentTransition = function(): number
		return ReactCurrentBatchConfig.transition
	end,
}
