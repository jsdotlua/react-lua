<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/16654436039dd8f16a63928e71081c7745872e8f/packages/react-reconciler/src/ReactFiberUnwindWork.new.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactFiberUnwindWork.new.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
<<<<<<< HEAD
]]

local ReactInternalTypes = require("./ReactInternalTypes")
type Fiber = ReactInternalTypes.Fiber
local ReactFiberLane = require("./ReactFiberLane")
type Lanes = ReactFiberLane.Lanes
local ReactFiberSuspenseComponent = require("./ReactFiberSuspenseComponent.new.lua")
type SuspenseState = ReactFiberSuspenseComponent.SuspenseState

local resetMutableSourceWorkInProgressVersions =
	require("./ReactMutableSource.new.lua").resetWorkInProgressVersions
local ReactWorkTags = require("./ReactWorkTags")
-- local {ReactFiberFlags.DidCapture, ReactFiberFlags.NoFlags, ReactFiberFlags.ShouldCapture} = require("./ReactFiberFlags")
local ReactFiberFlags = require("./ReactFiberFlags")
local ReactTypeOfMode = require("./ReactTypeOfMode")

local ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags
local enableSuspenseServerRenderer = ReactFeatureFlags.enableSuspenseServerRenderer
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer

local ReactFiberHostContext = require("./ReactFiberHostContext.new.lua")
local popHostContainer = ReactFiberHostContext.popHostContainer
local popHostContext = ReactFiberHostContext.popHostContext
local popSuspenseContext =
	require("./ReactFiberSuspenseContext.new.lua").popSuspenseContext
local resetHydrationState =
	require("./ReactFiberHydrationContext.new.lua").resetHydrationState
local ReactFiberContext = require("./ReactFiberContext.new.lua")
local isLegacyContextProvider = ReactFiberContext.isContextProvider
local popLegacyContext = ReactFiberContext.popContext
local popTopLevelLegacyContextObject = ReactFiberContext.popTopLevelContextObject
local popProvider = require("./ReactFiberNewContext.new.lua").popProvider
-- ROBLOX FIXME: this causes a circular require
local popRenderLanesRef
local popRenderLanes = function(...)
	if not popRenderLanesRef then
		popRenderLanesRef = require("./ReactFiberWorkLoop.new.lua").popRenderLanes
	end
	return popRenderLanesRef(...)
end
local transferActualDuration =
	require("./ReactProfilerTimer.new.lua").transferActualDuration

local invariant = require("@pkg/@jsdotlua/shared").invariant

local function unwindWork(workInProgress: Fiber, renderLanes: Lanes): Fiber?
	if workInProgress.tag == ReactWorkTags.ClassComponent then
		local Component = workInProgress.type
		if isLegacyContextProvider(Component) then
			popLegacyContext(workInProgress)
		end
		local flags = workInProgress.flags
		if bit32.band(flags, ReactFiberFlags.ShouldCapture) ~= 0 then
			workInProgress.flags = bit32.bor(
				bit32.band(flags, bit32.bnot(ReactFiberFlags.ShouldCapture)),
				ReactFiberFlags.DidCapture
			)
			if
				enableProfilerTimer
				and bit32.band(workInProgress.mode, ReactTypeOfMode.ProfileMode)
					~= ReactTypeOfMode.NoMode
			then
				transferActualDuration(workInProgress)
			end
			return workInProgress
		end
		return nil
	elseif workInProgress.tag == ReactWorkTags.HostRoot then
		popHostContainer(workInProgress)
		popTopLevelLegacyContextObject(workInProgress)
		resetMutableSourceWorkInProgressVersions()
		local flags = workInProgress.flags
		invariant(
			bit32.band(flags, ReactFiberFlags.DidCapture) == ReactFiberFlags.NoFlags,
			"The root failed to unmount after an error. This is likely a bug in "
				.. "React. Please file an issue."
		)
		workInProgress.flags = bit32.bor(
			bit32.band(flags, bit32.bnot(ReactFiberFlags.ShouldCapture)),
			ReactFiberFlags.DidCapture
		)
		return workInProgress
	elseif workInProgress.tag == ReactWorkTags.HostComponent then
		-- TODO: popHydrationState
		popHostContext(workInProgress)
		return nil
	elseif workInProgress.tag == ReactWorkTags.SuspenseComponent then
		popSuspenseContext(workInProgress)
		if enableSuspenseServerRenderer then
			local suspenseState = workInProgress.memoizedState
			if suspenseState ~= nil and suspenseState.dehydrated ~= nil then
				invariant(
					workInProgress.alternate ~= nil,
					"Threw in newly mounted dehydrated component. This is likely a bug in "
						.. "React. Please file an issue."
				)
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local exports = {}
local sharedReactTypesModule = require(Packages.shared.ReactTypes)
type ReactContext = sharedReactTypesModule.ReactContext
local reactInternalTypesModule = require(script.Parent.ReactInternalTypes)
type Fiber = reactInternalTypesModule.Fiber
type FiberRoot = reactInternalTypesModule.FiberRoot
local reactFiberLaneNewModule = require(script.Parent["ReactFiberLane.new"])
type Lanes = reactFiberLaneNewModule.Lanes
local reactFiberSuspenseComponentNewModule = require(script.Parent["ReactFiberSuspenseComponent.new"])
type SuspenseState = reactFiberSuspenseComponentNewModule.SuspenseState
local reactFiberCacheComponentNewModule = require(script.Parent["ReactFiberCacheComponent.new"])
type Cache = reactFiberCacheComponentNewModule.Cache
local resetMutableSourceWorkInProgressVersions =
	require(script.Parent["ReactMutableSource.new"]).resetWorkInProgressVersions
