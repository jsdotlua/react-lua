-- upstream: https://github.com/facebook/react/blob/9cdf8a99edcfd94d7420835ea663edca04237527/packages/jest-react/src/JestReact.js
--[[*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
*]]

local __DEV__ = _G.__DEV__
local exports = {}
local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object

local ReactSymbols = require(Packages.Shared).ReactSymbols
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
-- Lua TODO: upstream this explicit require, possible with jest 27+
local expect = require(Packages.JestGlobals).expect
-- Lua deviation: hoist decl to match JS visibility
local jsonChildrenToJSXChildren
local jsonChildToJSXChild

local function captureAssertion(fn): { pass: true, message: nil } | { pass: false, message: () -> string }
	-- Trick to use a Jest matcher inside another Jest matcher. `fn` contains an
	-- assertion; if it throws, we capture the error and return it, so the stack
	-- trace presented to the user points to the original assertion in the
	-- test file.
	local ok, result = pcall(fn)

	if not ok then
		-- Lua deviation: The message here will be a string with some extra info
		-- that's not helpful, so we trim it down a bit
		local stringResult = tostring(result)
		local subMessageIndex = string.find(stringResult, " ")
        -- Lua TODO: upstream this assert, it could technically happen and is needed to satisfy strict type checking
		assert(subMessageIndex, "assertion failure error not in expected format")
		local message = string.sub(stringResult, subMessageIndex + 1)

		return {
			pass = false,
			message = function()
				return message
			end,
		}
	end

	return { pass = true }
end

local function assertYieldsWereCleared(root)
	local Scheduler = root._Scheduler
    local actualYields = Scheduler.unstable_clearYields()
    if #actualYields ~= 0 then
        error(Error.new(
            "Log of yielded values is not empty. "
                .. "Call expect(ReactTestRenderer).unstable_toHaveYielded(...) first."),
            3
        )
    end
end

-- Lua TODO: is this missing the matcher's self param?
local function unstable_toMatchRenderedOutput(root, expectedJSX)
	assertYieldsWereCleared(root)
	local actualJSON = root.toJSON()

	local actualJSX
	if actualJSON == nil or type(actualJSON) == "string" then
		actualJSX = actualJSON
	elseif Array.isArray(actualJSON) then
		if #actualJSON == 0 then
			actualJSX = nil
		elseif #actualJSON == 1 then
			actualJSX = jsonChildToJSXChild(actualJSON[1])
		else
			local actualJSXChildren = jsonChildrenToJSXChildren(actualJSON)

			if actualJSXChildren == nil or type(actualJSXChildren) == "string" then
				actualJSX = actualJSXChildren
			else
				actualJSX = {
					["$$typeof"] = REACT_ELEMENT_TYPE,
					type = REACT_FRAGMENT_TYPE,
					key = nil,
					ref = nil,
					props = { children = actualJSXChildren },
					_owner = nil,
					_store = if __DEV__ then {} else nil,
				}
			end
		end
	else
		actualJSX = jsonChildToJSXChild(actualJSON)
	end

	return captureAssertion(function()
		expect(actualJSX).toEqual(expectedJSX)
	end)
end
exports.unstable_toMatchRenderedOutput = unstable_toMatchRenderedOutput

function jsonChildToJSXChild(jsonChild)
	if jsonChild == nil or type(jsonChild) == "string" then
		return jsonChild
	else
		local jsxChildren = jsonChildrenToJSXChildren(jsonChild.children)

		return {
			["$$typeof"] = REACT_ELEMENT_TYPE,
			type = jsonChild.type,
			key = nil,
			ref = nil,
			props = if jsxChildren == nil
				then jsonChild.props
				else Object.assign({ children = jsxChildren }, jsonChild.props),
			_owner = nil,
			_store = if __DEV__ then {} else nil,
		}
	end
end

function jsonChildrenToJSXChildren(jsonChildren)
	if jsonChildren ~= nil then
		if #jsonChildren == 1 then
			return jsonChildToJSXChild(jsonChildren[1])
		elseif #jsonChildren > 1 then
			local jsxChildren = {}
			local allJSXChildrenAreStrings = true
			local jsxChildrenString = ""

			for _, jsonChild in jsonChildren do
				local jsxChild = jsonChildToJSXChild(jsonChild)

				table.insert(jsxChildren, jsxChild)

				if allJSXChildrenAreStrings then
					if type(jsxChild) == "string" then
						jsxChildrenString ..= jsxChild
					elseif jsxChild ~= nil then
						allJSXChildrenAreStrings = false
					end
				end
			end

			return if allJSXChildrenAreStrings then jsxChildrenString else jsxChildren
		end
	end

	return nil
end

return {
	toMatchRenderedOutput = unstable_toMatchRenderedOutput,
}
