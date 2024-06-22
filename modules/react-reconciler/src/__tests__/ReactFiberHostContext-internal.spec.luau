-- ROBLOX upstream: https://github.com/facebook/react/blob/ea2af878cc3fb139b0e08cf9bc4b2f4178429d69/packages/react-reconciler/src/__tests__/ReactFiberHostContext-test.internal.js
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
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it

describe("ReactFiberHostContext", function()
	local ReactFiberReconciler
	local ConcurrentRoot
	local React

	beforeEach(function()
		jest.resetModules()
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
	end)
end)
