--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/portaledContent.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent.Parent.Parent.Parent
local MorePolyfill = require(Packages.MorePolyfill)
local JSON = MorePolyfill.JSON
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

-- import throttle from 'lodash.throttle';

local React = require(Packages.React)
local useContext = React.useContext
local ReactRoblox = require(Packages.ReactRoblox)
local createPortal = ReactRoblox.createPortal
-- import ErrorBoundary from './ErrorBoundary';
local contextModule = require(script.Parent.context)
local StoreContext = contextModule.StoreContext
local Store = require(script.Parent.Parent.store)
type Store = Store.Store

export type Props = { portalContainer: Instance? }

local function portaledContent<P>(
	Component: React.StatelessFunctionalComponent<P>,
	onErrorRetry: ((store: Store) -> ())?
): React.StatelessFunctionalComponent<P & Props>
	local function PortaledContent(props: P & Props)
		local portalContainer = props.portalContainer
		local rest = table.clone(props) :: any
		rest.portalContainer = nil
		local store = useContext(StoreContext)

		-- deviation: todo uncomment error boundary
		local children =
			-- React.createElement(
			-- 	ErrorBoundary,
			-- 	{ store = store, onRetry = onErrorRetry },
			React.createElement(Component, rest)
		-- )

		return if portalContainer ~= nil then createPortal(children, portalContainer) else children
	end

	return PortaledContent
end
exports.default = portaledContent
exports.portaledContent = portaledContent

return exports
