<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/9abc2785cb070148d64fae81e523246b90b92016/packages/scheduler/src/SchedulerFeatureFlags.js
--[[*
* Copyright (c) Facebook, Inc. and its affiliates.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
*
]]

return {
	enableSchedulerDebugging = false,
	enableIsInputPending = false,
	enableProfiling = _G.__PROFILE__,
}
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/scheduler/src/SchedulerFeatureFlags.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 ]]
local exports = {}
local enableSchedulerDebugging = false
exports.enableSchedulerDebugging = enableSchedulerDebugging
local enableIsInputPending = false
exports.enableIsInputPending = enableIsInputPending
local enableProfiling = false
exports.enableProfiling = enableProfiling
local enableIsInputPendingContinuous = false
exports.enableIsInputPendingContinuous = enableIsInputPendingContinuous
local frameYieldMs = 5
exports.frameYieldMs = frameYieldMs
local continuousYieldMs = 50
exports.continuousYieldMs = continuousYieldMs
local maxYieldMs = 300
exports.maxYieldMs = maxYieldMs
return exports
>>>>>>> upstream-apply
