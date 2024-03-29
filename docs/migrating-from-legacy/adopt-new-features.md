# Adopt New Features

React Lua ships with a number of features new to Roact that have been ported from React JS, in addition to a couple of new capabilities unique to the React in Lua ecosystem.

## Asynchronous Rendering

React Lua introduces a paradigm shift to the underlying rendering behavior that allows it to divide work across multiple frames and preserve high framerate and interactivity.

This behavior is called [Concurrent Mode](https://17.reactjs.org/docs/concurrent-mode-intro.html#what-is-concurrent-mode) rendering.

**React Lua will use Concurrent Mode by default in its `mount` compatibility layer.**

!!! info
	React Lua is aligned to React JS 17.0.1, which means that it has not inherited any [changes to Concurrent Mode described in the React 18 documentation](https://reactjs.org/blog/2022/03/29/react-v18.html#gradually-adopting-concurrent-features). As we begin to build _React Lua_ 18, we may shift our distinctions similarly. For now, **opting into Concurrent Mode is the best way to get the latest optimizations and ensure that your components are robust.**

### `ReactRoblox.createRoot`

In legacy Roact, the [`Roact.mount`](https://roblox.github.io/roact/api-reference/#roactmount) function is used to render a component tree. In React JS 17 and older, the primary entry-point for rendering a component tree is [`ReactDOM.render`](https://reactjs.org/docs/react-dom.html#render), while the experimental `ReactDOM.createRoot` API is used to adopt Concurrent Mode.

React Lua skips introducing the top-level `render` function from earlier versions of React JS, and instead provides the following for mounting Roact UI elements:

* The `createRoot`, `createBlockingRoot`, and `createLegacyRoot` APIs from React JS 17
* A [compatibility layer](../api-reference/roact-compat.md#roactcompatmount) that exports a `mount` function aligned with legacy Roact's API

In new code, you should always use [`ReactRoblox.createRoot`](https://reactjs.org/docs/concurrent-mode-reference.html#createroot). The vast majority of existing Roact code should be compatible with `createRoot`, which enables Concurrent Mode and can greatly improve responsiveness for complex applications.

If you run into problems with Concurrent Mode that are difficult to address, you may be interested in considering [`ReactRoblox.createBlockingRoot` or `ReactRoblox.createLegacyRoot`](https://reactjs.org/docs/concurrent-mode-reference.html#createblockingroot) at a cost to overall app responsiveness.

### `ReactRoblox.act`

When Concurrent Mode is enabled, React will attempt to schedule work evenly across rendering frames to keep the application running smoothly, even when UI rendering work has been queued up.

However, this means that tests relying on synchronous rendering behavior will no longer function correctly. To fix this, use the [`ReactRoblox.act`](../api-reference/react-roblox.md#reactrobloxact) function to play scheduler logic forward (also re-exported as [`RoactCompat.act`](../api-reference/roact-compat.md#roactcompatact)).

#### How to Use `act`

The `ReactRoblox.act` utility works by:

1. Running the provided function
2. Performing queued work by playing forward React's internal scheduler
3. Repeating step 2 until the queue is empty

When running tests using the mock scheduler, the following scenarios will need to be wrapped in an `act` call:

* Rendering an initial tree with the `render` method of a React root or the `RoactCompat.mount` compatibility function (if the [`__ROACT_17_INLINE_ACT__`](../configuration.md#__roact_17_inline_act__) global is set to true, this will happen **automatically** for `mount`, `update`, and `unmount`)
* Rendering updates with the `render` method of a React root
* Unmounting a tree by passing `nil` to the `render` method of a React root
* Calling `task.wait` or other yielding functions to allow engine callbacks to fire
* Triggering behavior that causes a component to update its state, including firing signals that your component has subscribed to

!!! info
	In order to enable the `act` function, you'll need React to use the mocked version of its internal scheduler. To do this, set the [`__ROACT_17_MOCK_SCHEDULER__`](../configuration.md#__roact_17_mock_scheduler__) global to true in your testing configuration.

#### Example

Many integration tests involve validating various states of a component and interacting with the component via virtual input events or mocked signals.
The following is a comprehensive example of several of the above scenarios in practice.

Suppose we have a component called `TooltipButton`:

```lua
local function TooltipButton(props)
	local showTooltip, setShowTooltip = React.useState(false)

	return React.createElement("Frame", {
		key = "TooltipButton",
		Size = UDim2.fromScale(1, 1),
	}, {
		Button = React.createElement("TextButton", {
			Text = "Show tooltip",
			Active = props.enabled,
			[React.Event.Activated] = function()
				setShowTooltip(true)
				task.delay(props.tooltipFadeDelay, function()
					setShowTooltip(false)
				end)
			end,
		})
		Tooltip = if showTooltip
			then React.createElement("TextLabel", {
				Text = "Tooltip text!",
			})
			else nil
	})
end
```

We'd like to write a test to validate the tooltip behavior. Here's how we might use `act` to guarantee that all scheduled work is flushed and our test works as expected:

!!! info
	This example uses an internal Roblox library called Rhodium. It is used for mocking input events, and cannot be used by external developers. We've kept the example in the react-lua fork because it's still a useful example.

```lua
local React = require(Packages.React)
local ReactRoblox = require(Packages.ReactRoblox)

local container, root
beforeEach(function()
	container = Instance.new("ScreenGui")
	container.Parent = Players.LocalPlayer.PlayerGui

	root = ReactRoblox.createRoot(container)
end)

afterEach(function()
	container:Destroy()
end)

it("shows a tooltip on click and hides it after a delay", function()
	-- Use `act` for the initial render
	ReactRoblox.act(function()
		-- Render the button in a disabled state
		root:render(React.createElement(TooltipButton, {
			enabled = false,
			tooltipFadeDelay = 1,
		}))
	end)

	expect(container.TooltipButton.Tooltip).toBeNil()
	expect(container.TooltipButton.Button.Active).toBe(false)

	-- Use `act` to re-render the tree
	ReactRoblox.act(function()
		-- Rerender in the enabled state
		root:render(React.createElement(TooltipButton, {
			enabled = true,
			tooltipFadeDelay = 1,
		}))
	end)

	expect(container.TooltipButton.Tooltip).toBeNil()
	expect(container.TooltipButton.Button.Active).toBe(true)

	-- Use `act` to trigger virtual input
	local element = Rhodium.Element.new(container.TooltipButton.Button)
	ReactRoblox.act(function()
		-- Click the button to trigger the tooltip
		element:click()
		Rhodium.VirtualInput.waitForInputEventsProcessed()
	end)

	expect(container.TooltipButton.Tooltip).never.toBeNil()
	expect(container.TooltipButton.Tooltip.Text).toEqual("Tooltip text!")

	-- Use `act` to resume queued renders after a delayed callback fires
	ReactRoblox.act(function()
		task.wait(1)
	end)

	expect(container.TooltipButton.Tooltip).toBeNil()
end)
```

For more details and examples, refer to documentation on [the `act` function in React JS](https://reactjs.org/docs/test-utils.html#act).

!!! info
	In new test code, consider adopting libraries like [`dom-testing-library-lua`](https://github.com/Roblox/dom-testing-library-lua) and [`react-testing-library-lua`](https://github.com/Roblox/react-testing-library-lua), which are ports of JS testing libraries that handle much of the `act` logic for you.

## Hooks

While async rendering is a paradigm shift for under-the-hood rendering behavior, hooks are a paradigm shift for component development. They're designed to be a more performant, composable, testable, and ergonomic approach to defining stateful behavior and side effects (relative to to class component lifecycle methods).

You can access hooks via the `React` Package. In order to encourage migration to the new package conventions, `RoactCompat` **does not** export the hooks API. Follow the [previous section](upgrading-to-react-lua.md#accessing-new-features) to set up your dependencies appropriately.

An excellent and comprehensive guide for hooks can be found in the [React JS documentation](https://reactjs.org/docs/hooks-intro.html); the example below will help illustrate what they look like when used in Luau.

### Hooks Example

The following is a simple example that uses two of the most common hooks: `useState` and `useEffect`.

```lua
local React = require(Packages.React)

function ClickerComponent(props)
	local count, setCount = React.useState(0)
	local function onClick()
		setCount(function(oldCount)
			 return oldCount + 1
		end)
	end

	React.useEffect(function()
		print(string.format("You've clicked %d times!", count))
	end)

	return React.createElement("TextButton", {
		Text = tostring(count),
		[React.Event.Activated] = onClick,
	})
end
```

Check the [API Reference](../api-reference/react.md#reactusestate) to see the complete list of hooks supported by React Lua.

## Utilities

### React.memo

The `memo` function can be used to memoize a function component, returning the same element if the same props are provided. This may be a helpful optimization in scenarios where a function component frequently re-renders without changes due to its parent re-rendering.

Refer to the [React JS documentation](https://reactjs.org/docs/react-api.html#reactmemo) for more details and examples.

### React.Children

*Under construction 🔨*

## Lua-Only Features

In addition to the new features provided by aligning with React JS 17, a few new features have been added to extend and improve support for legacy Roact features.

### `useBinding` Hook

Legacy Roact introduces a concept called "bindings", a shorthand for the concept of "unidirectional data bindings." You can learn more about bindings in the [legacy Roact documentation](https://roblox.github.io/roact/advanced/bindings-and-refs/#bindings).

The legacy version of bindings were created similarly to refs, using a `createBinding` method that would be called in the `init` method of a class component. So how do we use bindings with function components?

React Lua introduces, alongside the core hooks from React JS 17, an additional `useBinding` hook to address this case. You can use it much like a `useState` hook, except it will follow binding semantics: instead of triggering component re-renders, binding updates will directly update subscribed values.

```lua
local React = require(Packages.React)

function ClickerComponent(props)
	local count, setCount = React.useBinding(0)
	local function onClick()
		-- This will only update subscribed host properties, specifically the
		-- Text field of the button that's rendered below
		setCount(count:getValue() + 1)
	end

	React.useEffect(function()
		print(string.format("You've clicked %d times!", count))
	end)

	return React.createElement("TextButton", {
		Text = count:map(tostring),
		[React.Event.Activated] = onClick,
	})
end
```

### `React.Tag`

*Under Construction 🔨*
