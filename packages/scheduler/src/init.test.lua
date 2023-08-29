-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/setupTests.js
--[[**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 *
 * LICENSE file in the root directory of this source tree.
 * @flow
 *]]
return function()
	local Packages = script.Parent.Parent
	local LuaJest = require(Packages.LuaJest)
	local expect = require(Packages.JestGlobals).expect
	local getJestMatchers = require(script.Parent.getJestMatchers)

	beforeAll(function()
		expect.extend(getJestMatchers(expect))
		expect.extend(LuaJest.Matchers)
	end)
end
