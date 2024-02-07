<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/d13f5b9538e48f74f7c571ef3cde652ca887cca0/packages/react-reconciler/src/__tests__/ReactSuspense-test.internal.js
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @emails react-core
--  * @jest-environment node
--  */

=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/__tests__/ReactSuspense-test.internal.js
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local setTimeout = LuauPolyfill.setTimeout
type Object = LuauPolyfill.Object
local Promise = require(Packages.Promise)
>>>>>>> upstream-apply
local React
local ReactTestRenderer
local ReactFeatureFlags
local Scheduler
local ReactCache
local Suspense
local _act
local TextResource
local textResourceShouldFail
<<<<<<< HEAD

local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local it = JestGlobals.it
local xit = JestGlobals.xit
local describe = JestGlobals.describe
local jest = JestGlobals.jest

local jestMock = require("@pkg/@jsdotlua/jest-globals").jest
local Promise = require("@pkg/@jsdotlua/promise")
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local setTimeout = LuauPolyfill.setTimeout
local Error = LuauPolyfill.Error
-- Additional tests can be found in ReactSuspenseWithNoopRenderer. Plan is
-- to gradually migrate those to this file.
=======
>>>>>>> upstream-apply
describe("ReactSuspense", function()
	-- ROBLOX deviation START: add afterEach to reset to using useRealTimers()
	afterEach(function()
		jest.useRealTimers()
	end)
	-- ROBLOX deviation END

	beforeEach(function()
		jest.resetModules()

		ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags
		ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback = false
<<<<<<< HEAD
		ReactFeatureFlags.enableSchedulerTracing = true
		React = require("@pkg/@jsdotlua/react")
		ReactTestRenderer = require("@pkg/@jsdotlua/react-test-renderer")
		_act = ReactTestRenderer.unstable_concurrentAct
		Scheduler = require("@pkg/@jsdotlua/scheduler")
		SchedulerTracing = Scheduler.tracing
		ReactCache = require("@pkg/@jsdotlua/react-cache")
=======
		React = require_("react")
		ReactTestRenderer = require_("react-test-renderer")
		act = require_("jest-react").act
		Scheduler = require_("scheduler")
		ReactCache = require_("react-cache")
>>>>>>> upstream-apply
		Suspense = React.Suspense
		TextResource = ReactCache.unstable_createResource(function(input)
			local text, ms = input[1], (input[2] or 0)
			local listeners
			local status = "pending"
			local value = nil

			return {
				andThen = function(_self, resolve, reject)
					-- ROBLOX deviation: if/else in place of switch
					if status == "pending" then
						if listeners == nil then
							listeners = { { resolve = resolve, reject = reject } }
							setTimeout(function()
								if textResourceShouldFail then
									Scheduler.unstable_yieldValue(
										string.format("Promise rejected [%s]", text)
									)
									status = "rejected"
									value = Error.new("Failed to load: " .. text)
									for _, listener in listeners do
										listener.reject(value)
									end
								else
									Scheduler.unstable_yieldValue(
										string.format("Promise resolved [%s]", text)
									)
									status = "resolved"
									value = text
									for _, listener in listeners do
										listener.resolve(value)
									end
								end
							end, ms)
						else
							table.insert(
								listeners,
								{ resolve = resolve, reject = reject }
							)
						end
					elseif status == "resolved" then
						resolve(value)
					elseif status == "rejected" then
						reject(value)
					end
				end,
			}
		end, function(input)
			return input[1]
		end)
		textResourceShouldFail = false
	end)

	local function Text(props)
		Scheduler.unstable_yieldValue(props.text)
		return props.text
	end

	local function AsyncText(props)
		local text = props.text
		local ok, result = pcall(function()
			TextResource.read({ props.text, props.ms })
			Scheduler.unstable_yieldValue(text)
			return text
		end)
		if not ok then
			local promise = result
			if typeof(promise.andThen) == "function" then
				Scheduler.unstable_yieldValue(string.format("Suspend! [%s]", text))
			else
				Scheduler.unstable_yieldValue(string.format("Error! [%s]", text))
			end
			error(promise)
		end
		return result
	end

	it("suspends rendering and continues later", function()
		-- ROBLOX deviation START: add useFakeTimers()
		jest.useFakeTimers()
		-- ROBLOX deviation END
		local function Bar(props)
			Scheduler.unstable_yieldValue("Bar")
			return props.children
		end

		local function Foo(props)
			local renderBar = props.renderBar

			Scheduler.unstable_yieldValue("Foo")

			return React.createElement(
				Suspense,
				{
					fallback = React.createElement(Text, {
						text = "Loading...",
					}),
				},
				if renderBar
					then React.createElement(
						Bar,
						nil,
						React.createElement(AsyncText, {
							text = "A",
							ms = 100,
						}),
						React.createElement(Text, {
							text = "B",
						})
					)
					else nil
			)
		end

		-- Render an empty shell
		local root = ReactTestRenderer.create(
			React.createElement(Foo),
			{ unstable_isConcurrent = true }
		)

		jestExpect(Scheduler).toFlushAndYield({ "Foo" })
		jestExpect(root).toMatchRenderedOutput(nil)

		-- Navigate the shell to now render the child content.
		-- This should suspend.
<<<<<<< HEAD
		root.update(React.createElement(Foo, { renderBar = true }))
		jestExpect(Scheduler).toFlushAndYield({
=======
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				root:update(React.createElement(Foo, { renderBar = true }))
			end)
		else
			root:update(React.createElement(Foo, { renderBar = true }))
		end
		expect(Scheduler).toFlushAndYield({
>>>>>>> upstream-apply
			"Foo",
			"Bar",
			-- A suspends
			"Suspend! [A]",
			-- But we keep rendering the siblings
			"B",
			"Loading...",
		})
		jestExpect(root).toMatchRenderedOutput(nil)

		-- Flush some of the time
		jest.advanceTimersByTime(50)
		-- Still nothing...
		jestExpect(Scheduler).toFlushWithoutYielding()
		jestExpect(root).toMatchRenderedOutput(nil)

		-- Flush the promise completely
		jest.advanceTimersByTime(50)
		-- Renders successfully
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [A]",
		})
		jestExpect(Scheduler).toFlushAndYield({
			"Foo",
			"Bar",
			"A",
			"B",
		})
		jestExpect(root).toMatchRenderedOutput("AB")
	end)
	it("suspends siblings and later recovers each independently", function()
		-- ROBLOX deviation START: add useFakeTimers()
		jest.useFakeTimers()
		-- ROBLOX deviation END
		-- Render two sibling Suspense components
		local root = ReactTestRenderer.create(
			React.createElement(
				React.Fragment,
				nil,
				React.createElement(
					Suspense,
					{
						fallback = React.createElement(Text, {
							text = "Loading A...",
						}),
					},
					React.createElement(AsyncText, {
						text = "A",
						ms = 5000,
					})
				),
				React.createElement(
					Suspense,
					{
						fallback = React.createElement(Text, {
							text = "Loading B...",
						}),
					},
					React.createElement(AsyncText, {
						text = "B",
						ms = 6000,
					})
				)
			),
			{ unstable_isConcurrent = true }
		)

		jestExpect(Scheduler).toFlushAndYield({
			"Suspend! [A]",
			"Loading A...",
			"Suspend! [B]",
			"Loading B...",
		})
		Scheduler.unstable_flushAll()
		jestExpect(root).toMatchRenderedOutput("Loading A...Loading B...")
		-- Advance time by enough that the first Suspense's promise resolves and
		-- switches back to the normal view. The second Suspense should still
		-- show the placeholder
		jest.advanceTimersByTime(5000)
		-- TODO: Should we throw if you forget to call toHaveYielded?
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [A]",
		})
		jestExpect(Scheduler).toFlushAndYield({
			"A",
		})
		jestExpect(root).toMatchRenderedOutput("ALoading B...")

		-- Advance time by enough that the second Suspense's promise resolves
		-- and switches back to the normal view
		jest.advanceTimersByTime(1000)
<<<<<<< HEAD
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [B]",
=======
		expect(Scheduler).toHaveYielded({ "Promise resolved [B]" })
		expect(Scheduler).toFlushAndYield({ "B" })
		expect(root).toMatchRenderedOutput("AB")
	end)
	it("interrupts current render if promise resolves before current render phase", function()
		local didResolve = false
		local listeners = {}
		local thenable = {
			["then"] = function(self, resolve)
				if not Boolean.toJSBoolean(didResolve) then
					table.insert(listeners, resolve) --[[ ROBLOX CHECK: check if 'listeners' is an Array ]]
				else
					resolve()
				end
			end,
		}
		local function resolveThenable()
			didResolve = true
			Array.forEach(listeners, function(l)
				return l()
			end) --[[ ROBLOX CHECK: check if 'listeners' is an Array ]]
		end
		local function Async()
			if not Boolean.toJSBoolean(didResolve) then
				Scheduler:unstable_yieldValue("Suspend!")
				error(thenable)
			end
			Scheduler:unstable_yieldValue("Async")
			return "Async"
		end
		local root = ReactTestRenderer.create(
			React.createElement(
				React.Fragment,
				nil,
				React.createElement(Suspense, { fallback = React.createElement(Text, { text = "Loading..." }) }),
				React.createElement(Text, { text = "Initial" })
			),
			{ unstable_isConcurrent = true }
		)
		expect(Scheduler).toFlushAndYield({ "Initial" })
		expect(root).toMatchRenderedOutput("Initial") -- The update will suspend.
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				root:update(
					React.createElement(
						React.Fragment,
						nil,
						React.createElement(
							Suspense,
							{ fallback = React.createElement(Text, { text = "Loading..." }) },
							React.createElement(Async, nil)
						),
						React.createElement(Text, { text = "After Suspense" }),
						React.createElement(Text, { text = "Sibling" })
					)
				)
			end)
		else
			root:update(
				React.createElement(
					React.Fragment,
					nil,
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						React.createElement(Async, nil)
					),
					React.createElement(Text, { text = "After Suspense" }),
					React.createElement(Text, { text = "Sibling" })
				)
			)
		end -- Yield past the Suspense boundary but don't complete the last sibling.
		expect(Scheduler).toFlushAndYieldThrough({ "Suspend!", "Loading...", "After Suspense" }) -- The promise resolves before the current render phase has completed
		resolveThenable()
		expect(Scheduler).toHaveYielded({})
		expect(root).toMatchRenderedOutput("Initial") -- Start over from the root, instead of continuing.
		expect(Scheduler).toFlushAndYield({
			-- Async renders again *before* Sibling
			"Async",
			"After Suspense",
			"Sibling",
>>>>>>> upstream-apply
		})
		jestExpect(Scheduler).toFlushAndYield({
			"B",
		})
		jestExpect(root).toMatchRenderedOutput("AB")
	end)
