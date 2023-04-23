# `react-is`

This package allows you to test arbitrary values and see if they're a particular React element type.

## Usage

### Determining if a Component is Valid

```lua
local React = require(Path.To.React)
local ReactIs = require(Path.To.ReactIs)

local ClassComponent = React.Component:extend("ClassComponent")

function ClassComponent:render()
    return React.createElement("Frame")
end

local function FunctionComponent()
	return React.createElement("Frame")
end

local ForwardRefComponent = React.forwardRef(function(props, ref)
	return React.createElement(FunctionComponent, {
		forwardRef = ref,
	})
end)

local Context = React.createContext(false)

ReactIs.isValidElementType("Frame") -- true
ReactIs.isValidElementType(ClassComponent) -- true
ReactIs.isValidElementType(FunctionComponent) -- true
ReactIs.isValidElementType(ForwardRefComponent) -- true
ReactIs.isValidElementType(Context.Provider) -- true
ReactIs.isValidElementType(Context.Consumer) -- true
```

### Determining an Element's Type

#### Context

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactIs = require(ReplicatedStorage.Packages.ReactIs)

local ThemeContext = React.createContext("blue")

ReactIs.isContextConsumer(React.createElement(ThemeContext.Consumer)) -- true
ReactIs.isContextProvider(React.createElement(ThemeContext.Provider)) -- true
ReactIs.typeOf(React.createElement(ThemeContext.Provider)) == ReactIs.ContextProvider -- true
ReactIs.typeOf(React.createElement(ThemeContext.Consumer)) == ReactIs.ContextConsumer -- true
```

#### Element

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactIs = require(ReplicatedStorage.Packages.ReactIs)

ReactIs.isElement(React.createElement("Frame")) -- true
ReactIs.typeOf(React.createElement("Frame")) == ReactIs.Element -- true
```

#### Fragment

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactIs = require(ReplicatedStorage.Packages.ReactIs)

ReactIs.isFragment(React.createElement(React.Fragment)) -- true
ReactIs.typeOf(React.createElement(React.Fragment)) == ReactIs.Fragment -- true
```

#### Portal

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local ReactIs = require(ReplicatedStorage.Packages.ReactIs)

local container = Instance.new("Folder")
local portal = ReactRoblox.createPortal(React.createElement("Frame"), container)

ReactIs.isPortal(portal) -- true
ReactIs.typeOf(portal) == ReactIs.Portal -- true
```

#### StrictMode

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactIs = require(ReplicatedStorage.Packages.ReactIs)

ReactIs.isStrictMode(React.createElement(React.StrictMode)) -- true
ReactIs.typeOf(React.createElement(React.StrictMode)) == ReactIs.StrictMode -- true
```
