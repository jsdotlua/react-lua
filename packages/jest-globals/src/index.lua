-- upstream: https://github.com/facebook/jest/blob/v27.4.7/packages/jest-globals/src/index.ts
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  */

local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error

local JestEnvironment = require(Packages.JestEnvironment)
type Jest = JestEnvironment.Jest
local importedExpect = require(Packages.Expect)

-- deviation START: additional imports
local jestTypesModule = require(Packages.JestTypes)
type TestFrameworkGlobals = jestTypesModule.Global_TestFrameworkGlobals

local ExpectModule = require(Packages.Expect)
type MatcherState = ExpectModule.MatcherState
type ExpectExtended<E, State = MatcherState> = ExpectModule.ExpectExtended<E, State>
-- deviation END

type JestGlobals =
	{
		jest: Jest,
		expect: typeof(importedExpect),
		expectExtended: ExpectExtended<{ [string]: (...any) -> nil }>,
	}
	-- deviation START: using TestFrameworkGlobals instead of declaring variables one by one
	& TestFrameworkGlobals
-- deviation END

error(Error.new(
	-- deviation START: aligned message to make sense for jest-lua
	"Do not import `JestGlobals` outside of the Jest test environment"
	-- deviation END
))

return ({} :: any) :: JestGlobals
