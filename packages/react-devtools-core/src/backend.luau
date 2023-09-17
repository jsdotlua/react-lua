--!strict
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
-- todo: use console from react shared
local console = LuauPolyfill.console
local setTimeout = LuauPolyfill.setTimeout
type Timeout = LuauPolyfill.Timeout
type Array<T> = LuauPolyfill.Array
type Function = (any) -> any?

local exports = {}

local ReactDevtoolsShared = require(Packages.ReactDevtoolsShared)
local Agent = ReactDevtoolsShared.backend.agent
local Bridge = ReactDevtoolsShared.bridge
local installHook = ReactDevtoolsShared.hook.installHook
local initBackend = ReactDevtoolsShared.backend.initBackend
-- import {__DEBUG__} from 'react-devtools-shared/src/constants';
local __DEBUG__ = true
-- import setupNativeStyleEditor from 'react-devtools-shared/src/backend/NativeStyleEditor/setupNativeStyleEditor';
-- import {getDefaultComponentFilters} from 'react-devtools-shared/src/utils';

-- import type {BackendBridge} from 'react-devtools-shared/src/bridge';
-- import type {ComponentFilter} from 'react-devtools-shared/src/types';
-- import type {DevToolsHook} from 'react-devtools-shared/src/backend/types';
-- import type {ResolveNativeStyle} from 'react-devtools-shared/src/backend/NativeStyleEditor/setupNativeStyleEditor';

type ConnectOptions = {
	host: string?,
	nativeStyleEditorValidAttributes: Array<string>?,
	port: number?,
	useHttps: boolean?,
	resolveRNStyle: ResolveNativeStyle?,
	isAppActive: (() -> boolean)?,
	websocket: WebSocket?,
	--   ...
}

-- installHook(window);
installHook(_G)

local hook: DevToolsHook? = _G.__REACT_DEVTOOLS_GLOBAL_HOOK__

-- let savedComponentFilters: Array<ComponentFilter> = getDefaultComponentFilters();

local function debug(methodName: string, ...)
	if __DEBUG__ then
		local args = {}
		local totalArgs = select("#", ...)
		for i = 1, totalArgs do
			table.insert(args, LuauPolyfill.util.inspect((select(i, ...)), { depth =  5 }))
		end
		console.log(`[core/backend] {methodName}` .. string.rep(" %s", totalArgs), unpack(args))
	end
end

