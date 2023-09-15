--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/ProfilerContext.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent.Parent.Parent.Parent.Parent
local exports = {}

local React = require(Packages.React)
local createContext = React.createContext
local useCallback = React.useCallback
local useContext = React.useContext
local useMemo = React.useMemo
local useState = React.useState

local ReactRoblox = require(Packages.ReactRoblox)
local batchedUpdates = ReactRoblox.unstable_batchedUpdates

local hooksModule = require(script.Parent.Parent.hooks)
local useLocalStorage = hooksModule.useLocalStorage
local useSubscription = hooksModule.useSubscription

local TreeContextModule = require(script.Parent.Parent.Components.TreeContext)
local TreeDispatcherContext = TreeContextModule.TreeDispatcherContext
local TreeStateContext = TreeContextModule.TreeStateContext

local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext

local types = require(script.Parent.types)
type ProfilingDataFrontend = types.ProfilingDataFrontend

export type TabID = "flame-chart" | "ranked-chart" | "interactions"

export type Context = {
	-- Which tab is selected in the Profiler UI?
	selectedTabID: TabID,
	selectTab: (id: TabID) -> (),

	-- Store subscription based values.
	-- The isProfiling value may be modified by the record button in the Profiler toolbar,
	-- or from the backend itself (after a reload-and-profile action).
	-- It is synced between the backend and frontend via a Store subscription.
	didRecordCommits: boolean,
	isProcessingData: boolean,
	isProfiling: boolean,
	profilingData: ProfilingDataFrontend | nil,
	startProfiling: () -> (),
	stopProfiling: () -> (),
	supportsProfiling: boolean,

	-- Which root should profiling data be shown for?
	-- This value should be initialized to either:
	-- 1. The selected root in the Components tree (if it has any profiling data) or
	-- 2. The first root in the list with profiling data.
	rootID: number | nil,
	setRootID: (id: number) -> (),

	-- Controls whether commits are filtered by duration.
	-- This value is controlled by a filter toggle UI in the Profiler toolbar.
	-- It impacts the commit selector UI as well as the fiber commits bar chart.
	isCommitFilterEnabled: boolean,
	setIsCommitFilterEnabled: (value: boolean) -> (),
	minCommitDuration: number,
	setMinCommitDuration: (value: number) -> (),

	-- Which commit is currently selected in the commit selector UI.
	-- Note that this is the index of the commit in all commits (non-filtered) that were profiled.
	-- This value is controlled by the commit selector UI in the Profiler toolbar.
	-- It impacts the flame graph and ranked charts.
	selectedCommitIndex: number | nil,
	selectCommitIndex: (value: number | nil) -> (),

	-- Which fiber is currently selected in the Ranked or Flamegraph charts?
	selectedFiberID: number | nil,
	selectedFiberName: string | nil,
	selectFiber: (id: number | nil, name: string | nil) -> (),

	-- Which interaction is currently selected in the Interactions graph?
	selectedInteractionID: number | nil,
	selectInteraction: (id: number | nil) -> (),
}

local ProfilerContext = createContext((nil :: any) :: Context)
ProfilerContext.displayName = "ProfilerContext"

type StoreProfilingState = {
	didRecordCommits: boolean,
	isProcessingData: boolean,
	isProfiling: boolean,
	profilingData: ProfilingDataFrontend | nil,
	supportsProfiling: boolean,
}

type Props = {
	children: React.ReactNode,
}

