--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Settings/SettingsContext.js
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

local React = require(Packages.React)
local createContext = React.createContext
local useContext = React.useContext
local useEffect = React.useEffect
local useLayoutEffect = React.useLayoutEffect
local useMemo = React.useMemo

local constants = require(script.Parent.Parent.Parent.Parent.constants)
local COMFORTABLE_LINE_HEIGHT = constants.COMFORTABLE_LINE_HEIGHT
local COMPACT_LINE_HEIGHT = constants.COMPACT_LINE_HEIGHT
local LOCAL_STORAGE_SHOULD_BREAK_ON_CONSOLE_ERRORS = constants.LOCAL_STORAGE_SHOULD_BREAK_ON_CONSOLE_ERRORS
local LOCAL_STORAGE_SHOULD_PATCH_CONSOLE_KEY = constants.LOCAL_STORAGE_SHOULD_PATCH_CONSOLE_KEY
local LOCAL_STORAGE_TRACE_UPDATES_ENABLED_KEY = constants.LOCAL_STORAGE_TRACE_UPDATES_ENABLED_KEY

local hooksModule = require(script.Parent.Parent.hooks)
local useLocalStorage = hooksModule.useLocalStorage
local contextsModule = require(script.Parent.Parent.context)
local BridgeContext = contextsModule.BridgeContext

export type DisplayDensity = "comfortable" | "compact"
export type Theme = "auto" | "light" | "dark"

type Context = {
	displayDensity: DisplayDensity,
	setDisplayDensity: (value: DisplayDensity) -> (),

	-- Derived from display density.
	-- Specified as a separate prop so it can trigger a re-render of FixedSizeList.
	lineHeight: number,

	appendComponentStack: boolean,
	setAppendComponentStack: (value: boolean) -> (),

	breakOnConsoleErrors: boolean,
	setBreakOnConsoleErrors: (value: boolean) -> (),

	theme: Theme,
	setTheme: (value: Theme) -> (),

	traceUpdatesEnabled: boolean,
	setTraceUpdatesEnabled: (value: boolean) -> (),
}

local SettingsContext = createContext((nil :: any) :: Context)
SettingsContext.displayName = "SettingsContext"

type DocumentElements = Array<HTMLElement>

type Props = {
	--   browserTheme: BrowserTheme,
	children: React.ReactNode,
	--   componentsPortalContainer: Element?,
	--   profilerPortalContainer: Element?,
}

local function SettingsContextController(props: Props)
	-- local browserTheme = props.browserTheme
	local children = props.children
	-- local componentsPortalContainer = props.componentsPortalContainer
	-- local profilerPortalContainer = props.profilerPortalContainer
	local bridge = useContext(BridgeContext)

	local displayDensity: DisplayDensity, setDisplayDensity =
		useLocalStorage("React::DevTools::displayDensity", "compact" :: DisplayDensity)
	local theme: Theme, setTheme = useLocalStorage("React::DevTools::theme", "auto" :: Theme)

	local appendComponentStack, setAppendComponentStack = useLocalStorage(LOCAL_STORAGE_SHOULD_PATCH_CONSOLE_KEY, true)
	local breakOnConsoleErrors, setBreakOnConsoleErrors =
		useLocalStorage(LOCAL_STORAGE_SHOULD_BREAK_ON_CONSOLE_ERRORS, false)
	local traceUpdatesEnabled, setTraceUpdatesEnabled = useLocalStorage(LOCAL_STORAGE_TRACE_UPDATES_ENABLED_KEY, false)

	-- local documentElements: DocumentElements = useMemo(function()
	-- 	local array: Array<HTMLElement> = {
	-- 		document.documentElement :: any,
	-- 	}
	-- 	if componentsPortalContainer ~= nil then
	-- 		table.insert(array, componentsPortalContainer.ownerDocument.documentElement :: any)
	-- 	end
	-- 	if profilerPortalContainer ~= nil then
	-- 		table.insert(array, profilerPortalContainer.ownerDocument.documentElement :: any)
	-- 	end
	-- 	return array
	-- end, { componentsPortalContainer, profilerPortalContainer })

	--   useLayoutEffect(() => {
	--     switch (displayDensity) {
	--       case 'comfortable':
	--         updateDisplayDensity('comfortable', documentElements);
	--         break;
	--       case 'compact':
	--         updateDisplayDensity('compact', documentElements);
	--         break;
	--       default:
	--         throw Error(`Unsupported displayDensity value "${displayDensity}"`);
	--     }
	--   }, {displayDensity, documentElements});

	--   useLayoutEffect(() => {
	--     switch (theme) {
	--       case 'light':
	--         updateThemeVariables('light', documentElements);
	--         break;
	--       case 'dark':
	--         updateThemeVariables('dark', documentElements);
	--         break;
	--       case 'auto':
	--         updateThemeVariables(browserTheme, documentElements);
	--         break;
	--       default:
	--         throw Error(`Unsupported theme value "${theme}"`);
	--     }
	--   }, {browserTheme, theme, documentElements});

	useEffect(function()
		bridge:send("updateConsolePatchSettings", {
			appendComponentStack = appendComponentStack,
			breakOnConsoleErrors = breakOnConsoleErrors,
		})
	end, { bridge :: any, appendComponentStack, breakOnConsoleErrors })

	useEffect(function()
		bridge:send("setTraceUpdatesEnabled", traceUpdatesEnabled)
	end, { bridge :: any, traceUpdatesEnabled })

	local value = useMemo(function()
		return {
			appendComponentStack = appendComponentStack,
			breakOnConsoleErrors = breakOnConsoleErrors,
			displayDensity = displayDensity,
			lineHeight = if displayDensity == "compact" then COMPACT_LINE_HEIGHT else COMFORTABLE_LINE_HEIGHT,
			setAppendComponentStack = setAppendComponentStack,
			setBreakOnConsoleErrors = setBreakOnConsoleErrors,
			setDisplayDensity = setDisplayDensity,
			setTheme = setTheme,
			setTraceUpdatesEnabled = setTraceUpdatesEnabled,
			theme = theme,
			traceUpdatesEnabled = traceUpdatesEnabled,
		}
	end, {
		appendComponentStack,
		breakOnConsoleErrors,
		-- displayDensity,
		-- setAppendComponentStack,
		-- setBreakOnConsoleErrors,
		-- setDisplayDensity,
		-- setTheme,
		-- setTraceUpdatesEnabled,
		-- theme,
		traceUpdatesEnabled,
	})

	return React.createElement(SettingsContext.Provider, {
		value = value,
	}, children)
