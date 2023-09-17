-- _G.__PROFILE__ = true
_G.__DEV__ = true
-- do
-- 	return
-- end

local createPluginToolbar = require(script.Parent.createPluginToolbar)
local teardown = require(script.Parent.teardown).teardown

local teardownPlugin = createPluginToolbar(plugin)

plugin.Unloading:Connect(function()
	teardown(teardownPlugin)
end)
