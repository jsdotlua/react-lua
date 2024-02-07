<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/56e9feead0f91075ba0a4f725c9e4e343bca1c67/packages/react-reconciler/src/ReactFiber.new.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiber.new.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
]]

local __DEV__ = _G.__DEV__
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Object = LuauPolyfill.Object
<<<<<<< HEAD
local Array = LuauPolyfill.Array
local inspect = LuauPolyfill.util.inspect

-- ROBLOX: use patched console from shared
local console = require("@pkg/@jsdotlua/shared").console

local ReactTypes = require("@pkg/@jsdotlua/shared")
-- ROBLOX deviation: ReactElement is defined at the top level of Shared along
-- with the rest of the ReactTypes
type ReactElement = ReactTypes.ReactElement<any, any>
type ReactFragment = ReactTypes.ReactFragment
type ReactPortal = ReactTypes.ReactPortal
type ReactFundamentalComponent<T, U> = ReactTypes.ReactFundamentalComponent<T, U>
type ReactScope = ReactTypes.ReactScope
local ReactInternalTypes = require("./ReactInternalTypes")
export type Fiber = ReactInternalTypes.Fiber

-- ROBLOX deviation: Allow number keys for sparse arrays
type RoactStableKey = ReactInternalTypes.RoactStableKey
local ReactRootTags = require("./ReactRootTags")
type RootTag = ReactRootTags.RootTag
local ReactWorkTags = require("./ReactWorkTags")
type WorkTag = ReactWorkTags.WorkTag
local ReactTypeOfMode = require("./ReactTypeOfMode")
type TypeOfMode = ReactTypeOfMode.TypeOfMode
local ReactFiberLane = require("./ReactFiberLane")
type Lanes = ReactFiberLane.Lanes
local ReactFiberHostConfig = require("./ReactFiberHostConfig")
type SuspenseInstance = ReactFiberHostConfig.SuspenseInstance
local ReactFiberOffscreenComponent = require("./ReactFiberOffscreenComponent")
type OffscreenProps = ReactFiberOffscreenComponent.OffscreenProps

local invariant = require("@pkg/@jsdotlua/shared").invariant
local ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
-- local enableFundamentalAPI = ReactFeatureFlags.enableFundamentalAPI
-- local enableScopeAPI = ReactFeatureFlags.enableScopeAPI
local ReactFiberFlags = require("./ReactFiberFlags")
local NoFlags = ReactFiberFlags.NoFlags
local Placement = ReactFiberFlags.Placement
local StaticMask = ReactFiberFlags.StaticMask
local ConcurrentRoot = ReactRootTags.ConcurrentRoot
local BlockingRoot = ReactRootTags.BlockingRoot
local IndeterminateComponent = ReactWorkTags.IndeterminateComponent
local ClassComponent = ReactWorkTags.ClassComponent
local HostRoot = ReactWorkTags.HostRoot
local HostComponent = ReactWorkTags.HostComponent
local HostText = ReactWorkTags.HostText
local HostPortal = ReactWorkTags.HostPortal
local ForwardRef = ReactWorkTags.ForwardRef
local Fragment = ReactWorkTags.Fragment
local Mode = ReactWorkTags.Mode
local ContextProvider = ReactWorkTags.ContextProvider
local ContextConsumer = ReactWorkTags.ContextConsumer
local Profiler = ReactWorkTags.Profiler
local SuspenseComponent = ReactWorkTags.SuspenseComponent
local SuspenseListComponent = ReactWorkTags.SuspenseListComponent
local DehydratedFragment = ReactWorkTags.DehydratedFragment
local FunctionComponent = ReactWorkTags.FunctionComponent
local MemoComponent = ReactWorkTags.MemoComponent
local SimpleMemoComponent = ReactWorkTags.SimpleMemoComponent
local LazyComponent = ReactWorkTags.LazyComponent
local FundamentalComponent = ReactWorkTags.FundamentalComponent
local ScopeComponent = ReactWorkTags.ScopeComponent
local OffscreenComponent = ReactWorkTags.OffscreenComponent
local LegacyHiddenComponent = ReactWorkTags.LegacyHiddenComponent
local getComponentName = require("@pkg/@jsdotlua/shared").getComponentName

local ReactFiberDevToolsHook = require("./ReactFiberDevToolsHook.new.lua")
local isDevToolsPresent = ReactFiberDevToolsHook.isDevToolsPresent
local ReactFiberHotReloading = require("./ReactFiberHotReloading.new.lua")
local resolveClassForHotReloading = ReactFiberHotReloading.resolveClassForHotReloading
local resolveFunctionForHotReloading =
	ReactFiberHotReloading.resolveFunctionForHotReloading
local resolveForwardRefForHotReloading =
	ReactFiberHotReloading.resolveForwardRefForHotReloading
local NoLanes = ReactFiberLane.NoLanes
local NoMode = ReactTypeOfMode.NoMode
local ConcurrentMode = ReactTypeOfMode.ConcurrentMode
local DebugTracingMode = ReactTypeOfMode.DebugTracingMode
local ProfileMode = ReactTypeOfMode.ProfileMode
local StrictMode = ReactTypeOfMode.StrictMode
local BlockingMode = ReactTypeOfMode.BlockingMode
local ReactSymbols = require("@pkg/@jsdotlua/shared").ReactSymbols
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_STRICT_MODE_TYPE = ReactSymbols.REACT_STRICT_MODE_TYPE
local REACT_PROFILER_TYPE = ReactSymbols.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
-- local REACT_FUNDAMENTAL_TYPE = ReactSymbols.REACT_FUNDAMENTAL_TYPE
-- local REACT_SCOPE_TYPE = ReactSymbols.REACT_SCOPE_TYPE
local REACT_OFFSCREEN_TYPE = ReactSymbols.REACT_OFFSCREEN_TYPE
local REACT_LEGACY_HIDDEN_TYPE = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE

-- deviation: We probably don't have to worry about this scenario, since we use
-- simple tables as maps

-- local hasBadMapPolyfill

-- if __DEV__ then
-- 	hasBadMapPolyfill = false
-- 	try {
-- 		local nonExtensibleObject = Object.preventExtensions({})
-- 		--[[ eslint-disable no-new ]]
-- 		new Map([[nonExtensibleObject, nil]])
-- 		new Set([nonExtensibleObject])
-- 		--[[ eslint-enable no-new ]]
-- 	} catch (e)
-- 		-- TODO: Consider warning about bad polyfills
-- 		hasBadMapPolyfill = true
-- 	end
-- end

local createFiberFromScope, createFiberFromProfiler, createFiberFromFragment, createFiberFromFundamental, createFiberFromSuspense, createFiberFromOffscreen, createFiberFromLegacyHidden, createFiberFromSuspenseList

local debugCounter = 1

