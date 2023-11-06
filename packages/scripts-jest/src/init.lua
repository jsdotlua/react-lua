-- Lua note: Mimicking https://github.com/facebook/jest/blob/4453901c0239939cc2c1c8b7c7d121447f6f5f52/packages/jest-fake-timers/src/legacyFakeTimers.ts#L506
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 * @jest-environment node
 ]]

local LuauPolyfill = require(Pacakges.LuauPolyfill)
local Object = LuauPolyfill.Object

type Timer = {
	expiry: number,
	callback: () -> (),
}

local realDelay = delay
local realTick = tick
local realOsClock = os.clock
local realTaskDelay = task.delay

local timers: { [number]: Timer } = {}
local now = 0

local function reset()
	timers = {}
	now = 0
end

local function runAllTimers()
	for _, timer in timers do
		-- Move now to target time, in case the callback reads it via
		-- `tick`
		now = timer.expiry
		timer.callback()
	end

	timers = {}
end

local function mockDelay(_, delayTime, callback)
	local newExpiry = now + delayTime
	local timer = {
		expiry = newExpiry,
		callback = callback,
	}
	local insertIndex = 1
	while insertIndex <= #timers do
		-- Timers are inserted in time order. As soon as we encounter a
		-- expiry that's _after_ our newExpiry, we place ours in the list
		-- immediately before it. This way, timeouts with the exact same time
		-- will be queued up in insertion order to break ties
		if timers[insertIndex].expiry > newExpiry then
			break
		end
		insertIndex += 1
	end
	table.insert(timers, insertIndex, timer)
end

local function mockTick(_)
	return now
end

function round(number, decimals)
	local power = 10 ^ decimals
	return math.floor(number * power) / power
end

local function advanceTimersByTime(msToRun: number): ()
	-- Only run a generous number of timers and then bail.
	-- This is just to help avoid recursive loops
	-- Lua TODO: this needs to match the conversion in the setTimeout polyfill for now
	local secondsToRun = msToRun / 1000
	local i = 0
	while i < 100000 do
		i += 1
		-- If there are no more timers handles, stop!
		if #timers == 0 then
			-- If we run out of timers, we still need to finish advancing the
			-- time the rest of the way
			now += secondsToRun
			break
		end

		local nextTimerExpiry = timers[1].expiry

		if round(now + secondsToRun, 5) < round(nextTimerExpiry, 5) then
			-- There are no timers between now and the target we're running to, so
			-- adjust our time cursor and quit
			now += secondsToRun
			break
		else
			secondsToRun -= nextTimerExpiry - now
			now = nextTimerExpiry
			local callback = timers[1].callback
			table.remove(timers, 1)
			callback()
		end
	end
	if i == 100000 then
		error(
			"Ran 100000"
				.. " timers, and there are still more! "
				.. "Assuming we've hit an infinite recursion and bailing out..."
		)
	end
end

local delayOverride = {}
delayOverride.__call = realDelay

local tickOverride = {}
tickOverride.__call = realTick

local osClockOverride = {}
osClockOverride.__call = realOsClock

local taskDelayOverride = {}
taskDelayOverride.__call = realTaskDelay

local function useFakeTimers()
	reset()
	delayOverride.__call = mockDelay
	tickOverride.__call = mockTick
	-- osClockOverride.__call = mockClock
	taskDelayOverride.__call = mockDelay
end

local function useRealTimers()
	delayOverride.__call = realDelay
	tickOverride.__call = realTick
	osClockOverride.__call = realOsClock
	taskDelayOverride.__call = realTaskDelay
end

local function getTimerCount(): number
	return #timers
end

local taskOverride = {
	delay = setmetatable({}, taskDelayOverride),
}

local osOverride = {
	clock = setmetatable({}, osClockOverride),
}

local FakeTimers = {
	delayOverride = setmetatable({}, delayOverride),
	tickOverride = setmetatable({}, tickOverride),
	osOverride = osOverride,
	taskOverride = taskOverride,
	runAllTimers = runAllTimers,
	useFakeTimers = useFakeTimers,
	useRealTimers = useRealTimers,
	advanceTimersByTime = advanceTimersByTime,
	getTimerCount = getTimerCount,
	reset = reset,
	now = function()
		return now
	end,
	mockOsClock = function(mockFn)
		osClockOverride.__call = function(_, ...)
			return mockFn(...)
		end
	end,
}

local requiredModules: { [ModuleScript]: any } = {}
local moduleCleanup: { [ModuleScript]: (() -> any)? } = {}
local mocks: { [ModuleScript]: CleanupFn } = {}

