-- upstream: https://github.com/facebook/react/blob/v17.0.2/packages/react-debug-tools/src/ReactDebugHooks.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]
type void = nil --[[ FIXME: adding `void` type alias to make it easier to use Luau `void` equivalent when supported ]]
local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
-- deviation START: not needed
-- local Boolean = LuauPolyfill.Boolean
-- deviation END
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>
type Error = LuauPolyfill.Error
type Map<T, U> = LuauPolyfill.Map<T, U>
-- deviation START: add additional imports
type Object = LuauPolyfill.Object
local String = LuauPolyfill.String
-- deviation END
local exports = {}
-- local sharedReactTypesModule = require(Packages.shared.ReactTypes)
-- type MutableSource = sharedReactTypesModule.MutableSource
-- type MutableSourceGetSnapshotFn = sharedReactTypesModule.MutableSourceGetSnapshotFn
-- type MutableSourceSubscribeFn = sharedReactTypesModule.MutableSourceSubscribeFn
-- type ReactContext = sharedReactTypesModule.ReactContext
-- type ReactProviderType = sharedReactTypesModule.ReactProviderType
local ReactTypes = require(Packages.Shared)
type MutableSource<T> = ReactTypes.MutableSource<T>
type MutableSourceGetSnapshotFn<Source, Snapshot> = ReactTypes.MutableSourceGetSnapshotFn<Source, Snapshot>
type MutableSourceSubscribeFn<Source, Snapshot> = ReactTypes.MutableSourceSubscribeFn<Source, Snapshot>
type ReactContext<T> = ReactTypes.ReactContext<T>
type ReactProviderType<T> = ReactTypes.ReactProviderType<T>

-- deviation END
-- deviation START: add import type that is a built-in in flow
type React_Node = ReactTypes.React_Node
-- deviation END

-- deviation START: add binding support
type ReactBinding<T> = ReactTypes.ReactBinding<T>
type ReactBindingUpdater<T> = ReactTypes.ReactBindingUpdater<T>
-- deviation END
-- deviation START: fix import
-- local reactReconcilerSrcReactInternalTypesModule =
-- 	require(Packages["react-reconciler"].src.ReactInternalTypes)
local reactReconcilerSrcReactInternalTypesModule = require(Packages.ReactReconciler)
-- deviation END
type Fiber = reactReconcilerSrcReactInternalTypesModule.Fiber
type DispatcherType = reactReconcilerSrcReactInternalTypesModule.Dispatcher
-- deviation START: fix import - import from Shared
-- local reactReconcilerSrcReactFiberHostConfigModule =
-- 	require(Packages["react-reconciler"].src.ReactFiberHostConfig)
local reactReconcilerSrcReactFiberHostConfigModule = require(Packages.Shared)
-- deviation END
type OpaqueIDType = reactReconcilerSrcReactFiberHostConfigModule.OpaqueIDType
-- deviation START: fix import
-- local NoMode = require(Packages["react-reconciler"].src.ReactTypeOfMode).NoMode
local ReconcilerModule = require(Packages.ReactReconciler)({})
local NoMode = ReconcilerModule.ReactTypeOfMode.NoMode
-- deviation END
-- deviation START: add inline ErrorStackParser implementation
-- local ErrorStackParser = require(Packages["error-stack-parser"]).default
type StackFrame = {
	source: string?,
	functionName: string?,
}
local ErrorStackParser = {
	parse = function(error_: Error): Array<StackFrame>
		if error_.stack == nil then
			return {}
		end
		local filtered = Array.filter(string.split(error_.stack :: string, "\n"), function(line)
			return string.find(line, "^LoadedCode") ~= nil
		end)
		return Array.map(filtered, function(stackTraceLine)
			-- FIXME Luau: shouldn't need to explicitly provide nilable field
			local functionName = string.match(stackTraceLine, "function (%w+)$")
			return { source = stackTraceLine, functionName = functionName }
		end)
	end,
}
-- deviation END
-- deviation START: import from Shared
-- local ReactSharedInternals = require(Packages.shared.ReactSharedInternals).default
-- local REACT_OPAQUE_ID_TYPE = require(Packages.shared.ReactSymbols).REACT_OPAQUE_ID_TYPE
local SharedModule = require(Packages.Shared)
local ReactSharedInternals = SharedModule.ReactSharedInternals
local ReactSymbols = SharedModule.ReactSymbols
local REACT_OPAQUE_ID_TYPE = ReactSymbols.REACT_OPAQUE_ID_TYPE
-- deviation END
-- deviation START: fix import - get from ReconcilerModule
-- local reactReconcilerSrcReactWorkTagsModule =
-- 	require(Packages["react-reconciler"].src.ReactWorkTags)
local reactReconcilerSrcReactWorkTagsModule = ReconcilerModule.ReactWorkTags
-- deviation END
local FunctionComponent = reactReconcilerSrcReactWorkTagsModule.FunctionComponent
local SimpleMemoComponent = reactReconcilerSrcReactWorkTagsModule.SimpleMemoComponent
local ContextProvider = reactReconcilerSrcReactWorkTagsModule.ContextProvider
local ForwardRef = reactReconcilerSrcReactWorkTagsModule.ForwardRef
local Block = reactReconcilerSrcReactWorkTagsModule.Block
-- deviation START: fix import
-- type CurrentDispatcherRef = typeof(ReactSharedInternals_ReactCurrentDispatcher) -- Used to track hooks called during a render
type CurrentDispatcherRef = typeof(ReactSharedInternals.ReactCurrentDispatcher)
-- deviation END
type HookLogEntry = { primitive: string, stackError: Error, value: unknown } --[[ CHECK: inexact type upstream which is not supported by Luau. Verify if it doesn't break the analyze ]]
local hookLog: Array<HookLogEntry> = {} -- Primitives
type BasicStateAction<S> = (S) -> S | S
type Dispatch<A> = (A) -> ()
local primitiveStackCache: nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]] | Map<string, Array<any>> =
	nil
