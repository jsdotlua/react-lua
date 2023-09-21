--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/SidebarSelectedFiberInfo.js
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

type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local Fragment = React.Fragment
local useContext = React.useContext
local useEffect = React.useEffect
local useRef = React.useRef
local WhatChanged = require(script.Parent.WhatChanged).default
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext
local utilsModule = require(script.Parent.utils)
local formatDuration = utilsModule.formatDuration
local formatTime = utilsModule.formatTime
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext
-- import Button from '../Button';
-- import ButtonIcon from '../ButtonIcon';

-- local styles = require(script.Parent.SidebarSelectedFiberInfo.css)

export type Props = {}

local function SidebarSelectedFiberInfo(_: Props)
	local profilerStore = useContext(StoreContext):getProfilerStore()
	local profilerValue = useContext(ProfilerContext)
	local rootID = profilerValue.rootID
	local selectCommitIndex = profilerValue.selectCommitIndex
	local selectedCommitIndex = profilerValue.selectedCommitIndex
	local selectedFiberID = profilerValue.selectedFiberID
	local selectedFiberName = profilerValue.selectedFiberName
	local selectFiber = profilerValue.selectFiber
	local profilingCache = profilerStore:profilingCache()
	local selectedListItemRef = useRef(nil :: HTMLElement | nil)

	local commitIndices = profilingCache:getFiberCommits({
		fiberID = (selectedFiberID :: any) :: number,
		rootID = (rootID :: any) :: number,
	})

	-- local handleKeyDown = event => {
	--   switch (event.key) {
	--     case 'ArrowUp':
	--       if (selectedCommitIndex ~= nil) {
	--         local prevIndex = commitIndices.indexOf(selectedCommitIndex);
	--         local nextIndex =
	--           prevIndex > 0 ? prevIndex - 1 : commitIndices.length - 1;
	--         selectCommitIndex(commitIndices[nextIndex]);
	--       }
	--       event.preventDefault();
	--       break;
	--     case 'ArrowDown':
	--       if (selectedCommitIndex ~= nil) {
	--         local prevIndex = commitIndices.indexOf(selectedCommitIndex);
	--         local nextIndex =
	--           prevIndex < commitIndices.length - 1 ? prevIndex + 1 : 0;
	--         selectCommitIndex(commitIndices[nextIndex]);
	--       }
	--       event.preventDefault();
	--       break;
	--     default:
	--       break;
	--   }
	-- };

	useEffect(function()
		local selectedElement = selectedListItemRef.current
		if selectedElement ~= nil and type(selectedElement.scrollIntoView) == "function" then
			-- selectedElement.scrollIntoView({block: 'nearest', inline: 'nearest'});
		end
	end, { selectedCommitIndex })

	local listItems = {}

	for i, commitIndex in commitIndices do
		local commitData = profilerStore:getCommitData((rootID :: any) :: number, commitIndex)
		local duration = commitData.duration
		local timestamp = commitData.timestamp

		table.insert(
			listItems,
			React.createElement(Text, {
				key = tostring(commitIndex),
				ref = if selectedCommitIndex == commitIndex then selectedListItemRef else nil,
				text = `{formatTime(timestamp)}s for {formatDuration(duration)}ms`,
				onMouseDown = function()
					selectCommitIndex(commitIndex)
				end,
				frameProps = { LayoutOrder = i + 5 },
			})
			-- <button
			--   key={commitIndex}
			--   className={
			--     selectedCommitIndex == commitIndex
			--       ? styles.CurrentCommit
			--       : styles.Commit
			--   }
			--   onClick={}>
			--   {formatTime(timestamp)}s for {formatDuration(duration)}ms
			-- </button>,
		)
	end

	return React.createElement(
		Fragment,
		{},
		React.createElement(
			Div,
			{
				name = "toolbar",
				-- className = styles.Toolbar,
			},
			React.createElement(Text, {
				text = selectedFiberName or "Selected component",
			}),
			React.createElement(Text, {
				text = "Back to commit view",
				onMouseDown = function()
					selectFiber(nil, nil)
				end,
			})
		),
		React.createElement(
			Div,
			{
				name = "content",
				-- className = styles.Toolbar,
			},
			React.createElement(WhatChanged, {
				fiberID = (selectedFiberID :: any) :: number,
			}),
			#listItems > 0
				and React.createElement(
					Fragment,
					{},
					React.createElement(Text, {
						text = "Rendered at:",
						frameProps = { LayoutOrder = 2 },
					}),
					listItems
				),
			#listItems == 0
				and React.createElement(Text, {
					text = "Did not render during this profiling session.",
					frameProps = { LayoutOrder = 2 },
				})
		)
	)
end
exports.default = SidebarSelectedFiberInfo
exports.SidebarSelectedFiberInfo = SidebarSelectedFiberInfo

return exports
