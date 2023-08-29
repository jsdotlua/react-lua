-- upstream: https://github.com/facebook/react/blob/9abc2785cb070148d64fae81e523246b90b92016/packages/scheduler/src/__tests__/TracingSubscriptions-test.internal.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

return function()
	local Packages = script.Parent.Parent.Parent
	local LuaJest = require(Packages.Dev.LuaJest)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local expect = JestGlobals.expect
	local jest = JestGlobals.jest
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Set = LuauPolyfill.Set

	describe("TracingSubscriptions", function()
		local SchedulerTracing
		local ReactFeatureFlags
		local currentTime
		local onInteractionScheduledWorkCompleted
		local onInteractionTraced
		local onWorkCanceled
		local onWorkScheduled
		local onWorkStarted
		local onWorkStopped
		local throwInOnInteractionScheduledWorkCompleted
		local throwInOnInteractionTraced
		local throwInOnWorkCanceled
		local throwInOnWorkScheduled
		local throwInOnWorkStarted
		local throwInOnWorkStopped
		local firstSubscriber
		local secondSubscriber
		local firstEvent = { id = 0, name = "first", timestamp = 0 }
		local secondEvent = { id = 1, name = "second", timestamp = 0 }
		local threadID = 123
		local function loadModules(config)
			local enableSchedulerTracing = config.enableSchedulerTracing
			local autoSubscribe = (function()
				if config.autoSubscribe == nil then
					return true
				end
				return config.autoSubscribe
			end)()

			LuaJest.resetModules()
			LuaJest.useFakeTimers()

			currentTime = 0

			ReactFeatureFlags = require(Packages.Shared).ReactFeatureFlags
			ReactFeatureFlags.enableSchedulerTracing = enableSchedulerTracing

			SchedulerTracing = require(Packages.Scheduler).tracing

			throwInOnInteractionScheduledWorkCompleted = false
			throwInOnInteractionTraced = false
			throwInOnWorkCanceled = false
			throwInOnWorkScheduled = false
			throwInOnWorkStarted = false
			throwInOnWorkStopped = false

			onInteractionScheduledWorkCompleted = jest.fn(function()
				if throwInOnInteractionScheduledWorkCompleted then
					error("Expected error onInteractionScheduledWorkCompleted")
				end
			end)
			onInteractionTraced = jest.fn(function()
				if throwInOnInteractionTraced then
					error("Expected error onInteractionTraced")
				end
			end)
			onWorkCanceled = jest.fn(function()
				if throwInOnWorkCanceled then
					error("Expected error onWorkCanceled")
				end
			end)
			onWorkScheduled = jest.fn(function()
				if throwInOnWorkScheduled then
					error("Expected error onWorkScheduled")
				end
			end)
			onWorkStarted = jest.fn(function()
				if throwInOnWorkStarted then
					error("Expected error onWorkStarted")
				end
			end)
			onWorkStopped = jest.fn(function()
				if throwInOnWorkStopped then
					error("Expected error onWorkStopped")
				end
			end)

			firstSubscriber = {
				onInteractionScheduledWorkCompleted = onInteractionScheduledWorkCompleted,
				onInteractionTraced = onInteractionTraced,
				onWorkCanceled = onWorkCanceled,
				onWorkScheduled = onWorkScheduled,
				onWorkStarted = onWorkStarted,
				onWorkStopped = onWorkStopped,
			}

			secondSubscriber = {
				onInteractionScheduledWorkCompleted = jest.fn(),
				onInteractionTraced = jest.fn(),
				onWorkCanceled = jest.fn(),
				onWorkScheduled = jest.fn(),
				onWorkStarted = jest.fn(),
				onWorkStopped = jest.fn(),
			}
			if autoSubscribe then
				SchedulerTracing.unstable_subscribe(firstSubscriber)
				SchedulerTracing.unstable_subscribe(secondSubscriber)
			end
		end
		describe("enabled", function()
			beforeEach(function()
				return loadModules({ enableSchedulerTracing = true })
			end)
			it(
				"should lazily subscribe to tracing and unsubscribe again if there are no external subscribers",
				function()
					loadModules({ enableSchedulerTracing = true, autoSubscribe = false })
					expect(SchedulerTracing.__subscriberRef.current).toBe(nil)
					SchedulerTracing.unstable_subscribe(firstSubscriber)
					expect(SchedulerTracing.__subscriberRef.current).toBeDefined()
					SchedulerTracing.unstable_subscribe(secondSubscriber)
					expect(SchedulerTracing.__subscriberRef.current).toBeDefined()
					SchedulerTracing.unstable_unsubscribe(secondSubscriber)
					expect(SchedulerTracing.__subscriberRef.current).toBeDefined()
					SchedulerTracing.unstable_unsubscribe(firstSubscriber)
					expect(SchedulerTracing.__subscriberRef.current).toBe(nil)
				end
			)
			describe("error handling", function()
				it("should cover onInteractionTraced/onWorkStarted within", function()
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						local mock = jest.fn()

						-- It should call the callback before re-throwing
						throwInOnInteractionTraced = true
						expect(function()
							return SchedulerTracing.unstable_trace(secondEvent.name, currentTime, mock, threadID)
						end).toThrow("Expected error onInteractionTraced")
						throwInOnInteractionTraced = false
						expect(mock).toHaveBeenCalledTimes(1)
						throwInOnWorkStarted = true
						expect(function()
							return SchedulerTracing.unstable_trace(secondEvent.name, currentTime, mock, threadID)
						end).toThrow("Expected error onWorkStarted")
						expect(mock).toHaveBeenCalledTimes(2)

						-- It should restore the previous/outer interactions
						expect(SchedulerTracing.unstable_getCurrent()).toMatchInteractions({
							firstEvent,
						})

						-- It should call other subscribers despite the earlier error
						expect(secondSubscriber.onInteractionTraced).toHaveBeenCalledTimes(3)
						expect(secondSubscriber.onWorkStarted).toHaveBeenCalledTimes(3)
					end)
				end)
				it("should cover onWorkStopped within trace", function()
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						local innerInteraction
						local mock = jest.fn(function()
							innerInteraction = SchedulerTracing.unstable_getCurrent()._array[2] --[[ adaptation: added 1 to array index ]]
						end)

						throwInOnWorkStopped = true

						expect(function()
							return SchedulerTracing.unstable_trace(secondEvent.name, currentTime, mock)
						end).toThrow("Expected error onWorkStopped")
						throwInOnWorkStopped = false

						-- It should restore the previous/outer interactions
						expect(SchedulerTracing.unstable_getCurrent()).toMatchInteractions({
							firstEvent,
						})

						-- It should update the interaction count so as not to interfere with subsequent calls
						expect(innerInteraction.__count).toBe(0)

						-- It should call other subscribers despite the earlier error
						expect(secondSubscriber.onWorkStopped).toHaveBeenCalledTimes(1)
					end)
				end)
				it("should cover onInteractionScheduledWorkCompleted within trace", function()
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						local mock = jest.fn()
						throwInOnInteractionScheduledWorkCompleted = true
						expect(function()
							return SchedulerTracing.unstable_trace(secondEvent.name, currentTime, mock)
						end).toThrow("Expected error onInteractionScheduledWorkCompleted")
						throwInOnInteractionScheduledWorkCompleted = false
						expect(SchedulerTracing.unstable_getCurrent()).toMatchInteractions({
							firstEvent,
						})
						expect(secondSubscriber.onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(1)
					end)
				end)
				it("should cover the callback within trace", function()
					expect(onWorkStarted).never.toHaveBeenCalled()
					expect(onWorkStopped).never.toHaveBeenCalled()
					expect(function()
						SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
							error("Expected error callback")
						end)
					end).toThrow("Expected error callback")
					expect(onWorkStarted).toHaveBeenCalledTimes(1)
					expect(onWorkStopped).toHaveBeenCalledTimes(1)
				end)
				it("should cover onWorkScheduled within wrap", function()
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						-- FIXME: Array.from() polyfill doesn't recognize Set correctly
						local interaction = SchedulerTracing.unstable_getCurrent()._array[1] --[[ adaptation: added 1 to array index ]]
						local beforeCount = interaction.__count
						throwInOnWorkScheduled = true
						expect(function()
							return SchedulerTracing.unstable_wrap(function() end)
						end).toThrow("Expected error onWorkScheduled")
						expect(interaction.__count).toBe(beforeCount)
						expect(secondSubscriber.onWorkScheduled).toHaveBeenCalledTimes(1)
					end)
				end)
				it("should cover onWorkStarted within wrap", function()
					local mock = jest.fn()
					local interaction, wrapped
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						-- FIXME: Array.from() polyfill doesn't recognize Set correctly
						interaction = SchedulerTracing.unstable_getCurrent()._array[1] --[[ adaptation: added 1 to array index ]]
						wrapped = SchedulerTracing.unstable_wrap(mock)
					end)
					expect(interaction.__count).toBe(1)
					throwInOnWorkStarted = true
					expect(function()
						wrapped()
					end).toThrow("Expected error onWorkStarted")
					expect(mock).toHaveBeenCalledTimes(1)
					expect(interaction.__count).toBe(0)
					expect(secondSubscriber.onWorkStarted).toHaveBeenCalledTimes(2)
				end)
				it("should cover onWorkStopped within wrap", function()
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						-- FIXME: Array.from() polyfill doesn't recognize Set correctly
						local outerInteraction = SchedulerTracing.unstable_getCurrent()._array[1] --[[ adaptation: added 1 to array index ]]
						expect(outerInteraction.__count).toBe(1)
						local wrapped
						local innerInteraction
						SchedulerTracing.unstable_trace(secondEvent.name, currentTime, function()
							-- FIXME: Array.from() polyfill doesn't recognize Set correctly
							innerInteraction = SchedulerTracing.unstable_getCurrent()._array[2] --[[ adaptation: added 1 to array index ]]
							expect(outerInteraction.__count).toBe(1)
							expect(innerInteraction.__count).toBe(1)
							wrapped = SchedulerTracing.unstable_wrap(jest.fn())
							expect(outerInteraction.__count).toBe(2)
							expect(innerInteraction.__count).toBe(2)
						end)
						expect(outerInteraction.__count).toBe(2)
						expect(innerInteraction.__count).toBe(1)
						throwInOnWorkStopped = true
						expect(function()
							wrapped()
						end).toThrow("Expected error onWorkStopped")
						throwInOnWorkStopped = false
						expect(SchedulerTracing.unstable_getCurrent()).toMatchInteractions({
							outerInteraction,
						})
						expect(outerInteraction.__count).toBe(1)
						expect(innerInteraction.__count).toBe(0)
						expect(secondSubscriber.onWorkStopped).toHaveBeenCalledTimes(2)
					end)
				end)

				it("should cover the callback within wrap", function()
					expect(onWorkStarted).never.toHaveBeenCalled()
					expect(onWorkStopped).never.toHaveBeenCalled()

					local wrapped
					local interaction
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						-- FIXME: Array.from() polyfill doesn't recognize Set correctly
						interaction = SchedulerTracing.unstable_getCurrent()._array[1] --[[ adaptation: added 1 to array index ]]
						wrapped = SchedulerTracing.unstable_wrap(function()
							error("Expected error wrap")
						end)
					end)

					expect(onWorkStarted).toHaveBeenCalledTimes(1)
					expect(onWorkStopped).toHaveBeenCalledTimes(1)

					expect(function()
						wrapped()
					end).toThrow("Expected error wrap")

					expect(onWorkStarted).toHaveBeenCalledTimes(2)
					expect(onWorkStopped).toHaveBeenCalledTimes(2)
					expect(onWorkStopped).toHaveBeenLastNotifiedOfWork({ interaction })
				end)

				it("should cover onWorkCanceled within wrap", function()
					local interaction, wrapped
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						-- FIXME: Array.from() polyfill doesn't recognize Set correctly
						interaction = SchedulerTracing.unstable_getCurrent()._array[1] --[[ adaptation: added 1 to array index ]]
						wrapped = SchedulerTracing.unstable_wrap(jest.fn())
					end)
					expect(interaction.__count).toBe(1)
					throwInOnWorkCanceled = true
					expect(function()
						wrapped.cancel()
					end).toThrow("Expected error onWorkCanceled")
					expect(onWorkCanceled).toHaveBeenCalledTimes(1)
					expect(interaction.__count).toBe(0)
					expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(firstEvent)
					expect(secondSubscriber.onWorkCanceled).toHaveBeenCalledTimes(1)
				end)
			end)
			it("calls lifecycle methods for trace", function()
				expect(onInteractionTraced).never.toHaveBeenCalled()
				expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
				SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
					expect(onInteractionTraced).toHaveBeenCalledTimes(1)
					expect(onInteractionTraced).toHaveBeenLastNotifiedOfInteraction(firstEvent)
					expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
					expect(onWorkStarted).toHaveBeenCalledTimes(1)
					expect(onWorkStarted).toHaveBeenLastNotifiedOfWork(Set.new({ firstEvent }), threadID)
					expect(onWorkStopped).never.toHaveBeenCalled()

					SchedulerTracing.unstable_trace(secondEvent.name, currentTime, function()
						expect(onInteractionTraced).toHaveBeenCalledTimes(2)
						expect(onInteractionTraced).toHaveBeenLastNotifiedOfInteraction(secondEvent)
						expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
						expect(onWorkStarted).toHaveBeenCalledTimes(2)
						expect(onWorkStarted).toHaveBeenLastNotifiedOfWork(
							Set.new({ firstEvent, secondEvent }),
							threadID
						)
						expect(onWorkStopped).never.toHaveBeenCalled()
					end, threadID)
					expect(onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(1)
					expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(secondEvent)
					expect(onWorkStopped).toHaveBeenCalledTimes(1)
					expect(onWorkStopped).toHaveBeenLastNotifiedOfWork(
						Set.new({ firstEvent, secondEvent }),
						threadID
					)
				end, threadID)
				expect(onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(2)
				expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(firstEvent)
				expect(onWorkScheduled).never.toHaveBeenCalled()
				expect(onWorkCanceled).never.toHaveBeenCalled()
				expect(onWorkStarted).toHaveBeenCalledTimes(2)
				expect(onWorkStopped).toHaveBeenCalledTimes(2)
				expect(onWorkStopped).toHaveBeenLastNotifiedOfWork(Set.new({ firstEvent }), threadID)
			end)
			it("calls lifecycle methods for wrap", function()
				local unwrapped = jest.fn()
				local wrapped
				SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
					expect(onInteractionTraced).toHaveBeenCalledTimes(1)
					expect(onInteractionTraced).toHaveBeenLastNotifiedOfInteraction(firstEvent)
					SchedulerTracing.unstable_trace(secondEvent.name, currentTime, function()
						expect(onInteractionTraced).toHaveBeenCalledTimes(2)
						expect(onInteractionTraced).toHaveBeenLastNotifiedOfInteraction(secondEvent)
						wrapped = SchedulerTracing.unstable_wrap(unwrapped, threadID)
						expect(onWorkScheduled).toHaveBeenCalledTimes(1)
						expect(onWorkScheduled).toHaveBeenLastNotifiedOfWork(
							Set.new({ firstEvent, secondEvent }),
							threadID
						)
					end)
				end)
				expect(onInteractionTraced).toHaveBeenCalledTimes(2)
				expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
				wrapped()
				expect(unwrapped).toHaveBeenCalled()
				expect(onWorkScheduled).toHaveBeenCalledTimes(1)
				expect(onWorkCanceled).never.toHaveBeenCalled()
				expect(onWorkStarted).toHaveBeenCalledTimes(3)
				expect(onWorkStarted).toHaveBeenLastNotifiedOfWork(Set.new({ firstEvent, secondEvent }), threadID)
				expect(onWorkStopped).toHaveBeenCalledTimes(3)
				expect(onWorkStopped).toHaveBeenLastNotifiedOfWork(Set.new({ firstEvent, secondEvent }), threadID)
				expect(onInteractionScheduledWorkCompleted
					.mock
					.calls
					[1] --[[ adaptation: added 1 to array index ]]
					[1] --[[ adaptation: added 1 to array index ]]).toMatchInteraction(firstEvent)
				expect(onInteractionScheduledWorkCompleted
					.mock
					.calls
					[2] --[[ adaptation: added 1 to array index ]]
					[1] --[[ adaptation: added 1 to array index ]]).toMatchInteraction(secondEvent)
			end)
			it("should call the correct interaction subscriber methods when a wrapped callback is canceled", function()
				local fnOne = jest.fn()
				local fnTwo = jest.fn()
				local wrappedOne, wrappedTwo
				SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
					wrappedOne = SchedulerTracing.unstable_wrap(fnOne, threadID)
					SchedulerTracing.unstable_trace(secondEvent.name, currentTime, function()
						wrappedTwo = SchedulerTracing.unstable_wrap(fnTwo, threadID)
					end)
				end)
				expect(onInteractionTraced).toHaveBeenCalledTimes(2)
				expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
				expect(onWorkCanceled).never.toHaveBeenCalled()
				expect(onWorkStarted).toHaveBeenCalledTimes(2)
				expect(onWorkStopped).toHaveBeenCalledTimes(2)
				wrappedTwo:cancel()
				expect(onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(1)
				expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(secondEvent)
				expect(onWorkCanceled).toHaveBeenCalledTimes(1)
				expect(onWorkCanceled).toHaveBeenLastNotifiedOfWork(Set.new({ firstEvent, secondEvent }), threadID)
				wrappedOne:cancel()
				expect(onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(2)
				expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(firstEvent)
				expect(onWorkCanceled).toHaveBeenCalledTimes(2)
				expect(onWorkCanceled).toHaveBeenLastNotifiedOfWork(Set.new({ firstEvent }), threadID)
				expect(fnOne).never.toHaveBeenCalled()
				expect(fnTwo).never.toHaveBeenCalled()
			end)
			it(
				"should not end an interaction twice if wrap is used to schedule follow up work within another wrap",
				function()
					local wrappedOne, wrappedTwo
					local fnTwo = jest.fn()
					local fnOne = jest.fn(function()
						wrappedTwo = SchedulerTracing.unstable_wrap(fnTwo, threadID)
					end)
					SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
						wrappedOne = SchedulerTracing.unstable_wrap(fnOne, threadID)
					end)
					expect(onInteractionTraced).toHaveBeenCalledTimes(1)
					expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
					wrappedOne()
					expect(onInteractionTraced).toHaveBeenCalledTimes(1)
					expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
					wrappedTwo()
					expect(onInteractionTraced).toHaveBeenCalledTimes(1)
					expect(onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(1)
					expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(firstEvent)
				end
			)
			it("should not decrement the interaction count twice if a wrapped function is run twice", function()
				local unwrappedOne = jest.fn()
				local unwrappedTwo = jest.fn()
				local wrappedOne, wrappedTwo
				SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function()
					wrappedOne = SchedulerTracing.unstable_wrap(unwrappedOne, threadID)
					wrappedTwo = SchedulerTracing.unstable_wrap(unwrappedTwo, threadID)
				end)
				expect(onInteractionTraced).toHaveBeenCalledTimes(1)
				expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
				wrappedOne()
				expect(unwrappedOne).toHaveBeenCalledTimes(1)
				expect(onInteractionTraced).toHaveBeenCalledTimes(1)
				expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
				wrappedOne()
				expect(unwrappedOne).toHaveBeenCalledTimes(2)
				expect(onInteractionTraced).toHaveBeenCalledTimes(1)
				expect(onInteractionScheduledWorkCompleted).never.toHaveBeenCalled()
				wrappedTwo()
				expect(onInteractionTraced).toHaveBeenCalledTimes(1)
				expect(onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(1)
				expect(onInteractionScheduledWorkCompleted).toHaveBeenLastNotifiedOfInteraction(firstEvent)
			end)
			it("should unsubscribe", function()
				SchedulerTracing.unstable_unsubscribe(firstSubscriber)
				SchedulerTracing.unstable_trace(firstEvent.name, currentTime, function() end)
				expect(onInteractionTraced).never.toHaveBeenCalled()
			end)
		end)
		describe("disabled", function()
			beforeEach(function()
				return loadModules({ enableSchedulerTracing = false })
			end)

			-- TODO
		end)
	end)
end
