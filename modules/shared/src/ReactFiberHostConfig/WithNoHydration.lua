-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberHostConfigWithNoHydration.js
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

-- Renderers that don't support hydration
-- can re-export everything from this module.

function shim(...)
	invariant(
		false,
		"The current renderer does not support hydration. "
			.. "This error is likely caused by a bug in React. "
			.. "Please file an issue."
	)
end

-- Hydration (when unsupported)
export type SuspenseInstance = any
return {
	supportsHydration = false,
	canHydrateInstance = shim,
	canHydrateTextInstance = shim,
	canHydrateSuspenseInstance = shim,
	isSuspenseInstancePending = shim,
	isSuspenseInstanceFallback = shim,
	registerSuspenseInstanceRetry = shim,
	getNextHydratableSibling = shim,
	getFirstHydratableChild = shim,
	hydrateInstance = shim,
	hydrateTextInstance = shim,
	hydrateSuspenseInstance = shim,
	getNextHydratableInstanceAfterSuspenseInstance = shim,
	commitHydratedContainer = shim,
	commitHydratedSuspenseInstance = shim,
	clearSuspenseBoundary = shim,
	clearSuspenseBoundaryFromContainer = shim,
	didNotMatchHydratedContainerTextInstance = shim,
	didNotMatchHydratedTextInstance = shim,
	didNotHydrateContainerInstance = shim,
	didNotHydrateInstance = shim,
	didNotFindHydratableContainerInstance = shim,
	didNotFindHydratableContainerTextInstance = shim,
	didNotFindHydratableContainerSuspenseInstance = shim,
	didNotFindHydratableInstance = shim,
	didNotFindHydratableTextInstance = shim,
	didNotFindHydratableSuspenseInstance = shim,
}
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local exports = {}
-- Renderers that don't support hydration
-- can re-export everything from this module.
local function shim(
	...: any --[[ ROBLOX CHECK: check correct type of elements. Upstream type: <any> ]]
)
	local args = { ... }
	error(
		Error.new(
			"The current renderer does not support hydration. "
				.. "This error is likely caused by a bug in React. "
				.. "Please file an issue."
		)
	)
end -- Hydration (when unsupported)
export type SuspenseInstance = mixed
local supportsHydration = false
exports.supportsHydration = supportsHydration
local canHydrateInstance = shim
exports.canHydrateInstance = canHydrateInstance
local canHydrateTextInstance = shim
exports.canHydrateTextInstance = canHydrateTextInstance
local canHydrateSuspenseInstance = shim
exports.canHydrateSuspenseInstance = canHydrateSuspenseInstance
local isSuspenseInstancePending = shim
exports.isSuspenseInstancePending = isSuspenseInstancePending
local isSuspenseInstanceFallback = shim
exports.isSuspenseInstanceFallback = isSuspenseInstanceFallback
local getSuspenseInstanceFallbackErrorDetails = shim
exports.getSuspenseInstanceFallbackErrorDetails = getSuspenseInstanceFallbackErrorDetails
local registerSuspenseInstanceRetry = shim
exports.registerSuspenseInstanceRetry = registerSuspenseInstanceRetry
local getNextHydratableSibling = shim
exports.getNextHydratableSibling = getNextHydratableSibling
local getFirstHydratableChild = shim
exports.getFirstHydratableChild = getFirstHydratableChild
local getFirstHydratableChildWithinContainer = shim
exports.getFirstHydratableChildWithinContainer = getFirstHydratableChildWithinContainer
local getFirstHydratableChildWithinSuspenseInstance = shim
exports.getFirstHydratableChildWithinSuspenseInstance = getFirstHydratableChildWithinSuspenseInstance
local hydrateInstance = shim
exports.hydrateInstance = hydrateInstance
local hydrateTextInstance = shim
exports.hydrateTextInstance = hydrateTextInstance
local hydrateSuspenseInstance = shim
exports.hydrateSuspenseInstance = hydrateSuspenseInstance
local getNextHydratableInstanceAfterSuspenseInstance = shim
exports.getNextHydratableInstanceAfterSuspenseInstance = getNextHydratableInstanceAfterSuspenseInstance
local commitHydratedContainer = shim
exports.commitHydratedContainer = commitHydratedContainer
local commitHydratedSuspenseInstance = shim
exports.commitHydratedSuspenseInstance = commitHydratedSuspenseInstance
local clearSuspenseBoundary = shim
exports.clearSuspenseBoundary = clearSuspenseBoundary
local clearSuspenseBoundaryFromContainer = shim
exports.clearSuspenseBoundaryFromContainer = clearSuspenseBoundaryFromContainer
local shouldDeleteUnhydratedTailInstances = shim
exports.shouldDeleteUnhydratedTailInstances = shouldDeleteUnhydratedTailInstances
local didNotMatchHydratedContainerTextInstance = shim
exports.didNotMatchHydratedContainerTextInstance = didNotMatchHydratedContainerTextInstance
local didNotMatchHydratedTextInstance = shim
exports.didNotMatchHydratedTextInstance = didNotMatchHydratedTextInstance
local didNotHydrateInstanceWithinContainer = shim
exports.didNotHydrateInstanceWithinContainer = didNotHydrateInstanceWithinContainer
local didNotHydrateInstanceWithinSuspenseInstance = shim
exports.didNotHydrateInstanceWithinSuspenseInstance = didNotHydrateInstanceWithinSuspenseInstance
local didNotHydrateInstance = shim
exports.didNotHydrateInstance = didNotHydrateInstance
local didNotFindHydratableInstanceWithinContainer = shim
exports.didNotFindHydratableInstanceWithinContainer = didNotFindHydratableInstanceWithinContainer
local didNotFindHydratableTextInstanceWithinContainer = shim
exports.didNotFindHydratableTextInstanceWithinContainer = didNotFindHydratableTextInstanceWithinContainer
local didNotFindHydratableSuspenseInstanceWithinContainer = shim
exports.didNotFindHydratableSuspenseInstanceWithinContainer = didNotFindHydratableSuspenseInstanceWithinContainer
local didNotFindHydratableInstanceWithinSuspenseInstance = shim
exports.didNotFindHydratableInstanceWithinSuspenseInstance = didNotFindHydratableInstanceWithinSuspenseInstance
local didNotFindHydratableTextInstanceWithinSuspenseInstance = shim
exports.didNotFindHydratableTextInstanceWithinSuspenseInstance = didNotFindHydratableTextInstanceWithinSuspenseInstance
local didNotFindHydratableSuspenseInstanceWithinSuspenseInstance = shim
exports.didNotFindHydratableSuspenseInstanceWithinSuspenseInstance =
	didNotFindHydratableSuspenseInstanceWithinSuspenseInstance
local didNotFindHydratableInstance = shim
exports.didNotFindHydratableInstance = didNotFindHydratableInstance
local didNotFindHydratableTextInstance = shim
exports.didNotFindHydratableTextInstance = didNotFindHydratableTextInstance
local didNotFindHydratableSuspenseInstance = shim
exports.didNotFindHydratableSuspenseInstance = didNotFindHydratableSuspenseInstance
local errorHydratingContainer = shim
exports.errorHydratingContainer = errorHydratingContainer
return exports
>>>>>>> upstream-apply
