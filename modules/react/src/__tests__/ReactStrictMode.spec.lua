<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/d13f5b9538e48f74f7c571ef3cde652ca887cca0/packages/react/src/__tests__/ReactStrictMode-test.js
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @emails react-core
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react/src/__tests__/ReactStrictMode-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local console = LuauPolyfill.console
type Object = LuauPolyfill.Object
>>>>>>> upstream-apply

local Packages = script.Parent.Parent.Parent
local React
<<<<<<< HEAD
local ReactNoop
-- local ReactDOM
-- local ReactDOMServer
local Scheduler
-- local PropTypes
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it
local xit = JestGlobals.xit

-- ROBLOX TODO: split non-DOM test into separate file, make upstream PR for this division

local jestExpect = JestGlobals.expect

describe("ReactStrictMode", function()
	beforeEach(function()
		jest.resetModules()

		-- ROBLOX deviation: workaround because our flag is currently always set to false
		local ReactFeatureFlags = require("@pkg/@jsdotlua/shared").ReactFeatureFlags
		ReactFeatureFlags.debugRenderPhaseSideEffectsForStrictMode = true
		React = require(".")

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		-- ReactDOM = require('react-dom')
		-- ReactDOMServer = require('react-dom/server')
		Scheduler = require("@pkg/@jsdotlua/scheduler")
=======
local ReactDOM
local ReactDOMClient
local ReactDOMServer
local Scheduler
local PropTypes
local ReactFeatureFlags = require_("shared/ReactFeatureFlags")
describe("ReactStrictMode", function()
	beforeEach(function()
		jest.resetModules()
		React = require_("react")
		ReactDOM = require_("react-dom")
		ReactDOMClient = require_("react-dom/client")
		ReactDOMServer = require_("react-dom/server")
	end)
	it("should appear in the client component stack", function()
		local function Foo()
			return React.createElement("div", { ariaTypo = "" })
		end
		local container = document:createElement("div")
		expect(function()
			ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
		end).toErrorDev(
			"Invalid ARIA attribute `ariaTypo`. "
				.. "ARIA attributes follow the pattern aria-* and must be lowercase.\n"
				.. "    in div (at **)\n"
				.. "    in Foo (at **)"
		)
	end)
	it("should appear in the SSR component stack", function()
		local function Foo()
			return React.createElement("div", { ariaTypo = "" })
		end
		expect(function()
			ReactDOMServer:renderToString(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)))
		end).toErrorDev(
			"Invalid ARIA attribute `ariaTypo`. "
				.. "ARIA attributes follow the pattern aria-* and must be lowercase.\n"
				.. "    in div (at **)\n"
				.. "    in Foo (at **)"
		)
>>>>>>> upstream-apply
	end)
	-- ROBLOX TODO: Untranslated ReactDOMInvalidARIAHook file throws the error this test checks
	-- xit('should appear in the client component stack', function()
	--     local function Foo()
	--         return React.createElement('div', {
	--             ariaTypo = '',
	--         })
	--     end

	--     jestExpect(function()
	--         -- ROBLOX deviation: use ReactNoop to render instead of ReactDOM
	--         ReactNoop.render(React.createElement(React.StrictMode, nil, React.createElement(Foo)))
	--     end).toErrorDev('Invalid ARIA attribute `ariaTypo`. ' .. 'ARIA attributes follow the pattern aria-* and must be lowercase.\n' .. '    in div (at **)\n' .. '    in Foo (at **)')
	-- end)
	-- ROBLOX TODO: Untranslated ReactDOMInvalidARIAHook file throws the error this test checks
	-- xit('should appear in the SSR component stack', function()
	--     local function Foo()
	--         return React.createElement('div', {
	--             ariaTypo = '',
	--         })
	--     end

	--     jestExpect(function()
	--         -- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOMServer.renderToString
	--         ReactNoop.render(React.createElement(React.StrictMode, nil, React.createElement(Foo)))
	--     end).toErrorDev('Invalid ARIA attribute `ariaTypo`. ' .. 'ARIA attributes follow the pattern aria-* and must be lowercase.\n' .. '    in div (at **)\n' .. '    in Foo (at **)')
	-- end)
	it("should invoke precommit lifecycle methods twice", function()
		local log = {}
		local shouldComponentUpdate = false
		local ClassComponent = React.Component:extend("ClassComponent")

		function ClassComponent.getDerivedStateFromProps()
			table.insert(log, "getDerivedStateFromProps")

			return nil
		end
		function ClassComponent:init()
			-- ROBLOX deviation: silence analyze with explicit state
			self.state = {}
			table.insert(log, "constructor")
		end
		function ClassComponent:componentDidMount()
			table.insert(log, "componentDidMount")
		end
		function ClassComponent:componentDidUpdate()
			table.insert(log, "componentDidUpdate")
		end
		function ClassComponent:componentWillUnmount()
			table.insert(log, "componentWillUnmount")
		end
		function ClassComponent:shouldComponentUpdate()
			table.insert(log, "shouldComponentUpdate")

			return shouldComponentUpdate
		end
		function ClassComponent:render()
			table.insert(log, "render")

			return nil
		end

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(
					React.StrictMode,
					nil,
					React.createElement(ClassComponent)
				)
			)
		end)

		if _G.__DEV__ then
			jestExpect(log).toEqual({
				"constructor",
				"constructor",
				"getDerivedStateFromProps",
				"getDerivedStateFromProps",
				"render",
				"render",
				"componentDidMount",
			})
		else
			jestExpect(log).toEqual({
				"constructor",
				"getDerivedStateFromProps",
				"render",
				"componentDidMount",
			})
		end

		log = {}
		shouldComponentUpdate = true

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(
					React.StrictMode,
					nil,
					React.createElement(ClassComponent)
				)
			)
		end)

		if _G.__DEV__ then
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
				"shouldComponentUpdate",
				"render",
				"render",
				"componentDidUpdate",
			})
		else
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
				"render",
				"componentDidUpdate",
			})
		end

		log = {}
		shouldComponentUpdate = false

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(
					React.StrictMode,
					nil,
					React.createElement(ClassComponent)
				)
			)
		end)

		if _G.__DEV__ then
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
				"shouldComponentUpdate",
			})
		else
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
			})
		end
	end)
	it("should invoke setState callbacks twice", function()
		local instance
		local ClassComponent = React.Component:extend("ClassComponent")

		function ClassComponent:init()
			self.state = { count = 1 }
		end
		function ClassComponent:render()
			instance = self
			return nil
		end

		local setStateCount = 0

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(
					React.StrictMode,
					nil,
					React.createElement(ClassComponent)
				)
			)
		end)

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM, needs flushSync
		ReactNoop.flushSync(function()
			instance:setState(function(state: { count: number })
				setStateCount = setStateCount + 1
				return {
					count = state.count + 1,
				}
			end)
		end)
		-- Callback should be invoked twice in DEV
		jestExpect(setStateCount).toEqual((function()
			if _G.__DEV__ then
				return 2
			end

			return 1
		end)())
		-- But each time `state` should be the previous value
		jestExpect(instance.state.count).toEqual(2)
	end)
	it("should invoke precommit lifecycle methods twice in DEV", function()
		local StrictMode = React.StrictMode
		local log = {}
		local shouldComponentUpdate = false

		local ClassComponent = React.Component:extend("ClassComponent")

		function ClassComponent:init(props)
			-- ROBLOX deviation: silence analyze with explicit state
			self.state = {}
			table.insert(log, "constructor")
		end
		function ClassComponent.getDerivedStateFromProps()
			table.insert(log, "getDerivedStateFromProps")
			return nil
		end
		function ClassComponent:componentDidMount()
			table.insert(log, "componentDidMount")
		end
		function ClassComponent:componentDidUpdate()
			table.insert(log, "componentDidUpdate")
		end
		function ClassComponent:componentWillUnmount()
			table.insert(log, "componentWillUnmount")
		end
		function ClassComponent:shouldComponentUpdate()
			table.insert(log, "shouldComponentUpdate")

			return shouldComponentUpdate
		end
		function ClassComponent:render()
			table.insert(log, "render")

			return nil
		end

		local function Root()
			return React.createElement(
				StrictMode,
				nil,
				React.createElement(ClassComponent)
			)
		end

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(Root))
		end)

		if _G.__DEV__ then
			jestExpect(log).toEqual({
				"constructor",
				"constructor",
				"getDerivedStateFromProps",
				"getDerivedStateFromProps",
				"render",
				"render",
				"componentDidMount",
			})
		else
			jestExpect(log).toEqual({
				"constructor",
				"getDerivedStateFromProps",
				"render",
				"componentDidMount",
			})
		end

		log = {}
		shouldComponentUpdate = true

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(Root))
		end)

		if _G.__DEV__ then
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
				"shouldComponentUpdate",
				"render",
				"render",
				"componentDidUpdate",
			})
		else
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
				"render",
				"componentDidUpdate",
			})
		end

		log = {}
		shouldComponentUpdate = false

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(Root))
		end)

		if _G.__DEV__ then
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
				"shouldComponentUpdate",
			})
		else
			jestExpect(log).toEqual({
				"getDerivedStateFromProps",
				"shouldComponentUpdate",
			})
		end
	end)
	it("should invoke setState callbacks twice in DEV", function()
		local StrictMode = React.StrictMode
		local instance
		local ClassComponent = React.Component:extend("ClassComponent")

		function ClassComponent:init()
			self.state = {
				count = 1,
			}
		end

		function ClassComponent:render()
			instance = self

			return nil
		end

		local setStateCount = 0

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(StrictMode, nil, React.createElement(ClassComponent))
			)
		end)

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop.flushSync(function()
			instance:setState(function(state: { count: number })
				setStateCount = setStateCount + 1

				return {
					count = state.count + 1,
				}
			end)
		end)
		-- Callback should be invoked twice (in DEV)
		jestExpect(setStateCount).toEqual((function()
			if _G.__DEV__ then
				return 2
			end

			return 1
		end)())
		-- But each time `state` should be the previous value
		jestExpect(instance.state.count).toEqual(2)
	end)
