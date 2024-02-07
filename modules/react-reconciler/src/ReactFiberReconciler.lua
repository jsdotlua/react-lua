<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/faa697f4f9afe9f1c98e315b2a9e70f5a74a7a74/packages/react-reconciler/src/ReactFiberReconciler.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberReconciler.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]
<<<<<<< HEAD

-- deviation: old version of reconciler not ported
return require("./ReactFiberReconciler.new.lua")
=======
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local exports = {}
local enableNewReconciler = require(Packages.shared.ReactFeatureFlags).enableNewReconciler -- The entry file imports either the old or new version of the reconciler.
-- During build and testing, this indirection is always shimmed with the actual
-- modules, otherwise both reconcilers would be initialized. So this is really
-- only here for Flow purposes.
local reactFiberReconcilerOldModule = require(script.Parent["ReactFiberReconciler.old"])
local createContainer_old = reactFiberReconcilerOldModule.createContainer
local createHydrationContainer_old = reactFiberReconcilerOldModule.createHydrationContainer
local updateContainer_old = reactFiberReconcilerOldModule.updateContainer
local batchedUpdates_old = reactFiberReconcilerOldModule.batchedUpdates
local deferredUpdates_old = reactFiberReconcilerOldModule.deferredUpdates
local discreteUpdates_old = reactFiberReconcilerOldModule.discreteUpdates
local flushControlled_old = reactFiberReconcilerOldModule.flushControlled
local flushSync_old = reactFiberReconcilerOldModule.flushSync
local isAlreadyRendering_old = reactFiberReconcilerOldModule.isAlreadyRendering
local flushPassiveEffects_old = reactFiberReconcilerOldModule.flushPassiveEffects
local getPublicRootInstance_old = reactFiberReconcilerOldModule.getPublicRootInstance
local attemptSynchronousHydration_old = reactFiberReconcilerOldModule.attemptSynchronousHydration
local attemptDiscreteHydration_old = reactFiberReconcilerOldModule.attemptDiscreteHydration
local attemptContinuousHydration_old = reactFiberReconcilerOldModule.attemptContinuousHydration
local attemptHydrationAtCurrentPriority_old = reactFiberReconcilerOldModule.attemptHydrationAtCurrentPriority
local findHostInstance_old = reactFiberReconcilerOldModule.findHostInstance
local findHostInstanceWithWarning_old = reactFiberReconcilerOldModule.findHostInstanceWithWarning
local findHostInstanceWithNoPortals_old = reactFiberReconcilerOldModule.findHostInstanceWithNoPortals
local shouldError_old = reactFiberReconcilerOldModule.shouldError
local shouldSuspend_old = reactFiberReconcilerOldModule.shouldSuspend
local injectIntoDevTools_old = reactFiberReconcilerOldModule.injectIntoDevTools
local createPortal_old = reactFiberReconcilerOldModule.createPortal
local createComponentSelector_old = reactFiberReconcilerOldModule.createComponentSelector
local createHasPseudoClassSelector_old = reactFiberReconcilerOldModule.createHasPseudoClassSelector
local createRoleSelector_old = reactFiberReconcilerOldModule.createRoleSelector
local createTestNameSelector_old = reactFiberReconcilerOldModule.createTestNameSelector
local createTextSelector_old = reactFiberReconcilerOldModule.createTextSelector
local getFindAllNodesFailureDescription_old = reactFiberReconcilerOldModule.getFindAllNodesFailureDescription
local findAllNodes_old = reactFiberReconcilerOldModule.findAllNodes
local findBoundingRects_old = reactFiberReconcilerOldModule.findBoundingRects
local focusWithin_old = reactFiberReconcilerOldModule.focusWithin
local observeVisibleRects_old = reactFiberReconcilerOldModule.observeVisibleRects
local registerMutableSourceForHydration_old = reactFiberReconcilerOldModule.registerMutableSourceForHydration
local runWithPriority_old = reactFiberReconcilerOldModule.runWithPriority
local getCurrentUpdatePriority_old = reactFiberReconcilerOldModule.getCurrentUpdatePriority
local reactFiberReconcilerNewModule = require(script.Parent["ReactFiberReconciler.new"])
local createContainer_new = reactFiberReconcilerNewModule.createContainer
local createHydrationContainer_new = reactFiberReconcilerNewModule.createHydrationContainer
local updateContainer_new = reactFiberReconcilerNewModule.updateContainer
local batchedUpdates_new = reactFiberReconcilerNewModule.batchedUpdates
local deferredUpdates_new = reactFiberReconcilerNewModule.deferredUpdates
local discreteUpdates_new = reactFiberReconcilerNewModule.discreteUpdates
local flushControlled_new = reactFiberReconcilerNewModule.flushControlled
local flushSync_new = reactFiberReconcilerNewModule.flushSync
local isAlreadyRendering_new = reactFiberReconcilerNewModule.isAlreadyRendering
local flushPassiveEffects_new = reactFiberReconcilerNewModule.flushPassiveEffects
local getPublicRootInstance_new = reactFiberReconcilerNewModule.getPublicRootInstance
local attemptSynchronousHydration_new = reactFiberReconcilerNewModule.attemptSynchronousHydration
local attemptDiscreteHydration_new = reactFiberReconcilerNewModule.attemptDiscreteHydration
local attemptContinuousHydration_new = reactFiberReconcilerNewModule.attemptContinuousHydration
local attemptHydrationAtCurrentPriority_new = reactFiberReconcilerNewModule.attemptHydrationAtCurrentPriority
local findHostInstance_new = reactFiberReconcilerNewModule.findHostInstance
local findHostInstanceWithWarning_new = reactFiberReconcilerNewModule.findHostInstanceWithWarning
local findHostInstanceWithNoPortals_new = reactFiberReconcilerNewModule.findHostInstanceWithNoPortals
local shouldError_new = reactFiberReconcilerNewModule.shouldError
local shouldSuspend_new = reactFiberReconcilerNewModule.shouldSuspend
local injectIntoDevTools_new = reactFiberReconcilerNewModule.injectIntoDevTools
local createPortal_new = reactFiberReconcilerNewModule.createPortal
local createComponentSelector_new = reactFiberReconcilerNewModule.createComponentSelector
local createHasPseudoClassSelector_new = reactFiberReconcilerNewModule.createHasPseudoClassSelector
local createRoleSelector_new = reactFiberReconcilerNewModule.createRoleSelector
local createTestNameSelector_new = reactFiberReconcilerNewModule.createTestNameSelector
local createTextSelector_new = reactFiberReconcilerNewModule.createTextSelector
local getFindAllNodesFailureDescription_new = reactFiberReconcilerNewModule.getFindAllNodesFailureDescription
local findAllNodes_new = reactFiberReconcilerNewModule.findAllNodes
local findBoundingRects_new = reactFiberReconcilerNewModule.findBoundingRects
local focusWithin_new = reactFiberReconcilerNewModule.focusWithin
local observeVisibleRects_new = reactFiberReconcilerNewModule.observeVisibleRects
local registerMutableSourceForHydration_new = reactFiberReconcilerNewModule.registerMutableSourceForHydration
local runWithPriority_new = reactFiberReconcilerNewModule.runWithPriority
local getCurrentUpdatePriority_new = reactFiberReconcilerNewModule.getCurrentUpdatePriority
local createContainer = if Boolean.toJSBoolean(enableNewReconciler) then createContainer_new else createContainer_old
exports.createContainer = createContainer
local createHydrationContainer = if Boolean.toJSBoolean(enableNewReconciler)
	then createHydrationContainer_new
	else createHydrationContainer_old
