--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/WhatChanged.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent.Parent.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local useContext = React.useContext
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext

-- import styles from './WhatChanged.css';

type Props = {
	fiberID: number,
}

local function WhatChanged(props: Props): React.ReactElement<any>?
	local fiberID = props.fiberID
	local profilerStore = useContext(StoreContext):getProfilerStore()
	local profilerContext = useContext(ProfilerContext)
	local rootID = profilerContext.rootID
	local selectedCommitIndex = profilerContext.selectedCommitIndex

	-- TRICKY
	-- Handle edge case where no commit is selected because of a min-duration filter update.
	-- If the commit index is null, suspending for data below would throw an error.
	-- TODO (ProfilerContext) This check should not be necessary.
	if selectedCommitIndex == nil then
		return nil
	end

	local commitData = profilerStore:getCommitData((rootID :: any) :: number, selectedCommitIndex)
	local changeDescriptions = commitData.changeDescriptions

	if changeDescriptions == nil then
		return nil
	end

	local changeDescription = changeDescriptions:get(fiberID)
	if changeDescription == nil then
		return nil
	end

	if changeDescription.isFirstMount then
		return React.createElement(
			Div,
			{
				name = "what-changed",
				frameProps = {
					AutomaticSize = Enum.AutomaticSize.Y,
				},
			},
			React.createElement(Text, {
				expand = false,
				text = "Why did this render?",
				fontSize = 16,
				order = 1,
			}),
			React.createElement(Text, {
				expand = false,
				text = "This is the first time the component rendered.",
				order = 2,
			})
		)
	end

	local changes = {}

	if changeDescription.context == true then
		table.insert(
			changes,
			React.createElement(
				Div,
				{
					key = "context",
					name = "context-changed",
					frameProps = {
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
				React.createElement(Text, {
					order = 1,
					expand = false,
					fontSize = 14,
					text = "• Context changed:",
				})
			)
		)
	elseif
		type(changeDescription.context) == "table"
		and changeDescription.context ~= nil
		and #changeDescription.context ~= 0
	then
		table.insert(
			changes,
			React.createElement(
				Div,
				{
					key = "context",
					name = "context-changed",
					frameProps = {
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
				React.createElement(Text, {
					order = 1,
					expand = false,
					fontSize = 14,
					text = "• Context changed:",
				}),
				Array.map(changeDescription.context, function(key, index): any
					return React.createElement(Text, {
						order = 1 + index,
						key = key,
						expand = false,
						text = key,
					})
				end)
			)
		)
	end

	if changeDescription.didHooksChange then
		table.insert(
			changes,
			React.createElement(
				Div,
				{
					key = "hooks",
					name = "hooks-changed",
					frameProps = {
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
				React.createElement(Text, {
					order = 1,
					expand = false,
					fontSize = 14,
					text = "• Hooks changed:",
				})
			)
		)
	end

	if changeDescription.props ~= nil and #changeDescription.props ~= 0 then
		table.insert(
			changes,
			React.createElement(
				Div,
				{
					key = "props",
					name = "props-changed",
					frameProps = {
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
				React.createElement(Text, {
					order = 1,
					expand = false,
					fontSize = 14,
					text = "• Props changed:",
				}),
				Array.map(changeDescription.props, function(key, index): any
					return React.createElement(Text, {
						order = 1 + index,
						key = key,
						expand = false,
						text = key,
					})
				end)
			)
		)
	end

	if changeDescription.state ~= nil and #changeDescription.state ~= 0 then
		table.insert(
			changes,
			React.createElement(
				Div,
				{
					key = "state",
					name = "state-changed",
					frameProps = {
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
				React.createElement(Text, {
					order = 1,
					expand = false,
					fontSize = 14,
					text = "• State changed:",
				}),
				Array.map(changeDescription.state, function(key, index): any
					return React.createElement(Text, {
						order = 1 + index,
						key = key,
						expand = false,
						text = key,
					})
				end)
			)
		)
	end

	if #changes == 0 then
		table.insert(
			changes,
			React.createElement(
				Div,
				{
					key = "nothing",
					name = "nothing",
					frameProps = {
						AutomaticSize = Enum.AutomaticSize.Y,
					},
				},
				React.createElement(Text, {
					order = 1,
					expand = false,
					fontSize = 14,
					text = "The parent component rendered.",
				})
			)
		)
	end

	return React.createElement(
		Div,
		{
			name = "what-changed",
			frameProps = {
				AutomaticSize = Enum.AutomaticSize.Y,
			},
		},
		React.createElement(Text, {
			expand = false,
			text = "Why did this render?",
		}),
		changes
	)
end
exports.WhatChanged = WhatChanged
exports.default = WhatChanged

return exports
