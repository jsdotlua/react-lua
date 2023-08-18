
# Upgrading from the bespoke Roact library

The vast majority of old Roact application code can be integrated to use React 17 using the RoactCompat library. While this will help you get up and running with React 17 quickly, RoactCompat is *only* backwards-compatible with with with Legacy Roact, and it does *not* expose modern React features such as Error Boundaries and Hooks.

When writing code targeted specifically for React-Lua, you must*not* use RoactCompat and instead use the `React` package directly and the platform-specific renderer package (eg `ReactRoblox` for Roblox apps). Do *not* mix and match, as their data structures are entirely incompatible. Generally, try to avoid even referencing different React implementations in the same project.

The `React`package in React-Lua exposes the same fundamental APIs as the deprecated Roact package:
* Some common legacy Roact APIs that are different from React-Lua and require changes in your source code
    * `oneChild(...)` becomes `Children.only(...)`
    * `createFragment` becomes `createElement(React.Fragment, ...)`

* Some are deviant from ReactJS because of Lua language differences, so React-Lua aligns with Roact
    * `Component:extend()` instead of `class MyComponent extends Component`

* Some that are the same in legacy Roact and React-Lua
    * `createContext` 
    * `createElement`

* `React.render` in upstream uses `react-dom`, and in Lua we need to explicitly use the renderer you want
    * React-Lua includes a `ReactTestRenderer` package that's aligned with the same packages in upstream ReactJS
    * React-Lua includes a `RobloxRenderer` package for rendering React components to Roblox's proprietary UI Subsystem
    * All renderers packages expose these APIs
        * `createRoot` API, which is aligned with upstream React 18, and replaced the Roact `update` and `mount` APIs
        * `createPortal` API, which is the same as usptream ReactJS, should be used instead of the Roact `Portal` 
