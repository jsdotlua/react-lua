--!strict
-- Lua upstream: https://github.com/facebook/react/blob/47ff31a77add22bef54aaed9d4fb62d5aa693afd/scripts/jest/matchers/schedulerTestMatchers.js
--[[**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *]]
-- Lua TODO: upstream these are repo-level scripts, move them into a private package called jest to match

local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<T> = LuauPolyfill.Array<T>
local Error = LuauPolyfill.Error

 -- Lua TODO: upstream this explicit import, possible in Jest 27+
 local expect = require(Packages.JestGlobals).expect

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
        error(Error.new(
            "Log of yielded values is not empty. "
                .. "Call expect(Scheduler).toHaveYielded(...) first."),
            3
        )
    end
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toFlushAndYield(
    _matcherContext,
    Scheduler,
    expectedYields
)
    assertYieldsWereCleared(Scheduler)
    Scheduler.unstable_flushAllWithoutAsserting()
    local actualYields = Scheduler.unstable_clearYields()

    return captureAssertion(function()
        expect(actualYields).toEqual(expectedYields)
    end)
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toFlushAndYieldThrough(
    _matcherContext,
    Scheduler,
    expectedYields
)
    assertYieldsWereCleared(Scheduler)
    Scheduler.unstable_flushNumberOfYields(#expectedYields)
    local actualYields = Scheduler.unstable_clearYields()

    return captureAssertion(function()
        expect(actualYields).toEqual(expectedYields)
    end)
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toFlushUntilNextPaint(
    _matcherContext,
    Scheduler,
    expectedYields: Array<any>
)
    assertYieldsWereCleared(Scheduler)
    Scheduler.unstable_flushUntilNextPaint()
    local actualYields = Scheduler.unstable_clearYields()
    return captureAssertion(function()
        expect(actualYields).toEqual(expectedYields)
    end)
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toFlushWithoutYielding(_matcherContext, Scheduler)
    return toFlushAndYield(_matcherContext, Scheduler, {})
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toFlushExpired(
    _matcherContext,
    Scheduler,
    expectedYields: Array<any>
)
    assertYieldsWereCleared(Scheduler)
    Scheduler.unstable_flushExpired()
    local actualYields = Scheduler.unstable_clearYields()

    return captureAssertion(function()
        expect(actualYields).toEqual(expectedYields)
    end)
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toHaveYielded(
    _matcherContext,
    Scheduler,
    expectedYields: Array<any>
)
    local actualYields = Scheduler.unstable_clearYields()

    return captureAssertion(function()
        expect(actualYields).toEqual(expectedYields)
    end)
end

-- Lua deviation: this takes an extra first argument for 'self'
local function toFlushAndThrow(_matcherContext, Scheduler, rest)
    assertYieldsWereCleared(Scheduler)
    return captureAssertion(function()
        expect(Scheduler.unstable_flushAllWithoutAsserting).toThrow(rest)
    end)
end

return {
    toFlushAndYield = toFlushAndYield,
    toFlushAndYieldThrough = toFlushAndYieldThrough,
    toFlushWithoutYielding = toFlushWithoutYielding,
    toFlushUntilNextPaint = toFlushUntilNextPaint,
    toFlushExpired = toFlushExpired,
    toHaveYielded = toHaveYielded,
    toFlushAndThrow = toFlushAndThrow,
}
