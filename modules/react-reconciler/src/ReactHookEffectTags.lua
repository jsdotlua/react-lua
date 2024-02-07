<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/16654436039dd8f16a63928e71081c7745872e8f/packages/react-reconciler/src/ReactHookEffectTags.js
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactHookEffectTags.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]

export type HookFlags = number
<<<<<<< HEAD

return {
	--[[  ]]
	NoFlags = 0b000,

	-- Represents whether effect should fire.
	--[[ ]]
	HasEffect = 0b001,

	-- Represents the phase in which the effect (not the clean-up) fires.
	--[[    ]]
	Layout = 0b010,
	--[[   ]]
	Passive = 0b100,
}
=======
local NoFlags = --[[   ]]
	0b0000
exports.NoFlags = NoFlags -- Represents whether effect should fire.
local HasEffect = --[[ ]]
	0b0001
exports.HasEffect = HasEffect -- Represents the phase in which the effect (not the clean-up) fires.
local Insertion = --[[  ]]
	0b0010
exports.Insertion = Insertion
local Layout = --[[    ]]
	0b0100
exports.Layout = Layout
local Passive = --[[   ]]
	0b1000
exports.Passive = Passive
return exports
>>>>>>> upstream-apply
