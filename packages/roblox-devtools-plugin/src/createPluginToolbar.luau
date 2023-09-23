local Packages = script.Parent.Packages

local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local RobloxDevtools = require(script.Parent.RobloxDevtools)
local teardown = require(script.Parent.teardown)
type Teardown = Teardown.Teardown

local function createPluginToolbar(plugin: Plugin): Teardown
	local pluginToolbar = plugin:CreateToolbar("React Devtools Extension")
	local openDevtoolsButton = pluginToolbar:CreateButton("Open", "", "")

	local pluginGui = plugin:CreateDockWidgetPluginGui(
		"react-dev-tools",
		DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Right, true, false, 400, 300, 200, 300)
	)
	pluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pluginGui.Title = "React Devtools Extension"
	pluginGui.Name = pluginGui.Title

	local root = nil

	local function updateDevtoolsWindow(enabled: boolean)
		if not enabled and root ~= nil then
			root:unmount()
			root = nil
			return
		end
		if enabled and root == nil then
			local container = Instance.new("Folder")
			container.Name = "View"
			container.Parent = pluginGui
			local element = React.createElement(RobloxDevtools)

			root = ReactRoblox.createRoot(container)

			root:render(element, container)
		end
	end

	local function toggleDevtoolsWindow()
		pluginGui.Enabled = not pluginGui.Enabled

		updateDevtoolsWindow(pluginGui.Enabled)
	end

	updateDevtoolsWindow(pluginGui.Enabled)

	local openDevtoolsConnection = openDevtoolsButton.Click:Connect(toggleDevtoolsWindow)

	return function()
		if root then
			root:unmount()
			root = nil
		end
		teardown.teardown(openDevtoolsConnection, pluginGui)
	end
end

return createPluginToolbar
