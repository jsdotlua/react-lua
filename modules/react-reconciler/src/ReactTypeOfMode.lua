<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/22dc2e42bdc00d87fc19c5e75fc7c0b3fdcdc572/packages/react-reconciler/src/ReactTypeOfMode.js
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactTypeOfMode.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]

export type TypeOfMode = number
<<<<<<< HEAD

return {
	NoMode = 0b00000,
	StrictMode = 0b00001,
	-- TODO: Remove BlockingMode and ConcurrentMode by reading from the root
	-- tag instead
	BlockingMode = 0b00010,
	ConcurrentMode = 0b00100,
	ProfileMode = 0b01000,
	DebugTracingMode = 0b10000,
}
=======
local NoMode = --[[                         ]]
	0b000000
exports.NoMode = NoMode -- TODO: Remove ConcurrentMode by reading from the root tag instead
local ConcurrentMode = --[[                 ]]
	0b000001
exports.ConcurrentMode = ConcurrentMode
local ProfileMode = --[[                    ]]
	0b000010
exports.ProfileMode = ProfileMode
local DebugTracingMode = --[[               ]]
	0b000100
exports.DebugTracingMode = DebugTracingMode
local StrictLegacyMode = --[[               ]]
	0b001000
exports.StrictLegacyMode = StrictLegacyMode
local StrictEffectsMode = --[[              ]]
	0b010000
exports.StrictEffectsMode = StrictEffectsMode
local ConcurrentUpdatesByDefaultMode = --[[ ]]
	0b100000
exports.ConcurrentUpdatesByDefaultMode = ConcurrentUpdatesByDefaultMode
return exports
>>>>>>> upstream-apply