local reactWorkTagsModule = require(script.Parent.ReactWorkTags)
local ClassComponent = reactWorkTagsModule.ClassComponent
local HostRoot = reactWorkTagsModule.HostRoot
local HostComponent = reactWorkTagsModule.HostComponent
local HostPortal = reactWorkTagsModule.HostPortal
local ContextProvider = reactWorkTagsModule.ContextProvider
local SuspenseComponent = reactWorkTagsModule.SuspenseComponent
local SuspenseListComponent = reactWorkTagsModule.SuspenseListComponent
local OffscreenComponent = reactWorkTagsModule.OffscreenComponent
local LegacyHiddenComponent = reactWorkTagsModule.LegacyHiddenComponent
local CacheComponent = reactWorkTagsModule.CacheComponent
local reactFiberFlagsModule = require(script.Parent.ReactFiberFlags)
local DidCapture = reactFiberFlagsModule.DidCapture
local NoFlags = reactFiberFlagsModule.NoFlags
local ShouldCapture = reactFiberFlagsModule.ShouldCapture
local reactTypeOfModeModule = require(script.Parent.ReactTypeOfMode)
local NoMode = reactTypeOfModeModule.NoMode
local ProfileMode = reactTypeOfModeModule.ProfileMode
local sharedReactFeatureFlagsModule = require(Packages.shared.ReactFeatureFlags)
local enableProfilerTimer = sharedReactFeatureFlagsModule.enableProfilerTimer
local enableCache = sharedReactFeatureFlagsModule.enableCache
local reactFiberHostContextNewModule = require(script.Parent["ReactFiberHostContext.new"])
local popHostContainer = reactFiberHostContextNewModule.popHostContainer
local popHostContext = reactFiberHostContextNewModule.popHostContext
local popSuspenseContext = require(script.Parent["ReactFiberSuspenseContext.new"]).popSuspenseContext
local resetHydrationState = require(script.Parent["ReactFiberHydrationContext.new"]).resetHydrationState
local reactFiberContextNewModule = require(script.Parent["ReactFiberContext.new"])
local isLegacyContextProvider = reactFiberContextNewModule.isContextProvider
local popLegacyContext = reactFiberContextNewModule.popContext
local popTopLevelLegacyContextObject = reactFiberContextNewModule.popTopLevelContextObject
local popProvider = require(script.Parent["ReactFiberNewContext.new"]).popProvider
local popRenderLanes = require(script.Parent["ReactFiberWorkLoop.new"]).popRenderLanes
local popCacheProvider = require(script.Parent["ReactFiberCacheComponent.new"]).popCacheProvider
local transferActualDuration = require(script.Parent["ReactProfilerTimer.new"]).transferActualDuration
local popTreeContext = require(script.Parent["ReactFiberTreeContext.new"]).popTreeContext
local reactFiberTransitionNewModule = require(script.Parent["ReactFiberTransition.new"])
local popRootTransition = reactFiberTransitionNewModule.popRootTransition
local popTransition = reactFiberTransitionNewModule.popTransition
local function unwindWork(
	current: Fiber | nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]],
	workInProgress: Fiber,
	renderLanes: Lanes
)
	-- Note: This intentionally doesn't check if we're hydrating because comparing
	-- to the current tree provider fiber is just as fast and less error-prone.
	-- Ideally we would have a special version of the work loop only
	-- for hydration.
	popTreeContext(workInProgress)
	local condition_ = workInProgress.tag
	if condition_ == ClassComponent then
		do
			local Component = workInProgress.type
			if Boolean.toJSBoolean(isLegacyContextProvider(Component)) then
				popLegacyContext(workInProgress)
			end
			local flags = workInProgress.flags
			if
				Boolean.toJSBoolean(
					bit32.band(flags, ShouldCapture) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
				)
			then
				workInProgress.flags = bit32.bor(
					bit32.band(
						flags,
						bit32.bnot(ShouldCapture) --[[ ROBLOX CHECK: `bit32.bnot` clamps arguments and result to [0,2^32 - 1] ]]
					), --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
					DidCapture
				) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
				if
					Boolean.toJSBoolean(if Boolean.toJSBoolean(enableProfilerTimer)
						then bit32.band(workInProgress.mode, ProfileMode) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
							~= NoMode
						else enableProfilerTimer)
				then
					transferActualDuration(workInProgress)
				end
				return workInProgress
			end
			return nil
		end
	elseif condition_ == HostRoot then
		do
			local root: FiberRoot = workInProgress.stateNode
			if Boolean.toJSBoolean(enableCache) then
				local cache: Cache = workInProgress.memoizedState.cache
				popCacheProvider(workInProgress, cache)
			end
			popRootTransition(workInProgress, root, renderLanes)
			popHostContainer(workInProgress)
			popTopLevelLegacyContextObject(workInProgress)
			resetMutableSourceWorkInProgressVersions()
			local flags = workInProgress.flags
			if
				bit32.band(flags, ShouldCapture) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
					~= NoFlags
				and bit32.band(flags, DidCapture) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
					== NoFlags
			then
				-- There was an error during render that wasn't captured by a suspense
				-- boundary. Do a second pass on the root to unmount the children.
				workInProgress.flags = bit32.bor(
					bit32.band(
						flags,
						bit32.bnot(ShouldCapture) --[[ ROBLOX CHECK: `bit32.bnot` clamps arguments and result to [0,2^32 - 1] ]]
					), --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
					DidCapture
				) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
				return workInProgress
			end -- We unwound to the root without completing it. Exit.
			return nil
		end
	elseif condition_ == HostComponent then
		do
			-- TODO: popHydrationState
			popHostContext(workInProgress)
			return nil
		end
	elseif condition_ == SuspenseComponent then
		do
			popSuspenseContext(workInProgress)
			local suspenseState: nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]] | SuspenseState =
				workInProgress.memoizedState
			if suspenseState ~= nil and suspenseState.dehydrated ~= nil then
				if workInProgress.alternate == nil then
					error(
						Error.new(
							"Threw in newly mounted dehydrated component. This is likely a bug in "
								.. "React. Please file an issue."
						)
					)
				end
