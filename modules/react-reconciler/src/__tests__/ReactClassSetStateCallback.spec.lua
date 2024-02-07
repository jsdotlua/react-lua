<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/d7dce572c7453737a685e791e7afcbc7e2b2fe16/packages/react-reconciler/src/__tests__/ReactClassSetStateCallback-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 * @jest-environment node
]]

--[[ eslint-disable no-func-assign ]]
local Packages = script.Parent.Parent.Parent
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/__tests__/ReactClassSetStateCallback-test.js
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
type Object = LuauPolyfill.Object
local Promise = require(Packages.Promise)
>>>>>>> upstream-apply
local React

local ReactNoop
local Scheduler

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it
local jest = JestGlobals.jest

beforeEach(function()
	jest.resetModules()
	jest.useFakeTimers()

	React = require("@pkg/@jsdotlua/react")
	ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
	Scheduler = require("@pkg/@jsdotlua/scheduler")
end)

local function Text(props)
	Scheduler.unstable_yieldValue(props.text)
	return React.createElement("span", {
		prop = props.text,
	})
end

it(
	"regression: setState callback (2nd arg) should only fire once, even after a rebase",
	function()
		local app
		local App = React.Component:extend("App")
		function App:init()
			self:setState({ step = 0 })
		end
		function App:render()
			app = self
			return React.createElement(Text, { text = self.state.step })
		end

		local root = ReactNoop.createRoot()
		ReactNoop.act(function()
			root.render(React.createElement(App))
		end)
		jestExpect(Scheduler).toHaveYielded({ 0 })

		ReactNoop.act(function()
			app:setState({ step = 1 }, function()
				return Scheduler.unstable_yieldValue("Callback 1")
			end)

			ReactNoop.flushSync(function()
				app:setState({ step = 2 }, function()
					return Scheduler.unstable_yieldValue("Callback 2")
				end)
			end)
		end)
		jestExpect(Scheduler).toHaveYielded({ 2, "Callback 2", 2, "Callback 1" })
	end
)
