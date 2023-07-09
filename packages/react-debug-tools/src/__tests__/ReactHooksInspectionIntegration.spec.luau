-- upstream: https://github.com/facebook/react/blob/v17.0.2/packages/react-debug-tools/src/__tests__/ReactHooksInspectionIntegration-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 * @jest-environment node
 ]]
local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
-- deviation START: not needed
-- local Boolean = LuauPolyfill.Boolean
-- deviation END
-- deviation START: import from dev dependencies
-- local Promise = require(Packages.Promise)
local Promise = require(Packages.Dev.Promise)
-- deviation END
local JestGlobals = require(Packages.Dev.JestGlobals)
local beforeEach = JestGlobals.beforeEach
local describe = JestGlobals.describe
local expect = JestGlobals.expect
local it = JestGlobals.it
local jest = JestGlobals.jest
-- deviation START: add additional imports
local String = LuauPolyfill.String
-- deviation END

local React
local ReactTestRenderer
local Scheduler
local ReactDebugTools
local act
describe("ReactHooksInspectionIntegration", function()
	beforeEach(function()
		jest.resetModules()
		-- deviation START: fix requires
		-- React = require_("react")
		-- ReactTestRenderer = require_("react-test-renderer")
		-- Scheduler = require_("scheduler")
		ReactTestRenderer = require(Packages.Dev.ReactTestRenderer)
		Scheduler = require(Packages.Dev.Scheduler)
		React = require(Packages.Dev.React)
		-- deviation END
		act = ReactTestRenderer.unstable_concurrentAct
		-- deviation START: fix requires
		-- ReactDebugTools = require_("react-debug-tools")
		ReactDebugTools = require(Packages.ReactDebugTools)
		-- deviation END
	end)
	it("should inspect the current state of useState hooks", function()
		local useState = React.useState
		local function Foo(props)
			-- deviation START: useState returns 2 values
			-- local state1, setState1 = table.unpack(useState("hello"), 1, 2)
			-- local state2, setState2 = table.unpack(useState("world"), 1, 2)
			local state1, setState1 = useState("hello")
			local state2, setState2 = useState("world")
			-- deviation END
			return React.createElement(
				-- deviation START: use Frame instead
				-- "div",
				"Frame",
				-- deviation END
				{ onMouseDown = setState1, onMouseUp = setState2 },
				state1,
				" ",
				state2
			)
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, { prop = "prop" }))
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				value = "hello",
				subHooks = {},
			},
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				name = "State",
				value = "world",
				subHooks = {},
			},
		})
		local setStateA, setStateB
		do
			-- deviation START: use Frame instead
			-- local ref = renderer.root:findByType("div").props
			local ref = renderer.root:findByType("Frame").props
			-- deviation END
			setStateA, setStateB = ref.onMouseDown, ref.onMouseUp
		end
		act(function()
			return setStateA("Hi")
		end)
		childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				value = "Hi",
				subHooks = {},
			},
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				name = "State",
				value = "world",
				subHooks = {},
			},
		})
		act(function()
			return setStateB("world!")
		end)
		childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				value = "Hi",
				subHooks = {},
			},
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				name = "State",
				value = "world!",
				subHooks = {},
			},
		})
	end)
	it("should inspect the current state of all stateful hooks", function()
		local outsideRef = React.createRef()
		local function effect() end
		local function Foo(props)
			-- deviation START: useState and useReducer return 2 values
			-- local state1, setState = table.unpack(React.useState("a"), 1, 2)
			-- local state2, dispatch = table.unpack(
			-- 	React.useReducer(function(s, a)
			-- 		return a.value
			-- 	end, "b"),
			-- 	1,
			-- 	2
			-- )
			local state1, setState = React.useState("a")
			local state2, dispatch = React.useReducer(function(s, a)
				return a.value
			end, "b")
			-- deviation END
			local ref = React.useRef("c")
			React.useLayoutEffect(effect)
			React.useEffect(effect)
			React.useImperativeHandle(outsideRef, function()
				-- Return a function so that jest treats them as non-equal.
				return function() end
			end, {})
			React.useMemo(function()
				-- deviation START: use string concatenation
				-- return state1 + state2
				return state1 .. state2
				-- deviation END
			end, { state1 })
			local function update()
				act(function()
					setState("A")
				end)
				act(function()
					dispatch({ value = "B" })
				end)
				ref.current = "C"
			end
			local memoizedUpdate = React.useCallback(update, {})
			return React.createElement(
				-- deviation START: use Frame instead
				-- "div",
				"Frame",
				-- deviation END
				{ onClick = memoizedUpdate },
				state1,
				" ",
				state2
			)
		end
		local renderer
		act(function()
			renderer = ReactTestRenderer.create(React.createElement(Foo, { prop = "prop" }))
		end)
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use Frame instead
		-- local updateStates = renderer.root:findByType("div").props.onClick
		local updateStates = renderer.root:findByType("Frame").props.onClick
		-- deviation END
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				-- deviation START: tell Luau to type this field loosely
				value = "a" :: any,
				-- deviation END
				subHooks = {},
			},
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				name = "Reducer",
				value = "b",
				subHooks = {},
			},
			-- deviation START: adjust for 1-based indexing
			-- { isStateEditable = false, id = 2, name = "Ref", value = "c", subHooks = {} },
			{ isStateEditable = false, id = 3, name = "Ref", value = "c", subHooks = {} },
			-- deviation END
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 3,
				id = 4,
				-- deviation END
				name = "LayoutEffect",
				value = effect,
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 4,
				id = 5,
				-- deviation END
				name = "Effect",
				value = effect,
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 5,
				id = 6,
				-- deviation END
				name = "ImperativeHandle",
				value = outsideRef.current,
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 6,
				id = 7,
				-- deviation END
				name = "Memo",
				-- deviation START: useMemo wraps a value
				-- value = "ab",
				value = { "ab" },
				-- deviation END
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 7,
				id = 8,
				-- deviation END
				name = "Callback",
				value = updateStates,
				subHooks = {},
			},
		})
		updateStates()
		childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				-- deviation START: tell Luau to type this field loosely
				value = "A" :: any,
				-- deviation END
				subHooks = {},
			},
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				name = "Reducer",
				value = "B",
				subHooks = {},
			},
			-- deviation START: adjust for 1-based indexing
			-- { isStateEditable = false, id = 2, name = "Ref", value = "C", subHooks = {} },
			{ isStateEditable = false, id = 3, name = "Ref", value = "C", subHooks = {} },
			-- deviation END
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 3,
				id = 4,
				-- deviation END
				name = "LayoutEffect",
				value = effect,
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 4,
				id = 5,
				-- deviation END
				name = "Effect",
				value = effect,
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 5,
				id = 6,
				-- deviation END
				name = "ImperativeHandle",
				value = outsideRef.current,
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 6,
				id = 7,
				-- deviation END
				name = "Memo",
				-- deviation START: useMemo wraps a value
				-- value = "Ab",
				value = { "Ab" },
				-- deviation END
				subHooks = {},
			},
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 7,
				id = 8,
				-- deviation END
				name = "Callback",
				value = updateStates,
				subHooks = {},
			},
		})
	end)
	it("should inspect the value of the current provider in useContext", function()
		local MyContext = React.createContext("default")
		local function Foo(props)
			local value = React.useContext(MyContext)
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil, value)
			return React.createElement("Frame", nil, value)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(
			React.createElement(
				MyContext.Provider,
				{ value = "contextual" },
				React.createElement(Foo, { prop = "prop" })
			)
		)
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: adjust for 1-based indexing
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = false,
				id = nil,
				name = "Context",
				value = "contextual",
				subHooks = {},
			},
		})
	end)
	it("should inspect forwardRef", function()
		local function obj() end
		local Foo = React.forwardRef(function(props, ref)
			React.useImperativeHandle(ref, function()
				return obj
			end)
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil)
			return React.createElement("Frame", nil)
			-- deviation END
		end)
		local ref = React.createRef()
		local renderer = ReactTestRenderer.create(React.createElement(Foo, { ref = ref }))
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = false,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "ImperativeHandle",
				value = obj,
				subHooks = {},
			},
		})
	end)
	it("should inspect memo", function()
		local function InnerFoo(props)
			-- deviation START: useState returns 2 values
			-- local value = React.useState("hello")[1]
			local value = React.useState("hello")
			-- deviation END
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil, value)
			return React.createElement("Frame", nil, value)
			-- deviation END
		end
		local Foo = React.memo(InnerFoo)
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil)) -- TODO: Test renderer findByType is broken for memo. Have to search for the inner.
		local childFiber = renderer.root:findByType(InnerFoo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				value = "hello",
				subHooks = {},
			},
		})
	end)
	it("should inspect custom hooks", function()
		local function useCustom()
			-- deviation START: useState returns 2 values
			-- local value = React.useState("hello")[1]
			local value = React.useState("hello")
			-- deviation END
			return value
		end
		local function Foo(props)
			local value = useCustom()
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil, value)
			return React.createElement("Frame", nil, value)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = false,
				id = nil,
				name = "Custom",
				value = nil,
				subHooks = {
					{
						isStateEditable = true,
						-- deviation START: adjust for 1-based indexing
						-- id = 0,
						id = 1,
						-- deviation END
						name = "State",
						value = "hello",
						subHooks = {},
					},
				},
			},
		})
	end) -- @gate experimental
	-- deviation START: unstable_useTransition is not implemented
	-- it("should support composite useTransition hook", function()
	it.skip("should support composite useTransition hook", function()
		-- deviation END
		local function Foo(props)
			-- deviation START: not supported
			-- React.unstable_useTransition()
			-- deviation END
			local memoizedValue = React.useMemo(function()
				return "hello"
			end, {})
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil, memoizedValue)
			return React.createElement("Frame", nil, memoizedValue)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				isStateEditable = false,
				name = "Transition",
				-- deviation START: tell Luau to type this field loosely
				value = nil :: any,
				-- deviation END
				subHooks = {},
			},
			{
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				isStateEditable = false,
				name = "Memo",
				value = "hello",
				subHooks = {},
			},
		})
	end) -- @gate experimental
	-- deviation START: unstable_useDeferredValue not implemented
	-- it("should support composite useDeferredValue hook", function()
	it.skip("should support composite useDeferredValue hook", function()
		-- deviation END
		local function Foo(props)
			-- deviation START: not implemented
			-- React.unstable_useDeferredValue("abc", { timeoutMs = 500 })
			-- deviation END
			local state = React.useState(function()
				return "hello"
				-- deviation START: useState returns 2 values
				-- end, {})[1]
			end, {})
			-- deviation END
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil, state)
			return React.createElement("Frame", nil, state)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				isStateEditable = false,
				name = "DeferredValue",
				value = "abc",
				subHooks = {},
			},
			{
				-- deviation START: adjust for 1-based indexing
				-- id = 1,
				id = 2,
				-- deviation END
				isStateEditable = true,
				name = "State",
				value = "hello",
				subHooks = {},
			},
		})
	end) -- @gate experimental
	-- deviation START: unstable_useOpaqueIdentifier not implemented
	-- it("should support composite useOpaqueIdentifier hook", function()
	it.skip("should support composite useOpaqueIdentifier hook", function()
		-- deviation END
		local function Foo(props)
			-- deviation START: not implemented
			-- local id = React.unstable_useOpaqueIdentifier()
			local id = nil
			-- deviation END
			local state = React.useState(function()
				return "hello"
				-- deviation START: useState returns 2 values
				-- end, {})[1]
			end, {})
			-- deviation END
			-- deviation START: use Frame instead
			-- return React.createElement("div", { id = id }, state)
			return React.createElement("Frame", { id = id }, state)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		-- deviation START: fix length implementation
		-- expect(tree.length).toEqual(2)
		expect(#tree).toEqual(2)
		-- deviation END
		expect(tree[
			1 --[[ adapatation: added 1 to array index ]]
		].id).toEqual(0)
		expect(tree[
			1 --[[ adapatation: added 1 to array index ]]
		].isStateEditable).toEqual(false)
		expect(tree[
			1 --[[ adapatation: added 1 to array index ]]
		].name).toEqual("OpaqueIdentifier")
		-- deviation START: use String.startsWith
		-- expect((tostring(tree[
		-- 	1 --[[ adapatation: added 1 to array index ]]
		-- ].value) .. ""):startsWith("c_")).toBe(true)
		expect(String.startsWith(tree[1].value :: string .. "", "c_")).toBe(true)
		-- deviation END
		expect(tree[
			2 --[[ adapatation: added 1 to array index ]]
		]).toEqual({
			-- deviation START: adjust for 1-based indexing
			-- id = 1,
			id = 2,
			-- deviation END
			isStateEditable = true,
			name = "State",
			value = "hello",
			subHooks = {},
		})
	end) -- @gate experimental
	-- deviation START: unstable_useOpaqueIdentifier not implemented
	-- it("should support composite useOpaqueIdentifier hook in concurrent mode", function()
	it.skip("should support composite useOpaqueIdentifier hook in concurrent mode", function()
		-- deviation END
		local function Foo(props)
			-- FIXME: type this correctly when this is supported
			local id = (React :: any).unstable_useOpaqueIdentifier()
			local state = React.useState(function()
				return "hello"
				-- deviation START: useState returns 2 values
				-- end, {})[1]
			end, {})
			-- deviation END
			-- deviation START: use Frame instead
			-- return React.createElement("div", { id = id }, state)
			return React.createElement("Frame", { id = id }, state)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil), { unstable_isConcurrent = true })
		expect(Scheduler).toFlushWithoutYielding()
		local childFiber = renderer.root:findByType(Foo):_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		-- deviation START: fix length conversion
		-- expect(tree.length).toEqual(2)
		expect(#tree).toEqual(2)
		-- deviation END
		expect(tree[
			1 --[[ adapatation: added 1 to array index ]]
		].id).toEqual(0)
		expect(tree[
			1 --[[ adapatation: added 1 to array index ]]
		].isStateEditable).toEqual(false)
		expect(tree[
			1 --[[ adapatation: added 1 to array index ]]
		].name).toEqual("OpaqueIdentifier")
		-- deviation START: use String.startsWith
		-- expect((tostring(tree[
		-- 	1 --[[ adapatation: added 1 to array index ]]
		-- ].value) .. ""):startsWith("c_")).toBe(true)
		expect(String.startsWith(tree[1].value :: string .. "", "c_")).toBe(true)
		-- deviation END
		expect(tree[
			2 --[[ adapatation: added 1 to array index ]]
		]).toEqual({
			-- deviation START: adjust for 1-based indexing
			-- id = 1,
			id = 2,
			-- deviation END
			isStateEditable = true,
			name = "State",
			value = "hello",
			subHooks = {},
		})
	end)
	describe("useDebugValue", function()
		it("should support inspectable values for multiple custom hooks", function()
			local function useLabeledValue(label)
				-- deviation START: useState returns 2 values
				-- local value = React.useState(label)[1]
				local value = React.useState(label)
				-- deviation END
				React.useDebugValue(("custom label %s"):format(tostring(label)))
				return value
			end
			local function useAnonymous(label)
				-- deviation START: useState returns 2 values
				-- local value = React.useState(label)[1]
				local value = React.useState(label)
				-- deviation END
				return value
			end
			local function Example()
				useLabeledValue("a")
				React.useState("b")
				useAnonymous("c")
				useLabeledValue("d")
				return nil
			end
			local renderer = ReactTestRenderer.create(React.createElement(Example, nil))
			local childFiber = renderer.root:findByType(Example):_currentFiber()
			-- deviation START: use dot notation
			-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
			local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
			-- deviation END
			expect(tree).toEqual({
				{
					isStateEditable = false,
					-- deviation START: tell Luau to type this field loosely
					id = nil :: number?,
					-- deviation END
					name = "LabeledValue",
					-- deviation START: use _G.__DEV__ and cast
					-- value = if Boolean.toJSBoolean(__DEV__)
					-- 	then "custom label a"
					-- 	else nil,
					value = (if _G.__DEV__ then "custom label a" else nil) :: any,
					-- deviation END
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 0,
							id = 1,
							-- deviation END
							name = "State",
							value = "a",
							subHooks = {},
						},
					},
				},
				{
					isStateEditable = true,
					-- deviation START: adjust for 1-based indexing
					-- id = 1,
					id = 2,
					-- deviation END
					name = "State",
					value = "b",
					subHooks = {},
				},
				{
					isStateEditable = false,
					id = nil,
					name = "Anonymous",
					value = nil,
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 2,
							id = 3,
							-- deviation END
							name = "State",
							value = "c",
							subHooks = {},
						},
					},
				},
				{
					isStateEditable = false,
					id = nil,
					name = "LabeledValue",
					-- deviation START: use _G.__DEV__
					-- value = if Boolean.toJSBoolean(__DEV__)
					value = if _G.__DEV__
						-- deviation END
						then "custom label d"
						else nil,
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 3,
							id = 4,
							-- deviation END
							name = "State",
							value = "d",
							subHooks = {},
						},
					},
				},
			})
		end)
		it("should support inspectable values for nested custom hooks", function()
			local function useInner()
				React.useDebugValue("inner")
				React.useState(0)
			end
			local function useOuter()
				React.useDebugValue("outer")
				useInner()
			end
			local function Example()
				useOuter()
				return nil
			end
			local renderer = ReactTestRenderer.create(React.createElement(Example, nil))
			local childFiber = renderer.root:findByType(Example):_currentFiber()
			-- deviation START: use dot notation
			-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
			local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
			-- deviation END
			expect(tree).toEqual({
				{
					isStateEditable = false,
					id = nil,
					name = "Outer",
					-- deviation START: use _G.__DEV__
					-- value = if Boolean.toJSBoolean(__DEV__) then "outer" else nil,
					value = if _G.__DEV__ then "outer" else nil,
					-- deviation END
					subHooks = {
						{
							isStateEditable = false,
							id = nil,
							name = "Inner",
							-- deviation START: use _G.__DEV__
							-- value = if Boolean.toJSBoolean(__DEV__) then "inner" else nil,
							value = if _G.__DEV__ then "inner" else nil,
							-- deviation END
							subHooks = {
								{
									isStateEditable = true,
									-- deviation START: adjust for 1-based indexing
									-- id = 0,
									id = 1,
									-- deviation END
									name = "State",
									value = 0,
									subHooks = {},
								},
							},
						},
					},
				},
			})
		end)
		it("should support multiple inspectable values per custom hooks", function()
			local function useMultiLabelCustom()
				React.useDebugValue("one")
				React.useDebugValue("two")
				React.useDebugValue("three")
				React.useState(0)
			end
			local function useSingleLabelCustom(value)
				React.useDebugValue(("single %s"):format(tostring(value)))
				React.useState(0)
			end
			local function Example()
				useSingleLabelCustom("one")
				useMultiLabelCustom()
				useSingleLabelCustom("two")
				return nil
			end
			local renderer = ReactTestRenderer.create(React.createElement(Example, nil))
			local childFiber = renderer.root:findByType(Example):_currentFiber()
			-- deviation START: adjust for 1-based indexing
			-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
			local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
			-- deviation END
			expect(tree).toEqual({
				{
					isStateEditable = false,
					-- deviation START: Luau doesn't support mixed arrays
					-- id = nil,
					id = nil :: number | nil,
					-- deviation END
					name = "SingleLabelCustom",
					-- deviation START: use _G.__DEV__
					-- value = if Boolean.toJSBoolean(__DEV__) then "single one" else nil,
					value = (if _G.__DEV__ then "single one" else nil) :: any,
					-- deviation END
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 0,
							id = 1,
							-- deviation END
							name = "State",
							value = 0,
							subHooks = {},
						},
					},
				},
				{
					isStateEditable = false,
					id = nil,
					name = "MultiLabelCustom",
					-- deviation START: use _G.__DEV__
					-- value = if Boolean.toJSBoolean(__DEV__)
					value = if _G.__DEV__
						-- deviation END
						then { "one", "two", "three" }
						else nil,
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 1,
							id = 2,
							-- deviation END
							name = "State",
							value = 0,
							subHooks = {},
						},
					},
				},
				{
					isStateEditable = false,
					id = nil,
					name = "SingleLabelCustom",
					-- deviation START: use _G.__DEV__
					-- value = if Boolean.toJSBoolean(__DEV__) then "single two" else nil,
					value = if _G.__DEV__ then "single two" else nil,
					-- deviation END
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 2,
							id = 3,
							-- deviation END
							name = "State",
							value = 0,
							subHooks = {},
						},
					},
				},
			})
		end)
		it("should ignore useDebugValue() made outside of a custom hook", function()
			local function Example()
				React.useDebugValue("this is invalid")
				return nil
			end
			local renderer = ReactTestRenderer.create(React.createElement(Example, nil))
			local childFiber = renderer.root:findByType(Example):_currentFiber()
			-- deviation START: use dot notation
			-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
			local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
			-- deviation END
			expect(tree).toHaveLength(0)
		end)
		it("should support an optional formatter function param", function()
			local function useCustom()
				React.useDebugValue({ bar = 123 }, function(object)
					return ("bar:%s"):format(tostring(object.bar))
				end)
				React.useState(0)
			end
			local function Example()
				useCustom()
				return nil
			end
			local renderer = ReactTestRenderer.create(React.createElement(Example, nil))
			local childFiber = renderer.root:findByType(Example):_currentFiber()
			-- deviation START: use dot notation
			-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
			local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
			-- deviation END
			expect(tree).toEqual({
				{
					isStateEditable = false,
					id = nil,
					name = "Custom",
					-- deviation START: use _G.__DEV__
					-- value = if Boolean.toJSBoolean(__DEV__) then "bar:123" else nil,
					value = if _G.__DEV__ then "bar:123" else nil,
					-- deviation END
					subHooks = {
						{
							isStateEditable = true,
							-- deviation START: adjust for 1-based indexing
							-- id = 0,
							id = 1,
							-- deviation END
							name = "State",
							subHooks = {},
							value = 0,
						},
					},
				},
			})
		end)
	end)
	-- deviation START: defaultProps not supported for function components yet
	-- it("should support defaultProps and lazy", function()
	it.skip("should support defaultProps and lazy", function()
		-- deviation END
		return Promise.resolve():andThen(function()
			-- deviation START: defaultProps not supported for function components yet
			-- local Suspense = React.Suspense
			-- local function Foo(props)
			-- 	local value = React.useState(props.defaultValue:substr(0, 3))[1]
			-- 	return React.createElement("div", nil, value)
			-- end
			-- Foo.defaultProps = { defaultValue = "default" }
			-- local function fakeImport(result)
			-- 	return Promise.resolve():andThen(function()
			-- 		return { default = result }
			-- 	end)
			-- end
			-- local LazyFoo = React.lazy(function()
			-- 	return fakeImport(Foo)
			-- end)
			-- local renderer = ReactTestRenderer.create(
			-- 	React.createElement(
			-- 		Suspense,
			-- 		{ fallback = "Loading..." },
			-- 		React.createElement(LazyFoo, nil)
			-- 	)
			-- )
			-- LazyFoo:expect()
			-- Scheduler:unstable_flushAll()
			-- local childFiber = renderer.root:_currentFiber()
			-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
			-- expect(tree).toEqual({
			-- 	{
			-- 		isStateEditable = true,
			-- 		id = 0,
			-- 		name = "State",
			-- 		value = "def",
			-- 		subHooks = {},
			-- 	},
			-- })
			-- deviation END
		end)
	end)
	it("should support an injected dispatcher", function()
		local function Foo(props)
			-- deviation START: useState returns 2 values
			-- local state = React.useState("hello world")[1]
			local state = React.useState("hello world")
			-- deviation END
			-- deviation START: use Frame instead
			-- return React.createElement("div", nil, state)
			return React.createElement("Frame", nil, state)
			-- deviation END
		end
		local initial = {}
		local current = initial
		local getterCalls = 0
		local setterCalls = {}
		-- deviation START: implement getter and setter
		-- local FakeDispatcherRef = {
		-- 	current = function(self)
		-- 		getterCalls += 1
		-- 		return current
		-- 	end,
		-- 	current = function(self, value)
		-- 		table.insert(setterCalls, value) --[[ CHECK: check if 'setterCalls' is an Array ]]
		-- 		current = value
		-- 	end,
		-- }
		local FakeDispatcherRef = setmetatable({
			__getters = {
				current = function(self)
					getterCalls += 1
					return current
				end,
			},
			__setters = {
				current = function(self, value)
					table.insert(setterCalls, value)
					current = value
				end,
			},
		}, {
			__index = function(self, key)
				if typeof(self.__getters[key]) == "function" then
					return self.__getters[key](self)
				else
					return nil
				end
			end,
			__newindex = function(self, key, value)
				if typeof(self.__setters[key]) == "function" then
					return self.__setters[key](self, value)
				else
					return nil
				end
			end,
		}) :: any
		-- deviation END
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
		local childFiber = renderer.root:_currentFiber()
		expect(function()
			-- deviation START: use dot notation
			-- ReactDebugTools:inspectHooksOfFiber(childFiber, FakeDispatcherRef)
			ReactDebugTools.inspectHooksOfFiber(childFiber, FakeDispatcherRef)
			-- deviation END
		end).toThrow(
			"Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for"
				.. " one of the following reasons:\n"
				.. "1. You might have mismatching versions of React and the renderer (such as React DOM)\n"
				.. "2. You might be breaking the Rules of Hooks\n"
				.. "3. You might have more than one copy of React in the same app\n"
				.. "See https://reactjs.org/link/invalid-hook-call for tips about how to debug and fix this problem."
		)
		expect(getterCalls).toBe(1)
		expect(setterCalls).toHaveLength(2)
		expect(setterCalls[
			1 --[[ adapatation: added 1 to array index ]]
			-- deviation START: use never instead of not
			-- ])["not"].toBe(initial)
		]).never.toBe(initial)
		-- deviation END
		expect(setterCalls[
			2 --[[ adapatation: added 1 to array index ]]
		]).toBe(initial)
	end) -- This test case is based on an open source bug report:
	-- facebookincubator/redux-react-hook/issues/34#issuecomment-466693787
	it("should properly advance the current hook for useContext", function()
		local MyContext = React.createContext(1)
		local incrementCount
		local function Foo(props)
			local context = React.useContext(MyContext)
			-- deviation START: useState returns 2 values
			-- local data, setData = table.unpack(React.useState({ count = context }), 1, 2)
			local data, setData = React.useState({ count = context })
			-- deviation END
			incrementCount = function()
				return setData(function(ref0)
					local count = ref0.count
					return { count = count + 1 }
				end)
			end
			-- deviation START: use FRame instead
			-- return React.createElement("div", nil, "count: ", data.count)
			return React.createElement("Frame", nil, "count: ", data.count)
			-- deviation END
		end
		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
		expect(renderer:toJSON()).toEqual({
			-- deviation START: use Frame instead
			-- type = "div",
			type = "Frame",
			-- deviation END
			props = {},
			children = { "count: ", "1" },
		})
		act(incrementCount)
		expect(renderer:toJSON()).toEqual({
			-- deviation START: use Frame instead
			-- type = "div",
			type = "Frame",
			-- deviation END
			props = {},
			children = { "count: ", "2" },
		})
		local childFiber = renderer.root:_currentFiber()
		-- deviation START: use dot notation
		-- local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
		local tree = ReactDebugTools.inspectHooksOfFiber(childFiber)
		-- deviation END
		expect(tree).toEqual({
			{
				isStateEditable = false,
				-- deviation START: Luau doesn't support mixed arrays
				-- id = nil,
				id = nil :: number | nil,
				-- deviation END
				name = "Context",
				-- deviation START: Luau doesn't support mixed arrays
				-- value = 1,
				value = 1 :: any,
				-- deviation END
				subHooks = {},
			},
			{
				isStateEditable = true,
				-- deviation START: adjust for 1-based indexing
				-- id = 0,
				id = 1,
				-- deviation END
				name = "State",
				value = { count = 2 },
				subHooks = {},
			},
		})
	end)
	-- deviation START: no experimental features
	-- if Boolean.toJSBoolean(__EXPERIMENTAL__) then
	-- 	it("should support composite useMutableSource hook", function()
	-- 		local mutableSource = React.unstable_createMutableSource({}, function()
	-- 			return 1
	-- 		end)
	-- 		local function Foo(props)
	-- 			React.unstable_useMutableSource(mutableSource, function()
	-- 				return "snapshot"
	-- 			end, function() end)
	-- 			React.useMemo(function()
	-- 				return "memo"
	-- 			end, {})
	-- 			return React.createElement("div", nil)
	-- 		end
	-- 		local renderer = ReactTestRenderer.create(React.createElement(Foo, nil))
	-- 		local childFiber = renderer.root:findByType(Foo):_currentFiber()
	-- 		local tree = ReactDebugTools:inspectHooksOfFiber(childFiber)
	-- 		expect(tree).toEqual({
	-- 			{
	-- 				id = 0,
	-- 				isStateEditable = false,
	-- 				name = "MutableSource",
	-- 				value = "snapshot",
	-- 				subHooks = {},
	-- 			},
	-- 			{
	-- 				id = 1,
	-- 				isStateEditable = false,
	-- 				name = "Memo",
	-- 				value = "memo",
	-- 				subHooks = {},
	-- 			},
	-- 		})
	-- 	end)
	-- end
	-- deviation END
end)
