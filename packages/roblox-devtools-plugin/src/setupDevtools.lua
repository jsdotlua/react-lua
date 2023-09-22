local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = script.Parent.Packages

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
type Array<T> = LuauPolyfill.Array<T>

local React = require(Packages.React)
local ReactDevtoolsShared = require(Packages.ReactDevtoolsShared)

local installHook = ReactDevtoolsShared.hook.installHook
-- local initBackend = ReactDevtoolsShared.backend.initBackend
-- local Agent = ReactDevtoolsShared.backend.agent
local Bridge = ReactDevtoolsShared.bridge
local Store = ReactDevtoolsShared.devtools.store
type Store = ReactDevtoolsShared.Store

installHook(_G)

local frontendBindable: BindableEvent = ReplicatedStorage:FindFirstChild("ReactDevtoolsFrontendBindable")
local backendBindable: BindableEvent = ReplicatedStorage:FindFirstChild("ReactDevtoolsBackendBindable")

local function setupDevtools(): { bridge: any, store: Store }?
	local hook: DevToolsHook? = _G.__REACT_DEVTOOLS_GLOBAL_HOOK__

	if hook == nil then
		return nil
	end

	if (frontendBindable :: BindableEvent?) == nil then
		frontendBindable = Instance.new("BindableEvent")
		frontendBindable.Name = "ReactDevtoolsFrontendBindable"
		frontendBindable.Parent = ReplicatedStorage
	end

	if (backendBindable :: BindableEvent?) == nil then
		backendBindable = Instance.new("BindableEvent")
		backendBindable.Name = "ReactDevtoolsBackendBindable"
		backendBindable.Parent = ReplicatedStorage
	end

	local listeners: { (any) -> () } = {}

	-- socket.onmessage
	frontendBindable.Event:Connect(function(event)
		-- print("[plugin] received event", event)
		local data = event
		-- local data = event.data
		--   try {
		--     if (typeof event.data === 'string') {
		--       data = JSON.parse(event.data);

		--       if (__DEBUG__) {
		--         debug('WebSocket.onmessage', data);
		--       }
		--     } else {
		--       throw Error();
		--     }
		--   } catch (e) {
		--     log.error('Failed to parse JSON', event.data);
		--     return;
		--   }

		for _, fn in listeners do
			local success, err: any = pcall(fn, data)
			if not success then
				-- log.error('Error calling listener', data);
				warn("Error calling listener: " .. tostring(err))
			end
		end
	end)

	local bridge = Bridge.new({
		listen = function(fn)
			-- print("[plugin] add listener")
			table.insert(listeners, fn)
			return function()
				local index = Array.indexOf(listeners, fn)
				if index >= 1 then
					Array.splice(listeners, index, 2)
				end
			end
		end,
		send = function(event: string, payload: any, transferable: Array<any>?)
			-- send to backend!
			-- socket.send(JSON.stringify({event, payload}));
			if (backendBindable :: BindableEvent?) == nil then
				warn("skip sending to backend", event, payload)
			else
				-- print("[plugin] send", event, payload)
				backendBindable:Fire({ event = event, payload = payload })
			end
		end,
	})

	-- print("create plugin bridge")
	frontendBindable:SetAttribute("Ready", true)

	local store = Store.new(bridge, {
		supportsNativeInspection = false,
		-- supportsProfiling = true,
	})

	-- print("\n>>> Fire frontend bindable begin signal\n")

	-- log("Connected")
	-- reload()

	-- local agent = Agent.new(bridge)
	-- agent:addListener("shutdown", function()
	-- 	-- If we received 'shutdown' from `agent`, we assume the `bridge` is already shutting down,
	-- 	-- and that caused the 'shutdown' event on the `agent`, so we don't need to call `bridge.shutdown()` here.
	-- 	hook.emit("shutdown")
	-- end)

	-- initBackend(hook, agent, _G)

	return {
		bridge = bridge,
		store = store,
	}
end

return setupDevtools
