<<<<<<< HEAD
-- ROBLOX upstream: https://github.com/facebook/react/blob/56e9feead0f91075ba0a4f725c9e4e343bca1c67/packages/react-reconciler/src/ReactWorkTags.js
--!strict
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-reconciler/src/ReactWorkTags.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]

export type WorkTag = number
<<<<<<< HEAD

return {
	FunctionComponent = 0,
	ClassComponent = 1,
	IndeterminateComponent = 2, -- Before we know whether it is function or class
	HostRoot = 3, -- Root of a host tree. Could be nested inside another node.
	HostPortal = 4, -- A subtree. Could be an entry point to a different renderer.
	HostComponent = 5,
	HostText = 6,
	Fragment = 7,
	Mode = 8,
	ContextConsumer = 9,
	ContextProvider = 10,
	ForwardRef = 11,
	Profiler = 12,
	SuspenseComponent = 13,
	MemoComponent = 14,
	SimpleMemoComponent = 15,
	LazyComponent = 16,
	IncompleteClassComponent = 17,
	DehydratedFragment = 18,
	SuspenseListComponent = 19,
	FundamentalComponent = 20,
	ScopeComponent = 21,
	Block = 22,
	OffscreenComponent = 23,
	LegacyHiddenComponent = 24,
}
=======
local FunctionComponent = 0
exports.FunctionComponent = FunctionComponent
local ClassComponent = 1
exports.ClassComponent = ClassComponent
local IndeterminateComponent = 2
exports.IndeterminateComponent = IndeterminateComponent -- Before we know whether it is function or class
local HostRoot = 3
exports.HostRoot = HostRoot -- Root of a host tree. Could be nested inside another node.
local HostPortal = 4
exports.HostPortal = HostPortal -- A subtree. Could be an entry point to a different renderer.
local HostComponent = 5
exports.HostComponent = HostComponent
local HostText = 6
exports.HostText = HostText
local Fragment = 7
exports.Fragment = Fragment
local Mode = 8
exports.Mode = Mode
local ContextConsumer = 9
exports.ContextConsumer = ContextConsumer
local ContextProvider = 10
exports.ContextProvider = ContextProvider
local ForwardRef = 11
exports.ForwardRef = ForwardRef
local Profiler = 12
exports.Profiler = Profiler
local SuspenseComponent = 13
exports.SuspenseComponent = SuspenseComponent
local MemoComponent = 14
exports.MemoComponent = MemoComponent
local SimpleMemoComponent = 15
exports.SimpleMemoComponent = SimpleMemoComponent
local LazyComponent = 16
exports.LazyComponent = LazyComponent
local IncompleteClassComponent = 17
exports.IncompleteClassComponent = IncompleteClassComponent
local DehydratedFragment = 18
exports.DehydratedFragment = DehydratedFragment
local SuspenseListComponent = 19
exports.SuspenseListComponent = SuspenseListComponent
local ScopeComponent = 21
exports.ScopeComponent = ScopeComponent
local OffscreenComponent = 22
exports.OffscreenComponent = OffscreenComponent
local LegacyHiddenComponent = 23
exports.LegacyHiddenComponent = LegacyHiddenComponent
local CacheComponent = 24
exports.CacheComponent = CacheComponent
local TracingMarkerComponent = 25
exports.TracingMarkerComponent = TracingMarkerComponent
return exports
>>>>>>> upstream-apply