end)
describe("Concurrent Mode", function()
	beforeEach(function()
		jest.resetModules()
<<<<<<< HEAD
		React = require(".")
		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		-- ReactDOM = require('react-dom')
		-- ReactDOMServer = require('react-dom/server')
		Scheduler = require("@pkg/@jsdotlua/scheduler")
	end)
	it(
		"should warn about unsafe legacy lifecycle methods anywhere in the tree",
		function()
			local function Wrapper(props)
				local children = props.children
=======
		React = require_("react")
		ReactDOM = require_("react-dom")
		ReactDOMClient = require_("react-dom/client")
		Scheduler = require_("scheduler")
	end)
	it("should warn about unsafe legacy lifecycle methods anywhere in a StrictMode tree", function()
		local function StrictRoot()
			return React.createElement(React.StrictMode, nil, React.createElement(App, nil))
		end
		type App = React_Component<any, any> & {}
		type App_statics = {}
		local App = React.Component:extend("App") :: App & App_statics
		function App.UNSAFE_componentWillMount(self: App) end
		function App.UNSAFE_componentWillUpdate(self: App) end
		function App.render(self: App)
			return React.createElement(
				"div",
				nil,
				React.createElement(Wrapper, nil, React.createElement(Foo, nil)),
				React.createElement("div", nil, React.createElement(Bar, nil), React.createElement(Foo, nil))
			)
		end
		local function Wrapper(ref0)
			local children = ref0.children
			return React.createElement("div", nil, children)
		end
		type Foo = React_Component<any, any> & {}
		type Foo_statics = {}
		local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
		function Foo.UNSAFE_componentWillReceiveProps(self: Foo) end
		function Foo.render(self: Foo)
			return nil
		end
		type Bar = React_Component<any, any> & {}
		type Bar_statics = {}
		local Bar = React.Component:extend("Bar") :: Bar & Bar_statics
		function Bar.UNSAFE_componentWillReceiveProps(self: Bar) end
		function Bar.render(self: Bar)
			return nil
		end
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		root:render(React.createElement(StrictRoot, nil))
		expect(function()
			return Scheduler:unstable_flushAll()
		end).toErrorDev({
			--[[ eslint-disable max-len ]]
			[[Warning: Using UNSAFE_componentWillMount in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.
>>>>>>> upstream-apply

				return React.createElement("div", nil, children)
			end

<<<<<<< HEAD
			local Foo = React.Component:extend("Foo")
=======
Please update the following components: App]],
			[[Warning: Using UNSAFE_componentWillReceiveProps in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.
>>>>>>> upstream-apply

			function Foo:UNSAFE_componentWillReceiveProps() end
			function Foo:render()
				return nil
			end

			local Bar = React.Component:extend("Bar")

			function Bar:UNSAFE_componentWillReceiveProps() end
			function Bar:render()
				return nil
			end

<<<<<<< HEAD
			local AsyncRoot = React.Component:extend("AsyncRoot")

			function AsyncRoot:UNSAFE_componentWillMount() end
			function AsyncRoot:UNSAFE_componentWillUpdate() end
			function AsyncRoot:render()
				return React.createElement(
					"div",
					nil,
					React.createElement(Wrapper, nil, React.createElement(Foo)),
					React.createElement(
						"div",
						nil,
						React.createElement(Bar),
						React.createElement(Foo)
					)
				)
			end

			-- ROBLOX deviation: using ReactNoop in place of ReactDOM
			local root = ReactNoop.createRoot()

			root.render(React.createElement(AsyncRoot))
			jestExpect(function()
				return Scheduler.unstable_flushAll()
=======
Please update the following components: App]],
			--[[ eslint-enable max-len ]]
		}, { withoutStack = true }) -- Dedupe
		root:render(React.createElement(App, nil))
		Scheduler:unstable_flushAll()
	end)
	it("should coalesce warnings by lifecycle name", function()
		local function StrictRoot()
			return React.createElement(React.StrictMode, nil, React.createElement(App, nil))
		end
		type App = React_Component<any, any> & {}
		type App_statics = {}
		local App = React.Component:extend("App") :: App & App_statics
		function App.UNSAFE_componentWillMount(self: App) end
		function App.UNSAFE_componentWillUpdate(self: App) end
		function App.render(self: App)
			return React.createElement(Parent, nil)
		end
		type Parent = React_Component<any, any> & {}
		type Parent_statics = {}
		local Parent = React.Component:extend("Parent") :: Parent & Parent_statics
		function Parent.componentWillMount(self: Parent) end
		function Parent.componentWillUpdate(self: Parent) end
		function Parent.componentWillReceiveProps(self: Parent) end
		function Parent.render(self: Parent)
			return React.createElement(Child, nil)
		end
		type Child = React_Component<any, any> & {}
		type Child_statics = {}
		local Child = React.Component:extend("Child") :: Child & Child_statics
		function Child.UNSAFE_componentWillReceiveProps(self: Child) end
		function Child.render(self: Child)
			return nil
		end
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		root:render(React.createElement(StrictRoot, nil))
		expect(function()
			expect(function()
				return Scheduler:unstable_flushAll()
>>>>>>> upstream-apply
			end).toErrorDev({

				[[Warning: Using UNSAFE_componentWillMount in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move code with side effects to componentDidMount, and set initial state in the constructor.

<<<<<<< HEAD
Please update the following components: AsyncRoot]],

				[[Warning: Using UNSAFE_componentWillReceiveProps in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move data fetching code or side effects to componentDidUpdate.
* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state

Please update the following components: Bar, Foo]],

				[[Warning: Using UNSAFE_componentWillUpdate in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move data fetching code or side effects to componentDidUpdate.

Please update the following components: AsyncRoot]],
			}, { withoutStack = true })
			root.render(React.createElement(AsyncRoot))
			Scheduler.unstable_flushAll()
		end
	)
	it("should coalesce warnings by lifecycle name", function()
		local Child = React.Component:extend("Child")
		function Child:UNSAFE_componentWillReceiveProps() end
		function Child:render()
			return nil
		end

		local Parent = React.Component:extend("Parent")
		function Parent:componentWillMount() end
		function Parent:componentWillUpdate() end
		function Parent:componentWillReceiveProps() end
		function Parent:render()
			return React.createElement(Child)
		end

		local AsyncRoot = React.Component:extend("AsyncRoot")
		function AsyncRoot:UNSAFE_componentWillMount() end
		function AsyncRoot:UNSAFE_componentWillUpdate() end
		function AsyncRoot:render()
			return React.createElement(Parent)
		end

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		local root = ReactNoop.createRoot()

		root.render(React.createElement(AsyncRoot))
		jestExpect(function()
			jestExpect(function()
				return Scheduler.unstable_flushAll()
			end).toErrorDev({
				-- ROBLOX deviation: below warnings all remove "To rename all deprecated lifecycles..." line which are unique instructions for Node.js

				[[Warning: Using UNSAFE_componentWillMount in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move code with side effects to componentDidMount, and set initial state in the constructor.

Please update the following components: AsyncRoot]],

=======
Please update the following components: App]],
>>>>>>> upstream-apply
				[[Warning: Using UNSAFE_componentWillReceiveProps in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move data fetching code or side effects to componentDidUpdate.
* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state

Please update the following components: Child]],

				[[Warning: Using UNSAFE_componentWillUpdate in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move data fetching code or side effects to componentDidUpdate.

<<<<<<< HEAD
Please update the following components: AsyncRoot]],
=======
Please update the following components: App]],
				--[[ eslint-enable max-len ]]
>>>>>>> upstream-apply
			}, { withoutStack = true })
		end).toWarnDev({

			[[Warning: componentWillMount has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move code with side effects to componentDidMount, and set initial state in the constructor.
* Rename componentWillMount to UNSAFE_componentWillMount to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.

Please update the following components: Parent]],

			[[Warning: componentWillReceiveProps has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move data fetching code or side effects to componentDidUpdate.
* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state
* Rename componentWillReceiveProps to UNSAFE_componentWillReceiveProps to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.

Please update the following components: Parent]],

			[[Warning: componentWillUpdate has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.

* Move data fetching code or side effects to componentDidUpdate.
* Rename componentWillUpdate to UNSAFE_componentWillUpdate to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.

Please update the following components: Parent]],
<<<<<<< HEAD
		}, { withoutStack = true })
		root.render(React.createElement(AsyncRoot))
		Scheduler.unstable_flushAll()
	end)
	it("should warn about components not present during the initial render", function()
		local Foo = React.Component:extend("Foo")

		function Foo:UNSAFE_componentWillMount() end
		function Foo:render()
=======
			--[[ eslint-enable max-len ]]
		}, { withoutStack = true }) -- Dedupe
		root:render(React.createElement(StrictRoot, nil))
		Scheduler:unstable_flushAll()
	end)
	it("should warn about components not present during the initial render", function()
		local function StrictRoot(ref0)
			local foo = ref0.foo
			return React.createElement(
				React.StrictMode,
				nil,
				if Boolean.toJSBoolean(foo) then React.createElement(Foo, nil) else React.createElement(Bar, nil)
			)
		end
		type Foo = React_Component<any, any> & {}
		type Foo_statics = {}
		local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
		function Foo.UNSAFE_componentWillMount(self: Foo) end
		function Foo.render(self: Foo)
>>>>>>> upstream-apply
			return nil
		end

		local Bar = React.Component:extend("Bar")

		function Bar:UNSAFE_componentWillMount() end
		function Bar:render()
			return nil
		end
<<<<<<< HEAD

		local AsyncRoot = React.Component:extend("AsyncRoot")

		function AsyncRoot:render()
			return (function()
				if self.props.foo then
					return React.createElement(Foo)
				end

				return React.createElement(Bar)
			end)()
		end

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		local root = ReactNoop.createRoot()

		root.render(React.createElement(AsyncRoot, { foo = true }))
		jestExpect(function()
			return Scheduler.unstable_flushAll()
		end).toErrorDev(
			"Using UNSAFE_componentWillMount in strict mode is not recommended",
			{ withoutStack = true }
		)

		root.render(React.createElement(AsyncRoot, { foo = false }))
		jestExpect(function()
			return Scheduler.unstable_flushAll()
		end).toErrorDev(
			"Using UNSAFE_componentWillMount in strict mode is not recommended",
			{ withoutStack = true }
		)

		root.render(React.createElement(AsyncRoot, { foo = true }))
		Scheduler.unstable_flushAll()

		root.render(React.createElement(AsyncRoot, { foo = false }))
		Scheduler.unstable_flushAll()
=======
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		root:render(React.createElement(StrictRoot, { foo = true }))
		expect(function()
			return Scheduler:unstable_flushAll()
		end).toErrorDev("Using UNSAFE_componentWillMount in strict mode is not recommended", { withoutStack = true })
		root:render(React.createElement(StrictRoot, { foo = false }))
		expect(function()
			return Scheduler:unstable_flushAll()
		end).toErrorDev("Using UNSAFE_componentWillMount in strict mode is not recommended", { withoutStack = true }) -- Dedupe
		root:render(React.createElement(StrictRoot, { foo = true }))
		Scheduler:unstable_flushAll()
		root:render(React.createElement(StrictRoot, { foo = false }))
		Scheduler:unstable_flushAll()
>>>>>>> upstream-apply
	end)
	it('should also warn inside of "strict" mode trees', function()
		local StrictMode = React.StrictMode

		local Foo = React.Component:extend("Foo")
		function Foo:UNSAFE_componentWillReceiveProps() end
		function Foo:render()
			return nil
		end

		local Bar = React.Component:extend("Bar")
		function Bar:UNSAFE_componentWillReceiveProps() end
		function Bar:render()
			return nil
		end

		local function Wrapper(props)
			return React.createElement(
				"div",
				nil,
				React.createElement(Bar),
				React.createElement(Foo)
			)
		end

		local SyncRoot = React.Component:extend("SyncRoot")
		function SyncRoot:UNSAFE_componentWillMount() end
		function SyncRoot:UNSAFE_componentWillUpdate() end
		function SyncRoot:UNSAFE_componentWillReceiveProps() end
		function SyncRoot:render()
			return React.createElement(StrictMode, nil, React.createElement(Wrapper))
		end

		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		local root = ReactNoop.createLegacyRoot()

		jestExpect(function()
			return root.render(React.createElement(SyncRoot))
		end).toErrorDev(
			"Using UNSAFE_componentWillReceiveProps in strict mode is not recommended",
			{ withoutStack = true }
		)

		-- Dedupe
		root.render(React.createElement(SyncRoot))
	end)
