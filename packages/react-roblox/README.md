# `react-roblox`

This package serves as a Roblox renderer for React. It is intended to be paired with the generic React package, which is shipped as `jsdotlua/react` to Wally.

## Usage

```lua
local React = require(Path.To.React)
local ReactRoblox = require(Path.To.ReactRoblox)

local function App()
    return React.createElement("TextLabel", {
        Text = "Hello, world!"
    })
end

local element = React.createElement(App)

local root = ReactRoblox.createRoot(Instance.new("Folder"))
root:render(ReactRoblox.createPortal(element, playerGui))
```

## API

TODO
