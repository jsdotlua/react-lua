--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Settings/SettingsModalContext.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]
local Packages = script.Parent.Parent.Parent.Parent.Parent

local exports = {}

local React = require(Packages.React)
local createContext = React.createContext
local useMemo = React.useMemo
local useState = React.useState

export type DisplayDensity = "comfortable" | "compact"
export type Theme = "auto" | "light" | "dark"

type Context = {
	isModalShowing: boolean,
	setIsModalShowing: (value: boolean) -> (),
}

local SettingsModalContext = createContext((nil :: any) :: Context)
SettingsModalContext.displayName = "SettingsModalContext"

function SettingsModalContextController(props: { children: React.Node })
	local isModalShowing, setIsModalShowing = useState(false)

	local value = useMemo(function()
		return {
			isModalShowing = isModalShowing,
			setIsModalShowing = setIsModalShowing,
		}
	end, {
		isModalShowing :: any,
		setIsModalShowing,
	})

	return React.createElement(SettingsModalContext.Provider, {
		value = value,
	}, props.children)
end

exports.SettingsModalContext = SettingsModalContext
exports.SettingsModalContextController = SettingsModalContextController

return exports
