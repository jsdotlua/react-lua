<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/37cb732c59863297e48f69ac1f6e2ba1aa1886f0/packages/react-reconciler/src/ReactFiberFlags.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberFlags.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
]]

export type Flags = number

local exports = {}
<<<<<<< HEAD

-- Don't change these two values. They're used by React Dev Tools.
exports.NoFlags = --[[                      ]]
	0b000000000000000000
exports.PerformedWork = --[[                ]]
	0b000000000000000001

-- You can change the rest (and add more).
exports.Placement = --[[                    ]]
	0b000000000000000010
exports.Update = --[[                       ]]
	0b000000000000000100
exports.PlacementAndUpdate = --[[           ]]
	0b000000000000000110
exports.Deletion = --[[                     ]]
	0b000000000000001000
exports.ContentReset = --[[                 ]]
	0b000000000000010000
exports.Callback = --[[                     ]]
	0b000000000000100000
exports.DidCapture = --[[                   ]]
	0b000000000001000000
exports.Ref = --[[                          ]]
	0b000000000010000000
exports.Snapshot = --[[                     ]]
	0b000000000100000000
exports.Passive = --[[                      ]]
	0b000000001000000000
-- TODO (effects) Remove this bit once the new reconciler is synced to the old.
exports.PassiveUnmountPendingDev = --[[     ]]
	0b000010000000000000
exports.Hydrating = --[[                    ]]
	0b000000010000000000
exports.HydratingAndUpdate = --[[           ]]
	0b000000010000000100

-- Passive & Update & Callback & Ref & Snapshot
exports.LifecycleEffectMask = --[[          ]]
	0b000000001110100100

-- Union of all host effects
exports.HostEffectMask = --[[               ]]
	0b000000011111111111

-- These are not really side effects, but we still reuse this field.
exports.Incomplete = --[[                   ]]
	0b000000100000000000
exports.ShouldCapture = --[[                ]]
	0b000001000000000000
exports.ForceUpdateForLegacySuspense = --[[ ]]
	0b000100000000000000

-- Static tags describe aspects of a fiber that are not specific to a render,
=======
local enableCreateEventHandleAPI = require(Packages.shared.ReactFeatureFlags).enableCreateEventHandleAPI
export type Flags = number -- Don't change these two values. They're used by React Dev Tools.
local NoFlags = --[[                      ]]
	0b00000000000000000000000000
exports.NoFlags = NoFlags
local PerformedWork = --[[                ]]
	0b00000000000000000000000001
exports.PerformedWork = PerformedWork -- You can change the rest (and add more).
local Placement = --[[                    ]]
	0b00000000000000000000000010
exports.Placement = Placement
local Update = --[[                       ]]
	0b00000000000000000000000100
exports.Update = Update
local Deletion = --[[                     ]]
	0b00000000000000000000001000
exports.Deletion = Deletion
local ChildDeletion = --[[                ]]
	0b00000000000000000000010000
exports.ChildDeletion = ChildDeletion
local ContentReset = --[[                 ]]
	0b00000000000000000000100000
exports.ContentReset = ContentReset
local Callback = --[[                     ]]
	0b00000000000000000001000000
exports.Callback = Callback
local DidCapture = --[[                   ]]
	0b00000000000000000010000000
exports.DidCapture = DidCapture
local ForceClientRender = --[[            ]]
	0b00000000000000000100000000
exports.ForceClientRender = ForceClientRender
local Ref = --[[                          ]]
	0b00000000000000001000000000
exports.Ref = Ref
local Snapshot = --[[                     ]]
	0b00000000000000010000000000
exports.Snapshot = Snapshot
local Passive = --[[                      ]]
	0b00000000000000100000000000
exports.Passive = Passive
local Hydrating = --[[                    ]]
	0b00000000000001000000000000
exports.Hydrating = Hydrating
local Visibility = --[[                   ]]
	0b00000000000010000000000000
exports.Visibility = Visibility
local StoreConsistency = --[[             ]]
	0b00000000000100000000000000