-- ROBLOX deviation START: inline this into its only caller to save hot path performance
-- function FiberNode(
-- 	tag: WorkTag,
-- 	pendingProps: any,
-- 	key: RoactStableKey?,
-- 	mode: TypeOfMode
-- ): Fiber
-- 	return {} :: any
-- end
-- ROBLOX deviation END

-- This is a constructor function, rather than a POJO constructor, still
=======
local Set = LuauPolyfill.Set
local console = LuauPolyfill.console
local exports = {}
local sharedReactElementTypeModule = require(Packages.shared.ReactElementType)
type ReactElement = sharedReactElementTypeModule.ReactElement
local sharedReactTypesModule = require(Packages.shared.ReactTypes)
type ReactFragment = sharedReactTypesModule.ReactFragment
type ReactPortal = sharedReactTypesModule.ReactPortal
type ReactScope = sharedReactTypesModule.ReactScope
local reactInternalTypesModule = require(script.Parent.ReactInternalTypes)
type Fiber = reactInternalTypesModule.Fiber
local reactRootTagsModule = require(script.Parent.ReactRootTags)
type RootTag = reactRootTagsModule.RootTag
local reactWorkTagsModule = require(script.Parent.ReactWorkTags)
type WorkTag = reactWorkTagsModule.WorkTag
local reactTypeOfModeModule = require(script.Parent.ReactTypeOfMode)
type TypeOfMode = reactTypeOfModeModule.TypeOfMode
local reactFiberLaneNewModule = require(script.Parent["ReactFiberLane.new"])
type Lanes = reactFiberLaneNewModule.Lanes
local reactFiberHostConfigModule = require(script.Parent.ReactFiberHostConfig)
type SuspenseInstance = reactFiberHostConfigModule.SuspenseInstance
local reactFiberOffscreenComponentModule = require(script.Parent.ReactFiberOffscreenComponent)
type OffscreenProps = reactFiberOffscreenComponentModule.OffscreenProps
type OffscreenInstance = reactFiberOffscreenComponentModule.OffscreenInstance
local sharedReactFeatureFlagsModule = require(Packages.shared.ReactFeatureFlags)
local createRootStrictEffectsByDefault = sharedReactFeatureFlagsModule.createRootStrictEffectsByDefault
local enableCache = sharedReactFeatureFlagsModule.enableCache
local enableStrictEffects = sharedReactFeatureFlagsModule.enableStrictEffects
local enableProfilerTimer = sharedReactFeatureFlagsModule.enableProfilerTimer
local enableScopeAPI = sharedReactFeatureFlagsModule.enableScopeAPI
local enableLegacyHidden = sharedReactFeatureFlagsModule.enableLegacyHidden
local enableSyncDefaultUpdates = sharedReactFeatureFlagsModule.enableSyncDefaultUpdates
local allowConcurrentByDefault = sharedReactFeatureFlagsModule.allowConcurrentByDefault
local enableTransitionTracing = sharedReactFeatureFlagsModule.enableTransitionTracing
local enableDebugTracing = sharedReactFeatureFlagsModule.enableDebugTracing
local reactFiberFlagsModule = require(script.Parent.ReactFiberFlags)
local NoFlags = reactFiberFlagsModule.NoFlags
local Placement = reactFiberFlagsModule.Placement
local StaticMask = reactFiberFlagsModule.StaticMask
local ConcurrentRoot = require(script.Parent.ReactRootTags).ConcurrentRoot
local reactWorkTagsModule = require(script.Parent.ReactWorkTags)
local IndeterminateComponent = reactWorkTagsModule.IndeterminateComponent
local ClassComponent = reactWorkTagsModule.ClassComponent
local HostRoot = reactWorkTagsModule.HostRoot
local HostComponent = reactWorkTagsModule.HostComponent
local HostText = reactWorkTagsModule.HostText
local HostPortal = reactWorkTagsModule.HostPortal
local ForwardRef = reactWorkTagsModule.ForwardRef
local Fragment = reactWorkTagsModule.Fragment
local Mode = reactWorkTagsModule.Mode
local ContextProvider = reactWorkTagsModule.ContextProvider
local ContextConsumer = reactWorkTagsModule.ContextConsumer
local Profiler = reactWorkTagsModule.Profiler
local SuspenseComponent = reactWorkTagsModule.SuspenseComponent
local SuspenseListComponent = reactWorkTagsModule.SuspenseListComponent
local DehydratedFragment = reactWorkTagsModule.DehydratedFragment
local FunctionComponent = reactWorkTagsModule.FunctionComponent
local MemoComponent = reactWorkTagsModule.MemoComponent
local SimpleMemoComponent = reactWorkTagsModule.SimpleMemoComponent
local LazyComponent = reactWorkTagsModule.LazyComponent
local ScopeComponent = reactWorkTagsModule.ScopeComponent
local OffscreenComponent = reactWorkTagsModule.OffscreenComponent
local LegacyHiddenComponent = reactWorkTagsModule.LegacyHiddenComponent
local CacheComponent = reactWorkTagsModule.CacheComponent
local TracingMarkerComponent = reactWorkTagsModule.TracingMarkerComponent
local getComponentNameFromFiber = require(Packages["react-reconciler"].src.getComponentNameFromFiber).default
local isDevToolsPresent = require(script.Parent["ReactFiberDevToolsHook.new"]).isDevToolsPresent
local reactFiberHotReloadingNewModule = require(script.Parent["ReactFiberHotReloading.new"])
local resolveClassForHotReloading = reactFiberHotReloadingNewModule.resolveClassForHotReloading
local resolveFunctionForHotReloading = reactFiberHotReloadingNewModule.resolveFunctionForHotReloading
local resolveForwardRefForHotReloading = reactFiberHotReloadingNewModule.resolveForwardRefForHotReloading
local NoLanes = require(script.Parent["ReactFiberLane.new"]).NoLanes
local reactTypeOfModeModule = require(script.Parent.ReactTypeOfMode)
local NoMode = reactTypeOfModeModule.NoMode
local ConcurrentMode = reactTypeOfModeModule.ConcurrentMode
local DebugTracingMode = reactTypeOfModeModule.DebugTracingMode
local ProfileMode = reactTypeOfModeModule.ProfileMode
local StrictLegacyMode = reactTypeOfModeModule.StrictLegacyMode
local StrictEffectsMode = reactTypeOfModeModule.StrictEffectsMode
local ConcurrentUpdatesByDefaultMode = reactTypeOfModeModule.ConcurrentUpdatesByDefaultMode
local sharedReactSymbolsModule = require(Packages.shared.ReactSymbols)
local REACT_FORWARD_REF_TYPE = sharedReactSymbolsModule.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = sharedReactSymbolsModule.REACT_FRAGMENT_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = sharedReactSymbolsModule.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_STRICT_MODE_TYPE = sharedReactSymbolsModule.REACT_STRICT_MODE_TYPE
local REACT_PROFILER_TYPE = sharedReactSymbolsModule.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = sharedReactSymbolsModule.REACT_PROVIDER_TYPE
local REACT_CONTEXT_TYPE = sharedReactSymbolsModule.REACT_CONTEXT_TYPE
local REACT_SUSPENSE_TYPE = sharedReactSymbolsModule.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = sharedReactSymbolsModule.REACT_SUSPENSE_LIST_TYPE
local REACT_MEMO_TYPE = sharedReactSymbolsModule.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = sharedReactSymbolsModule.REACT_LAZY_TYPE
local REACT_SCOPE_TYPE = sharedReactSymbolsModule.REACT_SCOPE_TYPE
local REACT_OFFSCREEN_TYPE = sharedReactSymbolsModule.REACT_OFFSCREEN_TYPE
local REACT_LEGACY_HIDDEN_TYPE = sharedReactSymbolsModule.REACT_LEGACY_HIDDEN_TYPE
local REACT_CACHE_TYPE = sharedReactSymbolsModule.REACT_CACHE_TYPE
local REACT_TRACING_MARKER_TYPE = sharedReactSymbolsModule.REACT_TRACING_MARKER_TYPE
exports.Fiber = Fiber
local hasBadMapPolyfill
if Boolean.toJSBoolean(__DEV__) then
	hasBadMapPolyfill = false
	do --[[ ROBLOX COMMENT: try-catch block conversion ]]
		local ok, result, hasReturned = xpcall(function()
			local nonExtensibleObject = Object.preventExtensions({})
			--[[ eslint-disable no-new ]]
			Map.new({ { nonExtensibleObject, nil } })
			Set.new({ nonExtensibleObject })
			--[[ eslint-enable no-new ]]
		end, function(e)
			-- TODO: Consider warning about bad polyfills
			hasBadMapPolyfill = true
		end)
		if hasReturned then
			return result
		end
	end
