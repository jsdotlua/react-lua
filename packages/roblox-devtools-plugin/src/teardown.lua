export type Teardown = (() -> ()) | Instance | RBXScriptConnection | { Teardown } | nil

local function teardown(...: Teardown)
	for i = 1, select("#", ...) do
		local element = select(i, ...)
		local elementType = type(element)

		if element == nil then
			-- nothing to do!
		elseif elementType == "function" then
			element()
		elseif elementType == "table" then
			for _, subElement in element do
				teardown(subElement)
			end
		elseif elementType == "userdata" and typeof(element) == "RBXScriptConnection" then
			element:Disconnect()
		elseif elementType == "userdata" and typeof(element) == "Instance" then
			element:Destroy()
		else
			warn("unable to teardown value of type `" .. elementType .. "`")
		end
	end
end

local function join(...: Teardown): Teardown
	local packed = table.pack(...)
	local function teardownAll()
		teardown(table.unpack(packed, 1, packed.n))
	end
	return teardownAll
end

return {
	teardown = teardown,
	join = join,
}
