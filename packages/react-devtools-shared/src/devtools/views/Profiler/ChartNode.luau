--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/ChartNode.js
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
local ReactRoblox = require(Packages.ReactRoblox)

-- import styles from './ChartNode.css';

type SyntheticMouseEvent = any

type Props = {
	--   color: string,
	color: Color3,
	height: number,
	isDimmed: boolean?,
	label: string,
	onClick: (event: SyntheticMouseEvent) -> (),
	onDoubleClick: ((event: SyntheticMouseEvent) -> ())?,
	onMouseEnter: (event: SyntheticMouseEvent) -> (),
	onMouseLeave: (event: SyntheticMouseEvent) -> (),
	placeLabelAboveNode: boolean?,
	-- deviation: pass textColor directly instead
	textColor: Color3,
	width: number,
	x: number,
	-- y: number,
}

local minWidthToDisplay = 35

local function ChartNode(props: Props)
	local color = props.color
	local height = props.height
	local isDimmed = if props.isDimmed == nil then false else props.isDimmed
	local label = props.label
	local onClick = props.onClick
	local onMouseEnter = props.onMouseEnter
	local onMouseLeave = props.onMouseLeave
	local onDoubleClick = props.onDoubleClick
	-- deviation: pass textColor directly instead
	local textColor = props.textColor
	local width = props.width
	local x = props.x
	-- local y = props.y

	if onDoubleClick ~= nil then
		warn("todo: double click not supported")
	end

	return React.createElement("TextButton", {
		Name = label,
		BackgroundColor3 = color,
		TextColor3 = textColor,
		BackgroundTransparency = if isDimmed then 0.5 else 0,
		Text = label,
		Size = UDim2.new(width, 0, 0, height),
		LayoutOrder = x,
		-- Position = UDim2.new(0, 0, 0, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		[ReactRoblox.Event.MouseEnter] = onMouseEnter,
		[ReactRoblox.Event.MouseLeave] = onMouseLeave,
		[ReactRoblox.Event.MouseButton1Click] = onClick,
	})

	--   return (
	--     <g className={styles.Group} transform={`translate(${x},${y})`}>
	--       <rect
	--         width={width}
	--         height={height}
	--         fill={color}
	--         onClick={onClick}
	--         onMouseEnter={onMouseEnter}
	--         onMouseLeave={onMouseLeave}
	--         onDoubleClick={onDoubleClick}
	--         className={styles.Rect}
	--         style={{
	--           opacity: isDimmed ? 0.5 : 1,
	--         }}
	--       />
	--       {width >= minWidthToDisplay && (
	--         <foreignObject
	--           width={width}
	--           height={height}
	--           className={styles.ForeignObject}
	--           style={{
	--             paddingLeft: x < 0 ? -x : 0,
	--             opacity: isDimmed ? 0.75 : 1,
	--             display: width < minWidthToDisplay ? 'none' : 'block',
	--           }}
	--           y={0}>
	--           <div className={styles.Div} style={textStyle}>
	--             {label}
	--           </div>
	--         </foreignObject>
	--       )}
	--     </g>
	--   );
end
exports.ChartNode = ChartNode
exports.default = ChartNode

return exports