end
local function FiberNode(
	tag: WorkTag,
	pendingProps: mixed,
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string,
	mode: TypeOfMode
)
	-- Instance
	self.tag = tag
	self.key = key
	self.elementType = nil
	self.type = nil
	self.stateNode = nil -- Fiber
	self["return"] = nil
	self.child = nil
	self.sibling = nil
	self.index = 0
	self.ref = nil
	self.pendingProps = pendingProps
	self.memoizedProps = nil
	self.updateQueue = nil
	self.memoizedState = nil
	self.dependencies = nil
	self.mode = mode -- Effects
	self.flags = NoFlags
	self.subtreeFlags = NoFlags
	self.deletions = nil
	self.lanes = NoLanes
	self.childLanes = NoLanes
	self.alternate = nil
	if Boolean.toJSBoolean(enableProfilerTimer) then
		-- Note: The following is done to avoid a v8 performance cliff.
		--
		-- Initializing the fields below to smis and later updating them with
		-- double values will cause Fibers to end up having separate shapes.
		-- This behavior/bug has something to do with Object.preventExtension().
		-- Fortunately this only impacts DEV builds.
		-- Unfortunately it makes React unusably slow for some applications.
		-- To work around this, initialize the fields below with doubles.
		--
		-- Learn more about this here:
		-- https://github.com/facebook/react/issues/14365
		-- https://bugs.chromium.org/p/v8/issues/detail?id=8538
		self.actualDuration = Number.NaN
		self.actualStartTime = Number.NaN
		self.selfBaseDuration = Number.NaN
		self.treeBaseDuration = Number.NaN -- It's okay to replace the initial doubles with smis after initialization.
		-- This won't trigger the performance cliff mentioned above,
		-- and it simplifies other profiler code (including DevTools).
		self.actualDuration = 0
		self.actualStartTime = -1
		self.selfBaseDuration = 0
		self.treeBaseDuration = 0
	end
	if Boolean.toJSBoolean(__DEV__) then
		-- This isn't directly used but is handy for debugging internals:
		self._debugSource = nil
		self._debugOwner = nil
		self._debugNeedsRemount = false
		self._debugHookTypes = nil
		if not Boolean.toJSBoolean(hasBadMapPolyfill) and typeof(Object.preventExtensions) == "function" then
			Object.preventExtensions(self)
		end
	end
end -- This is a constructor function, rather than a POJO constructor, still
>>>>>>> upstream-apply
-- please ensure we do the following:
-- 1) Nobody should add any instance methods on this. Instance methods can be
--    more difficult to predict when they get optimized and they are almost
--    never inlined properly in static compilers.
-- 2) Nobody should rely on `instanceof Fiber` for type testing. We should
--    always know when it is a fiber.
-- 3) We might want to experiment with using numeric keys since they are easier
--    to optimize in a non-JIT environment.
-- 4) We can easily go from a constructor to a createFiber object literal if that
--    is faster.
-- 5) It should be easy to port this to a C struct and keep a C implementation
--    compatible.
-- ROBLOX deviation START: add elementType, type, and lanes arguments so the table is created in a one-shot to avoid rehashing
local function createFiber(
	tag: WorkTag,
	pendingProps: any,
	key: RoactStableKey?,
	mode: TypeOfMode,
	elementType: any?,
	type_: any?,
	stateNode: any?,
	lanes: Lanes?
): Fiber
	-- $FlowFixMe: the shapes are exact here but Flow doesn't like constructors
	-- ROBLOX deviation START: inline FiberNode(), do the table as a one-shot and avoid initializing nil fields for hot-path performance
	local node: Fiber = {
		-- Instance
		tag = tag,
		key = key,
		elementType = elementType,
		type = type_,
		stateNode = stateNode,

		-- Fiber
		-- node.return_ = nil
		-- node.child = nil
		-- node.sibling = nil
		index = 1,

		-- node.ref = nil

		pendingProps = pendingProps,
		-- memoizedProps = nil
		-- updateQueue = nil
		-- memoizedState = nil
		-- dependencies = nil

		mode = mode,

		-- Effects
		flags = NoFlags,
		subtreeFlags = NoFlags,
		-- deletions = nil

		lanes = if lanes then lanes else NoLanes,
		childLanes = NoLanes,

		-- alternate = nil
	} :: any

	if enableProfilerTimer then
		-- deviation: Unlikely that we have this same performance problem
		--[[
			-- Note: The following is done to avoid a v8 performance cliff.
			--
			-- Initializing the fields below to smis and later updating them with
			-- double values will cause Fibers to end up having separate shapes.
			-- This behavior/bug has something to do with Object.preventExtension().
			-- Fortunately this only impacts DEV builds.
			-- Unfortunately it makes React unusably slow for some applications.
			-- To work around this, initialize the fields below with doubles.
			--
			-- Learn more about this here:
			-- https://github.com/facebook/react/issues/14365
			-- https://bugs.chromium.org/p/v8/issues/detail?id=8538
			node.actualDuration = Number.NaN
			node.actualStartTime = Number.NaN
			node.selfBaseDuration = Number.NaN
			node.treeBaseDuration = Number.NaN

			-- It's okay to replace the initial doubles with smis after initialization.
			-- This won't trigger the performance cliff mentioned above,
			-- and it simplifies other profiler code (including DevTools).
		]]
		node.actualDuration = 0
		node.actualStartTime = -1
		node.selfBaseDuration = 0
		node.treeBaseDuration = 0
	end

	if __DEV__ then
		-- This isn't directly used but is handy for debugging internals:
		node._debugID = debugCounter
		debugCounter += 1
		node._debugSource = nil
		node._debugOwner = nil
		node._debugNeedsRemount = false
		node._debugHookTypes = nil
		-- deviation: We can just make sure this is always valid
		-- if not hasBadMapPolyfill and typeof(Object.preventExtensions) == "function"

		-- deviation: FIXME - we can't actually distinguish between 'nil' and
		-- absent, so if we do this here, we won't be able to initialize fields
		-- that start out as 'nil'
		-- Object.preventExtensions(node)

		-- end
	end
	return node
	-- ROBLOX deviation END
