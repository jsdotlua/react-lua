<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/d13f5b9538e48f74f7c571ef3cde652ca887cca0/packages/react-reconciler/src/__tests__/ReactIncrementalUpdates-test.js
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @emails react-core
--  * @jest-environment node
--  */
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/__tests__/ReactIncrementalUpdates-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 * @jest-environment node
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
type Object = LuauPolyfill.Object
local Promise = require(Packages.Promise)
>>>>>>> upstream-apply

local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Object = LuauPolyfill.Object
local ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags
local React
local ReactNoop
local Scheduler
<<<<<<< HEAD
local InputContinuousLanePriority = 10
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it
local xit = JestGlobals.xit
local jest = JestGlobals.jest

describe("ReactIncrementalUpdates", function()
	local function gate(fn)
		return fn(ReactFeatureFlags)
	end
	beforeEach(function()
		jest.resetModules()

		React = require("@pkg/@jsdotlua/react")
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		Scheduler = require("@pkg/@jsdotlua/scheduler")
	end)

	local function span(prop)
		return {
			type = "span",
			children = {},
			prop = prop,
			hidden = false,
		}
	end

=======
local ContinuousEventPriority
local act
describe("ReactIncrementalUpdates", function()
	beforeEach(function()
		jest.resetModuleRegistry()
		React = require_("react")
		ReactNoop = require_("react-noop-renderer")
		Scheduler = require_("scheduler")
		act = require_("jest-react").act
		ContinuousEventPriority = require_("react-reconciler/constants").ContinuousEventPriority
	end)
	local function span(prop)
		return { type = "span", children = {}, prop = prop, hidden = false }
	end
	local function flushNextRenderIfExpired()
		-- This will start rendering the next level of work. If the work hasn't
		-- expired yet, React will exit without doing anything. If it has expired,
		-- it will schedule a sync task.
		Scheduler:unstable_flushExpired() -- Flush the sync task.
		ReactNoop:flushSync()
	end
>>>>>>> upstream-apply
	it("applies updates in order of priority", function()
		local state
		local Foo = React.Component:extend("Foo")
		function Foo:init()
			self.state = {}
		end
		function Foo:componentDidMount()
			local _this = self
			Scheduler.unstable_yieldValue("commit")
			ReactNoop.deferredUpdates(function()
				-- Has low priority
				_this:setState({ b = "b" })
				_this:setState({ c = "c" })
			end)
			-- Has Task priority
			self:setState({ a = "a" })
		end

		function Foo:render()
			state = self.state
			return React.createElement("div")
		end
		ReactNoop.render(React.createElement(Foo))
		jestExpect(Scheduler).toFlushAndYieldThrough({ "commit" })
		jestExpect(state).toEqual({
			a = "a",
		})
		jestExpect(Scheduler).toFlushWithoutYielding()

		jestExpect(state).toEqual({
			a = "a",
			b = "b",
			c = "c",
		})
	end)
	it("applies updates with equal priority in insertion order", function()
		local state
		local Foo = React.Component:extend("Foo")
		function Foo:init()
			self.state = {}
		end
		function Foo:componentDidMount()
			-- All have Task priority
			self:setState({ a = "a" })
			self:setState({ b = "b" })
			self:setState({ c = "c" })
		end

		function Foo:render()
			state = self.state
			return React.createElement("div")
		end
		ReactNoop.render(React.createElement(Foo))
		jestExpect(Scheduler).toFlushWithoutYielding()
		jestExpect(state).toEqual({
			a = "a",
			b = "b",
			c = "c",
		})
	end)
	it(
		"only drops updates with equal or lesser priority when replaceState is called",
		function()
			local instance
			local Foo = React.Component:extend("Foo")
			function Foo:init()
				self.state = {}
			end

			function Foo:componentDidMount()
				Scheduler.unstable_yieldValue("componentDidMount")
			end

			function Foo:componentDidUpdate()
				Scheduler.unstable_yieldValue("componentDidUpdate")
			end

			function Foo:render()
				Scheduler.unstable_yieldValue("render")
				instance = self
				return React.createElement("div")
			end

			ReactNoop.render(React.createElement(Foo))
			jestExpect(Scheduler).toFlushAndYield({
				"render",
				"componentDidMount",
			})
			ReactNoop.flushSync(function()
				ReactNoop.deferredUpdates(function()
					instance:setState({
						x = "x",
					})
					instance:setState({
						y = "y",
					})
				end)
				instance:setState({
					a = "a",
				})
				instance:setState({
					b = "b",
				})
				ReactNoop.deferredUpdates(function()
					instance.__updater.enqueueReplaceState(instance, {
						c = "c",
					})
					instance:setState({
						d = "d",
					})
				end)
			end)
			-- Even though a replaceState has been already scheduled, it hasn't been
			-- flushed yet because it has async priority.

			jestExpect(instance.state).toEqual({
				a = "a",
				b = "b",
			})
			jestExpect(Scheduler).toHaveYielded({
				"render",
				"componentDidUpdate",
			})
			jestExpect(Scheduler).toFlushAndYield({
				"render",
				"componentDidUpdate",
			})
			-- Now the rest of the updates are flushed, including the replaceState.
			jestExpect(instance.state).toEqual({
				c = "c",
				d = "d",
			})
		end
	)
	-- Test fails due to update priority bug
	it("can abort an update, schedule additional updates, and resume", function()
		local instance
		local Foo = React.Component:extend("Foo")
		function Foo:init()
			self.state = {}
		end

		function Foo:render()
			instance = self
			local keylist = Object.keys(self.state)
			table.sort(keylist)
			return React.createElement("span", {
				prop = table.concat(keylist, ""),
			})
		end

		ReactNoop.render(React.createElement(Foo))
		jestExpect(Scheduler).toFlushWithoutYielding()

		local function createUpdate(letter)
			return function()
				Scheduler.unstable_yieldValue(letter)
				return { [letter] = letter }
			end
<<<<<<< HEAD
		end
		-- Schedule some async updates

		instance:setState(createUpdate("a"))
		instance:setState(createUpdate("b"))
		instance:setState(createUpdate("c")) -- // Begin the updates but don't flush them yet
		jestExpect(Scheduler).toFlushAndYieldThrough({
			"a",
			"b",
			"c",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span(""),
		}) -- Schedule some more updates at different priorities
		instance:setState(createUpdate("d"))
		ReactNoop.flushSync(function()
			instance:setState(createUpdate("e"))
			instance:setState(createUpdate("f"))
		end)
		instance:setState(createUpdate("g")) -- The sync updates should have flushed, but not the async ones
		jestExpect(Scheduler).toHaveYielded({
			"e",
			"f",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span("ef"),
		})
		-- Now flush the remaining work. Even though e and f were already processed,
		-- they should be processed again, to ensure that the terminal state
		-- is deterministic.
		jestExpect(Scheduler).toFlushAndYield({
			"a",
			"b",
			"c",
			"d",
			"e",
			"f",
			"g",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span("abcdefg"),
=======
		end -- Schedule some async updates
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				instance:setState(createUpdate("a"))
				instance:setState(createUpdate("b"))
				instance:setState(createUpdate("c"))
			end)
		else
			instance:setState(createUpdate("a"))
			instance:setState(createUpdate("b"))
			instance:setState(createUpdate("c"))
		end -- Begin the updates but don't flush them yet
		expect(Scheduler).toFlushAndYieldThrough({ "a", "b", "c" })
		expect(ReactNoop:getChildren()).toEqual({ span("") }) -- Schedule some more updates at different priorities
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			instance:setState(createUpdate("d"))
			ReactNoop:flushSync(function()
				instance:setState(createUpdate("e"))
				instance:setState(createUpdate("f"))
			end)
			React.startTransition(function()
				instance:setState(createUpdate("g"))
			end) -- The sync updates should have flushed, but not the async ones
			expect(Scheduler).toHaveYielded({ "e", "f" })
			expect(ReactNoop:getChildren()).toEqual({ span("ef") }) -- Now flush the remaining work. Even though e and f were already processed,
			-- they should be processed again, to ensure that the terminal state
			-- is deterministic.
			expect(Scheduler).toFlushAndYield({
				-- Since 'g' is in a transition, we'll process 'd' separately first.
				-- That causes us to process 'd' with 'e' and 'f' rebased.
				"d",
				"e",
				"f",
				-- Then we'll re-process everything for 'g'.
				"a",
				"b",
				"c",
				"d",
				"e",
				"f",
				"g",
			})
			expect(ReactNoop:getChildren()).toEqual({ span("abcdefg") })
		else
			instance:setState(createUpdate("d"))
			ReactNoop:flushSync(function()
				instance:setState(createUpdate("e"))
				instance:setState(createUpdate("f"))
			end)
			instance:setState(createUpdate("g")) -- The sync updates should have flushed, but not the async ones
			expect(Scheduler).toHaveYielded({ "e", "f" })
			expect(ReactNoop:getChildren()).toEqual({ span("ef") }) -- Now flush the remaining work. Even though e and f were already processed,
			-- they should be processed again, to ensure that the terminal state
			-- is deterministic.
			expect(Scheduler).toFlushAndYield({ "a", "b", "c", "d", "e", "f", "g" })
			expect(ReactNoop:getChildren()).toEqual({ span("abcdefg") })
		end
	end)
	it("can abort an update, schedule a replaceState, and resume", function()
		local instance
		type Foo = React_Component<any, any> & { state: Object }
		type Foo_statics = {}
		local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
		function Foo.init(self: Foo)
			self.state = {}
		end
		function Foo.render(self: Foo)
			instance = self
			return React.createElement("span", {
				prop = Array.join(
					Array.sort(Object.keys(self.state)), --[[ ROBLOX CHECK: check if 'Object.keys(this.state)' is an Array ]]
					""
				),
			})
		end
		ReactNoop:render(React.createElement(Foo, nil))
		expect(Scheduler).toFlushWithoutYielding()
		local function createUpdate(letter)
			return function()
				Scheduler:unstable_yieldValue(letter)
				return { [tostring(letter)] = letter }
			end
		end -- Schedule some async updates
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				instance:setState(createUpdate("a"))
				instance:setState(createUpdate("b"))
				instance:setState(createUpdate("c"))
			end)
		else
			instance:setState(createUpdate("a"))
			instance:setState(createUpdate("b"))
			instance:setState(createUpdate("c"))
		end -- Begin the updates but don't flush them yet
		expect(Scheduler).toFlushAndYieldThrough({ "a", "b", "c" })
		expect(ReactNoop:getChildren()).toEqual({ span("") }) -- Schedule some more updates at different priorities
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			instance:setState(createUpdate("d"))
			ReactNoop:flushSync(function()
				instance:setState(createUpdate("e")) -- No longer a public API, but we can test that it works internally by
				-- reaching into the updater.
				instance.updater:enqueueReplaceState(instance, createUpdate("f"))
			end)
			React.startTransition(function()
				instance:setState(createUpdate("g"))
			end) -- The sync updates should have flushed, but not the async ones.
			expect(Scheduler).toHaveYielded({ "e", "f" })
			expect(ReactNoop:getChildren()).toEqual({ span("f") }) -- Now flush the remaining work. Even though e and f were already processed,
			-- they should be processed again, to ensure that the terminal state
			-- is deterministic.
			expect(Scheduler).toFlushAndYield({
				-- Since 'g' is in a transition, we'll process 'd' separately first.
				-- That causes us to process 'd' with 'e' and 'f' rebased.
				"d",
				"e",
				"f",
				-- Then we'll re-process everything for 'g'.
				"a",
				"b",
				"c",
				"d",
				"e",
				"f",
				"g",
			})
			expect(ReactNoop:getChildren()).toEqual({ span("fg") })
		else
			instance:setState(createUpdate("d"))
			ReactNoop:flushSync(function()
				instance:setState(createUpdate("e")) -- No longer a public API, but we can test that it works internally by
				-- reaching into the updater.
				instance.updater:enqueueReplaceState(instance, createUpdate("f"))
			end)
			instance:setState(createUpdate("g")) -- The sync updates should have flushed, but not the async ones. Update d
			-- was dropped and replaced by e.
			expect(Scheduler).toHaveYielded({ "e", "f" })
			expect(ReactNoop:getChildren()).toEqual({ span("f") }) -- Now flush the remaining work. Even though e and f were already processed,
			-- they should be processed again, to ensure that the terminal state
			-- is deterministic.
			expect(Scheduler).toFlushAndYield({ "a", "b", "c", "d", "e", "f", "g" })
			expect(ReactNoop:getChildren()).toEqual({ span("fg") })
		end
	end)
	it("passes accumulation of previous updates to replaceState updater function", function()
		local instance
		type Foo = React_Component<any, any> & { state: Object }
		type Foo_statics = {}
		local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
		function Foo.init(self: Foo)
			self.state = {}
		end
		function Foo.render(self: Foo)
			instance = self
			return React.createElement("span", nil)
		end
		ReactNoop:render(React.createElement(Foo, nil))
		expect(Scheduler).toFlushWithoutYielding()
		instance:setState({ a = "a" })
		instance:setState({ b = "b" }) -- No longer a public API, but we can test that it works internally by
		-- reaching into the updater.
		instance.updater:enqueueReplaceState(instance, function(previousState)
			return { previousState = previousState }
		end)
		expect(Scheduler).toFlushWithoutYielding()
		expect(instance.state).toEqual({ previousState = { a = "a", b = "b" } })
	end)
	it("does not call callbacks that are scheduled by another callback until a later commit", function()
		type Foo = React_Component<any, any> & { state: Object }
		type Foo_statics = {}
		local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
		function Foo.init(self: Foo)
			self.state = {}
		end
		function Foo.componentDidMount(self: Foo)
			Scheduler:unstable_yieldValue("did mount")
			self:setState({ a = "a" }, function()
				Scheduler:unstable_yieldValue("callback a")
				self:setState({ b = "b" }, function()
					Scheduler:unstable_yieldValue("callback b")
				end)
			end)
		end
		function Foo.render(self: Foo)
			Scheduler:unstable_yieldValue("render")
			return React.createElement("div", nil)
		end
		ReactNoop:render(React.createElement(Foo, nil))
		expect(Scheduler).toFlushAndYield({
			"render",
			"did mount",
			"render",
			"callback a",
			"render",
			"callback b",
>>>>>>> upstream-apply
		})
	end)
	-- Test fails due to update priority bug
	it("can abort an update, schedule a replaceState, and resume", function()
		local instance

		local Foo = React.Component:extend("Foo")
		function Foo:init()
			self.state = {}
		end

		function Foo:render()
			instance = self
			local keylist = Object.keys(self.state)
			table.sort(keylist)
			return React.createElement("span", {
				prop = table.concat(keylist, ""),
			})
		end
<<<<<<< HEAD

		ReactNoop.render(React.createElement(Foo))
		jestExpect(Scheduler).toFlushWithoutYielding()

		local function createUpdate(letter)
			return function()
				Scheduler.unstable_yieldValue(letter)
				return { [letter] = letter }
			end
		end

		-- Schedule some async updates
		instance:setState(createUpdate("a"))
		instance:setState(createUpdate("b"))
		instance:setState(createUpdate("c"))

		-- Begin the updates but don't flush them yet
		jestExpect(Scheduler).toFlushAndYieldThrough({
			"a",
			"b",
			"c",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span(""),
		})

		-- Schedule some more updates at different priorities
		instance:setState(createUpdate("d"))
		ReactNoop.flushSync(function()
			instance:setState(createUpdate("e"))
			instance.__updater.enqueueReplaceState(instance, createUpdate("f"))
		end)
		instance:setState(createUpdate("g"))

		-- The sync updates should have flushed, but not the async ones
		jestExpect(Scheduler).toHaveYielded({
			"e",
			"f",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span("f"),
		})
		-- Now flush the remaining work. Even though e and f were already processed,
		-- they should be processed again, to ensure that the terminal state
		-- is deterministic.
		jestExpect(Scheduler).toFlushAndYield({
			"a",
			"b",
			"c",
			"d",
			"e",
			"f",
			"g",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span("fg"),
		})
=======
		ReactNoop:render(React.createElement(Foo, nil))
		expect(Scheduler).toFlushAndYield({ "render" })
		ReactNoop:flushSync(function()
			instance:setState({ a = "a" })
			ReactNoop:render(React.createElement(Foo, nil)) -- Trigger componentWillReceiveProps
		end)
		expect(instance.state).toEqual({ a = "a", b = "b" })
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.deferRenderPhaseUpdateToNextBatch
		end)) then
			expect(Scheduler).toHaveYielded({ "componentWillReceiveProps", "render", "render" })
		else
			expect(Scheduler).toHaveYielded({ "componentWillReceiveProps", "render" })
		end
>>>>>>> upstream-apply
	end)
	-- ROBLOX deviation START: same as above, but tests > 1000 updates
	it("can abort an update, schedule a replaceState, and resume many times", function()
		local instance

		local Foo = React.Component:extend("Foo")
		function Foo:init()
			self.state = {}
		end

		function Foo:render()
			instance = self
			local keylist = Object.keys(self.state)
			table.sort(keylist)
			return React.createElement("span", {
				prop = table.concat(keylist, ""),
			})
		end

		ReactNoop.render(React.createElement(Foo))
		jestExpect(Scheduler).toFlushWithoutYielding()

		local function createUpdate(letter)
			return function()
				Scheduler.unstable_yieldValue(letter)
				return { [letter] = letter }
			end
		end

		-- Schedule many async updates
		for _ = 1, 500 do
			instance:setState(createUpdate("a"))
			instance:setState(createUpdate("b"))
			instance:setState(createUpdate("c"))
		end
		jestExpect(ReactNoop.getChildren()).toEqual({
			span(""),
		})

		-- Schedule some more updates at different priorities
		instance:setState(createUpdate("d"))
		ReactNoop.flushSync(function()
			instance:setState(createUpdate("e"))
			instance.__updater.enqueueReplaceState(instance, createUpdate("f"))
		end)
		instance:setState(createUpdate("g"))

		-- The sync updates should have flushed, but not the async ones
		jestExpect(Scheduler).toHaveYielded({
			"e",
			"f",
		})
		jestExpect(ReactNoop.getChildren()).toEqual({
			span("f"),
		})
		-- Now flush the remaining work.
		ReactNoop.flushSync(function()
			instance:setState(createUpdate("g"))
		end)
		jestExpect(ReactNoop.getChildren()).toEqual({
			span("fg"),
		})
	end)
	-- ROBLOX deviation END
	it(
		"passes accumulation of previous updates to replaceState updater function",
		function()
			local instance
			local Foo = React.Component:extend("Foo")
			function Foo:init()
				self.state = {}
			end

			function Foo:render()
				instance = self
				return React.createElement("span")
			end

			ReactNoop.render(React.createElement(Foo))
			jestExpect(Scheduler).toFlushWithoutYielding()
			instance:setState({ a = "a" })
			instance:setState({ b = "b" })
			-- No longer a public API, but we can test that it works internally by
			-- reaching into the updater.
			instance.__updater.enqueueReplaceState(instance, function(previousState)
				return { previousState = previousState }
			end)
			jestExpect(Scheduler).toFlushWithoutYielding()
			jestExpect(instance.state.previousState).toEqual({
				a = "a",
				b = "b",
			})
		end
	)
	it(
		"does not call callbacks that are scheduled by another callback until a later commit",
		function()
			local Foo = React.Component:extend("Foo")
			function Foo:init()
				self.state = {}
			end

			function Foo:componentDidMount()
				local _this2 = self
				Scheduler.unstable_yieldValue("did mount")
				self:setState({
					a = "a",
				}, function()
					Scheduler.unstable_yieldValue("callback a")
					_this2:setState({
						b = "b",
					}, function()
						Scheduler.unstable_yieldValue("callback b")
					end)
				end)
			end

			function Foo:render()
				Scheduler.unstable_yieldValue("render")
				return React.createElement("div")
			end

			ReactNoop.render(React.createElement(Foo))
			jestExpect(Scheduler).toFlushAndYield({
				"render",
				"did mount",
				"render",
				"callback a",
				"render",
				"callback b",
			})
		end
	)
	it(
		"gives setState during reconciliation the same priority as whatever level is currently reconciling",
		function()
			local instance

			local Foo = React.Component:extend("Foo")
			function Foo:init()
				self.state = {}
			end

			function Foo:UNSAFE_componentWillReceiveProps()
				Scheduler.unstable_yieldValue("componentWillReceiveProps")
				self:setState({
					b = "b",
				})
			end

			function Foo:render()
				Scheduler.unstable_yieldValue("render")
				instance = self
				return React.createElement("div")
			end

			ReactNoop.render(React.createElement(Foo))
			jestExpect(function()
				return jestExpect(Scheduler).toFlushAndYield({
					"render",
				})
			end).toErrorDev(
				"Using UNSAFE_componentWillReceiveProps in strict mode is not recommended",
				{ withoutStack = true }
			)
			ReactNoop.flushSync(function()
				instance:setState({
					a = "a",
				})
				ReactNoop.render(React.createElement(Foo))
				return "test"
			end)
			jestExpect(instance.state).toEqual({
				a = "a",
				b = "b",
			})
			jestExpect(Scheduler).toHaveYielded({
				"componentWillReceiveProps",
				"render",
			})
		end
	)
	it("updates triggered from inside a class setState updater", function()
		local instance
		local Foo = React.Component:extend("Foo")
		function Foo:init()
			self.state = {}
		end

		function Foo:render()
			Scheduler.unstable_yieldValue("render")
			instance = self
			return React.createElement("div")
		end

		ReactNoop.render(React.createElement(Foo))
		jestExpect(Scheduler).toFlushAndYield({
			-- Initial render
			"render",
		})
		instance:setState(function()
			Scheduler.unstable_yieldValue("setState updater")
			instance:setState({
				b = "b",
			})
			return {
				a = "a",
			}
		end)
		jestExpect(function()
			-- ROBLOX deviation: using local defined gate which references ReactFeatureFlags as
			-- opposed to upstream's gate() which is defined in setupTests in Jest files
			return jestExpect(Scheduler).toFlushAndYield(gate(function(flags)
				if flags.deferRenderPhaseUpdateToNextBatch then
					return {
						"setState updater", -- In the new reconciler, updates inside the render phase are
						-- treated as if they came from an event, so the update gets
						-- shifted to a subsequent render.
						"render",
						"render",
					}
				end

				return {
					"setState updater", -- In the old reconciler, updates in the render phase receive
					-- the currently rendering expiration time, so the update
					-- flushes immediately in the same render.
					"render",
				}
			end))
		end).toErrorDev(
			"An update (setState, replaceState, or forceUpdate) was scheduled "
				.. "from inside an update function. Update functions should be pure, "
				.. "with zero side-effects. Consider using componentDidUpdate or a "
				.. "callback."
		)
		jestExpect(instance.state).toEqual({
			a = "a",
			b = "b",
		}) -- Test deduplication (no additional warnings expected)
		instance:setState(function()
			instance:setState({
				a = "a",
			})
			return {
				b = "b",
			}
		end)
		jestExpect(Scheduler).toFlushAndYield(gate(function(flags)
			return (function()
				if flags.deferRenderPhaseUpdateToNextBatch then
					return { -- In the new reconciler, updates inside the render phase are
						-- treated as if they came from an event, so the update gets shifted
						-- to a subsequent render.
						"render",
						"render",
					}
				end

				return {
					"render",
				}
			end)()
		end))
	end)
	it(
		"getDerivedStateFromProps should update base state of updateQueue (based on product bug)",
		function()
			-- Based on real-world bug.
			local foo
			local bar

			local Bar = React.Component:extend("Bar")
			function Bar:render()
				bar = self
				return nil
			end

			local Foo = React.Component:extend("Foo")
			function Foo:init()
				self.state = { value = "initial state" }
			end
			function Foo:getDerivedStateFromProps()
				return { value = "derived state" }
			end
			function Foo:render()
				foo = self
				return React.createElement(
					React.Fragment,
					nil,
					React.createElement("span", {
						prop = self.state.value,
					}),
					React.createElement(Bar)
				)
			end
			ReactNoop.flushSync(function()
				-- Triggers getDerivedStateFromProps again
				ReactNoop.render(React.createElement(Foo))
				-- The noop callback is needed to trigger the specific internal path that
				-- led to this bug. Removing it causes it to "accidentally" work.
			end)
			jestExpect(ReactNoop.getChildren()).toEqual({
				span("derived state"),
			})
			ReactNoop.flushSync(function()
				ReactNoop.render(React.createElement(Foo))
				foo:setState({
					value = "update state",
				}, function() end)
			end)
			jestExpect(ReactNoop.getChildren()).toEqual({
				span("derived state"),
			})
			ReactNoop.flushSync(function()
				bar:setState({})
			end)
			jestExpect(ReactNoop.getChildren()).toEqual({
				span("derived state"),
			})
		end
	)
	it(
		"regression: does not expire soon due to layout effects in the last batch",
		function()
			local useState = React.useState
			local useLayoutEffect = React.useLayoutEffect

			local setCount
			local function App()
				local count, setCountTemp = useState(0)
				setCount = setCountTemp

				Scheduler.unstable_yieldValue("Render: " .. count)
				useLayoutEffect(function()
					setCount(function(prevCount)
						return prevCount + 1
					end)
					Scheduler.unstable_yieldValue("Commit: " .. count)
				end, {})
				return nil
			end

			ReactNoop.act(function()
				ReactNoop.render(React.createElement(App))
				jestExpect(Scheduler).toFlushExpired({})
				jestExpect(Scheduler).toFlushAndYield({
					"Render: 0",
					"Commit: 0",
					"Render: 1",
				})
				Scheduler.unstable_advanceTime(10000)
				setCount(2)
				jestExpect(Scheduler).toFlushExpired({})
			end)
		end
<<<<<<< HEAD
	)
