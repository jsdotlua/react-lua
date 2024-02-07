<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/a89854bc936668d325cac9a22e2ebfa128c7addf/packages/shared/ReactVersion.js
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/ReactVersion.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 ]]

-- TODO: this is special because it gets imported during build.
<<<<<<< HEAD
return "17.1.0"
=======
--
-- TODO: 18.0.0 has not been released to NPM;
-- It exists as a placeholder so that DevTools can support work tag changes between releases.
-- When we next publish a release, update the matching TODO in backend/renderer.js
-- TODO: This module is used both by the release scripts and to expose a version
-- at runtime. We should instead inject the version number as part of the build
-- process, and use the ReactVersions.js module as the single source of truth.
exports.default = "18.1.0"
return exports
>>>>>>> upstream-apply
