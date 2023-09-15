--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/WhatChanged.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent.Parent.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>
local exports = {}

local React = require(Packages.React)
local useContext = React.useContext
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext

-- import styles from './WhatChanged.css';

type Props = {
	fiberID: number,
}

local function WhatChanged(props: Props)
	local fiberID = props.fiberID
	local profilerStore = useContext(StoreContext).profilerStore
	local profilerContext = useContext(ProfilerContext)
	local rootID = profilerContext.rootID
	local selectedCommitIndex = profilerContext.selectedCommitIndex

	-- TRICKY
	-- Handle edge case where no commit is selected because of a min-duration filter update.
	-- If the commit index is null, suspending for data below would throw an error.
	-- TODO (ProfilerContext) This check should not be necessary.
	if selectedCommitIndex == nil then
		return nil
	end

	local commitData = profilerStore:getCommitData((rootID :: any) :: number, selectedCommitIndex)
	local changeDescriptions = commitData.changeDescriptions

	if changeDescriptions == nil then
		return nil
	end

	local changeDescription = changeDescriptions:get(fiberID)
	if changeDescription == nil then
		return nil
	end

	if changeDescription.isFirstMount then
		error("todo")
		-- return (
		--   <div className={styles.Component}>
		--     <label className={styles.Label}>Why did this render?</label>
		--     <div className={styles.Item}>
		--       This is the first time the component rendered.
		--     </div>
		--   </div>
		-- );
	end

	local changes = {}

	if changeDescription.context == true then
		table.insert(
			changes,
			error("todo")
			-- <div key="context" className={styles.Item}>
			--   • Context changed
			-- </div>,
		)
	elseif
		type(changeDescription.context) == "table"
		and changeDescription.context ~= nil
		and #changeDescription.context ~= 0
	then
		table.insert(
			changes,
			error("todo")
			-- <div key="context" className={styles.Item}>
			--   • Context changed:
			--   {changeDescription.context.map(key => (
			--     <span key={key} className={styles.Key}>
			--       {key}
			--     </span>
			--   ))}
			-- </div>,
		)
	end

	if changeDescription.didHooksChange then
		table.insert(
			changes,
			error("todo")
			-- <div key="hooks" className={styles.Item}>
			--   • Hooks changed
			-- </div>,
		)
	end

	if changeDescription.props ~= nil and #changeDescription.props ~= 0 then
		table.insert(
			changes,
			error("todo")
			-- <div key="props" className={styles.Item}>
			--   • Props changed:
			--   {changeDescription.props.map(key => (
			--     <span key={key} className={styles.Key}>
			--       {key}
			--     </span>
			--   ))}
			-- </div>,
		)
	end

	if changeDescription.state ~= nil and #changeDescription.stateh ~= 0 then
		table.insert(
			changes,
			error("todo")
			-- <div key="state" className={styles.Item}>
			--   • State changed:
			--   {changeDescription.state.map(key => (
			--     <span key={key} className={styles.Key}>
			--       {key}
			--     </span>
			--   ))}
			-- </div>,
		)
	end

	if #changes == 0 then
		table.insert(
			changes,
			error("todo")
			-- <div key="nothing" className={styles.Item}>
			--   The parent component rendered.
			-- </div>,
		)
	end

	return error("todo")
	--     <div className={styles.Component}>
	--       <label className={styles.Label}>Why did this render?</label>
	--       {changes}
	--     </div>
end

return exports
