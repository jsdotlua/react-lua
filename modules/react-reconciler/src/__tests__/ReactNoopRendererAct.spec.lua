-- ROBLOX upstream: https://github.com/facebook/react/blob/d17086c7c813402a550d15a2f56dc43f1dbd1735/packages/react-reconciler/src/__tests__/ReactNoopRendererAct-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @jest-environment node
 ]]

-- sanity tests for ReactNoop.act()

local Packages = script.Parent.Parent.Parent
local React
local ReactNoop
local Scheduler

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local Promise = require("@pkg/@jsdotlua/promise")
local jestExpect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it
local jest = JestGlobals.jest

beforeEach(function()
	jest.resetModules()

	React = require("@pkg/@jsdotlua/react")
	ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
	Scheduler = require("@pkg/@jsdotlua/scheduler")
end)

it("can use act to flush effects", function()
	local function App(props)
		React.useEffect(props.callback)
		return nil
	end

	local calledLog = {}
	ReactNoop.act(function()
		ReactNoop.render(React.createElement(App, {
			callback = function()
				table.insert(calledLog, #calledLog)
			end,
		}))
	end)
	jestExpect(Scheduler).toFlushWithoutYielding()
	jestExpect(calledLog).toEqual({ 0 })
end)
it("should work with async/await", function()
	local function App()
		local ctr, setCtr = React.useState(0)
		local function someAsyncFunction()
			Scheduler.unstable_yieldValue("stage 1")
			Scheduler.unstable_yieldValue("stage 2")
			setCtr(1)
		end
		React.useEffect(function()
			someAsyncFunction()
		end, {})
		return ctr
	end
	Promise.try(function()
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(App))
		end)
	end):await()
	jestExpect(Scheduler).toHaveYielded({ "stage 1", "stage 2" })
	jestExpect(Scheduler).toFlushWithoutYielding()
	jestExpect(ReactNoop.getChildren()).toEqual({ { text = "1", hidden = false } })
end)
