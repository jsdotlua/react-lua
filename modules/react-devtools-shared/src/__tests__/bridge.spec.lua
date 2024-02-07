-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-devtools-shared/src/__tests__/bridge-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
]]
local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local jestExpect = JestGlobals.expect
local jest = JestGlobals.jest

describe("bridge", function()
	local Bridge

	beforeEach(function()
<<<<<<< HEAD
		jest.resetModules()
		jest.useFakeTimers()
		Bridge = require("./bridge")
	end)

=======
		Bridge = require_("react-devtools-shared/src/bridge").default
	end) -- @reactVersion >=16.0
>>>>>>> upstream-apply
	it("should shutdown properly", function()
		local wall = {
			listen = jest.fn(function()
				return function() end
			end),
			send = jest.fn(),
		}
		local bridge = Bridge.new(wall)

		-- Check that we're wired up correctly.
		bridge:send("reloadAppForProfiling")
		jest.runAllTimers()
		jestExpect(wall.send).toHaveBeenCalledWith("reloadAppForProfiling")

		-- Should flush pending messages and then shut down.
		wall.send.mockClear()
		bridge:send("update", "1")
		bridge:send("update", "2")
		bridge:shutdown()
		jest.runAllTimers()
		jestExpect(wall.send).toHaveBeenCalledWith("update", "1")
		jestExpect(wall.send).toHaveBeenCalledWith("update", "2")
		jestExpect(wall.send).toHaveBeenCalledWith("shutdown")

		-- Verify that the Bridge doesn't send messages after shutdown.

		wall.send.mockClear()
		-- ROBLOX deviation: instead of spying on console, use toWarnDev matcher
		jestExpect(function()
			bridge:send("should not send")
		end).toWarnDev(
			'Cannot send message "should not send" through a Bridge that has been shutdown.',
			{ withoutStack = true }
		)
		jest.runAllTimers()
		jestExpect(wall.send).never.toHaveBeenCalled()
	end)
end)
