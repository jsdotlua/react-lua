--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/Profiler.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]
local Packages = script.Parent.Parent.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local Fragment = React.Fragment
local useContext = React.useContext
-- local ModalDialog = require(script.Parent.Parent.ModalDialog).ModalDialog
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext
local TabBarModule = require(script.Parent.Parent.TabBar)
local TabBar = TabBarModule.TabBar
type TabInfo = TabBarModule.TabInfo
-- local ClearProfilingDataButton = require(script.Parent.ClearProfilingDataButton).default
local CommitFlamegraph = require(script.Parent.CommitFlamegraph).default
-- local CommitRanked = require(script.Parent.CommitRanked).default
-- local Interactions = require(script.Parent.Interactions).default
-- local RootSelector = require(script.Parent.RootSelector).default
local RecordToggle = require(script.Parent.RecordToggle).default
-- local ReloadAndProfileButton = require(script.Parent.ReloadAndProfileButton).default
-- local ProfilingImportExportButtons = require(script.Parent.ProfilingImportExportButtons).default
local SnapshotSelector = require(script.Parent.SnapshotSelector).default
local SidebarCommitInfo = require(script.Parent.SidebarCommitInfo).default
-- local SidebarInteractions = require(script.Parent.SidebarInteractions).default
local SidebarSelectedFiberInfo = require(script.Parent.SidebarSelectedFiberInfo).default

-- local SettingsModal = require(script.Parent.Parent.Settings.SettingsModal).default
local SettingsModalContextToggle = require(script.Parent.Parent.Settings.SettingsModalContextToggle).default
-- local SettingsModalContextModule = require(script.Parent.Parent.Settings.SettingsModalContext)
-- local SettingsModalContextController = SettingsModalContextModule.SettingsModalContextController
local portaledContent = require(script.Parent.Parent.portaledContent).default
local Store = require(script.Parent.Parent.Parent.store)
type Store = Store.Store

-- local styles = require(script.Parent.Profiler)

-- deviation: pre-declaration
local RecordingInProgress
local ProcessingData
local NoProfilingData
local ProfilingNotSupported
local tabs: Array<TabInfo>

local BAR_HEIGHT = 40

local function TodoView(props: { name: string })
	return React.createElement(
		Div,
		{},
		React.createElement(Text, {
			text = string.format("Todo: implement view `%s`", props.name),
		})
	)
end

