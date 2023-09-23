--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/DevTools.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */
local Packages = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<K> = LuauPolyfill.Array<K>
local exports = {}

local React = require(Packages.React)
local useEffect = React.useEffect
local useLayoutEffect = React.useLayoutEffect
local useMemo = React.useMemo
local useRef = React.useRef

local Div = require(script.Parent.roblox.Div)
local Text = require(script.Parent.roblox.Text)

local Store = require(script.Parent.Parent.store)
type Store = Store.Store
local contextModule = require(script.Parent.context)
local BridgeContext = contextModule.BridgeContext
local ContextMenuContext = contextModule.ContextMenuContext
local StoreContext = contextModule.StoreContext
-- local Components from './Components/Components';
local Profiler = require(script.Parent.Profiler.Profiler).default
local TabBarModule = require(script.Parent.TabBar)
local TabBar = TabBarModule.TabBar

local SettingsModal = require(script.Parent.Settings.SettingsModal).default
local SettingsModalContextModule = require(script.Parent.Settings.SettingsModalContext)
local SettingsModalContextController = SettingsModalContextModule.SettingsModalContextController

local SettingsContextController = require(script.Parent.Settings.SettingsContext).SettingsContextController
local TreeContext = require(script.Parent.Components.TreeContext)
local TreeContextController = TreeContext.TreeContextController
-- local ViewElementSourceContext from './Components/ViewElementSourceContext';
local ProfilerContext = require(script.Parent.Profiler.ProfilerContext)
local ProfilerContextController = ProfilerContext.ProfilerContextController
-- local ModalDialogContextController = require(script.Parent.ModalDialog).ModalDialogContextController
-- local ReactLogo from './ReactLogo';
-- local UnsupportedVersionDialog from './UnsupportedVersionDialog';
-- local WarnIfLegacyBackendDetected from './WarnIfLegacyBackendDetected';
local hooksModule = require(script.Parent.hooks)
local useLocalStorage = hooksModule.useLocalStorage

-- import styles from './DevTools.css';

-- import './root.css';

-- import type {InspectedElement} from 'react-devtools-shared/src/devtools/views/Components/types';
type InspectedElement = any

local bridgeModule = require(script.Parent.Parent.Parent.bridge)
type FrontendBridge = bridgeModule.FrontendBridge

export type BrowserTheme = "dark" | "light"
export type TabID = "components" | "profiler"
export type ViewElementSource = (id: number, inspectedElement: InspectedElement) -> ()
export type ViewAttributeSource = (id: number, path: Array<string | number>) -> ()
export type CanViewElementSource = (inspectedElement: InspectedElement) -> boolean

export type Props = {
	bridge: FrontendBridge,
	browserTheme: BrowserTheme?,
	canViewElementSourceFunction: CanViewElementSource?,
	defaultTab: TabID?,
	enabledInspectedElementContextMenu: boolean?,
	showTabBar: boolean?,
	store: Store,
	warnIfLegacyBackendDetected: boolean?,
	warnIfUnsupportedVersionDetected: boolean?,
	viewAttributeSourceFunction: ViewAttributeSource?,
	viewElementSourceFunction: ViewElementSource?,

	-- This property is used only by the web extension target.
	-- The built-in tab UI is hidden in that case, in favor of the browser's own panel tabs.
	-- This is done to save space within the app.
	-- Because of this, the extension needs to be able to change which tab is active/rendered.
	overrideTab: TabID?,

	-- To avoid potential multi-root trickiness, the web extension uses portals to render tabs.
	-- The root <DevTools> app is rendered in the top-level extension window,
	-- but individual tabs (e.g. Components, Profiling) can be rendered into portals within their browser panels.
	componentsPortalContainer: Element?,
	profilerPortalContainer: Element?,
}

local componentsTab = {
	id = "components" :: TabID,
	-- icon = "components",
	label = "Components",
	title = "React Components",
} :: TabBarModule.TabInfo
local profilerTab = {
	id = "profiler" :: TabID,
	-- icon = "profiler",
	label = "Profiler",
	title = "React Profiler",
} :: TabBarModule.TabInfo

local tabs: Array<TabBarModule.TabInfo> = { componentsTab, profilerTab }

local BAR_HEIGHT = 40

