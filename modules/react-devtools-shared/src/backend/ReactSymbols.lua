-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-devtools-shared/src/backend/ReactSymbols.js
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
]]
local exports = {}
<<<<<<< HEAD
exports.CONCURRENT_MODE_NUMBER = 0xeacf
exports.CONCURRENT_MODE_SYMBOL_STRING = "Symbol(react.concurrent_mode)"

exports.CONTEXT_NUMBER = 0xeace
exports.CONTEXT_SYMBOL_STRING = "Symbol(react.context)"

exports.DEPRECATED_ASYNC_MODE_SYMBOL_STRING = "Symbol(react.async_mode)"

exports.ELEMENT_NUMBER = 0xeac7
exports.ELEMENT_SYMBOL_STRING = "Symbol(react.element)"

exports.DEBUG_TRACING_MODE_NUMBER = 0xeae1
exports.DEBUG_TRACING_MODE_SYMBOL_STRING = "Symbol(react.debug_trace_mode)"

exports.FORWARD_REF_NUMBER = 0xead0
exports.FORWARD_REF_SYMBOL_STRING = "Symbol(react.forward_ref)"

exports.FRAGMENT_NUMBER = 0xeacb
exports.FRAGMENT_SYMBOL_STRING = "Symbol(react.fragment)"

exports.LAZY_NUMBER = 0xead4
exports.LAZY_SYMBOL_STRING = "Symbol(react.lazy)"

exports.MEMO_NUMBER = 0xead3
exports.MEMO_SYMBOL_STRING = "Symbol(react.memo)"

exports.OPAQUE_ID_NUMBER = 0xeae0
exports.OPAQUE_ID_SYMBOL_STRING = "Symbol(react.opaque.id)"

exports.PORTAL_NUMBER = 0xeaca
exports.PORTAL_SYMBOL_STRING = "Symbol(react.portal)"

exports.PROFILER_NUMBER = 0xead2
exports.PROFILER_SYMBOL_STRING = "Symbol(react.profiler)"

exports.PROVIDER_NUMBER = 0xeacd
exports.PROVIDER_SYMBOL_STRING = "Symbol(react.provider)"

exports.SCOPE_NUMBER = 0xead7
exports.SCOPE_SYMBOL_STRING = "Symbol(react.scope)"

exports.STRICT_MODE_NUMBER = 0xeacc
exports.STRICT_MODE_SYMBOL_STRING = "Symbol(react.strict_mode)"

exports.SUSPENSE_NUMBER = 0xead1
exports.SUSPENSE_SYMBOL_STRING = "Symbol(react.suspense)"

exports.SUSPENSE_LIST_NUMBER = 0xead8
exports.SUSPENSE_LIST_SYMBOL_STRING = "Symbol(react.suspense_list)"

