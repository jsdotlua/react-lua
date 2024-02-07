-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/__tests__/ReactSymbols-test.internal.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
]]
--!strict

local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local it = JestGlobals.it

-- deviation: This doesn't have any affect for this test
-- beforeEach(() => jest.resetModules());

local function expectToBeUnique(keyValuePairs)
	local map = {}
	for key, value in keyValuePairs do
		if map[value] ~= nil then
			-- ROBLOX TODO: workaround for Luau false positive nil-ability
			error(
				string.format(
					"%s value %s is the same as %s",
					key,
					tostring(value),
					map[value] :: any
				)
<<<<<<< HEAD
			)
=======
			end
			map:set(value, key)
		end) --[[ ROBLOX CHECK: check if 'keyValuePairs' is an Array ]]
	end
	it("Symbol values should be unique", function()
		expectToBeUnique(Object.entries(require_("shared/ReactSymbols")))
	end) -- @gate enableSymbolFallbackForWWW
	it("numeric values should be unique", function()
		local originalSymbolFor = global.Symbol["for"]
		global.Symbol["for"] = nil
		do --[[ ROBLOX COMMENT: try-finally block conversion ]]
			local ok, result, hasReturned = pcall(function()
				local entries = Array.filter(
					Object.entries(require_("shared/ReactSymbols.www")), -- REACT_ASYNC_MODE_TYPE and REACT_CONCURRENT_MODE_TYPE have the same numeric value
					-- for legacy backwards compatibility
					function(ref0)
						local key = ref0[1]
						return key ~= "REACT_ASYNC_MODE_TYPE"
					end
				) --[[ ROBLOX CHECK: check if 'Object.entries(require('shared/ReactSymbols.www'))' is an Array ]]
				expectToBeUnique(entries)
			end)
			do
				global.Symbol["for"] = originalSymbolFor
			end
			if hasReturned then
				return result
			end
			if not ok then
				error(result)
			end
>>>>>>> upstream-apply
		end
		-- ROBLOX TODO: workaround for Luau false positive nil-ability
		map[value] = key :: any
	end
end

-- deviation: Symbol values are not used
it.skip("Symbol values should be unique", function()
	-- expectToBeUnique(require(script.Parent.ReactSymbols));
end)

-- deviation: FIXME: verify that the equivalent legacy numeric values in the
-- commented out portion of this test are actually a thing; they don't seem
-- to exist, so we may be able to update the upstream test and the pull in
-- the simplified logic
it("numeric values should be unique", function()
	-- deviation: We don't use symbol anyways, so it's no use to
	-- override it. We also don't need to filter any values, since
	-- they're internal-only.
	local ReactSymbols = require("./ReactSymbols")
	expectToBeUnique(ReactSymbols)

	-- deviation: We comment out this chunk because we're not actually using
	-- a global `Symbol` definition in the first place, so we don't need to
	-- un-polyfill them

	-- const originalSymbolFor = global.Symbol.for;
	-- global.Symbol.for = null;
	-- try {
	-- 	entries = Object.entries(require('shared/ReactSymbols')).filter(
	-- 		// REACT_ASYNC_MODE_TYPE and REACT_CONCURRENT_MODE_TYPE have the same numeric value
	-- 		// for legacy backwards compatibility
	-- 		([key]) => key !== 'REACT_ASYNC_MODE_TYPE',
	-- 	);
	-- 	expectToBeUnique(entries);
	-- } finally {
	-- 	global.Symbol.for = originalSymbolFor;
	-- }
end)
