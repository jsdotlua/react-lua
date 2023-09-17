-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/Components/TreeContext.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

-- This context combines tree/selection state, search, and the owners stack.
-- These values are managed together because changes in one often impact the others.
-- Combining them enables us to avoid cascading renders.
--
-- Changes to search state may impact tree state.
-- For example, updating the selected search result also updates the tree's selected value.
-- Search does not fundamentally change the tree though.
-- It is also possible to update the selected tree value independently.
--
-- Changes to owners state mask search and tree values.
-- When owners stack is not empty, search is temporarily disabled,
-- and tree values (e.g. num elements, selected element) are masked.
-- Both tree and search values are restored when the owners stack is cleared.
--
-- For this reason, changes to the tree context are processed in sequence: tree -> search -> owners
-- This enables each section to potentially override (or mask) previous values.

local Packages = script.Parent.Parent.Parent.Parent.Parent
-- local RegexLua = require(Packages.RegexLua)
type RegExp = any -- RegexLua.RegExp
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local Map = LuauPolyfill.Map
local Array = LuauPolyfill.Array
type Array<T> = LuauPolyfill.Array<T>
type Object = LuauPolyfill.Object
type Map<K, V> = LuauPolyfill.Map<K, V>

local React = require(Packages.React)
local createContext = React.createContext
local useCallback = React.useCallback
local useContext = React.useContext
local useEffect = React.useEffect
local useLayoutEffect = React.useLayoutEffect
local useMemo = React.useMemo
local useReducer = React.useReducer
local useRef = React.useRef

local Scheduler = require(Packages.Scheduler)
local next = Scheduler.unstable_next
local runWithPriority = Scheduler.unstable_runWithPriority
local UserBlockingPriority = Scheduler.unstable_UserBlockingPriority

local createRegExp = require(script.Parent.Parent.utils).createRegExp

local contextModule = require(script.Parent.Parent.context)
local BridgeContext = contextModule.BridgeContext
local StoreContext = contextModule.StoreContext

-- deviation: take Store type from types file instead
-- local Store = require(script.Parent.Parent.store)
local devtoolsTypes = require(script.Parent.Parent.Parent.types)
type Store = devtoolsTypes.Store

local types = require(script.Parent.types)
type Element = types.Element

export type StateContext = {
	-- Tree
	numElements: number,
	ownerSubtreeLeafElementID: number | nil,
	selectedElementID: number | nil,
	selectedElementIndex: number | nil,

	-- Search
	searchIndex: number | nil,
	searchResults: Array<number>,
	searchText: string,

	-- Owners
	ownerID: number | nil,
	ownerFlatTree: Array<Element> | nil,

	-- Inspection element panel
	inspectedElementID: number | nil,
}

type ACTION_GO_TO_NEXT_SEARCH_RESULT = {
	type: "GO_TO_NEXT_SEARCH_RESULT",
}
type ACTION_GO_TO_PREVIOUS_SEARCH_RESULT = {
	type: "GO_TO_PREVIOUS_SEARCH_RESULT",
}
type ACTION_HANDLE_STORE_MUTATION = {
	type: "HANDLE_STORE_MUTATION",
	-- deviation: Luau does not have tuple types
	-- payload: [Array<number>, Map<number, number>],
	payload: { Array<number> | Map<number, number> },
}
type ACTION_RESET_OWNER_STACK = {
	type: "RESET_OWNER_STACK",
}
type ACTION_SELECT_CHILD_ELEMENT_IN_TREE = {
	type: "SELECT_CHILD_ELEMENT_IN_TREE",
}
type ACTION_SELECT_ELEMENT_AT_INDEX = {
	type: "SELECT_ELEMENT_AT_INDEX",
	payload: number | nil,
}
type ACTION_SELECT_ELEMENT_BY_ID = {
	type: "SELECT_ELEMENT_BY_ID",
	payload: number | nil,
}
type ACTION_SELECT_NEXT_ELEMENT_IN_TREE = {
	type: "SELECT_NEXT_ELEMENT_IN_TREE",
}
type ACTION_SELECT_NEXT_SIBLING_IN_TREE = {
	type: "SELECT_NEXT_SIBLING_IN_TREE",
}
type ACTION_SELECT_OWNER = {
	type: "SELECT_OWNER",
	payload: number,
}
type ACTION_SELECT_PARENT_ELEMENT_IN_TREE = {
	type: "SELECT_PARENT_ELEMENT_IN_TREE",
}
type ACTION_SELECT_PREVIOUS_ELEMENT_IN_TREE = {
	type: "SELECT_PREVIOUS_ELEMENT_IN_TREE",
}
type ACTION_SELECT_PREVIOUS_SIBLING_IN_TREE = {
	type: "SELECT_PREVIOUS_SIBLING_IN_TREE",
}
type ACTION_SELECT_OWNER_LIST_NEXT_ELEMENT_IN_TREE = {
	type: "SELECT_OWNER_LIST_NEXT_ELEMENT_IN_TREE",
}
type ACTION_SELECT_OWNER_LIST_PREVIOUS_ELEMENT_IN_TREE = {
	type: "SELECT_OWNER_LIST_PREVIOUS_ELEMENT_IN_TREE",
}
type ACTION_SET_SEARCH_TEXT = {
	type: "SET_SEARCH_TEXT",
	payload: string,
}
type ACTION_UPDATE_INSPECTED_ELEMENT_ID = {
	type: "UPDATE_INSPECTED_ELEMENT_ID",
}

