--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/SnapshotCommitListItem.js
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
type Object = LuauPolyfill.Object

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)
local memo = React.memo

-- import {areEqual} from 'react-window';
local utils = require(script.Parent.utils)
local getGradientColor = utils.getGradientColor
local formatDuration = utils.formatDuration
local formatTime = utils.formatTime

-- import styles from './SnapshotCommitListItem.css';

-- deviation: define DragState and ItemData here to avoid cyclic requires
export type DragState = {
	commitIndex: number,
	left: number,
	sizeIncrement: number,
}
export type ItemData = {
	commitDurations: Array<number>,
	commitTimes: Array<number>,
	filteredCommitIndices: Array<number>,
	maxDuration: number,
	selectedCommitIndex: number | nil,
	selectedFilteredCommitIndex: number | nil,
	selectCommitIndex: (index: number) -> (),
	startCommitDrag: (newDragState: DragState) -> (),
}

type Props = {
	data: ItemData,
	index: number,
	-- style: Object,
	-- ...
}

local function SnapshotCommitListItem(props: Props)
	local itemData = props.data
	local index = props.index
	-- local style = props.style

	local commitDurations = itemData.commitDurations
	local commitTimes = itemData.commitTimes
	local filteredCommitIndices = itemData.filteredCommitIndices
	local maxDuration = itemData.maxDuration
	local selectedCommitIndex = itemData.selectedCommitIndex
	local selectCommitIndex = itemData.selectCommitIndex
	local startCommitDrag = itemData.startCommitDrag

	index = filteredCommitIndices[index]

	local commitDuration = commitDurations[index]
	local commitTime = commitTimes[index]

	-- Guard against commits with duration 0
	-- deviation: guard against maxDuration with if
	local percentage = math.min(1, math.max(0, if maxDuration == 0 then 0 else commitDuration / maxDuration))
	local isSelected = selectedCommitIndex == index

	-- Leave a 1px gap between snapshots
	--   local width = parseFloat(style.width) - 1;

	local function handleMouseDown(event)
		-- local buttons = event.buttons
		-- local target = event.target
		-- if buttons == 1 then
		selectCommitIndex(index)
		-- startCommitDrag({
		-- 	commitIndex = index,
		-- 	left = target.getBoundingClientRect().left,
		-- 	sizeIncrement = parseFloat(style.width),
		-- })
		-- end
	end

	local mouseInside, setMouseInside = React.useState(false)

	local function handleMouseEnter(_)
		setMouseInside(true)
	end

	local function handleMouseLeave(_)
		setMouseInside(false)
	end

	return React.createElement(
		"TextButton",
		{
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1 / #filteredCommitIndices, 0, 1, 0),
			LayoutOrder = index,
			Text = "",
			[ReactRoblox.Event.Activated] = handleMouseDown,
			[ReactRoblox.Event.MouseEnter] = handleMouseEnter,
			[ReactRoblox.Event.MouseLeave] = handleMouseLeave,
		},
		React.createElement("Frame", {
			Active = false,
			BorderMode = Enum.BorderMode.Inset,
			BorderSizePixel = if isSelected then 2 elseif mouseInside then 1 else 0,
			BorderColor3 = Color3.new(0, 0, 0),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = if isSelected or mouseInside then 0 else 0.4,
			BackgroundColor3 = if percentage > 0 then getGradientColor(percentage) else Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, percentage, 0),
		})
	)
	--   return (
	--     <div
	--       className={styles.Outer}
	--       onMouseDown={handleMouseDown}
	--       style={{
	--         ...style,
	--         width,
	--         borderBottom: isSelected
	--           ? '3px solid var(--color-tab-selected-border)'
	--           : undefined,
	--       }}
	--       title={`Duration ${formatDuration(commitDuration)}ms at ${formatTime(
	--         commitTime,
	--       )}s`}>
	--       <div
	--         className={styles.Inner}
	--         style={{
	--           height: `${Math.round(percentage * 100)}%`,
	--           backgroundColor:
	--             percentage > 0 ? getGradientColor(percentage) : undefined,
	--         }}
	--       />
	--     </div>
	--   );
end

-- todo:
-- exports.default = memo(SnapshotCommitListItem, areEqual);
exports.default = SnapshotCommitListItem
exports.SnapshotCommitListItem = exports.default

return exports