local currentFiber: Fiber | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]] = nil
type Hook = {
	memoizedState: any,
	next: Hook | nil,--[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
}
-- deviation START: add predefined variable
local Dispatcher: DispatcherType
-- deviation END
local function getPrimitiveStackCache(): Map<string, Array<any>>
	-- This initializes a cache of all primitive hooks so that the top
	-- most stack frames added by calling the primitive hook can be removed.
	if primitiveStackCache == nil then
		local cache = Map.new()
		local readHookLog
		do --[[ COMMENT: try-finally block conversion ]]
			-- deviation START: doesn't return
			-- local ok, result, hasReturned = pcall(function()
			local ok, result = pcall(function()
				-- deviation END
				-- Use all hooks here to add them to the hook log.
				-- deviation START: use dot notation
				-- Dispatcher:useContext({ _currentValue = nil } :: any)
				-- Dispatcher:useState(nil)
				-- Dispatcher:useReducer(function(s, a)
				Dispatcher.useContext({ _currentValue = nil } :: any)
				Dispatcher.useState(nil)
				Dispatcher.useReducer(function(s, a)
					-- deviation END
					return s
				end, nil)
				-- deviation START: use dot notation
				-- Dispatcher:useRef(nil)
				-- Dispatcher:useLayoutEffect(function() end)
				-- Dispatcher:useEffect(function() end)
				-- Dispatcher:useImperativeHandle(nil, function()
				Dispatcher.useRef(nil)
				Dispatcher.useLayoutEffect(function() end)
				Dispatcher.useEffect(function() end)
				Dispatcher.useImperativeHandle(nil, function()
					-- deviation END
					return nil
				end)
				-- deviation START: use dot notation
				-- Dispatcher:useDebugValue(nil)
				-- Dispatcher:useCallback(function() end)
				-- Dispatcher:useMemo(function()
				Dispatcher.useDebugValue(nil)
				Dispatcher.useCallback(function() end)
				Dispatcher.useMemo(function()
					-- deviation END
					return nil
				end)
			end)
			do
				readHookLog = hookLog
				hookLog = {}
			end
			-- deviation START: doesn't return
			-- if hasReturned then
			-- 	return result
			-- end
			-- deviation END
			if not ok then
				error(result)
			end
		end
		-- deviation START: use for in loop instead of while
		-- do
		-- 	local i = 0
		-- 	while
		-- 		i
		-- 		< readHookLog.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		-- 	do
		-- 		local hook = readHookLog[tostring(i)]
		-- 		cache:set(hook.primitive, ErrorStackParser:parse(hook.stackError))
		-- 		i += 1
		-- 	end
		-- end
		for i = 1, #readHookLog do
			local hook = readHookLog[i]
			cache:set(hook.primitive, ErrorStackParser.parse(hook.stackError))
		end
		-- deviation END
		primitiveStackCache = cache
	end
	-- deviation START: needs cast
	-- return primitiveStackCache
	return primitiveStackCache :: Map<string, Array<any>>
	-- deviation END
end
local currentHook: nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]] | Hook = nil
local function nextHook(): nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]] | Hook
	local hook = currentHook
	if hook ~= nil then
		currentHook = hook.next
	end
	return hook
end
local function readContext<T>(context: ReactContext<T>, observedBits: void | number | boolean): T
	-- For now we don't expose readContext usage in the hooks debugging info.
	return context._currentValue
end
local function useContext<T>(context: ReactContext<T>, observedBits: void | number | boolean): T
	table.insert(hookLog, { primitive = "Context", stackError = Error.new(), value = context._currentValue }) --[[ CHECK: check if 'hookLog' is an Array ]]
	return context._currentValue
end
-- deviation START: return 2 values instead of a tuple
-- local function useState<S>(
-- 	initialState: () -> S | S
-- ): any --[[ TODO: Unhandled node for type: TupleTypeAnnotation ]] --[[ [S, Dispatch<BasicStateAction<S>>] ]]
local function useState<S>(initialState: (() -> S) | S): (S, Dispatch<BasicStateAction<S>>)
	-- deviation END
	local hook = nextHook()
	local state: S = if hook ~= nil
		then hook.memoizedState
		else if typeof(initialState) == "function"
			then -- $FlowFixMe: Flow doesn't like mixed types
				initialState()
			else initialState
	table.insert(hookLog, { primitive = "State", stackError = Error.new(), value = state }) --[[ CHECK: check if 'hookLog' is an Array ]]
	-- deviation START: return 2 values instead of a tuple
	-- return { state, function(action: BasicStateAction<S>) end }
	return state, function(action: BasicStateAction<S>) end
	-- deviation END
end
-- deviation START: return 2 values instead of a tuple
-- local function useReducer<S, I, A>(
-- 	reducer: (S, A) -> S,
-- 	initialArg: I,
-- 	init: ((I) -> S)?
-- ): any --[[ TODO: Unhandled node for type: TupleTypeAnnotation ]] --[[ [S, Dispatch<A>] ]]
local function useReducer<S, I, A>(reducer: (S, A) -> S, initialArg: I, init: ((I) -> S)?): (S, Dispatch<A>)
	-- deviation END
	local hook = nextHook()
	local state
	if hook ~= nil then
		state = hook.memoizedState
	else
		state = if init ~= nil then init(initialArg) else (initialArg :: any) :: S
	end
	table.insert(hookLog, { primitive = "Reducer", stackError = Error.new(), value = state }) --[[ CHECK: check if 'hookLog' is an Array ]]
	-- deviation START: return 2 values instead of a tuple
	-- return { state, function(action: A) end }
	return state, function(action: A) end
	-- deviation END
end
-- deviation START: TS models this slightly differently, which is needed to have an initially empty ref and clear the ref, and still typecheck
-- local function useRef<T>(initialValue: T): { current: T }
local function useRef<T>(initialValue: T): { current: T | nil }
	-- deviation END
	local hook = nextHook()
	local ref = if hook ~= nil then hook.memoizedState else { current = initialValue }
	table.insert(hookLog, { primitive = "Ref", stackError = Error.new(), value = ref.current }) --[[ CHECK: check if 'hookLog' is an Array ]]
	return ref
end
-- deviation START: add binding support; these aren't fully working hooks, so this
-- is just an approximation modeled off of the `ref` hook above
local function useBinding<T>(initialValue: T): (ReactBinding<T>, ReactBindingUpdater<T>)
	local hook = nextHook()
	local binding = if hook ~= nil
		then hook.memoizedState
		else ({
			getValue = function(_self)
				return initialValue
			end,
		} :: any) :: ReactBinding<T>

	table.insert(hookLog, {
		primitive = "Binding",
		stackError = Error.new(),
		value = binding:getValue(),
	})

	return binding, function(_value) end
end
-- deviation END
local function useLayoutEffect(
	-- deviation START: Luau needs union type packs for this type to translate idiomatically
	-- create: () -> () -> () | void,
	create: (() -> ()) | (() -> (() -> ())),
	-- deviation END
	inputs: Array<unknown> | void | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
): ()
	nextHook()
	table.insert(hookLog, { primitive = "LayoutEffect", stackError = Error.new(), value = create }) --[[ CHECK: check if 'hookLog' is an Array ]]
end
local function useEffect(
	-- deviation START: Luau needs union type packs for this type to translate idiomatically
	-- create: () -> () -> () | void,
	create: (() -> ()) | (() -> (() -> ())),
	-- deviation END
	inputs: Array<unknown> | void | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
): ()
	nextHook()
	table.insert(hookLog, { primitive = "Effect", stackError = Error.new(), value = create }) --[[ CHECK: check if 'hookLog' is an Array ]]
end
local function useImperativeHandle<T>(
	ref: {
		current: T | nil,--[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
	} | (
		inst: T | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
	) -> unknown | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]] | void,
	create: () -> T,
	inputs: Array<unknown> | void | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
): ()
	nextHook() -- We don't actually store the instance anywhere if there is no ref callback
	-- and if there is a ref callback it might not store it but if it does we
	-- have no way of knowing where. So let's only enable introspection of the
	-- ref itself if it is using the object form.
	local instance = nil
	if ref ~= nil and typeof(ref) == "table" then
		instance = ref.current
	end
	table.insert(hookLog, { primitive = "ImperativeHandle", stackError = Error.new(), value = instance }) --[[ CHECK: check if 'hookLog' is an Array ]]
