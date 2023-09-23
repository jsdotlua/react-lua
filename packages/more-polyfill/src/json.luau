local HttpService = game:GetService("HttpService")
local JSON = {}

function JSON.parse(value: string): any
	return HttpService:JSONDecode(value)
end

function JSON.stringify(value: unknown, replacer: nil, space: nil): string
	return HttpService:JSONEncode(value)
end

return JSON
