-- upstream: https://github.com/facebook/react/blob/3e94bce765d355d74f6a60feb4addb6d196e3482/packages/scheduler/src/__tests__/SchedulerNoDOM-test.js
--[[*
* Copyright (c) Facebook, Inc. and its affiliates.
*
* This source code is licensed under the MIT license found in the
* LICENSE file in the root directory of this source tree.
*
* @emails react-core
]]

return function()
	local Packages = script.Parent.Parent.Parent
	local expect = require(Packages.Dev.JestGlobals).expect
	local LuaJest = require(Packages.Dev.LuaJest)

	local scheduleCallback
	local ImmediatePriority
	local UserBlockingPriority
	local NormalPriority

	beforeEach(function()
		LuaJest.resetModules()
		LuaJest.useFakeTimers()
		local Scheduler = require(script.Parent.Parent.Scheduler)()

		scheduleCallback = Scheduler.unstable_scheduleCallback
		ImmediatePriority = Scheduler.unstable_ImmediatePriority
		UserBlockingPriority = Scheduler.unstable_UserBlockingPriority
		NormalPriority = Scheduler.unstable_NormalPriority
	end)

	it("runAllTimers flushes all scheduled callbacks", function()
		local log = {}
		scheduleCallback(NormalPriority, function()
			table.insert(log, "A")
		end)
		scheduleCallback(NormalPriority, function()
			table.insert(log, "B")
		end)
		scheduleCallback(NormalPriority, function()
			table.insert(log, "C")
		end)

		expect(log).toEqual({})

		LuaJest.runAllTimers()

		expect(log).toEqual({ "A", "B", "C" })
	end)

	it("executes callbacks in order of priority", function()
		local log = {}

		scheduleCallback(NormalPriority, function()
			table.insert(log, "A")
		end)
		scheduleCallback(NormalPriority, function()
			table.insert(log, "B")
		end)
		scheduleCallback(UserBlockingPriority, function()
			table.insert(log, "C")
		end)
		scheduleCallback(UserBlockingPriority, function()
			table.insert(log, "D")
		end)

		expect(log).toEqual({})
		LuaJest.runAllTimers()
		expect(log).toEqual({ "C", "D", "A", "B" })
	end)

	it("handles errors", function()
		local log = {}

		scheduleCallback(ImmediatePriority, function()
			table.insert(log, "A")
			error("Oops A")
		end)
		scheduleCallback(ImmediatePriority, function()
			table.insert(log, "B")
		end)
		scheduleCallback(ImmediatePriority, function()
			table.insert(log, "C")
			error("Oops C")
		end)

		expect(LuaJest.runAllTimers).toThrow("Oops A")
		expect(log).toEqual({ "A" })

		log = {}

		-- B and C flush in a subsequent event. That way, the second error is not
		-- swallowed.
		expect(function()
			LuaJest.runAllTimers()
		end).toThrow("Oops C")
		expect(log).toEqual({ "B", "C" })
	end)
end