end

-- ROBLOX deviation START: we inline all uses of this function for performance in hot path
function _shouldConstruct(Component)
	-- deviation: With Lua metatables, members of the "prototype" can be
	-- accessed directly. so we don't need to check for a prototype separately
	return type(Component) ~= "function" and not not Component.isReactComponent
end
-- ROBLOX deviation END

local function isSimpleFunctionComponent(type_: any)
	-- ROBLOX deviation START: inline shouldConstruct logic for hot path performance
	return type(type_) == "function"
	-- deviation: function components don't support this anyway
	-- type.defaultProps == undefined
	-- ROBLOX deviation END: inline shouldConstruct logic for hot path performance
end

local function resolveLazyComponentTag(Component: any): WorkTag
	local typeofComponent = typeof(Component)
	if typeofComponent == "function" then
		return FunctionComponent
	end

	if typeofComponent == "table" then
		if Component.isReactComponent then
			return ClassComponent
		end
		local __typeof = Component["$$typeof"]
		if __typeof == REACT_FORWARD_REF_TYPE then
			return ForwardRef
		end
		if __typeof == REACT_MEMO_TYPE then
			return MemoComponent
		end
	end

	return IndeterminateComponent
end

-- This is used to create an alternate fiber to do work on.
local function createWorkInProgress(current: Fiber, pendingProps: any): Fiber
	-- ROBLOX FIXME Luau: Luau doesn't understand if nil then create pattern
	local workInProgress = current.alternate :: Fiber
	if workInProgress == nil then
		-- We use a double buffering pooling technique because we know that we'll
		-- only ever need at most two versions of a tree. We pool the "other" unused
		-- node that we're free to reuse. This is lazily created to avoid allocating
		-- extra objects for things that are never updated. It also allow us to
		-- reclaim the extra memory if needed.
		workInProgress = createFiber(
			current.tag,
			pendingProps,
			current.key,
			current.mode,
			current.elementType,
			current.type,
			current.stateNode
		)

		if __DEV__ then
			-- DEV-only fields
			workInProgress._debugSource = current._debugSource
			workInProgress._debugOwner = current._debugOwner
			workInProgress._debugHookTypes = current._debugHookTypes
		end

		workInProgress.alternate = current
		current.alternate = workInProgress
	else
<<<<<<< HEAD
		workInProgress.pendingProps = pendingProps
		-- Needed because Blocks store data on type.
		workInProgress.type = current.type

		-- We already have an alternate.
		-- Reset the effect tag.
		workInProgress.flags = NoFlags

		-- The current effects are no longer valid
=======
		workInProgress.pendingProps = pendingProps -- Needed because Blocks store data on type.
		workInProgress.type = current.type -- We already have an alternate.
		-- Reset the effect tag.
		workInProgress.flags = NoFlags -- The effects are no longer valid.
>>>>>>> upstream-apply
		workInProgress.subtreeFlags = NoFlags
		workInProgress.deletions = nil

		if enableProfilerTimer then
			-- We intentionally reset, rather than copy, actualDuration & actualStartTime.
			-- This prevents time from endlessly accumulating in new commits.
			-- This has the downside of resetting values for different priority renders,
			-- But works for yielding (the common case) and should support resuming.
			workInProgress.actualDuration = 0
			workInProgress.actualStartTime = -1
		end
	end

	-- Reset all effects except static ones.
	-- Static effects are not specific to a render.
	workInProgress.flags = bit32.band(current.flags, StaticMask)
	workInProgress.childLanes = current.childLanes
	workInProgress.lanes = current.lanes

	workInProgress.child = current.child
	workInProgress.memoizedProps = current.memoizedProps
	workInProgress.memoizedState = current.memoizedState
	workInProgress.updateQueue = current.updateQueue

	-- Clone the dependencies object. This is mutated during the render phase, so
	-- it cannot be shared with the current fiber.
	local currentDependencies = current.dependencies
	if currentDependencies == nil then
		workInProgress.dependencies = nil
	else
		workInProgress.dependencies = {
			lanes = currentDependencies.lanes,
			firstContext = currentDependencies.firstContext,
		}
	end

	-- These will be overridden during the parent's reconciliation
	workInProgress.sibling = current.sibling
	workInProgress.index = current.index
	workInProgress.ref = current.ref

	if enableProfilerTimer then
		workInProgress.selfBaseDuration = current.selfBaseDuration
		workInProgress.treeBaseDuration = current.treeBaseDuration
	end

	if __DEV__ then
		workInProgress._debugNeedsRemount = current._debugNeedsRemount
		if
			workInProgress.tag == IndeterminateComponent
			or workInProgress.tag == FunctionComponent
			or workInProgress.tag == SimpleMemoComponent
		then
			workInProgress.type = resolveFunctionForHotReloading(current.type)
		elseif workInProgress.tag == ClassComponent then
			workInProgress.type = resolveClassForHotReloading(current.type)
		elseif workInProgress.tag == ForwardRef then
			workInProgress.type = resolveForwardRefForHotReloading(current.type)
		end
	end

	return workInProgress
end

-- Used to reuse a Fiber for a second pass.
local function resetWorkInProgress(workInProgress: Fiber, renderLanes: Lanes)
	-- This resets the Fiber to what createFiber or createWorkInProgress would
	-- have set the values to before during the first pass. Ideally this wouldn't
	-- be necessary but unfortunately many code paths reads from the workInProgress
	-- when they should be reading from current and writing to workInProgress.

	-- We assume pendingProps, index, key, ref, return are still untouched to
	-- avoid doing another reconciliation.
