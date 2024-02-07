<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react/src/__tests__/ReactProfiler-test.internal.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react/src/__tests__/ReactProfiler-test.internal.js
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

>>>>>>> upstream-apply
local React
local ReactFeatureFlags
local ReactNoop
local Scheduler
local ReactTestRenderer
<<<<<<< HEAD
local ReactTestRendererAct
local _SchedulerTracing
local AdvanceTime
local _AsyncText
local _ComponentWithPassiveEffect
local _Text
local TextResource
local resourcePromise
local setTimeout
local Set

local Packages = script.Parent.Parent.Parent

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it

local Promise = require("@pkg/@jsdotlua/promise")

local function loadModules(config)
	local enableProfilerTimer = (function()
		if config.enableProfilerTimer ~= nil then
			return config.enableProfilerTimer
		end
		return true
	end)()
	local enableProfilerCommitHooks = (function()
		if config.enableProfilerCommitHooks ~= nil then
			return config.enableProfilerCommitHooks
		end
		return true
	end)()
	local enableSchedulerTracing = (function()
		if config.enableSchedulerTracing ~= nil then
			return config.enableSchedulerTracing
		end
		return true
	end)()
	local replayFailedUnitOfWorkWithInvokeGuardedCallback = (function()
		if config.replayFailedUnitOfWorkWithInvokeGuardedCallback ~= nil then
			return config.replayFailedUnitOfWorkWithInvokeGuardedCallback
		end
		return false
	end)()
	local useNoopRenderer = (function()
		if config.useNoopRenderer ~= nil then
			return config.useNoopRenderer
		end
		return false
	end)()
	ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags

	ReactFeatureFlags.enableProfilerTimer = enableProfilerTimer
	ReactFeatureFlags.enableProfilerCommitHooks = enableProfilerCommitHooks
	ReactFeatureFlags.enableSchedulerTracing = enableSchedulerTracing
	ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback =
		replayFailedUnitOfWorkWithInvokeGuardedCallback

	local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
	setTimeout = LuauPolyfill.setTimeout
	Set = LuauPolyfill.Set

	React = require("../init")
	Scheduler = require("@pkg/@jsdotlua/scheduler")
	_SchedulerTracing = Scheduler.tracing
	ReactCache = require("@pkg/@jsdotlua/react-cache")

	if useNoopRenderer then
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
=======
local act
local AdvanceTime
local function loadModules(ref0_: Object?)
	local ref0: Object = if ref0_ ~= nil then ref0_ else {}
	local enableProfilerTimer, enableProfilerCommitHooks, enableProfilerNestedUpdatePhase, enableProfilerNestedUpdateScheduledHook, replayFailedUnitOfWorkWithInvokeGuardedCallback, useNoopRenderer =
		if ref0.enableProfilerTimer == nil then true else ref0.enableProfilerTimer,
		if ref0.enableProfilerCommitHooks == nil then true else ref0.enableProfilerCommitHooks,
		if ref0.enableProfilerNestedUpdatePhase == nil then true else ref0.enableProfilerNestedUpdatePhase,
		if ref0.enableProfilerNestedUpdateScheduledHook == nil
			then false
			else ref0.enableProfilerNestedUpdateScheduledHook,
		if ref0.replayFailedUnitOfWorkWithInvokeGuardedCallback == nil
			then false
			else ref0.replayFailedUnitOfWorkWithInvokeGuardedCallback,
		if ref0.useNoopRenderer == nil then false else ref0.useNoopRenderer
	ReactFeatureFlags = require_("shared/ReactFeatureFlags")
	ReactFeatureFlags.enableProfilerTimer = enableProfilerTimer
	ReactFeatureFlags.enableProfilerCommitHooks = enableProfilerCommitHooks
	ReactFeatureFlags.enableProfilerNestedUpdatePhase = enableProfilerNestedUpdatePhase
	ReactFeatureFlags.enableProfilerNestedUpdateScheduledHook = enableProfilerNestedUpdateScheduledHook
	ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback = replayFailedUnitOfWorkWithInvokeGuardedCallback
	React = require_("react")
	Scheduler = require_("scheduler")
	act = require_("jest-react").act
	if Boolean.toJSBoolean(useNoopRenderer) then
		ReactNoop = require_("react-noop-renderer")
>>>>>>> upstream-apply
		ReactTestRenderer = nil
	else
		ReactNoop = nil
<<<<<<< HEAD
		ReactTestRenderer = require("@pkg/@jsdotlua/react-test-renderer")
		ReactTestRendererAct = ReactTestRenderer.unstable_concurrentAct
=======
		ReactTestRenderer = require_("react-test-renderer")
>>>>>>> upstream-apply
	end

	AdvanceTime = React.Component:extend("AdvanceTime")
	AdvanceTime.defaultProps = {
		byAmount = 10,
		shouldComponentUpdate = true,
	}
	function AdvanceTime:shouldComponentUpdate(nextProps)
		return nextProps.shouldComponentUpdate
	end
	function AdvanceTime:render()
		-- Simulate time passing when self component is rendered
		Scheduler.unstable_advanceTime(self.props.byAmount)
		return self.props.children or nil
	end

<<<<<<< HEAD
	resourcePromise = nil

	TextResource = ReactCache.unstable_createResource(function(args)
		local text, ms = args[1], args[2] or 0
		resourcePromise = Promise.new(function(resolve, reject)
			setTimeout(function()
				Scheduler.unstable_yieldValue(
					string.format("Promise resolved [%s]", tostring(text))
				)
				resolve(text)
			end, ms)
		end)
		return resourcePromise
	end, function(args)
		local text = args[1]
		return text
	end)

	_AsyncText = function(props)
		local ms, text = props.ms, props.text
		local ok, result = pcall(function()
			TextResource.read({ text, ms })
			Scheduler.unstable_yieldValue(string.format("AsyncText [%s]", text))
			return text
		end)
		if not ok then
			local promise = result
			if typeof(promise.andThen) == "function" then
				Scheduler.unstable_yieldValue(string.format("Suspend [%s]", text))
			else
				Scheduler.unstable_yieldValue(string.format("Error [%s]", text))
			end
			error(promise)
		end
	end

	_Text = function(props)
		local text = props.text
		Scheduler.unstable_yieldValue(string.format("Text [%s]", text))
		return text
	end

	_ComponentWithPassiveEffect = function()
		-- Intentionally schedule a passive effect so the onPostCommit hook will be called.
		React.useEffect(function() end)
		return nil
	end
=======
    render() {
      // Simulate time passing when this component is rendered
      Scheduler.unstable_advanceTime(this.props.byAmount);
      return this.props.children || null;
    }

  } ]]
>>>>>>> upstream-apply
end

