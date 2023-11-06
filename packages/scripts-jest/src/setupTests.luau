-- Lua upstream: https://github.com/facebook/react/blob/69060e1da6061af845162dcf6854a5d9af28350a/scripts/jest/setupTests.js
--!strict
local LuauPolyfill = require(Pacakges.LuauPolyfill)
local Object = LuauPolyfill.Object

-- Lua TODO: upstream this explicit require, supported by jest 27+
local expect = require(Packages.JestGlobals).expect

expect.extend(
	Object.assign(
		table.clone(require(script.Parent.matchers.reactTestMatchers)),
		require(script.Parent.matchers.toThrow),
		require(script.Parent.matchers.toWarnDev)
	)
)

-- Lua TODO: put console patching in here
