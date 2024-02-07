<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/profilerStore-test.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-devtools-shared/src/__tests__/profilerStore-test.js
>>>>>>> upstream-apply
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
local jest = JestGlobals.jest
local jestExpect = JestGlobals.expect
local xdescribe = JestGlobals.xdescribe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local devtoolsTypes = require("./devtools/types")
type Store = devtoolsTypes.Store

local global = _G

xdescribe("ProfilerStore", function()
	local React
<<<<<<< HEAD
	local ReactRoblox
	local LuauPolyfill
=======
	local ReactDOM
	local legacyRender
>>>>>>> upstream-apply
	local store: Store
	local utils
	local act

	beforeEach(function()
<<<<<<< HEAD
		utils = require("./utils")
		act = utils.act

		store = global.store
		store:setCollapseNodesByDefault(false)
		store:setRecordChangeDescriptions(true)

		React = require("@pkg/@jsdotlua/react")
		ReactRoblox = require("@pkg/@jsdotlua/react-roblox")
		LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")

		utils.beforeEachProfiling()
	end)

	it("should not remove profiling data when roots are unmounted", function()
		local function Child()
			return React.createElement("Frame")
		end

		local function Parent(props)
			local count = props.count

			local arr = table.create(count) :: any
			for index = 1, count do
				arr[index] = React.createElement(
					Child,
					{ key = tostring(index), duration = index }
				)
			end
			return arr
		end

		local containerA = ReactRoblox.createRoot(Instance.new("Frame"))
		local containerB = ReactRoblox.createRoot(Instance.new("Frame"))
		act(function()
			containerA:render(React.createElement(Parent, { key = "A", count = 3 }))
			containerB:render(React.createElement(Parent, { key = "B", count = 2 }))
		end)
		act(function()
			store._profilerStore:startProfiling()
		end)
		act(function()
			containerA:render(React.createElement(Parent, { key = "A", count = 4 }))
			containerB:render(React.createElement(Parent, { key = "B", count = 1 }))
		end)
		act(function()
			store._profilerStore:stopProfiling()
		end)
		local rootA = store:getRoots()[1]
		local rootB = store:getRoots()[2]
		act(function()
			containerB:render(nil)
		end)
		jestExpect(store._profilerStore:getDataForRoot(rootA)).never.toBeNull()
		act(function()
			containerA:render(nil)
		end)
		jestExpect(store._profilerStore:getDataForRoot(rootB)).never.toBeNull()
=======
		utils = require_("./utils")
		utils:beforeEachProfiling()
		legacyRender = utils.legacyRender
		store = global.store
		store.collapseNodesByDefault = false
		store.recordChangeDescriptions = true
		React = require_("react")
		ReactDOM = require_("react-dom")
	end) -- @reactVersion >= 16.9
	it("should not remove profiling data when roots are unmounted", function()
		return Promise.resolve():andThen(function()
			local function Parent(ref0)
				local count = ref0.count
				return Array.map(Array.new(count):fill(true), function(_, index)
					return React.createElement(Child, { key = index, duration = index })
				end) --[[ ROBLOX CHECK: check if 'new Array(count).fill(true)' is an Array ]]
			end
			local function Child()
				return React.createElement("div", nil, "Hi!")
			end
			local containerA = document:createElement("div")
			local containerB = document:createElement("div")
			utils:act(function()
				legacyRender(React.createElement(Parent, { key = "A", count = 3 }), containerA)
				legacyRender(React.createElement(Parent, { key = "B", count = 2 }), containerB)
			end)
			utils:act(function()
				return store.profilerStore:startProfiling()
			end)
			utils:act(function()
				legacyRender(React.createElement(Parent, { key = "A", count = 4 }), containerA)
				legacyRender(React.createElement(Parent, { key = "B", count = 1 }), containerB)
			end)
			utils:act(function()
				return store.profilerStore:stopProfiling()
			end)
			local rootA = store.roots[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			local rootB = store.roots[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			utils:act(function()
				return ReactDOM:unmountComponentAtNode(containerB)
			end)
			expect(store.profilerStore:getDataForRoot(rootA))["not"].toBeNull()
			utils:act(function()
				return ReactDOM:unmountComponentAtNode(containerA)
			end)
			expect(store.profilerStore:getDataForRoot(rootB))["not"].toBeNull()
		end)
	end) -- @reactVersion >= 16.9
	it("should not allow new/saved profiling data to be set while profiling is in progress", function()
		utils:act(function()
			return store.profilerStore:startProfiling()
		end)
		local fauxProfilingData = { dataForRoots = Map.new() }
		spyOn(console, "warn")
		store.profilerStore.profilingData = fauxProfilingData
		expect(store.profilerStore.profilingData)["not"].toBe(fauxProfilingData)
		expect(console.warn).toHaveBeenCalledTimes(1)
		expect(console.warn).toHaveBeenCalledWith("Profiling data cannot be updated while profiling is in progress.")
		utils:act(function()
			return store.profilerStore:stopProfiling()
		end)
		store.profilerStore.profilingData = fauxProfilingData
		expect(store.profilerStore.profilingData).toBe(fauxProfilingData)
	end) -- @reactVersion >= 16.9
	-- This test covers current broken behavior (arguably) with the synthetic event system.
	it("should filter empty commits", function()
		local inputRef = React.createRef()
		local function ControlledInput()
			local name, setName = table.unpack(React.useState("foo"), 1, 2)
			local function handleChange(event)
				return setName(event.target.value)
			end
			return React.createElement("input", { ref = inputRef, value = name, onChange = handleChange })
		end
		local container = document:createElement("div") -- This element has to be in the <body> for the event system to work.
		document.body:appendChild(container) -- It's important that this test uses legacy sync mode.
		-- The root API does not trigger this particular failing case.
		legacyRender(React.createElement(ControlledInput, nil), container)
		utils:act(function()
			return store.profilerStore:startProfiling()
		end) -- Sets a value in a way that React doesn't see,
		-- so that a subsequent "change" event will trigger the event handler.
		local setUntrackedValue = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, "value").set
		local target = inputRef.current
		setUntrackedValue(target, "bar")
		target:dispatchEvent(Event.new("input", { bubbles = true, cancelable = true }))
		expect(target.value).toBe("bar")
		utils:act(function()
			return store.profilerStore:stopProfiling()
		end) -- Only one commit should have been recorded (in response to the "change" event).
		local root = store.roots[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local data = store.profilerStore:getDataForRoot(root)
		expect(data.commitData).toHaveLength(1)
		expect(data.operations).toHaveLength(1)
	end) -- @reactVersion >= 16.9
	it("should filter empty commits alt", function()
		local commitCount = 0
		local inputRef = React.createRef()
		local function Example()
			local setTouched = React.useState(false)[2]
			local function handleBlur()
				setTouched(true)
			end
			require_("scheduler"):unstable_advanceTime(1)
			React.useLayoutEffect(function()
				commitCount += 1
			end)
			return React.createElement("input", { ref = inputRef, onBlur = handleBlur })
		end
		local container = document:createElement("div") -- This element has to be in the <body> for the event system to work.
		document.body:appendChild(container) -- It's important that this test uses legacy sync mode.
		-- The root API does not trigger this particular failing case.
		legacyRender(React.createElement(Example, nil), container)
		expect(commitCount).toBe(1)
		commitCount = 0
		utils:act(function()
			return store.profilerStore:startProfiling()
		end) -- Focus and blur.
		local target = inputRef.current
		target:focus()
		target:blur()
		target:focus()
		target:blur()
		expect(commitCount).toBe(1)
		utils:act(function()
			return store.profilerStore:stopProfiling()
		end) -- Only one commit should have been recorded (in response to the "change" event).
		local root = store.roots[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local data = store.profilerStore:getDataForRoot(root)
		expect(data.commitData).toHaveLength(1)
		expect(data.operations).toHaveLength(1)
	end) -- @reactVersion >= 16.9
	it("should throw if component filters are modified while profiling", function()
		utils:act(function()
			return store.profilerStore:startProfiling()
		end)
		expect(function()
			utils:act(function()
				local ElementTypeHostComponent = require_("react-devtools-shared/src/types").ElementTypeHostComponent
				store.componentFilters = { utils:createElementTypeFilter(ElementTypeHostComponent) }
			end)
		end).toThrow("Cannot modify filter preferences while profiling")
	end) -- @reactVersion >= 16.9
	it("should not throw if state contains a property hasOwnProperty ", function()
		local setStateCallback
		local function ControlledInput()
			local state, setState = table.unpack(React.useState({ hasOwnProperty = true }), 1, 2)
			setStateCallback = setState
			return state.hasOwnProperty
		end
		local container = document:createElement("div") -- This element has to be in the <body> for the event system to work.
		document.body:appendChild(container) -- It's important that this test uses legacy sync mode.
		-- The root API does not trigger this particular failing case.
		legacyRender(React.createElement(ControlledInput, nil), container)
		utils:act(function()
			return store.profilerStore:startProfiling()
		end)
		utils:act(function()
			return setStateCallback({ hasOwnProperty = false })
		end)
		utils:act(function()
			return store.profilerStore:stopProfiling()
		end) -- Only one commit should have been recorded (in response to the "change" event).
		local root = store.roots[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local data = store.profilerStore:getDataForRoot(root)
		expect(data.commitData).toHaveLength(1)
		expect(data.operations).toHaveLength(1)
	end) -- @reactVersion >= 18.0
	it("should not throw while initializing context values for Fibers within a not-yet-mounted subtree", function()
		local promise = Promise.new(function(resolve) end)
		local function SuspendingView()
			error(promise)
		end
		local function App()
			return React.createElement(
				React.Suspense,
				{ fallback = "Fallback" },
				React.createElement(SuspendingView, nil)
			)
		end
		local container = document:createElement("div")
		utils:act(function()
			return legacyRender(React.createElement(App, nil), container)
		end)
		utils:act(function()
			return store.profilerStore:startProfiling()
		end)
>>>>>>> upstream-apply
	end)
	it(
		"should not allow new/saved profiling data to be set while profiling is in progress",
		function()
			act(function()
				return store._profilerStore:startProfiling()
			end)
			local fauxProfilingData = {
				-- ROLBLOX deviation START: upstream doesn't typecheck, needs mandatory imported field
				dataForRoots = LuauPolyfill.Map.new(),
				imported = false,
				-- ROBLOX deviation END
			}

			-- ROBLOX deviation: spyOn console.warn workaround
			local mockWarn = jest.fn().mockName("console.warn")
			LuauPolyfill.console.warn = mockWarn

			store._profilerStore:profilingData(fauxProfilingData)
			jestExpect(store._profilerStore.profilingData).never.toBe(fauxProfilingData)
			jestExpect(mockWarn).toHaveBeenCalledTimes(1)
			jestExpect(mockWarn).toHaveBeenCalledWith(
				"Profiling data cannot be updated while profiling is in progress."
			)

			act(function()
				return store._profilerStore:stopProfiling()
			end)

			store._profilerStore:profilingData(fauxProfilingData)
			jestExpect(store._profilerStore:profilingData()).toBe(fauxProfilingData)
		end
	)

	--[[ ROBLOX note: This seems to test edges that aren't present in our environment
		-- This test covers current broken behavior (arguably) with the synthetic event system.
		it("should filter empty commits", function()
			local inputRef = React.createRef()
			local function ControlledInput()
				local name, setName = React.useState("foo")
				local function handleChange(event)
					return setName(event.target.value)
				end
				return React.createElement(
					"input",
					{ ref = inputRef, value = name, onChange = handleChange }
				)
			end

			local container = Instance.new("Frame") -- This element has to be in the <body> for the event system to work.
			-document.body:appendChild(container) -- It's important that this test uses legacy sync mode.
			-- The root API does not trigger this particular failing case.
			ReactRoblox.createRoot(container):render(React.createElement(ControlledInput, nil))
			act(function()
				return store._profilerStore:startProfiling()
			end)

			-- Sets a value in a way that React doesn't see,
			-- so that a subsequent "change" event will trigger the event handler.
			local setUntrackedValue = Object.getOwnPropertyDescriptor(
				HTMLInputElement.prototype,
				"value"
			).set

			local target = inputRef.current
			setUntrackedValue(target, "bar")
			target:dispatchEvent(
				Event.new("input", { bubbles = true, cancelable = true })
			)
			jestExpect(target.value).toBe("bar")

			act(function()
				return store._profilerStore:stopProfiling()
			end)

			-- Only one commit should have been recorded (in response to the "change" event).
			local root = store:getRoots()[1]
			local data = store._profilerStore:getDataForRoot(root)
			jestExpect(data.commitData).toHaveLength(1)
			jestExpect(data.operations).toHaveLength(1)
		end)
		--]]
end)
