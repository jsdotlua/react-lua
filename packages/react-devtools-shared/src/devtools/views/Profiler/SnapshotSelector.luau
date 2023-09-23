--!strict
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Profiler/SnapshotSelector.js
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

local function String_padStart(value: string, targetLength: number, padString: string?)
	local length = string.len(value)
	if targetLength <= length then
		return value
	end
	local padString = if padString == nil then " " else padString
	targetLength = targetLength - length

	local padStringLength = string.len(padString)
	if targetLength > padStringLength then
		padString ..= string.rep(padString, targetLength / padStringLength)
	end

	return LuauPolyfill.String.slice(padString, 1, targetLength) .. value
end

type Map<K, V> = LuauPolyfill.Map<K, V>
type Array<K> = LuauPolyfill.Array<K>

local exports = {}

local Div = require(script.Parent.Parent.roblox.Div)
local Text = require(script.Parent.Parent.roblox.Text)

local React = require(Packages.React)
local Fragment = React.Fragment
local useCallback = React.useCallback
local useContext = React.useContext
local useMemo = React.useMemo

-- local Button = require(script.Parent.Parent.Button)
-- local ButtonIcon = require(script.Parent.Parent.ButtonIcon)
local ProfilerContextModule = require(script.Parent.ProfilerContext)
local ProfilerContext = ProfilerContextModule.ProfilerContext
local SnapshotCommitList = require(script.Parent.SnapshotCommitList).default
local maxBarWidth = require(script.Parent.constants).maxBarWidth
local contextModule = require(script.Parent.Parent.context)
local StoreContext = contextModule.StoreContext

-- import styles from './SnapshotSelector.css';

type Props = {}

