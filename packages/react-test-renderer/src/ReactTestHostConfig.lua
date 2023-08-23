-- upstream: https://github.com/facebook/react/blob/172e89b4bf0ec5ee5738af0156d90b0deef4d494/packages/react-test-renderer/src/ReactTestHostConfig.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
]]

local __DEV__ = _G.__DEV__
local Packages = script.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)

local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
type Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>
type Function = (...any) -> any
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
-- Lua DEVIATION: use mockable console from shared, rather than polyfill
local console = require(Packages.Shared).console

local ReactTypes = require(Packages.Shared)
type ReactFundamentalComponentInstance<T, U> = ReactTypes.ReactFundamentalComponentInstance<T, U>

local ReactSymbols = require(Packages.Shared).ReactSymbols
local REACT_OPAQUE_ID_TYPE = ReactSymbols.REACT_OPAQUE_ID_TYPE

export type Type = string
export type Props = Object
export type Container = {
	children: Array<Instance | TextInstance>,
	createNodeMock: Function,
	tag: "CONTAINER",
}
export type Instance = {
	type: string,
	props: Object,
	isHidden: boolean,
	children: Array<Instance | TextInstance>,
	internalInstanceHandle: Object,
	rootContainerInstance: Container,
	tag: "INSTANCE",
}
export type TextInstance = {
	text: string,
	isHidden: boolean,
	tag: "TEXT",
}
export type HydratableInstance = Instance | TextInstance
export type PublicInstance = Instance | TextInstance
export type HostContext = Object
export type UpdatePayload = Object
-- Unused
-- export type ChildSet = void;

-- Lua FIXME: This typically uses a builtin flowtype called 'TimeoutID', we
-- should find a common solution for polyfill types with Luau
export type TimeoutHandle = any
-- Lua DEVIATION: typed Lua doesn't support numeric literals
export type NoTimeout = number
export type EventResponder = any
export type OpaqueIDType = string | {
	toString: () -> string?, -- Lua deviation: typed Lua can't model `| ()` so make nil-able [sic]
	valueOf: () -> string?, -- Lua deviation: typed Lua can't model `| ()` so make nil-able [sic]
}

export type RendererInspectionConfig = {}

local ReactFiberHostConfig = require(Packages.Shared).ReactFiberHostConfig
local exports = Object.assign(
	{},
	ReactFiberHostConfig.WithNoPersistence,
	ReactFiberHostConfig.WithNoHydration,
	ReactFiberHostConfig.WithNoTestSelectors
) :: { [string]: any }

local NO_CONTEXT = {}
local UPDATE_SIGNAL = {}
-- Lua TODO: use the WeakMap impl in polyfill
local nodeToInstanceMap: { [Object]: Instance? } = {}

if __DEV__ then
	Object.freeze(NO_CONTEXT)
	Object.freeze(UPDATE_SIGNAL)
end

exports.getPublicInstance = function(inst: Instance | TextInstance)
	-- Lua FIXME Luau: Luau should narrow to Instance based on singleton type comparison
	if inst.tag == "INSTANCE" then
		local createNodeMock = (inst :: Instance).rootContainerInstance.createNodeMock
		local mockNode = createNodeMock({
			type = (inst :: Instance).type,
			props = (inst :: Instance).props,
		})
		if type(mockNode) == "table" then
			nodeToInstanceMap[mockNode] = inst :: Instance
		end
		return mockNode
	else
		return inst
	end
end
exports.appendChild = function(parentInstance: Instance | Container, child: Instance | TextInstance): ()
	if __DEV__ then
		if not Array.isArray(parentInstance.children) then
			console.error(
				"An invalid container has been provided. "
					.. "This may indicate that another renderer is being used in addition to the test renderer. "
					.. "(For example, ReactNoop.createPortal inside of a ReactTestRenderer tree.) "
					.. "This is not supported."
			)
		end
	end
	local index = Array.indexOf(parentInstance.children, child)
	if index ~= -1 then
		Array.splice(parentInstance.children, index, 1)
	end
	table.insert(parentInstance.children, child)
end

exports.insertBefore = function(
	parentInstance: Instance | Container,
	child: Instance | TextInstance,
	beforeChild: Instance | TextInstance
): ()
	local index = Array.indexOf(parentInstance.children, child)
	if index ~= -1 then
		Array.splice(parentInstance.children, index, 1)
	end
	local beforeIndex = Array.indexOf(parentInstance.children, beforeChild)
	Array.splice(parentInstance.children, beforeIndex, 0, child)
end

exports.removeChild = function(parentInstance: Instance | Container, child: Instance | TextInstance): ()
	local index = Array.indexOf(parentInstance.children, child)
	Array.splice(parentInstance.children, index, 1)
end

exports.clearContainer = function(container: Container): ()
	Array.splice(container.children, 0)
end

exports.getRootHostContext = function(rootContainerInstance: Container): HostContext
	return NO_CONTEXT
end

exports.getChildHostContext = function(
	parentHostContext: HostContext,
	type: string,
	rootContainerInstance: Container
): HostContext
	return NO_CONTEXT