end
-- deviation START: add generic params
-- local function useDebugValue(value: any, formatterFn: ((value: any) -> any)?)
local function useDebugValue<T>(value: T, formatterFn: ((value: T) -> any)?): ()
	-- deviation END
	table.insert(hookLog, {
		primitive = "DebugValue",
		stackError = Error.new(),
		value = if typeof(formatterFn) == "function" then formatterFn(value) else value,
	}) --[[ CHECK: check if 'hookLog' is an Array ]]
end
local function useCallback<T>(
	callback: T,
	inputs: Array<unknown> | void | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
): T
	local hook = nextHook()
	table.insert(hookLog, {
		primitive = "Callback",
		stackError = Error.new(),
		value = if hook ~= nil
			then hook.memoizedState[
				1 --[[ adapatation: added 1 to array index ]]
			]
			else callback,
	}) --[[ CHECK: check if 'hookLog' is an Array ]]
	return callback
end
-- deviation START: FIXME Luau: work around 'Failed to unify type packs' error: CLI-51338
-- local function useMemo<T>(
-- 	nextCreate: () -> T,
-- 	inputs: Array<unknown> | void | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
-- ): T
local function useMemo<T...>(nextCreate: () -> T..., inputs: Array<any> | nil): ...any
	-- deviation END
	local hook = nextHook()
	-- deviation START: Wrap memoized values in a table and unpack to allow for multiple return values
	-- local value = if hook ~= nil
	-- 	then hook.memoizedState[
	-- 		1 --[[ adapatation: added 1 to array index ]]
	-- 	]
	-- 	else nextCreate()
	local value = if hook ~= nil then hook.memoizedState[1] else { nextCreate() }
	-- deviation END

	table.insert(hookLog, { primitive = "Memo", stackError = Error.new(), value = value }) --[[ CHECK: check if 'hookLog' is an Array ]]
	-- deviation START: unwrap memoized values in a table
	-- return value
	return table.unpack(value)
	-- deviation END
end
local function useMutableSource<Source, Snapshot>(
	source: MutableSource<Source>,
	getSnapshot: MutableSourceGetSnapshotFn<Source, Snapshot>,
	subscribe: MutableSourceSubscribeFn<Source, Snapshot>
): Snapshot
	-- useMutableSource() composes multiple hooks internally.
	-- Advance the current hook index the same number of times
	-- so that subsequent hooks have the right memoized state.
	nextHook() -- MutableSource
	nextHook() -- State
	nextHook() -- Effect
	nextHook() -- Effect
	local value = getSnapshot(source._source)
	table.insert(hookLog, { primitive = "MutableSource", stackError = Error.new(), value = value }) --[[ CHECK: check if 'hookLog' is an Array ]]
	return value
