--!strict
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

-- import styles from './NoCommitData.css';

local function NoCommitData(_: {})
	return React.createElement(
		Div,
		{},
		React.createElement(Text, {
			text = "There is no data matching the current filter criteria.",
			expand = false,
		}),
		React.createElement(Text, {
			text = "Try adjusting the commit filter in Profiler settings.",
			expand = false,
		})
	)
end
exports.NoCommitData = NoCommitData
exports.default = NoCommitData

return exports
