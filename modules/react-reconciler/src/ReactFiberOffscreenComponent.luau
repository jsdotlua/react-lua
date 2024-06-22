-- ROBLOX upstream: https://github.com/facebook/react/blob/1faf9e3dd5d6492f3607d5c721055819e4106bc6/packages/react-reconciler/src/ReactFiberOffscreenComponent.js
--!strict
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local ReactTypes = require("@pkg/@jsdotlua/shared")
type ReactNodeList = ReactTypes.ReactNodeList

local ReactFiberLanes = require("./ReactFiberLane")
type Lanes = ReactFiberLanes.Lanes

export type OffscreenProps = {
	-- TODO: Pick an API before exposing the Offscreen type. I've chosen an enum
	-- for now, since we might have multiple variants. For example, hiding the
	-- content without changing the layout.
	--
	-- Default mode is visible. Kind of a weird default for a component
	-- called "Offscreen." Possible alt: <Visibility />?
	mode: string | nil,
	children: ReactNodeList,
}

-- We use the existence of the state object as an indicator that the component
-- is hidden.
export type OffscreenState = {
	-- TODO: This doesn't do anything, yet. It's always NoLanes. But eventually it
	-- will represent the pending work that must be included in the render in
	-- order to unhide the component.
	baseLanes: Lanes,
}

return {}
