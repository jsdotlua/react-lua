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
local LuauPolyfill = require(Packages.LuauPolyfill)
type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local useCallback = React.useCallback
local useContext = React.useContext
local useMemo = React.useMemo
local useRef = React.useRef

local useSubscription = require(script.Parent.Parent.hooks).useSubscription
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext
local ProfilerContextModule = require(script.Parent.Parent.Profiler.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext

--  import styles from './SettingsShared.css';

local function ProfilerSettings(_: {})
	local profilerValue = useContext(ProfilerContext)
	local isCommitFilterEnabled = profilerValue.isCommitFilterEnabled
	local minCommitDuration = profilerValue.minCommitDuration
	local setIsCommitFilterEnabled = profilerValue.setIsCommitFilterEnabled
	local setMinCommitDuration = profilerValue.setMinCommitDuration
	local store = useContext(StoreContext)

	local recordChangeDescriptionsSubscription = useMemo(function()
		return {
			getCurrentValue = function()
				return store:getRecordChangeDescriptions()
			end,
			subscribe = function(callback: () -> ())
				store:addListener("recordChangeDescriptions", callback)
				return function()
					return store:removeListener("recordChangeDescriptions", callback)
				end
			end,
		}
	end, { store })

	local recordChangeDescriptions = useSubscription(recordChangeDescriptionsSubscription)

	local updateRecordChangeDescriptions = useCallback(function(checked: boolean)
		-- local currentTarget = info.currentTarget
		store:setRecordChangeDescriptions(checked)
	end, { store })
	-- local updateMinCommitDuration = useCallback(function(event: SyntheticEvent<HTMLInputElement>)
	-- 	local newValue = parseFloat(event.currentTarget.value)
	-- 	setMinCommitDuration(Number.isNaN(newValue) or if newValue <= 0 then 0 else newValue)
	-- end, { setMinCommitDuration })

	-- deviation: re-order minCommitDurationInputRef
	local minCommitDurationInputRef = useRef(nil :: HTMLInputElement | nil)

	local updateIsCommitFilterEnabled = useCallback(function(event: SyntheticEvent<HTMLInputElement>)
		local checked = event.currentTarget.checked
		setIsCommitFilterEnabled(checked)
		if checked then
			if minCommitDurationInputRef.current ~= nil then
				minCommitDurationInputRef.current.focus()
			end
		end
	end, { setIsCommitFilterEnabled })

	return React.createElement(
		Div,
		{
			name = "profiler-settings",
			direction = Enum.FillDirection.Vertical,
		},
		React.createElement(
			Div,
			{
				name = "record-change-descriptions",
				direction = Enum.FillDirection.Horizontal,
				frameProps = { AutomaticSize = Enum.AutomaticSize.Y },
			},
			React.createElement(Text, {
				expand = false,
				text = tostring(recordChangeDescriptions),
				onMouseDown = function()
					updateRecordChangeDescriptions(not recordChangeDescriptions)
				end,
			}),
			React.createElement(Text, {
				expand = false,
				text = "Record why each component rendered while profiling.",
			})
		)
	)
	--    return (
	--      <div className={styles.Settings}>
	--        <div className={styles.Setting}>
	--          <label>
	--            <input
	--              type="checkbox"
	--              checked={recordChangeDescriptions}
	--              onChange={updateRecordChangeDescriptions}
	--            />{' '}
	--            Record why each component rendered while profiling.
	--          </label>
	--        </div>

	--        <div className={styles.Setting}>
	--          <label>
	--            <input
	--              checked={isCommitFilterEnabled}
	--              onChange={updateIsCommitFilterEnabled}
	--              type="checkbox"
	--            />{' '}
	--            Hide commits below
	--          </label>{' '}
	--          <input
	--            className={styles.Input}
	--            onChange={updateMinCommitDuration}
	--            ref={minCommitDurationInputRef}
	--            type="number"
	--            value={minCommitDuration}
	--          />{' '}
	--          (ms)
	--        </div>
	--      </div>
	--    );
end
exports.ProfilerSettings = ProfilerSettings
exports.default = ProfilerSettings

return exports