end)
describe("symbol checks", function()
	beforeEach(function()
		jest.resetModules()
<<<<<<< HEAD
		React = require(".")
		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		-- ReactDOM = require('react-dom')
		-- ReactDOMServer = require('react-dom/server')
		Scheduler = require("@pkg/@jsdotlua/scheduler")
=======
		React = require_("react")
		ReactDOM = require_("react-dom")
		ReactDOMClient = require_("react-dom/client")
>>>>>>> upstream-apply
	end)
	it("should switch from StrictMode to a Fragment and reset state", function()
		local Fragment, StrictMode = React.Fragment, React.StrictMode

		local ChildComponent = React.Component:extend("ChildComponent")

		function ChildComponent:init()
			self.state = {
				count = 0,
			}
		end

		function ChildComponent.getDerivedStateFromProps(nextProps, prevState)
			return {
				count = prevState.count + 1,
			}
		end
		function ChildComponent:render()
			return string.format("count:%s", self.state.count)
		end

		local function ParentComponent(props)
			local useFragment = props.useFragment

			return (function()
				if useFragment then
					return React.createElement(
						Fragment,
						nil,
						React.createElement(ChildComponent)
					)
				end

				return React.createElement(
					StrictMode,
					nil,
					React.createElement(ChildComponent)
				)
			end)()
		end

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(ParentComponent, { useFragment = false })
			)
		end)
		jestExpect(ReactNoop.getChildren()[1].text).toEqual("count:1")

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(ParentComponent, { useFragment = true }))
		end)
		jestExpect(ReactNoop.getChildren()[1].text).toEqual("count:1")
	end)
	it("should switch from a Fragment to StrictMode and reset state", function()
		local Fragment, StrictMode = React.Fragment, React.StrictMode

		local ChildComponent = React.Component:extend("ChildComponent")

		function ChildComponent:init()
			self.state = {
				count = 0,
			}
		end
		function ChildComponent.getDerivedStateFromProps(nextProps, prevState)
			return {
				count = prevState.count + 1,
			}
		end
		function ChildComponent:render()
			return string.format("count:%s", self.state.count)
		end

		local function ParentComponent(props)
			local useFragment = props.useFragment

			return (function()
				if useFragment then
					return React.createElement(
						Fragment,
						nil,
						React.createElement(ChildComponent)
					)
				end

				return React.createElement(
					StrictMode,
					nil,
					React.createElement(ChildComponent)
				)
			end)()
		end

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(
				React.createElement(ParentComponent, { useFragment = false })
			)
		end)
		jestExpect(ReactNoop.getChildren()[1].text).toEqual("count:1")

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(ParentComponent, { useFragment = true }))
		end)
		jestExpect(ReactNoop.getChildren()[1].text).toEqual("count:1")
	end)
	it("should update with StrictMode without losing state", function()
		local StrictMode = React.StrictMode

		local ChildComponent = React.Component:extend("ChildComponent")

		function ChildComponent:init()
			self.state = {
				count = 0,
			}
		end
		function ChildComponent.getDerivedStateFromProps(nextProps, prevState)
			return {
				count = prevState.count + 1,
			}
		end
		function ChildComponent:render()
			return string.format("count:%s", self.state.count)
		end

		local function ParentComponent()
			return React.createElement(
				StrictMode,
				nil,
				React.createElement(ChildComponent)
			)
		end

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(ParentComponent))
		end)
		jestExpect(ReactNoop.getChildren()[1].text).toEqual("count:1")

		-- ROBLOX deviation: use ReactNoop.render to render instead of ReactDOM.render
		ReactNoop.act(function()
			ReactNoop.render(React.createElement(ParentComponent))
		end)
		jestExpect(ReactNoop.getChildren()[1].text).toEqual("count:2")
	end)
