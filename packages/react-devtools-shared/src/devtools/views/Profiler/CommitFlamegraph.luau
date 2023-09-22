--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/CommitFlamegraph.js
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
local Map = LuauPolyfill.Map
local console = LuauPolyfill.console

type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local exports = {}

local React = require(Packages.React)
local forwardRef = React.forwardRef
local useCallback = React.useCallback
local useContext = React.useContext
local useMemo = React.useMemo
local useState = React.useState

-- import AutoSizer from 'react-virtualized-auto-sizer';
-- import {FixedSizeList} from 'react-window';
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext
local NoCommitData = require(script.Parent.NoCommitData).default
local CommitFlamegraphListItemModule = require(script.Parent.CommitFlamegraphListItem)
local CommitFlamegraphListItem = CommitFlamegraphListItemModule.default
-- local HoveredFiberInfo = require(script.Parent.HoveredFiberInfo).default
local scale = require(script.Parent.utils).scale
-- import {useHighlightNativeElement} from '../hooks';
local StoreContext = require(script.Parent.Parent.context).StoreContext
-- import {SettingsContext} from '../Settings/SettingsContext';
-- local Tooltip = require(script.Parent.Tooltip)

-- local styles = require(script.Parent.CommitFlamegraph.css)

-- import type {TooltipFiberData} from './HoveredFiberInfo';
type TooltipFiberData = any
local FlamegraphChartBuilder = require(script.Parent.FlamegraphChartBuilder)
type ChartData = FlamegraphChartBuilder.ChartData
type ChartNode = FlamegraphChartBuilder.ChartNode
local types = require(script.Parent.types)
type CommitTree = types.CommitTree

-- deviation: avoid cyclic import and require move ItemData type from CommitFlamegraphListItem
export type ItemData = CommitFlamegraphListItemModule.ItemData

-- deviation: pre-declaration
local CommitFlamegraph

local function CommitFlamegraphAutoSizer(_: {}): React.ReactElement<any>
	local profilerStore = useContext(StoreContext):getProfilerStore()
	local profilerValue = useContext(ProfilerContext)
	local rootID = profilerValue.rootID
	local selectedCommitIndex = profilerValue.selectedCommitIndex
	local selectFiber = profilerValue.selectFiber

	local profilingCache = profilerStore:profilingCache()

	local deselectCurrentFiber = useCallback(function(event)
		--   event.stopPropagation();
		selectFiber(nil, nil)
	end, { selectFiber })

	-- print("selectedCommitIndex", selectedCommitIndex)
	-- print("profilingCache", profilingCache)

	local commitTree: CommitTree | nil = nil
	local chartData: ChartData | nil = nil
	if selectedCommitIndex ~= nil then
		commitTree = profilingCache:getCommitTree({
			commitIndex = selectedCommitIndex,
			rootID = (rootID :: any) :: number,
		})

		-- print("commitTree", commitTree)

		chartData = profilingCache:getFlamegraphChartData({
			commitIndex = selectedCommitIndex,
			commitTree = commitTree,
			rootID = (rootID :: any) :: number,
		})
		-- print("chartData", chartData)
	end

	if commitTree ~= nil and chartData ~= nil and chartData.depth > 0 then
		return React.createElement(
			Div,
			{
				name = "flamegraph-container",
				-- className={styles.Container}
				-- onClick={deselectCurrentFiber}
			},
			React.createElement(CommitFlamegraph, {
				chartData = (chartData :: any) :: ChartData,
				commitTree = (commitTree :: any) :: CommitTree,
			})
			-- React.createElement(AutoSizer, {}, function(info)
			-- 	local height = info.height
			-- 	local width = info.width
			-- 	-- Force Flow types to avoid checking for `null` here because there's no static proof that
			-- 	-- by the time this render prop function is called, the values of the `let` variables have not changed.
			-- 	return React.createElement(CommitFlamegraph, {
			-- 		chartData = (chartData :: any) :: ChartData,
			-- 		commitTree = (commitTree :: any) :: CommitTree,
			-- 		height = height,
			-- 		width = width,
			-- 	})
			-- end)
		)
	else
		return React.createElement(NoCommitData)
	end
end
exports.CommitFlamegraphAutoSizer = CommitFlamegraphAutoSizer
exports.default = CommitFlamegraphAutoSizer

type Props = {
	chartData: ChartData,
	commitTree: CommitTree,
	-- height: number,
	-- width: number,
}

