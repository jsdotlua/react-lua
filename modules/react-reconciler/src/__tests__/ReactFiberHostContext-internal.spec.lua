-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/__tests__/ReactFiberHostContext-test.internal.js
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
local Promise = require(Packages.Promise)

<<<<<<< HEAD
local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it

=======
local React
local act
local ReactFiberReconciler
local ConcurrentRoot
local DefaultEventPriority
>>>>>>> upstream-apply
describe("ReactFiberHostContext", function()
	local ReactFiberReconciler
	local ConcurrentRoot
	local React

	beforeEach(function()
		jest.resetModules()
<<<<<<< HEAD
		React = require("@pkg/@jsdotlua/react")
		ReactFiberReconciler = require(".")
		ConcurrentRoot = require("./ReactRootTags")
	end)

	it("works with nil host context", function()
		local creates = 0
		local Renderer = ReactFiberReconciler({
			prepareForCommit = function()
				return nil
			end,
			resetAfterCommit = function() end,
			getRootHostContext = function()
				return nil
			end,
			getChildHostContext = function()
				return nil
			end,
			shouldSetTextContent = function()
				return false
			end,
			createInstance = function()
				creates += 1
			end,
			finalizeInitialChildren = function()
				return nil
			end,
			appendInitialChild = function()
				return nil
			end,
			now = function()
				return 0
			end,
			appendChildToContainer = function()
				return nil
			end,
			clearContainer = function() end,
			supportsMutation = true,
		})

		local container = Renderer.createContainer(
			--[[ root: ]]
			nil,
			ConcurrentRoot,
			false,
			nil
		)
		Renderer.updateContainer(
			React.createElement("a", nil, React.createElement("b")),
			container,
			--[[ parentComponent: ]]
			nil,
			--[[ callback: ]]
			nil
		)

		jestExpect(creates).toBe(2)
	end)

=======
		React = require_("react")
		act = React.unstable_act
		ReactFiberReconciler = require_("react-reconciler")
		ConcurrentRoot = require_("react-reconciler/src/ReactRootTags").ConcurrentRoot
		DefaultEventPriority = require_("react-reconciler/src/ReactEventPriorities").DefaultEventPriority
	end)
	global.IS_REACT_ACT_ENVIRONMENT = true -- @gate __DEV__
	it("works with null host context", function()
		return Promise.resolve():andThen(function()
			local creates = 0
			local Renderer = ReactFiberReconciler({
				prepareForCommit = function(self)
					return nil
				end,
				resetAfterCommit = function(self) end,
				getRootHostContext = function(self)
					return nil
				end,
				getChildHostContext = function(self)
					return nil
				end,
				shouldSetTextContent = function(self)
					return false
				end,
				createInstance = function(self)
					creates += 1
				end,
				finalizeInitialChildren = function(self)
					return nil
				end,
				appendInitialChild = function(self)
					return nil
				end,
				now = function(self)
					return 0
				end,
				appendChildToContainer = function(self)
					return nil
				end,
				clearContainer = function(self) end,
				getCurrentEventPriority = function(self)
					return DefaultEventPriority
				end,
				supportsMutation = true,
			})
			local container = Renderer:createContainer(--[[ root: ]] nil, ConcurrentRoot, nil, false, "", nil)
			act(function()
				Renderer:updateContainer(
					React.createElement("a", nil, React.createElement("b", nil)),
					container, --[[ parentComponent: ]]
					nil, --[[ callback: ]]
					nil
				)
			end)
			expect(creates).toBe(2)
		end)
	end) -- @gate __DEV__
>>>>>>> upstream-apply
	it("should send the context to prepareForCommit and resetAfterCommit", function()
		local rootContext = {}
		local Renderer = ReactFiberReconciler({
			prepareForCommit = function(hostContext)
				jestExpect(hostContext).toBe(rootContext)
				return nil
			end,
			resetAfterCommit = function(hostContext)
				jestExpect(hostContext).toBe(rootContext)
			end,
			getRootHostContext = function()
				return nil
			end,
			getChildHostContext = function()
				return nil
			end,
			shouldSetTextContent = function()
				return false
			end,
			createInstance = function()
				return nil
			end,
			finalizeInitialChildren = function()
				return nil
			end,
			appendInitialChild = function()
				return nil
			end,
			now = function()
				return 0
			end,
			appendChildToContainer = function()
				return nil
			end,
<<<<<<< HEAD
			clearContainer = function() end,
			supportsMutation = true,
		})

		local container =
			Renderer.createContainer(rootContext, ConcurrentRoot, false, nil)
		Renderer.updateContainer(
			React.createElement("a", nil, React.createElement("b")),
			container,
			--[[ parentComponent= ]]
			nil,
			--[[ callback= ]]
			nil
		)
=======
			clearContainer = function(self) end,
			getCurrentEventPriority = function(self)
				return DefaultEventPriority
			end,
			supportsMutation = true,
		})
		local container = Renderer:createContainer(rootContext, ConcurrentRoot, nil, false, "", nil)
		act(function()
			Renderer:updateContainer(
				React.createElement("a", nil, React.createElement("b", nil)),
				container, --[[ parentComponent: ]]
				nil, --[[ callback: ]]
				nil
			)
		end)
>>>>>>> upstream-apply
	end)
end)
