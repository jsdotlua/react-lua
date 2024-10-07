local Parser = {}

Parser.Types = {
	[0] = "open",
	[1] = "close",
	[2] = "ping",
	[3] = "pong",
	[4] = "message",

	-- unused
	[5] = "upgrade",
	[6] = "noop",
}

setmetatable(Parser.Types, {
	__index = function(_, index)
		for id, type in pairs(Parser.Types) do
			if type == index then
				return id
			end
		end
        return nil
	end,
})

function Parser:Encode(packets)
	local payload = ""

	for _, packet in pairs(packets) do
		payload = payload
			.. ("%d:%d%s"):format(
				packet.Data and #packet.Data + 1 or 1,
				Parser.Types[packet.Type],
				packet.Data or ""
			)
	end

	return payload
end

function Parser:Decode(str)
	local packets = {}

	repeat
		local length, id, data = str:match("^(%d+):b?(%d)")

		str = str:sub(#length + 1 + #id + 1)

		length = tonumber(length)
		id = tonumber(id)

		if length > 1 then
			data = str:sub(1, length - 1)
			str = str:sub(length)
		end

		table.insert(packets, {
			Type = Parser.Types[id],
			Data = data,
		})
	until #str == 0

	return packets
end

return Parser
