-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/setupTests.js
--[[**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 *
 * LICENSE file in the root directory of this source tree.
 * @flow
 *]]
local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local beforeAll = JestGlobals.beforeAll
local jest = require("@pkg/@jsdotlua/jest-globals").jest
local afterEach = JestGlobals.afterEach

local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Array = LuauPolyfill.Array

local global = _G

type Array<T> = { [number]: T }

beforeAll(function()
	jestExpect.extend({
		toErrorDev = require(Packages.Parent.jest.matchers.toErrorDev),
		toWarnDev = require(Packages.Parent.jest.matchers.toWarnDev),
	})
end)

beforeEach(function()
	-- Fake timers let us flush Bridge operations between setup and assertions.
	jest.useFakeTimers()

	-- These files should be required (and re-required) before each test,
	-- rather than imported at the head of the module.
	-- That's because we reset modules between tests,
	-- which disconnects the DevTool's cache from the current dispatcher ref.
	local Agent = require("./backend/agent")
	local initBackend = require("./backend").initBackend
	local Bridge = require("./bridge")
	local Store = require("./devtools/store")
	local installHook = require("./hook").installHook
	local utils = require("./utils")
	local getDefaultComponentFilters = utils.getDefaultComponentFilters
	local saveComponentFilters = utils.saveComponentFilters

	-- Initialize filters to a known good state.
	saveComponentFilters(getDefaultComponentFilters())
	global.__REACT_DEVTOOLS_COMPONENT_FILTERS__ = getDefaultComponentFilters()

	installHook(global)

	local bridgeListeners = {}
	local bridge = Bridge.new({
		listen = function(callback)
			table.insert(bridgeListeners, callback)
			return function()
				local index = Array.indexOf(bridgeListeners, callback)
				if index >= 0 then
					Array.splice(bridgeListeners, index, 1)
				end
			end
		end,
		send = function(event: string, payload: any, transferable: Array<any>?)
			for _, callback in bridgeListeners do
				callback({ event = event, payload = payload })
			end
		end,
	})

	local agent = Agent.new(bridge)
	local hook = global.__REACT_DEVTOOLS_GLOBAL_HOOK__

	initBackend(hook, agent, global)

	local store = Store.new(bridge)

	global.agent = agent
	global.bridge = bridge
	global.store = store

	local ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags
	ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback = true
end)

afterEach(function()
	global.__REACT_DEVTOOLS_GLOBAL_HOOK__ = nil

	-- It's important to reset modules between test runs;
	-- Without this, ReactDOM won't re-inject itself into the new hook.
	-- It's also important to reset after tests, rather than before,
	-- so that we don't disconnect the ReactCurrentDispatcher ref.
	jest.resetModules()
end)