<<<<<<< HEAD
	it(
		"interrupts current render if promise resolves before current render phase",
		function()
			local didResolve = false
			local listeners = {}
			local thenable = {
				andThen = function(self, resolve)
					if not didResolve then
						table.insert(listeners, resolve)
					else
						resolve()
					end
				end,
			}

			local function resolveThenable()
				didResolve = true

				-- ROBLOX deviation: for loop in place of forEach
				for _, l in listeners do
					l()
				end
			end
			local function Async()
				if not didResolve then
					Scheduler.unstable_yieldValue("Suspend!")
					error(thenable)
				end

				Scheduler.unstable_yieldValue("Async")

				return "Async"
			end

			local root = ReactTestRenderer.create(
				React.createElement(
					React.Fragment,
					nil,
					React.createElement(Suspense, {
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					}),
					React.createElement(Text, {
						text = "Initial",
					})
				),
				{ unstable_isConcurrent = true }
			)

			jestExpect(Scheduler).toFlushAndYield({
				"Initial",
			})
			jestExpect(root).toMatchRenderedOutput("Initial")

			-- The update will suspend.
			root.update(
				React.createElement(
					React.Fragment,
					nil,
					React.createElement(Suspense, {
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					}, React.createElement(Async)),
					React.createElement(Text, {
						text = "After Suspense",
					}),
					React.createElement(Text, {
						text = "Sibling",
					})
				)
			)
			-- Yield past the Suspense boundary but don't complete the last sibling.
			jestExpect(Scheduler).toFlushAndYieldThrough({
				"Suspend!",
				"Loading...",
				"After Suspense",
			})

			-- The promise resolves before the current render phase has completed
			resolveThenable()
			jestExpect(Scheduler).toHaveYielded({})
			jestExpect(root).toMatchRenderedOutput("Initial")

			-- Start over from the root, instead of continuing.
			jestExpect(Scheduler).toFlushAndYield({
				-- Async renders again *before* Sibling
				"Async",
				"After Suspense",
				"Sibling",
			})
			jestExpect(root).toMatchRenderedOutput("AsyncAfter SuspenseSibling")
		end
	)

	it(
		"interrupts current render if something already suspended with a "
			.. "delay, and then subsequently there's a lower priority update",
		function()
			local root = ReactTestRenderer.create(
				React.createElement(
					React.Fragment,
					nil,
					React.createElement(Suspense, {
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					}),
					React.createElement(Text, {
						text = "Initial",
					})
				),
				{ unstable_isConcurrent = true }
			)

			jestExpect(Scheduler).toFlushAndYield({
				"Initial",
			})
			jestExpect(root).toMatchRenderedOutput("Initial")
			-- The update will suspend.
			root.update(
				React.createElement(
					React.Fragment,
					nil,
					React.createElement(
						Suspense,
						{
							fallback = React.createElement(Text, {
								text = "Loading...",
							}),
						},
						React.createElement(AsyncText, {
							text = "Async",
							ms = 2000,
						})
					),
					React.createElement(Text, {
						text = "After Suspense",
					}),
					React.createElement(Text, {
						text = "Sibling",
					})
				)
			)
			-- Yield past the Suspense boundary but don't complete the last sibling.
			jestExpect(Scheduler).toFlushAndYieldThrough({
				"Suspend! [Async]",
				"Loading...",
				"After Suspense",
			})
			-- Receives a lower priority update before the current render phase
			-- has completed.
			Scheduler.unstable_advanceTime(1000)
			root.update(
				React.createElement(
					React.Fragment,
					nil,
					React.createElement(Suspense, {
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					}),
					React.createElement(Text, {
						text = "Updated",
					})
				)
			)
			jestExpect(Scheduler).toHaveYielded({})
			jestExpect(root).toMatchRenderedOutput("Initial")
			-- Render the update, instead of continuing
			jestExpect(Scheduler).toFlushAndYield({
				"Updated",
			})
			jestExpect(root).toMatchRenderedOutput("Updated")
		end
	)

	-- -- @gate experimental
	-- it('interrupts current render when something suspends with a ' .. "delay and we've already skipped over a lower priority update in " .. 'a parent', function(
	-- )
	--     local function interrupt()
	--         -- React has a heuristic to batch all updates that occur within the same
	--         -- event. This is a trick to circumvent that heuristic.
	--         ReactTestRenderer.create('whatever')
	--     end
	--     local function App(props)
	--         local shouldSuspend, step = props.shouldSuspend, props.step

	--         return React.createElement(React.Fragment, nil, React.createElement(Text, {
	--             text = string.format('A%s', step),
	--         }), React.createElement(Suspense, {
	--             fallback = React.createElement(Text, {
	--                 text = 'Loading...',
	--             }),
	--         }, (function()
	--             if shouldSuspend then
	--                 return React.createElement(AsyncText, {
	--                     text = 'Async',
	--                     ms = 2000,
	--                 })
	--             end

	--             return nil
	--         end)()), React.createElement(Text, {
	--             text = string.format('B%s', step),
	--         }), React.createElement(Text, {
	--             text = string.format('C%s', step),
	--         }))
	--     end

	--     local root = ReactTestRenderer.create(nil, {unstable_isConcurrent = true})

	--     root.update(React.createElement(App, {
	--         shouldSuspend = false,
	--         step = 0,
	--     }))
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'A0',
	--         'B0',
	--         'C0',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('A0B0C0')

	--     -- This update will suspend.
	--     root.update(React.createElement(App, {
	--         shouldSuspend = true,
	--         step = 1,
	--     }))

	--     -- Do a bit of work
	--     jestExpect(Scheduler).toFlushAndYieldThrough({
	--         'A1',
	--     })

	--     -- Schedule another update. This will have lower priority because it's
	--     -- a transition.
	--     React.unstable_startTransition(function()
	--         root.update(React.createElement(App, {
	--             shouldSuspend = false,
	--             step = 2,
	--         }))
	--     end)

	--     -- Interrupt to trigger a restart.
	--     interrupt()
	--     jestExpect(Scheduler).toFlushAndYieldThrough({
	--         -- Should have restarted the first update, because of the interruption
	--         'A1',
	--         'Suspend! [Async]',
	--         'Loading...',
	--         'B1',
	--     })

	--     -- Should not have committed loading state
	--     jestExpect(root).toMatchRenderedOutput('A0B0C0')

	--     -- After suspending, should abort the first update and switch to the
	--     -- second update. So, C1 should not appear in the log.
	--     -- TODO: This should work even if React does not yield to the main
	--     -- thread. Should use same mechanism as selective hydration to interrupt
	--     -- the render before the end of the current slice of work.
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'A2',
	--         'B2',
	--         'C2',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('A2B2C2')
	-- end)

	-- -- @gate experimental
	-- ROBLOX TODO: AsyncText component
	-- it('interrupts current render when something suspends with a ' ..
	-- "delay and we've already bailed out lower priority update in " ..
	-- 'a parent', _async(function()
	--     -- This is similar to the previous test case, except this covers when
	--     -- React completely bails out on the parent component, without processing
	--     -- the update queue.

	--     local function interrupt()
	--         -- React has a heuristic to batch all updates that occur within the same
	--         -- event. This is a trick to circumvent that heuristic.
	--         ReactTestRenderer.create('whatever')
	--     end

	--     local _React, useState = React, _React.useState

	--     local function Async()
	--         local _useState, _useState2, shouldSuspend, _setShouldSuspend = useState(false), _slicedToArray(_useState, 2), _useState2[0], _useState2[1]

	--         setShouldSuspend = _setShouldSuspend

	--         return React.createElement(React.Fragment, nil, React.createElement(Text, {
	--             text = 'A',
	--         }), React.createElement(Suspense, {
	--             fallback = React.createElement(Text, {
	--                 text = 'Loading...',
	--             }),
	--         }, (function()
	--             if shouldSuspend then
	--                 return React.createElement(AsyncText, {
	--                     text = 'Async',
	--                     ms = 2000,
	--                 })
	--             end

	--             return nil
	--         end)()), React.createElement(Text, {
	--             text = 'B',
	--         }), React.createElement(Text, {
	--             text = 'C',
	--         }))
	--     end

	--     local setShouldSuspend

	--     local function App()
	--         local _useState3, _useState4, shouldHideInParent, _setShouldHideInParent = useState(false), _slicedToArray(_useState3, 2), _useState4[0], _useState4[1]

	--         setShouldHideInParent = _setShouldHideInParent

	--         Scheduler.unstable_yieldValue('shouldHideInParent: ' + shouldHideInParent)

	--         return(function()
	--             if shouldHideInParent then
	--                 return React.createElement(Text, {
	--                     text = '(empty)',
	--                 })
	--             end

	--             return React.createElement(Async)
	--         end)()
	--     end

	--     local setShouldHideInParent
	--     local root = ReactTestRenderer.create(nil, {unstable_isConcurrent = true})

	--     return _awaitIgnored(act(_async(function()
	--         root.update(React.createElement(App))
	--         jestExpect(Scheduler).toFlushAndYield({
	--             'shouldHideInParent: false',
	--             'A',
	--             'B',
	--             'C',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('ABC')

	--         -- This update will suspend.
	--         setShouldSuspend(true)

	--         -- Need to move into the next async bucket.
	--         -- Do a bit of work, then interrupt to trigger a restart.
	--         jestExpect(Scheduler).toFlushAndYieldThrough({
	--             'A',
	--         })
	--         interrupt()
	--         -- Should not have committed loading state
	--         jestExpect(root).toMatchRenderedOutput('ABC')

	--         -- Schedule another update. This will have lower priority because it's
	--         -- a transition.
	--         React.unstable_startTransition(function()
	--             setShouldHideInParent(true)
	--         end)
	--         jestExpect(Scheduler).toFlushAndYieldThrough({
	--             -- Should have restarted the first update, because of the interruption
	--             'A',
	--             'Suspend! [Async]',
	--             'Loading...',
	--             'B',
	--         })

	--         -- Should not have committed loading state
	--         jestExpect(root).toMatchRenderedOutput('ABC')

	--         -- After suspending, should abort the first update and switch to the
	--         -- second update.
	--         jestExpect(Scheduler).toFlushAndYield({
	--             'shouldHideInParent: true',
	--             '(empty)',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('(empty)')

	--         return _await()
	--     end)))
	-- end))
	xit(
		"interrupts current render when something suspends with a "
			.. "delay, and a parent received an update after it completed",
		function()
			local function App(props)
				local shouldSuspend, step = props.shouldSuspend, props.step

				return React.createElement(React.Fragment, nil, {
					React.createElement(Text, { text = string.format("A%s", step) }),
					React.createElement(
						Suspense,
						{
							fallback = React.createElement(Text, {
								text = "Loading...",
							}),
						},
						(function()
							if shouldSuspend then
								return React.createElement(AsyncText, {
									text = "Async",
									ms = 2000,
								})
							end

							return nil
						end)()
					),
					React.createElement(Text, { text = string.format("B%s", step) }),
					React.createElement(Text, { text = string.format("C%s", step) }),
				})
			end

			local root = ReactTestRenderer.create(nil, { unstable_isConcurrent = true })

			root.update(React.createElement(App, {
				shouldSuspend = false,
				step = 0,
			}))
			jestExpect(Scheduler).toFlushAndYield({
				"A0",
				"B0",
				"C0",
			})
			jestExpect(root).toMatchRenderedOutput("A0B0C0")

			-- This update will suspend.
			root.update(React.createElement(App, {
				shouldSuspend = true,
				step = 1,
			}))
			-- Flush past the root, but stop before the async component.
			jestExpect(Scheduler).toFlushAndYieldThrough({
				"A1",
			})

			-- Schedule an update on the root, which already completed.
			root.update(React.createElement(App, {
				shouldSuspend = false,
				step = 2,
			}))
			-- We'll keep working on the existing update.
			jestExpect(Scheduler).toFlushAndYieldThrough({
				"Suspend! [Async]",
				"Loading...",
				"B1",
			})
			-- Should not have committed loading state
			jestExpect(root).toMatchRenderedOutput("A0B0C0")

			-- After suspending, should abort the first update and switch to the
=======
	it("throttles fallback committing globally", function()
		local function Foo()
			Scheduler:unstable_yieldValue("Foo")
			return React.createElement(
				Suspense,
				{ fallback = React.createElement(Text, { text = "Loading..." }) },
				React.createElement(AsyncText, { text = "A", ms = 200 }),
				React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading more..." }) },
					React.createElement(AsyncText, { text = "B", ms = 300 })
				)
			)
		end -- Committing fallbacks should be throttled.
		-- First, advance some time to skip the first threshold.
		jest.advanceTimersByTime(600)
		Scheduler:unstable_advanceTime(600)
		local root = ReactTestRenderer.create(React.createElement(Foo, nil), { unstable_isConcurrent = true })
		expect(Scheduler).toFlushAndYield({
			"Foo",
			"Suspend! [A]",
			"Suspend! [B]",
			"Loading more...",
			"Loading...",
		})
		expect(root).toMatchRenderedOutput("Loading...") -- Resolve A.
		jest.advanceTimersByTime(200)
		Scheduler:unstable_advanceTime(200)
		expect(Scheduler).toHaveYielded({ "Promise resolved [A]" })
		expect(Scheduler).toFlushAndYield({ "A", "Suspend! [B]", "Loading more..." }) -- By this point, we have enough info to show "A" and "Loading more..."
		-- However, we've just shown the outer fallback. So we'll delay
		-- showing the inner fallback hoping that B will resolve soon enough.
		expect(root).toMatchRenderedOutput("Loading...") -- Resolve B.
		jest.advanceTimersByTime(100)
		Scheduler:unstable_advanceTime(100)
		expect(Scheduler).toHaveYielded({ "Promise resolved [B]" }) -- By this point, B has resolved.
		-- We're still showing the outer fallback.
		expect(root).toMatchRenderedOutput("Loading...")
		expect(Scheduler).toFlushAndYield({ "A", "B" }) -- Then contents of both should pop in together.
		expect(root).toMatchRenderedOutput("AB")
	end)
	it("does not throttle fallback committing for too long", function()
		local function Foo()
			Scheduler:unstable_yieldValue("Foo")
			return React.createElement(
				Suspense,
				{ fallback = React.createElement(Text, { text = "Loading..." }) },
				React.createElement(AsyncText, { text = "A", ms = 200 }),
				React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading more..." }) },
					React.createElement(AsyncText, { text = "B", ms = 1200 })
				)
			)
		end -- Committing fallbacks should be throttled.
		-- First, advance some time to skip the first threshold.
		jest.advanceTimersByTime(600)
		Scheduler:unstable_advanceTime(600)
		local root = ReactTestRenderer.create(React.createElement(Foo, nil), { unstable_isConcurrent = true })
		expect(Scheduler).toFlushAndYield({
			"Foo",
			"Suspend! [A]",
			"Suspend! [B]",
			"Loading more...",
			"Loading...",
		})
		expect(root).toMatchRenderedOutput("Loading...") -- Resolve A.
		jest.advanceTimersByTime(200)
		Scheduler:unstable_advanceTime(200)
		expect(Scheduler).toHaveYielded({ "Promise resolved [A]" })
		expect(Scheduler).toFlushAndYield({ "A", "Suspend! [B]", "Loading more..." }) -- By this point, we have enough info to show "A" and "Loading more..."
		-- However, we've just shown the outer fallback. So we'll delay
		-- showing the inner fallback hoping that B will resolve soon enough.
		expect(root).toMatchRenderedOutput("Loading...") -- Wait some more. B is still not resolving.
		jest.advanceTimersByTime(500)
		Scheduler:unstable_advanceTime(500) -- Give up and render A with a spinner for B.
		expect(root).toMatchRenderedOutput("ALoading more...") -- Resolve B.
		jest.advanceTimersByTime(500)
		Scheduler:unstable_advanceTime(500)
		expect(Scheduler).toHaveYielded({ "Promise resolved [B]" })
		expect(Scheduler).toFlushAndYield({ "B" })
		expect(root).toMatchRenderedOutput("AB")
	end) -- @gate !enableSyncDefaultUpdates
	it(
		"interrupts current render when something suspends with a "
			.. "delay and we've already skipped over a lower priority update in "
			.. "a parent",
		function()
			local function interrupt()
				-- React has a heuristic to batch all updates that occur within the same
				-- event. This is a trick to circumvent that heuristic.
				ReactTestRenderer.create("whatever")
			end
			local function App(ref0)
				local shouldSuspend, step = ref0.shouldSuspend, ref0.step
				return React.createElement(
					React.Fragment,
					nil,
					React.createElement(Text, { text = ("A%s"):format(tostring(step)) }),
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						if Boolean.toJSBoolean(shouldSuspend)
							then React.createElement(AsyncText, { text = "Async", ms = 2000 })
							else nil
					),
					React.createElement(Text, { text = ("B%s"):format(tostring(step)) }),
					React.createElement(Text, { text = ("C%s"):format(tostring(step)) })
				)
			end
			local root = ReactTestRenderer.create(nil, { unstable_isConcurrent = true })
			root:update(React.createElement(App, { shouldSuspend = false, step = 0 }))
			expect(Scheduler).toFlushAndYield({ "A0", "B0", "C0" })
			expect(root).toMatchRenderedOutput("A0B0C0") -- This update will suspend.
			root:update(React.createElement(App, { shouldSuspend = true, step = 1 })) -- Do a bit of work
			expect(Scheduler).toFlushAndYieldThrough({ "A1" }) -- Schedule another update. This will have lower priority because it's
			-- a transition.
			React.startTransition(function()
				root:update(React.createElement(App, { shouldSuspend = false, step = 2 }))
			end) -- Interrupt to trigger a restart.
			interrupt()
			expect(Scheduler).toFlushAndYieldThrough({
				-- Should have restarted the first update, because of the interruption
				"A1",
				"Suspend! [Async]",
				"Loading...",
				"B1",
			}) -- Should not have committed loading state
			expect(root).toMatchRenderedOutput("A0B0C0") -- After suspending, should abort the first update and switch to the
>>>>>>> upstream-apply
			-- second update. So, C1 should not appear in the log.
			-- TODO: This should work even if React does not yield to the main
			-- thread. Should use same mechanism as selective hydration to interrupt
			-- the render before the end of the current slice of work.
<<<<<<< HEAD
			-- ROBLOX FIXME: currently failing right here, gets empty
			jestExpect(Scheduler).toFlushAndYield({
				"A2",
				"B2",
				"C2",
			})
			jestExpect(root).toMatchRenderedOutput("A2B2C2")
=======
			expect(Scheduler).toFlushAndYield({ "A2", "B2", "C2" })
			expect(root).toMatchRenderedOutput("A2B2C2")
>>>>>>> upstream-apply
		end
	)

	it("mounts a lazy class component in non-concurrent mode", function()
		jest.useRealTimers()
		local fakeImport = function(result)
			-- ROBLOX deviation: delay(0) because resolved promises are andThen'd on the same tick cycle
			-- remove once addressed in polyfill
			return Promise.delay(0):andThen(function()
				return { default = result }
			end)
<<<<<<< HEAD
		end
		local Class = React.Component:extend("Class")

		function Class:componentDidMount()
			Scheduler.unstable_yieldValue("Did mount: " .. self.props.label)
		end
		function Class:componentDidUpdate()
			Scheduler.unstable_yieldValue("Did update: " .. self.props.label)
		end
		function Class:render()
			return React.createElement(Text, {
				text = self.props.label,
			})
		end

		local LazyClass = React.lazy(function()
			return fakeImport(Class)
=======
			local root = ReactTestRenderer.create(
				React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(LazyClass, { label = "Hi" })
				)
			)
			expect(Scheduler).toHaveYielded({ "Loading..." })
			expect(root).toMatchRenderedOutput("Loading...")
			LazyClass:expect()
			expect(Scheduler).toFlushUntilNextPaint({ "Hi", "Did mount: Hi" })
			expect(root).toMatchRenderedOutput("Hi")
>>>>>>> upstream-apply
		end)
		local root = ReactTestRenderer.create(React.createElement(
			Suspense,
			{
				fallback = React.createElement(Text, {
					text = "Loading...",
				}),
			},
			React.createElement(LazyClass, {
				label = "Hi",
			})
		))

		jestExpect(Scheduler).toHaveYielded({
			"Loading...",
		})
		jestExpect(root).toMatchRenderedOutput("Loading...")

		-- ROBLOX deviation: used to synchronize on the above Promise.delay()
		Promise.delay(0):await()

		jestExpect(Scheduler).toFlushExpired({
			"Hi",
			"Did mount: Hi",
		})
		jestExpect(root).toMatchRenderedOutput("Hi")
	end)
<<<<<<< HEAD

	it("only captures if `fallback` is defined", function()
		-- ROBLOX deviation START: add useFakeTimers()
		jest.useFakeTimers()
		-- ROBLOX deviation END
		local root = ReactTestRenderer.create(
			React.createElement(
				Suspense,
				{
					fallback = React.createElement(Text, {
						text = "Loading...",
					}),
				},
				React.createElement(
					Suspense,
					nil,
					React.createElement(AsyncText, {
						text = "Hi",
						ms = 5000,
					})
				)
			),
			{ unstable_isConcurrent = true }
		)

		jestExpect(Scheduler).toFlushAndYield({
			"Suspend! [Hi]",
			-- The outer fallback should be rendered, because the inner one does not
			-- have a `fallback` prop
			"Loading...",
		})
		jest.advanceTimersByTime(1000)
		jestExpect(Scheduler).toHaveYielded({})
		jestExpect(Scheduler).toFlushAndYield({})
		jestExpect(root).toMatchRenderedOutput("Loading...")
		jest.advanceTimersByTime(5000)
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [Hi]",
		})
		jestExpect(Scheduler).toFlushAndYield({
			"Hi",
		})
		jestExpect(root).toMatchRenderedOutput("Hi")
	end)
	it(
		"throws if tree suspends and none of the Suspense ancestors have a fallback",
		function()
			ReactTestRenderer.create(
=======
	it("updates memoized child of suspense component when context updates (simple memo)", function()
		local useContext, createContext, useState, memo =
			React.useContext, React.createContext, React.useState, React.memo
		local ValueContext = createContext(nil)
		local MemoizedChild = memo(function()
			local text = useContext(ValueContext)
			do --[[ ROBLOX COMMENT: try-catch block conversion ]]
				local ok, result, hasReturned = xpcall(function()
					TextResource:read({ text, 1000 })
					Scheduler:unstable_yieldValue(text)
					return text, true
				end, function(promise)
					if typeof(promise["then"]) == "function" then
						Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
					else
						Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
					end
					error(promise)
				end)
				if hasReturned then
					return result
				end
			end
		end)
		local setValue
		local function App()
			local value, _setValue = table.unpack(useState("default"), 1, 2)
			setValue = _setValue
			return React.createElement(
				ValueContext.Provider,
				{ value = value },
>>>>>>> upstream-apply
				React.createElement(
					Suspense,
					nil,
					React.createElement(AsyncText, {
						text = "Hi",
						ms = 1000,
					})
				),
				{ unstable_isConcurrent = true }
			)
			-- ROBLOX Test Noise: in upstream, jest setup config makes these
			-- tests hide the error boundary warnings they trigger
			-- (scripts/jest/setupTests.js:72)
			jestExpect(Scheduler).toFlushAndThrow(
				"AsyncText suspended while rendering, but no fallback UI was specified."
			)
			jestExpect(Scheduler).toHaveYielded({
				"Suspend! [Hi]",
				"Suspend! [Hi]",
			})
		end
	)
	it(
		"updates memoized child of suspense component when context updates (simple memo)",
		function()
			-- ROBLOX deviation START: add useFakeTimers()
			jest.useFakeTimers()
			-- ROBLOX deviation END
			local useContext, createContext, useState, memo =
				React.useContext, React.createContext, React.useState, React.memo
			local ValueContext = createContext(nil)
			local MemoizedChild = memo(function()
				local text = useContext(ValueContext)
				local ok, result = pcall(function()
					TextResource.read({ text, 1000 })
					Scheduler.unstable_yieldValue(text)
				end)
				if not ok then
					if typeof(result.andThen) == "function" then
						Scheduler.unstable_yieldValue(
							string.format("Suspend! [%s]", text)
						)
					else
						Scheduler.unstable_yieldValue(string.format("Error! [%s]", text))
					end
					error(result)
				end
<<<<<<< HEAD
				return text
			end)
			local value, setValue

=======
			end
		end)
		local setValue
		local function App(ref0)
			local children = ref0.children
			local value, _setValue = table.unpack(useState("default"), 1, 2)
			setValue = _setValue
			return React.createElement(ValueContext.Provider, { value = value }, children)
		end
		local root = ReactTestRenderer.create(
			React.createElement(
				App,
				nil,
				React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(MemoizedChild, nil)
				)
			),
			{ unstable_isConcurrent = true }
		)
		expect(Scheduler).toFlushAndYield({ "Suspend! [default]", "Loading..." })
		jest.advanceTimersByTime(1000)
		expect(Scheduler).toHaveYielded({ "Promise resolved [default]" })
		expect(Scheduler).toFlushAndYield({ "default" })
		expect(root).toMatchRenderedOutput("default")
		act(function()
			return setValue("new value")
		end)
		expect(Scheduler).toHaveYielded({ "Suspend! [new value]", "Loading..." })
		jest.advanceTimersByTime(1000)
		expect(Scheduler).toHaveYielded({ "Promise resolved [new value]" })
		expect(Scheduler).toFlushAndYield({ "new value" })
		expect(root).toMatchRenderedOutput("new value")
	end) -- @gate enableSuspenseLayoutEffectSemantics
	it("re-fires layout effects when re-showing Suspense", function()
		local function TextWithLayout(props)
			Scheduler:unstable_yieldValue(props.text)
			React.useLayoutEffect(function()
				Scheduler:unstable_yieldValue("create layout")
				return function()
					Scheduler:unstable_yieldValue("destroy layout")
				end
			end, {})
			return props.text
		end
		local _setShow
		local function App(props)
			local show, setShow = table.unpack(React.useState(false), 1, 2)
			_setShow = setShow
			return React.createElement(
				Suspense,
				{ fallback = React.createElement(Text, { text = "Loading..." }) },
				React.createElement(TextWithLayout, { text = "Child 1" }),
				if Boolean.toJSBoolean(show)
					then React.createElement(AsyncText, { ms = 1000, text = "Child 2" })
					else show
			)
		end
		local root = ReactTestRenderer.create(React.createElement(App, nil), { unstable_isConcurrent = true })
		expect(Scheduler).toFlushAndYield({ "Child 1", "create layout" })
		expect(root).toMatchRenderedOutput("Child 1")
		act(function()
			_setShow(true)
		end)
		expect(Scheduler).toHaveYielded({ "Child 1", "Suspend! [Child 2]", "Loading..." })
		jest.advanceTimersByTime(1000)
		expect(Scheduler).toHaveYielded({ "destroy layout", "Promise resolved [Child 2]" })
		expect(Scheduler).toFlushAndYield({ "Child 1", "Child 2", "create layout" })
		expect(root).toMatchRenderedOutput(Array.join({ "Child 1", "Child 2" }, ""))
	end)
	describe("outside concurrent mode", function()
		it("a mounted class component can suspend without losing state", function()
			type TextWithLifecycle = React_Component<any, any> & {}
			type TextWithLifecycle_statics = {}
			local TextWithLifecycle =
				React.Component:extend("TextWithLifecycle") :: TextWithLifecycle & TextWithLifecycle_statics
			function TextWithLifecycle.componentDidMount(self: TextWithLifecycle)
				Scheduler:unstable_yieldValue(("Mount [%s]"):format(tostring(self.props.text)))
			end
			function TextWithLifecycle.componentDidUpdate(self: TextWithLifecycle)
				Scheduler:unstable_yieldValue(("Update [%s]"):format(tostring(self.props.text)))
			end
			function TextWithLifecycle.componentWillUnmount(self: TextWithLifecycle)
				Scheduler:unstable_yieldValue(("Unmount [%s]"):format(tostring(self.props.text)))
			end
			function TextWithLifecycle.render(self: TextWithLifecycle)
				return React.createElement(Text, self.props)
			end
			local instance
			type AsyncTextWithLifecycle = React_Component<any, any> & { state: Object }
			type AsyncTextWithLifecycle_statics = {}
			local AsyncTextWithLifecycle =
				React.Component:extend("AsyncTextWithLifecycle") :: AsyncTextWithLifecycle & AsyncTextWithLifecycle_statics
			function AsyncTextWithLifecycle.init(self: AsyncTextWithLifecycle)
				self.state = { step = 1 }
			end
			function AsyncTextWithLifecycle.componentDidMount(self: AsyncTextWithLifecycle)
				Scheduler:unstable_yieldValue(
					("Mount [%s:%s]"):format(tostring(self.props.text), tostring(self.state.step))
				)
			end
			function AsyncTextWithLifecycle.componentDidUpdate(self: AsyncTextWithLifecycle)
				Scheduler:unstable_yieldValue(
					("Update [%s:%s]"):format(tostring(self.props.text), tostring(self.state.step))
				)
			end
			function AsyncTextWithLifecycle.componentWillUnmount(self: AsyncTextWithLifecycle)
				Scheduler:unstable_yieldValue(
					("Unmount [%s:%s]"):format(tostring(self.props.text), tostring(self.state.step))
				)
			end
			function AsyncTextWithLifecycle.render(self: AsyncTextWithLifecycle)
				instance = self
				local text = ("%s:%s"):format(tostring(self.props.text), tostring(self.state.step))
				local ms = self.props.ms
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ text, ms })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end
>>>>>>> upstream-apply
			local function App()
				value, setValue = useState("default")

				return React.createElement(
					ValueContext.Provider,
					{ value = value },
					React.createElement(Suspense, {
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					}, React.createElement(MemoizedChild))
				)
			end

			local root = ReactTestRenderer.create(
				React.createElement(App),
				{ unstable_isConcurrent = true }
			)

			jestExpect(Scheduler).toFlushAndYield({
				"Suspend! [default]",
				"Loading...",
			})
