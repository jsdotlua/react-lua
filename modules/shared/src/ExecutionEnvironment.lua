--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/ExecutionEnvironment.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]
local exports = {}

exports.canUseDOM = function()
	-- ROBLOX deviation START
	return false
	-- ROBLOX deviation END
end

return exports