=======
-- This list should be kept updated to reflect additions to 'shared/ReactSymbols'.
-- DevTools can't import symbols from 'shared/ReactSymbols' directly for two reasons:
-- 1. DevTools requires symbols which may have been deleted in more recent versions (e.g. concurrent mode)
-- 2. DevTools must support both Symbol and numeric forms of each symbol;
--    Since e.g. standalone DevTools runs in a separate process, it can't rely on its own ES capabilities.
local CONCURRENT_MODE_NUMBER = 0xeacf
exports.CONCURRENT_MODE_NUMBER = CONCURRENT_MODE_NUMBER
local CONCURRENT_MODE_SYMBOL_STRING = "Symbol(react.concurrent_mode)"
exports.CONCURRENT_MODE_SYMBOL_STRING = CONCURRENT_MODE_SYMBOL_STRING
local CONTEXT_NUMBER = 0xeace
exports.CONTEXT_NUMBER = CONTEXT_NUMBER
local CONTEXT_SYMBOL_STRING = "Symbol(react.context)"
exports.CONTEXT_SYMBOL_STRING = CONTEXT_SYMBOL_STRING
local SERVER_CONTEXT_SYMBOL_STRING = "Symbol(react.server_context)"
exports.SERVER_CONTEXT_SYMBOL_STRING = SERVER_CONTEXT_SYMBOL_STRING
local DEPRECATED_ASYNC_MODE_SYMBOL_STRING = "Symbol(react.async_mode)"
exports.DEPRECATED_ASYNC_MODE_SYMBOL_STRING = DEPRECATED_ASYNC_MODE_SYMBOL_STRING
local ELEMENT_NUMBER = 0xeac7
exports.ELEMENT_NUMBER = ELEMENT_NUMBER
local ELEMENT_SYMBOL_STRING = "Symbol(react.element)"
exports.ELEMENT_SYMBOL_STRING = ELEMENT_SYMBOL_STRING
local DEBUG_TRACING_MODE_NUMBER = 0xeae1
exports.DEBUG_TRACING_MODE_NUMBER = DEBUG_TRACING_MODE_NUMBER
local DEBUG_TRACING_MODE_SYMBOL_STRING = "Symbol(react.debug_trace_mode)"
exports.DEBUG_TRACING_MODE_SYMBOL_STRING = DEBUG_TRACING_MODE_SYMBOL_STRING
local FORWARD_REF_NUMBER = 0xead0
exports.FORWARD_REF_NUMBER = FORWARD_REF_NUMBER
local FORWARD_REF_SYMBOL_STRING = "Symbol(react.forward_ref)"
exports.FORWARD_REF_SYMBOL_STRING = FORWARD_REF_SYMBOL_STRING
local FRAGMENT_NUMBER = 0xeacb
exports.FRAGMENT_NUMBER = FRAGMENT_NUMBER
local FRAGMENT_SYMBOL_STRING = "Symbol(react.fragment)"
exports.FRAGMENT_SYMBOL_STRING = FRAGMENT_SYMBOL_STRING
local LAZY_NUMBER = 0xead4
exports.LAZY_NUMBER = LAZY_NUMBER
local LAZY_SYMBOL_STRING = "Symbol(react.lazy)"
exports.LAZY_SYMBOL_STRING = LAZY_SYMBOL_STRING
local MEMO_NUMBER = 0xead3
exports.MEMO_NUMBER = MEMO_NUMBER
local MEMO_SYMBOL_STRING = "Symbol(react.memo)"
exports.MEMO_SYMBOL_STRING = MEMO_SYMBOL_STRING
local PORTAL_NUMBER = 0xeaca
exports.PORTAL_NUMBER = PORTAL_NUMBER
local PORTAL_SYMBOL_STRING = "Symbol(react.portal)"
exports.PORTAL_SYMBOL_STRING = PORTAL_SYMBOL_STRING
local PROFILER_NUMBER = 0xead2
exports.PROFILER_NUMBER = PROFILER_NUMBER
local PROFILER_SYMBOL_STRING = "Symbol(react.profiler)"
exports.PROFILER_SYMBOL_STRING = PROFILER_SYMBOL_STRING
local PROVIDER_NUMBER = 0xeacd
exports.PROVIDER_NUMBER = PROVIDER_NUMBER
local PROVIDER_SYMBOL_STRING = "Symbol(react.provider)"
exports.PROVIDER_SYMBOL_STRING = PROVIDER_SYMBOL_STRING
local SCOPE_NUMBER = 0xead7
exports.SCOPE_NUMBER = SCOPE_NUMBER
local SCOPE_SYMBOL_STRING = "Symbol(react.scope)"
exports.SCOPE_SYMBOL_STRING = SCOPE_SYMBOL_STRING
local STRICT_MODE_NUMBER = 0xeacc
exports.STRICT_MODE_NUMBER = STRICT_MODE_NUMBER
local STRICT_MODE_SYMBOL_STRING = "Symbol(react.strict_mode)"
exports.STRICT_MODE_SYMBOL_STRING = STRICT_MODE_SYMBOL_STRING
local SUSPENSE_NUMBER = 0xead1
exports.SUSPENSE_NUMBER = SUSPENSE_NUMBER
local SUSPENSE_SYMBOL_STRING = "Symbol(react.suspense)"
exports.SUSPENSE_SYMBOL_STRING = SUSPENSE_SYMBOL_STRING
local SUSPENSE_LIST_NUMBER = 0xead8
exports.SUSPENSE_LIST_NUMBER = SUSPENSE_LIST_NUMBER
local SUSPENSE_LIST_SYMBOL_STRING = "Symbol(react.suspense_list)"
exports.SUSPENSE_LIST_SYMBOL_STRING = SUSPENSE_LIST_SYMBOL_STRING
local SERVER_CONTEXT_DEFAULT_VALUE_NOT_LOADED_SYMBOL_STRING = "Symbol(react.server_context.defaultValue)"
exports.SERVER_CONTEXT_DEFAULT_VALUE_NOT_LOADED_SYMBOL_STRING = SERVER_CONTEXT_DEFAULT_VALUE_NOT_LOADED_SYMBOL_STRING
>>>>>>> upstream-apply
return exports
