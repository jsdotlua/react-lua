--!strict

--[[
	This file is meant to somehow facilate JS translation of div elements to Roblox.
	It is not API compatible with a `div`.
]]

local Packages = script.Parent.Parent.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local React = require(Packages.React)

type Props = {
	padding: number | UDim | nil,
	xAlignment: Enum.HorizontalAlignment?,
	yAlignment: Enum.VerticalAlignment?,
	direction: Enum.FillDirection?,
	frameProps: {
		ClipsDescendants: boolean?,
		LayoutOrder: number?,
		Visible: boolean,
		[string]: any,
	}?,
	children: { React.Node }?,
}

local function Div(props: Props, ref)
	local direction = props.direction or Enum.FillDirection.Vertical
	local horizontalAlignment = if props.xAlignment == nil then Enum.HorizontalAlignment.Left else props.xAlignment
	local verticalAlignment = if props.yAlignment == nil
		then if direction == Enum.FillDirection.Vertical
			then Enum.VerticalAlignment.Top
			else Enum.VerticalAlignment.Center
		else props.yAlignment
	local padding = if props.padding == nil
		then UDim.new(0, 0)
		elseif type(props.padding) == "number" then UDim.new(0, props.padding)
		else props.padding

	return React.createElement(
		"Frame",
		Object.assign({
			ref = ref,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
		}, props.frameProps),
		React.createElement("UIListLayout", {
			Padding = padding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = direction,
			HorizontalAlignment = horizontalAlignment,
			VerticalAlignment = verticalAlignment,
		}),
		props.children
	)
end

return React.forwardRef(Div)