=======
		function Foo.render(self: Foo)
			foo = self
			return React.createElement(
				React.Fragment,
				nil,
				React.createElement("span", { prop = self.state.value }),
				React.createElement(Bar, nil)
			)
		end
		local bar
		type Bar = React_Component<any, any> & {}
		type Bar_statics = {}
		local Bar = React.Component:extend("Bar") :: Bar & Bar_statics
		function Bar.render(self: Bar)
			bar = self
			return nil
		end
		ReactNoop:flushSync(function()
			ReactNoop:render(React.createElement(Foo, nil))
		end)
		expect(ReactNoop:getChildren()).toEqual({ span("derived state") })
		ReactNoop:flushSync(function()
			-- Triggers getDerivedStateFromProps again
			ReactNoop:render(React.createElement(Foo, nil)) -- The noop callback is needed to trigger the specific internal path that
			-- led to this bug. Removing it causes it to "accidentally" work.
			foo:setState({ value = "update state" }, function() end)
		end)
		expect(ReactNoop:getChildren()).toEqual({ span("derived state") })
		ReactNoop:flushSync(function()
			bar:setState({})
		end)
		expect(ReactNoop:getChildren()).toEqual({ span("derived state") })
	end)
	it("regression: does not expire soon due to layout effects in the last batch", function()
		local useState, useLayoutEffect = React.useState, React.useLayoutEffect
		local setCount
		local function App()
			local count, _setCount = table.unpack(useState(0), 1, 2)
			setCount = _setCount
			Scheduler:unstable_yieldValue("Render: " .. tostring(count))
			useLayoutEffect(function()
				setCount(function(prevCount)
					return prevCount + 1
				end)
				Scheduler:unstable_yieldValue("Commit: " .. tostring(count))
			end, {})
			return nil
		end
		act(function()
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					ReactNoop:render(React.createElement(App, nil))
				end)
			else
				ReactNoop:render(React.createElement(App, nil))
			end
			flushNextRenderIfExpired()
			expect(Scheduler).toHaveYielded({})
			expect(Scheduler).toFlushAndYield({ "Render: 0", "Commit: 0", "Render: 1" })
			Scheduler:unstable_advanceTime(10000)
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					setCount(2)
				end)
			else
				setCount(2)
			end
			flushNextRenderIfExpired()
			expect(Scheduler).toHaveYielded({})
		end)
	end)
