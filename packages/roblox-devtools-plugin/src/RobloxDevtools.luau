local Packages = script.Parent.Packages

local React = require(Packages.React)
local ReactDevtoolsShared = require(Packages.ReactDevtoolsShared)
local DevTools = ReactDevtoolsShared.devtools.devtools.Components.views.DevTools.DevTools

local setupDevtools = require(script.Parent.setupDevtools)

local function RobloxDevtools(_: {})
	local data, setData = React.useState(nil)

	React.useEffect(function()
		if not data then
			-- print("setupDevtools!")
			local devtoolsSetupData = setupDevtools()

			setData({
				store = devtoolsSetupData.store,
				bridge = devtoolsSetupData.bridge,
			})
		end
		return
	end, { data or false })

	return React.createElement(
		"Frame",
		{
			BackgroundColor3 = Color3.fromRGB(235, 235, 235),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		},
		if data
			then React.createElement(DevTools, {
				bridge = data.bridge, --((bridge:: any):: FrontendBridge),
				-- canViewElementSourceFunction = canViewElementSourceFunction,
				showTabBar = true,
				store = data.store, --((store:: any):: Store),
				warnIfLegacyBackendDetected = true,
				-- viewElementSourceFunction = viewElementSourceFunction,
			})
			-- print("DEV TOOLS DATA=", data)
			-- 		return React.createElement("TextLabel", {
			-- 			BackgroundTransparency = 1,
			-- 			BorderSizePixel = 0,
			-- 			Size = UDim2.new(1, 0, 1, 0),
			-- 			Text = "Devtools have loaded!",
			-- 		})
			else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = "Devtools not loaded",
			})
	)
end

return RobloxDevtools
