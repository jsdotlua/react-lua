-- upstream: https://github.com/facebook/react/blob/9abc2785cb070148d64fae81e523246b90b92016/packages/scheduler/src/__tests__/Tracing-test.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @jest-environment node
--  */

local Packages = script.Parent.Parent.Parent
local LuaJest = require(Packages.Dev.LuaJest)

return function()
	describe("Tracing", function()
		local JestGlobals = require(Packages.Dev.JestGlobals)
		local expect = JestGlobals.expect

		local SchedulerTracing

		beforeEach(function()
			LuaJest.resetModules()

			SchedulerTracing = require(Packages.Scheduler).tracing
		end)

		it("should return the value of a traced function", function()
			expect(SchedulerTracing.unstable_trace("arbitrary", 0, function()
				return 123
			end)).toBe(123)
		end)

		it("should return the value of a wrapped function", function()
			local wrapped
			SchedulerTracing.unstable_trace("arbitrary", 0, function()
				wrapped = SchedulerTracing.unstable_wrap(function()
					return 123
				end)
			end)
			expect(wrapped()).toBe(123)
		end)

		it("should execute traced callbacks", function()
			local done = false

			SchedulerTracing.unstable_trace("some event", 0, function()
				done = true
			end)

			expect(done).toBe(true)
		end)

		it("should return the value of a clear function", function()
			expect(SchedulerTracing.unstable_clear(function()
				return 123
			end)).toBe(123)
		end)

		it("should execute wrapped callbacks", function()
			local done = false
			local wrappedCallback = SchedulerTracing.unstable_wrap(function()
				done = true
			end)

			wrappedCallback()
			expect(done).toBe(true)
		end)
	end)
end