>>>>>>> upstream-apply
	it("regression: does not expire soon due to previous flushSync", function()
		local function Text(_ref)
			local text = _ref.text
			Scheduler.unstable_yieldValue(text)
			return text
		end

		ReactNoop.flushSync(function()
			ReactNoop.render(React.createElement(Text, {
				text = "A",
			}))
		end)
<<<<<<< HEAD
		jestExpect(Scheduler).toHaveYielded({
			"A",
		})
		Scheduler.unstable_advanceTime(10000)
		ReactNoop.render(React.createElement(Text, {
			text = "B",
		}))
		jestExpect(Scheduler).toFlushExpired({})
=======
		expect(Scheduler).toHaveYielded({ "A" })
		Scheduler:unstable_advanceTime(10000)
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				ReactNoop:render(React.createElement(Text, { text = "B" }))
			end)
		else
			ReactNoop:render(React.createElement(Text, { text = "B" }))
		end
		flushNextRenderIfExpired()
		expect(Scheduler).toHaveYielded({})
>>>>>>> upstream-apply
	end)
	it("regression: does not expire soon due to previous expired work", function()
		local function Text(_ref2)
			local text = _ref2.text

			Scheduler.unstable_yieldValue(text)

			return text
		end
<<<<<<< HEAD

		ReactNoop.render(React.createElement(Text, {
			text = "A",
		}))
		Scheduler.unstable_advanceTime(10000)
		jestExpect(Scheduler).toFlushExpired({
			"A",
		})
		Scheduler.unstable_advanceTime(10000)
		ReactNoop.render(React.createElement(Text, {
			text = "B",
		}))
		jestExpect(Scheduler).toFlushExpired({})
=======
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				ReactNoop:render(React.createElement(Text, { text = "A" }))
			end)
		else
			ReactNoop:render(React.createElement(Text, { text = "A" }))
		end
		Scheduler:unstable_advanceTime(10000)
		flushNextRenderIfExpired()
		expect(Scheduler).toHaveYielded({ "A" })
		Scheduler:unstable_advanceTime(10000)
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
				ReactNoop:render(React.createElement(Text, { text = "B" }))
			end)
		else
			ReactNoop:render(React.createElement(Text, { text = "B" }))
		end
		flushNextRenderIfExpired()
		expect(Scheduler).toHaveYielded({})
