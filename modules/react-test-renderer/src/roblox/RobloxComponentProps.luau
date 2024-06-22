local Shared = require("@pkg/@jsdotlua/shared")
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")

type Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>

local Tag = Shared.Tag

local TagManagers = {}

local function setInitialTags(
	hostInstance: any,
	_tag: string,
	rawProps: Object,
	rootContainerElement: any
)
	for key, newValue in rawProps do
		if key == Tag then
			local rootTagManager = TagManagers[rootContainerElement]
			if rootTagManager == nil then
				rootTagManager = {}
				TagManagers[rootContainerElement] = rootTagManager
			end

			local tagSet = string.split(newValue or "", ",")

			for _, newTag in tagSet do
				local instancesForTag = rootTagManager[newTag]
				if instancesForTag == nil then
					instancesForTag = {}
					rootTagManager[newTag] = instancesForTag
				end
				table.insert(instancesForTag, hostInstance)
			end
		end
	end
end

local function updateTags(hostInstance: any, newProps: Object, lastProps: Object)
	for propKey, newValue in newProps do
		if propKey == Tag then
			local rootTagManager = TagManagers[hostInstance.rootContainerInstance]
			if rootTagManager == nil then
				rootTagManager = {}
				TagManagers[hostInstance.rootContainerInstance] = rootTagManager
			end

			local newTagSet = string.split(newValue or "", ",")
			local lastTagSet = string.split(lastProps[Tag] or "", ",")

			for _, lastTag in lastTagSet do
				local existingTagIndex = table.find(newTagSet, lastTag)
				if existingTagIndex == nil then
					local index = table.find(rootTagManager[lastTag], hostInstance)
					table.remove(rootTagManager[lastTag], index)
				else
					table.remove(newTagSet, existingTagIndex)
				end
			end

			for _, newTag in newTagSet do
				local instancesForTag = rootTagManager[newTag]
				if instancesForTag == nil then
					instancesForTag = {}
					rootTagManager[newTag] = instancesForTag
				end
				table.insert(instancesForTag, hostInstance)
			end
		end
	end
end

local function removeTags(hostInstance)
	for _, childInstance in hostInstance.children or {} do
		removeTags(childInstance)
	end

	local rootTagManager = TagManagers[hostInstance.rootContainerInstance]
	if rootTagManager == nil then
		return
	end

	local tagSet = string.split(hostInstance.props[Tag] or "", ",")
	for _, tag in tagSet do
		local instancesForTag = rootTagManager[tag]
		if instancesForTag ~= nil then
			local index = table.find(instancesForTag, hostInstance)
			table.remove(instancesForTag, index)
		end
	end
end

local function getInstancesForTag(rootContainerElement, tag)
	local rootTagManager = TagManagers[rootContainerElement] or {}
	return rootTagManager[tag] or {}
end

local exports = {
	setInitialTags = setInitialTags,
	updateTags = updateTags,
	removeTags = removeTags,
	getInstancesForTag = getInstancesForTag,
}

return exports
