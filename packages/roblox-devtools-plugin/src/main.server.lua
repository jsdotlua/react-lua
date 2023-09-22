_G.__DEV__ = true
-- _G.__DEBUG__ = true

local RunService = game:GetService("RunService")

local runModes = {
	run = RunService:IsRunMode(),
	studio = RunService:IsStudio(),
	server = RunService:IsServer(),
	client = RunService:IsClient(),
	edit = RunService:IsEdit(),
}

if runModes.run then
	return
end

if runModes.edit then
	return
end

-- print("\nrunModes", runModes)

local createPluginToolbar = require(script.Parent.createPluginToolbar)
local teardown = require(script.Parent.teardown).teardown

local teardownPlugin = createPluginToolbar(plugin)

plugin.Unloading:Connect(function()
	teardown(teardownPlugin)
end)
