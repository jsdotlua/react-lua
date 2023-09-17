--!strict

--[[
	This file is meant to somehow facilate JS translation of span elements to Roblox.
	It is not API compatible with a `span`.
]]

local Packages = script.Parent.Parent.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

type Props = {
	text: string,
	expand: boolean?,
	onMouseDown: (() -> ())?,
	frameProps: {
		LayoutOrder: number?,
		[string]: any,
	}?,
}

local function Text(props: Props, ref)
	local isButton = props.onMouseDown ~= nil
	local expand = if props.expand == nil then true else props.expand
	return React.createElement(
		if isButton then "TextButton" else "TextLabel",
		Object.assign({
			ref = ref,
			AutoButtonColor = if isButton then true else nil,
			BackgroundTransparency = if isButton then 0.5 else 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, if expand then 1 else 0, 0),
			Text = props.text,
			AutomaticSize = if expand then Enum.AutomaticSize.X else Enum.AutomaticSize.XY,
			TextWrapped = true,
			[ReactRoblox.Event.Activated] = props.onMouseDown,
		}, props.frameProps),
		React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
		})
	)
end

return React.forwardRef(Text)