end
-- deviation START: enable these once they are fully enabled in the Dispatcher type and in ReactFiberHooks' myriad dispatchers
-- local function useTransition(
-- ): any --[[ TODO: Unhandled node for type: TupleTypeAnnotation ]] --[[ [(() => void) => void, boolean] ]]
-- 	-- useTransition() composes multiple hooks internally.
-- 	-- Advance the current hook index the same number of times
-- 	-- so that subsequent hooks have the right memoized state.
-- 	nextHook() -- State
-- 	nextHook() -- Callback
-- 	table.insert(
-- 		hookLog,
-- 		{ primitive = "Transition", stackError = Error.new(), value = nil }
-- 	) --[[ CHECK: check if 'hookLog' is an Array ]]
-- 	return { function(callback) end, false }
-- end
-- local function useDeferredValue<T>(value: T): T
-- 	-- useDeferredValue() composes multiple hooks internally.
-- 	-- Advance the current hook index the same number of times
-- 	-- so that subsequent hooks have the right memoized state.
-- 	nextHook() -- State
-- 	nextHook() -- Effect
-- 	table.insert(
-- 		hookLog,
-- 		{ primitive = "DeferredValue", stackError = Error.new(), value = value }
-- 	) --[[ CHECK: check if 'hookLog' is an Array ]]
-- 	return value
-- end
-- deviation END
local function useOpaqueIdentifier(): OpaqueIDType | void
	local hook = nextHook() -- State
	-- deviation START: simplify
	-- if
	-- 	Boolean.toJSBoolean(
	-- 		if Boolean.toJSBoolean(currentFiber)
	-- 			then currentFiber.mode == NoMode
	-- 			else currentFiber
	-- 	)
	-- then
	if currentFiber and currentFiber.mode == NoMode then
		-- deviation END
		nextHook() -- Effect
	end
	local value = if hook == nil then nil else hook.memoizedState
	-- deviation START: simplify
	-- if
	-- 	Boolean.toJSBoolean(
	-- 		if Boolean.toJSBoolean(value)
	-- 			then value["$$typeof"] == REACT_OPAQUE_ID_TYPE
	-- 			else value
	-- 	)
	-- then
	if value and (value :: any)["$$typeof"] == REACT_OPAQUE_ID_TYPE then
		-- deviation END
		value = nil
	end
	table.insert(hookLog, { primitive = "OpaqueIdentifier", stackError = Error.new(), value = value }) --[[ CHECK: check if 'hookLog' is an Array ]]
	return value