<<<<<<< HEAD
			jest.advanceTimersByTime(1000)
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [default]",
			})
			jestExpect(Scheduler).toFlushAndYield({
				"default",
			})
			jestExpect(root).toMatchRenderedOutput("default")
			ReactTestRenderer.act(function()
				return setValue("new value")
			end)
			jestExpect(Scheduler).toHaveYielded({
				"Suspend! [new value]",
				"Loading...",
			})
			jest.advanceTimersByTime(1000)
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [new value]",
			})
			jestExpect(Scheduler).toFlushAndYield({
				"new value",
			})
			-- ROBLOX FIXME: this last render doesn't flush, so this fails because it receives nil
			jestExpect(root).toMatchRenderedOutput("new value")
		end
	)
	-- it('updates memoized child of suspense component when context updates (manual memo)', function()
	--     local _React3, useContext, createContext, useState, memo = React, _React3.useContext, _React3.createContext, _React3.useState, _React3.memo
	--     local ValueContext = createContext(nil)
	--     local MemoizedChild = memo(function()
	--         local text = useContext(ValueContext)
	--     end, function(prevProps, nextProps)
	--         return true
	--     end)
	--     local setValue

	--     local function App()
	--         local _useState7, _useState8, value, _setValue = useState('default'), _slicedToArray(_useState7, 2), _useState8[0], _useState8[1]

	--         setValue = _setValue

	--         return React.createElement(ValueContext.Provider, {value = value}, React.createElement(Suspense, {
	--             fallback = React.createElement(Text, {
	--                 text = 'Loading...',
	--             }),
	--         }, React.createElement(MemoizedChild)))
	--     end

	--     local root = ReactTestRenderer.create(React.createElement(App), {unstable_isConcurrent = true})

	--     jestExpect(Scheduler).toFlushAndYield({
	--         'Suspend! [default]',
	--         'Loading...',
	--     })
	--     jest.advanceTimersByTime(1000)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [default]',
	--     })
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'default',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('default')
	--     act(function()
	--         return setValue('new value')
	--     end)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Suspend! [new value]',
	--         'Loading...',
	--     })
	--     jest.advanceTimersByTime(1000)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [new value]',
	--     })
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'new value',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('new value')
	-- end)
	-- it('updates memoized child of suspense component when context updates (function)', function()
	--     local _React4, useContext, createContext, useState = React, _React4.useContext, _React4.createContext, _React4.useState
	--     local ValueContext = createContext(nil)

	--     local function MemoizedChild()
	--         local text = useContext(ValueContext)
	--     end

	--     local setValue

	--     local function App(_ref8)
	--         local children = _ref8.children
	--         local _useState9, _useState10, value, _setValue = useState('default'), _slicedToArray(_useState9, 2), _useState10[0], _useState10[1]

	--         setValue = _setValue

	--         return React.createElement(ValueContext.Provider, {value = value}, children)
	--     end

	--     local root = ReactTestRenderer.create(React.createElement(App, nil, React.createElement(Suspense, {
	--         fallback = React.createElement(Text, {
	--             text = 'Loading...',
	--         }),
	--     }, React.createElement(MemoizedChild))), {unstable_isConcurrent = true})

	--     jestExpect(Scheduler).toFlushAndYield({
	--         'Suspend! [default]',
	--         'Loading...',
	--     })
	--     jest.advanceTimersByTime(1000)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [default]',
	--     })
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'default',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('default')
	--     act(function()
	--         return setValue('new value')
	--     end)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Suspend! [new value]',
	--         'Loading...',
	--     })
	--     jest.advanceTimersByTime(1000)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [new value]',
	--     })
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'new value',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('new value')
	-- end)
	-- it('updates memoized child of suspense component when context updates (forwardRef)', function()
	--     local _React5, forwardRef, useContext, createContext, useState = React, _React5.forwardRef, _React5.useContext, _React5.createContext, _React5.useState
	--     local ValueContext = createContext(nil)
	--     local MemoizedChild = forwardRef(function()
	--         local text = useContext(ValueContext)
	--     end)
	--     local setValue

	--     local function App(_ref9)
	--         local children = _ref9.children
	--         local _useState11, _useState12, value, _setValue = useState('default'), _slicedToArray(_useState11, 2), _useState12[0], _useState12[1]

	--         setValue = _setValue

	--         return React.createElement(ValueContext.Provider, {value = value}, children)
	--     end

	--     local root = ReactTestRenderer.create(React.createElement(App, nil, React.createElement(Suspense, {
	--         fallback = React.createElement(Text, {
	--             text = 'Loading...',
	--         }),
	--     }, React.createElement(MemoizedChild))), {unstable_isConcurrent = true})

	--     jestExpect(Scheduler).toFlushAndYield({
	--         'Suspend! [default]',
	--         'Loading...',
	--     })
	--     jest.advanceTimersByTime(1000)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [default]',
	--     })
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'default',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('default')
	--     act(function()
	--         return setValue('new value')
	--     end)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Suspend! [new value]',
	--         'Loading...',
	--     })
	--     jest.advanceTimersByTime(1000)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [new value]',
	--     })
	--     jestExpect(Scheduler).toFlushAndYield({
	--         'new value',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('new value')
	-- end)
	-- describe('outside concurrent mode', function()
	-- it('a mounted class component can suspend without losing state', function()
	--     local TextWithLifecycle = React.Component:extend("TextWithLifecycle")

	--     function TextWithLifecycle:componentDidMount()
	--         Scheduler.unstable_yieldValue(string.format('Mount [%s]', self.props.text))
	--     end
	--     function TextWithLifecycle:componentDidUpdate()
	--         Scheduler.unstable_yieldValue(string.format('Update [%s]', self.props.text))
	--     end
	--     function TextWithLifecycle:componentWillUnmount()
	--         Scheduler.unstable_yieldValue(string.format('Unmount [%s]', self.props.text))
	--     end
	--     function TextWithLifecycle:render()
	--         return React.createElement(Text, self.props)
	--     end

	--     local instance
	--     local AsyncTextWithLifecycle = React.Component:extend("AsyncTextWithLifecycle")

	--     function AsyncTextWithLifecycle:init()
	--         self.state = {
	--             step = 1
	--         }
	--     end
	--     function AsyncTextWithLifecycle:componentDidMount()
	--         Scheduler.unstable_yieldValue(string.format('Mount [%s:%s]', self.props.text, self.state.step))
	--     end
	--     function AsyncTextWithLifecycle:componentDidUpdate()
	--         Scheduler.unstable_yieldValue(string.format('Update [%s:%s]', self.props.text, self.state.step))
	--     end
	--     function AsyncTextWithLifecycle:componentWillUnmount()
	--         Scheduler.unstable_yieldValue(string.format('Unmount [%s:%s]', self.props.text, self.state.step))
	--     end
	--     function AsyncTextWithLifecycle:render()
	--         instance = self

	--         local text = string.format('%s:%s', self.props.text, self.state.step)
	--         local ms = self.props.ms

	--         local ok, result = pcall(function()
	--             TextResource.read({text, ms})
	--             Scheduler.unstable_yieldValue(text);
	--             return text;
	--         end)
	--         if not ok then
	--             if typeof(result.andThen) == 'function' then
	--                 Scheduler.unstable_yieldValue("Suspend! [" .. text .. "]")
	--                 else
	--                 Scheduler.unstable_yieldValue("Error! [" .. text .. "]")
	--                 end
	--                 error(result)
	--         end
	--     end

	--     local function App()
	--         return React.createElement(Suspense, {
	--             fallback = React.createElement(TextWithLifecycle, {
	--                 text = 'Loading...',
	--             }),
	--         }, React.createElement(TextWithLifecycle, {
	--             text = 'A',
	--         }), React.createElement(AsyncTextWithLifecycle, {
	--             ms = 100,
	--             text = 'B',
	--             ref = instance,
	--         }), React.createElement(TextWithLifecycle, {
	--             text = 'C',
	--         }))
	--     end

	--     local root = ReactTestRenderer.create(React.createElement(App))

	--     jestExpect(Scheduler).toHaveYielded({
	--         'A',
	--         'Suspend! [B:1]',
	--         'C',
	--         'Loading...',
	--         'Mount [A]',
	--         -- B's lifecycle should not fire because it suspended
	--         -- 'Mount [B]',
	--         'Mount [C]',
	--         'Mount [Loading...]',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('Loading...')
	--     jest.advanceTimersByTime(100)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [B:1]',
	--     })
	--     jestExpect(Scheduler).toFlushExpired({
	--         'B:1',
	--         'Unmount [Loading...]',
	--         -- Should be a mount, not an update
	--         'Mount [B:1]',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('AB:1C')
	--     instance.setState({step = 2})
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Suspend! [B:2]',
	--         'Loading...',
	--         'Mount [Loading...]',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('Loading...')
	--     jest.advanceTimersByTime(100)
	--     jestExpect(Scheduler).toHaveYielded({
	--         'Promise resolved [B:2]',
	--     })
	--     jestExpect(Scheduler).toFlushExpired({
	--         'B:2',
	--         'Unmount [Loading...]',
	--         'Update [B:2]',
	--     })
	--     jestExpect(root).toMatchRenderedOutput('AB:2C')
	-- end)
	--     it('bails out on timed-out primary children even if they receive an update', function()
	--         local instance
	--         local Stateful = {}
	--         local StatefulMetatable = {__index = Stateful}

	--         function Stateful.new()
	--             local self = setmetatable({}, StatefulMetatable)
	--             local _temp2

	--             return
	--         end
	--         function Stateful:render()
	--             instance = self

	--             return React.createElement(Text, {
	--                 text = string.format('Stateful: %s', self.state.step),
	--             })
	--         end

	--         local function App(props)
	--             return React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(Stateful), React.createElement(AsyncText, {
	--                 ms = 1000,
	--                 text = props.text,
	--             }))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App, {
	--             text = 'A',
	--         }))

	--         jestExpect(Scheduler).toHaveYielded({
	--             'Stateful: 1',
	--             'Suspend! [A]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [A]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'A',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Stateful: 1A')
	--         root.update(React.createElement(App, {
	--             text = 'B',
	--         }))
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Stateful: 1',
	--             'Suspend! [B]',
	--             'Loading...',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Loading...')
	--         instance.setState({step = 2})
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Stateful: 2',

	--             -- The suspended component should suspend again. If it doesn't, the
	--             -- likely mistake is that the suspended fiber wasn't marked with
	--             -- pending work, so it was improperly treated as complete.
	--             'Suspend! [B]',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Loading...')
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [B]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'B',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Stateful: 2B')
	--     end)
	it(
		"when updating a timed-out tree, always retries the suspended component",
		function()
			-- ROBLOX deviation START: add useFakeTimers()
			jest.useFakeTimers()
			-- ROBLOX deviation END
=======
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(100)
			expect(Scheduler).toHaveYielded({ "Promise resolved [B:1]" })
			expect(Scheduler).toFlushUntilNextPaint({
				"B:1",
				"Unmount [Loading...]",
				-- Should be a mount, not an update
				"Mount [B:1]",
			})
			expect(root).toMatchRenderedOutput("AB:1C")
			instance:setState({ step = 2 })
			expect(Scheduler).toHaveYielded({ "Suspend! [B:2]", "Loading...", "Mount [Loading...]" })
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(100)
			expect(Scheduler).toHaveYielded({ "Promise resolved [B:2]" })
			expect(Scheduler).toFlushUntilNextPaint({
				"B:2",
				"Unmount [Loading...]",
				"Update [B:2]",
			})
			expect(root).toMatchRenderedOutput("AB:2C")
		end)
		it("bails out on timed-out primary children even if they receive an update", function()
>>>>>>> upstream-apply
			local instance
			local Stateful = React.Component:extend("Stateful")
			function Stateful:init()
				self.state = { step = 1 }
			end
			function Stateful:render()
				instance = self
<<<<<<< HEAD

				return React.createElement(Text, {
					text = string.format("Stateful: %s", self.state.step),
				})
=======
				return React.createElement(Text, { text = ("Stateful: %s"):format(tostring(self.state.step)) })
			end
			local function App(props)
				return React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(Stateful, nil),
					React.createElement(AsyncText, { ms = 1000, text = props.text })
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, { text = "A" }))
			expect(Scheduler).toHaveYielded({ "Stateful: 1", "Suspend! [A]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [A]" })
			expect(Scheduler).toFlushUntilNextPaint({ "A" })
			expect(root).toMatchRenderedOutput("Stateful: 1A")
			root:update(React.createElement(App, { text = "B" }))
			expect(Scheduler).toHaveYielded({ "Stateful: 1", "Suspend! [B]", "Loading..." })
			expect(root).toMatchRenderedOutput("Loading...")
			instance:setState({ step = 2 })
			expect(Scheduler).toHaveYielded({ "Stateful: 2", "Suspend! [B]" })
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [B]" })
			expect(Scheduler).toFlushUntilNextPaint({ "B" })
			expect(root).toMatchRenderedOutput("Stateful: 2B")
		end)
		it("when updating a timed-out tree, always retries the suspended component", function()
			local instance
			type Stateful = React_Component<any, any> & { state: Object }
			type Stateful_statics = {}
			local Stateful = React.Component:extend("Stateful") :: Stateful & Stateful_statics
			function Stateful.init(self: Stateful)
				self.state = { step = 1 }
			end
			function Stateful.render(self: Stateful)
				instance = self
				return React.createElement(Text, { text = ("Stateful: %s"):format(tostring(self.state.step)) })
>>>>>>> upstream-apply
			end

			local Indirection = React.Fragment

			local function App(props)
				return React.createElement(
					Suspense,
					{
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					},
					React.createElement(Stateful),
					React.createElement(
						Indirection,
						nil,
						React.createElement(
							Indirection,
							nil,
							React.createElement(
								Indirection,
								nil,
								React.createElement(AsyncText, {
									ms = 1000,
									text = props.text,
								})
							)
						)
					)
				)
			end

			local root = ReactTestRenderer.create(React.createElement(App, {
				text = "A",
			}))

			jestExpect(Scheduler).toHaveYielded({
				"Stateful: 1",
				"Suspend! [A]",
				"Loading...",
			})
			jest.advanceTimersByTime(1000)
<<<<<<< HEAD
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [A]",
			})
			jestExpect(Scheduler).toFlushExpired({
				"A",
			})
			jestExpect(root).toMatchRenderedOutput("Stateful: 1A")
			root.update(React.createElement(App, {
				text = "B",
			}))
			jestExpect(Scheduler).toHaveYielded({
				"Stateful: 1",
				"Suspend! [B]",
				"Loading...",
			})
			-- ROBLOX FIXME: test fails here, rendered output is empty
			jestExpect(root).toMatchRenderedOutput("Loading...")
