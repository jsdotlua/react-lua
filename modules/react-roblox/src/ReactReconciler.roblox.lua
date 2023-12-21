--!strict
-- ROBLOX deviation: Initializes the reconciler with this package's host
-- config and returns the resulting module

local initializeReconciler = require("@pkg/@jsdotlua/react-reconciler")

local ReactRobloxHostConfig = require("./client/ReactRobloxHostConfig")

return initializeReconciler(ReactRobloxHostConfig)