exports.createHydrationContainer = createHydrationContainer
local updateContainer = if Boolean.toJSBoolean(enableNewReconciler) then updateContainer_new else updateContainer_old
exports.updateContainer = updateContainer
local batchedUpdates = if Boolean.toJSBoolean(enableNewReconciler) then batchedUpdates_new else batchedUpdates_old
exports.batchedUpdates = batchedUpdates
local deferredUpdates = if Boolean.toJSBoolean(enableNewReconciler) then deferredUpdates_new else deferredUpdates_old
exports.deferredUpdates = deferredUpdates
local discreteUpdates = if Boolean.toJSBoolean(enableNewReconciler) then discreteUpdates_new else discreteUpdates_old
exports.discreteUpdates = discreteUpdates
local flushControlled = if Boolean.toJSBoolean(enableNewReconciler) then flushControlled_new else flushControlled_old
exports.flushControlled = flushControlled
local flushSync = if Boolean.toJSBoolean(enableNewReconciler) then flushSync_new else flushSync_old
exports.flushSync = flushSync
local isAlreadyRendering = if Boolean.toJSBoolean(enableNewReconciler)
	then isAlreadyRendering_new
	else isAlreadyRendering_old
exports.isAlreadyRendering = isAlreadyRendering
local flushPassiveEffects = if Boolean.toJSBoolean(enableNewReconciler)
	then flushPassiveEffects_new
	else flushPassiveEffects_old
exports.flushPassiveEffects = flushPassiveEffects
local getPublicRootInstance = if Boolean.toJSBoolean(enableNewReconciler)
	then getPublicRootInstance_new
	else getPublicRootInstance_old
exports.getPublicRootInstance = getPublicRootInstance
local attemptSynchronousHydration = if Boolean.toJSBoolean(enableNewReconciler)
	then attemptSynchronousHydration_new
	else attemptSynchronousHydration_old
exports.attemptSynchronousHydration = attemptSynchronousHydration
local attemptDiscreteHydration = if Boolean.toJSBoolean(enableNewReconciler)
	then attemptDiscreteHydration_new
	else attemptDiscreteHydration_old