<<<<<<< HEAD

	-- Reset the effect tag but keep any Placement tags, since that's something
	-- that child fiber is setting, not the reconciliation.
	workInProgress.flags =
		bit32.band(workInProgress.flags, bit32.bor(StaticMask, Placement))

	-- The effects are no longer valid

=======
	-- Reset the effect flags but keep any Placement tags, since that's something
	-- that child fiber is setting, not the reconciliation.
	workInProgress.flags = bit32.band(
		workInProgress.flags,
		bit32.bor(StaticMask, Placement) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]] -- The effects are no longer valid.
>>>>>>> upstream-apply
	local current = workInProgress.alternate
	if current == nil then
		-- Reset to createFiber's initial values.
		workInProgress.childLanes = NoLanes
		workInProgress.lanes = renderLanes

		workInProgress.child = nil
		workInProgress.subtreeFlags = NoFlags
		workInProgress.memoizedProps = nil
		workInProgress.memoizedState = nil
		workInProgress.updateQueue = nil

		workInProgress.dependencies = nil

		workInProgress.stateNode = nil

		if enableProfilerTimer then
			-- Note: We don't reset the actualTime counts. It's useful to accumulate
			-- actual time across multiple render passes.
			workInProgress.selfBaseDuration = 0
			workInProgress.treeBaseDuration = 0
		end
	else
		-- Reset to the cloned values that createWorkInProgress would've.
		workInProgress.childLanes = current.childLanes
		workInProgress.lanes = current.lanes

		workInProgress.child = current.child
		workInProgress.subtreeFlags = NoFlags
		workInProgress.deletions = nil
		workInProgress.memoizedProps = current.memoizedProps
		workInProgress.memoizedState = current.memoizedState
		workInProgress.updateQueue = current.updateQueue
		-- Needed because Blocks store data on type.
		workInProgress.type = current.type

		-- Clone the dependencies object. This is mutated during the render phase, so
		-- it cannot be shared with the current fiber.
		local currentDependencies = current.dependencies
		if currentDependencies == nil then
			workInProgress.dependencies = nil
		else
			workInProgress.dependencies = {
				lanes = currentDependencies.lanes,
				firstContext = currentDependencies.firstContext,
			}
		end

		if enableProfilerTimer then
			-- Note: We don't reset the actualTime counts. It's useful to accumulate
			-- actual time across multiple render passes.
			workInProgress.selfBaseDuration = current.selfBaseDuration
			workInProgress.treeBaseDuration = current.treeBaseDuration
		end
	end

	return workInProgress
end
<<<<<<< HEAD

local function createHostRootFiber(tag: RootTag): Fiber
	local mode
	if tag == ConcurrentRoot then
		mode = bit32.bor(ConcurrentMode, BlockingMode, StrictMode)
	elseif tag == BlockingRoot then
		mode = bit32.bor(BlockingMode, StrictMode)
=======
exports.resetWorkInProgress = resetWorkInProgress
local function createHostRootFiber(
	tag: RootTag,
	isStrictMode: boolean,
	concurrentUpdatesByDefaultOverride: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | boolean
): Fiber
	local mode
	if tag == ConcurrentRoot then
		mode = ConcurrentMode
		if isStrictMode == true then
			mode = bit32.bor(mode, StrictLegacyMode) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
			if Boolean.toJSBoolean(enableStrictEffects) then
				mode = bit32.bor(mode, StrictEffectsMode) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
			end
		elseif
			Boolean.toJSBoolean(
				if Boolean.toJSBoolean(enableStrictEffects)
					then createRootStrictEffectsByDefault
					else enableStrictEffects
			)
		then
			mode = bit32.bor(
				mode,
				bit32.bor(StrictLegacyMode, StrictEffectsMode) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
			) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		end
		if
			Boolean.toJSBoolean( -- We only use this flag for our repo tests to check both behaviors.
					-- TODO: Flip this flag and rename it something like "forceConcurrentByDefaultForTesting"
					-- We only use this flag for our repo tests to check both behaviors.
					-- TODO: Flip this flag and rename it something like "forceConcurrentByDefaultForTesting"
				not Boolean.toJSBoolean(enableSyncDefaultUpdates)
					or (
						if Boolean.toJSBoolean(allowConcurrentByDefault)
							then concurrentUpdatesByDefaultOverride
							else allowConcurrentByDefault
					)
			)
		then
			mode = bit32.bor(mode, ConcurrentUpdatesByDefaultMode) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		end
>>>>>>> upstream-apply
	else
		mode = NoMode
	end

	-- ROBLOX deviation: We use a function for isDevtoolsPresent to handle the hook being changed at runtime
	if enableProfilerTimer and isDevToolsPresent() then
		-- Always collect profile timings when DevTools are present.
		-- This enables DevTools to start capturing timing at any point–
		-- Without some nodes in the tree having empty base times.
		mode = bit32.bor(mode, ProfileMode)
	end

	return createFiber(HostRoot, nil, nil, mode)
end

