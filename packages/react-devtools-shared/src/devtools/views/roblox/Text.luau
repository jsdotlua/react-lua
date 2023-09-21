--!strict

--[[
	This file is meant to somehow facilate JS translation of span elements to Roblox.
	It is not API compatible with a `span`.
]]
local TextService = game:GetService("TextService")

local Packages = script.Parent.Parent.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

type Props = {
	name: string?,
	text: string,
	fontSize: number?,
	expand: boolean?,
	onMouseDown: (() -> ())?,
	disabled: boolean?,
	frameProps: {
		LayoutOrder: number?,
		[string]: any,
	}?,
}

local function Text(props: Props, ref)
	local isButton = props.onMouseDown ~= nil
	local expand = if props.expand == nil then true else props.expand

	local text = props.text

	local font = Enum.Font.Arial
	local fontSize = if props.fontSize == nil then 12 else props.fontSize

	local padding = 6

	local textSize = React.useMemo(function()
		return TextService:GetTextSize(text, fontSize, font, Vector2.new(math.huge, math.huge))
			+ 2 * Vector2.new(padding, padding)
	end, { text })

	return React.createElement(
		if isButton then "TextButton" else "TextLabel",
		Object.assign({
			ref = ref,
			Name = props.name,
			AutoButtonColor = if isButton then not props.disabled else nil,
			BackgroundTransparency = if isButton then 0.5 else 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, if expand then 1 else 0, 0),
			TextSize = fontSize,
			Font = font,
			Text = text,
			AutomaticSize = if expand then Enum.AutomaticSize.X else Enum.AutomaticSize.XY,
			TextWrapped = true,
			[ReactRoblox.Event.Activated] = if not props.disabled then props.onMouseDown else nil,
		}, props.frameProps),
		React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, padding),
			PaddingRight = UDim.new(0, padding),
			PaddingTop = UDim.new(0, padding),
			PaddingBottom = UDim.new(0, padding),
		}),
		React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(textSize.X, if expand then math.huge else textSize.Y),
			MinSize = textSize,
		})
	)
end

return React.forwardRef(Text)
