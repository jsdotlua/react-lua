--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/SideBarCommitInfo.js
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
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map

type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local Fragment = React.Fragment
local useContext = React.useContext
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext

local utilsModule = require(script.Parent.utils)
local formatDuration = utilsModule.formatDuration
local formatTime = utilsModule.formatTime
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext

-- local styles = require(script.Parent.SidebarCommitInfo.css)

export type Props = {}

local function SidebarCommitInfo(_: Props)
	local profilerValue = useContext(ProfilerContext)
	local selectedCommitIndex = profilerValue.selectedCommitIndex
	local rootID = profilerValue.rootID
	local selectInteraction = profilerValue.selectInteraction
	local selectTab = profilerValue.selectTab

	local profilerStore = useContext(StoreContext):getProfilerStore()

	if rootID == nil or selectedCommitIndex == nil then
		return React.createElement(Text, { text = "Nothing selected", expand = true })
	end

	local interactions = profilerStore:getDataForRoot(rootID).interactions
	local commitData = profilerStore:getCommitData(rootID, selectedCommitIndex)
	local duration = commitData.duration
	local interactionIDs = commitData.interactionIDs
	local priorityLevel = commitData.priorityLevel
	local timestamp = commitData.timestamp

	-- local function viewInteraction(interactionID)
	-- 	selectTab("interactions")
	-- 	selectInteraction(interactionID)
	-- end

	return React.createElement(
		Fragment,
		{},
		React.createElement(Text, {
			text = "Commit information",
			expand = false,
			frameProps = {
				LayoutOrder = 1,
			},
		}),
		React.createElement(
			Div,
			{
				name = "content",
				frameProps = {
					LayoutOrder = 2,
				},
			},
			priorityLevel ~= nil
				and React.createElement(Text, {
					text = "Priority: " .. tostring(priorityLevel),
					expand = false,
					frameProps = {
						LayoutOrder = 1,
					},
				}),
			React.createElement(Text, {
				text = "Committed at: " .. formatTime(timestamp),
				expand = false,
				frameProps = {
					LayoutOrder = 2,
				},
			}),
			React.createElement(Text, {
				text = "Render duration: " .. formatDuration(duration),
				expand = false,
				frameProps = {
					LayoutOrder = 3,
				},
			}),
			React.createElement(Text, {
				text = "Interaction: ",
				expand = false,
				frameProps = {
					LayoutOrder = 4,
				},
			})
		)
	)
	-- return (
	--   <Fragment>
	--     <div className={styles.Toolbar}>Commit information</div>
	--     <div className={styles.Content}>
	--       <ul className={styles.List}>
	--         {priorityLevel !== nil && (
	--           <li className={styles.ListItem}>
	--             <label className={styles.Label}>Priority</label>:{' '}
	--             <span className={styles.Value}>{priorityLevel}</span>
	--           </li>
	--         )}
	--         <li className={styles.ListItem}>
	--           <label className={styles.Label}>Committed at</label>:{' '}
	--           <span className={styles.Value}>{formatTime(timestamp)}s</span>
	--         </li>
	--         <li className={styles.ListItem}>
	--           <label className={styles.Label}>Render duration</label>:{' '}
	--           <span className={styles.Value}>{formatDuration(duration)}ms</span>
	--         </li>
	--         <li className={styles.Interactions}>
	--           <label className={styles.Label}>Interactions</label>:
	--           <div className={styles.InteractionList}>
	--             {interactionIDs.length == 0 ? (
	--               <div className={styles.NoInteractions}>None</div>
	--             ) : nil}
	--             {interactionIDs.map(interactionID => {
	--               local interaction = interactions.get(interactionID);
	--               if (interaction == nil) {
	--                 throw Error(`Invalid interaction "${interactionID}"`);
	--               }
	--               return (
	--                 <button
	--                   key={interactionID}
	--                   className={styles.Interaction}
	--                   onClick={() => viewInteraction(interactionID)}>
	--                   {interaction.name}
	--                 </button>
	--               );
	--             })}
	--           </div>
	--         </li>
	--       </ul>
	--     </div>
	--   </Fragment>
	-- );
end
exports.default = SidebarCommitInfo
exports.SidebarCommitInfo = SidebarCommitInfo

return exports