=======
			expect(Scheduler).toHaveYielded({ "Promise resolved [A]" })
			expect(Scheduler).toFlushUntilNextPaint({ "A" })
			expect(root).toMatchRenderedOutput("Stateful: 1A")
			root:update(React.createElement(App, { text = "B" }))
			expect(Scheduler).toHaveYielded({ "Stateful: 1", "Suspend! [B]", "Loading..." })
			expect(root).toMatchRenderedOutput("Loading...")
>>>>>>> upstream-apply
			instance:setState({ step = 2 })
			jestExpect(Scheduler).toHaveYielded({
				"Stateful: 2",
				"Suspend! [B]",
			})
			jestExpect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(1000)
<<<<<<< HEAD
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [B]",
=======
			expect(Scheduler).toHaveYielded({ "Promise resolved [B]" })
			expect(Scheduler).toFlushUntilNextPaint({ "B" })
			expect(root).toMatchRenderedOutput("Stateful: 2B")
		end)
		it("suspends in a class that has componentWillUnmount and is then deleted", function()
			type AsyncTextWithUnmount = React_Component<any, any> & {}
			type AsyncTextWithUnmount_statics = {}
			local AsyncTextWithUnmount =
				React.Component:extend("AsyncTextWithUnmount") :: AsyncTextWithUnmount & AsyncTextWithUnmount_statics
			function AsyncTextWithUnmount.componentWillUnmount(self: AsyncTextWithUnmount)
				Scheduler:unstable_yieldValue("will unmount")
			end
			function AsyncTextWithUnmount.render(self: AsyncTextWithUnmount)
				local text = self.props.text
				local ms = self.props.ms
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ text, ms })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end
			local function App(ref0)
				local text = ref0.text
				return React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(AsyncTextWithUnmount, { text = text, ms = 100 })
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, { text = "A" }))
			expect(Scheduler).toHaveYielded({ "Suspend! [A]", "Loading..." })
			root:update(React.createElement(Text, { text = "B" })) -- Should not fire componentWillUnmount
			expect(Scheduler).toHaveYielded({ "B" })
			expect(root).toMatchRenderedOutput("B")
		end)
		it("suspends in a component that also contains useEffect", function()
			local useLayoutEffect = React.useLayoutEffect
			local function AsyncTextWithEffect(props)
				local text = props.text
				useLayoutEffect(function()
					Scheduler:unstable_yieldValue("Did commit: " .. tostring(text))
				end, { text })
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ props.text, props.ms })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end
			local function App(ref0)
				local text = ref0.text
				return React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(AsyncTextWithEffect, { text = text, ms = 100 })
				)
			end
			ReactTestRenderer.create(React.createElement(App, { text = "A" }))
			expect(Scheduler).toHaveYielded({ "Suspend! [A]", "Loading..." })
			jest.advanceTimersByTime(500)
			expect(Scheduler).toHaveYielded({ "Promise resolved [A]" })
			expect(Scheduler).toFlushUntilNextPaint({ "A", "Did commit: A" })
		end)
		it("retries when an update is scheduled on a timed out tree", function()
			local instance
			type Stateful = React_Component<any, any> & { state: Object }
			type Stateful_statics = {}
			local Stateful = React.Component:extend("Stateful") :: Stateful & Stateful_statics
			function Stateful.init(self: Stateful)
				self.state = { step = 1 }
			end
			function Stateful.render(self: Stateful)
				instance = self
				return React.createElement(
					AsyncText,
					{ ms = 1000, text = ("Step: %s"):format(tostring(self.state.step)) }
				)
			end
			local function App(props)
				return React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(Stateful, nil)
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil), { unstable_isConcurrent = true }) -- Initial render
			expect(Scheduler).toFlushAndYield({ "Suspend! [Step: 1]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Step: 1]" })
			expect(Scheduler).toFlushAndYield({ "Step: 1" })
			expect(root).toMatchRenderedOutput("Step: 1") -- Update that suspends
			instance:setState({ step = 2 })
			expect(Scheduler).toFlushAndYield({ "Suspend! [Step: 2]", "Loading..." })
			jest.advanceTimersByTime(500)
			expect(root).toMatchRenderedOutput("Loading...") -- Update while still suspended
			instance:setState({ step = 3 })
			expect(Scheduler).toFlushAndYield({ "Suspend! [Step: 3]" })
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({
				"Promise resolved [Step: 2]",
				"Promise resolved [Step: 3]",
>>>>>>> upstream-apply
			})
			jestExpect(Scheduler).toFlushExpired({
				"B",
			})