end

exports.prepareForCommit = function(containerInfo: Container): Object?
	-- noop
	return nil
end

exports.resetAfterCommit = function(containerInfo: Container)
	-- noop
end

exports.createInstance = function(
	type: string,
	props: Props,
	rootContainerInstance: Container,
	hostContext: Object,
	internalInstanceHandle: Object
): Instance
	return {
		type = type,
		props = props,
		isHidden = false,
		children = {},
		internalInstanceHandle = internalInstanceHandle,
		rootContainerInstance = rootContainerInstance,
		tag = "INSTANCE",
	}
end

exports.appendInitialChild = function(parentInstance: Instance, child: Instance | TextInstance)
	local index = Array.indexOf(parentInstance.children, child)
	if index ~= -1 then
		Array.splice(parentInstance.children, index, 1)
	end
	table.insert(parentInstance.children, child)
end

exports.finalizeInitialChildren = function(
	testElement: Instance,
	type_: string,
	props: Props,
	rootContainerInstance: Container,
	hostContext: Object
): boolean
	return false
end

exports.prepareUpdate = function(
	testElement: Instance,
	type: string,
	oldProps: Props,
	newProps: Props,
	rootContainerInstance: Container,
	hostContext: Object
): Object?
	return UPDATE_SIGNAL
end

exports.shouldSetTextContent = function(type: string, props: Props): boolean
	return false
end

exports.createTextInstance = function(
	text: string,
	rootContainerInstance: Container,
	hostContext: Object,
	internalInstanceHandle: Object
): TextInstance
	return {
		text = text,
		isHidden = false,
		tag = "TEXT",
	}
end

exports.isPrimaryRenderer = false
exports.warnsIfNotActing = true

exports.scheduleTimeout = setTimeout
exports.cancelTimeout = clearTimeout
exports.noTimeout = -1

-- -------------------
--     Mutation
-- -------------------

exports.supportsMutation = true

exports.commitUpdate = function(
	instance: Instance,
	updatePayload: { [any]: any },
	type: string,
	oldProps: Props,
	newProps: Props,
	internalInstanceHandle: Object
): ()
	instance.type = type
	instance.props = newProps
end

exports.commitMount = function(instance: Instance, type: string, newProps: Props, internalInstanceHandle: Object)
	-- noop
end

exports.commitTextUpdate = function(textInstance: TextInstance, oldText: string, newText: string)
	textInstance.text = newText
end
exports.appendChildToContainer = exports.appendChild
exports.insertInContainerBefore = exports.insertBefore
exports.removeChildFromContainer = exports.removeChild

exports.hideInstance = function(instance: Instance)
	instance.isHidden = true
end

exports.hideTextInstance = function(textInstance: TextInstance)
	textInstance.isHidden = true
end

exports.unhideInstance = function(instance: Instance, props: Props)
	instance.isHidden = false
end

exports.unhideTextInstance = function(textInstance: TextInstance, text: string)
	textInstance.isHidden = false
end

exports.getInstanceFromNode = function(mockNode: Object): Object?
	local instance = nodeToInstanceMap[mockNode]
	if instance ~= nil then
		return (instance :: Instance).internalInstanceHandle
	end
	return nil
end

local clientId: number = 0
exports.makeClientId = function(): OpaqueIDType
	-- FIXME (Lua): convert to base 36 representation
	-- return result = 'c_' + (clientId++).toString(36)
	local result = "c_" .. clientId
	clientId += 1
	return result
end

exports.makeClientIdInDEV = function(warnOnAccessInDEV: () -> ()): OpaqueIDType
	-- Lua FIXME: convert to base 36 representation
	-- local id = 'c_' + (clientId++).toString(36)
	local id = "c_" .. clientId
	clientId += 1
	return {
		toString = function()
			warnOnAccessInDEV()
			return id
		end,
		valueOf = function()
			warnOnAccessInDEV()
			return id
		end,
	}
end

exports.isOpaqueHydratingObject = function(value: any): boolean
	return type(value) == "table" and value["$$typeof"] == REACT_OPAQUE_ID_TYPE
end

exports.makeOpaqueHydratingObject = function(attemptToReadValue: () -> ()): OpaqueIDType
	return {
		["$$typeof"] = REACT_OPAQUE_ID_TYPE,
		toString = attemptToReadValue,
		valueOf = attemptToReadValue,
	}
end

exports.beforeActiveInstanceBlur = function(internalInstanceHandle: Object)
	-- noop
end

exports.afterActiveInstanceBlur = function()
	-- noop
end

exports.preparePortalMount = function(portalInstance: Instance)
	-- noop
end

exports.prepareScopeUpdate = function(scopeInstance: Object, inst: Object)
	nodeToInstanceMap[scopeInstance] = inst
end

exports.getInstanceFromScope = function(scopeInstance: Object): Object?
	return nodeToInstanceMap[scopeInstance] or nil
end

exports.detachDeletedInstance = function(node: Instance): ()
	-- noop
end

return exports
