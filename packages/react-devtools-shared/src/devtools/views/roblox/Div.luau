--!strict

--[[
	This file is meant to somehow facilate JS translation of div elements to Roblox.
	It is not API compatible with a `div`.
]]

local Packages = script.Parent.Parent.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

type Props = {
	name: string?,
	padding: number | UDim | nil,
	xAlignment: Enum.HorizontalAlignment?,
	yAlignment: Enum.VerticalAlignment?,
	direction: Enum.FillDirection?,
	maxWidth: number?,
	minWidth: number?,
	maxHeight: number?,
	minHeight: number?,
	order: number?,
	onClick: () -> (),
	frameProps: {
		ClipsDescendants: boolean?,
		LayoutOrder: number?,
		Visible: boolean,
		[string]: any,
	}?,
	layoutProps: {
		HorizontalAlignment: Enum.HorizontalAlignment?,
		VerticalAlignment: Enum.VerticalAlignment?,
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
	local onClick = props.onClick

	return React.createElement(
		if onClick then "TextButton" else "Frame",
		Object.assign(
			{
				ref = ref,
				Name = props.name,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				LayoutOrder = props.order,
			},
			if onClick
				then {
					AutoButtonColor = false,
					Text = "",
					[ReactRoblox.Event.Activated] = onClick,
				}
				else {},
			props.frameProps
		),
		React.createElement(
			"UIListLayout",
			Object.assign({
				Name = "list-layout-" .. string.lower(direction.Name),
				Padding = padding,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = direction,
				HorizontalAlignment = horizontalAlignment,
				VerticalAlignment = verticalAlignment,
			}, props.layoutProps)
		),
		if props.maxWidth
				or props.minWidth
				or props.maxHeight
				or props.minHeight
			then React.createElement("UISizeConstraint", {
				Name = "size-constraint",
				MaxSize = Vector2.new(props.maxWidth or math.huge, props.maxHeight or math.huge),
				MinSize = Vector2.new(props.minWidth or 0, props.minHeight or 0),
			})
			else nil,
		props.children
	)
end

return React.forwardRef(Div)