end
-- deviation START: predefined variable
-- local Dispatcher: DispatcherType = {
Dispatcher = {
	-- deviation END
	readContext = readContext,
	useCallback = useCallback,
	useContext = useContext,
	useEffect = useEffect,
	-- deviation START: needs cast
	-- useImperativeHandle = useImperativeHandle,
	useImperativeHandle = useImperativeHandle :: any,
	-- deviation END
	useDebugValue = useDebugValue,
	useLayoutEffect = useLayoutEffect,
	-- deviation START: needs cast
	-- useMemo = useMemo,
	useMemo = useMemo :: any,
	-- deviation END
	useReducer = useReducer,
	useRef = useRef,
	-- deviation START: add useBinding
	useBinding = useBinding,
	-- deviation END
	-- deviation START: needs cast
	-- useState = useState,
	useState = useState :: any,
	-- deviation END
	-- deviation START: not implemented
	-- useTransition = useTransition,
	-- deviation END
	useMutableSource = useMutableSource,
	-- deviation START: not implemented
	-- useDeferredValue = useDeferredValue,
	-- deviation END
	useOpaqueIdentifier = useOpaqueIdentifier,
} -- Inspect
export type HooksNode = {
	id: number | nil,--[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
	isStateEditable: boolean,
	name: string,
	value: unknown,
	subHooks: Array<HooksNode>,
} --[[ CHECK: inexact type upstream which is not supported by Luau. Verify if it doesn't break the analyze ]]
export type HooksTree = Array<HooksNode> -- Don't assume
--
-- We can't assume that stack frames are nth steps away from anything.
-- E.g. we can't assume that the root call shares all frames with the stack
-- of a hook call. A simple way to demonstrate this is wrapping `new Error()`
-- in a wrapper constructor like a polyfill. That'll add an extra frame.
-- Similar things can happen with the call to the dispatcher. The top frame
-- may not be the primitive. Likewise the primitive can have fewer stack frames
-- such as when a call to useState got inlined to use dispatcher.useState.
--
-- We also can't assume that the last frame of the root call is the same
-- frame as the last frame of the hook call because long stack traces can be
-- truncated to a stack trace limit.
-- deviation START: adapt to 1-based indexing
-- local mostLikelyAncestorIndex = 0
local mostLikelyAncestorIndex = 1
-- deviation END
-- deviation START: explicit type
-- local function findSharedIndex(hookStack, rootStack, rootIndex)
local function findSharedIndex(hookStack, rootStack, rootIndex: number)
	-- deviation END
	-- deviation START: don't use tostring
	-- local source = rootStack[tostring(rootIndex)].source
	local source = rootStack[rootIndex].source
	-- deviation END
	-- deviation START: implement LabeledStatement
	-- 	error("not implemented") --[[ TODO: Unhandled node for type: LabeledStatement ]] --[[ hookSearch: for (let i = 0; i < hookStack.length; i++) {
	--     if (hookStack[i].source === source) {
	--       // This looks like a match. Validate that the rest of both stack match up.
	--       for (let a = rootIndex + 1, b = i + 1; a < rootStack.length && b < hookStack.length; a++, b++) {
	--         if (hookStack[b].source !== rootStack[a].source) {
	--           // If not, give up and try a different match.
	--           continue hookSearch;
	--         }
	--       }

	--       return i;
	--     }
	--   } ]]
	for i = 1, #hookStack do
		if hookStack[i].source == source then
			-- This looks like a match. Validate that the rest of both stack match up.
			-- deviation: rewrite complex loop
			local a = rootIndex + 1
			local b = i + 1
			local skipReturn = false
			while a <= #rootStack and b <= #hookStack do
				if hookStack[b].source ~= rootStack[a].source then
					-- If not, give up and try a different match.
					skipReturn = true
					break
				end
				a += 1
				b += 1
			end
			if not skipReturn then
				return i
			end
		end
	end
	-- deviation END
	return -1
end
local function findCommonAncestorIndex(rootStack, hookStack)
	local rootIndex = findSharedIndex(hookStack, rootStack, mostLikelyAncestorIndex)
	if rootIndex ~= -1 then
		return rootIndex
	end -- If the most likely one wasn't a hit, try any other frame to see if it is shared.
	-- If that takes more than 5 frames, something probably went wrong.
	-- deviation START: use numeric for loop
	-- do
	-- 	local i = 0
	-- 	while
	-- 		i < rootStack.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 		and i < 5 --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 	do
	-- 		rootIndex = findSharedIndex(hookStack, rootStack, i)
	-- 		if rootIndex ~= -1 then
	-- 			mostLikelyAncestorIndex = i
	-- 			return rootIndex
	-- 		end
	-- 		i += 1
	-- 	end
	-- end
	for i = 1, math.min(#rootStack, 5) do
		rootIndex = findSharedIndex(hookStack, rootStack, i)
		if rootIndex ~= -1 then
			mostLikelyAncestorIndex = i
			return rootIndex
		end
	end
	-- deviation END
	return -1
end
local function isReactWrapper(functionName, primitiveName)
	-- deviation START: simplify
	-- if not Boolean.toJSBoolean(functionName) then
	if not functionName or functionName == "" then
		-- deviation END
		return false
	end
	local expectedPrimitiveName = "use" .. tostring(primitiveName)
	-- deviation START: fix length implementation + Luau doesn't understand the guard above
	-- if
	-- 	functionName.length
	-- 	< expectedPrimitiveName.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- then
	if string.len(functionName :: string) < string.len(expectedPrimitiveName) then
		-- deviation END
		return false
	end
	-- deviation START: fix length implementation + Luau doesn't understand the guard above
	-- return functionName:lastIndexOf(expectedPrimitiveName)
	-- 	== functionName.length - expectedPrimitiveName.length
	return String.lastIndexOf(functionName :: string, expectedPrimitiveName)
		== (string.len(functionName :: string) - string.len(expectedPrimitiveName) + 1)
	-- deviation END
end
local function findPrimitiveIndex(hookStack, hook)
	local stackCache = getPrimitiveStackCache()
	local primitiveStack = stackCache:get(hook.primitive)
	if primitiveStack == nil then
		return -1
	end
	-- deviation START: use numeric for loop and precompute iteration count
	-- do
	-- 	local i = 0
	-- 	while
	-- 		i < primitiveStack.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 		and i < hookStack.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 	do
	-- 		if primitiveStack[tostring(i)].source ~= hookStack[tostring(i)].source then
	-- 			-- If the next two frames are functions called `useX` then we assume that they're part of the
	-- 			-- wrappers that the React packager or other packages adds around the dispatcher.
	-- 			if
	-- 				Boolean.toJSBoolean(
	-- 					i < hookStack.length - 1 --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 						and isReactWrapper(
	-- 							hookStack[tostring(i)].functionName,
	-- 							hook.primitive
	-- 						)
	-- 				)
	-- 			then
	-- 				i += 1
	-- 			end
	-- 			if
	-- 				Boolean.toJSBoolean(
	-- 					i < hookStack.length - 1 --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 						and isReactWrapper(
	-- 							hookStack[tostring(i)].functionName,
	-- 							hook.primitive
	-- 						)
	-- 				)
	-- 			then
	-- 				i += 1
	-- 			end
	-- 			return i
	-- 		end
	-- 		i += 1
	-- 	end
	-- end
	for i = 1, math.min(#primitiveStack :: Array<any>, #hookStack) do
		if (primitiveStack :: Array<any>)[i].source ~= hookStack[i].source then
			-- If the next two frames are functions called `useX` then we assume that they're part of the
			-- wrappers that the React packager or other packages adds around the dispatcher.
			-- NOTE: 1-indexed so drop -1
			if i < #hookStack and isReactWrapper(hookStack[i].functionName, hook.primitive) then
				i += 1
			end
			-- NOTE: 1-indexed so drop -1
			if i < #hookStack and isReactWrapper(hookStack[i].functionName, hook.primitive) then
				i += 1
			end
			return i
		end
	end
	-- deviation END
	return -1
end
-- deviation START: Luau doesn't infer Array<StackFrame> | nil like it should
-- local function parseTrimmedStack(rootStack, hook)
local function parseTrimmedStack(rootStack, hook): Array<StackFrame>?
	-- deviation END
	-- Get the stack trace between the primitive hook function and
	-- the root function call. I.e. the stack frames of custom hooks.
	-- deviation START: use dot notation
	-- local hookStack = ErrorStackParser:parse(hook.stackError)
	local hookStack = ErrorStackParser.parse(hook.stackError)
	-- deviation END
	local rootIndex = findCommonAncestorIndex(rootStack, hookStack)
	local primitiveIndex = findPrimitiveIndex(hookStack, hook)
	if
		rootIndex == -1
		or primitiveIndex == -1
		or rootIndex - primitiveIndex < 2 --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- Something went wrong. Give up.
		return nil
	end
	return Array.slice(hookStack, primitiveIndex, rootIndex - 1) --[[ CHECK: check if 'hookStack' is an Array ]]
end
local function parseCustomHookName(functionName: void | string): string
	-- deviation START: simplify
	-- if not Boolean.toJSBoolean(functionName) then
	if not functionName then
		-- deviation END
		return ""
	end
	-- deviation START: fix implementation
	-- local startIndex = functionName:lastIndexOf(".")
	local startIndex = String.lastIndexOf(functionName :: string, ".")
	-- deviation END
	if startIndex == -1 then
		-- deviation START: adapt for 1-based indexing
		-- startIndex = 0
		startIndex = 1
		-- deviation END
	end
	-- deviation START: fix implementation
	-- if functionName:substr(startIndex, 3) == "use" then
	if String.substr(functionName :: string, startIndex, 3) == "use" then
		-- deviation END
		startIndex += 3
	end
	-- deviation START: fix implementation
	-- return functionName:substr(startIndex)
	return String.substr(functionName :: string, startIndex)
	-- deviation END
end
-- deviation START: add predefined function
local processDebugValues
-- deviation END
-- deviation START: explicit type
-- local function buildTree(rootStack, readHookLog): HooksTree
local function buildTree(rootStack, readHookLog: Array<any>): HooksTree
	-- deviation END
	local rootChildren = {}
	local prevStack = nil
	local levelChildren = rootChildren
	-- deviation START: adjust for 1-based indexing
	-- local nativeHookID = 0
	local nativeHookID = 1
	-- deviation END
	local stackOfChildren = {}
	-- deviation START: use numeric for loop
	-- do
	-- 	local i = 0
	-- 	while
	-- 		i
	-- 		< readHookLog.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 	do
	-- 		local hook = readHookLog[tostring(i)]
	-- 		local stack = parseTrimmedStack(rootStack, hook)
	-- 		if stack ~= nil then
	-- 			-- NOTE: The indices 0 <= n < length-1 will contain the names.
	-- 			-- The indices 1 <= n < length will contain the source locations.
	-- 			-- That's why we get the name from n - 1 and don't check the source
	-- 			-- of index 0.
	-- 			local commonSteps = 0
	-- 			if prevStack ~= nil then
	-- 				-- Compare the current level's stack to the new stack.
	-- 				while
	-- 					commonSteps < stack.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 					and commonSteps < prevStack.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	-- 				do
	-- 					local stackSource =
	-- 						stack[tostring(stack.length - commonSteps - 1)].source
	-- 					local prevSource =
	-- 						prevStack[tostring(prevStack.length - commonSteps - 1)].source
	-- 					if stackSource ~= prevSource then
	-- 						break
	-- 					end
	-- 					commonSteps += 1
	-- 				end -- Pop back the stack as many steps as were not common.
	-- 				do
	-- 					local j = prevStack.length - 1
	-- 					while
	-- 						j
	-- 						> commonSteps --[[ CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	-- 					do
	-- 						levelChildren = table.remove(stackOfChildren) --[[ CHECK: check if 'stackOfChildren' is an Array ]]
	-- 						j -= 1
	-- 					end
	-- 				end
	-- 			end -- The remaining part of the new stack are custom hooks. Push them
	-- 			-- to the tree.
	-- 			do
	-- 				local j = stack.length - commonSteps - 1
	-- 				while
	-- 					j
	-- 					>= 1 --[[ CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	-- 				do
	-- 					local children = {}
	-- 					table.insert(levelChildren, {
	-- 						id = nil,
	-- 						isStateEditable = false,
	-- 						name = parseCustomHookName(
	-- 							stack[tostring(j - 1)].functionName
	-- 						),
	-- 						value = nil,
	-- 						subHooks = children,
	-- 					}) --[[ CHECK: check if 'levelChildren' is an Array ]]
	-- 					table.insert(stackOfChildren, levelChildren) --[[ CHECK: check if 'stackOfChildren' is an Array ]]
	-- 					levelChildren = children
	-- 					j -= 1
	-- 				end
	-- 			end
	-- 			prevStack = stack
	-- 		end
	-- 		local primitive = hook.primitive -- For now, the "id" of stateful hooks is just the stateful hook index.
	-- 		-- Custom hooks have no ids, nor do non-stateful native hooks (e.g. Context, DebugValue).
	-- 		local id = if primitive == "Context" or primitive == "DebugValue"
	-- 			then nil
	-- 			else (function()
	-- 				local ref = nativeHookID
	-- 				nativeHookID += 1
	-- 				return ref
	-- 			end)() -- For the time being, only State and Reducer hooks support runtime overrides.
	-- 		local isStateEditable = primitive == "Reducer" or primitive == "State"
	-- 		table.insert(levelChildren, {
	-- 			id = id,
	-- 			isStateEditable = isStateEditable,
	-- 			name = primitive,
	-- 			value = hook.value,
	-- 			subHooks = {},
	-- 		}) --[[ CHECK: check if 'levelChildren' is an Array ]]
	-- 		i += 1
	-- 	end
	-- end -- Associate custom hook values (useDebugValue() hook entries) with the correct hooks.
	for i = 1, #readHookLog do
		local hook = readHookLog[i]
		local stack = parseTrimmedStack(rootStack, hook)

		if stack ~= nil then
			-- NOTE: The indices 0 <= n < length-1 will contain the names.
			-- The indices 1 <= n < length will contain the source locations.
			-- That's why we get the name from n - 1 and don't check the source
			-- of index 0.
			local commonSteps = 0
			if prevStack ~= nil then
				-- Compare the current level's stack to the new stack.
				while commonSteps < #stack and commonSteps < #prevStack do
					local stackSource = stack[#stack - commonSteps].source
					local prevSource = prevStack[#prevStack - commonSteps].source

					if stackSource ~= prevSource then
						break
					end

					commonSteps += 1
				end
				-- Pop back the stack as many steps as were not common.
				for j = #prevStack - 1, commonSteps + 1, -1 do
					levelChildren = table.remove(stackOfChildren :: Array<any>) :: Array<any>
				end
			end

			-- The remaining part of the new stack are custom hooks. Push them
			-- to the tree.
			for j = #stack - commonSteps, 2, -1 do
				local children = {}
				table.insert(levelChildren, {
					-- FIXME Luau: Luau should infer number | nil here by (at least) looking at the function-level usage
					id = nil :: number | nil,
					isStateEditable = false,
					name = parseCustomHookName(stack[j - 1].functionName),
					value = nil,
					subHooks = children,
				})
				table.insert(stackOfChildren, levelChildren)
				levelChildren = children
			end

			prevStack = stack
		end

		local function POSTFIX_INCREMENT()
			local prev = nativeHookID
			nativeHookID += 1
			return prev
		end

		local primitive = hook.primitive

		-- For now, the "id" of stateful hooks is just the stateful hook index.
		-- Custom hooks have no ids, nor do non-stateful native hooks (e.g. Context, DebugValue).
		-- FIXME Luau: Luau doesn't infer number | nil like it should
		local id = if primitive == "Context" or primitive == "DebugValue" then nil else POSTFIX_INCREMENT()
		-- For the time being, only State and Reducer hooks support runtime overrides.
		local isStateEditable = primitive == "Reducer" or primitive == "State"

		table.insert(levelChildren, {
			id = id,
			isStateEditable = isStateEditable,
			name = primitive,
			value = hook.value,
			subHooks = {},
		})
	end
	-- deviation END
	processDebugValues(rootChildren, nil)
	return rootChildren
end -- Custom hooks support user-configurable labels (via the special useDebugValue() hook).
-- That hook adds user-provided values to the hooks tree,
-- but these values aren't intended to appear alongside of the other hooks.
-- Instead they should be attributed to their parent custom hook.
-- This method walks the tree and assigns debug values to their custom hook owners.
-- deviation START: predefined function
-- local function processDebugValues(
function processDebugValues(
	-- deviation END
	hooksTree: HooksTree,
	parentHooksNode: HooksNode | nil --[[ CHECK: verify if `null` wasn't used differently than `undefined` ]]
): ()
	local debugValueHooksNodes: Array<HooksNode> = {}
	do
		-- deviation START: adapt for 1-based indexing
		-- local i = 0
		local i = 1
		-- deviation END
		-- deviation START: fix length implementation
		-- while
		-- 	i
		-- 	< hooksTree.length --[[ CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		-- do
		while i <= #hooksTree do
			-- deviation END
			-- deviation START: don't use tostring for iterating an array
			-- local hooksNode = hooksTree[tostring(i)]
			local hooksNode = hooksTree[i]
			-- deviation END
			-- deviation START: fix length implementation
			-- if hooksNode.name == "DebugValue" and hooksNode.subHooks.length == 0 then
			if hooksNode.name == "DebugValue" and #hooksNode.subHooks == 0 then
				-- deviation END
				Array.splice(hooksTree, i, 1) --[[ CHECK: check if 'hooksTree' is an Array ]]
				i -= 1
				table.insert(debugValueHooksNodes, hooksNode) --[[ CHECK: check if 'debugValueHooksNodes' is an Array ]]
			else
				processDebugValues(hooksNode.subHooks, hooksNode)
			end
			i += 1
		end
	end -- Bubble debug value labels to their custom hook owner.
	-- If there is no parent hook, just ignore them for now.
	-- (We may warn about this in the future.)
	if parentHooksNode ~= nil then
		-- deviation START: fix length implementation
		-- if debugValueHooksNodes.length == 1 then
		if #debugValueHooksNodes == 1 then
			-- deviation END
			parentHooksNode.value = debugValueHooksNodes[
				1 --[[ adapatation: added 1 to array index ]]
			].value
			-- deviation START: fix length implementation
			-- elseif
			-- 	debugValueHooksNodes.length
			-- 	> 1 --[[ CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			-- then
		elseif #debugValueHooksNodes > 1 then
			-- deviation END
			parentHooksNode.value = Array.map(debugValueHooksNodes, function(ref0)
				local value = ref0.value
				return value
			end) --[[ CHECK: check if 'debugValueHooksNodes' is an Array ]]
		end
	end
end
local function inspectHooks<Props>(
	renderFunction: (Props) -> React_Node --[[ CHECK: replaced unhandled characters in identifier. Original identifier: React$Node ]],
	props: Props,
	currentDispatcher: CurrentDispatcherRef?
): HooksTree
	-- DevTools will pass the current renderer's injected dispatcher.
	-- Other apps might compile debug hooks as part of their app though.
	if
		currentDispatcher == nil --[[ CHECK: loose equality used upstream ]]
	then
		currentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
	end
	-- deviation START: Luau doesn't understand that currentDispatcher is not nil
	-- local previousDispatcher = currentDispatcher.current
	local previousDispatcher = (currentDispatcher :: CurrentDispatcherRef).current
	-- deviation END
	local readHookLog;
	-- deviation START: Luau doesn't understand that currentDispatcher is not nil
	-- currentDispatcher.current = Dispatcher
	(currentDispatcher :: CurrentDispatcherRef).current = Dispatcher
	-- deviation END
	local ancestorStackError
	do --[[ COMMENT: try-finally block conversion ]]
		-- deviation START: doesn't return
		-- local ok, result, hasReturned = pcall(function()
		local ok, result = pcall(function()
			-- deviation END
			ancestorStackError = Error.new()
			renderFunction(props)
		end)
		do
			readHookLog = hookLog
			hookLog = {};
			-- deviation START: Luau doesn't understand that currentDispatcher is not nil
			-- currentDispatcher.current = previousDispatcher
			(currentDispatcher :: CurrentDispatcherRef).current = previousDispatcher
			-- deviation END
		end
		-- deviation START: doesn't return
		-- if hasReturned then
		-- 	return result
		-- end
		-- deviation END
		if not ok then
			error(result)
		end
	end
	-- deviation START: use dot notation
	-- local rootStack = ErrorStackParser:parse(ancestorStackError)
	local rootStack = ErrorStackParser.parse(ancestorStackError)
	-- deviation END
	return buildTree(rootStack, readHookLog)
end
exports.inspectHooks = inspectHooks
local function setupContexts(contextMap: Map<ReactContext<any>, any>, fiber: Fiber)
	local current = fiber
	-- deviation START: toJSBoolean not needed
	-- while Boolean.toJSBoolean(current) do
	while current do
		-- deviation END
		if current.tag == ContextProvider then
			local providerType: ReactProviderType<any> = current.type
			local context: ReactContext<any> = providerType._context
			-- deviation START: toJSBoolean not needed
			-- if not Boolean.toJSBoolean(contextMap:has(context)) then
			if not contextMap:has(context) then
				-- deviation END
				-- Store the current value that we're going to restore later.
				contextMap:set(context, context._currentValue) -- Set the inner most provider value on the context.
				context._currentValue = current.memoizedProps.value
			end
		end
		-- deviation START: use return_
		-- current = current["return"]
		current = current.return_ :: Fiber
		-- deviation END
	end
end
local function restoreContexts(contextMap: Map<ReactContext<any>, any>)
	-- deviation START: use for..in loop
	-- Array.forEach(contextMap, function(value, context)
	-- 	context._currentValue = value
	-- 	return context._currentValue
	-- end) --[[ CHECK: check if 'contextMap' is an Array ]]
	for _, ref in contextMap do
		local context, value = ref[1], ref[2]
		context._currentValue = value
	end
	-- deviation END
end
local function inspectHooksOfForwardRef<Props, Ref>(
	renderFunction: (Props, Ref) -> React_Node --[[ CHECK: replaced unhandled characters in identifier. Original identifier: React$Node ]],
	props: Props,
	ref: Ref,
	currentDispatcher: CurrentDispatcherRef
): HooksTree
	local previousDispatcher = currentDispatcher.current
	local readHookLog
	currentDispatcher.current = Dispatcher
	local ancestorStackError
	do --[[ COMMENT: try-finally block conversion ]]
		-- deviation START: doesn't return
		-- local ok, result, hasReturned = pcall(function()
		local ok, result = pcall(function()
			-- deviation END
			ancestorStackError = Error.new()
			renderFunction(props, ref)
		end)
		do
			readHookLog = hookLog
			hookLog = {}
			currentDispatcher.current = previousDispatcher
		end
		-- deviation START: doesn't return
		-- if hasReturned then
		-- 	return result
		-- end
		-- deviation END
		if not ok then
			error(result)
		end
	end
	-- deviation START: use dot notation
	-- local rootStack = ErrorStackParser:parse(ancestorStackError)
	local rootStack = ErrorStackParser.parse(ancestorStackError)
	-- deviation END
	return buildTree(rootStack, readHookLog)
end
-- deviation START: explicit type
-- local function resolveDefaultProps(Component, baseProps)
local function resolveDefaultProps(Component, baseProps: Object)
	-- deviation END
	-- deviation START: toJSBoolean not needed
	-- if
	-- 	Boolean.toJSBoolean(
	-- 		if Boolean.toJSBoolean(Component) then Component.defaultProps else Component
	-- 	)
	-- then
	if typeof(Component) == "table" and Component.defaultProps then
		-- deviation END
		-- Resolve default props. Taken from ReactElement
		local props = Object.assign({}, baseProps)
		local defaultProps = Component.defaultProps
		for propName in defaultProps do
			-- deviation START: needs cast
			-- if props[tostring(propName)] == nil then
			-- 	props[tostring(propName)] = defaultProps[tostring(propName)]
			if (props :: Object)[propName] == nil then
				(props :: Object)[propName] = defaultProps[propName]
			end
			-- deviation END
		end
		return props
	end
	return baseProps
end
local function inspectHooksOfFiber(fiber: Fiber, currentDispatcher: CurrentDispatcherRef?)
	-- DevTools will pass the current renderer's injected dispatcher.
	-- Other apps might compile debug hooks as part of their app though.
	if
		currentDispatcher == nil --[[ CHECK: loose equality used upstream ]]
	then
		currentDispatcher = ReactSharedInternals.ReactCurrentDispatcher
	end
	currentFiber = fiber
	if
		fiber.tag ~= FunctionComponent
		and fiber.tag ~= SimpleMemoComponent
		and fiber.tag ~= ForwardRef
		and fiber.tag ~= Block
	then
		error(Error.new("Unknown Fiber. Needs to be a function component to inspect hooks."))
	end -- Warm up the cache so that it doesn't consume the currentHook.
	getPrimitiveStackCache()
	local type_ = fiber.type
	local props = fiber.memoizedProps
	if type_ ~= fiber.elementType then
		props = resolveDefaultProps(type_, props)
	end -- Set up the current hook so that we can step through and read the
	-- current state from them.
	currentHook = fiber.memoizedState :: Hook
	local contextMap = Map.new()
	do --[[ COMMENT: try-finally block conversion ]]
		-- deviation START: doesn't need conditional return
		-- local ok, result, hasReturned = pcall(function()
		local ok, result = pcall(function()
			-- deviation END
			setupContexts(contextMap, fiber)
			if fiber.tag == ForwardRef then
				return inspectHooksOfForwardRef(
					type_.render,
					props,
					fiber.ref,
					-- deviation START: needs cast
					-- currentDispatcher
					currentDispatcher :: CurrentDispatcherRef
					-- deviation END
				)
			end
			return inspectHooks(type_, props, currentDispatcher)
		end)
		do
			currentHook = nil
			restoreContexts(contextMap)
		end
		-- deviation START: doesn't need conditional return
		-- if hasReturned then
		-- 	return result
		-- end
		-- deviation END
		if not ok then
			error(result)
		end
		-- deviation START: add return
		return result
		-- deviation END
	end
end
exports.inspectHooksOfFiber = inspectHooksOfFiber
return exports
