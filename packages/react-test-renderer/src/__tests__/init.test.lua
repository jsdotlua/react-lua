-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/setupTests.js
-- Lua TODO: this should be moved into the upstream's scripts location and referenced by a proper jest.config.lua
--[[**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 *
 * LICENSE file in the root directory of this source tree.
 * @flow
 *]]
return function()
	local Packages = script.Parent.Parent.Parent
	local expect = require(Packages.Dev.JestGlobals).expect
	local RobloxJest = require(Packages.Dev.RobloxJest)
	local getTestRendererJestMatchers = require(Packages.Dev.JestReact).getJestMatchers
	local getSchedulerJestMatchers = require(Packages.Scheduler).getJestMatchers

	beforeAll(function()
		expect.extend(getTestRendererJestMatchers(expect))
		expect.extend(getSchedulerJestMatchers(expect))
		expect.extend({
			toErrorDev = RobloxJest.Matchers.toErrorDev,
			toWarnDev = RobloxJest.Matchers.toWarnDev,
		})
	end)
end
