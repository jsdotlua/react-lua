<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/a9b035b0c2b8235405835beca0c4db2cc37f18d0/packages/shared/shallowEqual.js
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/shallowEqual.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
<<<<<<< HEAD
 *
]]
local is = require("./objectIs")

=======
 * @flow
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local exports = {}
local is = require(script.Parent.objectIs).default
local hasOwnProperty = require(script.Parent.hasOwnProperty).default
>>>>>>> upstream-apply
--[[*
 * Performs equality by iterating through keys on an object and returning false
 * when any key has values which are not strictly equal between the arguments.
 * Returns true when the values of all keys are strictly equal.
]]
local function shallowEqual(objA, objB)
	if is(objA, objB) then
		return true
	end

	if
		typeof(objA) ~= "table"
		or objA == nil
		or typeof(objB) ~= "table"
		or objB == nil
	then
		return false
	end
<<<<<<< HEAD

	-- deviation: `Object.keys` does not have an equivalent in Lua, so we
	-- iterate through each table instead
	for key, value in objA do
		if not is(objB[key], value) then
			return false
=======
	local keysA = Object.keys(objA)
	local keysB = Object.keys(objB)
	if keysA.length ~= keysB.length then
		return false
	end -- Test for A's keys different from B.
	do
		local i = 0
		while
			i
			< keysA.length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local currentKey = keysA[tostring(i)]
			if
				not Boolean.toJSBoolean(hasOwnProperty(objB, currentKey))
				or not Boolean.toJSBoolean(is(objA[tostring(currentKey)], objB[tostring(currentKey)]))
			then
				return false
			end
			i += 1
>>>>>>> upstream-apply
		end
	end

	for key, value in objB do
		if not is(objA[key], value) then
			return false
		end
	end

	return true
end

return shallowEqual
