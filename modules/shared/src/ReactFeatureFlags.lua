<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/ba82eea3837e4aaeb5a30b7827b664a8c2128d2e/packages/shared/ReactFeatureFlags.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/ReactFeatureFlags.js
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
-- Unknown globals fail type checking (see "Unknown symbols" section of
-- https://roblox.github.io/luau/typecheck.html)
local exports = {}

-- Filter certain DOM attributes (e.g. src, href) if their values are empty strings.
-- This prevents e.g. <img src=""> from making an unnecessary HTTP request for certain browsers.
exports.enableFilterEmptyStringAttributesDOM = true

-- Adds verbose console logging for e.g. state updates, suspense, and work loop stuff.
-- Intended to enable React core members to more easily debug scheduling issues in DEV builds.
exports.enableDebugTracing = false

-- Adds user timing marks for e.g. state updates, suspense, and work loop stuff,
-- for an experimental scheduling profiler tool.
exports.enableSchedulingProfiler = _G.__PROFILE__ and _G.__EXPERIMENTAL__

-- Helps identify side effects in render-phase lifecycle hooks and setState
-- reducers by double invoking them in Strict Mode.
-- ROBLOX TODO: we'll want to enable this for DEV app bundles
exports.debugRenderPhaseSideEffectsForStrictMode = _G.__DEV__

-- To preserve the "Pause on caught exceptions" behavior of the debugger, we
-- replay the begin phase of a failed component inside invokeGuardedCallback.
exports.replayFailedUnitOfWorkWithInvokeGuardedCallback = _G.__DEV__

-- Warn about deprecated, async-unsafe lifecycles; relates to RFC #6:
exports.warnAboutDeprecatedLifecycles = true

-- Gather advanced timing metrics for Profiler subtrees.
exports.enableProfilerTimer = _G.__PROFILE__

-- Record durations for commit and passive effects phases.
exports.enableProfilerCommitHooks = false

-- Trace which interactions trigger each commit.
exports.enableSchedulerTracing = _G.__PROFILE__

-- SSR experiments
exports.enableSuspenseServerRenderer = _G.__EXPERIMENTAL__
exports.enableSelectiveHydration = _G.__EXPERIMENTAL__

-- Flight experiments
exports.enableBlocksAPI = _G.__EXPERIMENTAL__
exports.enableLazyElements = _G.__EXPERIMENTAL__

-- Only used in www builds.
exports.enableSchedulerDebugging = false

-- Disable javascript: URL strings in href for XSS protection.
exports.disableJavaScriptURLs = false

-- Experimental Host Component support.
exports.enableFundamentalAPI = false

-- Experimental Scope support.
exports.enableScopeAPI = false

-- Experimental Create Event Handle API.
exports.enableCreateEventHandleAPI = false

-- New API for JSX transforms to target - https://github.com/reactjs/rfcs/pull/107

-- We will enforce mocking scheduler with scheduler/unstable_mock at some point. (v18?)
-- Till then, we warn about the missing mock, but still fallback to a legacy mode compatible version
exports.warnAboutUnmockedScheduler = false

-- Add a callback property to suspense to notify which promises are currently
-- in the update queue. This allows reporting and tracing of what is causing
-- the user to see a loading state.
-- Also allows hydration callbacks to fire when a dehydrated boundary gets
-- hydrated or deleted.
exports.enableSuspenseCallback = false

-- Part of the simplification of React.createElement so we can eventually move
-- from React.createElement to React.jsx
-- https://github.com/reactjs/rfcs/blob/createlement-rfc/text/0000-create-element-changes.md
exports.warnAboutDefaultPropsOnFunctionComponents = false

exports.disableSchedulerTimeoutBasedOnReactExpirationTime = false

exports.enableTrustedTypesIntegration = false

-- Enables a warning when trying to spread a 'key' to an element
-- a deprecated pattern we want to get rid of in the future
exports.warnAboutSpreadingKeyToJSX = true

exports.enableComponentStackLocations = true

exports.enableNewReconciler = true

-- Errors that are thrown while unmounting (or after in the case of passive effects)
-- should bypass any error boundaries that are also unmounting (or have unmounted)
-- and be handled by the nearest still-mounted boundary.
-- If there are no still-mounted boundaries, the errors should be rethrown.
exports.skipUnmountedBoundaries = true

-- --------------------------
-- Future APIs to be deprecated
-- --------------------------

-- Prevent the value and checked attributes from syncing
-- with their related DOM properties
exports.disableInputAttributeSyncing = true

exports.warnAboutStringRefs = false

exports.disableLegacyContext = false

-- Disables children for <textarea> elements
exports.disableTextareaChildren = false

exports.disableModulePatternComponents = false

-- We should remove this flag once the above flag becomes enabled
exports.warnUnstableRenderSubtreeIntoContainer = false

-- Support legacy Primer support on internal FB www
exports.enableLegacyFBSupport = true

-- Updates that occur in the render phase are not officially supported. But when
=======
local exports = {}
-- -----------------------------------------------------------------------------
-- Land or remove (zero effort)
--
-- Flags that can likely be deleted or landed without consequences
-- -----------------------------------------------------------------------------
local warnAboutDeprecatedLifecycles = true
exports.warnAboutDeprecatedLifecycles = warnAboutDeprecatedLifecycles
local enableComponentStackLocations = true
exports.enableComponentStackLocations = enableComponentStackLocations
local disableSchedulerTimeoutBasedOnReactExpirationTime = false
exports.disableSchedulerTimeoutBasedOnReactExpirationTime = disableSchedulerTimeoutBasedOnReactExpirationTime -- -----------------------------------------------------------------------------
-- Land or remove (moderate effort)
--
-- Flags that can be probably deleted or landed, but might require extra effort
-- like migrating internal callers or performance testing.
-- -----------------------------------------------------------------------------
-- This is blocked on adding a symbol polyfill to www.
local enableSymbolFallbackForWWW = false
exports.enableSymbolFallbackForWWW = enableSymbolFallbackForWWW -- This rolled out to 10% public in www, so we should be able to land, but some
-- internal tests need to be updated. The open source behavior is correct.
local skipUnmountedBoundaries = true
exports.skipUnmountedBoundaries = skipUnmountedBoundaries -- Destroy layout effects for components that are hidden because something
-- suspended in an update and recreate them when they are shown again (after the
-- suspended boundary has resolved). Note that this should be an uncommon use
-- case and can be avoided by using the transition API.
--
-- TODO: Finish rolling out in www
local enableSuspenseLayoutEffectSemantics = true
exports.enableSuspenseLayoutEffectSemantics = enableSuspenseLayoutEffectSemantics -- TODO: Finish rolling out in www
local enableClientRenderFallbackOnTextMismatch = true
exports.enableClientRenderFallbackOnTextMismatch = enableClientRenderFallbackOnTextMismatch -- TODO: Need to review this code one more time before landing
local enableCapturePhaseSelectiveHydrationWithoutDiscreteEventReplay = true
exports.enableCapturePhaseSelectiveHydrationWithoutDiscreteEventReplay =
	enableCapturePhaseSelectiveHydrationWithoutDiscreteEventReplay -- Recoil still uses useMutableSource in www, need to delete
local enableUseMutableSource = false
exports.enableUseMutableSource = enableUseMutableSource -- Not sure if www still uses this. We don't have a replacement but whatever we
-- replace it with will likely be different than what's already there, so we
-- probably should just delete it as long as nothing in www relies on it.
local enableSchedulerDebugging = false
exports.enableSchedulerDebugging = enableSchedulerDebugging -- Need to remove didTimeout argument from Scheduler before landing
local disableSchedulerTimeoutInWorkLoop = false
exports.disableSchedulerTimeoutInWorkLoop = disableSchedulerTimeoutInWorkLoop -- -----------------------------------------------------------------------------
-- Slated for removal in the future (significant effort)
--
-- These are experiments that didn't work out, and never shipped, but we can't
-- delete from the codebase until we migrate internal callers.
-- -----------------------------------------------------------------------------
-- Add a callback property to suspense to notify which promises are currently
-- in the update queue. This allows reporting and tracing of what is causing
-- the user to see a loading state.
--
-- Also allows hydration callbacks to fire when a dehydrated boundary gets
-- hydrated or deleted.
--
-- This will eventually be replaced by the Transition Tracing proposal.
local enableSuspenseCallback = false
exports.enableSuspenseCallback = enableSuspenseCallback -- Experimental Scope support.
local enableScopeAPI = false
exports.enableScopeAPI = enableScopeAPI -- Experimental Create Event Handle API.
local enableCreateEventHandleAPI = false
exports.enableCreateEventHandleAPI = enableCreateEventHandleAPI -- This controls whether you get the `.old` modules or the `.new` modules in
-- the react-reconciler package.
local enableNewReconciler = false
exports.enableNewReconciler = enableNewReconciler -- Support legacy Primer support on internal FB www
local enableLegacyFBSupport = false
exports.enableLegacyFBSupport = enableLegacyFBSupport -- -----------------------------------------------------------------------------
-- Ongoing experiments
--
-- These are features that we're either actively exploring or are reasonably
-- likely to include in an upcoming release.
-- -----------------------------------------------------------------------------
local enableCache = __EXPERIMENTAL__
exports.enableCache = enableCache
local enableCacheElement = __EXPERIMENTAL__
exports.enableCacheElement = enableCacheElement
local enableTransitionTracing = false
exports.enableTransitionTracing = enableTransitionTracing -- No known bugs, but needs performance testing
local enableLazyContextPropagation = false
exports.enableLazyContextPropagation = enableLazyContextPropagation -- FB-only usage. The new API has different semantics.
local enableLegacyHidden = false
exports.enableLegacyHidden = enableLegacyHidden -- Enables unstable_avoidThisFallback feature in Fiber
local enableSuspenseAvoidThisFallback = false
exports.enableSuspenseAvoidThisFallback = enableSuspenseAvoidThisFallback -- Enables unstable_avoidThisFallback feature in Fizz
local enableSuspenseAvoidThisFallbackFizz = false
exports.enableSuspenseAvoidThisFallbackFizz = enableSuspenseAvoidThisFallbackFizz
local enableCPUSuspense = __EXPERIMENTAL__
exports.enableCPUSuspense = enableCPUSuspense -- When a node is unmounted, recurse into the Fiber subtree and clean out
-- references. Each level cleans up more fiber fields than the previous level.
-- As far as we know, React itself doesn't leak, but because the Fiber contains
-- cycles, even a single leak in product code can cause us to retain large
-- amounts of memory.
--
-- The long term plan is to remove the cycles, but in the meantime, we clear
-- additional fields to mitigate.
--
-- It's an enum so that we can experiment with different levels of
-- aggressiveness.
local deletedTreeCleanUpLevel = 3
exports.deletedTreeCleanUpLevel = deletedTreeCleanUpLevel -- -----------------------------------------------------------------------------
-- Chopping Block
--
-- Planned feature deprecations and breaking changes. Sorted roughly in order of
-- when we we plan to enable them.
-- -----------------------------------------------------------------------------
-- This flag enables Strict Effects by default. We're not turning this on until
-- after 18 because it requires migration work. Recommendation is to use
-- <StrictMode /> to gradually upgrade components.
-- If TRUE, trees rendered with createRoot will be StrictEffectsMode.
-- If FALSE, these trees will be StrictLegacyMode.
local createRootStrictEffectsByDefault = false
exports.createRootStrictEffectsByDefault = createRootStrictEffectsByDefault
local disableModulePatternComponents = false
exports.disableModulePatternComponents = disableModulePatternComponents
local disableLegacyContext = false
exports.disableLegacyContext = disableLegacyContext
local enableUseRefAccessWarning = false
exports.enableUseRefAccessWarning = enableUseRefAccessWarning -- Enables time slicing for updates that aren't wrapped in startTransition.
local enableSyncDefaultUpdates = true
exports.enableSyncDefaultUpdates = enableSyncDefaultUpdates -- Adds an opt-in to time slicing for updates that aren't wrapped in
-- startTransition. Only relevant when enableSyncDefaultUpdates is disabled.
local allowConcurrentByDefault = false
exports.allowConcurrentByDefault = allowConcurrentByDefault -- Updates that occur in the render phase are not officially supported. But when
>>>>>>> upstream-apply
-- they do occur, we defer them to a subsequent render by picking a lane that's
-- not currently rendering. We treat them the same as if they came from an
-- interleaved event. Remove this flag once we have migrated to the
-- new behavior.
<<<<<<< HEAD
exports.deferRenderPhaseUpdateToNextBatch = false

-- Replacement for runWithPriority in React internals.
exports.decoupleUpdatePriorityFromScheduler = true

exports.enableDiscreteEventFlushingChange = false

exports.enableEagerRootListeners = false

exports.enableDoubleInvokingEffects = false
=======
-- NOTE: Not sure if we'll end up doing this or not.
local deferRenderPhaseUpdateToNextBatch = false
exports.deferRenderPhaseUpdateToNextBatch = deferRenderPhaseUpdateToNextBatch -- -----------------------------------------------------------------------------
-- React DOM Chopping Block
--
-- Similar to main Chopping Block but only flags related to React DOM. These are
-- grouped because we will likely batch all of them into a single major release.
-- -----------------------------------------------------------------------------
-- Disable support for comment nodes as React DOM containers. Already disabled
-- in open source, but www codebase still relies on it. Need to remove.
local disableCommentsAsDOMContainers = true
exports.disableCommentsAsDOMContainers = disableCommentsAsDOMContainers -- Disable javascript: URL strings in href for XSS protection.
local disableJavaScriptURLs = false
exports.disableJavaScriptURLs = disableJavaScriptURLs
local enableTrustedTypesIntegration = false
exports.enableTrustedTypesIntegration = enableTrustedTypesIntegration -- Prevent the value and checked attributes from syncing with their related
-- DOM properties
local disableInputAttributeSyncing = false
exports.disableInputAttributeSyncing = disableInputAttributeSyncing -- Filter certain DOM attributes (e.g. src, href) if their values are empty
-- strings. This prevents e.g. <img src=""> from making an unnecessary HTTP
-- request for certain browsers.
local enableFilterEmptyStringAttributesDOM = false
exports.enableFilterEmptyStringAttributesDOM = enableFilterEmptyStringAttributesDOM -- Changes the behavior for rendering custom elements in both server rendering
-- and client rendering, mostly to allow JSX attributes to apply to the custom
-- element's object properties instead of only HTML attributes.
-- https://github.com/facebook/react/issues/11347
local enableCustomElementPropertySupport = __EXPERIMENTAL__
exports.enableCustomElementPropertySupport = enableCustomElementPropertySupport -- Disables children for <textarea> elements
local disableTextareaChildren = false
exports.disableTextareaChildren = disableTextareaChildren -- -----------------------------------------------------------------------------
-- JSX Chopping Block
--
-- Similar to main Chopping Block but only flags related to JSX. These are
-- grouped because we will likely batch all of them into a single major release.
-- -----------------------------------------------------------------------------
-- New API for JSX transforms to target - https://github.com/reactjs/rfcs/pull/107
-- Part of the simplification of React.createElement so we can eventually move
-- from React.createElement to React.jsx
-- https://github.com/reactjs/rfcs/blob/createlement-rfc/text/0000-create-element-changes.md
local warnAboutDefaultPropsOnFunctionComponents = false
exports.warnAboutDefaultPropsOnFunctionComponents = warnAboutDefaultPropsOnFunctionComponents -- deprecate later, not 18.0
-- Enables a warning when trying to spread a 'key' to an element;
-- a deprecated pattern we want to get rid of in the future
local warnAboutSpreadingKeyToJSX = false
exports.warnAboutSpreadingKeyToJSX = warnAboutSpreadingKeyToJSX
local warnAboutStringRefs = false
exports.warnAboutStringRefs = warnAboutStringRefs -- -----------------------------------------------------------------------------
-- Debugging and DevTools
-- -----------------------------------------------------------------------------
-- Adds user timing marks for e.g. state updates, suspense, and work loop stuff,
-- for an experimental timeline tool.
local enableSchedulingProfiler = __PROFILE__
exports.enableSchedulingProfiler = enableSchedulingProfiler -- Helps identify side effects in render-phase lifecycle hooks and setState
-- reducers by double invoking them in StrictLegacyMode.
local debugRenderPhaseSideEffectsForStrictMode = __DEV__
exports.debugRenderPhaseSideEffectsForStrictMode = debugRenderPhaseSideEffectsForStrictMode -- Helps identify code that is not safe for planned Offscreen API and Suspense semantics;
-- this feature flag only impacts StrictEffectsMode.
local enableStrictEffects = __DEV__
exports.enableStrictEffects = enableStrictEffects -- To preserve the "Pause on caught exceptions" behavior of the debugger, we
-- replay the begin phase of a failed component inside invokeGuardedCallback.
local replayFailedUnitOfWorkWithInvokeGuardedCallback = __DEV__
exports.replayFailedUnitOfWorkWithInvokeGuardedCallback = replayFailedUnitOfWorkWithInvokeGuardedCallback -- Gather advanced timing metrics for Profiler subtrees.
local enableProfilerTimer = __PROFILE__
exports.enableProfilerTimer = enableProfilerTimer -- Record durations for commit and passive effects phases.
local enableProfilerCommitHooks = __PROFILE__
exports.enableProfilerCommitHooks = enableProfilerCommitHooks -- Phase param passed to onRender callback differentiates between an "update" and a "cascading-update".
local enableProfilerNestedUpdatePhase = __PROFILE__
exports.enableProfilerNestedUpdatePhase = enableProfilerNestedUpdatePhase -- Adds verbose console logging for e.g. state updates, suspense, and work loop
-- stuff. Intended to enable React core members to more easily debug scheduling
-- issues in DEV builds.
local enableDebugTracing = false
exports.enableDebugTracing = enableDebugTracing -- Track which Fiber(s) schedule render work.
local enableUpdaterTracking = __PROFILE__
exports.enableUpdaterTracking = enableUpdaterTracking -- Only enabled in RN, related to enableComponentStackLocations
local disableNativeComponentFrames = false
exports.disableNativeComponentFrames = disableNativeComponentFrames
local enableServerContext = __EXPERIMENTAL__
exports.enableServerContext = enableServerContext -- Internal only.
local enableGetInspectorDataForInstanceInProduction = false
exports.enableGetInspectorDataForInstanceInProduction = enableGetInspectorDataForInstanceInProduction -- Profiler API accepts a function to be called when a nested update is scheduled.
-- This callback accepts the component type (class instance or function) the update is scheduled for.
local enableProfilerNestedUpdateScheduledHook = false
exports.enableProfilerNestedUpdateScheduledHook = enableProfilerNestedUpdateScheduledHook
local consoleManagedByDevToolsDuringStrictMode = true
exports.consoleManagedByDevToolsDuringStrictMode = consoleManagedByDevToolsDuringStrictMode
>>>>>>> upstream-apply
return exports