>>>>>>> upstream-apply
				resetHydrationState()
			end
		end
		local flags = workInProgress.flags
		if bit32.band(flags, ReactFiberFlags.ShouldCapture) ~= 0 then
			workInProgress.flags = bit32.bor(
				bit32.band(flags, bit32.bnot(ReactFiberFlags.ShouldCapture)),
				ReactFiberFlags.DidCapture
			)
			-- Captured a suspense effect. Re-render the boundary.
			if
				enableProfilerTimer
				and (
					bit32.band(workInProgress.mode, ReactTypeOfMode.ProfileMode)
					~= ReactTypeOfMode.NoMode
				)
			then
				transferActualDuration(workInProgress)
			end
			return workInProgress
		end
		return nil
	elseif workInProgress.tag == ReactWorkTags.SuspenseListComponent then
		popSuspenseContext(workInProgress)
		-- SuspenseList doesn't actually catch anything. It should've been
		-- caught by a nested boundary. If not, it should bubble through.
		return nil
	elseif workInProgress.tag == ReactWorkTags.HostPortal then
		popHostContainer(workInProgress)
		return nil
<<<<<<< HEAD
	elseif workInProgress.tag == ReactWorkTags.ContextProvider then
		popProvider(workInProgress)
=======
	elseif condition_ == ContextProvider then
		local context: ReactContext<any> = workInProgress.type._context
		popProvider(context, workInProgress)