end
exports.SettingsContextController = SettingsContextController

-- local function setStyleVariable(name: string, value: string, documentElements: DocumentElements)
-- 	documentElements:forEach(function(documentElement)
-- 		documentElement.style.setProperty(name, value)
-- 	end)
-- end

-- local function updateStyleHelper(themeKey: string, style: string, documentElements: DocumentElements)
-- 	setStyleVariable(`--${style}`, `var(--${themeKey}-${style})`, documentElements)
-- end

local function updateDisplayDensity(displayDensity: DisplayDensity, documentElements: DocumentElements): ()
	--   updateStyleHelper(
	--     displayDensity,
	--     'font-size-monospace-normal',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     displayDensity,
	--     'font-size-monospace-large',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     displayDensity,
	--     'font-size-monospace-small',
	--     documentElements,
	--   );
	--   updateStyleHelper(displayDensity, 'font-size-sans-normal', documentElements);
	--   updateStyleHelper(displayDensity, 'font-size-sans-large', documentElements);
	--   updateStyleHelper(displayDensity, 'font-size-sans-small', documentElements);
	--   updateStyleHelper(displayDensity, 'line-height-data', documentElements);

	--   -- Sizes and paddings/margins are all rem-based,
	--   -- so update the root font-size as well when the display preference changes.
	--   const computedStyle = getComputedStyle((document.body: any));
	--   const fontSize = computedStyle.getPropertyValue(
	--     `--${displayDensity}-root-font-size`,
	--   );
	--   const root = ((document.querySelector(':root'): any): HTMLElement);
	--   root.style.fontSize = fontSize;
end

