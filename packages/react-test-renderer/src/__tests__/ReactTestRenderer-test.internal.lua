-- upstream: https://github.com/facebook/react/blob/16654436039dd8f16a63928e71081c7745872e8f/packages/react-test-renderer/src/__tests__/ReactTestRenderer-test.internal.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 * @jest-environment node
 --]]

--!strict
local Packages = script.Parent.Parent.Parent
local ReactFeatureFlags

local React
local ReactTestRenderer
-- local prettyFormat = require('pretty-format')

local LuaJest

-- Isolate noop renderer
-- local ReactNoop = require(Packages.ReactNoopRenderer)
-- local Scheduler = require(Packages.Scheduler)

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Symbol = LuauPolyfill.Symbol

-- Kind of hacky, but we nullify all the instances to test the tree structure
-- with jasmine's deep equality function, and test the instances separate. We
-- also delete children props because testing them is more annoying and not
-- really important to verify.
local function cleanNodeOrArray(node)
	if not node then
		return
	end
	if Array.isArray(node) then
		-- deviation: for loop in place of forEach()
		for _, v in node do
			cleanNodeOrArray(v)
		end
		return
	end
	if node and node.instance then
		node.instance = nil
	end
	if node and node.props and node.props.children then
		-- eslint-disable-next-line no-unused-vars
		node.props["children"] = nil
	end
	if Array.isArray(node.rendered) then
		-- deviation: for loop in place of forEach()
		for _, v in node.rendered do
			cleanNodeOrArray(v)
		end
	elseif typeof(node.rendered) == "table" then
		cleanNodeOrArray(node.rendered)
	end
end

