local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Error = LuauPolyfill.Error
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local it = JestGlobals.it
local jest = JestGlobals.jest
local ReactInternalTypes = require("./ReactInternalTypes")
type Fiber = ReactInternalTypes.Fiber

local ReactFiberComponentStack

describe("ReactFiberComponentStack", function()
	beforeEach(function()
		jest.resetModules()
		ReactFiberComponentStack = require("./ReactFiberComponentStack")
	end)

	it("given a nil fiber then it gives correct error message", function()
		local message =
			ReactFiberComponentStack.getStackByFiberInDevAndProd((nil :: any) :: Fiber)
		jestExpect(message).toContain("attempt to index nil")
	end)

	it("given a fiber that throws Error then it gives correct error message", function()
		local throwingFiber = {}
		setmetatable(throwingFiber, {
			__index = function(t, k)
				if k == "tag" then
					error(Error.new("this was an error object in a spec file"))
				end
				return nil
			end,
		})

		local message = ReactFiberComponentStack.getStackByFiberInDevAndProd(
			(throwingFiber :: any) :: Fiber
		)
		jestExpect(message).toContain("this was an error object in a spec file")
	end)

	it(
		"given a fiber that throws a non-Error table then it gives correct error message",
		function()
			local customErrorTable = {}
			setmetatable(customErrorTable, {
				__tostring = function(t, k)
					return "this was a custom __tostring"
				end,
			})

			local throwingFiber = {}
			setmetatable(throwingFiber, {
				__index = function(t, k)
					if k == "tag" then
						error(customErrorTable)
					end
					return nil
				end,
			})

			local message = ReactFiberComponentStack.getStackByFiberInDevAndProd(
				(throwingFiber :: any) :: Fiber
			)
			jestExpect(message).toContain("this was a custom __tostring")
		end
	)
end)