<<<<<<< HEAD
			jestExpect(root).toMatchRenderedOutput("Stateful: 2B")
		end
	)
	it("suspends in a class that has componentWillUnmount and is then deleted", function()
		local AsyncTextWithUnmount = React.Component:extend("AsyncTextWithUnmount")
		function AsyncTextWithUnmount:componentWillUnmount()
			Scheduler.unstable_yieldValue("will unmount")
		end
		function AsyncTextWithUnmount:render()
			local text = self.props.text
			local ms = self.props.ms
			local ok, result = pcall(function()
				TextResource.read({ text, ms })
				Scheduler.unstable_yieldValue(text)
				return text
			end)
			if not ok then
				local promise = result
				if typeof(promise.andThen) == "function" then
					Scheduler.unstable_yieldValue(string.format("Suspend! [%s]", text))
				else
					Scheduler.unstable_yieldValue(string.format("Error! [%s]", text))
=======
			expect(Scheduler).toFlushAndYield({})
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Child 1]" })
			expect(Scheduler).toFlushUntilNextPaint({
				"Child 1",
				"Suspend! [Child 2]",
				"Suspend! [Child 3]",
			})
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Child 2]" })
			expect(Scheduler).toFlushUntilNextPaint({ "Child 2", "Suspend! [Child 3]" })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Child 3]" })
			expect(Scheduler).toFlushUntilNextPaint({ "Child 3" })
			expect(root).toMatchRenderedOutput(Array.join({ "Child 1", "Child 2", "Child 3" }, ""))
			expect(mounts).toBe(1)
		end)
		it("does not get stuck with fallback in concurrent mode for a large delay", function()
			local function App(props)
				return React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(AsyncText, { ms = 1000, text = "Child 1" }),
					React.createElement(AsyncText, { ms = 7000, text = "Child 2" })
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil), { unstable_isConcurrent = true })
			expect(Scheduler).toFlushAndYield({
				"Suspend! [Child 1]",
				"Suspend! [Child 2]",
				"Loading...",
			})
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Child 1]" })
			expect(Scheduler).toFlushAndYield({ "Child 1", "Suspend! [Child 2]" })
			jest.advanceTimersByTime(6000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Child 2]" })
			expect(Scheduler).toFlushAndYield({ "Child 1", "Child 2" })
			expect(root).toMatchRenderedOutput(Array.join({ "Child 1", "Child 2" }, ""))
		end)
		it("reuses effects, including deletions, from the suspended tree", function()
			local useState = React.useState
			local setTab
			local function App()
				local tab, _setTab = table.unpack(useState(0), 1, 2)
				setTab = _setTab
				return React.createElement(
					Suspense,
					{ fallback = React.createElement(Text, { text = "Loading..." }) },
					React.createElement(AsyncText, { key = tab, text = "Tab: " .. tostring(tab), ms = 1000 }),
					React.createElement(Text, { key = tostring(tab) .. "sibling", text = " + sibling" })
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil))
			expect(Scheduler).toHaveYielded({ "Suspend! [Tab: 0]", " + sibling", "Loading..." })
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Tab: 0]" })
			expect(Scheduler).toFlushUntilNextPaint({ "Tab: 0" })
			expect(root).toMatchRenderedOutput("Tab: 0 + sibling")
			act(function()
				return setTab(1)
			end)
			expect(Scheduler).toHaveYielded({ "Suspend! [Tab: 1]", " + sibling", "Loading..." })
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Tab: 1]" })
			expect(Scheduler).toFlushUntilNextPaint({ "Tab: 1" })
			expect(root).toMatchRenderedOutput("Tab: 1 + sibling")
			act(function()
				return setTab(2)
			end)
			expect(Scheduler).toHaveYielded({ "Suspend! [Tab: 2]", " + sibling", "Loading..." })
			expect(root).toMatchRenderedOutput("Loading...")
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [Tab: 2]" })
			expect(Scheduler).toFlushUntilNextPaint({ "Tab: 2" })
			expect(root).toMatchRenderedOutput("Tab: 2 + sibling")
		end)
		it("does not warn if an mounted component is pinged", function()
			local useState = React.useState
			local root = ReactTestRenderer.create(nil)
			local setStep
			local function UpdatingText(ref0)
				local text, ms = ref0.text, ref0.ms
				local step, _setStep = table.unpack(useState(0), 1, 2)
				setStep = _setStep
				local fullText = ("%s:%s"):format(tostring(text), tostring(step))
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ fullText, ms })
						Scheduler:unstable_yieldValue(fullText)
						return fullText, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(fullText)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(fullText)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
