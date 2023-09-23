--!strict
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent

local connectToDevTools = require(Packages.ReactDevtoolsCore).backend.connectToDevTools

-- Connect immediately with default options.
-- If you need more control, use `react-devtools-core` directly instead of `react-devtools`.
connectToDevTools()

-- deviation: we need to inject devtools again
local ReactReconciler = require(Packages.ReactReconciler)({})

local function mockFindFiberByHostInstance()
	warn("mockFindFiberByHostInstance")
	return nil
end

ReactReconciler.injectIntoDevTools({
	findFiberByHostInstance = mockFindFiberByHostInstance,
	bundleType = if _G.__DEV__ then 1 else 0,
	version = "17.0.2",
	rendererPackageName = "ReactRoblox",
})

return nil