local function ProfilerContextController(props: Props)
	local children = props.children
	local store = useContext(StoreContext)
	local selectedElementID = useContext(TreeStateContext).selectedElementID
	local dispatch = useContext(TreeDispatcherContext)

	local profilerStore = store.profilerStore

	local subscription = useMemo(function()
		return {
			getCurrentValue = function()
				return {
					didRecordCommits = profilerStore.didRecordCommits,
					isProcessingData = profilerStore.isProcessingData,
					isProfiling = profilerStore.isProfiling,
					profilingData = profilerStore.profilingData,
					supportsProfiling = store.supportsProfiling,
				}
			end,
			subscribe = function(callback: Function)
				profilerStore:addListener("profilingData", callback)
				profilerStore:addListener("isProcessingData", callback)
				profilerStore:addListener("isProfiling", callback)
				store:addListener("supportsProfiling", callback)
				return function()
					profilerStore:removeListener("profilingData", callback)
					profilerStore:removeListener("isProcessingData", callback)
					profilerStore:removeListener("isProfiling", callback)
					store:removeListener("supportsProfiling", callback)
				end
			end,
		}
	end, { profilerStore, store })
	local subscriptionState = useSubscription(subscription) -- <StoreProfilingState>
	local didRecordCommits = subscriptionState.didRecordCommits
	local isProcessingData = subscriptionState.isProcessingData
	local isProfiling = subscriptionState.isProfiling
	local profilingData = subscriptionState.profilingData
	local supportsProfiling = subscriptionState.supportsProfiling

	local prevProfilingData, setPrevProfilingData = useState(nil :: ProfilingDataFrontend | nil)
	local rootID, setRootID = useState(nil :: number | nil)
	local selectedFiberID, selectFiberID = useState(nil :: number | nil)
	local selectedFiberName, selectFiberName = useState(nil :: string | nil)

	local selectFiber = useCallback(function(id: number | nil, name: string | nil)
		selectFiberID(id)
		selectFiberName(name)

		-- Sync selection to the Components tab for convenience.
		-- Keep in mind that profiling data may be from a previous session.
		-- If data has been imported, we should skip the selection sync.
		if id ~= nil and profilingData ~= nil and profilingData.imported == false then
			-- We should still check to see if this element is still in the store.
			-- It may have been removed during profiling.
			if store:containsElement(id) then
				dispatch({
					type = "SELECT_ELEMENT_BY_ID",
					payload = id,
				})
			end
		end
	end, { dispatch :: any, selectFiberID, selectFiberName, store, profilingData })

	local setRootIDAndClearFiber = useCallback(function(id: number | nil)
		selectFiber(nil, nil)
		setRootID(id)
	end, { setRootID :: any, selectFiber })

	if prevProfilingData ~= profilingData then
		batchedUpdates(function()
			setPrevProfilingData(profilingData)

			local dataForRoots = if profilingData ~= nil then profilingData.dataForRoots else nil
			if dataForRoots ~= nil then
				local firstRootID = dataForRoots:keys()[1].value or nil

				if rootID == nil or not dataForRoots:has(rootID) then
					local selectedElementRootID = nil
					if selectedElementID ~= nil then
						selectedElementRootID = store:getRootIDForElement(selectedElementID)
					end
					if selectedElementRootID ~= nil and dataForRoots:has(selectedElementRootID) then
						setRootIDAndClearFiber(selectedElementRootID)
					else
						setRootIDAndClearFiber(firstRootID)
					end
				end
			end
		end)
	end

	local startProfiling = useCallback(function()
		return store.profilerStore:startProfiling()
	end, { store })
	local stopProfiling = useCallback(function()
		return store.profilerStore:stopProfiling()
	end, { store })

	local isCommitFilterEnabled, setIsCommitFilterEnabled =
		useLocalStorage("React::DevTools::isCommitFilterEnabled", false)

	local minCommitDuration, setMinCommitDuration = useLocalStorage("minCommitDuration", 0)

	local selectedCommitIndex, selectCommitIndex = useState(nil :: number | nil)
	local selectedTabID, selectTab = useState("flame-chart" :: TabID)
	local selectedInteractionID, selectInteraction = useState(nil :: number | nil)

	if isProfiling then
		batchedUpdates(function()
			if selectedCommitIndex ~= nil then
				selectCommitIndex(nil)
			end
			if selectedFiberID ~= nil then
				selectFiberID(nil)
				selectFiberName(nil)
			end
			if selectedInteractionID ~= nil then
				selectInteraction(nil)
			end
		end)
	end

	local value = useMemo(function()
		return {
			selectedTabID = selectedTabID,
			selectTab = selectTab,

			didRecordCommits = didRecordCommits,
			isProcessingData = isProcessingData,
			isProfiling = isProfiling,
			profilingData = profilingData,
			startProfiling = startProfiling,
			stopProfiling = stopProfiling,
			supportsProfiling = supportsProfiling,

			rootID = rootID,
			setRootID = setRootIDAndClearFiber,

			isCommitFilterEnabled = isCommitFilterEnabled,
			setIsCommitFilterEnabled = setIsCommitFilterEnabled,
			minCommitDuration = minCommitDuration,
			setMinCommitDuration = setMinCommitDuration,

			selectedCommitIndex = selectedCommitIndex,
			selectCommitIndex = selectCommitIndex,

			selectedFiberID = selectedFiberID,
			selectedFiberName = selectedFiberName,
			selectFiber = selectFiber,

			selectedInteractionID = selectedInteractionID,
			selectInteraction = selectInteraction,
		}
	end, {
		selectedTabID :: any,
		selectTab,

		didRecordCommits,
		isProcessingData,
		isProfiling,
		profilingData,
		startProfiling,
		stopProfiling,
		supportsProfiling,

		rootID,
		setRootID,
		setRootIDAndClearFiber,

		isCommitFilterEnabled,
		setIsCommitFilterEnabled,
		minCommitDuration,
		setMinCommitDuration,

		selectedCommitIndex,
		selectCommitIndex,

		selectedFiberID,
		selectedFiberName,
		selectFiber,

		selectedInteractionID,
		selectInteraction,
	})

	return React.createElement(ProfilerContext.Provider, {
		value = value,
	}, children)
end

exports.ProfilerContext = ProfilerContext
exports.ProfilerContextController = ProfilerContextController

return exports
