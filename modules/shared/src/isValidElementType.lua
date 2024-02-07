<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/b61174fb7b09580c1ec2a8f55e73204b706d2935/packages/shared/isValidElementType.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/shared/isValidElementType.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
<<<<<<< HEAD
 *
 ]]
local ReactSymbols = require("./ReactSymbols")
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_PROFILER_TYPE = ReactSymbols.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = ReactSymbols.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_STRICT_MODE_TYPE = ReactSymbols.REACT_STRICT_MODE_TYPE
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
-- local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local REACT_FUNDAMENTAL_TYPE = ReactSymbols.REACT_FUNDAMENTAL_TYPE
-- local REACT_SCOPE_TYPE = ReactSymbols.REACT_SCOPE_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE
local REACT_SERVER_BLOCK_TYPE = ReactSymbols.REACT_SERVER_BLOCK_TYPE
local REACT_LEGACY_HIDDEN_TYPE = ReactSymbols.REACT_LEGACY_HIDDEN_TYPE

-- local ReactFeatureFlags = require("./ReactFeatureFlags")
-- local enableScopeAPI = ReactFeatureFlags.enableScopeAPI

return function(type)
	local typeofType = typeof(type)
	if typeofType == "string" or typeofType == "function" then
		return true
	end

	-- Note: typeof might be other than 'symbol' or 'number' (e.g. if it's a polyfill).
	if
		type == REACT_FRAGMENT_TYPE
		or type == REACT_PROFILER_TYPE
		or type == REACT_DEBUG_TRACING_MODE_TYPE
		or type == REACT_STRICT_MODE_TYPE
		or type == REACT_SUSPENSE_TYPE
		or type == REACT_LEGACY_HIDDEN_TYPE
		-- ROBLOX performance: eliminate compares that will only be true in React 18
		-- or type == REACT_SUSPENSE_LIST_TYPE
		-- or (enableScopeAPI and type == REACT_SCOPE_TYPE)
	then
		return true
	end

	if typeofType == "table" then
		-- ROBLOX deviation: In React, component classes are of type 'function'; for
		-- us, they're tables with a special value on their metatable
		if type.isReactComponent then
			return true
		end

		if
			type["$$typeof"] == REACT_LAZY_TYPE
			or type["$$typeof"] == REACT_MEMO_TYPE
			or type["$$typeof"] == REACT_PROVIDER_TYPE
			or type["$$typeof"] == REACT_CONTEXT_TYPE
			or type["$$typeof"] == REACT_FORWARD_REF_TYPE
			or type["$$typeof"] == REACT_FUNDAMENTAL_TYPE
			or type["$$typeof"] == REACT_BLOCK_TYPE
			or type[1] == REACT_SERVER_BLOCK_TYPE
=======
 * @flow
 ]]
local Packages --[[ ROBLOX comment: must define Packages module ]]
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Symbol = LuauPolyfill.Symbol
local exports = {}
local sharedReactSymbolsModule = require(Packages.shared.ReactSymbols)
local REACT_CONTEXT_TYPE = sharedReactSymbolsModule.REACT_CONTEXT_TYPE
local REACT_FORWARD_REF_TYPE = sharedReactSymbolsModule.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = sharedReactSymbolsModule.REACT_FRAGMENT_TYPE
local REACT_PROFILER_TYPE = sharedReactSymbolsModule.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = sharedReactSymbolsModule.REACT_PROVIDER_TYPE
local REACT_DEBUG_TRACING_MODE_TYPE = sharedReactSymbolsModule.REACT_DEBUG_TRACING_MODE_TYPE
local REACT_STRICT_MODE_TYPE = sharedReactSymbolsModule.REACT_STRICT_MODE_TYPE
local REACT_SUSPENSE_TYPE = sharedReactSymbolsModule.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = sharedReactSymbolsModule.REACT_SUSPENSE_LIST_TYPE
local REACT_MEMO_TYPE = sharedReactSymbolsModule.REACT_MEMO_TYPE
local REACT_LAZY_TYPE = sharedReactSymbolsModule.REACT_LAZY_TYPE
local REACT_SCOPE_TYPE = sharedReactSymbolsModule.REACT_SCOPE_TYPE
local REACT_LEGACY_HIDDEN_TYPE = sharedReactSymbolsModule.REACT_LEGACY_HIDDEN_TYPE
local REACT_OFFSCREEN_TYPE = sharedReactSymbolsModule.REACT_OFFSCREEN_TYPE
local REACT_CACHE_TYPE = sharedReactSymbolsModule.REACT_CACHE_TYPE
local REACT_TRACING_MARKER_TYPE = sharedReactSymbolsModule.REACT_TRACING_MARKER_TYPE
local reactFeatureFlagsModule = require(script.Parent.ReactFeatureFlags)
local enableScopeAPI = reactFeatureFlagsModule.enableScopeAPI
local enableCacheElement = reactFeatureFlagsModule.enableCacheElement
local enableTransitionTracing = reactFeatureFlagsModule.enableTransitionTracing
local enableDebugTracing = reactFeatureFlagsModule.enableDebugTracing
local enableLegacyHidden = reactFeatureFlagsModule.enableLegacyHidden
local enableSymbolFallbackForWWW = reactFeatureFlagsModule.enableSymbolFallbackForWWW
local REACT_MODULE_REFERENCE
if Boolean.toJSBoolean(enableSymbolFallbackForWWW) then
	if typeof(Symbol) == "function" then
		REACT_MODULE_REFERENCE = Symbol.for_("react.module.reference")
	else
		REACT_MODULE_REFERENCE = 0
	end