local function createFiberFromTypeAndProps(
	type_: any, -- React$ElementType
	key: string?,
	pendingProps: any,
	owner: nil | Fiber,
	mode: TypeOfMode,
	lanes: Lanes
): Fiber
	local fiberTag = IndeterminateComponent
	-- The resolved type is set if we know what the final type will be. I.e. it's not lazy.
	-- deviation: FIXME: Account for deviated class v. function component type logic
	local resolvedType = type_
	local typeOfType_ = type(type_)
	-- deviation: since our class components aren't functions, we have to look
	-- for them more explicitly (inlines logic from `shouldConstruct`)
	if typeOfType_ == "function" then
		if __DEV__ then
			resolvedType = resolveFunctionForHotReloading(resolvedType)
		end
	elseif typeOfType_ == "table" and not not type_.isReactComponent then
		fiberTag = ClassComponent
		if __DEV__ then
			resolvedType = resolveClassForHotReloading(resolvedType)
		end
	elseif typeOfType_ == "string" then
		fiberTag = HostComponent
	else
		if type_ == REACT_FRAGMENT_TYPE then
			return createFiberFromFragment(pendingProps.children, mode, lanes, key)
		elseif type_ == REACT_DEBUG_TRACING_MODE_TYPE then
			fiberTag = Mode
			mode = bit32.bor(mode, DebugTracingMode)
		elseif type_ == REACT_STRICT_MODE_TYPE then
			fiberTag = Mode
			mode = bit32.bor(mode, StrictMode)
		elseif type_ == REACT_PROFILER_TYPE then
			return createFiberFromProfiler(pendingProps, mode, lanes, key)
		elseif type_ == REACT_SUSPENSE_TYPE then
			return createFiberFromSuspense(pendingProps, mode, lanes, key)
			-- elseif type_ == REACT_SUSPENSE_LIST_TYPE then
			-- 	return createFiberFromSuspenseList(pendingProps, mode, lanes, key)
		elseif type_ == REACT_OFFSCREEN_TYPE then
			return createFiberFromOffscreen(pendingProps, mode, lanes, key)
		elseif type_ == REACT_LEGACY_HIDDEN_TYPE then
			return createFiberFromLegacyHidden(pendingProps, mode, lanes, key)
			-- elseif type_ == REACT_SCOPE_TYPE then
			-- 	if enableScopeAPI then
			-- 		return createFiberFromScope(type_, pendingProps, mode, lanes, key)
			-- 	end
		else
			local shouldBreak = false
			local type_typeof
			if typeOfType_ == "table" then
				type_typeof = type_["$$typeof"]
				if type_typeof == REACT_PROVIDER_TYPE then
					fiberTag = ContextProvider
					shouldBreak = true
				elseif type_typeof == REACT_CONTEXT_TYPE then
					-- This is a consumer
					fiberTag = ContextConsumer
					shouldBreak = true
				elseif type_typeof == REACT_FORWARD_REF_TYPE then
					fiberTag = ForwardRef
					if __DEV__ then
						resolvedType = resolveForwardRefForHotReloading(resolvedType)
					end
					shouldBreak = true
				elseif type_typeof == REACT_MEMO_TYPE then
					fiberTag = MemoComponent
					shouldBreak = true
				elseif type_typeof == REACT_LAZY_TYPE then
					fiberTag = LazyComponent
					resolvedType = nil
					shouldBreak = true
					-- elseif type_typeof == REACT_FUNDAMENTAL_TYPE then
					-- 	if enableFundamentalAPI then
					-- 		return createFiberFromFundamental(
					-- 			type_,
					-- 			pendingProps,
					-- 			mode,
					-- 			lanes,
					-- 			key
					-- 		)
					-- 	end
				end
			end
			if not shouldBreak then
				local info = ""
				if __DEV__ then
					if
						type_ == nil
						or (typeOfType_ == "table" and #Object.keys(type_) == 0)
					then
						info ..= " You likely forgot to export your component from the file " .. "it's defined in, or you might have mixed up default and " .. "named imports."
					elseif type_ ~= nil and typeOfType_ == "table" then
						-- ROBLOX deviation: print the table/string in readable form to give a clue, if no other info was gathered
						info ..= "\n" .. inspect(type_)
					end
					local ownerName
					if owner then
						ownerName = getComponentName(owner.type)
					end
					if ownerName ~= nil and ownerName ~= "" then
						info ..= "\n\nCheck the render method of `" .. ownerName .. "`."
					elseif owner then
						-- ROBLOX deviation: print the raw table in readable
						-- form to give a clue, if no other info was gathered
						info ..= "\n" .. inspect(owner)
					end
				end

<<<<<<< HEAD
				-- ROBLOX deviation: make output logic consistent across ReactFiber, ElementValidator, Memo, Context, and Lazy
				local typeString
				if type_ == nil then
					typeString = "nil"
				elseif Array.isArray(type_) then
					typeString = "array"
				elseif typeOfType_ == "table" and type_typeof == REACT_ELEMENT_TYPE then
					typeString =
						string.format("<%s />", getComponentName(type_.type) or "Unknown")
					info =
						" Did you accidentally export a JSX literal or Element instead of a component?"
				else
					typeString = typeOfType_
				end

				invariant(
					false,
					"Element type is invalid: expected a string (for built-in "
						.. "components) or a class/function (for composite components) "
						.. "but got: %s.%s",
					typeString,
					info
				)
			end
		end
=======
      case REACT_STRICT_MODE_TYPE:
        fiberTag = Mode;
        mode |= StrictLegacyMode;

        if (enableStrictEffects && (mode & ConcurrentMode) !== NoMode) {
          // Strict effects should never run on legacy roots
          mode |= StrictEffectsMode;
        }

        break;

      case REACT_PROFILER_TYPE:
        return createFiberFromProfiler(pendingProps, mode, lanes, key);

      case REACT_SUSPENSE_TYPE:
        return createFiberFromSuspense(pendingProps, mode, lanes, key);

      case REACT_SUSPENSE_LIST_TYPE:
        return createFiberFromSuspenseList(pendingProps, mode, lanes, key);

      case REACT_OFFSCREEN_TYPE:
        return createFiberFromOffscreen(pendingProps, mode, lanes, key);

      case REACT_LEGACY_HIDDEN_TYPE:
        if (enableLegacyHidden) {
          return createFiberFromLegacyHidden(pendingProps, mode, lanes, key);
        }

      // eslint-disable-next-line no-fallthrough

      case REACT_SCOPE_TYPE:
        if (enableScopeAPI) {
          return createFiberFromScope(type, pendingProps, mode, lanes, key);
        }

      // eslint-disable-next-line no-fallthrough

      case REACT_CACHE_TYPE:
        if (enableCache) {
          return createFiberFromCache(pendingProps, mode, lanes, key);
        }

      // eslint-disable-next-line no-fallthrough

      case REACT_TRACING_MARKER_TYPE:
        if (enableTransitionTracing) {
          return createFiberFromTracingMarker(pendingProps, mode, lanes, key);
        }

      // eslint-disable-next-line no-fallthrough

      case REACT_DEBUG_TRACING_MODE_TYPE:
        if (enableDebugTracing) {
          fiberTag = Mode;
          mode |= DebugTracingMode;
          break;
        }

      // eslint-disable-next-line no-fallthrough

      default:
        {
          if (typeof type === 'object' && type !== null) {
            switch (type.$$typeof) {
              case REACT_PROVIDER_TYPE:
                fiberTag = ContextProvider;
                break getTag;

              case REACT_CONTEXT_TYPE:
                // This is a consumer
                fiberTag = ContextConsumer;
                break getTag;

              case REACT_FORWARD_REF_TYPE:
                fiberTag = ForwardRef;

                if (__DEV__) {
                  resolvedType = resolveForwardRefForHotReloading(resolvedType);
                }

                break getTag;

              case REACT_MEMO_TYPE:
                fiberTag = MemoComponent;
                break getTag;

              case REACT_LAZY_TYPE:
                fiberTag = LazyComponent;
                resolvedType = null;
                break getTag;
            }
          }

          let info = '';

          if (__DEV__) {
            if (type === undefined || typeof type === 'object' && type !== null && Object.keys(type).length === 0) {
              info += ' You likely forgot to export your component from the file ' + "it's defined in, or you might have mixed up default and " + 'named imports.';
            }

            const ownerName = owner ? getComponentNameFromFiber(owner) : null;

            if (ownerName) {
              info += '\n\nCheck the render method of `' + ownerName + '`.';
            }
          }

          throw new Error('Element type is invalid: expected a string (for built-in ' + 'components) or a class/function (for composite components) ' + `but got: ${type == null ? type : typeof type}.${info}`);
        }
    } ]]
