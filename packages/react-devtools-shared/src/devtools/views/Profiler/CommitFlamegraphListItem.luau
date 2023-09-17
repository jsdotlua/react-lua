--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/CommitFlamegraphListItem.js
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
local Fragment = React.Fragment
local memo = React.memo
local useCallback = React.useCallback
local useContext = React.useContext

--  import {areEqual} from 'react-window';
--  import {barWidthThreshold} from './constants';
--  import {getGradientColor} from './utils';
local ChartNode = require(script.Parent.ChartNode)
--  import {SettingsContext} from '../Settings/SettingsContext';

local FlamegraphChartBuilder = require(script.Parent.FlamegraphChartBuilder)
type ChartNodeType = FlamegraphChartBuilder.ChartNode
type ChartData = FlamegraphChartBuilder.ChartData
--  import type {ItemData} from './CommitFlamegraph';

-- deviation: define ItemData type here to avoid cyclic requires
-- import type {TooltipFiberData} from './HoveredFiberInfo';
type TooltipFiberData = any
export type ItemData = {
	chartData: ChartData,
	onElementMouseEnter: (fiberData: TooltipFiberData) -> (),
	onElementMouseLeave: () -> (),
	scaleX: (value: number, fallbackValue: number) -> number,
	selectedChartNode: ChartNodeType | nil,
	selectedChartNodeIndex: number,
	selectFiber: (id: number | nil, name: string | nil) -> (),
	width: number,
}

type Props = {
	data: ItemData,
	index: number,
	style: Object,
}

local function CommitFlamegraphListItem(props: Props)
	local data = props.data
	local index = props.index
	local style = props.style

	local chartData = data.chartData
	local onElementMouseEnter = data.onElementMouseEnter
	local onElementMouseLeave = data.onElementMouseLeave
	local scaleX = data.scaleX
	local selectedChartNode = data.selectedChartNode
	local selectedChartNodeIndex = data.selectedChartNodeIndex
	local selectFiber = data.selectFiber
	local width = data.width

	local renderPathNodes = chartData.renderPathNodes
	local maxSelfDuration = chartData.maxSelfDuration
	local rows = chartData.rows

	-- todo: implement SettingsContext
	local lineHeight = 10 -- useContext(SettingsContext).lineHeight;

	local handleClick = useCallback(function(event, id: number, name: string)
		-- event.stopPropagation()
		selectFiber(id, name)
	end, { selectFiber })

	local function handleMouseEnter(nodeData: ChartNodeType)
		local id = nodeData.id
		local name = nodeData.name
		onElementMouseEnter({ id = id, name = name })
	end

	local function handleMouseLeave()
		onElementMouseLeave()
	end

	-- List items are absolutely positioned using the CSS "top" attribute.
	-- The "left" value will always be 0.
	-- Since height is fixed, and width is based on the node's duration,
	-- We can ignore those values as well.
	-- local top = parseInt(style.top, 10)

	local row = rows[index]

	local selectedNodeOffset = scaleX(if selectedChartNode ~= nil then selectedChartNode.offset else 0, width)

	return React.createElement(
		Fragment,
		nil,
		Array.map(row, function(chartNode)
			local didRender = chartNode.didRender
			local id = chartNode.id
			local label = chartNode.label
			local name = chartNode.name
			local offset = chartNode.offset
			local selfDuration = chartNode.selfDuration
			local treeBaseDuration = chartNode.treeBaseDuration

			local nodeOffset = scaleX(offset, width)
			local nodeWidth = scaleX(treeBaseDuration, width)

			-- Filter out nodes that are too small to see or click.
			-- This also helps render large trees faster.
			if nodeWidth < barWidthThreshold then
				return nil
			end

			-- Filter out nodes that are outside of the horizontal window.
			if nodeOffset + nodeWidth < selectedNodeOffset or nodeOffset > selectedNodeOffset + width then
				return nil
			end

			local color = "url(#didNotRenderPattern)"
			local textColor = "var(--color-commit-did-not-render-pattern-text)"
			if didRender then
				color = getGradientColor(selfDuration / maxSelfDuration)
				textColor = "var(--color-commit-gradient-text)"
			elseif renderPathNodes:has(id) then
				color = "var(--color-commit-did-not-render-fill)"
				textColor = "var(--color-commit-did-not-render-fill-text)"
			end

			return React.createElement(ChartNode, {
				color = color,
				height = lineHeight,
				isDimmed = index < selectedChartNodeIndex,
				key = id,
				label = label,
				onClick = function(event)
					handleClick(event, id, name)
				end,
				onMouseEnter = function()
					handleMouseEnter(chartNode)
				end,
				onMouseLeave = handleMouseLeave,
				--   textStyle={color: textColor},
				width = nodeWidth,
				x = nodeOffset - selectedNodeOffset,
				y = top,
			})
		end)
	)
end

-- todo: implement areEqual to use memo
-- exports.default = memo(CommitFlamegraphListItem, areEqual)
exports.default = CommitFlamegraphListItem
exports.CommitFlamegraphListItem = exports.default

return exports
