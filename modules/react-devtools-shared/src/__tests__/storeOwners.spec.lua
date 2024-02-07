<<<<<<< HEAD
--!strict
-- ROBLOX upstream: https://github.com/facebook/react/blob/v17.0.1/packages/react-devtools-shared/src/__tests__/storeOwners-test.js
=======
-- ROBLOX upstream: https://github.com/facebook/react/blob/v18.2.0/packages/react-devtools-shared/src/__tests__/storeOwners-test.js
>>>>>>> upstream-apply
--[[*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 ]]

local Packages = script.Parent.Parent.Parent
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach

local global = _G
local ReactRoblox

-- ROBLOX Deviation: Skip test in nonDev mode
local describeIfDev = _G.DEV and describe or describe.skip :: any
describeIfDev("Store owners list", function()
	local React
<<<<<<< HEAD
	local LuauPolyfill
	local Boolean
=======
>>>>>>> upstream-apply
	local act
	local legacyRender
	local store
	local devtoolsUtils
	local printOwnersList

	beforeEach(function()
		store = global.store
<<<<<<< HEAD
		store:setCollapseNodesByDefault(false)

		LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
		Boolean = LuauPolyfill.Boolean
		React = require("@pkg/@jsdotlua/react")
		ReactRoblox = require("@pkg/@jsdotlua/react-roblox")
		devtoolsUtils = require("./devtools/utils")
		printOwnersList = devtoolsUtils.printOwnersList

		local utils = require("./utils")
		act = utils.act
	end)

=======
		store.collapseNodesByDefault = false
		React = require_("react")
		local utils = require_("./utils")
		act = utils.act
		legacyRender = utils.legacyRender
	end)
	local function getFormattedOwnersList(elementID)
		local ownersList = store:getOwnersListForElement(elementID)
		return printOwnersList(ownersList)
	end
>>>>>>> upstream-apply
	it("should drill through intermediate components", function()
		local Wrapper, Intermediate, Leaf
		local function Root()
			return React.createElement(
				Intermediate,
				nil,
				React.createElement("Frame", nil, React.createElement(Leaf, nil))
			)
		end
		function Wrapper(ref)
			local children = ref.children
			return children
		end
<<<<<<< HEAD
		function Leaf()
=======
		local function Leaf()
			return React.createElement("div", nil, "Leaf")
		end
		local function Intermediate(ref0)
			local children = ref0.children
			return React.createElement(Wrapper, nil, children)
		end
		act(function()
			return legacyRender(React.createElement(Root, nil), document:createElement("div"))
		end)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
          ▾ <Intermediate>
            ▾ <Wrapper>
                <Leaf>
    ]])
		local rootID = store:getElementIDAtIndex(0)
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
          ▾ <Intermediate>
              <Leaf>"
    ]])
		local intermediateID = store:getElementIDAtIndex(1)
		expect(getFormattedOwnersList(intermediateID)).toMatchInlineSnapshot([[

      "  ▾ <Intermediate>
          ▾ <Wrapper>"
    ]])
	end)
	it("should drill through interleaved intermediate components", function()
		local function Root()
			return {
				React.createElement(Intermediate, { key = "intermediate" }, React.createElement(Leaf, nil)),
				React.createElement(Leaf, { key = "leaf" }),
			}
		end
		local function Wrapper(ref0)
			local children = ref0.children
			return children
		end
		local function Leaf()
			return React.createElement("div", nil, "Leaf")
		end
		local function Intermediate(ref0)
			local children = ref0.children
			return {
				React.createElement(Leaf, { key = "leaf" }),
				React.createElement(Wrapper, { key = "wrapper" }, children),
			}
		end
		act(function()
			return legacyRender(React.createElement(Root, nil), document:createElement("div"))
		end)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
          ▾ <Intermediate key="intermediate">
              <Leaf key="leaf">
            ▾ <Wrapper key="wrapper">
                <Leaf>
            <Leaf key="leaf">
    ]])
		local rootID = store:getElementIDAtIndex(0)
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
          ▾ <Intermediate key="intermediate">
              <Leaf>
            <Leaf key="leaf">"
    ]])
		local intermediateID = store:getElementIDAtIndex(1)
		expect(getFormattedOwnersList(intermediateID)).toMatchInlineSnapshot([[

      "  ▾ <Intermediate key="intermediate">
            <Leaf key="leaf">
          ▾ <Wrapper key="wrapper">"
    ]])
	end)
	it("should show the proper owners list order and contents after insertions and deletions", function()
		local function Root(ref0)
			local includeDirect, includeIndirect = ref0.includeDirect, ref0.includeIndirect
>>>>>>> upstream-apply
			return React.createElement(
				"Frame",
				nil,
				React.createElement("TextLabel", { Name = "Leaf" })
			)
		end
		function Intermediate(ref)
			local children = ref.children
			return React.createElement(Wrapper, nil, children)
		end

		-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
		act(function()
<<<<<<< HEAD
			local root = ReactRoblox.createRoot(Instance.new("Frame"))
			return root:render(React.createElement(Root, nil))
		end)
		-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
		jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot("1: mount")

		local rootID = store:getElementIDAtIndex(0)
		jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
			"2: components owned by <Root>"
		)

		local intermediateID = store:getElementIDAtIndex(1)
		jestExpect(printOwnersList(store:getOwnersListForElement(intermediateID))).toMatchSnapshot(
			"3: components owned by <Intermediate>"
		)
