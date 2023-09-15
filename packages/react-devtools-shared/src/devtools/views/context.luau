--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/context.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */
local Packages = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<K> = LuauPolyfill.Array<K>
local exports = {}

local React = require(Packages.React)
local createContext = React.createContext

-- local Store = require(script.Parent.Parent.store)
local devtoolsTypes = require(script.Parent.Parent.types)
type Store = devtoolsTypes.Store

-- deviation: importing DevTools would be a cyclic import, so we inline the
-- `ViewAttributeSource` type here
-- local DevTools = require(script.Parent.DevTools)
-- type ViewAttributeSource = DevTools.ViewAttributeSource
type ViewAttributeSource = (id: number, path: Array<string | number>) -> ()

local bridgeModule = require(script.Parent.Parent.Parent.bridge)
type FrontendBridge = bridgeModule.FrontendBridge

exports.BridgeContext = createContext((nil :: any) :: FrontendBridge)
exports.BridgeContext.displayName = "BridgeContext"

exports.StoreContext = createContext((nil :: any) :: Store)
exports.StoreContext.displayName = "StoreContext"

export type ContextMenuContextType = {
	isEnabledForInspectedElement: boolean,
	viewAttributeSourceFunction: ViewAttributeSource | nil,
}

exports.ContextMenuContext = createContext({
	isEnabledForInspectedElement = false,
	viewAttributeSourceFunction = nil,
})
exports.ContextMenuContext.displayName = "ContextMenuContext"

return exports
