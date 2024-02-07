<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/56e9feead0f91075ba0a4f725c9e4e343bca1c67/packages/react/src/React.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react/src/React.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
<<<<<<< HEAD
 *]]

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
type Object = LuauPolyfill.Object

local createMutableSource = require("./ReactMutableSource")
local ReactSharedInternals = require("@pkg/@jsdotlua/shared").ReactSharedInternals
local ReactBaseClasses = require("./ReactBaseClasses")
local ReactChildren = require("./ReactChildren")
local ReactElementValidator = require("./ReactElementValidator")
local ReactElement = require("./ReactElement")
local ReactCreateRef = require("./ReactCreateRef")
local ReactForwardRef = require("./ReactForwardRef")
local ReactHooks = require("./ReactHooks")
local ReactMemo = require("./ReactMemo")
local ReactContext = require("./ReactContext")
local ReactLazy = require("./ReactLazy")
type LazyComponent<T, P> = ReactLazy.LazyComponent<T, P>

-- ROBLOX DEVIATION: Bindings
local ReactBinding = require("./ReactBinding.roblox.lua")
-- ROBLOX DEVIATION: Re-export `None` marker
local ReactNone = require("./None.roblox.lua")

local SharedModule = require("@pkg/@jsdotlua/shared")
local ReactSymbols = SharedModule.ReactSymbols

local shouldValidate = _G.__DEV__ or _G.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__
local ReactTypes = require("@pkg/@jsdotlua/shared")
export type React_StatelessFunctionalComponent<P> =
	ReactTypes.React_StatelessFunctionalComponent<P>
export type React_ComponentType<P> = ReactTypes.React_ComponentType<P>
type React_AbstractComponent<P, T> = ReactTypes.React_AbstractComponent<P, T>
export type React_ElementProps<ElementType> = ReactTypes.React_ElementProps<ElementType>
export type ReactElement<P = Object, T = any> = ReactTypes.ReactElement<P, T>
export type ReactContext<T> = ReactTypes.ReactContext<T>
export type ReactProviderType<T> = ReactTypes.ReactProviderType<T>
export type React_Node = ReactTypes.React_Node
export type PureComponent<Props, State = nil> = ReactTypes.React_PureComponent<
	Props,
	State
>
-- ROBLOX deviation START: bindings support
export type ReactBinding<T> = ReactTypes.ReactBinding<T>
export type ReactBindingUpdater<T> = ReactTypes.ReactBindingUpdater<T>
-- ROBLOX deviation END

type createElementFn = <P, T>(
	type_: React_StatelessFunctionalComponent<P>
		| React_ComponentType<P>
		| React_AbstractComponent<P, T>
		| string
		| ReactContext<any>
		| ReactProviderType<any>
		| LazyComponent<T, P>,
	props: P?,
	...(React_Node | (...any) -> React_Node)
) -> ReactElement<P, T>

type cloneElementFn = <P, T>(
	element: ReactElement<P, T>,
	config: P?,
	...React_Node
) -> ReactElement<P, T>
-- ROBLOX FIXME Luau: these yield Cannot call non-function because the identical unions don't collapse
-- ROBLOX FIXME Luau: the next step is to add createElementFn here and work through issues, AFTER normalization and type packs work
local createElement = if shouldValidate
	then ReactElementValidator.createElementWithValidation :: createElementFn
	else ReactElement.createElement :: createElementFn
local cloneElement: cloneElementFn = if shouldValidate
	then ReactElementValidator.cloneElementWithValidation :: cloneElementFn
	else ReactElement.cloneElement :: cloneElementFn