if _G.__NO_LOADMODULE__ then
	warn("debug.loadmodule not enabled. Test plans relying on resetModules " .. "will not work properly.")

	return {
		requireOverride = require,
		resetModules = function()
			-- Should we warn on calling this more than once?
		end,
		mock = function(module: ModuleScript, fn: () -> any)
			-- Since we can't mock underneath require, we'll overwrite the
			-- require module altogether with the result of the mock
			local mockResult = fn()
			local realModule = require(module) :: any
			for k, v in mockResult do
				realModule[k] = v
			end
			for k, _v in realModule do
				if mockResult[k] == nil then
					realModule[k] = nil
				end
			end
		end,
		unmock = function(_module: ModuleScript)
			-- no op
		end,
	}
end

local function requireOverride(scriptInstance: ModuleScript): any
	-- This is crucial! We need to have an early out here so that we don't
	-- override requires of ourself; this would result in the module cache
	-- deviating into a bunch of separate ones.
	--
	-- Lua TODO: This is a little janky, so we should find a way to do this that's a
	-- little more robust. We may want to apply it to anything in ScriptsJest?
	if
		scriptInstance == script
		or scriptInstance == script.Parent
		or scriptInstance.Name == "jest-Lua"
		-- for the 2021 version of the Studio Inspector plugin
		or scriptInstance.Name == "DeveloperTools"
	then
		return require(scriptInstance) :: any
	end
	-- Lua FIXME: an extra special hack that prevents us from frequently reloading
	-- `jest-Lua`, and therefore dodges the expensive modules found in:
	-- jest-Lua -> luau-polyfill@0.1.5 -> RegExp
	if scriptInstance.Name == "RegExp" then
		return require(scriptInstance) :: any
	end
	-- If already loaded and cached, return cached module. This should behave
	-- similarly to normal `require` behavior
	if requiredModules[scriptInstance] ~= nil then
		return requiredModules[scriptInstance]
	end

	local moduleResult
	-- First, check the mock cache and see if this is being mocked
	if typeof(mocks[scriptInstance]) == "function" then
		-- Lua FIXME: Luau flow analysis bug workaround
		moduleResult = (mocks[scriptInstance] :: () -> any)()

		if moduleResult == nil then
			error(
				string.format(
					"[Mock Error]: %s did not return a valid result\n" .. "\tmocks must return a non-nil value",
					tostring(scriptInstance)
				)
			)
		end
	else
		-- Narrowing this type here lets us appease the type checker while still
		-- counting on types for the rest of this file
		local loadmodule: (ModuleScript) -> (any, string, CleanupFn) = debug["loadmodule"]
		local moduleFunction, errorMessage, cleanup = loadmodule(scriptInstance)
		assert(moduleFunction ~= nil, errorMessage)

		getfenv(moduleFunction).require = requireOverride
		getfenv(moduleFunction).delay = FakeTimers.delayOverride
		getfenv(moduleFunction).tick = FakeTimers.tickOverride
		getfenv(moduleFunction).task = FakeTimers.taskOverride
		getfenv(moduleFunction).os = FakeTimers.osOverride
		moduleResult = moduleFunction()

		if moduleResult == nil then
			error(
				string.format(
					"[Module Error]: %s did not return a valid result\n"
						.. "\tModuleScripts must return a non-nil value",
					tostring(scriptInstance)
				)
			)
		end
		moduleCleanup[scriptInstance] = cleanup
	end

	-- Load normally into the require cache
	requiredModules[scriptInstance] = moduleResult

	return moduleResult
end

local function resetModules()
	-- Clear all modules in the override require cache
	requiredModules = {}

	for script, cleanup in moduleCleanup do
		(cleanup :: CleanupFn)()
	end

	moduleCleanup = {}
end

local function mock(scriptInstance: ModuleScript, callback: () -> any)
	-- If there's a cached actual value, clear it out so that a new require
	-- will get the mock
	if requiredModules[scriptInstance] ~= nil then
		requiredModules[scriptInstance] = nil
		local cleanup = moduleCleanup[scriptInstance]
		if cleanup then
			(cleanup :: CleanupFn)()
			moduleCleanup[scriptInstance] = nil
		end
	end

	-- Silence type errors
	local getfenv: any = getfenv
	-- Make sure that the further requires used by this mock will also be using
	-- the require override
	getfenv(callback).require = requireOverride
	getfenv(callback).delay = FakeTimers.delayOverride
	getfenv(callback).tick = FakeTimers.tickOverride
	getfenv(callback).task = FakeTimers.taskOverride
	getfenv(callback).os = FakeTimers.osOverride
	mocks[scriptInstance] = callback
end

local function unmock(scriptInstance: ModuleScript)
	-- If there's a cached mock value, clear it out so that a new require won't
	-- get the mock
	if requiredModules[scriptInstance] ~= nil then
		requiredModules[scriptInstance] = nil
		local cleanup = moduleCleanup[scriptInstance]
		if cleanup then
			(cleanup :: CleanupFn)()
			moduleCleanup[scriptInstance] = nil
		end
	end

	mocks[scriptInstance] = nil
