local HttpService = game:GetService("HttpService")

local Parser = require("./parser")
local Emitter = require("./emitter")

local Transport = setmetatable({}, Emitter)
Transport.__index = Transport

function Transport.new(options)
	local self = setmetatable(Emitter.new(), Transport)

	self.Host = options.Host
	self.Secure = options.Secure
	self.Path = options.Path

	self._writeBuffer = {}

	self._flushing = false
	self._open = false

	self:Open()

	return self
end

function Transport:Open()
	self._open = true
	self:Read()
end

function Transport:Close()
	self._open = false
end

function Transport:Read()
	if self._open then
		task.spawn(function()
			local success, response =
				pcall(HttpService.GetAsync, HttpService, self:URI(), true)

			if success then
				for _, packet in pairs(Parser:Decode(response)) do
					self:Emit("packet", packet)
				end

				self:Read()
			else
				self:Emit("error", response)
			end
		end)
	end
end

function Transport:Write(packet)
	table.insert(self._writeBuffer, packet)
	self:Flush()
end

function Transport:Flush(force)
	if (self._open and not self._flushing and #self._writeBuffer > 0) or force then
		self._flushing = true

		task.spawn(function()
			local data = Parser:Encode(self._writeBuffer)
			local success, response =
				pcall(HttpService.PostAsync, HttpService, self:URI(), data)

			if success then
				self._writeBuffer = {}
				self._flushing = false

				self:Flush()
			else
				self:Emit("error", response)
			end
		end)
	end
end

function Transport:URI()
	local uri = ("%s://%s%s"):format(
		self.Secure and "https" or "http",
		self.Host,
		self.Path:gsub("/$", "") .. "/"
	)

	local query = {
		b64 = 1,
		transport = "polling",
		sid = self.Id,
	}

	local parameters = {}

	for key, value in pairs(query) do
		table.insert(parameters, key .. "=" .. value)
	end

	return uri .. "?" .. table.concat(parameters, "&")
end

return Transport