>>>>>>> upstream-apply
	end)

	it(
		"when rebasing, does not exclude updates that were already committed, regardless of priority",
		function()
			local useState = React.useState
			local useLayoutEffect = React.useLayoutEffect
			local pushToLog

			local function App()
				local log, setLog = useState("")
				pushToLog = function(msg)
					return setLog(function(prevLog)
						return prevLog .. msg
					end)
				end

				useLayoutEffect(function()
					Scheduler.unstable_yieldValue("Committed: " .. log)

					if log == "B" then
						-- Right after B commits, schedule additional updates.
<<<<<<< HEAD
						-- TODO: Double wrapping is temporary while we remove Scheduler runWithPriority.
						ReactNoop.unstable_runWithPriority(
							InputContinuousLanePriority,
							function()
								return Scheduler.unstable_runWithPriority(
									Scheduler.unstable_UserBlockingPriority,
									function()
										pushToLog("C")
									end
								)
							end
						)
=======
						ReactNoop:unstable_runWithPriority(ContinuousEventPriority, function()
							return pushToLog("C")
						end)
>>>>>>> upstream-apply
						setLog(function(prevLog)
							return prevLog .. "D"
						end)
					end
				end, {
					log,
				})

				return log
			end
<<<<<<< HEAD

			local root = ReactNoop.createRoot()
			ReactNoop.act(function()
				root.render(React.createElement(App))
			end)
			jestExpect(Scheduler).toHaveYielded({
				"Committed: ",
			})

			jestExpect(root).toMatchRenderedOutput("")

			ReactNoop.act(function()
				pushToLog("A")

				-- TODO: Double wrapping is temporary while we remove Scheduler runWithPriority.
				ReactNoop.unstable_runWithPriority(InputContinuousLanePriority, function()
					return Scheduler.unstable_runWithPriority(
						Scheduler.unstable_UserBlockingPriority,
						function()
							pushToLog("B")
						end
					)
=======
			local root = ReactNoop:createRoot()
			act(function()
				return Promise.resolve():andThen(function()
					root:render(React.createElement(App, nil))
				end)
			end):expect()
			expect(Scheduler).toHaveYielded({ "Committed: " })
			expect(root).toMatchRenderedOutput(nil)
			act(function()
				return Promise.resolve():andThen(function()
					if
						Boolean.toJSBoolean(gate(function(flags)
							return flags.enableSyncDefaultUpdates
						end))
					then
						React.startTransition(function()
							pushToLog("A")
						end)
					else
						pushToLog("A")
					end
					ReactNoop:unstable_runWithPriority(ContinuousEventPriority, function()
						return pushToLog("B")
					end)
>>>>>>> upstream-apply
				end)
			end)
			jestExpect(Scheduler).toHaveYielded({
				-- A and B are pending. B is higher priority, so we'll render that first.
				"Committed: B",
				-- Because A comes first in the queue, we're now in rebase mode. B must
				-- be rebased on top of A. Also, in a layout effect, we received two new
				-- updates: C and D. C is user-blocking and D is synchronous.
				--
				-- First render the synchronous update. What we're testing here is that
				-- B *is not dropped* even though it has lower than sync priority. That's
				-- because we already committed it. However, this render should not
				-- include C, because that update wasn't already committed.
				"Committed: BD",
				"Committed: BCD",
				"Committed: ABCD",
			})

			jestExpect(root).toMatchRenderedOutput("ABCD")
		end
	)
	-- ROBLOX FIXME: fails with incorrect values
	xit(
		"when rebasing, does not exclude updates that were already committed, regardless of priority (classes)",
		function()
<<<<<<< HEAD
			local instance
			local App = React.Component:extend("App")
			function App:init()
				self.state = { log = "" }
			end
			function App:pushToLog(msg)
				self:setState(function(prevState)
					return { log = prevState.state.log .. msg }
				end)
			end

			function App:componentDidUpdate()
				Scheduler.unstable_yieldValue("Committed: " .. self.state.log)
				if self.state.log == "B" then
					-- Right after B commits, schedule additional updates.
					-- TODO: Double wrapping is temporary while we remove Scheduler runWithPriority.
					ReactNoop.unstable_runWithPriority(
						InputContinuousLanePriority,
						function()
							Scheduler.unstable_runWithPriority(
								Scheduler.unstable_UserBlockingPriority,
								function()
									self:pushToLog("C")
								end
							)
						end
					)
					self:pushToLog("D")
				end
			end

			function App:render()
				instance = self
				return self.state.log
			end

			local root = ReactNoop.createRoot()
			local app = React.createElement(App)
			-- ROBLOX FIXME: fails probably due to this not being as Promise as in upstream
			ReactNoop.act(function()
				root.render(app)
=======
			return Promise.resolve():andThen(function()
				local pushToLog
				type App = React_Component<any, any> & { state: Object, pushToLog: any }
				type App_statics = {}
				local App = React.Component:extend("App") :: App & App_statics
				function App.init(self: App)
					self.state = { log = "" }
					self.pushToLog = function(msg)
						self:setState(function(prevState)
							return { log = prevState.log + msg }
						end)
					end
				end
				function App.componentDidUpdate(self: App)
					Scheduler:unstable_yieldValue("Committed: " .. tostring(self.state.log))
					if self.state.log == "B" then
						-- Right after B commits, schedule additional updates.
						ReactNoop:unstable_runWithPriority(ContinuousEventPriority, function()
							return self:pushToLog("C")
						end)
						self:pushToLog("D")
					end
				end
				function App.render(self: App)
					pushToLog = self.pushToLog
					return self.state.log
				end
				local root = ReactNoop:createRoot()
				act(function()
					return Promise.resolve():andThen(function()
						root:render(React.createElement(App, nil))
					end)
				end):expect()
				expect(Scheduler).toHaveYielded({})
				expect(root).toMatchRenderedOutput(nil)
				act(function()
					return Promise.resolve():andThen(function()
						if
							Boolean.toJSBoolean(gate(function(flags)
								return flags.enableSyncDefaultUpdates
							end))
						then
							React.startTransition(function()
								pushToLog("A")
							end)
						else
							pushToLog("A")
						end
						ReactNoop:unstable_runWithPriority(ContinuousEventPriority, function()
							return pushToLog("B")
						end)
					end)
				end):expect()
				expect(Scheduler).toHaveYielded({
					-- A and B are pending. B is higher priority, so we'll render that first.
					"Committed: B",
					-- Because A comes first in the queue, we're now in rebase mode. B must
					-- be rebased on top of A. Also, in a layout effect, we received two new
					-- updates: C and D. C is user-blocking and D is synchronous.
					--
					-- First render the synchronous update. What we're testing here is that
					-- B *is not dropped* even though it has lower than sync priority. That's
					-- because we already committed it. However, this render should not
					-- include C, because that update wasn't already committed.
					"Committed: BD",
					"Committed: BCD",
					"Committed: ABCD",
				})
				expect(root).toMatchRenderedOutput("ABCD")
>>>>>>> upstream-apply
			end)
			jestExpect(Scheduler).toHaveYielded({})

			jestExpect(root).toMatchRenderedOutput("")

			ReactNoop.act(function()
				instance:pushToLog("A")
				-- TODO: Double wrapping is temporary while we remove Scheduler runWithPriority.
				ReactNoop.unstable_runWithPriority(InputContinuousLanePriority, function()
					Scheduler.unstable_runWithPriority(
						Scheduler.unstable_UserBlockingPriority,
						function()
							instance:pushToLog("B")
						end
					)
				end)
			end)
			jestExpect(Scheduler).toHaveYielded({
				-- A and B are pending. B is higher priority, so we'll render that first.
				"Committed: B",
				-- Because A comes first in the queue, we're now in rebase mode. B must
				-- be rebased on top of A. Also, in a layout effect, we received two new
				-- updates: C and D. C is user-blocking and D is synchronous.
				--
				-- First render the synchronous update. What we're testing here is that
				-- B *is not dropped* even though it has lower than sync priority. That's
				-- because we already committed it. However, this render should not
				-- include C, because that update wasn't already committed.
				"Committed: BD",
				"Committed: BCD",
				"Committed: ABCD",
			})
			jestExpect(root).toMatchRenderedOutput("ABCD")
		end
	)
	it(
		"base state of update queue is initialized to its fiber's memoized state",
		function()
			local app
			local App = React.Component:extend("App")
			function App:init()
				self.state = {
					prevProp = "A",
					count = 0,
				}
			end

			function App.getDerivedStateFromProps(props, state)
				-- Add 100 whenever the label prop changes. The prev label is stored
				-- in state. If the state is dropped incorrectly, we'll fail to detect
				-- prop changes.
				if props.prop ~= state.prevProp then
					return {
						prevProp = props.prop,
						count = state.count + 100,
					}
				end

				return nil
			end

			function App:render()
				app = self
				return self.state.count
			end
<<<<<<< HEAD

			local root = ReactNoop.createRoot()
			ReactNoop.act(function()
				root.render(React.createElement(App, { prop = "A" }))
			end)

			jestExpect(root).toMatchRenderedOutput("0") -- Changing the prop causes the count to increase by 100

			ReactNoop.act(function()
				root.render(React.createElement(App, { prop = "B" }))
			end)
			jestExpect(root).toMatchRenderedOutput("100")
			-- Now increment the count by 1 with a state update. And, in the same
			-- batch, change the prop back to its original value.

			ReactNoop.act(function()
				root.render(React.createElement(App, { prop = "A" }))
				app:setState(function(state)
					return {
						count = state.count + 1,
					}
=======
			local root = ReactNoop:createRoot()
			act(function()
				return Promise.resolve():andThen(function()
					root:render(React.createElement(App, { prop = "A" }))
				end)
			end):expect()
			expect(root).toMatchRenderedOutput("0") -- Changing the prop causes the count to increase by 100
			act(function()
				return Promise.resolve():andThen(function()
					root:render(React.createElement(App, { prop = "B" }))
				end)
			end):expect()
			expect(root).toMatchRenderedOutput("100") -- Now increment the count by 1 with a state update. And, in the same
			-- batch, change the prop back to its original value.
			act(function()
				return Promise.resolve():andThen(function()
					root:render(React.createElement(App, { prop = "A" }))
					app:setState(function(state)
						return { count = state.count + 1 }
					end)
>>>>>>> upstream-apply
				end)
			end) -- There were two total prop changes, plus an increment

			jestExpect(root).toMatchRenderedOutput("201")
		end
	)
end)