-- ROBLOX Test Noise: in upstream, jest setup config makes these tests hide
-- the error boundary warnings they trigger (scripts/jest/setupTests.js:72)
describe("Profiler", function()
	-- ROBLOX deviation: use faketimers instead
	-- local advanceTimeBy
	-- local currentTime

	describe("works in profiling and non-profiling bundles", function()
<<<<<<< HEAD
		for _, enableSchedulerTracing in { true, false } do
			for _, enableProfilerTimer in { true, false } do
				describe("enableSchedulerTracing:" .. (function()
					if enableSchedulerTracing then
						return "enabled"
					end
					return "disabled"
				end)() .. " enableProfilerTimer:" .. (function()
					if enableProfilerTimer then
						return "enabled"
					end
					return "disabled"
				end)() .. "}", function()
					-- ROBLOX deviation START: add condition, otherwise the suite will fail because of no tests
					if _G.__DEV__ and enableProfilerTimer then
						-- ROBLOX deviation END
						beforeEach(function()
							jest.resetModules()

							loadModules({
								enableSchedulerTracing = enableSchedulerTracing,
								enableProfilerTimer = enableProfilerTimer,
								-- ROBLOX TODO: set this explicitly to false until we have the correct HostConfig for the TestRenderer setup
								replayFailedUnitOfWorkWithInvokeGuardedCallback = false,
							})
						end)
						-- ROBLOX deviation START: add condition, otherwise the suite will fail because of no tests
					end
					-- ROBLOX deviation END

					-- This will throw in production too,
					-- But the test is only interested in verifying the DEV error message.
					if _G.__DEV__ and enableProfilerTimer then
						it("should warn if required params are missing", function()
							jestExpect(function()
								ReactTestRenderer.create(
									React.createElement(React.Profiler)
								)
							end).toErrorDev(
								'Profiler must specify an "id" as a prop',
								{
									withoutStack = true,
								}
							)
						end)

						it(
							"should support an empty Profiler (with no children)",
							function()
								jestExpect(function()
									ReactTestRenderer.create(
										React.createElement(React.Profiler, {
											id = "label",
											onRender = jest.fn(),
										})
									)
										:toJSON()
									-- ROBLOX TODO: toJSON needs to work, use toMatchSnapshot
								end).never.toThrow()
							end
						)

						it("should render children", function()
							local FunctionComponent = function(props)
								local label = props.label
								return React.createElement("span", nil, label)
							end
							local renderer = ReactTestRenderer.create(
								React.createElement(
									"div",
									nil,
									React.createElement("span", nil, "outside span"),
									React.createElement(
										React.Profiler,
										{ id = "label", onRender = jest.fn() },
										React.createElement("span", nil, "inside span"),
										React.createElement(FunctionComponent, {
											label = "function component",
										})
									)
								)
							)
							jestExpect(function()
								renderer:toJSON()
							end).never.toThrow()
							-- ROBLOX TODO: toJSON needs to work, use toMatchSnapshot
							--toMatchSnapshot()
						end)

						it("should support nested Profilers", function()
							local FunctionComponent = function(props)
								local label = props.label
								return React.createElement("div", nil, label)
							end
							local ClassComponent =
								React.Component:extend("ClassComponent")
							function ClassComponent:render()
								return React.createElement("block", nil, self.props.label)
							end
							local renderer = ReactTestRenderer.create(
								React.createElement(
									React.Profiler,
									{ id = "outer", onRender = jest.fn() },
									React.createElement(FunctionComponent, {
										label = "outer function component",
									}),
									React.createElement(
										React.Profiler,
										{ id = "inner", onRender = jest.fn() },
										React.createElement(ClassComponent, {
											label = "inner class component",
										}),
										React.createElement("span", nil, "inner span")
									)
								)
							)

							jestExpect(function()
								renderer:toJSON()
							end).never.toThrow()
							-- ROBLOX TODO: implement toJSON, use toMatchSnapshot when its available
							-- .toMatchSnapshot()
						end)
					end
				end)
			end
		end
	end)

	for _, enableSchedulerTracing in { true, false } do
		describe("onRender enableSchedulerTracing:" .. (function()
			if enableSchedulerTracing then
				return "enabled"
			end
			return "disabled"
		end)(), function()
			beforeEach(function()
				jest.resetModules()

				loadModules({
					enableSchedulerTracing = enableSchedulerTracing,
					-- ROBLOX TODO: set this explicitly to false until we have the correct HostConfig for the TestRenderer setup
					replayFailedUnitOfWorkWithInvokeGuardedCallback = false,
				})
			end)

			it("should handle errors thrown", function()
				local callback = jest.fn(function(id)
					if id == "throw" then
						error("expected")
					end
				end)

				local didMount = false
				local ClassComponent = React.Component:extend("ClassComponent")
				function ClassComponent:componentDidMount()
					didMount = true
				end
				function ClassComponent:render()
					return self.props.children
				end

				-- Errors thrown from onRender should not break the commit phase,
				-- Or prevent other lifecycles from being called.
				jestExpect(function()
					ReactTestRenderer.create(
						React.createElement(
							ClassComponent,
							nil,
							React.createElement(
								React.Profiler,
								{ id = "do-not-throw", onRender = callback },
								React.createElement(React.Profiler, {
									id = "throw",
									onRender = callback,
								}, React.createElement("div"))
							)
						)
					)
				end).toThrow("expected")
				jestExpect(didMount).toBe(true)
				jestExpect(callback).toHaveBeenCalledTimes(2)
			end)

			it("is not invoked until the commit phase", function()
				local callback = jest.fn()

				local Yield = function(props)
					local value = props.value
					Scheduler.unstable_yieldValue(value)
					return nil
				end

=======
		Array.forEach({ true, false }, function(enableProfilerTimer)
			describe(
				("enableProfilerTimer:%s"):format(
					if Boolean.toJSBoolean(enableProfilerTimer) then "enabled" else "disabled"
				),
				function()
					beforeEach(function()
						jest.resetModules()
						loadModules({ enableProfilerTimer = enableProfilerTimer })
					end) -- This will throw in production too,
					-- But the test is only interested in verifying the DEV error message.
					if Boolean.toJSBoolean(if Boolean.toJSBoolean(__DEV__) then enableProfilerTimer else __DEV__) then
						it("should warn if required params are missing", function()
							expect(function()
								ReactTestRenderer.create(React.createElement(React.Profiler, nil))
							end).toErrorDev(
								'Profiler must specify an "id" of type `string` as a prop. Received the type `undefined` instead.',
								{ withoutStack = true }
							)
						end)
					end
					it("should support an empty Profiler (with no children)", function()
						-- As root
						expect(
							ReactTestRenderer.create(
								React.createElement(React.Profiler, { id = "label", onRender = jest.fn() })
							)
								:toJSON()
						).toMatchSnapshot() -- As non-root
						expect(
							ReactTestRenderer.create(
								React.createElement(
									"div",
									nil,
									React.createElement(React.Profiler, { id = "label", onRender = jest.fn() })
								)
							):toJSON()
						).toMatchSnapshot()
					end)
					it("should render children", function()
						local function FunctionComponent(ref0)
							local label = ref0.label
							return React.createElement("span", nil, label)
						end
						local renderer = ReactTestRenderer.create(
							React.createElement(
								"div",
								nil,
								React.createElement("span", nil, "outside span"),
								React.createElement(
									React.Profiler,
									{ id = "label", onRender = jest.fn() },
									React.createElement("span", nil, "inside span"),
									React.createElement(FunctionComponent, { label = "function component" })
								)
							)
						)
						expect(renderer:toJSON()).toMatchSnapshot()
					end)
					it("should support nested Profilers", function()
						local function FunctionComponent(ref0)
							local label = ref0.label
							return React.createElement("div", nil, label)
						end
						type ClassComponent = React_Component<any, any> & {}
						type ClassComponent_statics = {}
						local ClassComponent =
							React.Component:extend("ClassComponent") :: ClassComponent & ClassComponent_statics
						function ClassComponent.render(self: ClassComponent)
							return React.createElement("block", nil, self.props.label)
						end
						local renderer = ReactTestRenderer.create(
							React.createElement(
								React.Profiler,
								{ id = "outer", onRender = jest.fn() },
								React.createElement(FunctionComponent, { label = "outer function component" }),
								React.createElement(
									React.Profiler,
									{ id = "inner", onRender = jest.fn() },
									React.createElement(ClassComponent, { label = "inner class component" }),
									React.createElement("span", nil, "inner span")
								)
							)
						)
						expect(renderer:toJSON()).toMatchSnapshot()
					end)
				end
			)
		end)
	end)
end)
describe("onRender", function()
	beforeEach(function()
		jest.resetModules()
		loadModules()
	end)
	it("should handle errors thrown", function()
		local callback = jest.fn(function(id)
			if id == "throw" then
				error(Error("expected"))
			end
		end)
		local didMount = false
		type ClassComponent = React_Component<any, any> & {}
		type ClassComponent_statics = {}
		local ClassComponent = React.Component:extend("ClassComponent") :: ClassComponent & ClassComponent_statics
		function ClassComponent.componentDidMount(self: ClassComponent)
			didMount = true
		end
		function ClassComponent.render(self: ClassComponent)
			return self.props.children
		end -- Errors thrown from onRender should not break the commit phase,
		-- Or prevent other lifecycles from being called.
		expect(function()
			return ReactTestRenderer.create(
				React.createElement(
					ClassComponent,
					nil,
					React.createElement(
						React.Profiler,
						{ id = "do-not-throw", onRender = callback },
						React.createElement(
							React.Profiler,
							{ id = "throw", onRender = callback },
							React.createElement("div", nil)
						)
					)
				)
			)
		end).toThrow("expected")
		expect(didMount).toBe(true)
		expect(callback).toHaveBeenCalledTimes(2)
	end)
	it("is not invoked until the commit phase", function()
		local callback = jest.fn()
		local function Yield(ref0)
			local value = ref0.value
			Scheduler:unstable_yieldValue(value)
			return nil
		end
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableSyncDefaultUpdates
		end)) then
			React.startTransition(function()
>>>>>>> upstream-apply
				ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(Yield, { value = "first" }),
						React.createElement(Yield, { value = "last" })
					),
<<<<<<< HEAD
					{
						unstable_isConcurrent = true,
					}
				)

				-- Times are logged until a render is committed.
				jestExpect(Scheduler).toFlushAndYieldThrough({ "first" })
				jestExpect(callback).toHaveBeenCalledTimes(0)
				jestExpect(Scheduler).toFlushAndYield({ "last" })
				jestExpect(callback).toHaveBeenCalledTimes(1)
			end)

			-- skipped translating some tests

			it("does not report work done on a sibling", function()
				local callback = jest.fn()

				local DoesNotUpdate = React.memo(function()
					Scheduler.unstable_advanceTime(10)
					return nil
				end, function()
					return true
				end)

				local updateProfilerSibling

				local function ProfilerSibling()
					local count, setCount = React.useState(0)
					updateProfilerSibling = function()
						setCount(count + 1)
					end
					return nil
				end

				local function App()
					return React.createElement(
						React.Fragment,
						nil,
						React.createElement(React.Profiler, {
							id = "test",
							onRender = callback,
						}, React.createElement(DoesNotUpdate)),
						React.createElement(ProfilerSibling)
					)
				end

				local renderer = ReactTestRenderer.create(React.createElement(App))

				jestExpect(callback).toHaveBeenCalledTimes(1)

				local call = callback.mock.calls[1]

				jestExpect(call).toHaveLength((function()
					if enableSchedulerTracing then
						return 7
					else
						return 6
					end
				end)())
				jestExpect(call[1]).toBe("test")
				jestExpect(call[2]).toBe("mount")
				jestExpect(call[3]).toBe(10) -- actual time
				jestExpect(call[4]).toBe(10) -- base time
				jestExpect(call[5]).toBe(0) -- start time
				jestExpect(call[6]).toBe(10) -- commit time
				jestExpect(call[7]).toEqual((function()
					if enableSchedulerTracing then
						return Set.new()
					else
						return nil
					end
				end)()) -- intersection events

				callback:mockReset()

				Scheduler.unstable_advanceTime(20) -- 10 -> 30

				renderer.update(React.createElement(App))

				-- ROBLOX deviation: we don't support dynamic/gated flags, so hard-code the path
				-- 						if (gate(flags => flags.new)) {
				-- None of the Profiler's subtree was rendered because App bailed out before the Profiler.
				-- So we expect onRender not to be called.
				jestExpect(callback).never.toHaveBeenCalled()
				-- 						} else {
				-- Updating a parent reports a re-render,
				-- since React technically did a little bit of work between the Profiler and the bailed out subtree.
				-- This is not optimal but it's how the old reconciler fork works.
				--   jestExpect(callback).toHaveBeenCalledTimes(1)

				--   call = callback.mock.calls[1]

				--   jestExpect(call).toHaveLength((function()
				-- 	if enableSchedulerTracing then
				-- 		return 7
				-- 	else
				-- 		return 6
				-- 	end
				-- 	end)())
				--   jestExpect(call[1]).toBe('test')
				--   jestExpect(call[2]).toBe('update')
				--   jestExpect(call[3]).toBe(0) -- actual time
				--   jestExpect(call[4]).toBe(10) -- base time
				--   jestExpect(call[5]).toBe(30) -- start time
				--   jestExpect(call[6]).toBe(30) -- commit time
				--   jestExpect(call[7]).toEqual((function()
				-- 	if enableSchedulerTracing then
				-- 		return {}
				-- 	else
				-- 		return nil
				-- 	end
				-- end)()) -- intersection events

				--   callback.mockReset()
				-- }

				Scheduler.unstable_advanceTime(20) -- 30 -> 50

				-- Updating a sibling should not report a re-render.
				ReactTestRendererAct(updateProfilerSibling)

				jestExpect(callback).never.toHaveBeenCalled()
			end)

			it("logs render times for both mount and update", function()
				local callback = jest.fn()

				Scheduler.unstable_advanceTime(5) -- 0 -> 5

				local renderer = ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(AdvanceTime)
					)
				)

				jestExpect(callback).toHaveBeenCalledTimes(1)

				local call = callback.mock.calls[1]

				jestExpect(call).toHaveLength((function()
					if enableSchedulerTracing then
						return 7
					else
						return 6
					end
				end)())
				jestExpect(call[1]).toBe("test")
				jestExpect(call[2]).toBe("mount")
				jestExpect(call[3]).toBe(10) -- actual time
				jestExpect(call[4]).toBe(10) -- base time
				jestExpect(call[5]).toBe(5) -- start time
				jestExpect(call[6]).toBe(15) -- commit time
				jestExpect(call[7]).toEqual((function()
					if enableSchedulerTracing then
						return Set.new()
					else
						return nil
					end
				end)()) -- intersection events

				callback.mockReset()

				Scheduler.unstable_advanceTime(20) -- 15 -> 35

				renderer.update(React.createElement(React.Profiler, {
					id = "test",
					onRender = callback,
				}, React.createElement(AdvanceTime)))

				jestExpect(callback).toHaveBeenCalledTimes(1)

				call = callback.mock.calls[1]

				jestExpect(call).toHaveLength((function()
					if enableSchedulerTracing then
						return 7
					else
						return 6
					end
				end)())
				jestExpect(call[1]).toBe("test")
				jestExpect(call[2]).toBe("update")
				jestExpect(call[3]).toBe(10) -- actual time
				jestExpect(call[4]).toBe(10) -- base time
				jestExpect(call[5]).toBe(35) -- start time
				jestExpect(call[6]).toBe(45) -- commit time
				jestExpect(call[7]).toEqual((function()
					if enableSchedulerTracing then
						return Set.new()
					else
						return nil
					end
				end)()) -- intersection events

				callback.mockReset()

				Scheduler.unstable_advanceTime(20) -- 45 -> 65

				renderer.update(React.createElement(React.Profiler, {
					id = "test",
					onRender = callback,
				}, React.createElement(AdvanceTime, { byAmount = 4 })))

				jestExpect(callback).toHaveBeenCalledTimes(1)

				call = callback.mock.calls[1]

				jestExpect(call).toHaveLength((function()
					if enableSchedulerTracing then
						return 7
					else
						return 6
					end
				end)())
				jestExpect(call[1]).toBe("test")
				jestExpect(call[2]).toBe("update")
				jestExpect(call[3]).toBe(4) -- actual time
				jestExpect(call[4]).toBe(4) -- base time
				jestExpect(call[5]).toBe(65) -- start time
				jestExpect(call[6]).toBe(69) -- commit time
				jestExpect(call[7]).toEqual((function()
					if enableSchedulerTracing then
						return Set.new()
					else
						return nil
					end
				end)()) -- intersection events
			end)

			it(
				"includes render times of nested Profilers in their parent times",
				function()
					local callback = jest.fn()

					Scheduler.unstable_advanceTime(5) -- 0 -> 5

					ReactTestRenderer.create(
						React.createElement(
							React.Fragment,
							nil,
							React.createElement(
								React.Profiler,
								{ id = "parent", onRender = callback },
								React.createElement(
									AdvanceTime,
									{ byAmount = 10 },
									React.createElement(
										React.Profiler,
										{ id = "child", onRender = callback },
										React.createElement(
											AdvanceTime,
											{ byAmount = 20 }
										)
									)
								)
							)
						)
					)

					jestExpect(callback).toHaveBeenCalledTimes(2)

					-- Callbacks bubble (reverse order).
					local childCall, parentCall =
						callback.mock.calls[1], callback.mock.calls[2]
					jestExpect(childCall[1]).toBe("child")
					jestExpect(parentCall[1]).toBe("parent")

					-- Parent times should include child times
					jestExpect(childCall[3]).toBe(20) -- actual time
					jestExpect(childCall[4]).toBe(20) -- base time
					jestExpect(childCall[5]).toBe(15) -- start time
					jestExpect(childCall[6]).toBe(35) -- commit time
					jestExpect(parentCall[3]).toBe(30) -- actual time
					jestExpect(parentCall[4]).toBe(30) -- base time
					jestExpect(parentCall[5]).toBe(5) -- start time
					jestExpect(parentCall[6]).toBe(35) -- commit time
				end
			)

			it("traces sibling Profilers separately", function()
				local callback = jest.fn()

				Scheduler.unstable_advanceTime(5) -- 0 -> 5

				ReactTestRenderer.create(
					React.createElement(
						React.Fragment,
						nil,
						React.createElement(React.Profiler, {
							id = "first",
							onRender = callback,
						}, React.createElement(AdvanceTime, { byAmount = 20 })),
						React.createElement(React.Profiler, {
							id = "second",
							onRender = callback,
						}, React.createElement(AdvanceTime, { byAmount = 5 }))
					)
				)

				jestExpect(callback).toHaveBeenCalledTimes(2)

				-- Callbacks bubble (reverse order).
				local firstCall, secondCall =
					callback.mock.calls[1], callback.mock.calls[2]
				jestExpect(firstCall[1]).toBe("first")
				jestExpect(secondCall[1]).toBe("second")

				-- Parent times should include child times
				jestExpect(firstCall[3]).toBe(20) -- actual time
				jestExpect(firstCall[4]).toBe(20) -- base time
				jestExpect(firstCall[5]).toBe(5) -- start time
				jestExpect(firstCall[6]).toBe(30) -- commit time
				jestExpect(secondCall[3]).toBe(5) -- actual time
				jestExpect(secondCall[4]).toBe(5) -- base time
				jestExpect(secondCall[5]).toBe(25) -- start time
				jestExpect(secondCall[6]).toBe(30) -- commit time
			end)

			it("does not include time spent outside of profile root", function()
				local callback = jest.fn()

				Scheduler.unstable_advanceTime(5) -- 0 -> 5

				ReactTestRenderer.create(
					React.createElement(
						React.Fragment,
						nil,
						React.createElement(AdvanceTime, { byAmount = 20 }),
						React.createElement(React.Profiler, {
							id = "test",
							onRender = callback,
						}, React.createElement(AdvanceTime, { byAmount = 5 })),
						React.createElement(AdvanceTime, { byAmount = 20 })
					)
				)

				jestExpect(callback).toHaveBeenCalledTimes(1)

				-- Callbacks bubble (reverse order).
				local call = callback.mock.calls[1]
				jestExpect(call[1]).toBe("test")
				jestExpect(call[3]).toBe(5) -- actual time
				jestExpect(call[4]).toBe(5) -- base time
				jestExpect(call[5]).toBe(25) -- start time
				jestExpect(call[6]).toBe(50) -- commit time
			end)

			it("is not called when blocked by sCU false", function()
				local callback = jest.fn()

				local instance
				local Updater = React.Component:extend("Updater")
				function Updater:init()
					self.state = {}
				end
				function Updater:render()
					instance = self
					return self.props.children
				end

				local renderer = ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "outer", onRender = callback },
						React.createElement(
							Updater,
							nil,
							React.createElement(
								React.Profiler,
								{ id = "inner", onRender = callback },
								React.createElement("div")
							)
						)
					)
				)

				-- All profile callbacks are called for initial render
				jestExpect(callback).toHaveBeenCalledTimes(2)

				callback:mockReset()

				renderer.unstable_flushSync(function()
					instance:setState({
						count = 1,
					})
				end)

				-- Only call onRender for paths that have re-rendered.
				-- Since the Updater's props didn't change,
				-- React does not re-render its children.
				jestExpect(callback).toHaveBeenCalledTimes(1)
				jestExpect(callback.mock.calls[1][1]).toBe("outer")
			end)

			it(
				"decreases actual time but not base time when sCU prevents an update",
				function()
					local callback = jest.fn()

					Scheduler.unstable_advanceTime(5) -- 0 -> 5

					local renderer = ReactTestRenderer.create(
						React.createElement(
							React.Profiler,
							{ id = "test", onRender = callback },
							React.createElement(
								AdvanceTime,
								{ byAmount = 10 },
								React.createElement(
									AdvanceTime,
									{ byAmount = 13, shouldComponentUpdate = false }
								)
							)
						)
					)

					jestExpect(callback).toHaveBeenCalledTimes(1)

					Scheduler.unstable_advanceTime(30) -- 28 -> 58

					renderer.update(
						React.createElement(
							React.Profiler,
							{ id = "test", onRender = callback },
							React.createElement(
								AdvanceTime,
								{ byAmount = 4 },
								React.createElement(
									AdvanceTime,
									{ byAmount = 7, shouldComponentUpdate = false }
								)
							)
						)
					)

					jestExpect(callback).toHaveBeenCalledTimes(2)

					local mountCall, updateCall =
						callback.mock.calls[1], callback.mock.calls[2]

					jestExpect(mountCall[2]).toBe("mount")
					jestExpect(mountCall[3]).toBe(23) -- actual time
					jestExpect(mountCall[4]).toBe(23) -- base time
					jestExpect(mountCall[5]).toBe(5) -- start time
					jestExpect(mountCall[6]).toBe(28) -- commit time

					jestExpect(updateCall[2]).toBe("update")
					jestExpect(updateCall[3]).toBe(4) -- actual time
					jestExpect(updateCall[4]).toBe(17) -- base time
					jestExpect(updateCall[5]).toBe(58) -- start time
					jestExpect(updateCall[6]).toBe(62) -- commit time
				end
			)

			it("includes time spent in render phase lifecycles", function()
				local WithLifecycles = React.Component:extend("WithLifecycles")
				function WithLifecycles:init()
					self.state = {}
				end
				WithLifecycles.getDerivedStateFromProps = function()
					Scheduler.unstable_advanceTime(3)
					return nil
				end
				function WithLifecycles:shouldComponentUpdate()
					Scheduler.unstable_advanceTime(7)
					return true
				end
				function WithLifecycles:render()
					Scheduler.unstable_advanceTime(5)
					return nil
				end

				local callback = jest.fn()

				Scheduler.unstable_advanceTime(5) -- 0 -> 5

				local renderer = ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(WithLifecycles)
					)
				)

				Scheduler.unstable_advanceTime(15) -- 13 -> 28

				renderer.update(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(WithLifecycles)
					)
				)

				jestExpect(callback).toHaveBeenCalledTimes(2)

				local mountCall, updateCall =
					callback.mock.calls[1], callback.mock.calls[2]

				jestExpect(mountCall[2]).toBe("mount")
				jestExpect(mountCall[3]).toBe(8) -- actual time
				jestExpect(mountCall[4]).toBe(8) -- base time
				jestExpect(mountCall[5]).toBe(5) -- start time
				jestExpect(mountCall[6]).toBe(13) -- commit time

				jestExpect(updateCall[2]).toBe("update")
				jestExpect(updateCall[3]).toBe(15) -- actual time
				jestExpect(updateCall[4]).toBe(15) -- base time
				jestExpect(updateCall[5]).toBe(28) -- start time
				jestExpect(updateCall[6]).toBe(43) -- commit time
			end)

			describe("with regard to interruptions", function()
				for _, replayFailedUnitOfWorkWithInvokeGuardedCallback in { true, false } do
					describe(
						"replayFailedUnitOfWorkWithInvokeGuardedCallback "
							.. (function()
								if replayFailedUnitOfWorkWithInvokeGuardedCallback then
									return "enabled"
								end
								return "disabled"
							end)(),
						function()
							beforeEach(function()
								jest.resetModules()

								loadModules({
									replayFailedUnitOfWorkWithInvokeGuardedCallback = replayFailedUnitOfWorkWithInvokeGuardedCallback,
								})
							end)

							it(
								"should accumulate actual time after an error handled by componentDidCatch()",
								function()
									local callback = jest.fn()

									local ThrowsError = function(props)
										local _unused = props.unused
										Scheduler.unstable_advanceTime(3)
										error("expected error")
									end

									local ErrorBoundary =
										React.Component:extend("ErrorBoundary")
									function ErrorBoundary:init()
										self.state = { error_ = nil }
									end
									function ErrorBoundary:componentDidCatch(error_)
										self:setState({ error_ = error_ })
									end
									function ErrorBoundary:render()
										Scheduler.unstable_advanceTime(2)
										return (function()
											if self.state.error_ == nil then
												return self.props.children
											end
											return React.createElement(
												AdvanceTime,
												{ byAmount = 20 }
											)
										end)()
									end

									Scheduler.unstable_advanceTime(5) -- 0 -> 5

									ReactTestRenderer.create(
										React.createElement(
											React.Profiler,
											{ id = "test", onRender = callback },
											React.createElement(
												ErrorBoundary,
												nil,
												React.createElement(
													AdvanceTime,
													{ byAmount = 9 }
												),
												React.createElement(ThrowsError)
											)
										)
									)

									jestExpect(callback).toHaveBeenCalledTimes(2)

									-- Callbacks bubble (reverse order).
									local mountCall, updateCall =
										callback.mock.calls[1], callback.mock.calls[2]

									-- The initial mount only includes the ErrorBoundary (which takes 2)
									-- But it spends time rendering all of the failed subtree also.
									jestExpect(mountCall[2]).toBe("mount")
									-- actual time includes: 2 (ErrorBoundary) + 9 (AdvanceTime) + 3 (ThrowsError)
									-- We don't count the time spent in replaying the failed unit of work (ThrowsError)
									jestExpect(mountCall[3]).toBe(14)
									-- base time includes: 2 (ErrorBoundary)
									-- Since the tree is empty for the initial commit
									jestExpect(mountCall[4]).toBe(2)
									-- start time
									jestExpect(mountCall[5]).toBe(5)
									-- commit time: 5 initially + 14 of work
									-- Add an additional 3 (ThrowsError) if we replayed the failed work
									jestExpect(mountCall[6]).toBe((function()
										if
											_G.__DEV__
											and replayFailedUnitOfWorkWithInvokeGuardedCallback
										then
											return 22
										end
										return 19
									end)())

									-- The update includes the ErrorBoundary and its fallback child
									jestExpect(updateCall[2]).toBe("update")
									-- actual time includes: 2 (ErrorBoundary) + 20 (AdvanceTime)
									jestExpect(updateCall[3]).toBe(22)
									-- base time includes: 2 (ErrorBoundary) + 20 (AdvanceTime)
									jestExpect(updateCall[4]).toBe(22)
									-- start time
									jestExpect(updateCall[5]).toBe((function()
										if
											_G.__DEV__
											and replayFailedUnitOfWorkWithInvokeGuardedCallback
										then
											return 22
										end
										return 19
									end)())

									-- commit time: 19 (startTime) + 2 (ErrorBoundary) + 20 (AdvanceTime)
									-- Add an additional 3 (ThrowsError) if we replayed the failed work
									jestExpect(updateCall[6]).toBe((function()
										if
											_G.__DEV__
											and replayFailedUnitOfWorkWithInvokeGuardedCallback
										then
											return 44
										end
										return 41
									end)())
								end
							)

							it(
								"should accumulate actual time after an error handled by getDerivedStateFromError()",
								function()
									local callback = jest.fn()

									local ThrowsError = function(props)
										local _unused = props.unused
										Scheduler.unstable_advanceTime(10)
										error("expected error")
									end

									local ErrorBoundary =
										React.Component:extend("ErrorBoundary")
									function ErrorBoundary:init()
										self.state = { error_ = nil }
									end
									function ErrorBoundary.getDerivedStateFromError(
										error_
									)
										return { error_ = error_ }
									end
									function ErrorBoundary:render()
										Scheduler.unstable_advanceTime(2)
										return (function()
											if self.state.error_ == nil then
												return self.props.children
											end
											return React.createElement(
												AdvanceTime,
												{ byAmount = 20 }
											)
										end)()
									end

									Scheduler.unstable_advanceTime(5) -- 0 -> 5

									ReactTestRenderer.create(
										React.createElement(
											React.Profiler,
											{ id = "test", onRender = callback },
											React.createElement(
												ErrorBoundary,
												nil,
												React.createElement(
													AdvanceTime,
													{ byAmount = 5 }
												),
												React.createElement(ThrowsError)
											)
										)
									)

									jestExpect(callback).toHaveBeenCalledTimes(1)

									-- Callbacks bubble (reverse order).
									local mountCall = callback.mock.calls[1]

									-- The initial mount includes the ErrorBoundary's error state,
									-- But it also spends actual time rendering UI that fails and isn't included.
									jestExpect(mountCall[2]).toBe("mount")
									-- actual time includes: 2 (ErrorBoundary) + 5 (AdvanceTime) + 10 (ThrowsError)
									-- Then the re-render: 2 (ErrorBoundary) + 20 (AdvanceTime)
									-- We don't count the time spent in replaying the failed unit of work (ThrowsError)
									jestExpect(mountCall[3]).toBe(39)
									-- base time includes: 2 (ErrorBoundary) + 20 (AdvanceTime)
									jestExpect(mountCall[4]).toBe(22)
									-- start time
									jestExpect(mountCall[5]).toBe(5)
									-- commit time
									jestExpect(mountCall[6]).toBe((function()
										if
											_G.__DEV__
											and replayFailedUnitOfWorkWithInvokeGuardedCallback
										then
											return 54
										end
										return 44
									end)())
								end
							)

							it(
								'should reset the fiber stack correct after a "complete" phase error',
								function()
									jest.resetModules()

									loadModules({
										useNoopRenderer = true,
										replayFailedUnitOfWorkWithInvokeGuardedCallback = replayFailedUnitOfWorkWithInvokeGuardedCallback,
									})

									-- Simulate a renderer error during the "complete" phase.
									-- This mimics behavior like React Native's View/Text nesting validation.
									ReactNoop.render(
										React.createElement(
											React.Profiler,
											{ id = "profiler", onRender = jest.fn() },
											React.createElement(
												"errorInCompletePhase",
												nil,
												"hi"
											)
										)
									)
									jestExpect(Scheduler).toFlushAndThrow(
										"Error in host config."
									)

									-- A similar case we've seen caused by an invariant in ReactDOM.
									-- It didn't reproduce without a host component inside.
									ReactNoop.render(
										React.createElement(
											React.Profiler,
											{ id = "profiler", onRender = jest.fn() },
											React.createElement(
												"errorInCompletePhase",
												nil,
												React.createElement("span", nil, "hi")
											)
										)
									)
									jestExpect(Scheduler).toFlushAndThrow(
										"Error in host config."
									)

									-- So long as the profiler timer's fiber stack is reset correctly,
									-- Subsequent renders should not error.
									ReactNoop.render(
										React.createElement(
											React.Profiler,
											{ id = "profiler", onRender = jest.fn() },
											React.createElement("span", nil, "hi")
										)
									)
									jestExpect(Scheduler).toFlushWithoutYielding()
								end
							)
						end
					)
				end
			end)
		end)
	end
