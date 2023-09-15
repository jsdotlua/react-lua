--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/hooks.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent.Parent.Parent.Parent
local MorePolyfill = require(Packages.MorePolyfill)
local JSON = MorePolyfill.JSON
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
type Array<K> = LuauPolyfill.Array<K>
local exports = {}

-- import throttle from 'lodash.throttle';

local React = require(Packages.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useLayoutEffect = React.useLayoutEffect
local useReducer = React.useReducer
local useState = React.useState
local useContext = React.useContext

local ReactRoblox = require(Packages.ReactRoblox)
local batchedUpdates = ReactRoblox.unstable_batchedUpdates

local storageModule = require(script.Parent.Parent.Parent.storage)
local localStorageGetItem = storageModule.localStorageGetItem
local localStorageSetItem = storageModule.localStorageSetItem

local contextModule = require(script.Parent.context)
local StoreContext = contextModule.StoreContext
local BridgeContext = contextModule.BridgeContext

local utilsModule = require(script.Parent.Parent.utils)
local sanitizeForParse = utilsModule.sanitizeForParse
local smartParse = utilsModule.smartParse
local smartStringify = utilsModule.smartStringify

type ACTION_RESET = {
	type: "RESET",
	externalValue: any,
}
type ACTION_UPDATE = {
	type: "UPDATE",
	editableValue: any,
	externalValue: any,
}

type UseEditableValueAction = ACTION_RESET | ACTION_UPDATE
type UseEditableValueDispatch = (action: UseEditableValueAction) -> ()
type UseEditableValueState = {
	editableValue: any,
	externalValue: any,
	hasPendingChanges: boolean,
	isValid: boolean,
	parsedValue: any,
}

-- function useEditableValueReducer(state, action) {
--   switch (action.type) {
--     case 'RESET':
--       return {
--         ...state,
--         editableValue: smartStringify(action.externalValue),
--         externalValue: action.externalValue,
--         hasPendingChanges: false,
--         isValid: true,
--         parsedValue: action.externalValue,
--       };
--     case 'UPDATE':
--       let isNewValueValid = false;
--       let newParsedValue;
--       try {
--         newParsedValue = smartParse(action.editableValue);
--         isNewValueValid = true;
--       } catch (error) {}
--       return {
--         ...state,
--         editableValue: sanitizeForParse(action.editableValue),
--         externalValue: action.externalValue,
--         hasPendingChanges:
--           smartStringify(action.externalValue) !== action.editableValue,
--         isValid: isNewValueValid,
--         parsedValue: isNewValueValid ? newParsedValue : state.parsedValue,
--       };
--     default:
--       throw new Error(`Invalid action "${action.type}"`);
--   }
-- }

-- Convenience hook for working with an editable value that is validated via JSON.parse.
-- export function useEditableValue(
--   externalValue: any,
-- ): [UseEditableValueState, UseEditableValueDispatch] {
--   const [state, dispatch] = useReducer<
--     UseEditableValueState,
--     UseEditableValueState,
--     UseEditableValueAction,
--   >(useEditableValueReducer, {
--     editableValue: smartStringify(externalValue),
--     externalValue,
--     hasPendingChanges: false,
--     isValid: true,
--     parsedValue: externalValue,
--   });
--   if (!Object.is(state.externalValue, externalValue)) {
--     if (!state.hasPendingChanges) {
--       dispatch({
--         type: 'RESET',
--         externalValue,
--       });
--     } else {
--       dispatch({
--         type: 'UPDATE',
--         editableValue: state.editableValue,
--         externalValue,
--       });
--     }
--   }

--   return [state, dispatch];
-- }

-- export function useIsOverflowing(
--   containerRef: {current: HTMLDivElement | null, ...},
--   totalChildWidth: number,
-- ): boolean {
--   const [isOverflowing, setIsOverflowing] = useState<boolean>(false);

--   // It's important to use a layout effect, so that we avoid showing a flash of overflowed content.
--   useLayoutEffect(() => {
--     if (containerRef.current === null) {
--       return () => {};
--     }

--     const container = ((containerRef.current: any): HTMLDivElement);

--     const handleResize = throttle(
--       () => setIsOverflowing(container.clientWidth <= totalChildWidth),
--       100,
--     );

--     handleResize();

--     // It's important to listen to the ownerDocument.defaultView to support the browser extension.
--     // Here we use portals to render individual tabs (e.g. Profiler),
--     // and the root document might belong to a different window.
--     const ownerWindow = container.ownerDocument.defaultView;
--     ownerWindow.addEventListener('resize', handleResize);
--     return () => ownerWindow.removeEventListener('resize', handleResize);
--   }, [containerRef, totalChildWidth]);

--   return isOverflowing;
-- }

-- Forked from https://usehooks.com/useLocalStorage/
local function useLocalStorage<T>(key: string, initialValue: T | (() -> T)): (T, (value: T | (() -> T)) -> ())
	local getValueFromLocalStorage = useCallback(function()
		xpcall(function()
			local item = localStorageGetItem(key)
			if item ~= nil then
				return JSON.parse(item)
			end
		end, function(err)
			console.log(error)
		end)
		if type(initialValue) == "function" then
			return ((initialValue :: any) :: () -> T)()
		else
			return initialValue
		end
	end, { initialValue :: any, key })

	local storedValue, setStoredValue = useState(getValueFromLocalStorage :: () -> T)

	local setValue = useCallback(function(value)
		xpcall(function()
			local valueToStore = if type(value) == "function" then (value :: any)(storedValue) else value
			setStoredValue(valueToStore)
			localStorageSetItem(key, JSON.stringify(valueToStore))
		end, function(error)
			console.log(error)
		end)
	end, { key :: any, storedValue })

	-- Listen for changes to this local storage value made from other windows.
	-- This enables the e.g. "⚛️ Elements" tab to update in response to changes from "⚛️ Settings".
	-- useLayoutEffect(function()
	-- 	local function onStorage(event)
	-- 		local newValue = getValueFromLocalStorage()
	-- 		if key == event.key and storedValue ~= newValue then
	-- 			setValue(newValue)
	-- 		end
	-- 	end

	-- 	window.addEventListener("storage", onStorage)

	-- 	return function()
	-- 		window.removeEventListener("storage", onStorage)
	-- 	end
	-- end, { getValueFromLocalStorage, key, storedValue, setValue })

	return storedValue, setValue
end
exports.useLocalStorage = useLocalStorage

-- export function useModalDismissSignal(
--   modalRef: {current: HTMLDivElement | null, ...},
--   dismissCallback: () => void,
--   dismissOnClickOutside?: boolean = true,
-- ): void {
--   useEffect(() => {
--     if (modalRef.current === null) {
--       return () => {};
--     }

--     const handleDocumentKeyDown = ({key}: any) => {
--       if (key === 'Escape') {
--         dismissCallback();
--       }
--     };

--     const handleDocumentClick = (event: any) => {
--       // $FlowFixMe
--       if (
--         modalRef.current !== null &&
--         !modalRef.current.contains(event.target)
--       ) {
--         event.stopPropagation();
--         event.preventDefault();

--         dismissCallback();
--       }
--     };

--     // It's important to listen to the ownerDocument to support the browser extension.
--     // Here we use portals to render individual tabs (e.g. Profiler),
--     // and the root document might belong to a different window.
--     const ownerDocument = modalRef.current.ownerDocument;
--     ownerDocument.addEventListener('keydown', handleDocumentKeyDown);
--     if (dismissOnClickOutside) {
--       ownerDocument.addEventListener('click', handleDocumentClick);
--     }

--     return () => {
--       ownerDocument.removeEventListener('keydown', handleDocumentKeyDown);
--       ownerDocument.removeEventListener('click', handleDocumentClick);
--     };
--   }, [modalRef, dismissCallback, dismissOnClickOutside]);
-- }

-- // Copied from https://github.com/facebook/react/pull/15022
local function useSubscription<Value>(config: {
	getCurrentValue: () -> Value,
	subscribe: (callback: () -> ()) -> () -> (),
}): Value
	local getCurrentValue = config.getCurrentValue
	local subscribe = config.subscribe

	local state, setState = useState({
		getCurrentValue = getCurrentValue,
		subscribe = subscribe,
		value = getCurrentValue(),
	})

	if state.getCurrentValue ~= getCurrentValue or state.subscribe ~= subscribe then
		setState({
			getCurrentValue = getCurrentValue,
			subscribe = subscribe,
			value = getCurrentValue(),
		})
	end

	useEffect(function()
		local didUnsubscribe = false

		local function checkForUpdates()
			if didUnsubscribe then
				return
			end

			setState(function(prevState)
				if prevState.getCurrentValue ~= getCurrentValue or prevState.subscribe ~= subscribe then
					return prevState
				end

				local value = getCurrentValue()
				if prevState.value == value then
					return prevState
				end

				return Object.assign(table.clone(prevState), { value = value })
			end)
		end
		local unsubscribe = subscribe(checkForUpdates)

		checkForUpdates()

		return function()
			didUnsubscribe = true
			unsubscribe()
		end
	end, { getCurrentValue :: any, subscribe })

	return state.value
end
exports.useSubscription = useSubscription

-- export function useHighlightNativeElement() {
--   const bridge = useContext(BridgeContext);
--   const store = useContext(StoreContext);

--   const highlightNativeElement = useCallback(
--     (id: number) => {
--       const element = store.getElementByID(id);
--       const rendererID = store.getRendererIDForElement(id);
--       if (element !== null && rendererID !== null) {
--         bridge.send('highlightNativeElement', {
--           displayName: element.displayName,
--           hideAfterTimeout: false,
--           id,
--           openNativeElementsPanel: false,
--           rendererID,
--           scrollIntoView: false,
--         });
--       }
--     },
--     [store, bridge],
--   );

--   const clearHighlightNativeElement = useCallback(() => {
--     bridge.send('clearNativeElementHighlight');
--   }, [bridge]);

--   return {
--     highlightNativeElement,
--     clearHighlightNativeElement,
--   };
-- }

return exports
