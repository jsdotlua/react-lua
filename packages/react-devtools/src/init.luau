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

return nil
