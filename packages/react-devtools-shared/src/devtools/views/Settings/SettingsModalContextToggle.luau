--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Settings/SettingsModalContext.js
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
type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local useCallback = React.useCallback
local useContext = React.useContext
local useMemo = React.useMemo
local SettingsModalContext = require(script.Parent.SettingsModalContext).SettingsModalContext
--  import Button from '../Button';
--  import ButtonIcon from '../ButtonIcon';
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext
local hooksModule = require(script.Parent.Parent.hooks)
local useSubscription = hooksModule.useSubscription

local function SettingsModalContextToggle(_: {})
	local settingsContextValue = useContext(SettingsModalContext)
	local setIsModalShowing = settingsContextValue.setIsModalShowing
	local store = useContext(StoreContext)
	local profilerStore = store:getProfilerStore()

	local showFilterModal = useCallback(function()
		setIsModalShowing(true)
	end, {
		setIsModalShowing,
	})

	-- Updating preferences while profiling is in progress could break things (e.g. filtering)
	-- Explicitly disallow it for now.
	local isProfilingSubscription = useMemo(function()
		return {
			getCurrentValue = function()
				return profilerStore:isProfiling()
			end,
			subscribe = function(callback: () -> ())
				profilerStore:addListener("isProfiling", callback)
				return function()
					profilerStore:removeListener("isProfiling", callback)
				end
			end,
		}
	end, { profilerStore })
	local isProfiling = useSubscription(isProfilingSubscription)

	return React.createElement(Text, {
		name = "settings-modal-toggle",
		disabled = isProfiling,
		onMouseDown = showFilterModal,
		text = "Settings",
	})
end

exports.SettingsModalContextToggle = SettingsModalContextToggle
exports.default = SettingsModalContextToggle
return exports
