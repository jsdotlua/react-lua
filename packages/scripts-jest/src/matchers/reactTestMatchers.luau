--!strict
--[[
	Lua upstream: https://github.com/facebook/react/blob/69060e1da6061af845162dcf6854a5d9af28350a/scripts/jest/matchers/reactTestMatchers.js

	Note: this file is partially redundant with modules/scheduler/src/schedulerTestMatchers.lua
	That is also happening upstream: https://github.com/facebook/react/blob/47ff31a77add22bef54aaed9d4fb62d5aa693afd/scripts/jest/matchers/schedulerTestMatchers.js
]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error

--[[**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *]]

-- Lua TODO: upstream this explicit import, possible in Jest 27+
local expect = require(Packages.JestGlobals).expect
local JestReact = require(Packages.JestReact)
local SchedulerMatchers = require(script.Parent.schedulerTestMatchers)

local function captureAssertion(fn): { pass: true, message: nil } | { pass: false, message: () -> string }
	-- Trick to use a Jest matcher inside another Jest matcher. `fn` contains an
	-- assertion; if it throws, we capture the error and return it, so the stack
	-- trace presented to the user points to the original assertion in the
	-- test file.
	local ok, result = pcall(fn)

	if not ok then
		-- Lua deviation: The message here will be a string with some extra info
		-- that's not helpful, so we trim it down a bit
		local stringResult = tostring(result)
		local subMessageIndex = string.find(stringResult, " ")
		-- Lua TODO: upstream this assert, it could technically happen and is needed to silence strict type checking
		assert(subMessageIndex, "assertion failure error not in expected format")
		local message = string.sub(stringResult, subMessageIndex + 1)

		return {
			pass = false,
			message = function()
				return message
			end,
		}
	end

	return { pass = true }
end

local function assertYieldsWereCleared(Scheduler)
	local actualYields = Scheduler.unstable_clearYields()

	if #actualYields ~= 0 then
		error(
			Error.new("Log of yielded values is not empty. " .. "Call expect(Scheduler).toHaveYielded(...) first."),
			3
		)
	end
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toMatchRenderedOutput(_matcherContext, ReactNoop, expectedJSX)
	if type(ReactNoop.getChildrenAsJSX) == "function" then
		local Scheduler = ReactNoop._Scheduler
		assertYieldsWereCleared(Scheduler)
		return captureAssertion(function()
			expect(ReactNoop.getChildrenAsJSX()).toEqual(expectedJSX)
		end)
	end
	return JestReact.unstable_toMatchRenderedOutput(ReactNoop, expectedJSX)
end

local exports = table.clone(SchedulerMatchers)
exports.toMatchRenderedOutput = toMatchRenderedOutput
return exports