local function connectToDevTools(options: ConnectOptions?)
	if hook == nil then
		-- DevTools didn't get injected into this page (maybe b'c of the contentType).
		-- todo remove warning
		warn("DevTools didn't get injected into this page")
		return
	end
	print("Connect to devtools!")
	--   local {
	--     host = 'localhost',
	--     nativeStyleEditorValidAttributes,
	--     useHttps = false,
	--     port = 8097,
	--     websocket,
	--     resolveRNStyle = nil,
	--     isAppActive = () => true,
	--   } = options || {};

	--   local protocol = if useHttps then 'wss' then 'ws';
	local retryTimeoutID: Timeout | nil = nil

	local function scheduleRetry()
		if retryTimeoutID == nil then
			-- Two seconds because RN had issues with quick retries.
			retryTimeoutID = setTimeout(function()
				connectToDevTools(options)
				-- deviation: retry more often
			end, 1000)
		end
	end

	--   if (!isAppActive()) {
	--     // If the app is in background, maybe retry later.
	--     // Don't actually attempt to connect until we're in foreground.
	--     scheduleRetry();
	--     return;
	--   }

	local bridge: BackendBridge | nil = nil

	local messageListeners: { (any) -> () } = {}

	-- deviation: setup Roblox bindable event
	do
		local bindableToFrontend = ReplicatedStorage:FindFirstChild("ReactDevtoolsFrontendBindable")
		local bindableToBackend = ReplicatedStorage:FindFirstChild("ReactDevtoolsBackendBindable")
		if
			bindableToFrontend == nil
			or bindableToBackend == nil
			or not bindableToFrontend:IsA("BindableEvent")
			or not bindableToBackend:IsA("BindableEvent")
		then
			scheduleRetry()
			return
		end

		bindableToBackend.Event:Connect(function(data)
			for _, fn in messageListeners do
				local success, err: any = pcall(fn, data)
				if not success then
					-- jsc doesn't play so well with tracebacks that go into eval'd code,
					-- so the stack trace here will stop at the `eval()` call. Getting the
					-- message that caused the error is the best we can do for now.
					console.log("[React DevTools] Error calling listener", data)
					console.log("error:", err)
					error(err)
				end
			end
		end)
		bridge = Bridge.new({
			listen = function(fn)
				table.insert(messageListeners, fn)
				return function()
					local index = Array.indexOf(messageListeners, fn)
					if index >= 0 then
						Array.splice(messageListeners, index, 1)
					end
				end
			end,
			send = function(event: string, payload: any, transferable: Array<any>?)
				if __DEBUG__ then
					debug("wall.send()", event, payload)
				end

				bindableToFrontend:Fire({ event = event, payload = payload })
			end,
		})
	end

	--   local uri = protocol + '://' + host + ':' + port;

	--   -- If existing websocket is passed, use it.
	--   -- This is necessary to support our custom integrations.
	--   -- See D6251744.
	--   local ws = websocket ? websocket : new window.WebSocket(uri);
	--   ws.onclose = handleClose;
	--   ws.onerror = handleFailed;
	--   ws.onmessage = handleMessage;
	--   ws.onopen = function() {
	--     bridge = new Bridge({
	--       listen(fn) {
	--         messageListeners.push(fn);
	--         return () => {
	--           local index = messageListeners.indexOf(fn);
	--           if (index >= 0) {
	--             messageListeners.splice(index, 1);
	--           }
	--         };
	--       },
	--       send(event: string, payload: any, transferable?: Array<any>) {
	--         if (ws.readyState == ws.OPEN) {
	--           if (__DEBUG__) {
	--             debug('wall.send()', event, payload);
	--           }

	--           ws.send(JSON.stringify({event, payload}));
	--         } else {
	--           if (__DEBUG__) {
	--             debug(
	--               'wall.send()',
	--               'Shutting down bridge because of closed WebSocket connection',
	--             );
	--           }

	--           if (bridge !== null) {
	--             bridge.shutdown();
	--           }

	--           scheduleRetry();
	--         }
	--       },
	--     });
	--     bridge:addListener(
	--       'inspectElement',
	--       ({id, rendererID}: {id: number, rendererID: number, ...}) => {
	--         local renderer = agent.rendererInterfaces[rendererID];
	--         if (renderer != null) {
	--           -- Send event for RN to highlight.
	--           local nodes: ?Array<HTMLElement> = renderer.findNativeNodesForFiberID(
	--             id,
	--           );
	--           if (nodes != null && nodes[0] != null) {
	--             agent.emit('showNativeHighlight', nodes[0]);
	--           }
	--         }
	--       },
	--     );
	--     bridge:addListener(
	--       'updateComponentFilters',
	--       (componentFilters: Array<ComponentFilter>) => {
	--         -- Save filter changes in memory, in case DevTools is reloaded.
	--         -- In that case, the renderer will already be using the updated values.
	--         -- We'll lose these in between backend reloads but that can't be helped.
	--         savedComponentFilters = componentFilters;
	--       },
	--     );

	-- The renderer interface doesn't read saved component filters directly,
	-- because they are generally stored in localStorage within the context of the extension.
	-- Because of this it relies on the extension to pass filters.
	-- In the case of the standalone DevTools being used with a website,
	-- saved filters are injected along with the backend script tag so we shouldn't override them here.
	-- This injection strategy doesn't work for React Native though.
	-- Ideally the backend would save the filters itself, but RN doesn't provide a sync storage solution.
	-- So for now we just fall back to using the default filters...

	-- todo:
	-- if window.__REACT_DEVTOOLS_COMPONENT_FILTERS__ == nil then
	-- 	bridge:send("overrideComponentFilters", savedComponentFilters)
	-- end

	-- TODO (npm-packages) Warn if "isBackendStorageAPISupported"
	local agent = Agent.new(bridge)
	agent:addListener("shutdown", function()
		-- If we received 'shutdown' from `agent`, we assume the `bridge` is already shutting down,
		-- and that caused the 'shutdown' event on the `agent`, so we don't need to call `bridge:shutdown()` here.
		hook.emit("shutdown")
	end)

	initBackend(
		hook,
		agent,
		-- deviation: use _G instead of window
		-- window
		_G
	)

	-- Setup React Native style editor if the environment supports it.
	--     if (resolveRNStyle != null || hook.resolveRNStyle != null) {
	--       setupNativeStyleEditor(
	--         bridge,
	--         agent,
	--         ((resolveRNStyle || hook.resolveRNStyle: any): ResolveNativeStyle),
	--         nativeStyleEditorValidAttributes ||
	--           hook.nativeStyleEditorValidAttributes ||
	--           null,
	--       );
	--     } else {
	--       -- Otherwise listen to detect if the environment later supports it.
	--       -- For example, Flipper does not eagerly inject these values.
	--       -- Instead it relies on the React Native Inspector to lazily inject them.
	--       let lazyResolveRNStyle;
	--       let lazyNativeStyleEditorValidAttributes;

	--       local initAfterTick = () => {
	--         if (bridge !== null) {
	--           setupNativeStyleEditor(
	--             bridge,
	--             agent,
	--             lazyResolveRNStyle,
	--             lazyNativeStyleEditorValidAttributes,
	--           );
	--         }
	--       };

	--       if (!hook.hasOwnProperty('resolveRNStyle')) {
	--         Object.defineProperty(
	--           hook,
	--           'resolveRNStyle',
	--           ({
	--             enumerable: false,
	--             get() {
	--               return lazyResolveRNStyle;
	--             },
	--             set(value) {
	--               lazyResolveRNStyle = value;
	--               initAfterTick();
	--             },
	--           }: Object),
	--         );
	--       }
	--       if (!hook.hasOwnProperty('nativeStyleEditorValidAttributes')) {
	--         Object.defineProperty(
	--           hook,
	--           'nativeStyleEditorValidAttributes',
	--           ({
	--             enumerable: false,
	--             get() {
	--               return lazyNativeStyleEditorValidAttributes;
	--             },
	--             set(value) {
	--               lazyNativeStyleEditorValidAttributes = value;
	--               initAfterTick();
	--             },
	--           }: Object),
	--         );
	--       }
	--     }
	--   };

	-- local function handleClose()
	-- 	if __DEBUG__ then
	-- 		debug("WebSocket.onclose")
	-- 	end

	-- 	if bridge ~= nil then
	-- 		bridge.emit("shutdown")
	-- 	end

	-- 	scheduleRetry()
	-- end

	-- local function handleFailed()
	-- 	if __DEBUG__ then
	-- 		debug("WebSocket.onerror")
	-- 	end

	-- 	scheduleRetry()
	-- end

	-- local function handleMessage(event)
	-- 	local data
	--     try {
	--       if (typeof event.data == 'string') {
	--         data = JSON.parse(event.data);
	--         if (__DEBUG__) {
	--           debug('WebSocket.onmessage', data);
	--         }
	--       } else {
	--         throw Error();
	--       }
	--     } catch (e) {
	--       console.error(
	--         '[React DevTools] Failed to parse JSON: ' + (event.data: any),
	--       );
	--       return;
	--     }
	--     messageListeners.forEach(fn => {
	--       try {
	--         fn(data);
	--       } catch (error) {
	--         // jsc doesn't play so well with tracebacks that go into eval'd code,
	--         // so the stack trace here will stop at the `eval()` call. Getting the
	--         // message that caused the error is the best we can do for now.
	--         console.log('[React DevTools] Error calling listener', data);
	--         console.log('error:', error);
	--         throw error;
	--       }
	--     });
	-- end
end
exports.connectToDevTools = connectToDevTools

return exports