local function updateThemeVariables(theme: Theme, documentElements: DocumentElements): ()
	--   updateStyleHelper(theme, 'color-attribute-name', documentElements);
	--   updateStyleHelper(
	--     theme,
	--     'color-attribute-name-not-editable',
	--     documentElements,
	--   );
	--   updateStyleHelper(theme, 'color-attribute-name-inverted', documentElements);
	--   updateStyleHelper(theme, 'color-attribute-value', documentElements);
	--   updateStyleHelper(theme, 'color-attribute-value-inverted', documentElements);
	--   updateStyleHelper(theme, 'color-attribute-editable-value', documentElements);
	--   updateStyleHelper(theme, 'color-background', documentElements);
	--   updateStyleHelper(theme, 'color-background-hover', documentElements);
	--   updateStyleHelper(theme, 'color-background-inactive', documentElements);
	--   updateStyleHelper(theme, 'color-background-invalid', documentElements);
	--   updateStyleHelper(theme, 'color-background-selected', documentElements);
	--   updateStyleHelper(theme, 'color-border', documentElements);
	--   updateStyleHelper(theme, 'color-button-background', documentElements);
	--   updateStyleHelper(theme, 'color-button-background-focus', documentElements);
	--   updateStyleHelper(theme, 'color-button', documentElements);
	--   updateStyleHelper(theme, 'color-button-active', documentElements);
	--   updateStyleHelper(theme, 'color-button-disabled', documentElements);
	--   updateStyleHelper(theme, 'color-button-focus', documentElements);
	--   updateStyleHelper(theme, 'color-button-hover', documentElements);
	--   updateStyleHelper(
	--     theme,
	--     'color-commit-did-not-render-fill',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     theme,
	--     'color-commit-did-not-render-fill-text',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     theme,
	--     'color-commit-did-not-render-pattern',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     theme,
	--     'color-commit-did-not-render-pattern-text',
	--     documentElements,
	--   );
	--   updateStyleHelper(theme, 'color-commit-gradient-0', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-1', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-2', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-3', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-4', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-5', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-6', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-7', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-8', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-9', documentElements);
	--   updateStyleHelper(theme, 'color-commit-gradient-text', documentElements);
	--   updateStyleHelper(theme, 'color-component-name', documentElements);
	--   updateStyleHelper(theme, 'color-component-name-inverted', documentElements);
	--   updateStyleHelper(
	--     theme,
	--     'color-component-badge-background',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     theme,
	--     'color-component-badge-background-inverted',
	--     documentElements,
	--   );
	--   updateStyleHelper(theme, 'color-component-badge-count', documentElements);
	--   updateStyleHelper(
	--     theme,
	--     'color-component-badge-count-inverted',
	--     documentElements,
	--   );
	--   updateStyleHelper(theme, 'color-context-background', documentElements);
	--   updateStyleHelper(theme, 'color-context-background-hover', documentElements);
	--   updateStyleHelper(
	--     theme,
	--     'color-context-background-selected',
	--     documentElements,
	--   );
	--   updateStyleHelper(theme, 'color-context-border', documentElements);
	--   updateStyleHelper(theme, 'color-context-text', documentElements);
	--   updateStyleHelper(theme, 'color-context-text-selected', documentElements);
	--   updateStyleHelper(theme, 'color-dim', documentElements);
	--   updateStyleHelper(theme, 'color-dimmer', documentElements);
	--   updateStyleHelper(theme, 'color-dimmest', documentElements);
	--   updateStyleHelper(theme, 'color-error-background', documentElements);
	--   updateStyleHelper(theme, 'color-error-border', documentElements);
	--   updateStyleHelper(theme, 'color-error-text', documentElements);
	--   updateStyleHelper(theme, 'color-expand-collapse-toggle', documentElements);
	--   updateStyleHelper(theme, 'color-link', documentElements);
	--   updateStyleHelper(theme, 'color-modal-background', documentElements);
	--   updateStyleHelper(theme, 'color-record-active', documentElements);
	--   updateStyleHelper(theme, 'color-record-hover', documentElements);
	--   updateStyleHelper(theme, 'color-record-inactive', documentElements);
	--   updateStyleHelper(theme, 'color-color-scroll-thumb', documentElements);
	--   updateStyleHelper(theme, 'color-color-scroll-track', documentElements);
	--   updateStyleHelper(theme, 'color-search-match', documentElements);
	--   updateStyleHelper(theme, 'color-shadow', documentElements);
	--   updateStyleHelper(theme, 'color-search-match-current', documentElements);
	--   updateStyleHelper(
	--     theme,
	--     'color-selected-tree-highlight-active',
	--     documentElements,
	--   );
	--   updateStyleHelper(
	--     theme,
	--     'color-selected-tree-highlight-inactive',
	--     documentElements,
	--   );
	--   updateStyleHelper(theme, 'color-tab-selected-border', documentElements);
	--   updateStyleHelper(theme, 'color-text', documentElements);
	--   updateStyleHelper(theme, 'color-text-invalid', documentElements);
	--   updateStyleHelper(theme, 'color-text-selected', documentElements);
	--   updateStyleHelper(theme, 'color-toggle-background-invalid', documentElements);
	--   updateStyleHelper(theme, 'color-toggle-background-on', documentElements);
	--   updateStyleHelper(theme, 'color-toggle-background-off', documentElements);
	--   updateStyleHelper(theme, 'color-toggle-text', documentElements);
	--   updateStyleHelper(theme, 'color-tooltip-background', documentElements);
	--   updateStyleHelper(theme, 'color-tooltip-text', documentElements);

	--   -- Font smoothing varies based on the theme.
	--   updateStyleHelper(theme, 'font-smoothing', documentElements);

	--   -- Update scrollbar color to match theme.
	--   -- this CSS property is currently only supported in Firefox,
	--   -- but it makes a significant UI improvement in dark mode.
	--   -- https://developer.mozilla.org/en-US/docs/Web/CSS/scrollbar-color
	--   documentElements.forEach(documentElement => {
	--     -- $FlowFixMe scrollbarColor is missing in CSSStyleDeclaration
	--     documentElement.style.scrollbarColor = `var(${`--${theme}-color-scroll-thumb`}) var(${`--${theme}-color-scroll-track`})`;
	--   });
end

return exports
