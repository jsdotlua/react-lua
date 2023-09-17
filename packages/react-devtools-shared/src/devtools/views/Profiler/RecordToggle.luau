--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/RecordToggle.js
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
local useContext = React.useContext

--  local Button = require(script.Parent.Parent.Button);
--  local ButtonIcon = require(script.Parent.Parent.ButtonIcon);
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext

-- local styles = './RecordToggle.css';

export type Props = {
	disabled: boolean?,
}

local function RecordToggle(props: Props)
	local disabled = props.disabled
	local profilerValue = useContext(ProfilerContext)
	local isProfiling = profilerValue.isProfiling
	local startProfiling = profilerValue.startProfiling
	local stopProfiling = profilerValue.stopProfiling

	-- local className = styles.InactiveRecordToggle;
	-- if (disabled) {
	--   className = styles.DisabledRecordToggle;
	-- } else if (isProfiling) {
	--   className = styles.ActiveRecordToggle;
	-- }

	return React.createElement(Text, {
		text = if isProfiling then "Stop profiling" else "Start profiling",
		expand = false,
		onMouseDown = if props.disabled then nil else if isProfiling then stopProfiling else startProfiling,
	})
end

exports.RecordToggle = RecordToggle
exports.default = RecordToggle

return exports