local function DevTools(props: Props)
	local bridge = props.bridge
	local browserTheme = if props.browserTheme == nil then "light" else props.browserTheme
	local canViewElementSourceFunction = props.canViewElementSourceFunction
	local componentsPortalContainer = props.componentsPortalContainer
	local defaultTab = if props.defaultTab == nil then "components" else props.defaultTab
	local enabledInspectedElementContextMenu = if props.enabledInspectedElementContextMenu == nil
		then false
		else props.enabledInspectedElementContextMenu
	local overrideTab = props.overrideTab
	local profilerPortalContainer = props.profilerPortalContainer
	local showTabBar = if props.showTabBar == nil then false else props.showTabBar
	local store = props.store
	local warnIfLegacyBackendDetected = if props.warnIfLegacyBackendDetected == nil
		then false
		else props.warnIfLegacyBackendDetected
	local warnIfUnsupportedVersionDetected = if props.warnIfUnsupportedVersionDetected == nil
		then false
		else props.warnIfUnsupportedVersionDetected
	local viewAttributeSourceFunction = props.viewAttributeSourceFunction
	local viewElementSourceFunction = props.viewElementSourceFunction

	local currentTab, setTab = useLocalStorage("React::DevTools::defaultTab", defaultTab)

	local tab = currentTab

	if overrideTab ~= nil then
		tab = overrideTab
	end

	local viewElementSource = useMemo(function()
		return {
			canViewElementSourceFunction = canViewElementSourceFunction,
			viewElementSourceFunction = viewElementSourceFunction,
		}
	end, { canViewElementSourceFunction :: any, viewElementSourceFunction })

	local contextMenu = useMemo(function()
		return {
			isEnabledForInspectedElement = enabledInspectedElementContextMenu,
			viewAttributeSourceFunction = viewAttributeSourceFunction,
		}
	end, { enabledInspectedElementContextMenu :: any, viewAttributeSourceFunction })

	local devToolsRef = useRef(nil :: HTMLElement | nil)

	-- useEffect(function()
	-- 	if not showTabBar then
	-- 		return
	-- 	end

	-- 	local div = devToolsRef.current
	-- 	if div == nil then
	-- 		return
	-- 	end

	-- 	local ownerWindow = div.ownerDocument.defaultView
	-- 	local handleKeyDown = function(event: KeyboardEvent)
	-- 		if event.ctrlKey or event.metaKey then
	-- 			if event.key == "1" then
	-- 				setTab(tabs[0].id)
	-- 				event.preventDefault()
	-- 				event.stopPropagation()
	-- 			elseif event.key == "2" then
	-- 				setTab(tabs[1].id)
	-- 				event.preventDefault()
	-- 				event.stopPropagation()
	-- 			end
	-- 		end
	-- 	end

	-- 	ownerWindow:addEventListener("keydown", handleKeyDown)
	-- 	return function()
	-- 		ownerWindow:removeEventListener("keydown", handleKeyDown)
	-- 	end
	-- end, { showTabBar })

	useLayoutEffect(function()
		return function()
			local success, err = pcall(function()
				bridge:shutdown()
			end)
			if not success then
				-- Attempting to use a disconnected port.
				warn("Attempting to use a disconnected port: " .. tostring(err))
			end
		end
	end, { bridge })

	return React.createElement(
		BridgeContext.Provider,
		{ value = bridge },
		React.createElement(
			StoreContext.Provider,
			{ value = store },
			React.createElement(
				ContextMenuContext.Provider,
				{ value = contextMenu },
				-- React.createElement(
				-- 	ModalDialogContextController,
				-- 	{},
				React.createElement(
					SettingsModalContextController,
					{},
					React.createElement(
						SettingsContextController,
						{
							browserTheme = browserTheme,
							componentsPortalContainer = componentsPortalContainer,
							profilerPortalContainer = profilerPortalContainer,
						},
						-- 	React.createElement(
						-- 		ViewElementSourceContext.Provider,
						-- 		{ value = viewElementSource },
						React.createElement(
							TreeContextController,
							nil,
							React.createElement(
								ProfilerContextController,
								nil,
								React.createElement(Div, {
									ref = devToolsRef,
								}, showTabBar and React.createElement(
									Div,
									{
										name = "tab-bar-container",
										direction = Enum.FillDirection.Horizontal,
										frameProps = {
											Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
										},
									},
									-- <ReactLogo />,
									React.createElement(Text, {
										text = _G.DEVTOOLS_VERSION or "<version>",
									}),
									-- <div className={styles.Spacer} />
									React.createElement(TabBar, {
										currentTab = tab,
										id = "DevTools",
										selectTab = setTab,
										tabs = tabs,
										type = "navigation",
									})
								)),
								React.createElement(
									Div,
									{
										name = "components-tab",
										frameProps = {
											Position = UDim2.fromOffset(0, BAR_HEIGHT),
											Size = UDim2.new(1, 0, 1, -BAR_HEIGHT),
											Visible = tab == "components",
										},
									},
									-- todo: render Components instead of text
									React.createElement(Text, {
										text = "Components tab!",
									})
									-- React.createElement(Components, {
									-- 	portalContainer = componentsPortalContainer,
									-- })
								),
								React.createElement(
									Div,
									{
										name = "profiler-tabs",
										frameProps = {
											Position = UDim2.fromOffset(0, BAR_HEIGHT),
											Size = UDim2.new(1, 0, 1, -BAR_HEIGHT),
											Visible = tab == "profiler",
										},
									},
									React.createElement(Profiler, {
										portalContainer = profilerPortalContainer,
									})
								),
								React.createElement(SettingsModal)
							)
						)
					)
					-- )
					-- warnIfLegacyBackendDetected and React.createElement(WarnIfLegacyBackendDetected),
					-- warnIfUnsupportedVersionDetected and React.createElement(UnsupportedVersionDialog)
					-- )
				)
			)
		)
	)
end
exports.default = DevTools
exports.DevTools = DevTools

return exports