function CommitFlamegraph(props: Props)
	local chartData = props.chartData
	-- local commitTree = props.commitTree
	-- local height = props.height
	-- local width = props.width
	local hoveredFiberData, setHoveredFiberData = useState(nil :: TooltipFiberData | nil)
	--   local {lineHeight} = useContext(SettingsContext);
	-- todo: implement SettingsContext
	local lineHeight = 10
	local profilerValue = useContext(ProfilerContext)

	local selectFiber = profilerValue.selectFiber
	local selectedFiberID = profilerValue.selectedFiberID
	-- local highlighter = useHighlightNativeElement()
	-- local highlightNativeElement = highlighter.highlightNativeElement
	-- local clearHighlightNativeElement = highlighter.clearHighlightNativeElement

	local selectedChartNodeIndex = useMemo(function()
		if selectedFiberID == nil then
			return 0
		end
		-- The selected node might not be in the tree for this commit,
		-- so it's important that we have a fallback plan.
		local depth = chartData.idToDepthMap:get(selectedFiberID)
		return if depth ~= nil then depth - 1 else 0
	end, { chartData :: any, selectedFiberID })

	local selectedChartNode = useMemo(function()
		if selectedFiberID ~= nil then
			return Array.find(chartData.rows[selectedChartNodeIndex], function(chartNode)
				return chartNode.id == selectedFiberID
			end) or nil
		end
		return nil
	end, { chartData :: any, selectedFiberID, selectedChartNodeIndex })

	local handleElementMouseEnter = useCallback(function(args)
		local id = args.id
		local name = args.name

		-- highlightNativeElement(id) -- Highlight last hovered element.
		setHoveredFiberData({ id, name }) -- Set hovered fiber data for tooltip
	end, { --[[ highlightNativeElement ]]
	})

	local handleElementMouseLeave = useCallback(function()
		-- clearHighlightNativeElement() -- clear highlighting of element on mouse leave
		setHoveredFiberData(nil :: any) -- clear hovered fiber data for tooltip
	end, { --[[clearHighlightNativeElement]]
	})

	local itemData: ItemData = useMemo(function()
		return {
			chartData = chartData,
			onElementMouseEnter = handleElementMouseEnter,
			onElementMouseLeave = handleElementMouseLeave,
			scaleX = scale(
				0,
				if selectedChartNode ~= nil then selectedChartNode.treeBaseDuration else chartData.baseDuration,
				0,
				1 -- width
			),
			selectedChartNode = selectedChartNode,
			selectedChartNodeIndex = selectedChartNodeIndex,
			selectFiber = selectFiber,
			-- width = width,
		}
	end, {
		chartData :: any,
		handleElementMouseEnter,
		handleElementMouseLeave,
		selectedChartNode,
		selectedChartNodeIndex,
		selectFiber,
		-- width,
	})

	-- Tooltip used to show summary of fiber info on hover
	local tooltipLabel = useMemo(function()
		return if hoveredFiberData ~= nil
			-- todo: implement tooltip
			then nil -- React.createElement(HoveredFiberInfo, { fiberData = hoveredFiberData })
			else nil
	end, { hoveredFiberData })

	local items = {}
	for i = 1, chartData.depth do
		items[i] = React.createElement(CommitFlamegraphListItem, {
			key = tostring(i),
			data = itemData,
			index = i,
		})
	end

	-- print("chartData", chartData)
	return React.createElement(Div, {
		name = "commit-flamegraph",
		direction = Enum.FillDirection.Vertical,
		layoutProps = {
			VerticalAlignment = Enum.VerticalAlignment.Top,
		},
	}, items)
	-- return React.createElement(
	-- 	Tooltip,
	-- 	{
	-- 		label = tooltipLabel,
	-- 	},
	-- 	React.createElement(FixedSizeList, {
	-- 		height = height,
	-- 		innerElementType = InnerElementType,
	-- 		itemCount = chartData.depth,
	-- 		itemData = itemData,
	-- 		itemSize = lineHeight,
	-- 		width = width,
	-- 	}, CommitFlamegraphListItem)
	-- )
end

-- local InnerElementType = forwardRef(({children, ...rest}, ref) => (
--   <svg ref={ref} {...rest}>
--     <defs>
--       <pattern
--         id="didNotRenderPattern"
--         patternUnits="userSpaceOnUse"
--         width="4"
--         height="4">
--         <path
--           d="M-1,1 l2,-2 M0,4 l4,-4 M3,5 l2,-2"
--           className={styles.PatternPath}
--         />
--       </pattern>
--     </defs>
--     {children}
--   </svg>
-- ));

return exports