end)
-- ROBLOX deviation START: we removed support for string refs, so skip test
describe("string refs", function()
	beforeEach(function()
		jest.resetModules()
<<<<<<< HEAD
		React = require(".")
		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		-- ReactDOM = require('react-dom')
		-- ReactDOMServer = require('react-dom/server')
		Scheduler = require("@pkg/@jsdotlua/scheduler")
=======
		React = require_("react")
		ReactDOM = require_("react-dom")
		ReactDOMClient = require_("react-dom/client")
>>>>>>> upstream-apply
	end)

	xit("should warn within a strict tree", function()
		-- local StrictMode = React.StrictMode
		-- local OuterComponent = React.Component:extend("OuterComponent")

		-- local InnerComponent = React.Component:extend("InnerComponent")

		-- function InnerComponent:render()
		--     return nil
		-- end

		-- function OuterComponent:render()
		--     return React.createElement(StrictMode, nil, React.createElement(InnerComponent, {
		--         ref = 'somestring',
		--     }))
		-- end

		-- jestExpect(function()
		--     -- ROBLOX deviation: using ReactNoop in place of ReactDOM
		--     ReactNoop.act(function()
		--         ReactNoop.render(React.createElement(OuterComponent))
		--     end)
		-- end).toErrorDev(
		--     'Warning: A string ref, "somestring", has been found within a strict mode tree. ' ..
		--         'String refs are a source of potential bugs and should be avoided. ' ..
		--         'We recommend using useRef() or createRef() instead. ' ..
		--         'Learn more about using refs safely here: ' ..
		--         'https://reactjs.org/link/strict-mode-string-ref\n' ..
		--         '    in OuterComponent (at **)'
		-- )

		-- -- Dedup
		-- -- ROBLOX deviation: using ReactNoop in place of ReactDOM
		-- ReactNoop.act(function()
		--     ReactNoop.render(React.createElement(OuterComponent))
		-- end)
	end)

	xit("should warn within a strict tree 2", function()
		-- local StrictMode = React.StrictMode

		-- local MiddleComponent = React.Component:extend("MiddleComponent")

		-- function MiddleComponent:render()
		--     return nil
		-- end

		-- local InnerComponent = React.Component:extend("InnerComponent")

		-- function InnerComponent:render()
		--     return React.createElement(MiddleComponent, {
		--         ref = 'somestring',
		--     })
		-- end

		-- local OuterComponent = React.Component:extend("OuterComponent")

		-- function OuterComponent:render()
		--     return React.createElement(StrictMode, nil, React.createElement(InnerComponent))
		-- end

		-- jestExpect(function()
		--     -- ROBLOX deviation: using ReactNoop in place of ReactDOM
		--     ReactNoop.act(function()
		--         ReactNoop.render(React.createElement(OuterComponent))
		--     end)
		-- end).toErrorDev(
		--     'Warning: A string ref, "somestring", has been found within a strict mode tree. ' ..
		--         'String refs are a source of potential bugs and should be avoided. ' ..
		--         'We recommend using useRef() or createRef() instead. ' ..
		--         'Learn more about using refs safely here: ' ..
		--         'https://reactjs.org/link/strict-mode-string-ref\n' ..
		--         '    in InnerComponent (at **)\n' ..
		--         '    in OuterComponent (at **)'
		-- )
		-- -- Dedup
		-- -- ROBLOX deviation: using ReactNoop in place of ReactDOM
		-- ReactNoop.act(function()
		--     ReactNoop.render(React.createElement(OuterComponent))
		-- end)
	end)
end)
-- ROBLOX deviation END
describe("context legacy", function()
	beforeEach(function()
		jest.resetModules()
<<<<<<< HEAD
		React = require(".")
		-- ROBLOX deviation: using ReactNoop in place of ReactDOM
		ReactNoop = require("@pkg/@jsdotlua/react-noop-renderer")
		-- ReactDOM = require('react-dom')
		-- ReactDOMServer = require('react-dom/server')
		Scheduler = require("@pkg/@jsdotlua/scheduler")
		-- PropTypes = require('prop-types')
=======
		React = require_("react")
		ReactDOM = require_("react-dom")
		ReactDOMClient = require_("react-dom/client")
		PropTypes = require_("prop-types")
>>>>>>> upstream-apply
	end)
	-- ROBLOX TODO: Proptypes
	xit("should warn if the legacy context API have been used in strict mode", function()

		--     local function FunctionalLegacyContextConsumer()
		--         return nil
		--     end

		--     local LegacyContextConsumer = React.Component:extend("LegacyContextConsumer")

		--     function LegacyContextConsumer:render()
		--         return nil
		--     end

		--     local StrictMode = React.StrictMode

		--     LegacyContextConsumer.contextTypes = {
		--         color = PropTypes.string,
		--     }
		--     FunctionalLegacyContextConsumer.contextTypes = {
		--         color = PropTypes.string,
		--     }

		--     local LegacyContextProvider = React.Component:extend("LegacyContextProvider")

		--     function LegacyContextProvider:getChildContext()
		--         return{
		--             color = 'purple',
		--         }
		--     end
		--     function LegacyContextProvider:render()
		--         return React.createElement('div', nil, React.createElement(LegacyContextConsumer), React.createElement(FunctionalLegacyContextConsumer))
		--     end

		--     LegacyContextProvider.childContextTypes = {
		--         color = PropTypes.string,
		--     }

		--     local Root = React.Component:extend("Root")

		--     function Root:render()
		--         return React.createElement('div', nil, React.createElement(StrictMode, nil, React.createElement(LegacyContextProvider)))
		--     end

		--     jestExpect(function()
		--         ReactNoop.render(React.createElement(Root))
		--     end).toErrorDev('Warning: Legacy context API has been detected within a strict-mode tree.' .. '\n\nThe old API will be supported in all 16.x releases, but applications ' .. 'using it should migrate to the new version.' .. '\n\nPlease update the following components: ' .. 'FunctionalLegacyContextConsumer, LegacyContextConsumer, LegacyContextProvider' .. '\n\nLearn more about this warning here: ' .. 'https://reactjs.org/link/legacy-context' .. '\n    in LegacyContextProvider (at **)' .. '\n    in div (at **)' .. '\n    in Root (at **)')
		--     ReactNoop.render(React.createElement(Root))
	end)
	describe("console logs logging", function()
		beforeEach(function()
			jest.resetModules()
			React = require_("react")
			ReactDOM = require_("react-dom")
			ReactDOMClient = require_("react-dom/client")
		end)
		if Boolean.toJSBoolean(ReactFeatureFlags.consoleManagedByDevToolsDuringStrictMode) then
			it("does not disable logs for class double render", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & {}
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.render(self: Foo)
					count += 1
					console.log("foo " .. tostring(count))
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(if Boolean.toJSBoolean(__DEV__) then 2 else 1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("does not disable logs for class double ctor", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & {}
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo, props)
					count += 1
					console.log("foo " .. tostring(count))
				end
				function Foo.render(self: Foo)
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(if Boolean.toJSBoolean(__DEV__) then 2 else 1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("does not disable logs for class double getDerivedStateFromProps", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & { state: Object }
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo)
					self.state = {}
				end
				function Foo.getDerivedStateFromProps()
					count += 1
					console.log("foo " .. tostring(count))
					return {}
				end
				function Foo.render(self: Foo)
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(if Boolean.toJSBoolean(__DEV__) then 2 else 1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("does not disable logs for class double shouldComponentUpdate", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & { state: Object }
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo)
					self.state = {}
				end
				function Foo.shouldComponentUpdate(self: Foo)
					count += 1
					console.log("foo " .. tostring(count))
					return {}
				end
				function Foo.render(self: Foo)
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container) -- Trigger sCU:
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(if Boolean.toJSBoolean(__DEV__) then 2 else 1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("does not disable logs for class state updaters", function()
				spyOnDevAndProd(console, "log")
				local inst
				local count = 0
				type Foo = React_Component<any, any> & { state: Object }
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo)
					self.state = {}
				end
				function Foo.render(self: Foo)
					inst = self
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				inst:setState(function()
					count += 1
					console.log("foo " .. tostring(count))
					return {}
				end)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(if Boolean.toJSBoolean(__DEV__) then 2 else 1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("does not disable logs for function double render", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				local function Foo()
					count += 1
					console.log("foo " .. tostring(count))
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(if Boolean.toJSBoolean(__DEV__) then 2 else 1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
		else
			it("disable logs for class double render", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & {}
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.render(self: Foo)
					count += 1
					console.log("foo " .. tostring(count))
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("disables logs for class double ctor", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & {}
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo, props)
					count += 1
					console.log("foo " .. tostring(count))
				end
				function Foo.render(self: Foo)
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("disable logs for class double getDerivedStateFromProps", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & { state: Object }
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo)
					self.state = {}
				end
				function Foo.getDerivedStateFromProps()
					count += 1
					console.log("foo " .. tostring(count))
					return {}
				end
				function Foo.render(self: Foo)
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("disable logs for class double shouldComponentUpdate", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				type Foo = React_Component<any, any> & { state: Object }
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo)
					self.state = {}
				end
				function Foo.shouldComponentUpdate(self: Foo)
					count += 1
					console.log("foo " .. tostring(count))
					return {}
				end
				function Foo.render(self: Foo)
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container) -- Trigger sCU:
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("disable logs for class state updaters", function()
				spyOnDevAndProd(console, "log")
				local inst
				local count = 0
				type Foo = React_Component<any, any> & { state: Object }
				type Foo_statics = {}
				local Foo = React.Component:extend("Foo") :: Foo & Foo_statics
				function Foo.init(self: Foo)
					self.state = {}
				end
				function Foo.render(self: Foo)
					inst = self
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				inst:setState(function()
					count += 1
					console.log("foo " .. tostring(count))
					return {}
				end)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
			it("disable logs for function double render", function()
				spyOnDevAndProd(console, "log")
				local count = 0
				local function Foo()
					count += 1
					console.log("foo " .. tostring(count))
					return nil
				end
				local container = document:createElement("div")
				ReactDOM:render(React.createElement(React.StrictMode, nil, React.createElement(Foo, nil)), container)
				expect(count).toBe(if Boolean.toJSBoolean(__DEV__) then 2 else 1)
				expect(console.log).toBeCalledTimes(1) -- Note: we should display the first log because otherwise
				-- there is a risk of suppressing warnings when they happen,
				-- and on the next render they'd get deduplicated and ignored.
				expect(console.log).toBeCalledWith("foo 1")
			end)
		end
	end)
end)