exports.attemptDiscreteHydration = attemptDiscreteHydration
local attemptContinuousHydration = if Boolean.toJSBoolean(enableNewReconciler)
	then attemptContinuousHydration_new
	else attemptContinuousHydration_old
exports.attemptContinuousHydration = attemptContinuousHydration
local attemptHydrationAtCurrentPriority = if Boolean.toJSBoolean(enableNewReconciler)
	then attemptHydrationAtCurrentPriority_new
	else attemptHydrationAtCurrentPriority_old
exports.attemptHydrationAtCurrentPriority = attemptHydrationAtCurrentPriority
local getCurrentUpdatePriority = if Boolean.toJSBoolean(enableNewReconciler)
	then getCurrentUpdatePriority_new
	else getCurrentUpdatePriority_old
exports.getCurrentUpdatePriority = getCurrentUpdatePriority
local findHostInstance = if Boolean.toJSBoolean(enableNewReconciler) then findHostInstance_new else findHostInstance_old
exports.findHostInstance = findHostInstance
local findHostInstanceWithWarning = if Boolean.toJSBoolean(enableNewReconciler)
	then findHostInstanceWithWarning_new
	else findHostInstanceWithWarning_old
exports.findHostInstanceWithWarning = findHostInstanceWithWarning
local findHostInstanceWithNoPortals = if Boolean.toJSBoolean(enableNewReconciler)
	then findHostInstanceWithNoPortals_new
	else findHostInstanceWithNoPortals_old
exports.findHostInstanceWithNoPortals = findHostInstanceWithNoPortals
local shouldError = if Boolean.toJSBoolean(enableNewReconciler) then shouldError_new else shouldError_old
exports.shouldError = shouldError
local shouldSuspend = if Boolean.toJSBoolean(enableNewReconciler) then shouldSuspend_new else shouldSuspend_old
exports.shouldSuspend = shouldSuspend
local injectIntoDevTools = if Boolean.toJSBoolean(enableNewReconciler)
	then injectIntoDevTools_new
	else injectIntoDevTools_old
exports.injectIntoDevTools = injectIntoDevTools
local createPortal = if Boolean.toJSBoolean(enableNewReconciler) then createPortal_new else createPortal_old
exports.createPortal = createPortal
local createComponentSelector = if Boolean.toJSBoolean(enableNewReconciler)
	then createComponentSelector_new
	else createComponentSelector_old
exports.createComponentSelector = createComponentSelector --TODO: "psuedo" is spelled "pseudo"
local createHasPseudoClassSelector = if Boolean.toJSBoolean(enableNewReconciler)
	then createHasPseudoClassSelector_new
	else createHasPseudoClassSelector_old
exports.createHasPseudoClassSelector = createHasPseudoClassSelector
local createRoleSelector = if Boolean.toJSBoolean(enableNewReconciler)
	then createRoleSelector_new
	else createRoleSelector_old
exports.createRoleSelector = createRoleSelector
local createTextSelector = if Boolean.toJSBoolean(enableNewReconciler)
	then createTextSelector_new
	else createTextSelector_old
exports.createTextSelector = createTextSelector
local createTestNameSelector = if Boolean.toJSBoolean(enableNewReconciler)
	then createTestNameSelector_new
	else createTestNameSelector_old
exports.createTestNameSelector = createTestNameSelector
local getFindAllNodesFailureDescription = if Boolean.toJSBoolean(enableNewReconciler)
	then getFindAllNodesFailureDescription_new
	else getFindAllNodesFailureDescription_old
exports.getFindAllNodesFailureDescription = getFindAllNodesFailureDescription
local findAllNodes = if Boolean.toJSBoolean(enableNewReconciler) then findAllNodes_new else findAllNodes_old
exports.findAllNodes = findAllNodes
local findBoundingRects = if Boolean.toJSBoolean(enableNewReconciler)
	then findBoundingRects_new
	else findBoundingRects_old
exports.findBoundingRects = findBoundingRects
local focusWithin = if Boolean.toJSBoolean(enableNewReconciler) then focusWithin_new else focusWithin_old
exports.focusWithin = focusWithin
local observeVisibleRects = if Boolean.toJSBoolean(enableNewReconciler)
	then observeVisibleRects_new
	else observeVisibleRects_old
exports.observeVisibleRects = observeVisibleRects
local registerMutableSourceForHydration = if Boolean.toJSBoolean(enableNewReconciler)
	then registerMutableSourceForHydration_new
	else registerMutableSourceForHydration_old
exports.registerMutableSourceForHydration = registerMutableSourceForHydration
local runWithPriority = if Boolean.toJSBoolean(enableNewReconciler) then runWithPriority_new else runWithPriority_old
exports.runWithPriority = runWithPriority
return exports
>>>>>>> upstream-apply