>>>>>>> upstream-apply
	end

	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber =
		createFiber(fiberTag, pendingProps, key, mode, type_, resolvedType, nil, lanes)

	-- fiber.elementType = type_
	-- fiber.type = resolvedType
	-- fiber.lanes = lanes
	-- ROBLOX deviation END

	if __DEV__ then
		fiber._debugOwner = owner
	end

	return fiber
end

local function createFiberFromElement(
	element: ReactElement,
	mode: TypeOfMode,
	lanes: Lanes
): Fiber
	local owner = nil
	if __DEV__ then
		owner = element._owner
	end
	local type = element.type
	local key = element.key
	local pendingProps = element.props
	local fiber = createFiberFromTypeAndProps(
		type,
		-- ROBLOX FIXME: according to upstream types, key can only be string?, but RoactStableKey deviation also says number
		key :: string,
		pendingProps,
		owner,
		mode,
		lanes
	)
	if __DEV__ then
		fiber._debugSource = element._source
		fiber._debugOwner = element._owner
	end
	return fiber
end

function createFiberFromFragment(
	elements: ReactFragment,
	mode: TypeOfMode,
	lanes: Lanes,
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(Fragment, elements, key, mode, nil, nil, nil, lanes)
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
	return fiber
end
<<<<<<< HEAD

function createFiberFromFundamental(
	fundamentalComponent: ReactFundamentalComponent<any, any>,
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(
		FundamentalComponent,
		pendingProps,
		key,
		mode,
		fundamentalComponent,
		fundamentalComponent,
		nil,
		lanes
	)
	-- fiber.elementType = fundamentalComponent
	-- fiber.type = fundamentalComponent
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
	return fiber
end

function createFiberFromScope(
=======
exports.createFiberFromFragment = createFiberFromFragment
local function createFiberFromScope(
>>>>>>> upstream-apply
	scope: ReactScope,
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber =
		createFiber(ScopeComponent, pendingProps, key, mode, scope, scope, nil, lanes)
	-- fiber.type = scope
	-- fiber.elementType = scope
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
	return fiber
end

function createFiberFromProfiler(
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
	key: string?
): Fiber
	if __DEV__ then
		if typeof(pendingProps.id) ~= "string" then
			console.error(
				'Profiler must specify an "id" of type `string` as a prop. Received the type `%s` instead.',
				typeof(pendingProps.id)
			)
		end
	end

	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(
		Profiler,
		pendingProps,
		key,
<<<<<<< HEAD
		bit32.bor(mode, ProfileMode),
		REACT_PROFILER_TYPE,
		REACT_PROFILER_TYPE,
		if enableProfilerTimer
			then {
				effectDuration = 0,
				passiveEffectDuration = 0,
			}
			else nil,
		lanes
	)
	-- TODO: The Profiler fiber shouldn't have a type. It has a tag.
	-- fiber.elementType = REACT_PROFILER_TYPE
	-- fiber.type = REACT_PROFILER_TYPE
	-- fiber.lanes = lanes
	-- ROBLOX deviation END

	-- if enableProfilerTimer then
	-- 	fiber.stateNode = {
	-- 		effectDuration = 0,
	-- 		passiveEffectDuration = 0,
	-- 	}
	-- end

=======
		bit32.bor(mode, ProfileMode) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
	)
	fiber.elementType = REACT_PROFILER_TYPE
	fiber.lanes = lanes
	if Boolean.toJSBoolean(enableProfilerTimer) then
		fiber.stateNode = { effectDuration = 0, passiveEffectDuration = 0 }
	end
>>>>>>> upstream-apply
	return fiber
end

function createFiberFromSuspense(
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
<<<<<<< HEAD
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(
		SuspenseComponent,
		pendingProps,
		key,
		mode,
		REACT_SUSPENSE_TYPE,
		REACT_SUSPENSE_TYPE,
		nil,
		lanes
	)

	-- TODO: The SuspenseComponent fiber shouldn't have a type. It has a tag.
	-- This needs to be fixed in getComponentName so that it relies on the tag
	-- instead.
	-- fiber.type = REACT_SUSPENSE_TYPE
	-- fiber.elementType = REACT_SUSPENSE_TYPE

	-- fiber.lanes = lanes
	-- ROBLOX deviation END
=======
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string
)
	local fiber = createFiber(SuspenseComponent, pendingProps, key, mode)
	fiber.elementType = REACT_SUSPENSE_TYPE
	fiber.lanes = lanes
>>>>>>> upstream-apply
	return fiber
end

function createFiberFromSuspenseList(
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
<<<<<<< HEAD
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(
		SuspenseListComponent,
		pendingProps,
		key,
		mode,
		REACT_SUSPENSE_LIST_TYPE,
		if __DEV__ then REACT_SUSPENSE_LIST_TYPE else nil,
		nil,
		lanes
	)
	-- if __DEV__ then
	-- 	-- TODO: The SuspenseListComponent fiber shouldn't have a type. It has a tag.
	-- 	-- This needs to be fixed in getComponentName so that it relies on the tag
	-- 	-- instead.
	-- 	fiber.type = REACT_SUSPENSE_LIST_TYPE
	-- end
	-- fiber.elementType = REACT_SUSPENSE_LIST_TYPE
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
=======
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string
)
	local fiber = createFiber(SuspenseListComponent, pendingProps, key, mode)
	fiber.elementType = REACT_SUSPENSE_LIST_TYPE
	fiber.lanes = lanes
>>>>>>> upstream-apply
	return fiber
end

function createFiberFromOffscreen(
	pendingProps: OffscreenProps,
	mode: TypeOfMode,
	lanes: Lanes,
<<<<<<< HEAD
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(
		OffscreenComponent,
		pendingProps,
		key,
		mode,
		REACT_OFFSCREEN_TYPE,
		if __DEV__ then REACT_OFFSCREEN_TYPE else nil,
		nil,
		lanes
	)
	-- TODO: The OffscreenComponent fiber shouldn't have a type. It has a tag.
	-- This needs to be fixed in getComponentName so that it relies on the tag
	-- instead.
	-- if __DEV__ then
	-- 	fiber.type = REACT_OFFSCREEN_TYPE
	-- end
	-- fiber.elementType = REACT_OFFSCREEN_TYPE
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
=======
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string
)
	local fiber = createFiber(OffscreenComponent, pendingProps, key, mode)
	fiber.elementType = REACT_OFFSCREEN_TYPE
	fiber.lanes = lanes
	local primaryChildInstance: OffscreenInstance = { isHidden = false }
	fiber.stateNode = primaryChildInstance
>>>>>>> upstream-apply
	return fiber
end

function createFiberFromLegacyHidden(
	pendingProps: OffscreenProps,
	mode: TypeOfMode,
	lanes: Lanes,
<<<<<<< HEAD
	key: string?
): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(
		LegacyHiddenComponent,
		pendingProps,
		key,
		mode,
		REACT_LEGACY_HIDDEN_TYPE,
		if __DEV__ then REACT_LEGACY_HIDDEN_TYPE else nil,
		nil,
		lanes
	)
	-- TODO: The LegacyHidden fiber shouldn't have a type. It has a tag.
	-- This needs to be fixed in getComponentName so that it relies on the tag
	-- instead.
	-- if __DEV__ then
	-- 	fiber.type = REACT_LEGACY_HIDDEN_TYPE
	-- end
	-- fiber.elementType = REACT_LEGACY_HIDDEN_TYPE
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
	return fiber
end

=======
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string
)
	local fiber = createFiber(LegacyHiddenComponent, pendingProps, key, mode)
	fiber.elementType = REACT_LEGACY_HIDDEN_TYPE
	fiber.lanes = lanes
	return fiber
end
exports.createFiberFromLegacyHidden = createFiberFromLegacyHidden
local function createFiberFromCache(
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string
)
	local fiber = createFiber(CacheComponent, pendingProps, key, mode)
	fiber.elementType = REACT_CACHE_TYPE
	fiber.lanes = lanes
	return fiber
end
exports.createFiberFromCache = createFiberFromCache
local function createFiberFromTracingMarker(
	pendingProps: any,
	mode: TypeOfMode,
	lanes: Lanes,
	key: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | string
)
	local fiber = createFiber(TracingMarkerComponent, pendingProps, key, mode)
	fiber.elementType = REACT_TRACING_MARKER_TYPE
	fiber.lanes = lanes
	return fiber
end
exports.createFiberFromTracingMarker = createFiberFromTracingMarker
>>>>>>> upstream-apply
local function createFiberFromText(content: string, mode: TypeOfMode, lanes: Lanes): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(HostText, content, nil, mode, nil, nil, nil, lanes)
	-- fiber.lanes = lanes
	-- ROBLOX deviation END
	return fiber
end

local function createFiberFromHostInstanceForDeletion(): Fiber
<<<<<<< HEAD
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(HostComponent, nil, nil, NoMode, "DELETED", "DELETED")
	-- TODO: These should not need a type.
	-- fiber.elementType = "DELETED"
	-- fiber.type = "DELETED"
	-- ROBLOX deviation END
=======
	local fiber = createFiber(HostComponent, nil, nil, NoMode)
	fiber.elementType = "DELETED"
>>>>>>> upstream-apply
	return fiber
end

local function createFiberFromDehydratedFragment(dehydratedNode: SuspenseInstance): Fiber
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber =
		createFiber(DehydratedFragment, nil, nil, NoMode, nil, nil, dehydratedNode)
	-- fiber.stateNode = dehydratedNode
	-- ROBLOX deviation END
	return fiber
end

local function createFiberFromPortal(
	portal: ReactPortal,
	mode: TypeOfMode,
	lanes: Lanes
): Fiber
	local pendingProps = if portal.children ~= nil then portal.children else {}
	-- ROBLOX deviation START: we pass in all needed values so the table creation+field assignment is a one-shot
	local fiber = createFiber(HostPortal, pendingProps, portal.key, mode, nil, nil, {
		containerInfo = portal.containerInfo,
		pendingChildren = nil, -- Used by persistent updates
		implementation = portal.implementation,
	}, lanes)
	-- fiber.lanes = lanes
	-- fiber.stateNode = {
	-- 	containerInfo = portal.containerInfo,
	-- 	pendingChildren = nil, -- Used by persistent updates
	-- 	implementation = portal.implementation,
	-- }
	-- ROBLOX deviation END
	return fiber
end

-- Used for stashing WIP properties to replay failed work in DEV.
-- ROBLOX FIXME: `target: Fiber | nil` - Narrowing doesn't work even with nil check
local function assignFiberPropertiesInDEV(target: Fiber, source: Fiber): Fiber
	if target == nil then
		-- This Fiber's initial properties will always be overwritten.
		-- We only use a Fiber to ensure the same hidden class so DEV isn't slow.
		target = createFiber(IndeterminateComponent, nil, nil, NoMode)
	end

	-- This is intentionally written as a list of all properties.
	-- We tried to use Object.assign() instead but this is called in
	-- the hottest path, and Object.assign() was too slow:
	-- https://github.com/facebook/react/issues/12502
	-- This code is DEV-only so size is not a concern.

	target.tag = source.tag
	target.key = source.key
	target.elementType = source.elementType
	target.type = source.type
	target.stateNode = source.stateNode
	target.return_ = source.return_
	target.child = source.child
	target.sibling = source.sibling
	target.index = source.index
	target.ref = source.ref
	target.pendingProps = source.pendingProps
	target.memoizedProps = source.memoizedProps
	target.updateQueue = source.updateQueue
	target.memoizedState = source.memoizedState
	target.dependencies = source.dependencies
	target.mode = source.mode
	target.flags = source.flags
	target.subtreeFlags = source.subtreeFlags
	target.deletions = source.deletions
	target.lanes = source.lanes
	target.childLanes = source.childLanes
	target.alternate = source.alternate
	if enableProfilerTimer then
		target.actualDuration = source.actualDuration
		target.actualStartTime = source.actualStartTime
		target.selfBaseDuration = source.selfBaseDuration
		target.treeBaseDuration = source.treeBaseDuration
	end
	target._debugSource = source._debugSource
	target._debugOwner = source._debugOwner
	target._debugNeedsRemount = source._debugNeedsRemount
	target._debugHookTypes = source._debugHookTypes
	return target
end

-- deviation: more convenient to export entire interface at the end
return {
	isSimpleFunctionComponent = isSimpleFunctionComponent,
	resolveLazyComponentTag = resolveLazyComponentTag,
	createWorkInProgress = createWorkInProgress,
	resetWorkInProgress = resetWorkInProgress,
	createHostRootFiber = createHostRootFiber,
	createFiberFromTypeAndProps = createFiberFromTypeAndProps,
	createFiberFromElement = createFiberFromElement,
	createFiberFromFragment = createFiberFromFragment,
	createFiberFromFundamental = createFiberFromFundamental,
	createFiberFromSuspense = createFiberFromSuspense,
	createFiberFromSuspenseList = createFiberFromSuspenseList,
	createFiberFromOffscreen = createFiberFromOffscreen,
	createFiberFromLegacyHidden = createFiberFromLegacyHidden,
	createFiberFromText = createFiberFromText,
	createFiberFromHostInstanceForDeletion = createFiberFromHostInstanceForDeletion,
	createFiberFromDehydratedFragment = createFiberFromDehydratedFragment,
	createFiberFromPortal = createFiberFromPortal,
	assignFiberPropertiesInDEV = assignFiberPropertiesInDEV,
}
