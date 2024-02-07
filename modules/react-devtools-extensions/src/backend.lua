<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.2/packages/react-devtools-extensions/src/backend.js
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-devtools-extensions/src/backend.js
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
>>>>>>> upstream-apply
-- ROBLOX deviation START: not needed
-- local Boolean = LuauPolyfill.Boolean
-- ROBLOX deviation END
local console = LuauPolyfill.console
type Array<T> = LuauPolyfill.Array<T>
-- Do not use imports or top-level requires here!
-- Running module factories is intentionally delayed until we know the hook exists.
-- This is to avoid issues like: https://github.com/facebook/react-devtools/issues/1039
<<<<<<< HEAD
--[[* @flow ]]

-- ROBLOX deviation START: not needed
-- local function welcome(event)
-- 	if event.source ~= window or event.data.source ~= "react-devtools-content-script" then
-- 		return
-- 	end
-- 	window:removeEventListener("message", welcome)
-- 	setup(window.__REACT_DEVTOOLS_GLOBAL_HOOK__)
-- end
-- window:addEventListener("message", welcome)
-- ROBLOX deviation END
-- ROBLOX deviation START: add types for BridgeListener
type BridgeEvent = {
	source: string,
	event: any,
	payload: any,
}
type BridgeListener = (BridgeEvent) -> ()
-- ROBLOX deviation END
=======
-- @flow strict-local
local welcomeHasInitialized = false
local function welcome(event)
	if event.source ~= window or event.data.source ~= "react-devtools-content-script" then
		return
	end -- In some circumstances, this method is called more than once for a single welcome message.
	-- The exact circumstances of this are unclear, though it seems related to 3rd party event batching code.
	--
	-- Regardless, call this method multiple times can cause DevTools to add duplicate elements to the Store
	-- (and throw an error) or worse yet, choke up entirely and freeze the browser.
	--
	-- The simplest solution is to ignore the duplicate events.
	-- To be clear, this SHOULD NOT BE NECESSARY, since we remove the event handler below.
	--
	-- See https://github.com/facebook/react/issues/24162
	if Boolean.toJSBoolean(welcomeHasInitialized) then
		console.warn('React DevTools detected duplicate welcome "message" events from the content script.')
		return
	end
	welcomeHasInitialized = true
	window:removeEventListener("message", welcome)
	setup(window.__REACT_DEVTOOLS_GLOBAL_HOOK__)
end
window:addEventListener("message", welcome)
>>>>>>> upstream-apply
local function setup(hook)
	-- ROBLOX deviation START: add bridgeListeners instead of listening to messages
	local bridgeListeners: Array<BridgeListener> = {}
	-- ROBLOX deviation END
	-- ROBLOX deviation START: not needed
	-- if
	-- 	hook == nil --[[ ROBLOX CHECK: loose equality used upstream ]]
	-- then
	-- 	-- DevTools didn't get injected into this page (maybe b'c of the contentType).
	-- 	return
	-- end
	-- ROBLOX deviation END
	-- ROBLOX deviation START: fix imports
	-- local Agent = require_("react-devtools-shared/src/backend/agent").default
	-- local Bridge = require_("react-devtools-shared/src/bridge").default
	-- local initBackend = require_("react-devtools-shared/src/backend").initBackend
	local ReactDevtoolsShared = require("@pkg/@jsdotlua/react-devtools-shared")
	local backend = ReactDevtoolsShared.backend
	local Agent = backend.agent
	local Bridge = ReactDevtoolsShared.bridge
	local initBackend = backend.initBackend
	-- ROBLOX deviation END
	-- ROBLOX deviation START: not needed
	-- local setupNativeStyleEditor = require_(
	-- 	"react-devtools-shared/src/backend/NativeStyleEditor/setupNativeStyleEditor"
	-- ).default
	-- ROBLOX deviation END
	local bridge = Bridge.new({
		-- ROBLOX deviation START: no self param needed
		-- listen = function(self, fn)
		listen = function(fn: BridgeListener)
			-- ROBLOX deviation END
			-- ROBLOX deviation START: Because we don't listen for all messages on window like in browser, we don't need to verify their source
			-- local function listener(event)
			-- 	if
			-- 		event.source ~= window
			-- 		or not Boolean.toJSBoolean(event.data)
			-- 		or event.data.source ~= "react-devtools-content-script"
			-- 		or not Boolean.toJSBoolean(event.data.payload)
			-- 	then
			-- 		return
			-- 	end
			-- 	fn(event.data.payload)
			-- end
			-- window:addEventListener("message", listener)
			-- return function()
			-- 	window:removeEventListener("message", listener)
			-- end
			table.insert(bridgeListeners, fn)
			return function()
				for index, value in bridgeListeners do
					if value == fn then
						table.remove(bridgeListeners, index)
						return
					end
				end
			end
			-- ROBLOX deviation END
		end,
		-- ROBLOX deviation START: no self param needed
		-- send = function(self, event: string, payload: any, transferable: Array<any>?)
		send = function(event: string, payload: any, transferable: Array<any>?)
			-- ROBLOX deviation END
			-- ROBLOX deviation START: custom implementation
			-- window:postMessage({
			-- 	source = "react-devtools-bridge",
			-- 	payload = { event = event, payload = payload },
			-- }, "*", transferable)
			for _, fn in bridgeListeners do
				fn({
					source = "react-devtools-bridge",
					event = event,
					payload = payload,
				})
			end
			-- ROBLOX deviation END
		end,
	})
	local agent = Agent.new(bridge)
	agent:addListener("shutdown", function()
		-- If we received 'shutdown' from `agent`, we assume the `bridge` is already shutting down,
		-- and that caused the 'shutdown' event on the `agent`, so we don't need to call `bridge.shutdown()` here.
		-- ROBLOX deviation START: use dot notation
		-- hook:emit("shutdown")
		hook.emit("shutdown")
		-- ROBLOX deviation END
	end)
	-- ROBLOX deviation START: use _G instead of window
	-- initBackend(hook, agent, window) -- Let the frontend know that the backend has attached listeners and is ready for messages.
	initBackend(hook, agent, _G)
	-- ROBLOX deviation END
	-- This covers the case of syncing saved values after reloading/navigating while DevTools remain open.
	bridge:send("extensionBackendInitialized") -- Setup React Native style editor if a renderer like react-native-web has injected it.
	-- ROBLOX deviation START: not needed
	-- if Boolean.toJSBoolean(hook.resolveRNStyle) then
	-- 	setupNativeStyleEditor(
	-- 		bridge,
	-- 		agent,
	-- 		hook.resolveRNStyle,
	-- 		hook.nativeStyleEditorValidAttributes
	-- 	)
	-- end
	-- ROBLOX deviation END
	-- ROBLOX deviation START: add return
	return {
		agent = agent,
		hook = hook,
		bridge = bridge,
	}
	-- ROBLOX deviation END
end

-- ROBLOX deviation START: add return
return {
	setup = setup,
}
-- ROBLOX deviation END