>>>>>>> upstream-apply
		return nil
	elseif
		workInProgress.tag == ReactWorkTags.OffscreenComponent
		or workInProgress.tag == ReactWorkTags.LegacyHiddenComponent
	then
		popRenderLanes(workInProgress)
		popTransition(workInProgress, current)
		return nil
	elseif condition_ == CacheComponent then
		if Boolean.toJSBoolean(enableCache) then
			local cache: Cache = workInProgress.memoizedState.cache
			popCacheProvider(workInProgress, cache)
		end
		return nil
	else
		return nil
	end
end
<<<<<<< HEAD

function unwindInterruptedWork(interruptedWork: Fiber)
	if interruptedWork.tag == ReactWorkTags.ClassComponent then
		-- ROBLOX deviation: Lua doesn't support properties on functions
		local childContextTypes
		if typeof(interruptedWork.type) == "table" then
			childContextTypes = interruptedWork.type.childContextTypes
=======
local function unwindInterruptedWork(
	current: Fiber | nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]],
	interruptedWork: Fiber,
	renderLanes: Lanes
)
	-- Note: This intentionally doesn't check if we're hydrating because comparing
	-- to the current tree provider fiber is just as fast and less error-prone.
	-- Ideally we would have a special version of the work loop only
	-- for hydration.
	popTreeContext(interruptedWork)
	repeat --[[ ROBLOX comment: switch statement conversion ]]
		local condition_ = interruptedWork.tag
		if condition_ == ClassComponent then
			do
				local childContextTypes = interruptedWork.type.childContextTypes
				if childContextTypes ~= nil and childContextTypes ~= nil then
					popLegacyContext(interruptedWork)
				end
				break
			end
		elseif condition_ == HostRoot then
			do
				local root: FiberRoot = interruptedWork.stateNode
				if Boolean.toJSBoolean(enableCache) then
					local cache: Cache = interruptedWork.memoizedState.cache
					popCacheProvider(interruptedWork, cache)
				end
				popRootTransition(interruptedWork, root, renderLanes)
				popHostContainer(interruptedWork)
				popTopLevelLegacyContextObject(interruptedWork)
				resetMutableSourceWorkInProgressVersions()
				break
			end
		elseif condition_ == HostComponent then
			do
				popHostContext(interruptedWork)
				break
			end
		elseif condition_ == HostPortal then
			popHostContainer(interruptedWork)
			break
		elseif condition_ == SuspenseComponent then
			popSuspenseContext(interruptedWork)
			break
		elseif condition_ == SuspenseListComponent then
			popSuspenseContext(interruptedWork)
			break
		elseif condition_ == ContextProvider then
			local context: ReactContext<any> = interruptedWork.type._context
			popProvider(context, interruptedWork)
			break
		elseif condition_ == OffscreenComponent or condition_ == LegacyHiddenComponent then
			popRenderLanes(interruptedWork)
			popTransition(interruptedWork, current)
			break
		elseif condition_ == CacheComponent then
			if Boolean.toJSBoolean(enableCache) then
				local cache: Cache = interruptedWork.memoizedState.cache
				popCacheProvider(interruptedWork, cache)
			end
			break
		else
			break
>>>>>>> upstream-apply
		end
		if childContextTypes ~= nil then
			popLegacyContext(interruptedWork)
		end
	elseif interruptedWork.tag == ReactWorkTags.HostRoot then
		popHostContainer(interruptedWork)
		popTopLevelLegacyContextObject(interruptedWork)
		resetMutableSourceWorkInProgressVersions()
	elseif interruptedWork.tag == ReactWorkTags.HostComponent then
		popHostContext(interruptedWork)
	elseif interruptedWork.tag == ReactWorkTags.HostPortal then
		popHostContainer(interruptedWork)
	elseif interruptedWork.tag == ReactWorkTags.SuspenseComponent then
		popSuspenseContext(interruptedWork)
	elseif interruptedWork.tag == ReactWorkTags.SuspenseListComponent then
		popSuspenseContext(interruptedWork)
	elseif interruptedWork.tag == ReactWorkTags.ContextProvider then
		popProvider(interruptedWork)
	elseif
		interruptedWork.tag == ReactWorkTags.OffscreenComponent
		or interruptedWork.tag == ReactWorkTags.LegacyHiddenComponent
	then
		popRenderLanes(interruptedWork)
		return
	else -- default
		return
	end
end

return {
	unwindWork = unwindWork,
	unwindInterruptedWork = unwindInterruptedWork,
}
