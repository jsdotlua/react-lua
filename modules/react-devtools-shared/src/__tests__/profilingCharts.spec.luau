--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/profilingCharts-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]

local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local xdescribe = JestGlobals.xdescribe
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach
local describe = JestGlobals.describe
local it = JestGlobals.it
local jestExpect = JestGlobals.expect

local devtoolsTypes = require("./devtools/types")
type Store = devtoolsTypes.Store

xdescribe("profiling charts", function()
	local React
	local ReactRoblox
	local Scheduler
	local SchedulerTracing
	-- local TestRenderer
	local store: Store
	local utils
	beforeEach(function()
		_G.__PROFILE__ = true
		utils = require("./utils")
		utils.beforeEachProfiling()

		store = _G.store
		store:setCollapseNodesByDefault(false)
		store:setRecordChangeDescriptions(true)
		React = require("@pkg/@jsdotlua/react")
		ReactRoblox = require("@pkg/@jsdotlua/react-roblox")
		Scheduler = require("@pkg/@jsdotlua/scheduler")
		SchedulerTracing = Scheduler.tracing
	end)
	afterEach(function()
		_G.__PROFILE__ = nil
	end)
	describe("flamegraph chart", function()
		it("should contain valid data", function()
			local Child
			local function Parent(_: {})
				Scheduler.unstable_advanceTime(10)
				return React.createElement(
					React.Fragment,
					nil,
					React.createElement(Child, { key = "first", duration = 3 }),
					React.createElement(Child, { key = "second", duration = 2 }),
					React.createElement(Child, { key = "third", duration = 0 })
				)
			end

			-- Memoize children to verify that chart doesn't include in the update.
			function Child(ref)
				local duration = ref.duration
				Scheduler.unstable_advanceTime(duration)
				return nil
			end
			-- ROBLOX FIXME Luau: greediness means first type assignment wins, needs DCR
			Child = React.memo(Child) :: any

			local container = ReactRoblox.createRoot(Instance.new("Frame"))
			utils.act(function()
				return store._profilerStore:startProfiling()
			end)
			utils.act(function()
				return SchedulerTracing.unstable_trace(
					"mount",
					Scheduler.unstable_now(),
					function()
						return container:render(React.createElement(Parent))
					end
				)
			end)
			utils.act(function()
				return SchedulerTracing.unstable_trace(
					"update",
					Scheduler.unstable_now(),
					function()
						return container:render(React.createElement(Parent))
					end
				)
			end)
			utils.act(function()
				return store._profilerStore:stopProfiling()
			end)
			local renderFinished = false
			local function Validator(ref)
				local commitIndex, rootID = ref.commitIndex, ref.rootID
				local commitTree = store._profilerStore:profilingCache():getCommitTree({
					commitIndex = commitIndex,
					rootID = rootID,
				})
				local chartData =
					store._profilerStore:profilingCache():getFlamegraphChartData({
						commitIndex = commitIndex,
						commitTree = commitTree,
						rootID = rootID,
					})
				jestExpect(commitTree).toMatchSnapshot(
					("%s: CommitTree"):format(tostring(commitIndex - 1))
				)
				jestExpect(chartData).toMatchSnapshot(
					("%s: FlamegraphChartData"):format(tostring(commitIndex - 1))
				)
				renderFinished = true
				return nil
			end
			local rootID = store:getRoots()[1]

			for commitIndex = 1, 2 do
				renderFinished = false
				Validator({
					commitIndex = commitIndex,
					rootID = rootID,
				})
			end
			jestExpect(renderFinished).toBe(true)
		end)
	end)

	xdescribe("ranked chart", function()
		-- ROBLOX FIXME: the "type" of the children in our snap is 5, but in upstream it's 8, every matches except...
		it("should contain valid data", function()
			local Child
			local function Parent(_: {})
				Scheduler.unstable_advanceTime(10)
				return React.createElement(
					React.Fragment,
					nil,
					React.createElement(Child, { key = "first", duration = 3 }),
					React.createElement(Child, { key = "second", duration = 2 }),
					React.createElement(Child, { key = "third", duration = 0 })
				)
			end

			-- Memoize children to verify that chart doesn't include in the update.
			function Child(ref)
				local duration = ref.duration
				Scheduler.unstable_advanceTime(duration)
				return nil
			end
			-- ROBLOX FIXME Luau: greediness means first type assignment wins, needs DCR
			Child = React.memo(Child) :: any
			local container = ReactRoblox.createRoot(Instance.new("Frame"))
			utils.act(function()
				return store._profilerStore:startProfiling()
			end)

			utils.act(function()
				return SchedulerTracing.unstable_trace(
					"mount",
					Scheduler.unstable_now(),
					function()
						return container:render(React.createElement(Parent))
					end
				)
			end)

			utils.act(function()
				return SchedulerTracing.unstable_trace(
					"update",
					Scheduler.unstable_now(),
					function()
						return container:render(React.createElement(Parent))
					end
				)
			end)

			utils.act(function()
				return store._profilerStore:stopProfiling()
			end)
			local renderFinished = false
			local function Validator(ref)
				local commitIndex, rootID = ref.commitIndex, ref.rootID
				local commitTree = store._profilerStore:profilingCache():getCommitTree({
					commitIndex = commitIndex,
					rootID = rootID,
				})
				local chartData =
					store._profilerStore:profilingCache():getRankedChartData({
						commitIndex = commitIndex,
						commitTree = commitTree,
						rootID = rootID,
					})
				jestExpect(commitTree).toMatchSnapshot(
					("%s: CommitTree"):format(tostring(commitIndex - 1))
				)
				jestExpect(chartData).toMatchSnapshot(
					("%s: RankedChartData"):format(tostring(commitIndex - 1))
				)
				renderFinished = true
				return nil
			end
			local rootID = store:getRoots()[1]

			for commitIndex = 1, 2 do
				renderFinished = false
				Validator({
					commitIndex = commitIndex,
					rootID = rootID,
				})
				jestExpect(renderFinished).toBe(true)
			end
			jestExpect(renderFinished).toBe(true)
		end)
	end)
	xdescribe("interactions", function()
		it("should contain valid data", function()
			local Child
			local function Parent(_: {})
				Scheduler.unstable_advanceTime(10)
				return React.createElement(
					React.Fragment,
					nil,
					React.createElement(Child, { key = "first", duration = 3 }),
					React.createElement(Child, { key = "second", duration = 2 }),
					React.createElement(Child, { key = "third", duration = 0 })
				)
			end

			-- Memoize children to verify that chart doesn't include in the update.
			function Child(ref)
				local duration = ref.duration
				Scheduler.unstable_advanceTime(duration)
				return nil
			end
			-- ROBLOX FIXME Luau: greediness means first type assignment wins, needs DCR
			Child = React.memo(Child) :: any
			local container = ReactRoblox.createRoot(Instance.new("Frame"))
			utils.act(function()
				return store._profilerStore:startProfiling()
			end)
			utils.act(function()
				return SchedulerTracing.unstable_trace(
					"mount",
					Scheduler.unstable_now(),
					function()
						return container:render(React.createElement(Parent))
					end
				)
			end)

			utils.act(function()
				return SchedulerTracing.unstable_trace(
					"update",
					Scheduler.unstable_now(),
					function()
						return container:render(React.createElement(Parent))
					end
				)
			end)
			utils.act(function()
				return store._profilerStore:stopProfiling()
			end)
			local renderFinished = false
			local function Validator(ref)
				local _commitIndex, rootID = ref.commitIndex, ref.rootID
				local chartData =
					store._profilerStore:profilingCache():getInteractionsChartData({
						rootID = rootID,
					})
				jestExpect(chartData).toMatchSnapshot("Interactions")
				renderFinished = true
				return nil
			end
			local rootID = store:getRoots()[1]
			for commitIndex = 1, 2 do
				renderFinished = false
				Validator({
					commitIndex = commitIndex,
					rootID = rootID,
				})
				jestExpect(renderFinished).toBe(true)
			end
			jestExpect(renderFinished).toBe(true)
		end)
	end)
end)
