-- Based on an old Engine.io socket implementation by Reselim:
-- https://github.com/Reselim/rbx-engine.io

local HttpService = game:GetService("HttpService")

local Transport = require("./transport")
local Emitter = require("./emitter")
local Timer = require("./timer")

local Types = require("./types")
type Socket = Types.Socket

local Socket = setmetatable({}, Emitter)
Socket.__index = Socket

function Socket.new(uri: string?, path: string?): Socket
	local self = setmetatable(Emitter.new(), Socket)

	if uri then
		local schema = uri:match("^(%w+)://")
		local host = uri:gsub("^%w+://", ""):match("^([%w%.%-]+:?%d*)")

		self.Host = host
		self.Secure = schema == "https" or schema == "wss"
	else
		self.Host = "localhost"
		self.Secure = false
	end

	self.Path = path or "/engine.io"

	self:Open()

	return self :: any
end

function Socket:Open()
	self._transport = Transport.new({
		Host = self.Host,
		Secure = self.Secure,
		Path = self.Path,
	})

	self._transport:On("packet", function(packet)
		if packet.Type == "open" then
			local data = HttpService:JSONDecode(packet.Data)

			self._transport.Id = data.sid

			self._pingTimeout = data.pingTimeout / 1000
			self._pingInterval = data.pingInterval / 1000

			self._pingTimer = Timer.new(function()
				self:Ping()
			end):Start(self._pingInterval)

			self:Emit("open")
		end

		if packet.Type == "error" then
			self:Close(true)
		else
			self:Emit(packet.Type, packet.Data)
		end
	end)

	self._transport:On("error", function()
		self:Close(true)
	end)
end

function Socket:Ping()
	self:Emit("ping")

	task.spawn(function()
		local success = false

		task.delay(self._pingTimeout, function()
			if not success then
				self:Close(true, "Timed out")
			end
		end)

		self._transport:Write({ Type = "ping" })
		self:Wait("pong")

		success = true
	end)
end

function Socket:Send(data)
	self._transport:Write({
		Type = "message",
		Data = data,
	})
end

function Socket:Close(error)
	if error then
		self:Emit("close", true)
	else
		self._transport:Write({ Type = "close" })
		self._transport:Flush(true)
	end

	self._transport:Close()

	if self._pingTimer then
		self._pingTimer:Stop()
	end
end

return {
	new = Socket.new,
}