local function SnapshotSelector(_: Props)
	local profilerValue = useContext(ProfilerContext)
	local isCommitFilterEnabled = profilerValue.isCommitFilterEnabled
	local minCommitDuration = profilerValue.minCommitDuration
	local rootID = profilerValue.rootID
	local selectedCommitIndex = profilerValue.selectedCommitIndex
	local selectCommitIndex = profilerValue.selectCommitIndex

	local profilerStore = useContext(StoreContext):getProfilerStore()
	-- deviation: if rootID is nil, skip getting the commit data to avoid an error
	local commitData = if rootID == nil then {} else profilerStore:getDataForRoot((rootID :: any) :: number).commitData

	local commitDurations: Array<number> = {}
	local commitTimes: Array<number> = {}
	Array.forEach(commitData, function(commitDatum)
		table.insert(commitDurations, commitDatum.duration)
		table.insert(commitTimes, commitDatum.timestamp)
	end)

	local filteredCommitIndices = useMemo(function()
		return Array.reduce(commitData, function(reduced, commitDatum, index)
			if not isCommitFilterEnabled or commitDatum.duration >= minCommitDuration then
				table.insert(reduced, index)
			end
			return reduced
		end, {})
	end, { commitData :: any, isCommitFilterEnabled, minCommitDuration })

	local numFilteredCommits = #filteredCommitIndices

	-- Map the (unfiltered) selected commit index to an index within the filtered data.
	local selectedFilteredCommitIndex = useMemo(function()
		if selectedCommitIndex ~= nil then
			for i = 1, #filteredCommitIndices do
				if filteredCommitIndices[i] == selectedCommitIndex then
					return i
				end
			end
		end
		-- deviation: in JS, `null + 1` gives `1`, so to imitate in Luau, use 0
		return 0
	end, { filteredCommitIndices :: any, selectedCommitIndex })

	-- TODO (ProfilerContext) This should be managed by the context controller (reducer).
	-- It doesn't currently know about the filtered commits though (since it doesn't suspend).
	-- Maybe this component should pass filteredCommitIndices up?
	-- deviation: wrap side-effects in useEffect
	React.useEffect(function()
		-- deviation: instead of using null, we are using 0
		if selectedFilteredCommitIndex == 0 then
			if numFilteredCommits > 0 then
				-- deviation: first index is 1 in Luau
				selectCommitIndex(1)
			else
				selectCommitIndex(nil)
			end
			-- deviation: use > because of 1-indexing
		elseif selectedFilteredCommitIndex > numFilteredCommits then
			selectCommitIndex(if numFilteredCommits == 0 then nil else numFilteredCommits - 1)
		end
	end, { selectedFilteredCommitIndex :: any, selectCommitIndex, numFilteredCommits })

	local label = nil
	if numFilteredCommits > 0 then
		-- deviation: no need to add 1 because of 1-indexing
		label = String_padStart(`{selectedFilteredCommitIndex}`, #`{numFilteredCommits}`, "0")
			.. " / "
			.. numFilteredCommits
	end

	local viewNextCommit = useCallback(function()
		local nextCommitIndex = ((selectedFilteredCommitIndex :: any) :: number) + 1
		-- deviation: use > because of 1-indexing
		if nextCommitIndex > #filteredCommitIndices then
			-- deviation: use 1 because of 1-indexing
			nextCommitIndex = 1
		end
		selectCommitIndex(filteredCommitIndices[nextCommitIndex])
	end, { selectedFilteredCommitIndex :: any, filteredCommitIndices, selectCommitIndex })
	local viewPrevCommit = useCallback(function()
		local nextCommitIndex = ((selectedFilteredCommitIndex :: any) :: number) - 1
		-- deviation: use 1 because of 1-indexing
		if nextCommitIndex < 1 then
			-- deviation: use array length because of 1-indexing
			nextCommitIndex = #filteredCommitIndices
		end
		selectCommitIndex(filteredCommitIndices[nextCommitIndex])
	end, { selectedFilteredCommitIndex :: any, filteredCommitIndices, selectCommitIndex })

	local handleKeyDown = useCallback(function(event)
		-- switch (event.key) {
		--   case 'ArrowLeft':
		--     viewPrevCommit();
		--     event.stopPropagation();
		--     break;
		--   case 'ArrowRight':
		--     viewNextCommit();
		--     event.stopPropagation();
		--     break;
		--   default:
		--     break;
		-- }
	end, { viewNextCommit, viewPrevCommit })

	if #commitData == 0 then
		return (nil :: any) :: React.ReactElement<any>
	end

	-- shift content after tab bar
	local layoutOrderBase = 100

	return React.createElement(
		Fragment,
		nil,
		React.createElement(Text, {
			text = label,
			frameProps = { LayoutOrder = layoutOrderBase },
		}),
		React.createElement(
			Text, -- Button,
			{
				name="previous-button",
				-- className = styles.Button,
				disabled = numFilteredCommits == 0,
				onMouseDown = viewPrevCommit,
				text = "<",
				frameProps = { LayoutOrder = layoutOrderBase + 1 },
			}
			-- React.createElement(ButtonIcon, { type = "previous" })
		),
		React.createElement(
			Div,
			{
				-- className = styles.Commits,
				-- onKeyDown = handleKeyDown,
				-- style = {
				-- 	flex = if numFilteredCommits > 0 then "1 1 auto" else "0 0 auto",
				maxWidth = if numFilteredCommits > 0 then numFilteredCommits * maxBarWidth else nil,
				-- },
				-- tabIndex = 0,
				frameProps = { LayoutOrder = layoutOrderBase + 2 },
			},
			--
			numFilteredCommits > 0
				and React.createElement(SnapshotCommitList, {
					commitDurations = commitDurations,
					commitTimes = commitTimes,
					filteredCommitIndices = filteredCommitIndices,
					selectedCommitIndex = selectedCommitIndex,
					selectedFilteredCommitIndex = selectedFilteredCommitIndex,
					selectCommitIndex = selectCommitIndex,
				}),
			numFilteredCommits == 0
				and React.createElement(Div, {
					-- className = styles.NoCommits,
				}, React.createElement(Text, { text = "No commits" }))
		),
		React.createElement(
			Text, --Button,
			{
				name="next-button",
				-- className = styles.Button,
				disabled = numFilteredCommits == 0,
				onMouseDown = viewNextCommit,
				text = ">",
				frameProps = { LayoutOrder = layoutOrderBase + 3 },
			}
			-- React.createElement(ButtonIcon, { type = "next" })
		)
	)
	-- (
	--   <Fragment>
	--     <span className={styles.IndexLabel}>{label}</span>
	--     <Button
	--       className={styles.Button}
	--       disabled={numFilteredCommits === 0}
	--       onClick={viewPrevCommit}
	--       title="Select previous commit">
	--       <ButtonIcon type="previous" />
	--     </Button>
	--     <div
	--       className={styles.Commits}
	--       onKeyDown={handleKeyDown}
	--       style={{
	--         flex: numFilteredCommits > 0 ? '1 1 auto' : '0 0 auto',
	--         maxWidth:
	--           numFilteredCommits > 0
	--             ? numFilteredCommits * maxBarWidth
	--             : undefined,
	--       }}
	--       tabIndex={0}>
	--       {numFilteredCommits > 0 && (
	--         <SnapshotCommitList
	--           commitDurations={commitDurations}
	--           commitTimes={commitTimes}
	--           filteredCommitIndices={filteredCommitIndices}
	--           selectedCommitIndex={selectedCommitIndex}
	--           selectedFilteredCommitIndex={selectedFilteredCommitIndex}
	--           selectCommitIndex={selectCommitIndex}
	--         />
	--       )}
	--       {numFilteredCommits === 0 && (
	--         <div className={styles.NoCommits}>No commits</div>
	--       )}
	--     </div>
	--     <Button
	--       className={styles.Button}
	--       disabled={numFilteredCommits === 0}
	--       onClick={viewNextCommit}
	--       title="Select next commit">
	--       <ButtonIcon type="next" />
	--     </Button>
	--   </Fragment>
	-- );
end
exports.default = SnapshotSelector
exports.SnapshotSelector = SnapshotSelector

return exports