local function Profiler(_: {})
	local profilerStore = useContext(ProfilerContext)
	local didRecordCommits = profilerStore.didRecordCommits
	local isProcessingData = profilerStore.isProcessingData
	local isProfiling = profilerStore.isProfiling
	local selectedCommitIndex = profilerStore.selectedCommitIndex
	local selectedFiberID = profilerStore.selectedFiberID
	local selectedTabID = profilerStore.selectedTabID
	local selectTab = profilerStore.selectTab
	local supportsProfiling = profilerStore.supportsProfiling

	local view: React.ReactElement<any> = nil
	if didRecordCommits then
		if selectedTabID == "flame-chart" then
			view = React.createElement(CommitFlamegraph)
		elseif selectedTabID == "ranked-chart" then
			view = React.createElement(TodoView, { name = "CommitRanked" })
			-- view = React.createElement(CommitRanked)
		elseif selectedTabID == "interactions" then
			view = React.createElement(TodoView, { name = "interactions" })
			-- view = React.createElement(Interactions)
		end
	elseif isProfiling then
		view = React.createElement(RecordingInProgress)
	elseif isProcessingData then
		view = React.createElement(TodoView, { name = "ProcessingData" })
		-- view = React.createElement(ProcessingData)
	elseif supportsProfiling then
		view = React.createElement(NoProfilingData)
	else
		view = React.createElement(ProfilingNotSupported)
	end

	local sidebar = nil
	if not isProfiling and not isProcessingData and didRecordCommits then
		if selectedTabID == "interactions" then
			-- sidebar = React.createElement(SidebarInteractions)
			-- todo
			view = React.createElement(TodoView, { name = "SidebarInteractions" })
		elseif selectedTabID == "flame-chart" or selectedTabID == "ranked-chart" then
			-- TRICKY
			-- Handle edge case where no commit is selected because of a min-duration filter update.
			-- In that case, the selected commit index would be null.
			-- We could still show a sidebar for the previously selected fiber,
			-- but it would be an odd user experience.
			-- TODO (ProfilerContext) This check should not be necessary.
			if selectedCommitIndex ~= nil then
				if selectedFiberID ~= nil then
					sidebar = React.createElement(SidebarSelectedFiberInfo)
				else
					sidebar = React.createElement(SidebarCommitInfo)
				end
			end
		end
	end

	local leftFraction = 0.7

	-- deviation: use Roblox view objects
	-- return React.createElement(
	-- 	SettingsModalContextController,
	-- 	nil,
	return React.createElement(
		"Frame",
		{
			Name = "container",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		},
		React.createElement(
			Div,
			{
				name = "columns",
				-- className=styles.Profiler
				direction = Enum.FillDirection.Horizontal,
			},
			React.createElement(
				Div,
				{
					name = "left-column",
					-- className=styles.LeftColumn
					frameProps = {
						Size = UDim2.fromScale(leftFraction, 1),
					},
				},
				React.createElement(
					"Frame",
					{
						Name = "toolbar-container",
						-- className=styles.Toolbar
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
					},
					React.createElement("UITableLayout", {
						Name = "table-layout",
						FillEmptySpaceColumns = true,
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),
					React.createElement(
						"Frame",
						{
							Name = "row",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
						},
						-- React.createElement(RecordToggle, {
						-- 	disabled = not supportsProfiling,
						-- }),
						-- React.createElement(ReloadAndProfileButton),
						-- React.createElement(ClearProfilingDataButton),
						-- React.createElement(ProfilingImportExportButtons),
						-- React.createElement(Div, {
						-- 	-- className = styles.VRule
						-- }),
						React.createElement(TabBar, {
							currentTab = selectedTabID,
							id = "Profiler",
							selectTab = selectTab,
							tabs = tabs,
							type = "profiler",
						}),
						-- React.createElement(RootSelector)
						-- React.createElement(Div, {
						-- 	-- className = styles.Space
						-- })
						React.createElement(SettingsModalContextToggle),
						-- didRecordCommits
						-- 	and React.createElement(
						-- 		Fragment,
						-- 		nil,
						-- 		React.createElement(Div, {
						-- 			-- className = styles.VRule
						-- 		}),
						React.createElement(SnapshotSelector)
						-- 	)
					)
				),
				React.createElement(
					Div,
					{
						name = "content",
						-- className = styles.Content,
						frameProps = {
							Size = UDim2.new(1, 0, 1, -BAR_HEIGHT),
						},
					},
					view
					-- React.createElement(ModalDialog)
				)
			),
			React.createElement(Div, {
				name = "right-column",
				-- className=styles.RightColumn
				frameProps = {
					Position = UDim2.fromScale(leftFraction, 0),
					Size = UDim2.fromScale(1 - leftFraction, 1),
					LayoutOrder = 2,
				},
			}, sidebar)
		)
		-- deviation: move SettingsModal up
		-- React.createElement(SettingsModal)
	)
	-- )
end

tabs = {
	{
		id = "flame-chart",
		icon = "flame-chart",
		label = "Flamegraph",
		title = "Flamegraph chart",
	},
	-- {
	-- 	id = "ranked-chart",
	-- 	icon = "ranked-chart",
	-- 	label = "Ranked",
	-- 	title = "Ranked chart",
	-- },
	-- {
	-- 	id = "interactions",
	-- 	icon = "interactions",
	-- 	label = "Interactions",
	-- 	title = "Profiled interactions",
	-- },
}

function NoProfilingData()
	-- deviation: use Roblox view objects
	return React.createElement(
		Div,
		{
			xAlignment = Enum.HorizontalAlignment.Center,
		},
		React.createElement(Text, {
			text = "No profiling data has been recorded.",
			expand = false,
		}),
		React.createElement(
			Div,
			{
				-- direction = Enum.FillDirection.Vertical,
			},
			React.createElement(Text, {
				text = "Click the record button",
				expand = false,
			}),
			-- todo record button
			React.createElement(RecordToggle),
			React.createElement(Text, {
				text = "to start recording.",
				expand = false,
			})
		)
	)
end

function ProfilingNotSupported()
	return React.createElement(
		Div,
		{},
		React.createElement(Text, {
			text = "Profiling not supported.",
			frameProps = { Size = UDim2.fromOffset(0, 50) },
		}),
		React.createElement(Text, {
			text = "Profiling support requires either a development or production-profiling build of React v16.5+.",
			expand = false,
			frameProps = { Size = UDim2.fromOffset(0, 0) },
		})
	)
	--   <p className={styles.Paragraph}>
	--     Learn more at{' '}
	--     <a
	--       className={styles.Link}
	--       href="https://reactjs.org/link/profiling"
	--       rel="noopener noreferrer"
	--       target="_blank">
	--       reactjs.org/link/profiling
	--     </a>
	--     .
	--   </p>
end

--   function ProcessingData ()
--     <div className={styles.Column}>
--       <div className={styles.Header}>Processing data...</div>
--       <div className={styles.Row}>This should only take a minute.</div>
--     </div>
--   end

function RecordingInProgress()
	-- deviation: use Roblox view objects
	return React.createElement(
		Div,
		{
			xAlignment = Enum.HorizontalAlignment.Center,
		},
		React.createElement(Text, {
			text = "Profiling is in progress...",
			expand = false,
		}),
		React.createElement(
			Div,
			{
				-- direction = Enum.FillDirection.Vertical,
			},
			React.createElement(Text, {
				text = "Click the record button",
				expand = false,
			}),
			-- todo record button
			React.createElement(RecordToggle),
			React.createElement(Text, {
				text = "to stop recording.",
				expand = false,
			})
		)
	)
end

local function onErrorRetry(store: Store)
	-- If an error happened in the Profiler,
	-- we should clear data on retry (or it will just happen again).
	store:getProfilerStore().profilingData = nil
end

exports.default = portaledContent(Profiler, onErrorRetry)

return exports