else
	REACT_MODULE_REFERENCE = Symbol.for_("react.module.reference")
end
local function isValidElementType(type_)
	if typeof(type_) == "string" or typeof(type_) == "function" then
		return true
	end -- Note: typeof might be other than 'symbol' or 'number' (e.g. if it's a polyfill).
	if
		Boolean.toJSBoolean((function()
			local ref = type_ == REACT_FRAGMENT_TYPE
				or type_ == REACT_PROFILER_TYPE
				or (
					if Boolean.toJSBoolean(enableDebugTracing)
						then type_ == REACT_DEBUG_TRACING_MODE_TYPE
						else enableDebugTracing
				)
			local ref = Boolean.toJSBoolean(ref) and ref or type_ == REACT_STRICT_MODE_TYPE
			local ref = Boolean.toJSBoolean(ref) and ref or type_ == REACT_SUSPENSE_TYPE
			local ref = Boolean.toJSBoolean(ref) and ref or type_ == REACT_SUSPENSE_LIST_TYPE
			local ref = Boolean.toJSBoolean(ref) and ref
				or (
					if Boolean.toJSBoolean(enableLegacyHidden)
						then type_ == REACT_LEGACY_HIDDEN_TYPE
						else enableLegacyHidden
				)
			local ref = Boolean.toJSBoolean(ref) and ref or type_ == REACT_OFFSCREEN_TYPE
			local ref = Boolean.toJSBoolean(ref) and ref
				or (if Boolean.toJSBoolean(enableScopeAPI) then type_ == REACT_SCOPE_TYPE else enableScopeAPI)
			local ref = Boolean.toJSBoolean(ref) and ref
				or (if Boolean.toJSBoolean(enableCacheElement) then type_ == REACT_CACHE_TYPE else enableCacheElement)
			return Boolean.toJSBoolean(ref) and ref
				or (
					if Boolean.toJSBoolean(enableTransitionTracing)
						then type_ == REACT_TRACING_MARKER_TYPE
						else enableTransitionTracing
				)
		end)())
	then
		return true
	end
	if typeof(type_) == "table" and type_ ~= nil then
		if
			type_["$$typeof"] == REACT_LAZY_TYPE
			or type_["$$typeof"] == REACT_MEMO_TYPE
			or type_["$$typeof"] == REACT_PROVIDER_TYPE
			or type_["$$typeof"] == REACT_CONTEXT_TYPE
			or type_["$$typeof"] == REACT_FORWARD_REF_TYPE -- This needs to include all possible module reference object
			-- types supported by any Flight configuration anywhere since
			-- we don't know which Flight build this will end up being used
			-- with.
			or type_["$$typeof"] == REACT_MODULE_REFERENCE
			or type_.getModuleId ~= nil
>>>>>>> upstream-apply
		then
			return true
		end
	end
<<<<<<< HEAD

	return false
end
=======
	return false
end
exports.default = isValidElementType
return exports
>>>>>>> upstream-apply