type Action =
	ACTION_GO_TO_NEXT_SEARCH_RESULT
	| ACTION_GO_TO_PREVIOUS_SEARCH_RESULT
	| ACTION_HANDLE_STORE_MUTATION
	| ACTION_RESET_OWNER_STACK
	| ACTION_SELECT_CHILD_ELEMENT_IN_TREE
	| ACTION_SELECT_ELEMENT_AT_INDEX
	| ACTION_SELECT_ELEMENT_BY_ID
	| ACTION_SELECT_NEXT_ELEMENT_IN_TREE
	| ACTION_SELECT_NEXT_SIBLING_IN_TREE
	| ACTION_SELECT_OWNER
	| ACTION_SELECT_PARENT_ELEMENT_IN_TREE
	| ACTION_SELECT_PREVIOUS_ELEMENT_IN_TREE
	| ACTION_SELECT_PREVIOUS_SIBLING_IN_TREE
	| ACTION_SELECT_OWNER_LIST_NEXT_ELEMENT_IN_TREE
	| ACTION_SELECT_OWNER_LIST_PREVIOUS_ELEMENT_IN_TREE
	| ACTION_SET_SEARCH_TEXT
	| ACTION_UPDATE_INSPECTED_ELEMENT_ID

export type DispatcherContext = (action: Action) -> ()

local TreeStateContext = createContext((nil :: any) :: StateContext)
TreeStateContext.displayName = "TreeStateContext"

local TreeDispatcherContext = createContext((nil :: any) :: DispatcherContext)
TreeDispatcherContext.displayName = "TreeDispatcherContext"

type State = {
	-- Tree
	numElements: number,
	ownerSubtreeLeafElementID: number | nil,
	selectedElementID: number | nil,
	selectedElementIndex: number | nil,

	-- Search
	searchIndex: number | nil,
	searchResults: Array<number>,
	searchText: string,

	-- Owners
	ownerID: number | nil,
	ownerFlatTree: Array<Element> | nil,

	-- Inspection element panel
	inspectedElementID: number | nil,
}