=======
					{ unstable_isConcurrent = true }
				)
			end)
		else
			ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "test", onRender = callback },
					React.createElement(Yield, { value = "first" }),
					React.createElement(Yield, { value = "last" })
				),
				{ unstable_isConcurrent = true }
			)
		end -- Times are logged until a render is committed.
		expect(Scheduler).toFlushAndYieldThrough({ "first" })
		expect(callback).toHaveBeenCalledTimes(0)
		expect(Scheduler).toFlushAndYield({ "last" })
		expect(callback).toHaveBeenCalledTimes(1)
	end)
	it("does not record times for components outside of Profiler tree", function()
		-- Mock the Scheduler module so we can track how many times the current
		-- time is read
		jest.mock("scheduler", function(obj)
			local ActualScheduler = jest.requireActual("scheduler/unstable_mock")
			return Object.assign({}, ActualScheduler, {
				unstable_now = function(self)
					ActualScheduler:unstable_yieldValue("read current time")
					return ActualScheduler:unstable_now()
				end,
			})
		end)
		jest.resetModules()
		loadModules() -- Clear yields in case the current time is read during initialization.
		Scheduler:unstable_clearYields()
		ReactTestRenderer.create(
			React.createElement(
				"div",
				nil,
				React.createElement(AdvanceTime, nil),
				React.createElement(AdvanceTime, nil),
				React.createElement(AdvanceTime, nil),
				React.createElement(AdvanceTime, nil),
				React.createElement(AdvanceTime, nil)
			)
		) -- TODO: unstable_now is called by more places than just the profiler.
		-- Rewrite this test so it's less fragile.
		expect(Scheduler).toHaveYielded({
			"read current time",
			"read current time",
			"read current time",
			"read current time",
			"read current time",
		}) -- Restore original mock
		jest.mock("scheduler", function()
			return jest.requireActual("scheduler/unstable_mock")
		end)
	end)
	it("does not report work done on a sibling", function()
		local callback = jest.fn()
		local DoesNotUpdate = React.memo(function()
			Scheduler:unstable_advanceTime(10)
			return nil
		end, function()
			return true
		end)
		local updateProfilerSibling
		local function ProfilerSibling()
			local count, setCount = table.unpack(React.useState(0), 1, 2)
			updateProfilerSibling = function()
				return setCount(count + 1)
			end
			return nil
		end
		local function App()
			return React.createElement(
				React.Fragment,
				nil,
				React.createElement(
					React.Profiler,
					{ id = "test", onRender = callback },
					React.createElement(DoesNotUpdate, nil)
				),
				React.createElement(ProfilerSibling, nil)
			)
		end
		local renderer = ReactTestRenderer.create(React.createElement(App, nil))
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(6)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- actual time
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- base time
		expect(call[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(0) -- start time
		expect(call[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- commit time
		callback:mockReset()
		Scheduler:unstable_advanceTime(20) -- 10 -> 30
		renderer:update(React.createElement(App, nil))
		if Boolean.toJSBoolean(gate(function(flags)
			return flags.enableUseJSStackToTrackPassiveDurations
		end)) then
			-- None of the Profiler's subtree was rendered because App bailed out before the Profiler.
			-- So we expect onRender not to be called.
			expect(callback)["not"].toHaveBeenCalled()
		else
			-- Updating a parent reports a re-render,
			-- since React technically did a little bit of work between the Profiler and the bailed out subtree.
			-- This is not optimal but it's how the old reconciler fork works.
			expect(callback).toHaveBeenCalledTimes(1)
			call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call).toHaveLength(6)
			expect(call[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe("test")
			expect(call[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe("update")
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(0) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(10) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(30) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(30) -- commit time
			callback:mockReset()
		end
		Scheduler:unstable_advanceTime(20) -- 30 -> 50
		-- Updating a sibling should not report a re-render.
		act(updateProfilerSibling)
		expect(callback)["not"].toHaveBeenCalled()
	end)
	it("logs render times for both mount and update", function()
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(AdvanceTime, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[1]
		expect(call).toHaveLength(6)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- actual time
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- base time
		expect(call[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- start time
		expect(call[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(15) -- commit time
		callback:mockReset()
		Scheduler:unstable_advanceTime(20) -- 15 -> 35
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(AdvanceTime, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		call = callback.mock.calls[1]
		expect(call).toHaveLength(6)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- actual time
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- base time
		expect(call[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(35) -- start time
		expect(call[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(45) -- commit time
		callback:mockReset()
		Scheduler:unstable_advanceTime(20) -- 45 -> 65
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(AdvanceTime, { byAmount = 4 })
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		call = callback.mock.calls[1]
		expect(call).toHaveLength(6)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(4) -- actual time
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(4) -- base time
		expect(call[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(65) -- start time
		expect(call[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(69) -- commit time
	end)
	it("includes render times of nested Profilers in their parent times", function()
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		ReactTestRenderer.create(
			React.createElement(
				React.Fragment,
				nil,
				React.createElement(
					React.Profiler,
					{ id = "parent", onRender = callback },
					React.createElement(
						AdvanceTime,
						{ byAmount = 10 },
						React.createElement(
							React.Profiler,
							{ id = "child", onRender = callback },
							React.createElement(AdvanceTime, { byAmount = 20 })
						)
					)
				)
			)
		)
		expect(callback).toHaveBeenCalledTimes(2) -- Callbacks bubble (reverse order).
		local childCall, parentCall = table.unpack(callback.mock.calls, 1, 2)
		expect(childCall[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("child")
		expect(parentCall[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("parent") -- Parent times should include child times
		expect(childCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(20) -- actual time
		expect(childCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(20) -- base time
		expect(childCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(15) -- start time
		expect(childCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(35) -- commit time
		expect(parentCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(30) -- actual time
		expect(parentCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(30) -- base time
		expect(parentCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- start time
		expect(parentCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(35) -- commit time
	end)
	it("traces sibling Profilers separately", function()
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		ReactTestRenderer.create(
			React.createElement(
				React.Fragment,
				nil,
				React.createElement(
					React.Profiler,
					{ id = "first", onRender = callback },
					React.createElement(AdvanceTime, { byAmount = 20 })
				),
				React.createElement(
					React.Profiler,
					{ id = "second", onRender = callback },
					React.createElement(AdvanceTime, { byAmount = 5 })
				)
			)
		)
		expect(callback).toHaveBeenCalledTimes(2)
		local firstCall, secondCall = table.unpack(callback.mock.calls, 1, 2)
		expect(firstCall[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("first")
		expect(secondCall[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("second") -- Parent times should include child times
		expect(firstCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(20) -- actual time
		expect(firstCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(20) -- base time
		expect(firstCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- start time
		expect(firstCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(30) -- commit time
		expect(secondCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- actual time
		expect(secondCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- base time
		expect(secondCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(25) -- start time
		expect(secondCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(30) -- commit time
	end)
	it("does not include time spent outside of profile root", function()
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		ReactTestRenderer.create(
			React.createElement(
				React.Fragment,
				nil,
				React.createElement(AdvanceTime, { byAmount = 20 }),
				React.createElement(
					React.Profiler,
					{ id = "test", onRender = callback },
					React.createElement(AdvanceTime, { byAmount = 5 })
				),
				React.createElement(AdvanceTime, { byAmount = 20 })
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[1]
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- actual time
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- base time
		expect(call[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(25) -- start time
		expect(call[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(50) -- commit time
	end)
	it("is not called when blocked by sCU false", function()
		local callback = jest.fn()
		local instance
		type Updater = React_Component<any, any> & { state: Object }
		type Updater_statics = {}
		local Updater = React.Component:extend("Updater") :: Updater & Updater_statics
		function Updater.init(self: Updater)
			self.state = {}
		end
		function Updater.render(self: Updater)
			instance = self
			return self.props.children
		end
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "outer", onRender = callback },
				React.createElement(
					Updater,
					nil,
					React.createElement(
						React.Profiler,
						{ id = "inner", onRender = callback },
						React.createElement("div", nil)
					)
				)
			)
		) -- All profile callbacks are called for initial render
		expect(callback).toHaveBeenCalledTimes(2)
		callback:mockReset()
		renderer:unstable_flushSync(function()
			instance:setState({ count = 1 })
		end) -- Only call onRender for paths that have re-rendered.
		-- Since the Updater's props didn't change,
		-- React does not re-render its children.
		expect(callback).toHaveBeenCalledTimes(1)
		expect(callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("outer")
	end)
	it("decreases actual time but not base time when sCU prevents an update", function()
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(
					AdvanceTime,
					{ byAmount = 10 },
					React.createElement(AdvanceTime, { byAmount = 13, shouldComponentUpdate = false })
				)
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		Scheduler:unstable_advanceTime(30) -- 28 -> 58
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(
					AdvanceTime,
					{ byAmount = 4 },
					React.createElement(AdvanceTime, { byAmount = 7, shouldComponentUpdate = false })
				)
			)
		)
		expect(callback).toHaveBeenCalledTimes(2)
		local mountCall, updateCall = table.unpack(callback.mock.calls, 1, 2)
		expect(mountCall[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(mountCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(23) -- actual time
		expect(mountCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(23) -- base time
		expect(mountCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- start time
		expect(mountCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(28) -- commit time
		expect(updateCall[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(updateCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(4) -- actual time
		expect(updateCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(17) -- base time
		expect(updateCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(58) -- start time
		expect(updateCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(62) -- commit time
	end)
	it("includes time spent in render phase lifecycles", function()
		type WithLifecycles = React_Component<any, any> & { state: Object }
		type WithLifecycles_statics = {}
		local WithLifecycles = React.Component:extend("WithLifecycles") :: WithLifecycles & WithLifecycles_statics
		function WithLifecycles.init(self: WithLifecycles)
			self.state = {}
		end
		function WithLifecycles.getDerivedStateFromProps()
			Scheduler:unstable_advanceTime(3)
			return nil
		end
		function WithLifecycles.shouldComponentUpdate(self: WithLifecycles)
			Scheduler:unstable_advanceTime(7)
			return true
		end
		function WithLifecycles.render(self: WithLifecycles)
			Scheduler:unstable_advanceTime(5)
			return nil
		end
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(WithLifecycles, nil)
			)
		)
		Scheduler:unstable_advanceTime(15) -- 13 -> 28
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(WithLifecycles, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(2)
		local mountCall, updateCall = table.unpack(callback.mock.calls, 1, 2)
		expect(mountCall[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(mountCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(8) -- actual time
		expect(mountCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(8) -- base time
		expect(mountCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- start time
		expect(mountCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(13) -- commit time
		expect(updateCall[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(updateCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(15) -- actual time
		expect(updateCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(15) -- base time
		expect(updateCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(28) -- start time
		expect(updateCall[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(43) -- commit time
	end)
	it("should clear nested-update flag when multiple cascading renders are scheduled", function()
		loadModules({ useNoopRenderer = true })
		local function Component()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			local didMountAndUpdate, setDidMountAndUpdate = table.unpack(React.useState(false), 1, 2)
			React.useLayoutEffect(function()
				setDidMount(true)
			end, {})
			React.useEffect(function()
				if
					Boolean.toJSBoolean(
						if Boolean.toJSBoolean(didMount) then not Boolean.toJSBoolean(didMountAndUpdate) else didMount
					)
				then
					setDidMountAndUpdate(true)
				end
			end, { didMount, didMountAndUpdate })
			Scheduler:unstable_yieldValue(("%s:%s"):format(tostring(didMount), tostring(didMountAndUpdate)))
			return nil
		end
		local onRender = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "root", onRender = onRender },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "false:false", "true:false", "true:true" })
		expect(onRender).toHaveBeenCalledTimes(3)
		expect(onRender.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(onRender.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
		expect(onRender.mock.calls[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
	end)
	it("is properly distinguish updates and nested-updates when there is more than sync remaining work", function()
		loadModules({ useNoopRenderer = true })
		local function Component()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			React.useLayoutEffect(function()
				setDidMount(true)
			end, {})
			Scheduler:unstable_yieldValue(didMount)
			return didMount
		end
		local onRender = jest.fn() -- Schedule low-priority work.
		React.startTransition(function()
			return ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "root", onRender = onRender },
					React.createElement(Component, nil)
				)
			)
		end) -- Flush sync work with a nested update
		ReactNoop:flushSync(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "root", onRender = onRender },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ false, true }) -- Verify that the nested update inside of the sync work is appropriately tagged.
		expect(onRender).toHaveBeenCalledTimes(2)
		expect(onRender.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(onRender.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
	end)
	describe("with regard to interruptions", function()
		it("should accumulate actual time after a scheduling interruptions", function()
			local callback = jest.fn()
			local function Yield(ref0)
				local renderTime = ref0.renderTime
				Scheduler:unstable_advanceTime(renderTime)
				Scheduler:unstable_yieldValue("Yield:" .. tostring(renderTime))
				return nil
			end
			Scheduler:unstable_advanceTime(5) -- 0 -> 5
			-- Render partially, but run out of time before completing.
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					ReactTestRenderer.create(
						React.createElement(
							React.Profiler,
							{ id = "test", onRender = callback },
							React.createElement(Yield, { renderTime = 2 }),
							React.createElement(Yield, { renderTime = 3 })
						),
						{ unstable_isConcurrent = true }
					)
				end)
			else
				ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(Yield, { renderTime = 2 }),
						React.createElement(Yield, { renderTime = 3 })
					),
					{ unstable_isConcurrent = true }
				)
			end
			expect(Scheduler).toFlushAndYieldThrough({ "Yield:2" })
			expect(callback).toHaveBeenCalledTimes(0) -- Resume render for remaining children.
			expect(Scheduler).toFlushAndYield({ "Yield:3" }) -- Verify that logged times include both durations above.
			expect(callback).toHaveBeenCalledTimes(1)
			local call = callback.mock.calls[1]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(10) -- commit time
		end)
		it("should not include time between frames", function()
			local callback = jest.fn()
			local function Yield(ref0)
				local renderTime = ref0.renderTime
				Scheduler:unstable_advanceTime(renderTime)
				Scheduler:unstable_yieldValue("Yield:" .. tostring(renderTime))
				return nil
			end
			Scheduler:unstable_advanceTime(5) -- 0 -> 5
			-- Render partially, but don't finish.
			-- This partial render should take 5ms of simulated time.
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					ReactTestRenderer.create(
						React.createElement(
							React.Profiler,
							{ id = "outer", onRender = callback },
							React.createElement(Yield, { renderTime = 5 }),
							React.createElement(Yield, { renderTime = 10 }),
							React.createElement(
								React.Profiler,
								{ id = "inner", onRender = callback },
								React.createElement(Yield, { renderTime = 17 })
							)
						),
						{ unstable_isConcurrent = true }
					)
				end)
			else
				ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "outer", onRender = callback },
						React.createElement(Yield, { renderTime = 5 }),
						React.createElement(Yield, { renderTime = 10 }),
						React.createElement(
							React.Profiler,
							{ id = "inner", onRender = callback },
							React.createElement(Yield, { renderTime = 17 })
						)
					),
					{ unstable_isConcurrent = true }
				)
			end
			expect(Scheduler).toFlushAndYieldThrough({ "Yield:5" })
			expect(callback).toHaveBeenCalledTimes(0) -- Simulate time moving forward while frame is paused.
			Scheduler:unstable_advanceTime(50) -- 10 -> 60
			-- Flush the remaining work,
			-- Which should take an additional 10ms of simulated time.
			expect(Scheduler).toFlushAndYield({ "Yield:10", "Yield:17" })
			expect(callback).toHaveBeenCalledTimes(2)
			local innerCall, outerCall = table.unpack(callback.mock.calls, 1, 2) -- Verify that the actual time includes all work times,
			-- But not the time that elapsed between frames.
			expect(innerCall[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe("inner")
			expect(innerCall[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(17) -- actual time
			expect(innerCall[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(17) -- base time
			expect(innerCall[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(70) -- start time
			expect(innerCall[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(87) -- commit time
			expect(outerCall[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe("outer")
			expect(outerCall[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(32) -- actual time
			expect(outerCall[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(32) -- base time
			expect(outerCall[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- start time
			expect(outerCall[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(87) -- commit time
		end)
		it("should report the expected times when a high-pri update replaces a mount in-progress", function()
			local callback = jest.fn()
			local function Yield(ref0)
				local renderTime = ref0.renderTime
				Scheduler:unstable_advanceTime(renderTime)
				Scheduler:unstable_yieldValue("Yield:" .. tostring(renderTime))
				return nil
			end
			Scheduler:unstable_advanceTime(5) -- 0 -> 5
			-- Render a partially update, but don't finish.
			-- This partial render should take 10ms of simulated time.
			local renderer
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					renderer = ReactTestRenderer.create(
						React.createElement(
							React.Profiler,
							{ id = "test", onRender = callback },
							React.createElement(Yield, { renderTime = 10 }),
							React.createElement(Yield, { renderTime = 20 })
						),
						{ unstable_isConcurrent = true }
					)
				end)
			else
				renderer = ReactTestRenderer.create(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(Yield, { renderTime = 10 }),
						React.createElement(Yield, { renderTime = 20 })
					),
					{ unstable_isConcurrent = true }
				)
			end
			expect(Scheduler).toFlushAndYieldThrough({ "Yield:10" })
			expect(callback).toHaveBeenCalledTimes(0) -- Simulate time moving forward while frame is paused.
			Scheduler:unstable_advanceTime(100) -- 15 -> 115
			-- Interrupt with higher priority work.
			-- The interrupted work simulates an additional 5ms of time.
			renderer:unstable_flushSync(function()
				renderer:update(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(Yield, { renderTime = 5 })
					)
				)
			end)
			expect(Scheduler).toHaveYielded({ "Yield:5" }) -- The initial work was thrown away in this case,
			-- So the actual and base times should only include the final rendered tree times.
			expect(callback).toHaveBeenCalledTimes(1)
			local call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(115) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(120) -- commit time
			callback:mockReset() -- Verify no more unexpected callbacks from low priority work
			expect(Scheduler).toFlushWithoutYielding()
			expect(callback).toHaveBeenCalledTimes(0)
		end)
		it("should report the expected times when a high-priority update replaces a low-priority update", function()
			local callback = jest.fn()
			local function Yield(ref0)
				local renderTime = ref0.renderTime
				Scheduler:unstable_advanceTime(renderTime)
				Scheduler:unstable_yieldValue("Yield:" .. tostring(renderTime))
				return nil
			end
			Scheduler:unstable_advanceTime(5) -- 0 -> 5
			local renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "test", onRender = callback },
					React.createElement(Yield, { renderTime = 6 }),
					React.createElement(Yield, { renderTime = 15 })
				),
				{ unstable_isConcurrent = true }
			) -- Render everything initially.
			-- This should take 21 seconds of actual and base time.
			expect(Scheduler).toFlushAndYield({ "Yield:6", "Yield:15" })
			expect(callback).toHaveBeenCalledTimes(1)
			local call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(21) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(21) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(26) -- commit time
			callback:mockReset()
			Scheduler:unstable_advanceTime(30) -- 26 -> 56
			-- Render a partially update, but don't finish.
			-- This partial render should take 3ms of simulated time.
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					renderer:update(
						React.createElement(
							React.Profiler,
							{ id = "test", onRender = callback },
							React.createElement(Yield, { renderTime = 3 }),
							React.createElement(Yield, { renderTime = 5 }),
							React.createElement(Yield, { renderTime = 9 })
						)
					)
				end)
			else
				renderer:update(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(Yield, { renderTime = 3 }),
						React.createElement(Yield, { renderTime = 5 }),
						React.createElement(Yield, { renderTime = 9 })
					)
				)
			end
			expect(Scheduler).toFlushAndYieldThrough({ "Yield:3" })
			expect(callback).toHaveBeenCalledTimes(0) -- Simulate time moving forward while frame is paused.
			Scheduler:unstable_advanceTime(100) -- 59 -> 159
			-- Render another 5ms of simulated time.
			expect(Scheduler).toFlushAndYieldThrough({ "Yield:5" })
			expect(callback).toHaveBeenCalledTimes(0) -- Simulate time moving forward while frame is paused.
			Scheduler:unstable_advanceTime(100) -- 164 -> 264
			-- Interrupt with higher priority work.
			-- The interrupted work simulates an additional 11ms of time.
			renderer:unstable_flushSync(function()
				renderer:update(
					React.createElement(
						React.Profiler,
						{ id = "test", onRender = callback },
						React.createElement(Yield, { renderTime = 11 })
					)
				)
			end)
			expect(Scheduler).toHaveYielded({ "Yield:11" }) -- The actual time should include only the most recent render,
			-- Because this lets us avoid a lot of commit phase reset complexity.
			-- The base time includes only the final rendered tree times.
			expect(callback).toHaveBeenCalledTimes(1)
			call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(11) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(11) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(264) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(275) -- commit time
			-- Verify no more unexpected callbacks from low priority work
			expect(Scheduler).toFlushAndYield({})
			expect(callback).toHaveBeenCalledTimes(1)
		end)
		it("should report the expected times when a high-priority update interrupts a low-priority update", function()
			local callback = jest.fn()
			local function Yield(ref0)
				local renderTime = ref0.renderTime
				Scheduler:unstable_advanceTime(renderTime)
				Scheduler:unstable_yieldValue("Yield:" .. tostring(renderTime))
				return nil
			end
			local first
			type FirstComponent = React_Component<any, any> & { state: Object }
			type FirstComponent_statics = {}
			local FirstComponent = React.Component:extend("FirstComponent") :: FirstComponent & FirstComponent_statics
			function FirstComponent.init(self: FirstComponent)
				self.state = { renderTime = 1 }
			end
			function FirstComponent.render(self: FirstComponent)
				first = self
				Scheduler:unstable_advanceTime(self.state.renderTime)
				Scheduler:unstable_yieldValue("FirstComponent:" .. tostring(self.state.renderTime))
				return React.createElement(Yield, { renderTime = 4 })
			end
			local second
			type SecondComponent = React_Component<any, any> & { state: Object }
			type SecondComponent_statics = {}
			local SecondComponent =
				React.Component:extend("SecondComponent") :: SecondComponent & SecondComponent_statics
			function SecondComponent.init(self: SecondComponent)
				self.state = { renderTime = 2 }
			end
			function SecondComponent.render(self: SecondComponent)
				second = self
				Scheduler:unstable_advanceTime(self.state.renderTime)
				Scheduler:unstable_yieldValue("SecondComponent:" .. tostring(self.state.renderTime))
				return React.createElement(Yield, { renderTime = 7 })
			end
			Scheduler:unstable_advanceTime(5) -- 0 -> 5
			local renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "test", onRender = callback },
					React.createElement(FirstComponent, nil),
					React.createElement(SecondComponent, nil)
				),
				{ unstable_isConcurrent = true }
			) -- Render everything initially.
			-- This simulates a total of 14ms of actual render time.
			-- The base render time is also 14ms for the initial render.
			expect(Scheduler).toFlushAndYield({
				"FirstComponent:1",
				"Yield:4",
				"SecondComponent:2",
				"Yield:7",
			})
			expect(callback).toHaveBeenCalledTimes(1)
			local call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(14) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(14) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(5) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(19) -- commit time
			callback:mockClear()
			Scheduler:unstable_advanceTime(100) -- 19 -> 119
			-- Render a partially update, but don't finish.
			-- This partial render will take 10ms of actual render time.
			if Boolean.toJSBoolean(gate(function(flags)
				return flags.enableSyncDefaultUpdates
			end)) then
				React.startTransition(function()
					first:setState({ renderTime = 10 })
				end)
			else
				first:setState({ renderTime = 10 })
			end
			expect(Scheduler).toFlushAndYieldThrough({ "FirstComponent:10" })
			expect(callback).toHaveBeenCalledTimes(0) -- Simulate time moving forward while frame is paused.
			Scheduler:unstable_advanceTime(100) -- 129 -> 229
			-- Interrupt with higher priority work.
			-- This simulates a total of 37ms of actual render time.
			renderer:unstable_flushSync(function()
				return second:setState({ renderTime = 30 })
			end)
			expect(Scheduler).toHaveYielded({ "SecondComponent:30", "Yield:7" }) -- The actual time should include only the most recent render (37ms),
			-- Because this greatly simplifies the commit phase logic.
			-- The base time should include the more recent times for the SecondComponent subtree,
			-- As well as the original times for the FirstComponent subtree.
			expect(callback).toHaveBeenCalledTimes(1)
			call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(37) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(42) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(229) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(266) -- commit time
			callback:mockClear() -- Simulate time moving forward while frame is paused.
			Scheduler:unstable_advanceTime(100) -- 266 -> 366
			-- Resume the original low priority update, with rebased state.
			-- This simulates a total of 14ms of actual render time,
			-- And does not include the original (interrupted) 10ms.
			-- The tree contains 42ms of base render time at this point,
			-- Reflecting the most recent (longer) render durations.
			-- TODO: This actual time should decrease by 10ms once the scheduler supports resuming.
			expect(Scheduler).toFlushAndYield({ "FirstComponent:10", "Yield:4" })
			expect(callback).toHaveBeenCalledTimes(1)
			call = callback.mock.calls[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			expect(call[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(14) -- actual time
			expect(call[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(51) -- base time
			expect(call[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(366) -- start time
			expect(call[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]).toBe(380) -- commit time
		end)
		Array.forEach({ true, false }, function(replayFailedUnitOfWorkWithInvokeGuardedCallback)
			describe(
				("replayFailedUnitOfWorkWithInvokeGuardedCallback %s"):format(
					if Boolean.toJSBoolean(replayFailedUnitOfWorkWithInvokeGuardedCallback)
						then "enabled"
						else "disabled"
				),
				function()
					beforeEach(function()
						jest.resetModules()
						loadModules({
							replayFailedUnitOfWorkWithInvokeGuardedCallback = replayFailedUnitOfWorkWithInvokeGuardedCallback,
						})
					end)
					it("should accumulate actual time after an error handled by componentDidCatch()", function()
						local callback = jest.fn()
						local function ThrowsError(ref0)
							local unused = ref0.unused
							Scheduler:unstable_advanceTime(3)
							error(Error("expected error"))
						end
						type ErrorBoundary = React_Component<any, any> & { state: Object }
						type ErrorBoundary_statics = {}
						local ErrorBoundary =
							React.Component:extend("ErrorBoundary") :: ErrorBoundary & ErrorBoundary_statics
						function ErrorBoundary.init(self: ErrorBoundary)
							self.state = { error = nil }
						end
						function ErrorBoundary.componentDidCatch(self: ErrorBoundary, error_)
							self:setState({ error = error_ })
						end
						function ErrorBoundary.render(self: ErrorBoundary)
							Scheduler:unstable_advanceTime(2)
							return if self.state.error == nil
								then self.props.children
								else React.createElement(AdvanceTime, { byAmount = 20 })
						end
						Scheduler:unstable_advanceTime(5) -- 0 -> 5
						ReactTestRenderer.create(
							React.createElement(
								React.Profiler,
								{ id = "test", onRender = callback },
								React.createElement(
									ErrorBoundary,
									nil,
									React.createElement(AdvanceTime, { byAmount = 9 }),
									React.createElement(ThrowsError, nil)
								)
							)
						)
						expect(callback).toHaveBeenCalledTimes(2) -- Callbacks bubble (reverse order).
						local mountCall, updateCall = table.unpack(callback.mock.calls, 1, 2) -- The initial mount only includes the ErrorBoundary (which takes 2)
						-- But it spends time rendering all of the failed subtree also.
						expect(mountCall[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe("mount") -- actual time includes: 2 (ErrorBoundary) + 9 (AdvanceTime) + 3 (ThrowsError)
						-- We don't count the time spent in replaying the failed unit of work (ThrowsError)
						expect(mountCall[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(14) -- base time includes: 2 (ErrorBoundary)
						-- Since the tree is empty for the initial commit
						expect(mountCall[
							4 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(2) -- start time
						expect(mountCall[
							5 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(5) -- commit time: 5 initially + 14 of work
						-- Add an additional 3 (ThrowsError) if we replayed the failed work
						expect(mountCall[
							6 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(
							if Boolean.toJSBoolean(
									if Boolean.toJSBoolean(__DEV__)
										then replayFailedUnitOfWorkWithInvokeGuardedCallback
										else __DEV__
								)
								then 22
								else 19
						) -- The update includes the ErrorBoundary and its fallback child
						expect(updateCall[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe("nested-update") -- actual time includes: 2 (ErrorBoundary) + 20 (AdvanceTime)
						expect(updateCall[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(22) -- base time includes: 2 (ErrorBoundary) + 20 (AdvanceTime)
						expect(updateCall[
							4 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(22) -- start time
						expect(updateCall[
							5 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(
							if Boolean.toJSBoolean(
									if Boolean.toJSBoolean(__DEV__)
										then replayFailedUnitOfWorkWithInvokeGuardedCallback
										else __DEV__
								)
								then 22
								else 19
						) -- commit time: 19 (startTime) + 2 (ErrorBoundary) + 20 (AdvanceTime)
						-- Add an additional 3 (ThrowsError) if we replayed the failed work
						expect(updateCall[
							6 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(
							if Boolean.toJSBoolean(
									if Boolean.toJSBoolean(__DEV__)
										then replayFailedUnitOfWorkWithInvokeGuardedCallback
										else __DEV__
								)
								then 44
								else 41
						)
					end)
					it("should accumulate actual time after an error handled by getDerivedStateFromError()", function()
						local callback = jest.fn()
						local function ThrowsError(ref0)
							local unused = ref0.unused
							Scheduler:unstable_advanceTime(10)
							error(Error("expected error"))
						end
						type ErrorBoundary = React_Component<any, any> & { state: Object }
						type ErrorBoundary_statics = {}
						local ErrorBoundary =
							React.Component:extend("ErrorBoundary") :: ErrorBoundary & ErrorBoundary_statics
						function ErrorBoundary.init(self: ErrorBoundary)
							self.state = { error = nil }
						end
						function ErrorBoundary.getDerivedStateFromError(error_)
							return { error = error_ }
						end
						function ErrorBoundary.render(self: ErrorBoundary)
							Scheduler:unstable_advanceTime(2)
							return if self.state.error == nil
								then self.props.children
								else React.createElement(AdvanceTime, { byAmount = 20 })
						end
						Scheduler:unstable_advanceTime(5) -- 0 -> 5
						ReactTestRenderer.create(
							React.createElement(
								React.Profiler,
								{ id = "test", onRender = callback },
								React.createElement(
									ErrorBoundary,
									nil,
									React.createElement(AdvanceTime, { byAmount = 5 }),
									React.createElement(ThrowsError, nil)
								)
							)
						)
						expect(callback).toHaveBeenCalledTimes(1) -- Callbacks bubble (reverse order).
						local mountCall = callback.mock.calls[1] -- The initial mount includes the ErrorBoundary's error state,
						-- But it also spends actual time rendering UI that fails and isn't included.
						expect(mountCall[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe("mount") -- actual time includes: 2 (ErrorBoundary) + 5 (AdvanceTime) + 10 (ThrowsError)
						-- Then the re-render: 2 (ErrorBoundary) + 20 (AdvanceTime)
						-- We don't count the time spent in replaying the failed unit of work (ThrowsError)
						expect(mountCall[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(39) -- base time includes: 2 (ErrorBoundary) + 20 (AdvanceTime)
						expect(mountCall[
							4 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(22) -- start time
						expect(mountCall[
							5 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(5) -- commit time
						expect(mountCall[
							6 --[[ ROBLOX adaptation: added 1 to array index ]]
						]).toBe(
							if Boolean.toJSBoolean(
									if Boolean.toJSBoolean(__DEV__)
										then replayFailedUnitOfWorkWithInvokeGuardedCallback
										else __DEV__
								)
								then 54
								else 44
						)
					end)
					it('should reset the fiber stack correct after a "complete" phase error', function()
						jest.resetModules()
						loadModules({
							useNoopRenderer = true,
							replayFailedUnitOfWorkWithInvokeGuardedCallback = replayFailedUnitOfWorkWithInvokeGuardedCallback,
						}) -- Simulate a renderer error during the "complete" phase.
						-- This mimics behavior like React Native's View/Text nesting validation.
						ReactNoop:render(
							React.createElement(
								React.Profiler,
								{ id = "profiler", onRender = jest.fn() },
								React.createElement("errorInCompletePhase", nil, "hi")
							)
						)
						expect(Scheduler).toFlushAndThrow("Error in host config.") -- A similar case we've seen caused by an invariant in ReactDOM.
						-- It didn't reproduce without a host component inside.
						ReactNoop:render(
							React.createElement(
								React.Profiler,
								{ id = "profiler", onRender = jest.fn() },
								React.createElement("errorInCompletePhase", nil, React.createElement("span", nil, "hi"))
							)
						)
						expect(Scheduler).toFlushAndThrow("Error in host config.") -- So long as the profiler timer's fiber stack is reset correctly,
						-- Subsequent renders should not error.
						ReactNoop:render(
							React.createElement(
								React.Profiler,
								{ id = "profiler", onRender = jest.fn() },
								React.createElement("span", nil, "hi")
							)
						)
						expect(Scheduler).toFlushWithoutYielding()
					end)
				end
			)
		end)
	end)
	it("reflects the most recently rendered id value", function()
		local callback = jest.fn()
		Scheduler:unstable_advanceTime(5) -- 0 -> 5
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "one", onRender = callback },
				React.createElement(AdvanceTime, { byAmount = 2 })
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		Scheduler:unstable_advanceTime(20) -- 7 -> 27
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "two", onRender = callback },
				React.createElement(AdvanceTime, { byAmount = 1 })
			)
		)
		expect(callback).toHaveBeenCalledTimes(2)
		local mountCall, updateCall = table.unpack(callback.mock.calls, 1, 2)
		expect(mountCall[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("one")
		expect(mountCall[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(mountCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(2) -- actual time
		expect(mountCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(2) -- base time
		expect(mountCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(5) -- start time
		expect(updateCall[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("two")
		expect(updateCall[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(updateCall[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1) -- actual time
		expect(updateCall[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1) -- base time
		expect(updateCall[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(27) -- start time
	end)
	it("should not be called until after mutations", function()
		local classComponentMounted = false
		local callback = jest.fn(function(id, phase, actualDuration, baseDuration, startTime, commitTime)
			-- Don't call this hook until after mutations
			expect(classComponentMounted).toBe(true) -- But the commit time should reflect pre-mutation
			expect(commitTime).toBe(2)
		end)
		type ClassComponent = React_Component<any, any> & {}
		type ClassComponent_statics = {}
		local ClassComponent = React.Component:extend("ClassComponent") :: ClassComponent & ClassComponent_statics
		function ClassComponent.componentDidMount(self: ClassComponent)
			Scheduler:unstable_advanceTime(5)
			classComponentMounted = true
		end
		function ClassComponent.render(self: ClassComponent)
			Scheduler:unstable_advanceTime(2)
			return nil
		end
		ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "test", onRender = callback },
				React.createElement(ClassComponent, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
	end)
end)
describe("onCommit", function()
	beforeEach(function()
		jest.resetModules()
		loadModules()
	end)
	it("should report time spent in layout effects and commit lifecycles", function()
		local callback = jest.fn()
		local function ComponentWithEffects()
			React.useLayoutEffect(function()
				Scheduler:unstable_advanceTime(10)
				return function()
					Scheduler:unstable_advanceTime(100)
				end
			end, {})
			React.useLayoutEffect(function()
				Scheduler:unstable_advanceTime(1000)
				return function()
					Scheduler:unstable_advanceTime(10000)
				end
			end)
			React.useEffect(function()
				-- This passive effect is here to verify that its time isn't reported.
				Scheduler:unstable_advanceTime(5)
				return function()
					Scheduler:unstable_advanceTime(7)
				end
			end)
			return nil
		end
		type ComponentWithCommitHooks = React_Component<any, any> & {}
		type ComponentWithCommitHooks_statics = {}
		local ComponentWithCommitHooks =
			React.Component:extend("ComponentWithCommitHooks") :: ComponentWithCommitHooks & ComponentWithCommitHooks_statics
		function ComponentWithCommitHooks.componentDidMount(self: ComponentWithCommitHooks)
			Scheduler:unstable_advanceTime(100000)
		end
		function ComponentWithCommitHooks.componentDidUpdate(self: ComponentWithCommitHooks)
			Scheduler:unstable_advanceTime(1000000)
		end
		function ComponentWithCommitHooks.render(self: ComponentWithCommitHooks)
			return nil
		end
		Scheduler:unstable_advanceTime(1)
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "mount-test", onCommit = callback },
				React.createElement(ComponentWithEffects, nil),
				React.createElement(ComponentWithCommitHooks, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(101010) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1) -- commit start time (before mutations or effects)
		Scheduler:unstable_advanceTime(1)
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "update-test", onCommit = callback },
				React.createElement(ComponentWithEffects, nil),
				React.createElement(ComponentWithCommitHooks, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(2)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1011000) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(101017) -- commit start time (before mutations or effects)
		Scheduler:unstable_advanceTime(1)
		renderer:update(React.createElement(React.Profiler, { id = "unmount-test", onCommit = callback }))
		expect(callback).toHaveBeenCalledTimes(3)
		call = callback.mock.calls[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("unmount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1112030) -- commit start time (before mutations or effects)
	end)
	it("should report time spent in layout effects and commit lifecycles with cascading renders", function()
		local callback = jest.fn()
		local function ComponentWithEffects(ref0)
			local shouldCascade = ref0.shouldCascade
			local didCascade, setDidCascade = table.unpack(React.useState(false), 1, 2)
			Scheduler:unstable_advanceTime(100000000)
			React.useLayoutEffect(function()
				if
					Boolean.toJSBoolean(
						if Boolean.toJSBoolean(shouldCascade)
							then not Boolean.toJSBoolean(didCascade)
							else shouldCascade
					)
				then
					setDidCascade(true)
				end
				Scheduler:unstable_advanceTime(if Boolean.toJSBoolean(didCascade) then 30 else 10)
				return function()
					Scheduler:unstable_advanceTime(100)
				end
			end, { didCascade, shouldCascade })
			return nil
		end
		type ComponentWithCommitHooks = React_Component<any, any> & { state: Object }
		type ComponentWithCommitHooks_statics = {}
		local ComponentWithCommitHooks =
			React.Component:extend("ComponentWithCommitHooks") :: ComponentWithCommitHooks & ComponentWithCommitHooks_statics
		function ComponentWithCommitHooks.init(self: ComponentWithCommitHooks)
			self.state = { didCascade = false }
		end
		function ComponentWithCommitHooks.componentDidMount(self: ComponentWithCommitHooks)
			Scheduler:unstable_advanceTime(1000)
		end
		function ComponentWithCommitHooks.componentDidUpdate(self: ComponentWithCommitHooks)
			Scheduler:unstable_advanceTime(10000)
			if
				Boolean.toJSBoolean(
					if Boolean.toJSBoolean(self.props.shouldCascade)
						then not Boolean.toJSBoolean(self.state.didCascade)
						else self.props.shouldCascade
				)
			then
				self:setState({ didCascade = true })
			end
		end
		function ComponentWithCommitHooks.render(self: ComponentWithCommitHooks)
			Scheduler:unstable_advanceTime(1000000000)
			return nil
		end
		Scheduler:unstable_advanceTime(1)
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "mount-test", onCommit = callback },
				React.createElement(ComponentWithEffects, { shouldCascade = true }),
				React.createElement(ComponentWithCommitHooks, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(2)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1010) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1100000001) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(130) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1200001011) -- commit start time (before mutations or effects)
		Scheduler:unstable_advanceTime(1)
		renderer:update(
			React.createElement(
				React.Profiler,
				{ id = "update-test", onCommit = callback },
				React.createElement(ComponentWithEffects, nil),
				React.createElement(ComponentWithCommitHooks, { shouldCascade = true })
			)
		)
		expect(callback).toHaveBeenCalledTimes(4)
		call = callback.mock.calls[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10130) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(2300001142) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10000) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(3300011272) -- commit start time (before mutations or effects)
	end)
	it("should include time spent in ref callbacks", function()
		local callback = jest.fn()
		local function refSetter(ref)
			if ref ~= nil then
				Scheduler:unstable_advanceTime(10)
			else
				Scheduler:unstable_advanceTime(100)
			end
		end
		type ClassComponent = React_Component<any, any> & {}
		type ClassComponent_statics = {}
		local ClassComponent = React.Component:extend("ClassComponent") :: ClassComponent & ClassComponent_statics
		function ClassComponent.render(self: ClassComponent)
			return nil
		end
		local function Component()
			Scheduler:unstable_advanceTime(1000)
			return React.createElement(ClassComponent, { ref = refSetter })
		end
		Scheduler:unstable_advanceTime(1)
		local renderer = ReactTestRenderer.create(
			React.createElement(
				React.Profiler,
				{ id = "root", onCommit = callback },
				React.createElement(Component, nil)
			)
		)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1001) -- commit start time (before mutations or effects)
		callback:mockClear()
		renderer:update(React.createElement(React.Profiler, { id = "root", onCommit = callback }))
		expect(callback).toHaveBeenCalledTimes(1)
		call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1011) -- commit start time (before mutations or effects)
	end)
	it("should bubble time spent in layout effects to higher profilers", function()
		local callback = jest.fn()
		local function ComponentWithEffects(ref0)
			local cleanupDuration, duration, setCountRef = ref0.cleanupDuration, ref0.duration, ref0.setCountRef
			local setCount = React.useState(0)[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			if
				setCountRef ~= nil --[[ ROBLOX CHECK: loose inequality used upstream ]]
			then
				setCountRef.current = setCount
			end
			React.useLayoutEffect(function()
				Scheduler:unstable_advanceTime(duration)
				return function()
					Scheduler:unstable_advanceTime(cleanupDuration)
				end
			end)
			Scheduler:unstable_advanceTime(1)
			return nil
		end
		local setCountRef = React.createRef(nil)
		local renderer = nil
		act(function()
			renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "root-mount", onCommit = callback },
					React.createElement(
						React.Profiler,
						{ id = "a" },
						React.createElement(
							ComponentWithEffects,
							{ duration = 10, cleanupDuration = 100, setCountRef = setCountRef }
						)
					),
					React.createElement(
						React.Profiler,
						{ id = "b" },
						React.createElement(ComponentWithEffects, { duration = 1000, cleanupDuration = 10000 })
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root-mount")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1010) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(2) -- commit start time (before mutations or effects)
		act(function()
			return setCountRef:current(function(count)
				return count + 1
			end)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root-mount")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(110) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1013) -- commit start time (before mutations or effects)
		act(function()
			renderer:update(
				React.createElement(
					React.Profiler,
					{ id = "root-update", onCommit = callback },
					React.createElement(
						React.Profiler,
						{ id = "b" },
						React.createElement(ComponentWithEffects, { duration = 1000, cleanupDuration = 10000 })
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(3)
		call = callback.mock.calls[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root-update")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1124) -- commit start time (before mutations or effects)
	end)
	it("should properly report time in layout effects even when there are errors", function()
		local callback = jest.fn()
		type ErrorBoundary = React_Component<any, any> & { state: Object }
		type ErrorBoundary_statics = {}
		local ErrorBoundary = React.Component:extend("ErrorBoundary") :: ErrorBoundary & ErrorBoundary_statics
		function ErrorBoundary.init(self: ErrorBoundary)
			self.state = { error = nil }
		end
		function ErrorBoundary.getDerivedStateFromError(error_)
			return { error = error_ }
		end
		function ErrorBoundary.render(self: ErrorBoundary)
			return if self.state.error == nil then self.props.children else self.props.fallback
		end
		local function ComponentWithEffects(ref0)
			local cleanupDuration, duration, effectDuration, shouldThrow =
				ref0.cleanupDuration, ref0.duration, ref0.effectDuration, ref0.shouldThrow
			React.useLayoutEffect(function()
				Scheduler:unstable_advanceTime(effectDuration)
				if Boolean.toJSBoolean(shouldThrow) then
					error(Error("expected"))
				end
				return function()
					Scheduler:unstable_advanceTime(cleanupDuration)
				end
			end)
			Scheduler:unstable_advanceTime(duration)
			return nil
		end
		Scheduler:unstable_advanceTime(1) -- Test an error that happens during an effect
		act(function()
			ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "root", onCommit = callback },
					React.createElement(
						ErrorBoundary,
						{
							fallback = React.createElement(ComponentWithEffects, {
								duration = 10000000,
								effectDuration = 100000000,
								cleanupDuration = 1000000000,
							}),
						},
						React.createElement(ComponentWithEffects, {
							duration = 10,
							effectDuration = 100,
							cleanupDuration = 1000,
							shouldThrow = true,
						})
					),
					React.createElement(
						ComponentWithEffects,
						{ duration = 10000, effectDuration = 100000, cleanupDuration = 1000000 }
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Initial render (with error)
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10011) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Cleanup render from error boundary
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100000000) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10110111) -- commit start time (before mutations or effects)
	end)
	it("should properly report time in layout effect cleanup functions even when there are errors", function()
		local callback = jest.fn()
		type ErrorBoundary = React_Component<any, any> & { state: Object }
		type ErrorBoundary_statics = {}
		local ErrorBoundary = React.Component:extend("ErrorBoundary") :: ErrorBoundary & ErrorBoundary_statics
		function ErrorBoundary.init(self: ErrorBoundary)
			self.state = { error = nil }
		end
		function ErrorBoundary.getDerivedStateFromError(error_)
			return { error = error_ }
		end
		function ErrorBoundary.render(self: ErrorBoundary)
			return if self.state.error == nil then self.props.children else self.props.fallback
		end
		local function ComponentWithEffects(ref0)
			local cleanupDuration, duration, effectDuration, shouldThrow =
				ref0.cleanupDuration,
				ref0.duration,
				ref0.effectDuration,
				if ref0.shouldThrow == nil then false else ref0.shouldThrow
			React.useLayoutEffect(function()
				Scheduler:unstable_advanceTime(effectDuration)
				return function()
					Scheduler:unstable_advanceTime(cleanupDuration)
					if Boolean.toJSBoolean(shouldThrow) then
						error(Error("expected"))
					end
				end
			end)
			Scheduler:unstable_advanceTime(duration)
			return nil
		end
		Scheduler:unstable_advanceTime(1)
		local renderer = nil
		act(function()
			renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "root", onCommit = callback },
					React.createElement(
						ErrorBoundary,
						{
							fallback = React.createElement(ComponentWithEffects, {
								duration = 10000000,
								effectDuration = 100000000,
								cleanupDuration = 1000000000,
							}),
						},
						React.createElement(ComponentWithEffects, {
							duration = 10,
							effectDuration = 100,
							cleanupDuration = 1000,
							shouldThrow = true,
						})
					),
					React.createElement(
						ComponentWithEffects,
						{ duration = 10000, effectDuration = 100000, cleanupDuration = 1000000 }
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Initial render
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10011) -- commit start time (before mutations or effects)
		callback:mockClear() -- Test an error that happens during an cleanup function
		act(function()
			renderer:update(
				React.createElement(
					React.Profiler,
					{ id = "root", onCommit = callback },
					React.createElement(
						ErrorBoundary,
						{
							fallback = React.createElement(ComponentWithEffects, {
								duration = 10000000,
								effectDuration = 100000000,
								cleanupDuration = 1000000000,
							}),
						},
						React.createElement(ComponentWithEffects, {
							duration = 10,
							effectDuration = 100,
							cleanupDuration = 1000,
							shouldThrow = false,
						})
					),
					React.createElement(
						ComponentWithEffects,
						{ duration = 10000, effectDuration = 100000, cleanupDuration = 1000000 }
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Update (that throws)
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1101100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(120121) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Cleanup render from error boundary
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100001000) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(11221221) -- commit start time (before mutations or effects)
	end)
end)
describe("onPostCommit", function()
	beforeEach(function()
		jest.resetModules()
		loadModules()
	end)
	it("should report time spent in passive effects", function()
		local callback = jest.fn()
		local function ComponentWithEffects()
			React.useLayoutEffect(function()
				-- This layout effect is here to verify that its time isn't reported.
				Scheduler:unstable_advanceTime(5)
				return function()
					Scheduler:unstable_advanceTime(7)
				end
			end)
			React.useEffect(function()
				Scheduler:unstable_advanceTime(10)
				return function()
					Scheduler:unstable_advanceTime(100)
				end
			end, {})
			React.useEffect(function()
				Scheduler:unstable_advanceTime(1000)
				return function()
					Scheduler:unstable_advanceTime(10000)
				end
			end)
			return nil
		end
		Scheduler:unstable_advanceTime(1)
		local renderer
		act(function()
			renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "mount-test", onPostCommit = callback },
					React.createElement(ComponentWithEffects, nil)
				)
			)
		end)
		Scheduler:unstable_flushAll()
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1010) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1) -- commit start time (before mutations or effects)
		Scheduler:unstable_advanceTime(1)
		act(function()
			renderer:update(
				React.createElement(
					React.Profiler,
					{ id = "update-test", onPostCommit = callback },
					React.createElement(ComponentWithEffects, nil)
				)
			)
		end)
		Scheduler:unstable_flushAll()
		expect(callback).toHaveBeenCalledTimes(2)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(11000) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1017) -- commit start time (before mutations or effects)
		Scheduler:unstable_advanceTime(1)
		act(function()
			renderer:update(React.createElement(React.Profiler, { id = "unmount-test", onPostCommit = callback }))
		end)
		Scheduler:unstable_flushAll()
		expect(callback).toHaveBeenCalledTimes(3)
		call = callback.mock.calls[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("unmount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update") -- TODO (bvaughn) The duration reported below should be 10100, but is 0
		-- by the time the passive effect is flushed its parent Fiber pointer is gone.
		-- If we refactor to preserve the unmounted Fiber tree we could fix this.
		-- The current implementation would require too much extra overhead to track this.
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(0) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(12030) -- commit start time (before mutations or effects)
	end)
	it("should report time spent in passive effects with cascading renders", function()
		local callback = jest.fn()
		local function ComponentWithEffects()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			Scheduler:unstable_advanceTime(1000)
			React.useEffect(function()
				if not Boolean.toJSBoolean(didMount) then
					setDidMount(true)
				end
				Scheduler:unstable_advanceTime(if Boolean.toJSBoolean(didMount) then 30 else 10)
				return function()
					Scheduler:unstable_advanceTime(100)
				end
			end, { didMount })
			return nil
		end
		Scheduler:unstable_advanceTime(1)
		act(function()
			ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "mount-test", onPostCommit = callback },
					React.createElement(ComponentWithEffects, nil)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1001) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount-test")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(130) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(2011) -- commit start time (before mutations or effects)
	end)
	it("should bubble time spent in effects to higher profilers", function()
		local callback = jest.fn()
		local function ComponentWithEffects(ref0)
			local cleanupDuration, duration, setCountRef = ref0.cleanupDuration, ref0.duration, ref0.setCountRef
			local setCount = React.useState(0)[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			if
				setCountRef ~= nil --[[ ROBLOX CHECK: loose inequality used upstream ]]
			then
				setCountRef.current = setCount
			end
			React.useEffect(function()
				Scheduler:unstable_advanceTime(duration)
				return function()
					Scheduler:unstable_advanceTime(cleanupDuration)
				end
			end)
			Scheduler:unstable_advanceTime(1)
			return nil
		end
		local setCountRef = React.createRef(nil)
		local renderer = nil
		act(function()
			renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "root-mount", onPostCommit = callback },
					React.createElement(
						React.Profiler,
						{ id = "a" },
						React.createElement(
							ComponentWithEffects,
							{ duration = 10, cleanupDuration = 100, setCountRef = setCountRef }
						)
					),
					React.createElement(
						React.Profiler,
						{ id = "b" },
						React.createElement(ComponentWithEffects, { duration = 1000, cleanupDuration = 10000 })
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root-mount")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1010) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(2) -- commit start time (before mutations or effects)
		act(function()
			return setCountRef:current(function(count)
				return count + 1
			end)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root-mount")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(110) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1013) -- commit start time (before mutations or effects)
		act(function()
			renderer:update(
				React.createElement(
					React.Profiler,
					{ id = "root-update", onPostCommit = callback },
					React.createElement(
						React.Profiler,
						{ id = "b" },
						React.createElement(ComponentWithEffects, { duration = 1000, cleanupDuration = 10000 })
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(3)
		call = callback.mock.calls[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root-update")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1124) -- commit start time (before mutations or effects)
	end)
	it("should properly report time in passive effects even when there are errors", function()
		local callback = jest.fn()
		type ErrorBoundary = React_Component<any, any> & { state: Object }
		type ErrorBoundary_statics = {}
		local ErrorBoundary = React.Component:extend("ErrorBoundary") :: ErrorBoundary & ErrorBoundary_statics
		function ErrorBoundary.init(self: ErrorBoundary)
			self.state = { error = nil }
		end
		function ErrorBoundary.getDerivedStateFromError(error_)
			return { error = error_ }
		end
		function ErrorBoundary.render(self: ErrorBoundary)
			return if self.state.error == nil then self.props.children else self.props.fallback
		end
		local function ComponentWithEffects(ref0)
			local cleanupDuration, duration, effectDuration, shouldThrow =
				ref0.cleanupDuration, ref0.duration, ref0.effectDuration, ref0.shouldThrow
			React.useEffect(function()
				Scheduler:unstable_advanceTime(effectDuration)
				if Boolean.toJSBoolean(shouldThrow) then
					error(Error("expected"))
				end
				return function()
					Scheduler:unstable_advanceTime(cleanupDuration)
				end
			end)
			Scheduler:unstable_advanceTime(duration)
			return nil
		end
		Scheduler:unstable_advanceTime(1) -- Test an error that happens during an effect
		act(function()
			ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "root", onPostCommit = callback },
					React.createElement(
						ErrorBoundary,
						{
							fallback = React.createElement(ComponentWithEffects, {
								duration = 10000000,
								effectDuration = 100000000,
								cleanupDuration = 1000000000,
							}),
						},
						React.createElement(ComponentWithEffects, {
							duration = 10,
							effectDuration = 100,
							cleanupDuration = 1000,
							shouldThrow = true,
						})
					),
					React.createElement(
						ComponentWithEffects,
						{ duration = 10000, effectDuration = 100000, cleanupDuration = 1000000 }
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Initial render (with error)
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10011) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Cleanup render from error boundary
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100000000) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10110111) -- commit start time (before mutations or effects)
	end)
	it("should properly report time in passive effect cleanup functions even when there are errors", function()
		local callback = jest.fn()
		type ErrorBoundary = React_Component<any, any> & { state: Object }
		type ErrorBoundary_statics = {}
		local ErrorBoundary = React.Component:extend("ErrorBoundary") :: ErrorBoundary & ErrorBoundary_statics
		function ErrorBoundary.init(self: ErrorBoundary)
			self.state = { error = nil }
		end
		function ErrorBoundary.getDerivedStateFromError(error_)
			return { error = error_ }
		end
		function ErrorBoundary.render(self: ErrorBoundary)
			return if self.state.error == nil then self.props.children else self.props.fallback
		end
		local function ComponentWithEffects(ref0)
			local cleanupDuration, duration, effectDuration, shouldThrow, id =
				ref0.cleanupDuration,
				ref0.duration,
				ref0.effectDuration,
				if ref0.shouldThrow == nil then false else ref0.shouldThrow,
				ref0.id
			React.useEffect(function()
				Scheduler:unstable_advanceTime(effectDuration)
				return function()
					Scheduler:unstable_advanceTime(cleanupDuration)
					if Boolean.toJSBoolean(shouldThrow) then
						error(Error("expected"))
					end
				end
			end)
			Scheduler:unstable_advanceTime(duration)
			return nil
		end
		Scheduler:unstable_advanceTime(1)
		local renderer = nil
		act(function()
			renderer = ReactTestRenderer.create(
				React.createElement(
					React.Profiler,
					{ id = "root", onPostCommit = callback },
					React.createElement(
						ErrorBoundary,
						{
							fallback = React.createElement(ComponentWithEffects, {
								duration = 10000000,
								effectDuration = 100000000,
								cleanupDuration = 1000000000,
							}),
						},
						React.createElement(ComponentWithEffects, {
							duration = 10,
							effectDuration = 100,
							cleanupDuration = 1000,
							shouldThrow = true,
						})
					),
					React.createElement(
						ComponentWithEffects,
						{ duration = 10000, effectDuration = 100000, cleanupDuration = 1000000 }
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(1)
		local call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Initial render
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(10011) -- commit start time (before mutations or effects)
		callback:mockClear() -- Test an error that happens during an cleanup function
		act(function()
			renderer:update(
				React.createElement(
					React.Profiler,
					{ id = "root", onPostCommit = callback },
					React.createElement(
						ErrorBoundary,
						{
							fallback = React.createElement(ComponentWithEffects, {
								duration = 10000000,
								effectDuration = 100000000,
								cleanupDuration = 1000000000,
							}),
						},
						React.createElement(ComponentWithEffects, {
							duration = 10,
							effectDuration = 100,
							cleanupDuration = 1000,
							shouldThrow = false,
						})
					),
					React.createElement(
						ComponentWithEffects,
						{ duration = 10000, effectDuration = 100000, cleanupDuration = 1000000 }
					)
				)
			)
		end)
		expect(callback).toHaveBeenCalledTimes(2)
		call = callback.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Update (that throws)
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update") -- We continue flushing pending effects even if one throws.
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(1101100) -- durations
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(120121) -- commit start time (before mutations or effects)
		call = callback.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- Cleanup render from error boundary
		expect(call).toHaveLength(4)
		expect(call[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
		expect(call[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("update")
		expect(call[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(100000000) -- durations
		-- The commit time varies because the above duration time varies
		expect(call[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe(11221221) -- commit start time (before mutations or effects)
	end)
end)
describe("onNestedUpdateScheduled", function()
	beforeEach(function()
		jest.resetModules()
		loadModules({ enableProfilerNestedUpdateScheduledHook = true, useNoopRenderer = true })
	end)
	it("is not called when the legacy render API is used to schedule an update", function()
		local onNestedUpdateScheduled = jest.fn()
		ReactNoop:renderLegacySyncRoot(
			React.createElement(
				React.Profiler,
				{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
				React.createElement("div", nil, "initial")
			)
		)
		ReactNoop:renderLegacySyncRoot(
			React.createElement(
				React.Profiler,
				{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
				React.createElement("div", nil, "update")
			)
		)
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end)
	it("is not called when the root API is used to schedule an update", function()
		local onNestedUpdateScheduled = jest.fn()
		ReactNoop:render(
			React.createElement(
				React.Profiler,
				{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
				React.createElement("div", nil, "initial")
			)
		)
		ReactNoop:render(
			React.createElement(
				React.Profiler,
				{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
				React.createElement("div", nil, "update")
			)
		)
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end)
	it("is called when a function component schedules an update during a layout effect", function()
		local function Component()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			React.useLayoutEffect(function()
				setDidMount(true)
			end, {})
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(didMount)))
			return didMount
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false", "Component:true" })
		expect(onNestedUpdateScheduled).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduled.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
	end)
	it("is called when a function component schedules a batched update during a layout effect", function()
		local function Component()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			React.useLayoutEffect(function()
				ReactNoop:batchedUpdates(function()
					setDidMount(true)
				end)
			end, {})
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(didMount)))
			return didMount
		end
		local onNestedUpdateScheduled = jest.fn()
		local onRender = jest.fn()
		ReactNoop:render(React.createElement(React.Profiler, {
			id = "root",
			onNestedUpdateScheduled = onNestedUpdateScheduled,
			onRender = onRender,
		}, React.createElement(Component, nil)))
		expect(Scheduler).toFlushAndYield({ "Component:false", "Component:true" })
		expect(onRender).toHaveBeenCalledTimes(2)
		expect(onRender.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("mount")
		expect(onRender.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("nested-update")
		expect(onNestedUpdateScheduled).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduled.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("root")
	end)
	it("bubbles up and calls all ancestor Profilers", function()
		local function Component()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			React.useLayoutEffect(function()
				setDidMount(true)
			end, {})
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(didMount)))
			return didMount
		end
		local onNestedUpdateScheduledOne = jest.fn()
		local onNestedUpdateScheduledTwo = jest.fn()
		local onNestedUpdateScheduledThree = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "one", onNestedUpdateScheduled = onNestedUpdateScheduledOne },
					React.createElement(
						React.Profiler,
						{ id = "two", onNestedUpdateScheduled = onNestedUpdateScheduledTwo },
						React.createElement(
							React.Fragment,
							nil,
							React.createElement(Component, nil),
							React.createElement(React.Profiler, {
								id = "three",
								onNestedUpdateScheduled = onNestedUpdateScheduledThree,
							})
						)
					)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false", "Component:true" })
		expect(onNestedUpdateScheduledOne).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduledOne.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("one")
		expect(onNestedUpdateScheduledTwo).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduledTwo.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("two")
		expect(onNestedUpdateScheduledThree)["not"].toHaveBeenCalled()
	end)
	it("is not called when an update is scheduled for another doort during a layout effect", function()
		local setStateRef = React.createRef(nil)
		local function ComponentRootOne()
			local state, setState = table.unpack(React.useState(false), 1, 2)
			setStateRef.current = setState
			Scheduler:unstable_yieldValue(("ComponentRootOne:%s"):format(tostring(state)))
			return state
		end
		local function ComponentRootTwo()
			React.useLayoutEffect(function()
				setStateRef:current(true)
			end, {})
			Scheduler:unstable_yieldValue("ComponentRootTwo")
			return nil
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:renderToRootWithID(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(ComponentRootOne, nil)
				),
				1
			)
			ReactNoop:renderToRootWithID(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(ComponentRootTwo, nil)
				),
				2
			)
		end)
		expect(Scheduler).toHaveYielded({
			"ComponentRootOne:false",
			"ComponentRootTwo",
			"ComponentRootOne:true",
		})
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end)
	it("is not called when a function component schedules an update during a passive effect", function()
		local function Component()
			local didMount, setDidMount = table.unpack(React.useState(false), 1, 2)
			React.useEffect(function()
				setDidMount(true)
			end, {})
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(didMount)))
			return didMount
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false", "Component:true" })
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end)
	it("is not called when a function component schedules an update outside of render", function()
		local updateFnRef = React.createRef(nil)
		local function Component()
			local state, setState = table.unpack(React.useState(false), 1, 2)
			updateFnRef.current = function(_self: any)
				return setState(true)
			end
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(state)))
			return state
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false" })
		act(function()
			updateFnRef:current()
		end)
		expect(Scheduler).toHaveYielded({ "Component:true" })
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end)
	it("it is not called when a component schedules an update during render", function()
		local function Component()
			local state, setState = table.unpack(React.useState(false), 1, 2)
			if state == false then
				setState(true)
			end
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(state)))
			return state
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false", "Component:true" })
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end)
	it("it is called when a component schedules an update from a ref callback", function()
		local function Component(ref0)
			local mountChild = ref0.mountChild
			local refAttached, setRefAttached = table.unpack(React.useState(false), 1, 2)
			local refDetached, setRefDetached = table.unpack(React.useState(false), 1, 2)
			local refSetter = React.useCallback(function(ref)
				if ref ~= nil then
					setRefAttached(true)
				else
					setRefDetached(true)
				end
			end, {})
			Scheduler:unstable_yieldValue(("Component:%s:%s"):format(tostring(refAttached), tostring(refDetached)))
			return if Boolean.toJSBoolean(mountChild) then React.createElement("div", { ref = refSetter }) else nil
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, { mountChild = true })
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false:false", "Component:true:false" })
		expect(onNestedUpdateScheduled).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduled.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, { mountChild = false })
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:true:false", "Component:true:true" })
		expect(onNestedUpdateScheduled).toHaveBeenCalledTimes(2)
		expect(onNestedUpdateScheduled.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
	end)
	it("is called when a class component schedules an update from the componentDidMount lifecycles", function()
		type Component = React_Component<any, any> & { state: Object }
		type Component_statics = {}
		local Component = React.Component:extend("Component") :: Component & Component_statics
		function Component.init(self: Component)
			self.state = { value = false }
		end
		function Component.componentDidMount(self: Component)
			self:setState({ value = true })
		end
		function Component.render(self: Component)
			local value = self.state.value
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(value)))
			return value
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false", "Component:true" })
		expect(onNestedUpdateScheduled).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduled.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
	end)
	it("is called when a class component schedules an update from the componentDidUpdate lifecycles", function()
		type Component = React_Component<any, any> & { state: Object }
		type Component_statics = {}
		local Component = React.Component:extend("Component") :: Component & Component_statics
		function Component.init(self: Component)
			self.state = { nestedUpdateSheduled = false }
		end
		function Component.componentDidUpdate(self: Component, prevProps, prevState)
			if
				Boolean.toJSBoolean(
					if Boolean.toJSBoolean(self.props.scheduleNestedUpdate)
						then not Boolean.toJSBoolean(self.state.nestedUpdateSheduled)
						else self.props.scheduleNestedUpdate
				)
			then
				self:setState({ nestedUpdateSheduled = true })
			end
		end
		function Component.render(self: Component)
			local scheduleNestedUpdate = self.props.scheduleNestedUpdate
			local nestedUpdateSheduled = self.state.nestedUpdateSheduled
			Scheduler:unstable_yieldValue(
				("Component:%s:%s"):format(tostring(scheduleNestedUpdate), tostring(nestedUpdateSheduled))
			)
			return nestedUpdateSheduled
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, { scheduleNestedUpdate = false })
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false:false" })
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, { scheduleNestedUpdate = true })
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:true:false", "Component:true:true" })
		expect(onNestedUpdateScheduled).toHaveBeenCalledTimes(1)
		expect(onNestedUpdateScheduled.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("test")
	end)
	it("is not called when a class component schedules an update outside of render", function()
		local updateFnRef = React.createRef(nil)
		type Component = React_Component<any, any> & { state: Object }
		type Component_statics = {}
		local Component = React.Component:extend("Component") :: Component & Component_statics
		function Component.init(self: Component)
			self.state = { value = false }
		end
		function Component.render(self: Component)
			local value = self.state.value
			updateFnRef.current = function(_self: any)
				return self:setState({ value = true })
			end
			Scheduler:unstable_yieldValue(("Component:%s"):format(tostring(value)))
			return value
		end
		local onNestedUpdateScheduled = jest.fn()
		act(function()
			ReactNoop:render(
				React.createElement(
					React.Profiler,
					{ id = "test", onNestedUpdateScheduled = onNestedUpdateScheduled },
					React.createElement(Component, nil)
				)
			)
		end)
		expect(Scheduler).toHaveYielded({ "Component:false" })
		act(function()
			updateFnRef:current()
		end)
		expect(Scheduler).toHaveYielded({ "Component:true" })
		expect(onNestedUpdateScheduled)["not"].toHaveBeenCalled()
	end) -- TODO Add hydration tests to ensure we don't have false positives called.
>>>>>>> upstream-apply
end)