exports.StoreConsistency = StoreConsistency
local LifecycleEffectMask = bit32.bor(
	bit32.bor(
		bit32.bor(
			bit32.bor(
				bit32.bor(Passive, Update), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
				Callback
			), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
			Ref
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		Snapshot
	), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
	StoreConsistency
) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
exports.LifecycleEffectMask = LifecycleEffectMask -- Union of all commit flags (flags with the lifetime of a particular commit)
local HostEffectMask = --[[               ]]
	0b00000000000111111111111111
exports.HostEffectMask = HostEffectMask -- These are not really side effects, but we still reuse this field.
local Incomplete = --[[                   ]]
	0b00000000001000000000000000
exports.Incomplete = Incomplete
local ShouldCapture = --[[                ]]
	0b00000000010000000000000000
exports.ShouldCapture = ShouldCapture
local ForceUpdateForLegacySuspense = --[[ ]]
	0b00000000100000000000000000
exports.ForceUpdateForLegacySuspense = ForceUpdateForLegacySuspense
local DidPropagateContext = --[[          ]]
	0b00000001000000000000000000
exports.DidPropagateContext = DidPropagateContext
local NeedsPropagation = --[[             ]]
	0b00000010000000000000000000
exports.NeedsPropagation = NeedsPropagation
local Forked = --[[                       ]]
	0b00000100000000000000000000
exports.Forked = Forked -- Static tags describe aspects of a fiber that are not specific to a render,
>>>>>>> upstream-apply
-- e.g. a fiber uses a passive effect (even if there are no updates on this particular render).
-- This enables us to defer more work in the unmount case,
-- since we can defer traversing the tree during layout to look for Passive effects,
-- and instead rely on the static flag as a signal that there may be cleanup work.
<<<<<<< HEAD
exports.PassiveStatic = --[[                ]]
	0b001000000000000000

-- Union of side effect groupings as pertains to subtreeFlags
exports.BeforeMutationMask = --[[           ]]
	0b000000001100001010
exports.MutationMask = --[[                 ]]
	0b000000010010011110
exports.LayoutMask = --[[                   ]]
	0b000000000010100100
exports.PassiveMask = --[[                  ]]
	0b000000001000001000

-- Union of tags that don't get reset on clones.
-- This allows certain concepts to persist without recalculting them,
-- e.g. whether a subtree contains passive effects or portals.
exports.StaticMask = --[[                   ]]
	0b001000000000000000

-- These flags allow us to traverse to fibers that have effects on mount
-- without traversing the entire tree after every commit for
-- double invoking
exports.MountLayoutDev = --[[               ]]
	0b010000000000000000
exports.MountPassiveDev = --[[              ]]
	0b100000000000000000

=======
local RefStatic = --[[                    ]]
	0b00001000000000000000000000
exports.RefStatic = RefStatic
local LayoutStatic = --[[                 ]]
	0b00010000000000000000000000
exports.LayoutStatic = LayoutStatic
local PassiveStatic = --[[                ]]
	0b00100000000000000000000000
exports.PassiveStatic = PassiveStatic -- These flags allow us to traverse to fibers that have effects on mount
-- without traversing the entire tree after every commit for
-- double invoking
local MountLayoutDev = --[[               ]]
	0b01000000000000000000000000
exports.MountLayoutDev = MountLayoutDev
local MountPassiveDev = --[[              ]]
	0b10000000000000000000000000
exports.MountPassiveDev = MountPassiveDev -- Groups of flags that are used in the commit phase to skip over trees that
-- don't contain effects, by checking subtreeFlags.
local BeforeMutationMask = -- TODO: Remove Update flag from before mutation phase by re-landing Visibility
	-- flag logic (see #20043)
	bit32.bor(
		bit32.bor(Update, Snapshot), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		if Boolean.toJSBoolean(enableCreateEventHandleAPI)
			then -- createEventHandle needs to visit deleted and hidden trees to
				-- fire beforeblur
				-- TODO: Only need to visit Deletions during BeforeMutation phase if an
				-- element is focused.
				bit32.bor(ChildDeletion, Visibility) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
			else 0
	) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
exports.BeforeMutationMask = BeforeMutationMask
local MutationMask = bit32.bor(
	bit32.bor(
		bit32.bor(
			bit32.bor(
				bit32.bor(
					bit32.bor(Placement, Update), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
					ChildDeletion
				), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
				ContentReset
			), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
			Ref
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		Hydrating
	), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
	Visibility
) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
exports.MutationMask = MutationMask
local LayoutMask = bit32.bor(
	bit32.bor(
		bit32.bor(Update, Callback), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		Ref
	), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
	Visibility
) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
exports.LayoutMask = LayoutMask -- TODO: Split into PassiveMountMask and PassiveUnmountMask
local PassiveMask = bit32.bor(Passive, ChildDeletion) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
exports.PassiveMask = PassiveMask -- Union of tags that don't get reset on clones.
-- This allows certain concepts to persist without recalculating them,
-- e.g. whether a subtree contains passive effects or portals.
local StaticMask = bit32.bor(
	bit32.bor(LayoutStatic, PassiveStatic), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
	RefStatic
) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
exports.StaticMask = StaticMask
>>>>>>> upstream-apply
return exports
