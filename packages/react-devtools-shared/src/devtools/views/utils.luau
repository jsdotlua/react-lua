-- Bad regex. Make it not match anything.
-- TODO: maybe warn in console?
-- Bad regex. Make it not match anything.
-- TODO: maybe warn in console?
-- upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/devtools/views/utils.js
-- /**
--  * Copyright (c) Facebook, Inc. and its affiliates.
--  *
--  * This source code is licensed under the MIT license found in the
--  * LICENSE file in the root directory of this source tree.
--  *
--  * @flow
--  */

local Packages = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
type Object = LuauPolyfill.Object

local RegexLua = require(Packages.RegexLua)
type Regexp = RegexLua.Regexp

-- deviation: `escapeStringRegExp` needs regex replace functionality for its implementation
-- but Regex-Lua has not implemented it yet.
-- import escapeStringRegExp from 'escape-string-regexp';
local function escapeStringRegExp(value: string): string
	return value
end

local meta = require(script.Parent.Parent.Parent.hydration).meta
local formatDataForPreview = require(script.Parent.Parent.Parent.utils).formatDataForPreview
local ReactDebugHooksModule = require(Packages.ReactDebugTools)
type HooksTree = ReactDebugHooksModule.HooksTree

local exports = {}

local function alphaSortEntries(
	-- deviation: Luau does not have tuple types
	entryA: { string | mixed },
	entryB: { string | mixed }
): number
	local a = entryA[0] :: string
	local b = entryB[0] :: string
	if "" .. tonumber(a) == a then
		if "" .. tonumber(b) ~= b then
			return -1
		end
		return if tonumber(a) < tonumber(b) then -1 else 1
	end
	return if a < b then -1 else 1
end
exports.alphaSortEntries = alphaSortEntries

local function createRegExp(string_: string): RegExp
	-- Allow /regex/ syntax with optional last /
	if string.sub(string_, 1, 1) == "/" then
		-- Cut off first slash
		string_ = string.sub(string_, 2)
		-- Cut off last slash, but only if it's there
		if string.sub(string_, -1, -1) == "/" then
			string_ = string.sub(string_, 1, -1)
		end
		local success, result: any = pcall(function()
			return RegExp(string_, "i")
		end)
		if success then
			return result
		else
			-- Bad regex. Make it not match anything.
			-- TODO: maybe warn in console?
			return RegExp(".^")
		end
	end

	local function isLetter(char: string): boolean
		return string.lower(char) ~= string.upper(char)
	end

	local function matchAnyCase(char: string)
		if not isLetter(char) then
			-- Don't mess with special characters like [.
			return char
		end
		return "[" .. string.lower(char) .. string.upper(char) .. "]"
	end

	-- 'item' should match 'Item' and 'ListItem', but not 'InviteMom'.
	-- To do this, we'll slice off 'tem' and check first letter separately.
	local escaped = escapeStringRegExp(string_)
	local firstChar = string.sub(escaped, 1, 1)
	local restRegex = ""
	-- For 'item' input, restRegex becomes '[tT][eE][mM]'
	-- We can't simply make it case-insensitive because first letter case matters.
	for i = 1, #escaped do
		restRegex ..= matchAnyCase(string.sub(escaped, i, i))
	end

	if not isLetter(firstChar) then
		-- We can't put a non-character like [ in a group
		-- so we fall back to the simple case.
		return RegExp(firstChar + restRegex)
	end

	-- Construct a smarter regex.
	return RegExp(
		-- For example:
		-- (^[iI]|I)[tT][eE][mM]
		-- Matches:
		-- 'Item'
		-- 'ListItem'
		-- but not 'InviteMom'
		"(^"
			.. matchAnyCase(firstChar)
			.. "|"
			.. string.upper(firstChar)
			.. ")"
			.. restRegex
	)
end
exports.createRegExp = createRegExp

local function getMetaValueLabel(data: Object): string | nil
	if hasOwnProperty.call(data, meta.preview_long) then
		return data[meta.preview_long]
	else
		return formatDataForPreview(data, true)
	end
end
exports.getMetaValueLabel = getMetaValueLabel

local function sanitize(data: Object): ()
	for key, value in data do
		if value and value[meta.type] then
			data[key] = getMetaValueLabel(value)
		elseif value ~= nil then
			if Array.isArray(value) then
				sanitize(value)
			elseif type(value) == "table" then
				sanitize(value)
			end
		end
	end
end

local function serializeDataForCopy(props: Object): string
	local cloned = Object.assign({}, props)

	sanitize(cloned)

	local success, result: any = pcall(function()
		return JSON.stringify(cloned, nil, 2)
	end)
	if success then
		return result
	else
		return ""
	end
end
exports.serializeDataForCopy = serializeDataForCopy

local function serializeHooksForCopy(hooks: HooksTree | nil): string
	-- $FlowFixMe "HooksTree is not an object"
	local cloned = Object.assign({}, hooks)

	local queue = table.clone(cloned)

	while #queue > 0 do
		local current = table.remove(queue)

		-- These aren't meaningful
		current.id = nil
		current.isStateEditable = nil

		if #current.subHooks > 0 then
			for _, subHook in current.subHooks do
				table.insert(queue, subHook)
			end
		end
	end

	sanitize(cloned)

	local success, result: any = pcall(function()
		return JSON.stringify(cloned, nil, 2)
	end)
	if success then
		return result
	else
		return ""
	end
end
exports.serializeHooksForCopy = serializeHooksForCopy

-- Keeping this in memory seems to be enough to enable the browser to download larger profiles.
-- Without this, we would see a "Download failed: network error" failure.
local downloadUrl = nil

local function downloadFile(element: HTMLAnchorElement, filename: string, text: string): ()
	local blob = Blob.new({ text }, { type = "text/plain;charset=utf-8" })

	if downloadUrl ~= nil then
		URL.revokeObjectURL(downloadUrl)
	end

	downloadUrl = URL.createObjectURL(blob)

	element:setAttribute("href", downloadUrl)
	element:setAttribute("download", filename)

	element:click()
end
exports.downloadFile = downloadFile

local function truncateText(text: string, maxLength: number): string
	local length = string.len(text)
	if length > maxLength then
		error("todo: not implemented")
		-- return LuauPolyfill.String. (text.substr(0, Math.floor(maxLength / 2)) + "…" + text.substr(length - Math.ceil(maxLength / 2) - 1))
	else
		return text
	end
end
exports.truncateText = truncateText

return exports
