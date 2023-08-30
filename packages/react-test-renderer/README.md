Example
```lua
local Packages = "" --[[ fill in for your project setup ]]
local ReactFeatureFlags = require(Packages.Shared).ReactFeatureFlags
ReactFeatureFlags.replayFailedUnitOfWorkWithInvokeGuardedCallback = false

local React = require(Packages.React)
ReactTestRenderer = require(Packages.ReactTestRenderer)

local context = React.createContext("Megaphone")
local Consumer, Provider = context.Consumer, context.Provider

local function Child(props)
    return props.value
end

local function Game()
    return React.createElement(
        Provider,
        { value = "b0mb" },
        React.createElement(Consumer, nil, function(value)
            return React.createElement(Child, { value = value })
        end)
    )
end

local renderer = ReactTestRenderer.create(React.createElement(Game))
local child = renderer.root:findByType(Child)

assert(child.children[1] == "b0mb", "context default value not set correctly")

renderer.update(React.createElement("text", nil, "Gaiares"))
assert(renderer.toJSON().children[1] == "Gaiares", "render update not complete")
```