=======
			return legacyRender(React.createElement(Root, { includeDirect = false, includeIndirect = true }), container)
		end)
		local rootID = store:getElementIDAtIndex(0)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
          ▾ <Intermediate>
            ▾ <Wrapper>
                <Leaf>
    ]])
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
          ▾ <Intermediate>
              <Leaf>"
    ]])
		act(function()
			return legacyRender(React.createElement(Root, { includeDirect = true, includeIndirect = true }), container)
		end)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
            <Leaf>
          ▾ <Intermediate>
            ▾ <Wrapper>
                <Leaf>
    ]])
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
            <Leaf>
          ▾ <Intermediate>
              <Leaf>"
    ]])
		act(function()
			return legacyRender(React.createElement(Root, { includeDirect = true, includeIndirect = false }), container)
		end)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
            <Leaf>
    ]])
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
            <Leaf>"
    ]])
		act(function()
			return legacyRender(
				React.createElement(Root, { includeDirect = false, includeIndirect = false }),
				container
			)
		end)
		expect(store).toMatchInlineSnapshot([[

      [root]
          <Root>
    ]])
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot('"    <Root>"')
>>>>>>> upstream-apply
	end)

	it("should drill through interleaved intermediate components", function()
		-- ROBLOX FIXME Luau: needs deferred constraint resolution to eliminate any cast
		local Wrapper, Intermediate: any, Leaf
		-- ROBLOX FIXME Luau: this cast couldn't be needed: Type '() -> {ReactElement<any, a>}' could not be converted into '((React_ElementProps<any>?, any) -> (Array<(Array<<CYCLE>> | React_Element<any> | boolean | number | string | t1)?> | React_Element<any> | boolean | number | string | t1)?) | LazyComponent<a, React_ElementProps<any>?> | ReactContext<any> | ReactProviderType<any> | React_ComponentType<React_ElementProps<any>?> | string where t1 = {| [string]: (boolean | number | string | t1 | {(<CYCLE> | boolean | number | string | t1 | {| key: (number | string)?, props: {| __source: {| fileName: string, lineNumber: number |}?, children: any?, key: (number | string)?, ref: (((any?) -> ()) | {| current: any? |})? |}?, ref: any, type: any |})?}... <TRUNCATED>'; none of the union options are compatible
		local function Root(): any
			return {
				React.createElement(
					Intermediate,
					{ key = "intermediate" },
					React.createElement(Leaf)
				),
				React.createElement(Leaf, { key = "leaf" }),
			}
		end
		function Wrapper(ref)
			local children = ref.children
			return children
		end
		function Leaf()
			return React.createElement(
				"Frame",
				nil,
				React.createElement("TextLabel", { Name = "Leaf" })
			)
		end
		function Intermediate(ref)
			local children = ref.children
			return {
				React.createElement(Leaf, { key = "leaf" }),
				-- ROBLOX FIXME Luau: without this any cast,  Type '{ key: string }' could not be converted into '{ key: string }?'
				React.createElement(Wrapper, { key = "wrapper" } :: any, children),
			}
		end

		-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
		act(function()
			local root = ReactRoblox.createRoot(Instance.new("Frame"))
			return root:render(React.createElement(Root))
		end)
		-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
		jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot("1: mount")

		local rootID = store:getElementIDAtIndex(0)
		jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
			"2: components owned by <Root>"
		)
		local intermediateID = store:getElementIDAtIndex(1)
		jestExpect(printOwnersList(store:getOwnersListForElement(intermediateID))).toMatchSnapshot(
			"3: components owned by <Intermediate>"
		)
	end)

	-- ROBLOX Test Noise: This test alone prints numerous 'No element
	-- found with id' errors that upstream does not
	it(
		"should show the proper owners list order and contents after insertions and deletions",
		function()
			local Wrapper, Leaf, Intermediate
			local function Root(ref)
				local includeDirect, includeIndirect =
					ref.includeDirect, ref.includeIndirect
				return React.createElement(
					"Frame",
					nil,
					if Boolean.toJSBoolean(includeDirect)
						then React.createElement(Leaf, nil)
						else nil,
					if Boolean.toJSBoolean(includeIndirect)
						then React.createElement(
							Intermediate,
							nil,
							React.createElement(Leaf, nil)
						)
						else nil
				)
			end
			function Wrapper(ref)
				local children = ref.children
				return children
			end
			function Leaf()
				return React.createElement(
					"Frame",
					nil,
					React.createElement("TextLabel", { Name = "Leaf" })
				)
			end
			function Intermediate(ref)
				local children = ref.children
				return React.createElement(Wrapper, nil, children)
			end

			local container = Instance.new("Frame")
			-- ROBLOX deviation: Create a root for rendering instead of using ReactDOM
			local root = ReactRoblox.createRoot(container)

			-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
			act(function()
				return root:render(
					React.createElement(
						Root,
						{ includeDirect = false, includeIndirect = true }
					)
				)
			end)
			-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
			jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot("1: mount")
			local rootID = store:getElementIDAtIndex(0)
			jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
				"2: components owned by <Root>"
			)

			-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
			act(function()
				return root:render(
					React.createElement(
						Root,
						{ includeDirect = true, includeIndirect = true }
					)
				)
			end)
			-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
			jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot(
				"3: update to add direct"
			)
			jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
				"4: components owned by <Root>"
			)

			-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
			act(function()
				return root:render(
					React.createElement(
						Root,
						{ includeDirect = true, includeIndirect = false }
					)
				)
			end)
			-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
			jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot(
				"5: update to remove indirect"
			)
			jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
				"6: components owned by <Root>"
			)

			-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
			act(function()
				return root:render(
					React.createElement(
						Root,
						{ includeDirect = false, includeIndirect = false }
					)
				)
			end)
			-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
			jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot(
				"7: update to remove both"
			)
			jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
				"8: components owned by <Root>"
			)
		end
	)

	it("should show the proper owners list ordering after reordered children", function()
		local Leaf
		-- ROBLOX FIXME Luau: shouldn't need this any cast
		local function Root(ref): any
			local ascending = ref.ascending
			return if Boolean.toJSBoolean(ascending)
				then {
					React.createElement(Leaf, { key = "A" }),
					React.createElement(Leaf, { key = "B" }),
					React.createElement(Leaf, { key = "C" }),
				}
				else {
					React.createElement(Leaf, { key = "C" }),
					React.createElement(Leaf, { key = "B" }),
					React.createElement(Leaf, { key = "A" }),
				}
		end
		function Leaf()
			return React.createElement(
				"Frame",
				nil,
				React.createElement("TextLabel", { Name = "Leaf" })
			)
		end

		local container = Instance.new("Frame")
		-- ROBLOX deviation: Create a root for rendering instead of using ReactDOM
		local root = ReactRoblox.createRoot(container)

		-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
		act(function()
<<<<<<< HEAD
			return root:render(React.createElement(Root, { ascending = true }))
		end)
		-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
		jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot(
			"1: mount (ascending)"
		)
		local rootID = store:getElementIDAtIndex(0)
		jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
			"2: components owned by <Root>"
		)

		-- ROBLOX deviation: use root:render to render instead of ReactDOM.render
		act(function()
			return root:render(React.createElement(Root, { ascending = false }))
		end)
		-- ROBLOX deviation: we use devtoolsUtils.printStore, upstream uses a jest serializer (storeSerializer) instead
		jestExpect(devtoolsUtils.printStore(store)).toMatchSnapshot(
			"3: update (descending)"
		)
		jestExpect(printOwnersList(store:getOwnersListForElement(rootID))).toMatchSnapshot(
			"4: components owned by <Root>"
		)
=======
			return legacyRender(React.createElement(Root, { ascending = true }), container)
		end)
		local rootID = store:getElementIDAtIndex(0)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
            <Leaf key="A">
            <Leaf key="B">
            <Leaf key="C">
    ]])
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
            <Leaf key="A">
            <Leaf key="B">
            <Leaf key="C">"
    ]])
		act(function()
			return legacyRender(React.createElement(Root, { ascending = false }), container)
		end)
		expect(store).toMatchInlineSnapshot([[

      [root]
        ▾ <Root>
            <Leaf key="C">
            <Leaf key="B">
            <Leaf key="A">
    ]])
		expect(getFormattedOwnersList(rootID)).toMatchInlineSnapshot([[

      "  ▾ <Root>
            <Leaf key="C">
            <Leaf key="B">
            <Leaf key="A">"
    ]])
>>>>>>> upstream-apply
	end)
end)
