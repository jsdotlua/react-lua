-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-devtools-shared/src/__tests__/console-test.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
<<<<<<< HEAD
]]
local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local describe = JestGlobals.describe
local xit = JestGlobals.xit
local beforeEach = JestGlobals.beforeEach
local jestExpect = JestGlobals.expect
local jest = JestGlobals.jest

-- ROBLOX deviation: Use lua's _G global table
local global = _G

-- ROBLOX deviation: Stub for now
local Console = {
	patch = function(...)
		print("Console.patch", ...)
	end,
	unpatch = function(...)
		print("Console.unpatch", ...)
	end,
	dangerous_setTargetConsoleForTesting = function(...) end,
	registerRenderer = function(...) end,
}

local React
local ReactRoblox
local utils = require("./utils")

describe("console", function()
	local act
	local fakeConsole
	local mockError
	local mockInfo
	local mockLog
	local mockWarn
	local patchConsole
	local unpatchConsole

	beforeEach(function()
		jest.resetModules()

=======
 *
 * @flow
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Symbol = LuauPolyfill.Symbol
type Object = LuauPolyfill.Object
local RegExp = require(Packages.RegExp)
local React
local ReactDOMClient
local act
local fakeConsole
local legacyRender
local mockError
local mockInfo
local mockLog
local mockWarn
local patchConsole
local unpatchConsole
local rendererID
describe("console", function()
	beforeEach(function()
		local Console = require_("react-devtools-shared/src/backend/console")
>>>>>>> upstream-apply
		patchConsole = Console.patch
		unpatchConsole = Console.unpatch

		-- Patch a fake console so we can verify with tests below.
		-- Patching the real console is too complicated,
		-- because Jest itself has hooks into it as does our test env setup.
		mockError = jest.fn()
		mockInfo = jest.fn()
		mockLog = jest.fn()
		mockWarn = jest.fn()
<<<<<<< HEAD
		fakeConsole = {
			error = mockError,
			info = mockInfo,
			log = mockLog,
			warn = mockWarn,
		}

		Console.dangerous_setTargetConsoleForTesting(fakeConsole)

		-- Note the Console module only patches once,
		-- so it's important to patch the test console before injection.
		patchConsole({
			appendComponentStack = true,
			breakOnWarn = false,
		})

		local inject = global.__REACT_DEVTOOLS_GLOBAL_HOOK__.inject
		global.__REACT_DEVTOOLS_GLOBAL_HOOK__.inject = function(internals)
			inject(internals)

			Console.registerRenderer(internals)
		end

		React = require("@pkg/@jsdotlua/react")
		ReactRoblox = require("@pkg/@jsdotlua/react-roblox")

=======
		fakeConsole = { error = mockError, info = mockInfo, log = mockLog, warn = mockWarn }
		Console:dangerous_setTargetConsoleForTesting(fakeConsole)
		global.__REACT_DEVTOOLS_GLOBAL_HOOK__:dangerous_setTargetConsoleForTesting(fakeConsole)
		local inject = global.__REACT_DEVTOOLS_GLOBAL_HOOK__.inject
		global.__REACT_DEVTOOLS_GLOBAL_HOOK__.inject = function(_self: any, internals)
			rendererID = inject(internals)
			Console:registerRenderer(internals)
			return rendererID
		end
		React = require_("react")
		ReactDOMClient = require_("react-dom/client")
		local utils = require_("./utils")
>>>>>>> upstream-apply
		act = utils.act
		legacyRender = utils.legacyRender
	end)

	local function normalizeCodeLocInfo(str)
<<<<<<< HEAD
		-- ROBLOX deviation: Lua stack traces won't match JS ones
		-- ROBLOX TODO: verify this
		return str
	end

	xit(
		"should not patch console methods that do not receive component stacks",
		function()
			jestExpect(fakeConsole.error).never.toBe(mockError)
			jestExpect(fakeConsole.info).toBe(mockInfo)
			jestExpect(fakeConsole.log).toBe(mockLog)
			jestExpect(fakeConsole.warn).never.toBe(mockWarn)
		end
	)

	xit("should only patch the console once", function()
		local prevError = fakeConsole.error
		local prevWarn = fakeConsole.warn

		patchConsole({
			appendComponentStack = true,
			breakOnWarn = false,
		})
		jestExpect(fakeConsole.error).toBe(prevError)
		jestExpect(fakeConsole.warn).toBe(prevWarn)
	end)

	xit("should un-patch when requested", function()
		jestExpect(fakeConsole.error).never.toBe(mockError)
		jestExpect(fakeConsole.warn).never.toBe(mockWarn)
		unpatchConsole()
		jestExpect(fakeConsole.error).toBe(mockError)
		jestExpect(fakeConsole.warn).toBe(mockWarn)
	end)

	xit("should pass through logs when there is no current fiber", function()
		jestExpect(mockLog).toHaveBeenCalledTimes(0)
		jestExpect(mockWarn).toHaveBeenCalledTimes(0)
		jestExpect(mockError).toHaveBeenCalledTimes(0)
		fakeConsole.log("log")
		fakeConsole.warn("warn")
		fakeConsole.error("error")
		jestExpect(mockLog).toHaveBeenCalledTimes(1)
		jestExpect(mockLog.mock.calls[0]).toHaveLength(1)
		jestExpect(mockLog.mock.calls[0][0]).toBe("log")
		jestExpect(mockWarn).toHaveBeenCalledTimes(1)
		jestExpect(mockWarn.mock.calls[0]).toHaveLength(1)
		jestExpect(mockWarn.mock.calls[0][0]).toBe("warn")
		jestExpect(mockError).toHaveBeenCalledTimes(1)
		jestExpect(mockError.mock.calls[0]).toHaveLength(1)
		jestExpect(mockError.mock.calls[0][0]).toBe("error")
	end)

	xit("should not append multiple stacks", function()
		local Child = function()
			fakeConsole.warn("warn\n    in Child (at fake.js:123)")
			fakeConsole.error("error", "\n    in Child (at fake.js:123)")
=======
		return if Boolean.toJSBoolean(str)
			then str:replace(
				RegExp("\\n +(?:at|in) ([\\S]+)[^\\n]*", "g"), --[[ ROBLOX NOTE: global flag is not implemented yet ]]
				function(m, name)
					return "\n    in " .. tostring(name) .. " (at **)"
				end
			)
			else str
	end -- @reactVersion >=18.0
	it("should not patch console methods that are not explicitly overridden", function()
		expect(fakeConsole.error)["not"].toBe(mockError)
		expect(fakeConsole.info).toBe(mockInfo)
		expect(fakeConsole.log).toBe(mockLog)
		expect(fakeConsole.warn)["not"].toBe(mockWarn)
	end) -- @reactVersion >=18.0
	it("should patch the console when appendComponentStack is enabled", function()
		unpatchConsole()
		expect(fakeConsole.error).toBe(mockError)
		expect(fakeConsole.warn).toBe(mockWarn)
		patchConsole({
			appendComponentStack = true,
			breakOnConsoleErrors = false,
			showInlineWarningsAndErrors = false,
		})
		expect(fakeConsole.error)["not"].toBe(mockError)
		expect(fakeConsole.warn)["not"].toBe(mockWarn)
	end) -- @reactVersion >=18.0
	it("should patch the console when breakOnConsoleErrors is enabled", function()
		unpatchConsole()
		expect(fakeConsole.error).toBe(mockError)
		expect(fakeConsole.warn).toBe(mockWarn)
		patchConsole({
			appendComponentStack = false,
			breakOnConsoleErrors = true,
			showInlineWarningsAndErrors = false,
		})
		expect(fakeConsole.error)["not"].toBe(mockError)
		expect(fakeConsole.warn)["not"].toBe(mockWarn)
	end) -- @reactVersion >=18.0
	it("should patch the console when showInlineWarningsAndErrors is enabled", function()
		unpatchConsole()
		expect(fakeConsole.error).toBe(mockError)
		expect(fakeConsole.warn).toBe(mockWarn)
		patchConsole({
			appendComponentStack = false,
			breakOnConsoleErrors = false,
			showInlineWarningsAndErrors = true,
		})
		expect(fakeConsole.error)["not"].toBe(mockError)
		expect(fakeConsole.warn)["not"].toBe(mockWarn)
	end) -- @reactVersion >=18.0
	it("should only patch the console once", function()
		local error_, warn_ = fakeConsole.error, fakeConsole.warn
		patchConsole({
			appendComponentStack = true,
			breakOnConsoleErrors = false,
			showInlineWarningsAndErrors = false,
		})
		expect(fakeConsole.error).toBe(error_)
		expect(fakeConsole.warn).toBe(warn_)
	end) -- @reactVersion >=18.0
	it("should un-patch when requested", function()
		expect(fakeConsole.error)["not"].toBe(mockError)
		expect(fakeConsole.warn)["not"].toBe(mockWarn)
		unpatchConsole()
		expect(fakeConsole.error).toBe(mockError)
		expect(fakeConsole.warn).toBe(mockWarn)
	end) -- @reactVersion >=18.0
	it("should pass through logs when there is no current fiber", function()
		expect(mockLog).toHaveBeenCalledTimes(0)
		expect(mockWarn).toHaveBeenCalledTimes(0)
		expect(mockError).toHaveBeenCalledTimes(0)
		fakeConsole:log("log")
		fakeConsole:warn_("warn")
		fakeConsole:error_("error")
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
	end) -- @reactVersion >=18.0
	it("should not append multiple stacks", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = true
		local function Child(ref0)
			local children = ref0.children
			fakeConsole:warn_("warn\n    in Child (at fake.js:123)")
			fakeConsole:error_("error", "\n    in Child (at fake.js:123)")
>>>>>>> upstream-apply
			return nil
		end

		-- ROBLOX deviation: Use createRoot instead of DOM element
		local root = ReactRoblox.createRoot(Instance.new("Frame"))

		act(function()
<<<<<<< HEAD
			return root:render(React.createElement(Child))
		end)
		jestExpect(mockWarn).toHaveBeenCalledTimes(1)
		jestExpect(mockWarn.mock.calls[0]).toHaveLength(1)
		-- ROBLOX TODO: What is printed instead of this?
		jestExpect(mockWarn.mock.calls[0][0]).toBe("warn\n    in Child (at fake.js:123)")
		jestExpect(mockError).toHaveBeenCalledTimes(1)
		jestExpect(mockError.mock.calls[0]).toHaveLength(2)
		jestExpect(mockError.mock.calls[0][0]).toBe("error")
		jestExpect(mockError.mock.calls[0][1]).toBe("\n    in Child (at fake.js:123)")
	end)

	xit(
		"should append component stacks to errors and warnings logged during render",
		function()
			local Intermediate = function(_ref2)
				local children = _ref2.children
				return children
=======
			return legacyRender(React.createElement(Child, nil), document:createElement("div"))
		end)
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn\n    in Child (at fake.js:123)")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("\n    in Child (at fake.js:123)")
	end) -- @reactVersion >=18.0
	it("should append component stacks to errors and warnings logged during render", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = true
		local function Intermediate(ref0)
			local children = ref0.children
			return children
		end
		local function Parent(ref0)
			local children = ref0.children
			return React.createElement(Intermediate, nil, React.createElement(Child, nil))
		end
		local function Child(ref0)
			local children = ref0.children
			fakeConsole:error_("error")
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			return nil
		end
		act(function()
			return legacyRender(React.createElement(Parent, nil), document:createElement("div"))
		end)
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
	end) -- @reactVersion >=18.0
	it("should append component stacks to errors and warnings logged from effects", function()
		local function Intermediate(ref0)
			local children = ref0.children
			return children
		end
		local function Parent(ref0)
			local children = ref0.children
			return React.createElement(Intermediate, nil, React.createElement(Child, nil))
		end
		local function Child(ref0)
			local children = ref0.children
			React.useLayoutEffect(function()
				fakeConsole:error_("active error")
				fakeConsole:log("active log")
				fakeConsole:warn_("active warn")
			end)
			React.useEffect(function()
				fakeConsole:error_("passive error")
				fakeConsole:log("passive log")
				fakeConsole:warn_("passive warn")
			end)
			return nil
		end
		act(function()
			return legacyRender(React.createElement(Parent, nil), document:createElement("div"))
		end)
		expect(mockLog).toHaveBeenCalledTimes(2)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("active log")
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("passive log")
		expect(mockWarn).toHaveBeenCalledTimes(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("active warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("passive warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError).toHaveBeenCalledTimes(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("active error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("passive error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
	end) -- @reactVersion >=18.0
	it("should append component stacks to errors and warnings logged from commit hooks", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = true
		local function Intermediate(ref0)
			local children = ref0.children
			return children
		end
		local function Parent(ref0)
			local children = ref0.children
			return React.createElement(Intermediate, nil, React.createElement(Child, nil))
		end
		type Child = React_Component<any, any> & {}
		type Child_statics = {}
		local Child = React.Component:extend("Child") :: Child & Child_statics
		function Child.componentDidMount(self: Child)
			fakeConsole:error_("didMount error")
			fakeConsole:log("didMount log")
			fakeConsole:warn_("didMount warn")
		end
		function Child.componentDidUpdate(self: Child)
			fakeConsole:error_("didUpdate error")
			fakeConsole:log("didUpdate log")
			fakeConsole:warn_("didUpdate warn")
		end
		function Child.render(self: Child)
			return nil
		end
		local container = document:createElement("div")
		act(function()
			return legacyRender(React.createElement(Parent, nil), container)
		end)
		act(function()
			return legacyRender(React.createElement(Parent, nil), container)
		end)
		expect(mockLog).toHaveBeenCalledTimes(2)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("didMount log")
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("didUpdate log")
		expect(mockWarn).toHaveBeenCalledTimes(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("didMount warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("didUpdate warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError).toHaveBeenCalledTimes(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("didMount error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("didUpdate error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
	end) -- @reactVersion >=18.0
	it("should append component stacks to errors and warnings logged from gDSFP", function()
		local function Intermediate(ref0)
			local children = ref0.children
			return children
		end
		local function Parent(ref0)
			local children = ref0.children
			return React.createElement(Intermediate, nil, React.createElement(Child, nil))
		end
		type Child = React_Component<any, any> & { state: Object }
		type Child_statics = {}
		local Child = React.Component:extend("Child") :: Child & Child_statics
		function Child.init(self: Child)
			self.state = {}
		end
		function Child.getDerivedStateFromProps()
			fakeConsole:error_("error")
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			return nil
		end
		function Child.render(self: Child)
			return nil
		end
		act(function()
			return legacyRender(React.createElement(Parent, nil), document:createElement("div"))
		end)
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
	end) -- @reactVersion >=18.0
	it("should append stacks after being uninstalled and reinstalled", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = false
		local function Child(ref0)
			local children = ref0.children
			fakeConsole:warn_("warn")
			fakeConsole:error_("error")
			return nil
		end
		act(function()
			return legacyRender(React.createElement(Child, nil), document:createElement("div"))
		end)
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		patchConsole({
			appendComponentStack = true,
			breakOnConsoleErrors = false,
			showInlineWarningsAndErrors = false,
		})
		act(function()
			return legacyRender(React.createElement(Child, nil), document:createElement("div"))
		end)
		expect(mockWarn).toHaveBeenCalledTimes(2)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)")
		expect(mockError).toHaveBeenCalledTimes(2)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)")
	end) -- @reactVersion >=18.0
	it("should be resilient to prepareStackTrace", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = true
		Error.prepareStackTrace = function(self: any, error_, callsites)
			local stack = { "An error occurred:", error_.message }
			do
				local i = 0
				while
					i
					< callsites.length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local callsite = callsites[tostring(i)]
					Array.concat(stack, {
						"\t" .. tostring(callsite:getFunctionName()),
						"\t\tat " .. tostring(callsite:getFileName()),
						"\t\ton line " .. tostring(callsite:getLineNumber()),
					}) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
					i += 1
				end
>>>>>>> upstream-apply
			end
			-- ROBLOX deviation: switched ordering for variable definition order
			local Child = function(_ref4)
				local _children = _ref4.children

				fakeConsole.error("error")
				fakeConsole.log("log")
				fakeConsole.warn("warn")

				return nil
			end
			local Parent = function(_ref3)
				local _children = _ref3.children
				return React.createElement(
					Intermediate,
					nil,
					React.createElement(Child, nil)
				)
			end

			-- ROBLOX deviation: Use createRoot instead of DOM element
			local root = ReactRoblox.createRoot(Instance.new("Frame"))

			act(function()
				return root:render(React.createElement(Parent, nil))
			end)
			jestExpect(mockLog).toHaveBeenCalledTimes(1)
			jestExpect(mockLog.mock.calls[0]).toHaveLength(1)
			jestExpect(mockLog.mock.calls[0][0]).toBe("log")
			jestExpect(mockWarn).toHaveBeenCalledTimes(1)
			jestExpect(mockWarn.mock.calls[0]).toHaveLength(2)
			jestExpect(mockWarn.mock.calls[0][0]).toBe("warn")
			-- ROBLOX TODO: What is printed instead of this?
			jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[0][1])).toEqual(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockError).toHaveBeenCalledTimes(1)
			jestExpect(mockError.mock.calls[0]).toHaveLength(2)
			jestExpect(mockError.mock.calls[0][0]).toBe("error")
			jestExpect(normalizeCodeLocInfo(mockError.mock.calls[0][1])).toBe(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
		end
	)
	xit(
		"should append component stacks to errors and warnings logged from effects",
		function()
			local Intermediate = function(_ref5)
				local children = _ref5.children
				return children
			end
			-- ROBLOX deviation: switched ordering for variable definition order
			local Child = function(_ref7)
				local _children = _ref7.children

				React.useLayoutEffect(function()
					fakeConsole.error("active error")
					fakeConsole.log("active log")
					fakeConsole.warn("active warn")
				end)
				React.useEffect(function()
					fakeConsole.error("passive error")
					fakeConsole.log("passive log")
					fakeConsole.warn("passive warn")
				end)

				return nil
			end
			local Parent = function(_ref6)
				local _children = _ref6.children

				return React.createElement(
					Intermediate,
					nil,
					React.createElement(Child, nil)
				)
			end

			-- ROBLOX deviation: Use createRoot instead of DOM element
			local root = ReactRoblox.createRoot(Instance.new("Frame"))

			act(function()
				return root:render(React.createElement(Parent, nil))
			end)
			jestExpect(mockLog).toHaveBeenCalledTimes(2)
			jestExpect(mockLog.mock.calls[0]).toHaveLength(1)
			jestExpect(mockLog.mock.calls[0][0]).toBe("active log")
			jestExpect(mockLog.mock.calls[1]).toHaveLength(1)
			jestExpect(mockLog.mock.calls[1][0]).toBe("passive log")
			jestExpect(mockWarn).toHaveBeenCalledTimes(2)
			jestExpect(mockWarn.mock.calls[0]).toHaveLength(2)
			jestExpect(mockWarn.mock.calls[0][0]).toBe("active warn")
			-- ROBLOX TODO: What is printed instead of this?
			jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[0][1])).toEqual(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockWarn.mock.calls[1]).toHaveLength(2)
			jestExpect(mockWarn.mock.calls[1][0]).toBe("passive warn")
			jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[1][1])).toEqual(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockError).toHaveBeenCalledTimes(2)
			jestExpect(mockError.mock.calls[0]).toHaveLength(2)
			jestExpect(mockError.mock.calls[0][0]).toBe("active error")
			jestExpect(normalizeCodeLocInfo(mockError.mock.calls[0][1])).toBe(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockError.mock.calls[1]).toHaveLength(2)
			jestExpect(mockError.mock.calls[1][0]).toBe("passive error")
			jestExpect(normalizeCodeLocInfo(mockError.mock.calls[1][1])).toBe(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
		end
	)
	xit(
		"should append component stacks to errors and warnings logged from commit hooks",
		function()
			local Intermediate = function(_ref8)
				local children = _ref8.children

				return children
			end
			-- ROBLOX deviation: switched ordering for variable definition order
			local Child = React.Component:extend("Child")
			local Parent = function(_ref9)
				local _children = _ref9.children

				return React.createElement(
					Intermediate,
					nil,
					React.createElement(Child, nil)
				)
			end

			function Child:componentDidMount()
				fakeConsole.error("didMount error")
				fakeConsole.log("didMount log")
				fakeConsole.warn("didMount warn")
			end
			function Child:componentDidUpdate()
				fakeConsole.error("didUpdate error")
				fakeConsole.log("didUpdate log")
				fakeConsole.warn("didUpdate warn")
			end
			function Child:render()
				return nil
			end

			-- ROBLOX deviation: Use createRoot instead of DOM element
			local root = ReactRoblox.createRoot(Instance.new("Frame"))

			act(function()
				return root:render(React.createElement(Parent, nil))
			end)
			act(function()
				return root:render(React.createElement(Parent, nil))
			end)
			jestExpect(mockLog).toHaveBeenCalledTimes(2)
			jestExpect(mockLog.mock.calls[0]).toHaveLength(1)
			jestExpect(mockLog.mock.calls[0][0]).toBe("didMount log")
			jestExpect(mockLog.mock.calls[1]).toHaveLength(1)
			jestExpect(mockLog.mock.calls[1][0]).toBe("didUpdate log")
			jestExpect(mockWarn).toHaveBeenCalledTimes(2)
			jestExpect(mockWarn.mock.calls[0]).toHaveLength(2)
			jestExpect(mockWarn.mock.calls[0][0]).toBe("didMount warn")
			-- ROBLOX TODO: What is printed instead of this?
			jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[0][1])).toEqual(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockWarn.mock.calls[1]).toHaveLength(2)
			jestExpect(mockWarn.mock.calls[1][0]).toBe("didUpdate warn")
			jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[1][1])).toEqual(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockError).toHaveBeenCalledTimes(2)
			jestExpect(mockError.mock.calls[0]).toHaveLength(2)
			jestExpect(mockError.mock.calls[0][0]).toBe("didMount error")
			jestExpect(normalizeCodeLocInfo(mockError.mock.calls[0][1])).toBe(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockError.mock.calls[1]).toHaveLength(2)
			jestExpect(mockError.mock.calls[1][0]).toBe("didUpdate error")
			jestExpect(normalizeCodeLocInfo(mockError.mock.calls[1][1])).toBe(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
		end
	)
	xit(
		"should append component stacks to errors and warnings logged from gDSFP",
		function()
			local Intermediate = function(props)
				local children = props.children
				return children
			end
			-- ROBLOX deviation: switched ordering for variable definition order
			local Child = React.Component:extend("Child")
			local Parent = function(props)
				local _children = props.children
				return React.createElement(Intermediate, nil, React.createElement(Child))
			end

			function Child.getDerivedStateFromProps()
				fakeConsole.error("error")
				fakeConsole.log("log")
				fakeConsole.warn("warn")
				return nil
			end
			function Child:render()
				return nil
			end

			-- ROBLOX deviation: Use createRoot instead of DOM element
			local root = ReactRoblox.createRoot(Instance.new("Frame"))

			act(function()
				return root:render(React.createElement(Parent, nil))
			end)
			jestExpect(mockLog).toHaveBeenCalledTimes(1)
			jestExpect(mockLog.mock.calls[0]).toHaveLength(1)
			jestExpect(mockLog.mock.calls[0][0]).toBe("log")
			jestExpect(mockWarn).toHaveBeenCalledTimes(1)
			jestExpect(mockWarn.mock.calls[0]).toHaveLength(2)
			jestExpect(mockWarn.mock.calls[0][0]).toBe("warn")
			-- ROBLOX TODO: What is printed instead of this?
			jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[0][1])).toEqual(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
			jestExpect(mockError).toHaveBeenCalledTimes(1)
			jestExpect(mockError.mock.calls[0]).toHaveLength(2)
			jestExpect(mockError.mock.calls[0][0]).toBe("error")
			jestExpect(normalizeCodeLocInfo(mockError.mock.calls[0][1])).toBe(
				"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
			)
		end
	)
	xit("should append stacks after being uninstalled and reinstalled", function()
		local Child = function(_ref12)
			local _children = _ref12.children

			fakeConsole.warn("warn")
			fakeConsole.error("error")

			return nil
		end

		unpatchConsole()

		-- ROBLOX deviation: Use createRoot instead of DOM element
		local root = ReactRoblox.createRoot(Instance.new("Frame"))

		act(function()
<<<<<<< HEAD
			return root:render(React.createElement(Child, nil))
		end)
		jestExpect(mockWarn).toHaveBeenCalledTimes(1)
		jestExpect(mockWarn.mock.calls[0]).toHaveLength(1)
		jestExpect(mockWarn.mock.calls[0][0]).toBe("warn")
		jestExpect(mockError).toHaveBeenCalledTimes(1)
		jestExpect(mockError.mock.calls[0]).toHaveLength(1)
		jestExpect(mockError.mock.calls[0][0]).toBe("error")
		patchConsole({
			appendComponentStack = true,
			breakOnWarn = false,
		})
		act(function()
			return root:render(React.createElement(Child, nil))
		end)
		jestExpect(mockWarn).toHaveBeenCalledTimes(2)
		jestExpect(mockWarn.mock.calls[1]).toHaveLength(2)
		jestExpect(mockWarn.mock.calls[1][0]).toBe("warn")
		-- ROBLOX TODO: What is printed instead of this?
		jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[1][1])).toEqual(
			"\n    in Child (at **)"
		)
		jestExpect(mockError).toHaveBeenCalledTimes(2)
		jestExpect(mockError.mock.calls[1]).toHaveLength(2)
		jestExpect(mockError.mock.calls[1][0]).toBe("error")
		jestExpect(normalizeCodeLocInfo(mockError.mock.calls[1][1])).toBe(
			"\n    in Child (at **)"
		)
	end)
	xit("should be resilient to prepareStackTrace", function()
		-- ROBLOX TODO: what is a suitable alternative for this?
		-- Error.prepareStackTrace = function(error, callsites)
		-- 	local stack = {
		-- 		'An error occurred:',
		-- 		error.message,
		-- 	}

		-- 	for i=0, callsites.length - 1 do
		-- 		local callsite = callsites[i]

		-- 		stack.push('\t' + callsite.getFunctionName(), '\t\tat ' + callsite.getFileName(), '\t\ton line ' + callsite.getLineNumber())
		-- 	end

		-- 	return stack.join('\n')
		-- end

		local Intermediate = function(_ref13)
			local children = _ref13.children
			return children
		end
		-- ROBLOX deviation: switched ordering for variable definition order
		local Child = function(_ref15)
			fakeConsole.error("error")
			fakeConsole.log("log")
			fakeConsole.warn("warn")

			return nil
		end
		local Parent = function(_ref14)
			local _children = _ref14.children
			return React.createElement(Intermediate, nil, React.createElement(Child, nil))
		end

		-- ROBLOX deviation: Use createRoot instead of DOM element
		local root = ReactRoblox.createRoot(Instance.new("Frame"))

		act(function()
			return root:render(React.createElement(Parent, nil))
		end)
		jestExpect(mockLog).toHaveBeenCalledTimes(1)
		jestExpect(mockLog.mock.calls[0]).toHaveLength(1)
		jestExpect(mockLog.mock.calls[0][0]).toBe("log")
		jestExpect(mockWarn).toHaveBeenCalledTimes(1)
		jestExpect(mockWarn.mock.calls[0]).toHaveLength(2)
		jestExpect(mockWarn.mock.calls[0][0]).toBe("warn")
		-- ROBLOX TODO: What is printed instead of this?
		jestExpect(normalizeCodeLocInfo(mockWarn.mock.calls[0][1])).toEqual(
			"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
		)
		jestExpect(mockError).toHaveBeenCalledTimes(1)
		jestExpect(mockError.mock.calls[0]).toHaveLength(2)
		jestExpect(mockError.mock.calls[0][0]).toBe("error")
		jestExpect(normalizeCodeLocInfo(mockError.mock.calls[0][1])).toBe(
			"\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)"
		)
=======
			return legacyRender(React.createElement(Parent, nil), document:createElement("div"))
		end)
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toBe("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
	end) -- @reactVersion >=18.0
	it("should correctly log Symbols", function()
		local function Component(ref0)
			local children = ref0.children
			fakeConsole:warn_("Symbol:", Symbol(""))
			return nil
		end
		act(function()
			return legacyRender(React.createElement(Component, nil), document:createElement("div"))
		end)
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("Symbol:")
	end)
	it("should double log if hideConsoleLogsInStrictMode is disabled in Strict mode", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = false
		global.__REACT_DEVTOOLS_HIDE_CONSOLE_LOGS_IN_STRICT_MODE__ = false
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		local function App()
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			fakeConsole:error_("error")
			return React.createElement("div", nil)
		end
		act(function()
			return root:render(React.createElement(React.StrictMode, nil, React.createElement(App, nil)))
		end)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual({
			"%c%s",
			("color: %s"):format(tostring(process.env.DARK_MODE_DIMMED_LOG_COLOR)),
			"log",
		})
		expect(mockWarn).toHaveBeenCalledTimes(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(3)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual({
			"%c%s",
			("color: %s"):format(tostring(process.env.DARK_MODE_DIMMED_WARNING_COLOR)),
			"warn",
		})
		expect(mockError).toHaveBeenCalledTimes(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(3)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual({
			"%c%s",
			("color: %s"):format(tostring(process.env.DARK_MODE_DIMMED_ERROR_COLOR)),
			"error",
		})
	end)
	it("should not double log if hideConsoleLogsInStrictMode is enabled in Strict mode", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = false
		global.__REACT_DEVTOOLS_HIDE_CONSOLE_LOGS_IN_STRICT_MODE__ = true
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		local function App()
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			fakeConsole:error_("error")
			return React.createElement("div", nil)
		end
		act(function()
			return root:render(React.createElement(React.StrictMode, nil, React.createElement(App, nil)))
		end)
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
	end)
	it("should double log in Strict mode initial render for extension", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = false
		global.__REACT_DEVTOOLS_HIDE_CONSOLE_LOGS_IN_STRICT_MODE__ = false -- This simulates a render that happens before React DevTools have finished
		-- their handshake to attach the React DOM renderer functions to DevTools
		-- In this case, we should still be able to mock the console in Strict mode
		global.__REACT_DEVTOOLS_GLOBAL_HOOK__.rendererInterfaces:set(rendererID, nil)
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		local function App()
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			fakeConsole:error_("error")
			return React.createElement("div", nil)
		end
		act(function()
			return root:render(React.createElement(React.StrictMode, nil, React.createElement(App, nil)))
		end)
		expect(mockLog).toHaveBeenCalledTimes(2)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(3)
		expect(mockLog.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual({
			"%c%s",
			("color: %s"):format(tostring(process.env.DARK_MODE_DIMMED_LOG_COLOR)),
			"log",
		})
		expect(mockWarn).toHaveBeenCalledTimes(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(3)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual({
			"%c%s",
			("color: %s"):format(tostring(process.env.DARK_MODE_DIMMED_WARNING_COLOR)),
			"warn",
		})
		expect(mockError).toHaveBeenCalledTimes(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(3)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual({
			"%c%s",
			("color: %s"):format(tostring(process.env.DARK_MODE_DIMMED_ERROR_COLOR)),
			"error",
		})
	end)
	it("should not double log in Strict mode initial render for extension", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = false
		global.__REACT_DEVTOOLS_HIDE_CONSOLE_LOGS_IN_STRICT_MODE__ = true -- This simulates a render that happens before React DevTools have finished
		-- their handshake to attach the React DOM renderer functions to DevTools
		-- In this case, we should still be able to mock the console in Strict mode
		global.__REACT_DEVTOOLS_GLOBAL_HOOK__.rendererInterfaces:set(rendererID, nil)
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		local function App()
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			fakeConsole:error_("error")
			return React.createElement("div", nil)
		end
		act(function()
			return root:render(React.createElement(React.StrictMode, nil, React.createElement(App, nil)))
		end)
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
	end)
	it("should properly dim component stacks during strict mode double log", function()
		global.__REACT_DEVTOOLS_APPEND_COMPONENT_STACK__ = true
		global.__REACT_DEVTOOLS_HIDE_CONSOLE_LOGS_IN_STRICT_MODE__ = false
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		local function Intermediate(ref0)
			local children = ref0.children
			return children
		end
		local function Parent(ref0)
			local children = ref0.children
			return React.createElement(Intermediate, nil, React.createElement(Child, nil))
		end
		local function Child(ref0)
			local children = ref0.children
			fakeConsole:error_("error")
			fakeConsole:warn_("warn")
			return nil
		end
		act(function()
			return root:render(React.createElement(React.StrictMode, nil, React.createElement(Parent, nil)))
		end)
		expect(mockWarn).toHaveBeenCalledTimes(2)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(4)
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual("%c%s %s")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toMatch("color: rgba(")
		expect(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual("warn")
		expect(normalizeCodeLocInfo(mockWarn.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]):trim()).toEqual("in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError).toHaveBeenCalledTimes(2)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(2)
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])).toEqual("\n    in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(4)
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual("%c%s %s")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toMatch("color: rgba(")
		expect(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toEqual("error")
		expect(normalizeCodeLocInfo(mockError.mock.calls[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]):trim()).toEqual("in Child (at **)\n    in Intermediate (at **)\n    in Parent (at **)")
	end)
end)
describe("console error", function()
	beforeEach(function()
		jest.resetModules()
		local Console = require_("react-devtools-shared/src/backend/console")
		patchConsole = Console.patch
		unpatchConsole = Console.unpatch -- Patch a fake console so we can verify with tests below.
		-- Patching the real console is too complicated,
		-- because Jest itself has hooks into it as does our test env setup.
		mockError = jest.fn()
		mockInfo = jest.fn()
		mockLog = jest.fn()
		mockWarn = jest.fn()
		fakeConsole = { error = mockError, info = mockInfo, log = mockLog, warn = mockWarn }
		Console:dangerous_setTargetConsoleForTesting(fakeConsole)
		local inject = global.__REACT_DEVTOOLS_GLOBAL_HOOK__.inject
		global.__REACT_DEVTOOLS_GLOBAL_HOOK__.inject = function(_self: any, internals)
			inject(internals)
			Console:registerRenderer(internals, function()
				error(Error("foo"))
			end)
		end
		React = require_("react")
		ReactDOMClient = require_("react-dom/client")
		local utils = require_("./utils")
		act = utils.act
		legacyRender = utils.legacyRender
	end) -- @reactVersion >=18.0
	it("error in console log throws without interfering with logging", function()
		local container = document:createElement("div")
		local root = ReactDOMClient:createRoot(container)
		local function App()
			fakeConsole:log("log")
			fakeConsole:warn_("warn")
			fakeConsole:error_("error")
			return React.createElement("div", nil)
		end
		patchConsole({
			appendComponentStack = true,
			breakOnConsoleErrors = false,
			showInlineWarningsAndErrors = true,
			hideConsoleLogsInStrictMode = false,
		})
		expect(function()
			act(function()
				root:render(React.createElement(App, nil))
			end)
		end).toThrowError("foo")
		expect(mockLog).toHaveBeenCalledTimes(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockLog.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("log")
		expect(mockWarn).toHaveBeenCalledTimes(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockWarn.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("warn")
		expect(mockError).toHaveBeenCalledTimes(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toHaveLength(1)
		expect(mockError.mock.calls[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]).toBe("error")
>>>>>>> upstream-apply
	end)
end)
