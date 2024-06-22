-- ROBLOX upstream: https://github.com/facebook/react/blob/69060e1da6061af845162dcf6854a5d9af28350a/packages/react-reconciler/src/__tests__/ReactTopLevelText-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 * @jest-environment node
]]
--!strict

local Packages = script.Parent.Parent.Parent
local React
local ReactNoop
local Scheduler

-- This is a new feature in Fiber so I put it in its own test file. It could
-- probably move to one of the other test files once it is official.
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it
local jest = JestGlobals.jest
local describe = JestGlobals.describe

describe("ReactTopLevelText", function()
	beforeEach(function()
		jest.resetModules()

		React = require("@pkg/@jsdotlua/react")
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		Scheduler = require("@pkg/@jsdotlua/scheduler")
	end)

	it("should render a component returning strings directly from render", function()
		local Text = function(props)
			return props.value
		end
		ReactNoop.render(React.createElement(Text, { value = "foo" }))
		jestExpect(Scheduler).toFlushWithoutYielding()

		jestExpect(ReactNoop).toMatchRenderedOutput("foo")
	end)

	it("should render a component returning numbers directly from renderß", function()
		local Text = function(props)
			return props.value
		end
		ReactNoop.render(React.createElement(Text, { value = 10 }))
		jestExpect(Scheduler).toFlushWithoutYielding()

		jestExpect(ReactNoop).toMatchRenderedOutput("10")
	end)
end)