local function reduceTreeState(store: Store, state: State, action: Action): State
	local numElements = state.numElements
	local ownerSubtreeLeafElementID = state.ownerSubtreeLeafElementID
	local selectedElementIndex = state.selectedElementIndex
	local selectedElementID = state.selectedElementID

	local ownerID = state.ownerID

	local lookupIDForIndex = true

	-- Base tree should ignore selected element changes when the owner's tree is active.
	if ownerID == nil then
		local actionType = action.type
		if action.type == "HANDLE_STORE_MUTATION" then
			numElements = store:getNumElements()

			-- If the currently-selected Element has been removed from the tree, update selection state.
			local removedIDs = action.payload[2] :: Map<number, number>
			-- Find the closest parent that wasn't removed during this batch.
			-- We deduce the parent-child mapping from removedIDs (id -> parentID)
			-- because by now it's too late to read them from the store.
			while selectedElementID ~= nil and removedIDs:has(selectedElementID) do
				selectedElementID = (removedIDs:get(selectedElementID) :: any) :: number
			end
			if selectedElementID == 1 then
				-- The whole root was removed.
				selectedElementIndex = nil
			end
		elseif actionType == "SELECT_CHILD_ELEMENT_IN_TREE" then
			ownerSubtreeLeafElementID = nil

			if selectedElementIndex ~= nil then
				local selectedElement = store:getElementAtIndex((selectedElementIndex :: any) :: number)
				if selectedElement ~= nil and #selectedElement.children > 0 and not selectedElement.isCollapsed then
					local firstChildID = selectedElement.children[1]
					local firstChildIndex = store:getIndexOfElementID(firstChildID)
					if firstChildIndex ~= nil then
						selectedElementIndex = firstChildIndex
					end
				end
			end
		elseif actionType == "SELECT_ELEMENT_AT_INDEX" then
			ownerSubtreeLeafElementID = nil

			selectedElementIndex = (action :: ACTION_SELECT_ELEMENT_AT_INDEX).payload
		elseif actionType == "SELECT_ELEMENT_BY_ID" then
			ownerSubtreeLeafElementID = nil

			-- Skip lookup in this case; it would be redundant.
			-- It might also cause problems if the specified element was inside of a (not yet expanded) subtree.
			lookupIDForIndex = false

			selectedElementID = (action :: ACTION_SELECT_ELEMENT_BY_ID).payload
			selectedElementIndex = if selectedElementID == nil
				then nil
				else store:getIndexOfElementID(selectedElementID)
		elseif actionType == "SELECT_NEXT_ELEMENT_IN_TREE" then
			ownerSubtreeLeafElementID = nil

			if
				selectedElementIndex == nil
				-- deviation: Luau is 1-index based, so remove +1
				or selectedElementIndex >= numElements
			then
				selectedElementIndex = 1
			else
				selectedElementIndex += 1
			end
		elseif actionType == "SELECT_NEXT_SIBLING_IN_TREE" then
			ownerSubtreeLeafElementID = nil

			if selectedElementIndex ~= nil then
				local selectedElement = store:getElementAtIndex((selectedElementIndex :: any) :: number)
				if selectedElement ~= nil and selectedElement.parentID ~= 0 then
					local parent = store:getElementByID(selectedElement.parentID)
					if parent ~= nil then
						local children = parent.children
						local selectedChildIndex = Array.indexOf(children, selectedElement.id)
						-- deviation: remove -1 because 1-indexing
						local nextChildID = if selectedChildIndex < #children
							then children[selectedChildIndex + 1]
							-- deviation: use children[1] because 1-indexing
							else children[1]
						selectedElementIndex = store:getIndexOfElementID(nextChildID)
					end
				end
			end
		elseif actionType == "SELECT_OWNER_LIST_NEXT_ELEMENT_IN_TREE" then
			if selectedElementIndex ~= nil then
				if ownerSubtreeLeafElementID ~= nil and ownerSubtreeLeafElementID ~= selectedElementID then
					local leafElement = store:getElementByID(ownerSubtreeLeafElementID)
					if leafElement ~= nil then
						local currentElement = leafElement
						while currentElement ~= nil do
							if currentElement.ownerID == selectedElementID then
								selectedElementIndex = store:getIndexOfElementID(currentElement.id)
								break
							elseif currentElement.ownerID ~= 0 then
								currentElement = store:getElementByID(currentElement.ownerID)
							end
						end
					end
				end
			end
		elseif actionType == "SELECT_OWNER_LIST_PREVIOUS_ELEMENT_IN_TREE" then
			if selectedElementIndex ~= nil then
				if ownerSubtreeLeafElementID == nil then
					-- If this is the first time we're stepping through the owners tree,
					-- pin the current component as the owners list leaf.
					-- This will enable us to step back down to this component.
					ownerSubtreeLeafElementID = selectedElementID
				end

				local selectedElement = store:getElementAtIndex((selectedElementIndex :: any) :: number)
				if selectedElement ~= nil and selectedElement.ownerID ~= 0 then
					local ownerIndex = store:getIndexOfElementID(selectedElement.ownerID)
					if ownerIndex ~= nil then
						selectedElementIndex = ownerIndex
					end
				end
			end
		elseif actionType == "SELECT_PARENT_ELEMENT_IN_TREE" then
			ownerSubtreeLeafElementID = nil

			if selectedElementIndex ~= nil then
				local selectedElement = store:getElementAtIndex((selectedElementIndex :: any) :: number)
				if selectedElement ~= nil and selectedElement.parentID ~= 0 then
					local parentIndex = store:getIndexOfElementID(selectedElement.parentID)
					if parentIndex ~= nil then
						selectedElementIndex = parentIndex
					end
				end
			end
		elseif actionType == "SELECT_PREVIOUS_ELEMENT_IN_TREE" then
			ownerSubtreeLeafElementID = nil

			if selectedElementIndex == nil or selectedElementIndex == 1 then
				-- deviation: remove -1 to point to the last element (because of 1-indexing)
				selectedElementIndex = numElements
			else
				selectedElementIndex -= 1
			end
		elseif actionType == "SELECT_PREVIOUS_SIBLING_IN_TREE" then
			ownerSubtreeLeafElementID = nil

			if selectedElementIndex ~= nil then
				local selectedElement = store:getElementAtIndex((selectedElementIndex :: any) :: number)
				if selectedElement ~= nil and selectedElement.parentID ~= 0 then
					local parent = store:getElementByID(selectedElement.parentID)
					if parent ~= nil then
						local children = parent.children
						local selectedChildIndex = Array.indexOf(children, selectedElement.id)
						local nextChildID = if selectedChildIndex > 0
							then children[selectedChildIndex - 1]
							else children[#children]
						selectedElementIndex = store:getIndexOfElementID(nextChildID)
					end
				end
			end
		else
			-- React can bailout of no-op updates.
			return state
		end
	end

	-- Keep selected item ID and index in sync.
	if lookupIDForIndex and selectedElementIndex ~= state.selectedElementIndex then
		if selectedElementIndex == nil then
			selectedElementID = nil
		else
			selectedElementID = store:getElementIDAtIndex((selectedElementIndex :: any) :: number)
		end
	end

	return Object.assign(table.clone(state), {
		numElements = numElements,
		ownerSubtreeLeafElementID = ownerSubtreeLeafElementID,
		selectedElementIndex = selectedElementIndex,
		selectedElementID = selectedElementID,
	})
end

-- deviation: pre-declaration
local getNearestResultIndex
local recursivelySearchTree

local function reduceSearchState(store: Store, state: State, action: Action): State
	local searchIndex = state.searchIndex
	local searchResults = state.searchResults
	local searchText = state.searchText
	local selectedElementID = state.selectedElementID
	local selectedElementIndex = state.selectedElementIndex
	local ownerID = state.ownerID

	local prevSearchIndex = searchIndex
	local prevSearchText = searchText
	local numPrevSearchResults = #searchResults

	-- We track explicitly whether search was requested because
	-- we might want to search even if search index didn't change.
	-- For example, if you press "next result" on a search with a single
	-- result but a different current selection, we'll set this to true.
	local didRequestSearch = false

	-- Search isn't supported when the owner's tree is active.
	if ownerID == nil then
		local actionType = action.type
		if actionType == "GO_TO_NEXT_SEARCH_RESULT" then
			if numPrevSearchResults > 0 then
				didRequestSearch = true
				searchIndex = if searchIndex + 1 < numPrevSearchResults then searchIndex + 1 else 0
			end
		elseif actionType == "GO_TO_PREVIOUS_SEARCH_RESULT" then
			if numPrevSearchResults > 0 then
				didRequestSearch = true
				searchIndex = if (searchIndex :: any) :: number > 0
					then ((searchIndex :: any) :: number) - 1
					else numPrevSearchResults - 1
			end
		elseif actionType == "HANDLE_STORE_MUTATION" then
			if searchText ~= "" then
				local actionPayload = (action :: ACTION_HANDLE_STORE_MUTATION).payload
				local addedElementIDs = actionPayload[1] :: Array<number>
				local removedElementIDs = actionPayload[2] :: Map<number, number>

				removedElementIDs:forEach(function(parentID, id)
					-- Prune this item from the search results.
					local index = Array.indexOf(searchResults, id)
					if index >= 0 then
						searchResults =
							-- deviation: use 1-indexing
							Array.concat(Array.slice(searchResults, 1, index), Array.slice(searchResults, index + 1))

						-- If the results are now empty, also deselect things.
						if #searchResults == 0 then
							searchIndex = nil
						elseif ((searchIndex :: any) :: number) >= #searchResults then
							-- deviation: use 1-indexing, so remove the `-1`
							searchIndex = #searchResults -- -1
						end
					end
				end)

				Array.forEach(addedElementIDs, function(id)
					local element = (store:getElementByID(id) :: any) :: Element

					-- It's possible that multiple tree operations will fire before this action has run.
					-- So it's important to check for elements that may have been added and then removed.
					if element ~= nil then
						local displayName = element.displayName

						-- Add this item to the search results if it matches.
						local regExp = createRegExp(searchText)
						if displayName ~= nil and regExp.test(displayName) then
							local newElementIndex = (store:getIndexOfElementID(id) :: any) :: number

							local foundMatch = false
							for index, resultID in searchResults do
								if newElementIndex < ((store:getIndexOfElementID(resultID) :: any) :: number) then
									foundMatch = true
									searchResults = Array.concat(
										-- deviation: use 1-indexing
										Array.concat(Array.slice(searchResults, 1, index), resultID),
										Array.slice(searchResults, index)
									)
									break
								end
							end
							if not foundMatch then
								searchResults = Array.concat(searchResults, id)
							end

							searchIndex = if searchIndex == nil then 0 else searchIndex
						end
					end
				end)
			end
		elseif actionType == "SET_SEARCH_TEXT" then
			searchIndex = nil
			searchResults = {}
			searchText = (action :: ACTION_SET_SEARCH_TEXT).payload

			if searchText ~= "" then
				local regExp = createRegExp(searchText)
				store.roots.forEach(function(rootID)
					recursivelySearchTree(store, rootID, regExp, searchResults)
				end)
				if #searchResults > 0 then
					if prevSearchIndex == nil then
						if selectedElementIndex ~= nil then
							searchIndex = getNearestResultIndex(store, searchResults, selectedElementIndex)
						else
							searchIndex = 0
						end
					else
						searchIndex = math.min(
							(prevSearchIndex :: any) :: number,
							-- deviation: use 1-indexing
							#searchResults -- - 1
						)
					end
				end
			end
		else
			-- React can bailout of no-op updates.
			return state
		end
	end

	if searchText ~= prevSearchText then
		local newSearchIndex = Array.indexOf(searchResults, selectedElementID)
		if newSearchIndex == -1 then
			-- Only move the selection if the new query
			-- doesn't match the current selection anymore.
			didRequestSearch = true
		else
			-- Selected item still matches the new search query.
			-- Adjust the index to reflect its position in new results.
			searchIndex = newSearchIndex
		end
	end
	if didRequestSearch and searchIndex ~= nil then
		selectedElementID = (searchResults[searchIndex] :: any) :: number
		selectedElementIndex = store:getIndexOfElementID((selectedElementID :: any) :: number)
	end

	return Object.assign(table.clone(state), {

		selectedElementID = selectedElementID,
		selectedElementIndex = selectedElementIndex,

		searchIndex = searchIndex,
		searchResults = searchResults,
		searchText = searchText,
	})
end

local function reduceOwnersState(store: Store, state: State, action: Action): State
	local numElements = state.numElements
	local selectedElementID = state.selectedElementID
	local selectedElementIndex = state.selectedElementIndex
	local ownerID = state.ownerID
	local ownerFlatTree = state.ownerFlatTree
	local searchIndex = state.searchIndex
	local searchResults = state.searchResults
	local searchText = state.searchText

	local prevSelectedElementIndex = selectedElementIndex

	local actionType = action.type
	if actionType == "HANDLE_STORE_MUTATION" then
		if ownerID ~= nil then
			if not store:containsElement(ownerID) then
				ownerID = nil
				ownerFlatTree = nil
				selectedElementID = nil
			else
				ownerFlatTree = store:getOwnersListForElement(ownerID)
				if selectedElementID ~= nil then
					-- Mutation might have caused the index of this ID to shift.
					selectedElementIndex = Array.findIndex(ownerFlatTree, function(element)
						return element.id == selectedElementID
					end)
				end
			end
		else
			if selectedElementID ~= nil then
				-- Mutation might have caused the index of this ID to shift.
				selectedElementIndex = store:getIndexOfElementID(selectedElementID)
			end
		end
		if selectedElementIndex == -1 then
			-- If we couldn't find this ID after mutation, unselect it.
			selectedElementIndex = nil
			selectedElementID = nil
		end
	elseif actionType == "RESET_OWNER_STACK" then
		ownerID = nil
		ownerFlatTree = nil
		selectedElementIndex = if selectedElementID ~= nil then store:getIndexOfElementID(selectedElementID) else nil
	elseif actionType == "SELECT_ELEMENT_AT_INDEX" then
		if ownerFlatTree ~= nil then
			selectedElementIndex = (action :: ACTION_SELECT_ELEMENT_AT_INDEX).payload
		end
	elseif actionType == "SELECT_ELEMENT_BY_ID" then
		if ownerFlatTree ~= nil then
			local payload = (action :: ACTION_SELECT_ELEMENT_BY_ID).payload
			if payload == nil then
				selectedElementIndex = nil
			else
				selectedElementIndex = ownerFlatTree.findIndex(function(element)
					return element.id == payload
				end)

				-- If the selected element is outside of the current owners list,
				-- exit the list and select the element in the main tree.
				-- This supports features like toggling Suspense.
				if selectedElementIndex ~= nil and selectedElementIndex < 1 then
					ownerID = nil
					ownerFlatTree = nil
					selectedElementIndex = store:getIndexOfElementID(payload)
				end
			end
		end
	elseif actionType == "SELECT_NEXT_ELEMENT_IN_TREE" then
		if ownerFlatTree ~= nil and #ownerFlatTree > 0 then
			if selectedElementIndex == nil then
				-- deviation: use 1 because 1-indexing
				selectedElementIndex = 1
				-- deviation: remove +1 because 1-indexing
			elseif selectedElementIndex < #ownerFlatTree then
				selectedElementIndex += 1
			end
		end
	elseif actionType == "SELECT_PREVIOUS_ELEMENT_IN_TREE" then
		if ownerFlatTree ~= nil and #ownerFlatTree > 0 then
			-- deviation: use 1 because 1-indexing
			if selectedElementIndex ~= nil and selectedElementIndex > 1 then
				selectedElementIndex -= 1
			end
		end
	elseif actionType == "SELECT_OWNER" then
		-- If the Store doesn't have any owners metadata, don't drill into an empty stack.
		-- This is a confusing user experience.
		if store.hasOwnerMetadata then
			ownerID = (action :: ACTION_SELECT_OWNER).payload
			ownerFlatTree = store:getOwnersListForElement(ownerID :: number)

			-- Always force reset selection to be the top of the new owner tree.
			selectedElementIndex = 1
			prevSelectedElementIndex = nil
		end
	else
		-- React can bailout of no-op updates.
		return state
	end

	-- -- Changes in the selected owner require re-calculating the owners tree.
	if ownerFlatTree ~= state.ownerFlatTree or action.type == "HANDLE_STORE_MUTATION" then
		if ownerFlatTree == nil then
			numElements = store:getNumElements()
		else
			numElements = #ownerFlatTree
		end
	end

	-- Keep selected item ID and index in sync.
	if selectedElementIndex ~= prevSelectedElementIndex then
		if selectedElementIndex == nil then
			selectedElementID = nil
		else
			if ownerFlatTree ~= nil then
				selectedElementID = ownerFlatTree[selectedElementIndex].id
			end
		end
	end

	return Object.assign(table.clone(state), {
		numElements = numElements,
		selectedElementID = selectedElementID,
		selectedElementIndex = selectedElementIndex,

		searchIndex = searchIndex,
		searchResults = searchResults,
		searchText = searchText,

		ownerID = ownerID,
		ownerFlatTree = ownerFlatTree,
	})
end

local function reduceSuspenseState(store: Store, state: State, action: Action): State
	local type = action.type
	if type == "UPDATE_INSPECTED_ELEMENT_ID" then
		if state.inspectedElementID ~= state.selectedElementID then
			return Object.assign(table.clone(state), {
				inspectedElementID = state.selectedElementID,
			})
		end
	end
	-- React can bailout of no-op updates.
	return state
end

type Props = {
	children: React.ReactNode,

	-- Used for automated testing
	defaultInspectedElementID: number?,
	defaultOwnerID: number?,
	defaultSelectedElementID: number?,
	defaultSelectedElementIndex: number?,
}

-- -- TODO Remove TreeContextController wrapper element once global ConsearchText.write API exists.
local function TreeContextController(props: Props)
	local children = props.children
	local defaultInspectedElementID = props.defaultInspectedElementID
	local defaultOwnerID = props.defaultOwnerID
	local defaultSelectedElementID = props.defaultSelectedElementID
	local defaultSelectedElementIndex = props.defaultSelectedElementIndex

	local bridge = useContext(BridgeContext)
	local store = useContext(StoreContext)

	local initialRevision = useMemo(function()
		return store.revision
	end, { store })

	-- This reducer is created inline because it needs access to the Store.
	-- The store is mutable, but the Store itself is global and lives for the lifetime of the DevTools,
	-- so it's okay for the reducer to have an empty dependencies array.
	local reducer = useMemo(function()
		return function(state: State, action: Action): State
			local type = action.type
			if
				type == "GO_TO_NEXT_SEARCH_RESULT"
				or type == "GO_TO_PREVIOUS_SEARCH_RESULT"
				or type == "HANDLE_STORE_MUTATION"
				or type == "RESET_OWNER_STACK"
				or type == "SELECT_ELEMENT_AT_INDEX"
				or type == "SELECT_ELEMENT_BY_ID"
				or type == "SELECT_CHILD_ELEMENT_IN_TREE"
				or type == "SELECT_NEXT_ELEMENT_IN_TREE"
				or type == "SELECT_NEXT_SIBLING_IN_TREE"
				or type == "SELECT_OWNER_LIST_NEXT_ELEMENT_IN_TREE"
				or type == "SELECT_OWNER_LIST_PREVIOUS_ELEMENT_IN_TREE"
				or type == "SELECT_PARENT_ELEMENT_IN_TREE"
				or type == "SELECT_PREVIOUS_ELEMENT_IN_TREE"
				or type == "SELECT_PREVIOUS_SIBLING_IN_TREE"
				or type == "SELECT_OWNER"
				or type == "UPDATE_INSPECTED_ELEMENT_ID"
				or type == "SET_SEARCH_TEXT"
			then
				state = reduceTreeState(store, state, action)
				state = reduceSearchState(store, state, action)
				state = reduceOwnersState(store, state, action)
				state = reduceSuspenseState(store, state, action)

				-- If the selected ID is in a collapsed subtree, reset the selected index to null.
				-- We'll know the correct index after the layout effect will toggle the tree,
				-- and the store tree is mutated to account for that.
				if state.selectedElementID ~= nil and store:isInsideCollapsedSubTree(state.selectedElementID) then
					local nextState = table.clone(state)
					nextState.selectedElementIndex = nil
					return nextState
				end

				return state
			else
				error(Error.new(`Unrecognized action "${type}"`))
			end
		end
	end, { store })

	local state, dispatch = useReducer(reducer, {
		-- Tree
		numElements = store:getNumElements(),
		ownerSubtreeLeafElementID = nil,
		selectedElementID = if defaultSelectedElementID == nil then nil else defaultSelectedElementID,
		selectedElementIndex = if defaultSelectedElementIndex == nil then nil else defaultSelectedElementIndex,

		-- Search
		searchIndex = nil,
		searchResults = {},
		searchText = "",

		-- Owners
		ownerID = if defaultOwnerID == nil then nil else defaultOwnerID,
		ownerFlatTree = nil,

		-- Inspection element panel
		inspectedElementID = if defaultInspectedElementID == nil then nil else defaultInspectedElementID,
	})

	local dispatchWrapper = useCallback(function(action: Action)
		-- Run the first update at "user-blocking" priority in case dispatch is called from a non-React event.
		-- In this case, the current (and "next") priorities would both be "normal",
		-- and suspense would potentially block both updates.
		runWithPriority(UserBlockingPriority, function()
			return dispatch(action)
		end)
		next(function()
			return dispatch({ type = "UPDATE_INSPECTED_ELEMENT_ID" })
		end)
	end, { dispatch })

	-- Listen for host element selections.
	useEffect(function()
		local handleSelectFiber = function(id: number)
			dispatchWrapper({ type = "SELECT_ELEMENT_BY_ID", payload = id })
		end
		bridge:addListener("selectFiber", handleSelectFiber)
		return function()
			return bridge:removeListener("selectFiber", handleSelectFiber)
		end
	end, { bridge::any, dispatchWrapper })

	-- If a newly-selected search result or inspection selection is inside of a collapsed subtree, auto expand it.
	-- This needs to be a layout effect to avoid temporarily flashing an incorrect selection.
	local prevSelectedElementID = useRef(nil :: number | nil)
	useLayoutEffect(function()
		if state.selectedElementID ~= prevSelectedElementID.current then
			prevSelectedElementID.current = state.selectedElementID

			if state.selectedElementID ~= nil then
				local element = store:getElementByID(state.selectedElementID)
				if element ~= nil and element.parentID > 0 then
					store:toggleIsCollapsed(element.parentID, false)
				end
			end
		end
	end, { state.selectedElementID :: any, store })

	-- Mutations to the underlying tree may impact this context (e.g. search results, selection state).
	useEffect(function()
		-- deviation: Luau does not have tuple types
		-- [ Array<number>, Map<number, number> ]
		local handleStoreMutated = function(payload: { Array<number> | Map<number, number> })
			local addedElementIDs = payload[1]
			local removedElementIDs = payload[2]
			dispatchWrapper({
				type = "HANDLE_STORE_MUTATION",
				payload = { addedElementIDs, removedElementIDs },
			})
		end

		-- Since this is a passive effect, the tree may have been mutated before our initial subscription.
		if store.revision ~= initialRevision then
			-- At the moment, we can treat this as a mutation.
			-- We don't know which Elements were newly added/removed, but that should be okay in this case.
			-- It would only impact the search state, which is unlikely to exist yet at this point.
			dispatchWrapper({
				type = "HANDLE_STORE_MUTATION",
				payload = { {}, Map.new() },
			})
		end
		store:addListener("mutated", handleStoreMutated)

		return function()
			return store:removeListener("mutated", handleStoreMutated)
		end
	end, { dispatchWrapper :: any, initialRevision, store })

	return React.createElement(
		TreeStateContext.Provider,
		{ value = state },
		React.createElement(TreeDispatcherContext.Provider, {
			value = dispatchWrapper,
		}, children)
	)
end

function recursivelySearchTree(store: Store, elementID: number, regExp: RegExp, searchResults: Array<number>): ()
	local element = (store:getElementByID(elementID) :: any) :: Element
	local children = element.children
	local displayName = element.displayName
	local hocDisplayNames = element.hocDisplayNames

	if displayName ~= nil and regExp.test(displayName) == true then
		table.insert(searchResults, elementID)
	elseif
		hocDisplayNames ~= nil
		and #hocDisplayNames > 0
		and Array.some(hocDisplayNames, function(name)
			return regExp:test(name)
		end) == true
	then
		table.insert(searchResults, elementID)
	end

	Array.forEach(children, function(childID)
		return recursivelySearchTree(store, childID, regExp, searchResults)
	end)
end

function getNearestResultIndex(store: Store, searchResults: Array<number>, selectedElementIndex: number): number
	local index = Array.findIndex(searchResults, function(id)
		local innerIndex = store:getIndexOfElementID(id)
		return innerIndex ~= nil and innerIndex >= selectedElementIndex
	end)

	-- deviation: use 1-indexing
	return if index == -1 then 1 else index
end

return {
	TreeDispatcherContext = TreeDispatcherContext,
	TreeStateContext = TreeStateContext,
	TreeContextController = TreeContextController,
}
