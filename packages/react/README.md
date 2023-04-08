# `react`

React is a library for creating user interfaces.

The `react` package contains only the functionality necessary to define React components. It is typically used together with a React renderer like `react-roblox`.

## Usage

```lua
local React = require(Path.To.React)
local ReactRoblox = require(Path.To.ReactRoblox)

local e = React.createElement
local useState = React.useState

local function Counter()
    local count, setCount = useState(0)

    return e("Frame", {}, {
        CurrentCount = e("TextLabel", {
            Text = count,
            ...
        }),
        IncrementButton = e("TextButton", {
            Text = "Increment",
            ...,

            [React.Event.Activated] = function()
                setCount(count + 1)
            end
        })
    })
end

local root = ReactRoblox.createRoot(Instance.new("Folder"))
root:render(ReactRoblox.createPortal(e(Counter), playerGui))
```

## Documentation

See https://react.dev/

## API

See https://react.dev/reference/react