end

local Module = {
	requireOverride = requireOverride,
	resetModules = resetModules,
	mock = mock,
	unmock = unmock,
}

function toContainNoInteractions(self, actualSet)
	return {
		message = function()
			if self.isNot then
				return "Expected interactions but there were none."
			end
			return "Expected no interactions but there were " .. tostring(#Object.keys(actualSet)) .. "."
		end,
		pass = #actualSet == 0,
	}
end

function toHaveBeenLastNotifiedOfInteraction(self, mockFunction, expectedInteraction)
	local calls = mockFunction.mock.calls
	if #calls == 0 then
		return {
			message = function()
				return "Mock function was not called"
			end,
			pass = false,
		}
	end

	local actualInteraction = calls[#calls][1]

	return toMatchInteraction(self, actualInteraction, expectedInteraction)
end

function toHaveBeenLastNotifiedOfWork(self, mockFunction, expectedInteractions, expectedThreadID)
	local calls = mockFunction.mock.calls
	if #calls == 0 then
		return {
			message = function()
				return "Mock function was not called"
			end,
			pass = false,
		}
	end

	local actualInteractions, actualThreadID = calls[#calls][1], calls[#calls][2]
	if expectedThreadID ~= nil then
		if expectedThreadID ~= actualThreadID then
			return {
				message = function()
					return JestDiff.diff(tostring(expectedThreadID), tostring(actualThreadID))
				end,
				pass = false,
			}
		end
	end

	return toMatchInteractions(self, actualInteractions, expectedInteractions)
end

function toMatchInteraction(self, actual, expected)
	for _, attribute in expected do
		if actual[attribute] ~= expected[attribute] then
			return {
				message = function()
					return JestDiff.diff(expected, actual)
				end,

				pass = false,
			}
		end
	end

	return { pass = true }
end

function toMatchInteractions(self, actualSetOrArray, expectedSetOrArray)
	local actualArrayLength = 0
	for _, __ in actualSetOrArray do
		actualArrayLength += 1
	end

	local expectedArrayLength = 0
	for _, __ in expectedSetOrArray do
		expectedArrayLength += 1
	end

	if actualArrayLength ~= expectedArrayLength then
		return {
			message = function()
				return string.format(
					"Expected %d interactions but there were %d",
					expectedArrayLength,
					actualArrayLength
				)
			end,
			pass = false,
		}
	end
	for i, actualInteraction in actualSetOrArray do
		local expectedInteraction = if expectedSetOrArray._array
			then expectedSetOrArray._array[i]
			else expectedSetOrArray[i]
		local result = toMatchInteraction(self, actualInteraction, expectedInteraction)
		if result.pass == false then
			return result
		end
	end

	return { pass = true }
end

local InteractionTracingMatchers = {
	toContainNoInteractions = toContainNoInteractions,
	toHaveBeenLastNotifiedOfInteraction = toHaveBeenLastNotifiedOfInteraction,
	toHaveBeenLastNotifiedOfWork = toHaveBeenLastNotifiedOfWork,
	toMatchInteraction = toMatchInteraction,
	toMatchInteractions = toMatchInteractions,
}

-- override require from now to make sure Matchers are
-- hitting the Module's cache
local require = Module.requireOverride
local ScriptsJest = {
	setupTests = require(script.Parent.setupTests),
	Matchers = {
		toContainNoInteractions = InteractionTracingMatchers.toContainNoInteractions,
		toHaveBeenLastNotifiedOfInteraction = InteractionTracingMatchers.toHaveBeenLastNotifiedOfInteraction,
		toHaveBeenLastNotifiedOfWork = InteractionTracingMatchers.toHaveBeenLastNotifiedOfWork,
		toMatchInteraction = InteractionTracingMatchers.toMatchInteraction,
		toMatchInteractions = InteractionTracingMatchers.toMatchInteractions,
	},

	resetModules = Module.resetModules,
	mock = Module.mock,
	unmock = Module.unmock,

	-- Lua TODO: use Lua-jest fake timers impl and delete these
	useFakeTimers = FakeTimers.useFakeTimers,
	useRealTimers = FakeTimers.useRealTimers,
	runAllTimers = FakeTimers.runAllTimers,
	advanceTimersByTime = FakeTimers.advanceTimersByTime,
	now = FakeTimers.now,
	resetFakeTimers = FakeTimers.reset,
	getTimerCount = FakeTimers.getTimerCount,
	mockOsClock = FakeTimers.mockOsClock,

	testEnv = {
		require = Module.requireOverride,
		delay = FakeTimers.delayOverride,
		tick = FakeTimers.tickOverride,
		os = FakeTimers.osOverride,
		task = FakeTimers.taskOverride,
	},
}
Object.assign(ScriptsJest.Matchers, require(script.Parent.matchers.toWarnDev))

return ScriptsJest