>>>>>>> upstream-apply
				end
				error(promise)
			end
			return result
		end

		local function App(props)
			local text = props.text

			return React.createElement(
				Suspense,
				{
					fallback = React.createElement(Text, {
						text = "Loading...",
					}),
				},
				React.createElement(AsyncTextWithUnmount, {
					text = text,
					ms = 100,
				})
			)
<<<<<<< HEAD
		end

		local root = ReactTestRenderer.create(React.createElement(App, {
			text = "A",
		}))

		jestExpect(Scheduler).toHaveYielded({
			"Suspend! [A]",
			"Loading...",
		})
		root.update(React.createElement(Text, {
			text = "B",
		}))
		-- Should not fire componentWillUnmount
		jestExpect(Scheduler).toHaveYielded({
			"B",
		})
		jestExpect(root).toMatchRenderedOutput("B")
	end)
	it("suspends in a component that also contains useEffect", function()
		-- ROBLOX deviation START: add useFakeTimers()
		jest.useFakeTimers()
		-- ROBLOX deviation END
		local useLayoutEffect = React.useLayoutEffect

		local function AsyncTextWithEffect(props)
			local text = props.text

			useLayoutEffect(function()
				Scheduler.unstable_yieldValue("Did commit: " .. text)
			end, { text })

			local ok, result = pcall(function()
				TextResource.read({ props.text, props.ms })
				Scheduler.unstable_yieldValue(text)
				return text
=======
			expect(Scheduler).toHaveYielded({ "Suspend! [A:0]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [A:0]" })
			expect(Scheduler).toFlushUntilNextPaint({ "A:0" })
			expect(root).toMatchRenderedOutput("A:0")
			act(function()
				return setStep(1)
>>>>>>> upstream-apply
			end)
			if not ok then
				local promise = result
				if typeof(promise.andThen) == "function" then
					Scheduler.unstable_yieldValue(string.format("Suspend! [%s]", text))
				else
					Scheduler.unstable_yieldValue(string.format("Error! [%s]", text))
				end
				error(promise)
			end
			return result
		end

		local function App(props)
			local text = props.text

			return React.createElement(
				Suspense,
				{
					fallback = React.createElement(Text, {
						text = "Loading...",
					}),
				},
				React.createElement(AsyncTextWithEffect, {
					text = text,
					ms = 100,
				})
			)
		end

		ReactTestRenderer.create(React.createElement(App, {
			text = "A",
		}))
		jestExpect(Scheduler).toHaveYielded({
			"Suspend! [A]",
			"Loading...",
		})
		jest.advanceTimersByTime(500)
		-- ROBLOX FIXME: when not focused, the test fails by getting *two* 'Promise resolved [A]'
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [A]",
		})
		jestExpect(Scheduler).toFlushExpired({
			"A",
			"Did commit: A",
		})
	end)
	it("retries when an update is scheduled on a timed out tree", function()
		-- ROBLOX deviation START: add useFakeTimers()
		jest.useFakeTimers()
		-- ROBLOX deviation END
		local instance
		local Stateful = React.Component:extend("Stateful")

		function Stateful:init()
			self.state = { step = 1 }
		end

		function Stateful:render()
			instance = self

			return React.createElement(AsyncText, {
				ms = 1000,
				text = string.format("Step: %s", self.state.step),
			})
		end

		local function App(props)
			return React.createElement(Suspense, {
				fallback = React.createElement(Text, {
					text = "Loading...",
				}),
			}, React.createElement(Stateful))
		end

		local root = ReactTestRenderer.create(
			React.createElement(App),
			{ unstable_isConcurrent = true }
		)

		-- Initial render
		jestExpect(Scheduler).toFlushAndYield({
			"Suspend! [Step: 1]",
			"Loading...",
		})
		jest.advanceTimersByTime(1000)
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [Step: 1]",
		})
		jestExpect(Scheduler).toFlushAndYield({
			"Step: 1",
		})
		jestExpect(root).toMatchRenderedOutput("Step: 1")

		-- Update that suspends
		instance:setState({ step = 2 })
		jestExpect(Scheduler).toFlushAndYield({
			"Suspend! [Step: 2]",
			"Loading...",
		})
		jest.advanceTimersByTime(500)
		-- ROBLOX FIXME: expect fails because rendered output is nil
		jestExpect(root).toMatchRenderedOutput("Loading...")

		-- Update while still suspended
		instance:setState({ step = 3 })
		jestExpect(Scheduler).toFlushAndYield({
			"Suspend! [Step: 3]",
		})
		jestExpect(root).toMatchRenderedOutput("Loading...")
		jest.advanceTimersByTime(1000)
		jestExpect(Scheduler).toHaveYielded({
			"Promise resolved [Step: 2]",
			"Promise resolved [Step: 3]",
		})
		jestExpect(Scheduler).toFlushAndYield({
			"Step: 3",
		})
		jestExpect(root).toMatchRenderedOutput("Step: 3")
	end)
	--     it('does not remount the fallback while suspended children resolve in legacy mode', function()
	--         local mounts = 0
	--         local ShouldMountOnce = {}
	--         local ShouldMountOnceMetatable = {__index = ShouldMountOnce}

	--         function ShouldMountOnce:componentDidMount()
	--             mounts = mounts + 1
	--         end
	--         function ShouldMountOnce:render()
	--             return React.createElement(Text, {
	--                 text = 'Loading...',
	--             })
	--         end

	--         local function App(props)
	--             return React.createElement(Suspense, {
	--                 fallback = React.createElement(ShouldMountOnce),
	--             }, React.createElement(AsyncText, {
	--                 ms = 1000,
	--                 text = 'Child 1',
	--             }), React.createElement(AsyncText, {
	--                 ms = 2000,
	--                 text = 'Child 2',
	--             }), React.createElement(AsyncText, {
	--                 ms = 3000,
	--                 text = 'Child 3',
	--             }))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App))

	--         -- Initial render
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [Child 1]',
	--             'Suspend! [Child 2]',
	--             'Suspend! [Child 3]',
	--             'Loading...',
	--         })
	--         jestExpect(Scheduler).toFlushAndYield({})
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Child 1]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'Child 1',
	--             'Suspend! [Child 2]',
	--             'Suspend! [Child 3]',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Child 2]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'Child 2',
	--             'Suspend! [Child 3]',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Child 3]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'Child 3',
	--         })
	--         jestExpect(root).toMatchRenderedOutput(({
	--             'Child 1',
	--             'Child 2',
	--             'Child 3',
	--         }).join(''))
	--         jestExpect(mounts).toBe(1)
	--     end)
	--     it('does not get stuck with fallback in concurrent mode for a large delay', function()
	--         local function App(props)
	--             return React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(AsyncText, {
	--                 ms = 1000,
	--                 text = 'Child 1',
	--             }), React.createElement(AsyncText, {
	--                 ms = 7000,
	--                 text = 'Child 2',
	--             }))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App), {unstable_isConcurrent = true})

	--         jestExpect(Scheduler).toFlushAndYield({
	--             'Suspend! [Child 1]',
	--             'Suspend! [Child 2]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Child 1]',
	--         })
	--         jestExpect(Scheduler).toFlushAndYield({
	--             'Child 1',
	--             'Suspend! [Child 2]',
	--         })
	--         jest.advanceTimersByTime(6000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Child 2]',
	--         })
	--         jestExpect(Scheduler).toFlushAndYield({
	--             'Child 1',
	--             'Child 2',
	--         })
	--         jestExpect(root).toMatchRenderedOutput(({
	--             'Child 1',
	--             'Child 2',
	--         }).join(''))
	--     end)
	--     it('reuses effects, including deletions, from the suspended tree', function()
	--         local _React7, useState = React, _React7.useState
	--         local setTab

	--         local function App()
	--             local _useState13, _useState14, tab, _setTab = useState(0), _slicedToArray(_useState13, 2), _useState14[0], _useState14[1]

	--             setTab = _setTab

	--             return React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(AsyncText, {
	--                 key = tab,
	--                 text = 'Tab: ' + tab,
	--                 ms = 1000,
	--             }), React.createElement(Text, {
	--                 key = tab + 'sibling',
	--                 text = ' + sibling',
	--             }))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App))

	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [Tab: 0]',
	--             ' + sibling',
	--             'Loading...',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Loading...')
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Tab: 0]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'Tab: 0',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Tab: 0 + sibling')
	--         act(function()
	--             return setTab(1)
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [Tab: 1]',
	--             ' + sibling',
	--             'Loading...',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Loading...')
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Tab: 1]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'Tab: 1',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Tab: 1 + sibling')
	--         act(function()
	--             return setTab(2)
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [Tab: 2]',
	--             ' + sibling',
	--             'Loading...',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Loading...')
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [Tab: 2]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'Tab: 2',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Tab: 2 + sibling')
	--     end)
	--     it('does not warn if an mounted component is pinged', function()
	--         local _React8, useState = React, _React8.useState
	--         local root = ReactTestRenderer.create(nil)
	--         local setStep

	--         local function UpdatingText(_ref12)
	--             local text, ms = _ref12.text, _ref12.ms
	--             local _useState15, _useState16, step, _setStep = useState(0), _slicedToArray(_useState15, 2), _useState16[0], _useState16[1]

	--             setStep = _setStep

	--             local fullText = string.format('%s:%s', text, step)
	--         end

	--         root.update(React.createElement(Suspense, {
	--             fallback = React.createElement(Text, {
	--                 text = 'Loading...',
	--             }),
	--         }, React.createElement(UpdatingText, {
	--             text = 'A',
	--             ms = 1000,
	--         })))
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [A:0]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [A:0]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'A:0',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('A:0')
	--         act(function()
	--             return setStep(1)
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [A:1]',
	--             'Loading...',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('Loading...')
	--         root.update(nil)
	--         jestExpect(Scheduler).toFlushWithoutYielding()
	--         jest.advanceTimersByTime(1000)
	--     end)
	--     it('memoizes promise listeners per thread ID to prevent redundant renders', function()
	--         local function App()
	--             return React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(AsyncText, {
	--                 text = 'A',
	--                 ms = 1000,
	--             }), React.createElement(AsyncText, {
	--                 text = 'B',
	--                 ms = 2000,
	--             }), React.createElement(AsyncText, {
	--                 text = 'C',
	--                 ms = 3000,
	--             }))
	--         end

	--         local root = ReactTestRenderer.create(nil)

	--         root.update(React.createElement(App))
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [A]',
	--             'Suspend! [B]',
	--             'Suspend! [C]',
	--             'Loading...',
	--         })

	--         -- Resolve A
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [A]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'A',
	--             -- The promises for B and C have now been thrown twice
	--             'Suspend! [B]',
	--             'Suspend! [C]',
	--         })

	--         -- Resolve B
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [B]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             -- Even though the promise for B was thrown twice, we should only
	--             -- re-render once.
	--             'B',
	--             -- The promise for C has now been thrown three times
	--             'Suspend! [C]',
	--         })

	--         -- Resolve C
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [C]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             -- Even though the promise for C was thrown three times, we should only
	--             -- re-render once.
	--             'C',
	--         })
	--     end)
	it("should call onInteractionScheduledWorkCompleted after suspending", function()
		-- ROBLOX deviation START: add useFakeTimers()
		jest.useFakeTimers()
		-- ROBLOX deviation END
		-- ROBLOX deviation: mock performance.now
		local performanceNowCounter = 0
		_G.performance = {
			now = function()
				performanceNowCounter += 1
				return performanceNowCounter
			end,
			mark = function() end,
		}
		local subscriber = {
			onInteractionScheduledWorkCompleted = jestMock.fn(),
			onInteractionTraced = jestMock.fn(),
			onWorkCanceled = jestMock.fn(),
			onWorkScheduled = jestMock.fn(),
			onWorkStarted = jestMock.fn(),
			onWorkStopped = jestMock.fn(),
		}

		SchedulerTracing.unstable_subscribe(subscriber)
		SchedulerTracing.unstable_trace("test", _G.performance.now(), function()
			local function App()
				return React.createElement(
					React.Suspense,
					{
						fallback = React.createElement(Text, {
							text = "Loading...",
						}),
					},
					React.createElement(AsyncText, {
						text = "A",
						ms = 1000,
					}),
					React.createElement(AsyncText, {
						text = "B",
						ms = 2000,
					}),
					React.createElement(AsyncText, {
						text = "C",
						ms = 3000,
					})
				)
			end

			local root = ReactTestRenderer.create()

			root.update(React.createElement(App))
			jestExpect(Scheduler).toHaveYielded({
				"Suspend! [A]",
				"Suspend! [B]",
				"Suspend! [C]",
				"Loading...",
			})

			-- Resolve A
			jest.advanceTimersByTime(1000)
<<<<<<< HEAD
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [A]",
			})
			jestExpect(Scheduler).toFlushExpired({
=======
			expect(Scheduler).toHaveYielded({ "Promise resolved [A]" })
			expect(Scheduler).toFlushUntilNextPaint({
>>>>>>> upstream-apply
				"A",
				-- The promises for B and C have now been thrown twice
				"Suspend! [B]",
				"Suspend! [C]",
			})

			-- Resolve B
			jest.advanceTimersByTime(1000)
<<<<<<< HEAD
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [B]",
			})
			jestExpect(Scheduler).toFlushExpired({
=======
			expect(Scheduler).toHaveYielded({ "Promise resolved [B]" })
			expect(Scheduler).toFlushUntilNextPaint({
>>>>>>> upstream-apply
				-- Even though the promise for B was thrown twice, we should only
				-- re-render once.
				"B",
				-- The promise for C has now been thrown three times
				"Suspend! [C]",
			})

			-- Resolve C
			jest.advanceTimersByTime(1000)
<<<<<<< HEAD
			jestExpect(Scheduler).toHaveYielded({
				"Promise resolved [C]",
			})
			jestExpect(Scheduler).toFlushAndYield({
=======
			expect(Scheduler).toHaveYielded({ "Promise resolved [C]" })
			expect(Scheduler).toFlushUntilNextPaint({
>>>>>>> upstream-apply
				-- Even though the promise for C was thrown three times, we should only
				-- re-render once.
				"C",
			})
		end)
<<<<<<< HEAD
		jestExpect(subscriber.onInteractionScheduledWorkCompleted).toHaveBeenCalledTimes(
			1
		)
=======
		it("#14162", function()
			local lazy = React.lazy
			local function Hello()
				return React.createElement("span", nil, "hello")
			end
			local function fetchComponent()
				return Promise.resolve():andThen(function()
					return Promise.new(function(r)
						-- simulating a delayed import() call
						setTimeout(r, 1000, { default = Hello })
					end)
				end)
			end
			local LazyHello = lazy(fetchComponent)
			type App = React_Component<any, any> & { state: Object }
			type App_statics = {}
			local App = React.Component:extend("App") :: App & App_statics
			function App.init(self: App)
				self.state = { render = false }
			end
			function App.componentDidMount(self: App)
				setTimeout(function()
					return self:setState({ render = true })
				end)
			end
			function App.render(self: App)
				return React.createElement(
					Suspense,
					{ fallback = React.createElement("span", nil, "loading...") },
					if Boolean.toJSBoolean(self.state.render)
						then React.createElement(LazyHello, nil)
						else self.state.render
				)
			end
			local root = ReactTestRenderer.create(nil)
			root:update(React.createElement(App, { name = "world" }))
			jest.advanceTimersByTime(1000)
		end)
		it("updates memoized child of suspense component when context updates (simple memo)", function()
			local useContext, createContext, useState, memo =
				React.useContext, React.createContext, React.useState, React.memo
			local ValueContext = createContext(nil)
			local MemoizedChild = memo(function()
				local text = useContext(ValueContext)
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ text, 1000 })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end)
			local setValue
			local function App()
				local value, _setValue = table.unpack(useState("default"), 1, 2)
				setValue = _setValue
				return React.createElement(
					ValueContext.Provider,
					{ value = value },
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						React.createElement(MemoizedChild, nil)
					)
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil))
			expect(Scheduler).toHaveYielded({ "Suspend! [default]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [default]" })
			expect(Scheduler).toFlushUntilNextPaint({ "default" })
			expect(root).toMatchRenderedOutput("default")
			act(function()
				return setValue("new value")
			end)
			expect(Scheduler).toHaveYielded({ "Suspend! [new value]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [new value]" })
			expect(Scheduler).toFlushUntilNextPaint({ "new value" })
			expect(root).toMatchRenderedOutput("new value")
		end)
		it("updates memoized child of suspense component when context updates (manual memo)", function()
			local useContext, createContext, useState, memo =
				React.useContext, React.createContext, React.useState, React.memo
			local ValueContext = createContext(nil)
			local MemoizedChild = memo(function()
				local text = useContext(ValueContext)
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ text, 1000 })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end, function(prevProps, nextProps)
				return true
			end)
			local setValue
			local function App()
				local value, _setValue = table.unpack(useState("default"), 1, 2)
				setValue = _setValue
				return React.createElement(
					ValueContext.Provider,
					{ value = value },
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						React.createElement(MemoizedChild, nil)
					)
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil))
			expect(Scheduler).toHaveYielded({ "Suspend! [default]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [default]" })
			expect(Scheduler).toFlushUntilNextPaint({ "default" })
			expect(root).toMatchRenderedOutput("default")
			act(function()
				return setValue("new value")
			end)
			expect(Scheduler).toHaveYielded({ "Suspend! [new value]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [new value]" })
			expect(Scheduler).toFlushUntilNextPaint({ "new value" })
			expect(root).toMatchRenderedOutput("new value")
		end)
		it("updates memoized child of suspense component when context updates (function)", function()
			local useContext, createContext, useState = React.useContext, React.createContext, React.useState
			local ValueContext = createContext(nil)
			local function MemoizedChild()
				local text = useContext(ValueContext)
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ text, 1000 })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end
			local setValue
			local function App(ref0)
				local children = ref0.children
				local value, _setValue = table.unpack(useState("default"), 1, 2)
				setValue = _setValue
				return React.createElement(ValueContext.Provider, { value = value }, children)
			end
			local root = ReactTestRenderer.create(
				React.createElement(
					App,
					nil,
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						React.createElement(MemoizedChild, nil)
					)
				)
			)
			expect(Scheduler).toHaveYielded({ "Suspend! [default]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [default]" })
			expect(Scheduler).toFlushUntilNextPaint({ "default" })
			expect(root).toMatchRenderedOutput("default")
			act(function()
				return setValue("new value")
			end)
			expect(Scheduler).toHaveYielded({ "Suspend! [new value]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [new value]" })
			expect(Scheduler).toFlushUntilNextPaint({ "new value" })
			expect(root).toMatchRenderedOutput("new value")
		end)
		it("updates memoized child of suspense component when context updates (forwardRef)", function()
			local forwardRef, useContext, createContext, useState =
				React.forwardRef, React.useContext, React.createContext, React.useState
			local ValueContext = createContext(nil)
			local MemoizedChild = forwardRef(function()
				local text = useContext(ValueContext)
				do --[[ ROBLOX COMMENT: try-catch block conversion ]]
					local ok, result, hasReturned = xpcall(function()
						TextResource:read({ text, 1000 })
						Scheduler:unstable_yieldValue(text)
						return text, true
					end, function(promise)
						if typeof(promise["then"]) == "function" then
							Scheduler:unstable_yieldValue(("Suspend! [%s]"):format(tostring(text)))
						else
							Scheduler:unstable_yieldValue(("Error! [%s]"):format(tostring(text)))
						end
						error(promise)
					end)
					if hasReturned then
						return result
					end
				end
			end)
			local setValue
			local function App()
				local value, _setValue = table.unpack(useState("default"), 1, 2)
				setValue = _setValue
				return React.createElement(
					ValueContext.Provider,
					{ value = value },
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						React.createElement(MemoizedChild, nil)
					)
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil))
			expect(Scheduler).toHaveYielded({ "Suspend! [default]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [default]" })
			expect(Scheduler).toFlushUntilNextPaint({ "default" })
			expect(root).toMatchRenderedOutput("default")
			act(function()
				return setValue("new value")
			end)
			expect(Scheduler).toHaveYielded({ "Suspend! [new value]", "Loading..." })
			jest.advanceTimersByTime(1000)
			expect(Scheduler).toHaveYielded({ "Promise resolved [new value]" })
			expect(Scheduler).toFlushUntilNextPaint({ "new value" })
			expect(root).toMatchRenderedOutput("new value")
		end)
		it("updates context consumer within child of suspended suspense component when context updates", function()
			local createContext, useState = React.createContext, React.useState
			local ValueContext = createContext(nil)
			local promiseThatNeverResolves = Promise.new(function() end)
			local function Child()
				return React.createElement(ValueContext.Consumer, nil, function(value)
					Scheduler:unstable_yieldValue(("Received context value [%s]"):format(tostring(value)))
					if value == "default" then
						return React.createElement(Text, { text = "default" })
					end
					error(promiseThatNeverResolves)
				end)
			end
			local setValue
			local function Wrapper(ref0)
				local children = ref0.children
				local value, _setValue = table.unpack(useState("default"), 1, 2)
				setValue = _setValue
				return React.createElement(ValueContext.Provider, { value = value }, children)
			end
			local function App()
				return React.createElement(
					Wrapper,
					nil,
					React.createElement(
						Suspense,
						{ fallback = React.createElement(Text, { text = "Loading..." }) },
						React.createElement(Child, nil)
					)
				)
			end
			local root = ReactTestRenderer.create(React.createElement(App, nil))
			expect(Scheduler).toHaveYielded({ "Received context value [default]", "default" })
			expect(root).toMatchRenderedOutput("default")
			act(function()
				return setValue("new value")
			end)
			expect(Scheduler).toHaveYielded({
				"Received context value [new value]",
				"Loading...",
			})
			expect(root).toMatchRenderedOutput("Loading...")
			act(function()
				return setValue("default")
			end)
			expect(Scheduler).toHaveYielded({ "Received context value [default]", "default" })
			expect(root).toMatchRenderedOutput("default")
		end)
