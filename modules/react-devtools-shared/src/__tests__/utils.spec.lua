-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/events-test.js
-- /*
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */
return function()
	local Packages = script.Parent.Parent.Parent
	local jest = require(Packages.Dev.JestRoblox)
	local jestExpect = jest.Globals.expect
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Symbol = LuauPolyfill.Symbol

	local utils = require(script.Parent.Parent.utils)
	local getDisplayName = utils.getDisplayName
	local getDisplayNameForReactElement = utils.getDisplayNameForReactElement
	local ReactSymbols = require(Packages.Shared).ReactSymbols
	local SuspenseList = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
	local StrictMode = ReactSymbols.REACT_STRICT_MODE_TYPE
	local React = require(Packages.React)
	local createElement = React.createElement

	describe("utils", function()
		describe("getDisplayName", function()
			it("should return a function name", function()
				local function FauxComponent() end

				jestExpect(getDisplayName(FauxComponent)).toEqual("FauxComponent")
			end)

			it("should return a displayName name if specified", function()
				local FauxComponent = {}

				FauxComponent.displayName = "OverrideDisplayName"

				jestExpect(getDisplayName(FauxComponent)).toEqual("OverrideDisplayName")
			end)

			it("should return the fallback for anonymous functions", function()
				jestExpect(getDisplayName(function() end, "Fallback")).toEqual("Fallback")
			end)

			it(
				"should return Anonymous for anonymous functions without a fallback",
				function()
					jestExpect(getDisplayName(function() end)).toEqual("Anonymous")
				end
			)

			-- Simulate a reported bug:
			-- https://github.com/facebook/react/issues/16685
			it("should return a fallback when the name prop is not a string", function()
				local FauxComponent = { name = {} }
				jestExpect(getDisplayName(FauxComponent, "Fallback")).toEqual("Fallback")
			end)
		end)
		describe("getDisplayNameForReactElement", function()
			-- ROBLOX deviation: Lua can't put fields on functions
			xit(
				"should return correct display name for an element with function type",
				function()
					local function FauxComponent() end

					-- FauxComponent.displayName = 'OverrideDisplayName'

					local element = createElement(FauxComponent)

					jestExpect(getDisplayNameForReactElement(element)).toEqual(
						"OverrideDisplayName"
					)
				end
			)

			it(
				"should return correct display name for an element with a type of StrictMode",
				function()
					local element = createElement(StrictMode)

					jestExpect(getDisplayNameForReactElement(element)).toEqual(
						"StrictMode"
					)
				end
			)

			it(
				"should return correct display name for an element with a type of SuspenseList",
				function()
					local element = createElement(SuspenseList)

					jestExpect(getDisplayNameForReactElement(element)).toEqual(
						"SuspenseList"
					)
				end
			)

			it(
				"should return NotImplementedInDevtools for an element with invalid symbol type",
				function()
					local element = createElement(Symbol("foo"))

					jestExpect(getDisplayNameForReactElement(element)).toEqual(
						"NotImplementedInDevtools"
					)
				end
			)

			it(
				"should return NotImplementedInDevtools for an element with invalid type",
				function()
					local element = createElement(true)

					jestExpect(getDisplayNameForReactElement(element)).toEqual(
						"NotImplementedInDevtools"
					)
				end
			)

			it("should return Element for null type", function()
				local element = createElement()

				jestExpect(getDisplayNameForReactElement(element)).toEqual("Element")
			end)
		end)
	end)
end
