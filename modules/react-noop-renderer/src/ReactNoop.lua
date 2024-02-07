<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/faa697f4f9afe9f1c98e315b2a9e70f5a74a7a74/packages/react-noop-renderer/src/ReactNoop.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-noop-renderer/src/ReactNoop.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
]]

--[[*
 * This is a renderer of React that doesn't have a render target output.
 * It is useful to demonstrate the internals of the reconciler in isolation
 * and for testing semantics of reconciliation separate from the host
 * environment.
<<<<<<< HEAD
]]

local ReactFiberReconciler = require("@pkg/@jsdotlua/react-reconciler")
local createReactNoop = require("./createReactNoop")

local NoopRenderer = createReactNoop(
	ReactFiberReconciler, -- reconciler
	true -- useMutation
)

return {
	_Scheduler = NoopRenderer._Scheduler,
	getChildren = NoopRenderer.getChildren,
	getPendingChildren = NoopRenderer.getPendingChildren,
	getOrCreateRootContainer = NoopRenderer.getOrCreateRootContainer,
	createRoot = NoopRenderer.createRoot,
	createBlockingRoot = NoopRenderer.createBlockingRoot,
	createLegacyRoot = NoopRenderer.createLegacyRoot,
	getChildrenAsJSX = NoopRenderer.getChildrenAsJSX,
	getPendingChildrenAsJSX = NoopRenderer.getPendingChildrenAsJSX,
	createPortal = NoopRenderer.createPortal,
	render = NoopRenderer.render,
	renderLegacySyncRoot = NoopRenderer.renderLegacySyncRoot,
	renderToRootWithID = NoopRenderer.renderToRootWithID,
	unmountRootWithID = NoopRenderer.unmountRootWithID,
	findInstance = NoopRenderer.findInstance,
	flushNextYield = NoopRenderer.flushNextYield,
	flushWithHostCounters = NoopRenderer.flushWithHostCounters,
	expire = NoopRenderer.expire,
	flushExpired = NoopRenderer.flushExpired,
	batchedUpdates = NoopRenderer.batchedUpdates,
	deferredUpdates = NoopRenderer.deferredUpdates,
	unbatchedUpdates = NoopRenderer.unbatchedUpdates,
	discreteUpdates = NoopRenderer.discreteUpdates,
	flushDiscreteUpdates = NoopRenderer.flushDiscreteUpdates,
	flushSync = NoopRenderer.flushSync,
	flushPassiveEffects = NoopRenderer.flushPassiveEffects,
	act = NoopRenderer.act,
	dumpTree = NoopRenderer.dumpTree,
	getRoot = NoopRenderer.getRoot,
	-- TODO: Remove this after callers migrate to alternatives.
	unstable_runWithPriority = NoopRenderer.unstable_runWithPriority,
}
=======
 ]]
local ReactFiberReconciler = require(Packages["react-reconciler"]).default
local createReactNoop = require(script.Parent.createReactNoop).default
local _Scheduler, getChildren, getPendingChildren, getOrCreateRootContainer, createRoot, createLegacyRoot, getChildrenAsJSX, getPendingChildrenAsJSX, createPortal, render, renderLegacySyncRoot, renderToRootWithID, unmountRootWithID, findInstance, flushNextYield, flushWithHostCounters, expire, flushExpired, batchedUpdates, deferredUpdates, discreteUpdates, idleUpdates, flushSync, flushPassiveEffects, act, dumpTree, getRoot, unstable_runWithPriority
do
	local ref = createReactNoop(
		ReactFiberReconciler, -- reconciler
		true -- useMutation
	)
	_Scheduler, getChildren, getPendingChildren, getOrCreateRootContainer, createRoot, createLegacyRoot, getChildrenAsJSX, getPendingChildrenAsJSX, createPortal, render, renderLegacySyncRoot, renderToRootWithID, unmountRootWithID, findInstance, flushNextYield, flushWithHostCounters, expire, flushExpired, batchedUpdates, deferredUpdates, discreteUpdates, idleUpdates, flushSync, flushPassiveEffects, act, dumpTree, getRoot, unstable_runWithPriority =
		ref._Scheduler,
		ref.getChildren,
		ref.getPendingChildren,
		ref.getOrCreateRootContainer,
		ref.createRoot,
		ref.createLegacyRoot,
		ref.getChildrenAsJSX,
		ref.getPendingChildrenAsJSX,
		ref.createPortal,
		ref.render,
		ref.renderLegacySyncRoot,
		ref.renderToRootWithID,
		ref.unmountRootWithID,
		ref.findInstance,
		ref.flushNextYield,
		ref.flushWithHostCounters,
		ref.expire,
		ref.flushExpired,
		ref.batchedUpdates,
		ref.deferredUpdates,
		ref.discreteUpdates,
		ref.idleUpdates,
		ref.flushSync,
		ref.flushPassiveEffects,
		ref.act,
		ref.dumpTree,
		ref.getRoot, -- TODO: Remove this after callers migrate to alternatives.
		ref.unstable_runWithPriority
end
exports._Scheduler = _Scheduler
exports.getChildren = getChildren
exports.getPendingChildren = getPendingChildren
exports.getOrCreateRootContainer = getOrCreateRootContainer
exports.createRoot = createRoot
exports.createLegacyRoot = createLegacyRoot
exports.getChildrenAsJSX = getChildrenAsJSX
exports.getPendingChildrenAsJSX = getPendingChildrenAsJSX
exports.createPortal = createPortal
exports.render = render
exports.renderLegacySyncRoot = renderLegacySyncRoot
exports.renderToRootWithID = renderToRootWithID
exports.unmountRootWithID = unmountRootWithID
exports.findInstance = findInstance
exports.flushNextYield = flushNextYield
exports.flushWithHostCounters = flushWithHostCounters
exports.expire = expire
exports.flushExpired = flushExpired
exports.batchedUpdates = batchedUpdates
exports.deferredUpdates = deferredUpdates
exports.discreteUpdates = discreteUpdates
exports.idleUpdates = idleUpdates
exports.flushSync = flushSync
exports.flushPassiveEffects = flushPassiveEffects
exports.act = act
exports.dumpTree = dumpTree
exports.getRoot = getRoot
exports.unstable_runWithPriority = unstable_runWithPriority
return exports
>>>>>>> upstream-apply
