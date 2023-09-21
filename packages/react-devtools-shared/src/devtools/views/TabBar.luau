--!strict
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
local Array = LuauPolyfill.Array
type Array<K> = LuauPolyfill.Array<K>
local exports = {}

local Text = require(script.Parent.roblox.Text)

local React = require(Packages.React)
local Fragment = React.Fragment
local useCallback = React.useCallback

-- import Tooltip from '@reach/tooltip';
-- import Icon from './Icon';

-- import styles from './TabBar.css';
-- import tooltipStyles from './Tooltip.css';

-- import type {IconType} from './Icon';

export type TabInfo = {
	--   icon: IconType,
	id: string,
	label: string,
	title: string?,
}

export type Props = {
	currentTab: any,
	disabled: boolean?,
	id: string,
	selectTab: (tabID: any) -> (),
	tabs: Array<TabInfo>,
	type: "navigation" | "profiler" | "settings",
	-- deviation: Roblox view props
	startOrderAt: number?,
}

local function TabBar(props: Props)
	local currentTab = props.currentTab
	local disabled = if props.disabled == nil then false else props.disabled
	local id = props.id
	local selectTab = props.selectTab
	local tabs = props.tabs
	local type = props.type
	local startOrderAt = props.startOrderAt or 0

	-- deviation: wrap side-effects in useEffect
	local oneSelected = Array.some(tabs, function(tab)
		return tab.id == currentTab
	end)
	React.useEffect(function()
		if not oneSelected then
			selectTab(tabs[1].id)
		end
	end, { oneSelected })

	local onChange = useCallback(function(payload)
		local currentTarget = payload.currentTarget
		return selectTab(currentTarget.value)
	end, { selectTab })

	local handleKeyDown = useCallback(function(event)
		-- switch (event.key) {
		--   case 'ArrowDown':
		--   case 'ArrowLeft':
		--   case 'ArrowRight':
		--   case 'ArrowUp':
		--     event.stopPropagation();
		--     break;
		--   default:
		--     break;
		-- }
	end, {})

	-- local iconSizeClassName
	-- local tabLabelClassName
	-- local tabSizeClassName
	-- if type == "navigation" then
	-- 	iconSizeClassName = styles.IconSizeNavigation
	-- 	tabLabelClassName = styles.TabLabelNavigation
	-- 	tabSizeClassName = styles.TabSizeNavigation
	-- elseif type == "profiler" then
	-- 	iconSizeClassName = styles.IconSizeProfiler
	-- 	tabLabelClassName = styles.TabLabelProfiler
	-- 	tabSizeClassName = styles.TabSizeProfiler
	-- elseif type == "settings" then
	-- 	iconSizeClassName = styles.IconSizeSettings
	-- 	tabLabelClassName = styles.TabLabelSettings
	-- 	tabSizeClassName = styles.TabSizeSettings
	-- else
	-- 	error(Error.new(`Unsupported type "{type}"`))
	-- end

	return React.createElement(
		Fragment,
		nil,
		Array.map(tabs, function(tab: TabInfo, index: number): any
			-- local icon = tab.icon
			local id = tab.id
			local label = tab.label
			-- local title = tab.title

			local button = React.createElement(Text, {
				-- className = table.concat({
				-- 	tabSizeClassName,
				-- 	if disabled then styles.TabDisabled else styles.Tab,
				-- 	if not disabled and currentTab == id then styles.TabCurrent else "",
				-- }, " "),
				key = id,
				-- onKeyDown={handleKeyDown},
				onMouseDown = function()
					-- deviation: check if disabled
					if not disabled then
						selectTab(id)
					end
				end,
				-- <input
				--   type="radio"
				--   className={styles.Input}
				--   checked={currentTab === id}
				--   disabled={disabled}
				--   name={groupName}
				--   value={id}
				--   onChange={onChange}
				-- />
				-- <Icon
				--   className={`${
				--     disabled ? styles.IconDisabled : ''
				--   } ${iconSizeClassName}`}
				--   type={icon}
				-- />
				-- <span className={tabLabelClassName}>{label}</span>
				text = label,
				frameProps = {
					LayoutOrder = index + startOrderAt,
				},
			})

			-- if title then
			-- 	button = React.createElement(Tooltip, {
			-- 		key = id,
			-- 		-- className = tooltipStyles.Tooltip,
			-- 		label = title,
			-- 	}, button)
			-- end

			return button
		end)
	)
end
exports.TabBar = TabBar
exports.default = TabBar

return exports