return {
	Children = ReactChildren,
	createMutableSource = createMutableSource,
	createRef = ReactCreateRef.createRef,
	Component = ReactBaseClasses.Component,
	PureComponent = ReactBaseClasses.PureComponent,
	createContext = ReactContext.createContext,
	forwardRef = ReactForwardRef.forwardRef,
	lazy = ReactLazy.lazy,
	memo = ReactMemo.memo,
	useCallback = ReactHooks.useCallback,
	useContext = ReactHooks.useContext,
	useEffect = ReactHooks.useEffect,
	useImperativeHandle = ReactHooks.useImperativeHandle,
	useDebugValue = ReactHooks.useDebugValue,
	useLayoutEffect = ReactHooks.useLayoutEffect,
	useMemo = ReactHooks.useMemo,
	useMutableSource = ReactHooks.useMutableSource,
	useReducer = ReactHooks.useReducer,
	useRef = ReactHooks.useRef,
	-- ROBLOX deviation: bindings support
	useBinding = ReactHooks.useBinding,
	useState = ReactHooks.useState,
	Fragment = ReactSymbols.REACT_FRAGMENT_TYPE,
	Profiler = ReactSymbols.REACT_PROFILER_TYPE,
	StrictMode = ReactSymbols.REACT_STRICT_MODE_TYPE,
	unstable_DebugTracingMode = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE,
	Suspense = ReactSymbols.REACT_SUSPENSE_TYPE,
	createElement = createElement,
	cloneElement = cloneElement,
	isValidElement = ReactElement.isValidElement,
	-- ROBLOX TODO: ReactVersion
	__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = ReactSharedInternals,
	-- Deprecated behind disableCreateFactory
	-- ROBLOX TODO: createFactory,
	-- Concurrent Mode
	-- ROBLOX TODO: useTransition,
	-- ROBLOX TODO: startTransition,
	-- ROBLOX TODO: useDeferredValue,
	-- ROBLOX TODO: REACT_SUSPENSE_LIST_TYPE as SuspenseList,
	unstable_LegacyHidden = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE,
	-- enableBlocksAPI
	-- ROBLOX TODO: block,
	-- enableFundamentalAPI
	-- ROBLOX TODO: createFundamental as unstable_createFundamental,
	-- enableScopeAPI
	-- ROBLOX TODO: REACT_SCOPE_TYPE as unstable_Scope,
	-- ROBLOX TODO: useOpaqueIdentifier as unstable_useOpaqueIdentifier,

	-- ROBLOX deviation START: bindings support
	createBinding = ReactBinding.create,
	joinBindings = ReactBinding.join,
	-- ROBLOX deviation END

	-- ROBLOX DEVIATION: export the `None` placeholder for use with setState
	None = ReactNone,

	-- ROBLOX FIXME: These aren't supposed to be exposed, but they're needed by
	-- the renderer in order to update properly
	__subscribeToBinding = ReactBinding.subscribe,

	-- ROBLOX DEVIATION: export Change, Event, and Tag from React
	Event = require("@pkg/@jsdotlua/shared").Event,
	Change = require("@pkg/@jsdotlua/shared").Change,
	Tag = require("@pkg/@jsdotlua/shared").Tag,

	-- ROBLOX DEVIATION: used by error reporters to parse caught errors. React
	-- stringifies at its boundaries to maintain compatibility with
	-- ScriptContext signals that may ultimately catch them
	unstable_parseReactError = require("@pkg/@jsdotlua/shared").parseReactError,
}
=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local exports = {}
local ReactVersion = require(Packages.shared.ReactVersion).default
local sharedReactSymbolsModule = require(Packages.shared.ReactSymbols)
local REACT_FRAGMENT_TYPE = sharedReactSymbolsModule.REACT_FRAGMENT_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = sharedReactSymbolsModule.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_PROFILER_TYPE = sharedReactSymbolsModule.REACT_PROFILER_TYPE
local REACT_STRICT_MODE_TYPE = sharedReactSymbolsModule.REACT_STRICT_MODE_TYPE
local REACT_SUSPENSE_TYPE = sharedReactSymbolsModule.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = sharedReactSymbolsModule.REACT_SUSPENSE_LIST_TYPE
local REACT_LEGACY_HIDDEN_TYPE = sharedReactSymbolsModule.REACT_LEGACY_HIDDEN_TYPE
local REACT_OFFSCREEN_TYPE = sharedReactSymbolsModule.REACT_OFFSCREEN_TYPE
local REACT_SCOPE_TYPE = sharedReactSymbolsModule.REACT_SCOPE_TYPE
local REACT_CACHE_TYPE = sharedReactSymbolsModule.REACT_CACHE_TYPE
local REACT_TRACING_MARKER_TYPE = sharedReactSymbolsModule.REACT_TRACING_MARKER_TYPE
local reactBaseClassesModule = require(script.Parent.ReactBaseClasses)
local Component = reactBaseClassesModule.Component
local PureComponent = reactBaseClassesModule.PureComponent
local createRef = require(script.Parent.ReactCreateRef).createRef
local reactChildrenModule = require(script.Parent.ReactChildren)
local forEach = reactChildrenModule.forEach
local map = reactChildrenModule.map
local count = reactChildrenModule.count
local toArray = reactChildrenModule.toArray
local only = reactChildrenModule.only
local reactElementModule = require(script.Parent.ReactElement)
local createElementProd = reactElementModule.createElement
local createFactoryProd = reactElementModule.createFactory
local cloneElementProd = reactElementModule.cloneElement
local isValidElement = reactElementModule.isValidElement
local createContext = require(script.Parent.ReactContext).createContext
local lazy = require(script.Parent.ReactLazy).lazy
local forwardRef = require(script.Parent.ReactForwardRef).forwardRef
local memo = require(script.Parent.ReactMemo).memo
local reactHooksModule = require(script.Parent.ReactHooks)
local getCacheSignal = reactHooksModule.getCacheSignal
local getCacheForType = reactHooksModule.getCacheForType
local useCallback = reactHooksModule.useCallback
local useContext = reactHooksModule.useContext
local useEffect = reactHooksModule.useEffect
local useImperativeHandle = reactHooksModule.useImperativeHandle
local useDebugValue = reactHooksModule.useDebugValue
local useInsertionEffect = reactHooksModule.useInsertionEffect
local useLayoutEffect = reactHooksModule.useLayoutEffect
local useMemo = reactHooksModule.useMemo
local useMutableSource = reactHooksModule.useMutableSource
local useSyncExternalStore = reactHooksModule.useSyncExternalStore
local useReducer = reactHooksModule.useReducer
local useRef = reactHooksModule.useRef
local useState = reactHooksModule.useState
local useTransition = reactHooksModule.useTransition
local useDeferredValue = reactHooksModule.useDeferredValue
local useId = reactHooksModule.useId
local useCacheRefresh = reactHooksModule.useCacheRefresh
local reactElementValidatorModule = require(script.Parent.ReactElementValidator)
local createElementWithValidation = reactElementValidatorModule.createElementWithValidation
local createFactoryWithValidation = reactElementValidatorModule.createFactoryWithValidation
local cloneElementWithValidation = reactElementValidatorModule.cloneElementWithValidation
local createServerContext = require(script.Parent.ReactServerContext).createServerContext
local createMutableSource = require(script.Parent.ReactMutableSource).createMutableSource
local ReactSharedInternals = require(script.Parent.ReactSharedInternals).default
local startTransition = require(script.Parent.ReactStartTransition).startTransition
local act = require(script.Parent.ReactAct).act -- TODO: Move this branching into the other module instead and just re-export.
local createElement = if Boolean.toJSBoolean(__DEV__) then createElementWithValidation else createElementProd
local cloneElement = if Boolean.toJSBoolean(__DEV__) then cloneElementWithValidation else cloneElementProd
local createFactory = if Boolean.toJSBoolean(__DEV__) then createFactoryWithValidation else createFactoryProd
local Children = { map = map, forEach = forEach, count = count, toArray = toArray, only = only }
exports.Children = Children
exports.createMutableSource = createMutableSource
exports.createRef = createRef
exports.Component = Component
exports.PureComponent = PureComponent
exports.createContext = createContext
exports.createServerContext = createServerContext
exports.forwardRef = forwardRef
exports.lazy = lazy
exports.memo = memo
exports.useCallback = useCallback
exports.useContext = useContext
exports.useEffect = useEffect
exports.useImperativeHandle = useImperativeHandle
exports.useDebugValue = useDebugValue
exports.useInsertionEffect = useInsertionEffect
exports.useLayoutEffect = useLayoutEffect
exports.useMemo = useMemo
exports.useMutableSource = useMutableSource
exports.useSyncExternalStore = useSyncExternalStore
exports.useReducer = useReducer
exports.useRef = useRef
exports.useState = useState
exports.Fragment = REACT_FRAGMENT_TYPE
exports.Profiler = REACT_PROFILER_TYPE
exports.StrictMode = REACT_STRICT_MODE_TYPE
exports.unstable_DebugTracingMode = REACT_DEBUG_TRACING_MODE_TYPE
exports.Suspense = REACT_SUSPENSE_TYPE
exports.createElement = createElement
exports.cloneElement = cloneElement
exports.isValidElement = isValidElement
exports.version_ = ReactVersion
exports.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = ReactSharedInternals
-- Deprecated behind disableCreateFactory
exports.createFactory = createFactory
-- Concurrent Mode
exports.useTransition = useTransition
exports.startTransition = startTransition
exports.useDeferredValue = useDeferredValue
exports.SuspenseList = REACT_SUSPENSE_LIST_TYPE
exports.unstable_LegacyHidden = REACT_LEGACY_HIDDEN_TYPE
exports.unstable_Offscreen = REACT_OFFSCREEN_TYPE
exports.unstable_getCacheSignal = getCacheSignal
exports.unstable_getCacheForType = getCacheForType
exports.unstable_useCacheRefresh = useCacheRefresh
exports.unstable_Cache = REACT_CACHE_TYPE
-- enableScopeAPI
exports.unstable_Scope = REACT_SCOPE_TYPE
-- enableTransitionTracing
exports.unstable_TracingMarker = REACT_TRACING_MARKER_TYPE
exports.useId = useId
exports.act = act
return exports
>>>>>>> upstream-apply
