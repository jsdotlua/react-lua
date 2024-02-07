<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/b0cb137bcbd3a11d8eff3c2229cd6b8379d29785/packages/react-reconciler/src/ReactCurrentFiber.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactCurrentFiber.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
<<<<<<< HEAD
]]
local __DEV__ = _G.__DEV__ :: boolean

local ReactInternalTypes = require("./ReactInternalTypes")
type Fiber = ReactInternalTypes.Fiber

local ReactSharedInternals = require("@pkg/@jsdotlua/shared").ReactSharedInternals
local ReactFiberComponentStack = require("./ReactFiberComponentStack")
local getStackByFiberInDevAndProd = ReactFiberComponentStack.getStackByFiberInDevAndProd
local getComponentName = require("@pkg/@jsdotlua/shared").getComponentName

=======
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local exports = {}
local reactInternalTypesModule = require(script.Parent.ReactInternalTypes)
type Fiber = reactInternalTypesModule.Fiber
local ReactSharedInternals = require(Packages.shared.ReactSharedInternals).default
local getStackByFiberInDevAndProd = require(script.Parent.ReactFiberComponentStack).getStackByFiberInDevAndProd
local getComponentNameFromFiber = require(Packages["react-reconciler"].src.getComponentNameFromFiber).default
>>>>>>> upstream-apply
local ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame

-- deviation: Pre-declare type of exports, including values we'll initialize
type Exports = {
	current: Fiber | nil,
	isRendering: boolean,
	-- remaining functions declare their own types
	[string]: any,
}

local exports: Exports = {
	current = nil,
	isRendering = false,
}

exports.getCurrentFiberOwnerNameInDevOrNull = function(): string?
	if __DEV__ then
		if exports.current == nil then
			return nil
		end
<<<<<<< HEAD
		-- ROBLOX FIXME Luau: Luau doesn't understand guard above
		local owner = (exports.current :: Fiber)._debugOwner
		if owner then
			return getComponentName(owner.type)
=======
		local owner = current._debugOwner
		if owner ~= nil and typeof(owner) ~= "undefined" then
			return getComponentNameFromFiber(owner)
>>>>>>> upstream-apply
		end
	end
	return nil
end

local function getCurrentFiberStackInDev(): string
	if __DEV__ then
		if exports.current == nil then
			return ""
		end
		-- Safe because if current fiber exists, we are reconciling,
		-- and it is guaranteed to be the work-in-progress version.
		-- ROBLOX FIXME Luau: Luau doesn't understand guard above
		return getStackByFiberInDevAndProd(exports.current :: Fiber)
	end
	return ""
end

exports.resetCurrentFiber = function(): ()
	if __DEV__ then
		-- ROBLOX FIXME Luau: Expected type table, got 'ReactDebugCurrentFrame | { setExtraStackFrame: () -> () }' instead
		(ReactDebugCurrentFrame :: any).getCurrentStack = nil
		exports.current = nil
		exports.isRendering = false
	end
end
<<<<<<< HEAD

exports.setCurrentFiber = function(fiber: Fiber): ()
	if __DEV__ then
		-- ROBLOX FIXME Luau: Expected type table, got 'ReactDebugCurrentFrame | { setExtraStackFrame: () -> () }' instead
		(ReactDebugCurrentFrame :: any).getCurrentStack = getCurrentFiberStackInDev
		exports.current = fiber
		exports.isRendering = false
	end
end

exports.setIsRendering = function(rendering: boolean): ()
	if __DEV__ then
		exports.isRendering = rendering
=======
exports.resetCurrentFiber = resetCurrentFiber
local function setCurrentFiber(
	fiber: Fiber | nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]]
)
	if Boolean.toJSBoolean(__DEV__) then
		ReactDebugCurrentFrame.getCurrentStack = if fiber == nil then nil else getCurrentFiberStackInDev
		current = fiber
		isRendering = false
	end
end
exports.setCurrentFiber = setCurrentFiber
local function getCurrentFiber(): Fiber | nil --[[ ROBLOX CHECK: verify if `null` wasn't used differently than `undefined` ]]
	if Boolean.toJSBoolean(__DEV__) then
		return current
	end
	return nil
end
exports.getCurrentFiber = getCurrentFiber
local function setIsRendering(rendering: boolean)
	if Boolean.toJSBoolean(__DEV__) then
		isRendering = rendering
>>>>>>> upstream-apply
	end
end

exports.getIsRendering = function(): boolean
	if __DEV__ then
		return exports.isRendering
	end
	return false
end

return exports