return function()
	LuaJest = require(Packages.LuaJest)
	local jestExpect = require(Packages.JestGlobals).expect

	describe("ReactTestRenderer", function()
		beforeEach(function()
			LuaJest.resetModules()

			ReactFeatureFlags = require(Packages.Shared).ReactFeatureFlags
			ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback = false

			React = require(Packages.React)
			ReactTestRenderer = require(Packages.ReactTestRenderer)
			-- local prettyFormat = require('pretty-format')
		end)
		it("renders a simple component", function()
			local function Link()
				return React.createElement("a", {
					role = "link",
				})
			end

			local renderer = ReactTestRenderer.create(React.createElement(Link))

			jestExpect(renderer.toJSON()).toEqual({
				type = "a",
				props = {
					role = "link",
				},
				children = nil,
			})
		end)
		it("renders a top-level empty component", function()
			local function Empty()
				return nil
			end

			local renderer = ReactTestRenderer.create(React.createElement(Empty))

			jestExpect(renderer.toJSON()).toEqual(nil)
		end)
		it("exposes a type flag", function()
			local function Link()
				return React.createElement("a", {
					role = "link",
				})
			end

			local renderer = ReactTestRenderer.create(React.createElement(Link))
			local object = renderer.toJSON()
			-- FIXME: needs to stringify $$typeof because Symbol module is reset. Un-stringify once we've found a solution.
			jestExpect(tostring(object["$$typeof"])).toEqual(tostring(Symbol.for_("react.test.json")))

			-- $$typeof should not be enumerable.
			for key, _ in object do
				jestExpect(key).never.toEqual("$$typeof")
			end
		end)
		it("can render a composite component", function()
			local Component = React.Component:extend("Component")

			local Child = function()
				return React.createElement("moo")
			end

			function Component:render()
				return React.createElement("div", {
					className = "purple",
				}, React.createElement(Child, nil))
			end

			local renderer = ReactTestRenderer.create(React.createElement(Component))

			jestExpect(renderer.toJSON()).toEqual({
				type = "div",
				props = {
					className = "purple",
				},
				children = {
					{
						type = "moo",
						props = {},
						children = nil,
					},
				},
			})
		end)
		it("renders some basics with an update", function()
			local renders = 0
			local Component = React.Component:extend("Component")

			local Child = function()
				renders = renders + 1

				return React.createElement("moo")
			end
			local Null = function()
				renders = renders + 1
				return nil
			end

			function Component:init()
				self.state = { x = 3 }
				return
			end
			function Component:render()
				renders = renders + 1

				return React.createElement("div", {
					className = "purple",
				}, self.state.x, React.createElement(Child), React.createElement(Null))
			end
			function Component:componentDidMount()
				self:setState({ x = 7 })
			end

			local renderer = ReactTestRenderer.create(React.createElement(Component))

			jestExpect(renderer.toJSON()).toEqual({
				type = "div",
				props = {
					className = "purple",
				},
				children = {
					"7",
					{
						type = "moo",
						props = {},
						children = nil,
					},
				},
			})
			jestExpect(renders).toEqual(6)
		end)
		it("exposes the instance", function()
			local Mouse = React.Component:extend("Mouse")

			function Mouse:init()
				self.state = {
					mouse = "mouse",
				}
			end
			function Mouse:handleMoose()
				self:setState({
					mouse = "moose",
				})
			end
			function Mouse:render()
				return React.createElement("div", nil, self.state.mouse)
			end

			local renderer = ReactTestRenderer.create(React.createElement(Mouse))
			jestExpect(renderer.toJSON()).toEqual({
				type = "div",
				props = {},
				children = {
					"mouse",
				},
			})

			local mouse = renderer.getInstance()

			mouse:handleMoose()
			jestExpect(renderer.toJSON()).toEqual({
				type = "div",
				children = {
					"moose",
				},
				props = {},
			})
		end)
		it("updates types", function()
			local renderer = ReactTestRenderer.create(React.createElement("div", nil, "mouse"))

			jestExpect(renderer.toJSON()).toEqual({
				type = "div",
				props = {},
				children = {
					"mouse",
				},
			})
			renderer.update(React.createElement("span", nil, "mice"))
			jestExpect(renderer.toJSON()).toEqual({
				type = "span",
				props = {},
				children = {
					"mice",
				},
			})
		end)
		it("gives a ref to native components", function()
			local log = {}

			ReactTestRenderer.create(React.createElement("div", {
				ref = function(r)
					return table.insert(log, r)
				end,
			}))
			jestExpect(log).toEqual({ nil })
		end)
		it("warns correctly for refs on SFCs", function()
			local function Bar()
				return React.createElement("div", nil, "Hello, world")
			end

			local Foo = React.Component:extend("Foo")

			function Foo:render()
				return React.createElement(Bar, {
					ref = React.createRef(),
				})
			end

			local Baz = React.Component:extend("Baz")

			function Baz:render()
				return React.createElement("div", {
					ref = React.createRef(),
				})
			end

			ReactTestRenderer.create(React.createElement(Baz))
			jestExpect(function()
				return ReactTestRenderer.create(React.createElement(Foo))
			end).toErrorDev(
				"Warning: Function components cannot be given refs. Attempts "
					.. "to access this ref will fail. "
					.. "Did you mean to use React.forwardRef()?\n\n"
					.. "Check the render method of `Foo`.\n"
					.. "    in Bar (at **)\n"
					.. "    in Foo (at **)"
			)
		end)
		it("allows an optional createNodeMock function", function()
			local mockDivInstance = {
				appendChild = function() end,
			}
			local mockInputInstance = {
				focus = function() end,
			}
			local mockListItemInstance = {
				click = function() end,
			}
			local mockAnchorInstance = {
				hover = function() end,
			}
			local log = {}

			-- deviation: using createRef in place of string refs
			local bar = React.createRef()
			local Foo = React.Component:extend("Foo")

			function Foo:componentDidMount()
				table.insert(log, bar.current)
			end
			function Foo:render()
				return React.createElement("a", {
					ref = bar,
				}, "Hello, world")
			end

			local function createNodeMock(element)
				if element.type == "div" then
					return mockDivInstance
				elseif element.type == "input" then
					return mockInputInstance
				elseif element.type == "li" then
					return mockListItemInstance
				elseif element.type == "a" then
					return mockAnchorInstance
				else
					return {}
				end
			end

			ReactTestRenderer.create(
				React.createElement("div", {
					ref = function(r)
						return table.insert(log, r)
					end,
				}),
				{ createNodeMock = createNodeMock }
			)
			ReactTestRenderer.create(
				React.createElement("input", {
					ref = function(r)
						return table.insert(log, r)
					end,
				}),
				{ createNodeMock = createNodeMock }
			)
			ReactTestRenderer.create(
				React.createElement(
					"div",
					nil,
					React.createElement(
						"span",
						nil,
						React.createElement(
							"ul",
							nil,
							React.createElement("li", {
								ref = function(r)
									return table.insert(log, r)
								end,
							})
						),
						React.createElement(
							"ul",
							nil,
							React.createElement("li", {
								ref = function(r)
									return table.insert(log, r)
								end,
							}),
							React.createElement("li", {
								ref = function(r)
									return table.insert(log, r)
								end,
							})
						)
					)
				),
				{
					createNodeMock = createNodeMock,
					foobar = true,
				}
			)
			ReactTestRenderer.create(React.createElement(Foo), { createNodeMock = createNodeMock })
			ReactTestRenderer.create(React.createElement("div", {
				ref = function(r)
					return table.insert(log, r)
				end,
			}))
			ReactTestRenderer.create(
				React.createElement("div", {
					ref = function(r)
						return table.insert(log, r)
					end,
				}),
				{}
			)
			jestExpect(log).toEqual({
				mockDivInstance,
				mockInputInstance,
				mockListItemInstance,
				mockListItemInstance,
				mockListItemInstance,
				mockAnchorInstance,
			})
		end)
		it("supports context providers and consumers", function()
			local context = React.createContext("a")
			local Consumer = context.Consumer
			local Provider = context.Provider

			local function Child(props)
				return props.value
			end
			local function App()
				return React.createElement(
					Provider,
					{
						value = "b",
					},
					React.createElement(Consumer, nil, function(value)
						return React.createElement(Child, { value = value })
					end)
				)
			end

			local renderer = ReactTestRenderer.create(React.createElement(App))
			local child = renderer.root:findByType(Child)

			jestExpect(child.children).toEqual({
				"b",
			})
			-- deviation: no need to pretty format
			jestExpect(renderer.toTree()).toEqual({
				instance = nil,
				nodeType = "component",
				props = {},
				rendered = {
					instance = nil,
					nodeType = "component",
					props = {
						value = "b",
					},
					rendered = "b",
					type = Child,
				},
				type = App,
			})
		end)
		it("supports modes", function()
			local function Child(props)
				return props.value
			end
			local function App(props)
				return React.createElement(
					React.StrictMode,
					nil,
					React.createElement(Child, {
						value = props.value,
					})
				)
			end
			local renderer = ReactTestRenderer.create(React.createElement(App, {
				value = "a",
			}))
			local child = renderer.root:findByType(Child)

			jestExpect(child.children).toEqual({
				"a",
			})
			-- deviation: no need to pretty format
			jestExpect(renderer.toTree()).toEqual({
				instance = nil,
				nodeType = "component",
				props = {
					value = "a",
				},
				rendered = {
					instance = nil,
					nodeType = "component",
					props = {
						value = "a",
					},
					rendered = "a",
					type = Child,
				},
				type = App,
			})
		end)
		it("supports forwardRef", function()
			local InnerRefed = React.forwardRef(function(props, ref)
				return React.createElement("div", nil, React.createElement("span", { ref = ref }))
			end)
			local App = React.Component:extend("App")

			function App:render()
				return React.createElement(InnerRefed, {
					ref = function(r)
						self.ref = r
						return
					end,
				})
			end

			local renderer = ReactTestRenderer.create(React.createElement(App))
			local tree = renderer.toTree()

			cleanNodeOrArray(tree)

			-- deviation: no need to pretty format
			jestExpect(tree).toEqual({
				instance = nil,
				nodeType = "component",
				props = {},
				rendered = {
					instance = nil,
					nodeType = "host",
					props = {},
					rendered = {
						{
							instance = nil,
							nodeType = "host",
							props = {},
							rendered = {},
							type = "span",
						},
					},
					type = "div",
				},
				type = App,
			})
		end)
		it('calling findByType() with an invalid component will fall back to "Unknown" for component name', function()
			local App = function()
				return nil
			end
			local renderer = ReactTestRenderer.create(React.createElement(App))
			local NonComponent = {}
			jestExpect(function()
				renderer.root:findByType(NonComponent)
			end).toThrow('No instances found with node type: "Unknown"')
		end)
	end)
end