>>>>>>> upstream-apply
	end)
	--     it('#14162', function()
	--         local fetchComponent = _async(function()
	--             return Promise(function(r)
	--                 -- simulating a delayed import() call
	--                 setTimeout(r, 1000, {default = Hello})
	--             end)
	--         end)
	--         local _React9, lazy = React, _React9.lazy

	--         local function Hello()
	--             return React.createElement('span', nil, 'hello')
	--         end

	--         local LazyHello = lazy(fetchComponent)
	--         local App = {}
	--         local AppMetatable = {__index = App}

	--         function App.new()
	--             local self = setmetatable({}, AppMetatable)
	--             local _temp5

	--             return
	--         end
	--         function App:componentDidMount()
	--             local _this = self

	--             setTimeout(function()
	--                 return _this.setState({render = true})
	--             end)
	--         end
	--         function App:render()
	--             return React.createElement(Suspense, {
	--                 fallback = React.createElement('span', nil, 'loading...'),
	--             }, self.state.render and React.createElement(LazyHello))
	--         end

	--         local root = ReactTestRenderer.create(nil)

	--         root.update(React.createElement(App, {
	--             name = 'world',
	--         }))
	--         jest.advanceTimersByTime(1000)
	--     end)
	--     it('updates memoized child of suspense component when context updates (simple memo)', function()
	--         local _React10, useContext, createContext, useState, memo = React, _React10.useContext, _React10.createContext, _React10.useState, _React10.memo
	--         local ValueContext = createContext(nil)
	--         local MemoizedChild = memo(function()
	--             local text = useContext(ValueContext)
	--         end)
	--         local setValue

	--         local function App()
	--             local _useState17, _useState18, value, _setValue = useState('default'), _slicedToArray(_useState17, 2), _useState18[0], _useState18[1]

	--             setValue = _setValue

	--             return React.createElement(ValueContext.Provider, {value = value}, React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(MemoizedChild)))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App))

	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [default]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [default]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'default',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('default')
	--         act(function()
	--             return setValue('new value')
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [new value]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [new value]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'new value',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('new value')
	--     end)
	--     it('updates memoized child of suspense component when context updates (manual memo)', function()
	--         local _React11, useContext, createContext, useState, memo = React, _React11.useContext, _React11.createContext, _React11.useState, _React11.memo
	--         local ValueContext = createContext(nil)
	--         local MemoizedChild = memo(function()
	--             local text = useContext(ValueContext)
	--         end, function(prevProps, nextProps)
	--             return true
	--         end)
	--         local setValue

	--         local function App()
	--             local _useState19, _useState20, value, _setValue = useState('default'), _slicedToArray(_useState19, 2), _useState20[0], _useState20[1]

	--             setValue = _setValue

	--             return React.createElement(ValueContext.Provider, {value = value}, React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(MemoizedChild)))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App))

	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [default]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [default]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'default',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('default')
	--         act(function()
	--             return setValue('new value')
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [new value]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [new value]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'new value',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('new value')
	--     end)
	--     it('updates memoized child of suspense component when context updates (function)', function()
	--         local _React12, useContext, createContext, useState = React, _React12.useContext, _React12.createContext, _React12.useState
	--         local ValueContext = createContext(nil)

	--         local function MemoizedChild()
	--             local text = useContext(ValueContext)
	--         end

	--         local setValue

	--         local function App(_ref13)
	--             local children = _ref13.children
	--             local _useState21, _useState22, value, _setValue = useState('default'), _slicedToArray(_useState21, 2), _useState22[0], _useState22[1]

	--             setValue = _setValue

	--             return React.createElement(ValueContext.Provider, {value = value}, children)
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App, nil, React.createElement(Suspense, {
	--             fallback = React.createElement(Text, {
	--                 text = 'Loading...',
	--             }),
	--         }, React.createElement(MemoizedChild))))

	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [default]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [default]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'default',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('default')
	--         act(function()
	--             return setValue('new value')
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [new value]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [new value]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'new value',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('new value')
	--     end)
	--     it('updates memoized child of suspense component when context updates (forwardRef)', function()
	--         local _React13, forwardRef, useContext, createContext, useState = React, _React13.forwardRef, _React13.useContext, _React13.createContext, _React13.useState
	--         local ValueContext = createContext(nil)
	--         local MemoizedChild = forwardRef(function()
	--             local text = useContext(ValueContext)
	--         end)
	--         local setValue

	--         local function App()
	--             local _useState23, _useState24, value, _setValue = useState('default'), _slicedToArray(_useState23, 2), _useState24[0], _useState24[1]

	--             setValue = _setValue

	--             return React.createElement(ValueContext.Provider, {value = value}, React.createElement(Suspense, {
	--                 fallback = React.createElement(Text, {
	--                     text = 'Loading...',
	--                 }),
	--             }, React.createElement(MemoizedChild)))
	--         end

	--         local root = ReactTestRenderer.create(React.createElement(App))

	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [default]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [default]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'default',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('default')
	--         act(function()
	--             return setValue('new value')
	--         end)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Suspend! [new value]',
	--             'Loading...',
	--         })
	--         jest.advanceTimersByTime(1000)
	--         jestExpect(Scheduler).toHaveYielded({
	--             'Promise resolved [new value]',
	--         })
	--         jestExpect(Scheduler).toFlushExpired({
	--             'new value',
	--         })
	--         jestExpect(root).toMatchRenderedOutput('new value')
	--     end)
	-- end)
end)
