--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/SnapshotCommitList.js
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
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
--  import AutoSizer from 'react-virtualized-auto-sizer';
-- import {FixedSizeList} from 'react-window';
local SnapshotCommitListItemModule = require(script.Parent.SnapshotCommitListItem)
local SnapshotCommitListItem = SnapshotCommitListItemModule.default
local minBarWidth = require(script.Parent.constants).minBarWidth

-- import styles from './SnapshotCommitList.css';

-- deviation: ItemData moved to avoid cyclic requires
export type ItemData = SnapshotCommitListItemModule.ItemData
export type DragState = SnapshotCommitListItemModule.DragState

type Props = {
	commitDurations: Array<number>,
	commitTimes: Array<number>,
	filteredCommitIndices: Array<number>,
	selectedCommitIndex: number | nil,
	selectedFilteredCommitIndex: number | nil,
	selectCommitIndex: (index: number) -> (),
}

-- deviation: pre-declare functions
local List

local function SnapshotCommitList(props: Props)
	local commitDurations = props.commitDurations
	local commitTimes = props.commitTimes
	local filteredCommitIndices = props.filteredCommitIndices
	local selectedCommitIndex = props.selectedCommitIndex
	local selectedFilteredCommitIndex = props.selectedFilteredCommitIndex
	local selectCommitIndex = props.selectCommitIndex

	return React.createElement(List, {
		commitDurations = commitDurations,
		commitTimes = commitTimes,
		-- height = height,
		filteredCommitIndices = filteredCommitIndices,
		selectedCommitIndex = selectedCommitIndex,
		selectedFilteredCommitIndex = selectedFilteredCommitIndex,
		selectCommitIndex = selectCommitIndex,
		-- width = width,
	})
	--   return (
	--     <AutoSizer>
	--       {({height, width}) => (
	--         <List
	--           commitDurations={commitDurations}
	--           commitTimes={commitTimes}
	--           height={height}
	--           filteredCommitIndices={filteredCommitIndices}
	--           selectedCommitIndex={selectedCommitIndex}
	--           selectedFilteredCommitIndex={selectedFilteredCommitIndex}
	--           selectCommitIndex={selectCommitIndex}
	--           width={width}
	--         />
	--       )}
	--     </AutoSizer>
	--   );
end
exports.SnapshotCommitList = SnapshotCommitList
exports.default = SnapshotCommitList

type ListProps = {
	commitDurations: Array<number>,
	commitTimes: Array<number>,
	-- height: number,
	filteredCommitIndices: Array<number>,
	selectedCommitIndex: number | nil,
	selectedFilteredCommitIndex: number | nil,
	selectCommitIndex: (index: number) -> (),
	-- width: number,
}

function List(props: ListProps)
	local commitDurations = props.commitDurations
	local selectedCommitIndex = props.selectedCommitIndex
	local commitTimes = props.commitTimes
	-- local height = props.height
	local filteredCommitIndices = props.filteredCommitIndices
	local selectedFilteredCommitIndex = props.selectedFilteredCommitIndex
	local selectCommitIndex = props.selectCommitIndex
	-- local width = props.width

	local listRef = useRef(nil :: FixedSizeList<ItemData> | null)
	local divRef = useRef(nil :: HTMLDivElement | nil)
	local prevCommitIndexRef = useRef(nil :: number | nil)

	-- Make sure a newly selected snapshot is fully visible within the list.
	useEffect(function()
		if selectedFilteredCommitIndex ~= prevCommitIndexRef.current then
			prevCommitIndexRef.current = selectedFilteredCommitIndex
			if selectedFilteredCommitIndex ~= nil and listRef.current ~= nil then
				listRef.current.scrollToItem(selectedFilteredCommitIndex)
			end
		end
	end, { listRef :: any, selectedFilteredCommitIndex })

	-- local itemSize = useMemo(function()
	-- 	return math.max(minBarWidth, width / #filteredCommitIndices)
	-- end, { filteredCommitIndices :: any, width })
	local maxDuration = useMemo(function()
		return Array.reduce(commitDurations, function(max, duration)
			return math.max(max, duration)
		end, 0)
	end, { commitDurations })

	-- deviation: use array length because of 1-indexing
	local maxCommitIndex = #filteredCommitIndices

	local dragState, setDragState = useState(nil :: DragState | nil)

	local function handleDragCommit(dragInfo: any)
		local buttons = dragInfo.buttons
		local pageX = dragInfo.pageX
		if buttons == 0 then
			setDragState(nil)
			return
		end

		if dragState ~= nil then
			local commitIndex = dragState.commitIndex
			local left = dragState.left
			local sizeIncrement = dragState.sizeIncrement

			local newCommitIndex = commitIndex
			local newCommitLeft = left

			if pageX < newCommitLeft then
				while pageX < newCommitLeft do
					newCommitLeft -= sizeIncrement
					newCommitIndex -= 1
				end
			else
				local newCommitRectRight = newCommitLeft + sizeIncrement
				while pageX > newCommitRectRight do
					newCommitRectRight += sizeIncrement
					newCommitIndex += 1
				end
			end

			-- todo: adjust indexes for 1-indexing
			if newCommitIndex < 0 then
				newCommitIndex = 0
			elseif newCommitIndex > maxCommitIndex then
				newCommitIndex = maxCommitIndex
			end

			selectCommitIndex(newCommitIndex)
		end
	end

	useEffect(function()
		if dragState == nil then
			return
		end

		local element = divRef.current
		if element ~= nil then
			local ownerDocument = element.ownerDocument
			ownerDocument.addEventListener("mousemove", handleDragCommit)
			return function()
				ownerDocument.removeEventListener("mousemove", handleDragCommit)
			end
		end
	end, { dragState })

	-- Pass required contextual data down to the ListItem renderer.
	local itemData = useMemo(function(): ItemData
		return {
			commitDurations = commitDurations,
			commitTimes = commitTimes,
			filteredCommitIndices = filteredCommitIndices,
			maxDuration = maxDuration,
			selectedCommitIndex = selectedCommitIndex,
			selectedFilteredCommitIndex = selectedFilteredCommitIndex,
			selectCommitIndex = selectCommitIndex,
			startCommitDrag = setDragState :: any,
		}
	end, {
		commitDurations :: any,
		commitTimes,
		filteredCommitIndices,
		maxDuration,
		selectedCommitIndex,
		selectedFilteredCommitIndex,
		selectCommitIndex,
	})

	local items = {}
	for i = 1, #filteredCommitIndices do
		items[i] = React.createElement(SnapshotCommitListItem, {
			key = tostring(i),
			data = itemData,
			index = i,
		})
	end
	return React.createElement(Div, {
		direction = Enum.FillDirection.Horizontal,
		layoutProps = {
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		},
	}, items)
	--   return (
	--     <div ref={divRef} style={{height, width}}>
	--       <FixedSizeList
	--         className=styles.List,
	--         layout="horizontal",
	--         height=height,
	--         itemCount=#filteredCommitIndices,
	--         itemData=itemData,
	--         itemSize=itemSize,
	--         ref={(listRef: any) /* Flow bug? */}
	--         width=width,
	--         {SnapshotCommitListItem}
	--       </FixedSizeList>
	--     </div>
	--   );
end

return exports
