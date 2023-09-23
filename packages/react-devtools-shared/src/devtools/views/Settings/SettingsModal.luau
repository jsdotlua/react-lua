--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Settings/SettingsModal.js
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

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local useCallback = React.useCallback
local useContext = React.useContext
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef

local SettingsModalContext = require(script.Parent.SettingsModalContext).SettingsModalContext
--  import Button from '../Button';
--  import ButtonIcon from '../ButtonIcon';
local TabBarModule = require(script.Parent.Parent.TabBar)
local TabBar = TabBarModule.TabBar
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext
local hooksModule = require(script.Parent.Parent.hooks)
local useLocalStorage = hooksModule.useLocalStorage
local useModalDismissSignal = hooksModule.useModalDismissSignal
local useSubscription = hooksModule.useSubscription
--  local ComponentsSettings =require(script.Parent.ComponentsSettings).default
--  local DebuggingSettings =require(script.Parent.DebuggingSettings).default
--  local GeneralSettings =require(script.Parent.GeneralSettings).default
local ProfilerSettings = require(script.Parent.ProfilerSettings).default

--  import styles from './SettingsModal.css';

type TabID = "general" | "components" | "profiler"

-- deviation: pre-declaration
local SettingsModalImpl

local function SettingsModal(_: {}): React.ReactElement?
	local settingsModal = useContext(SettingsModalContext)
	local isModalShowing = settingsModal.isModalShowing
	local setIsModalShowing = settingsModal.setIsModalShowing
	local store = useContext(StoreContext)
	local profilerStore = store:getProfilerStore()

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
	local isProfiling: boolean = useSubscription(isProfilingSubscription)

	-- deviation: wrap side effect in useEffect
	useEffect(function()
		if isProfiling and isModalShowing then
			setIsModalShowing(false)
		end
	end, { isProfiling, isModalShowing })

	if not isModalShowing then
		return nil
	end

	return React.createElement(SettingsModalImpl)
end
exports.SettingsModal = SettingsModal
exports.default = SettingsModal

local BAR_HEIGHT = 40

-- pre-declaration
local tabs: Array<TabBarModule.TabInfo>

function SettingsModalImpl(_: {})
	local settingsModal = useContext(SettingsModalContext)
	local setIsModalShowing = settingsModal.setIsModalShowing
	local dismissModal = useCallback(function()
		return setIsModalShowing(false)
	end, {
		setIsModalShowing,
	})

	local selectedTabID, selectTab = useLocalStorage(
		"React::DevTools::selectedSettingsTabID",
		-- deviation: default to profiler instead of "general" :: TabID
		"profiler" :: TabID
	)

	-- local modalRef = useRef(nil :: HTMLDivElement | nil)
	-- useModalDismissSignal(modalRef, dismissModal)

	-- useEffect(function()
	-- 	if modalRef.current ~= nil then
	-- 		modalRef.current.focus()
	-- 	end
	-- end, { modalRef })

	local view = nil
	if selectedTabID == "components" then
		-- view = React.createElement(ComponentsSettings)
	elseif selectedTabID == "debugging" then
		-- view = React.createElement(DebuggingSettings)
	elseif selectedTabID == "general" then
		-- view = React.createElement(GeneralSettings)
	elseif selectedTabID == "profiler" then
		view = React.createElement(ProfilerSettings)
	end

	return React.createElement(
		Div,
		{
			name = "settings-modal",
			direction = Enum.FillDirection.Vertical,
			frameProps = {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0, 0, 0),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 100,
			},
		},
		React.createElement(
			Div,
			{
				name = "settings-toolbar",
				direction = Enum.FillDirection.Horizontal,
				onClick = function()
					dismissModal()
				end,
				frameProps = {
					Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
				},
			},
			React.createElement(TabBar, {
				currentTab = selectedTabID,
				id = "Settings",
				selectTab = selectTab,
				tabs = tabs,
				-- type="settings",
			}),
			React.createElement(Text, {
				order = 10,
				text = "Close",
				onMouseDown = dismissModal,
			})
		),
		React.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, -BAR_HEIGHT),
		}, view)
	)
end

tabs = {
	{
		id = "general",
		-- icon = "settings",
		label = "General",
	},
	{
		id = "debugging",
		-- icon = "bug",
		label = "Debugging",
	},
	{
		id = "components",
		-- icon = "components",
		label = "Components",
	},
	{
		id = "profiler",
		-- icon = "profiler",
		label = "Profiler",
	},
}

return exports
