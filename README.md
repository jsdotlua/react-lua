<img src="https://raw.githubusercontent.com/jsdotlua/branding/main/Logo.png" align="right" height="128"/>

<h1>React Lua</h1>
<h3>A (mostly) runtime agnostic library for building user interfaces.</h3>

<a href="https://github.com/jsdotlua/react-lua/blob/main/LICENSE.md"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="license" height="18"></a>

---

`react-lua` is a 1:1 translation of upstream [React](https://github.com/facebook/react) from JavaScript into Lua, and is highly-turned for both performance and correctness.
When possible, upstream flowtype and definitely-typed types have been translated into Luau type annotations. The major and minor version of React Lua is aligned to the upstream used for the translation, except where noted. Due to the close nature of the two implementations, most article, video, or blog post that gives React JS advice can be applied to `react-lua` -- modulo language differences, of course. 

Some experimental React JS 17 features, that are removed in React JS 18 and are not implemented in `react-lua`:
* Blocks
* SuspenseList
* FundamentalComponent
* `createEventHandle` API

Some React JS 17 features not yet translated in `react-lua`:
* Server Components
* (De)Hydration
* Persistence
* The `supportsMutation = false` option in the ReactHostConfig
* ScopeComponent
* some specific `Text` behavior not needed by the currently ported renderers

If you'd like to help port some of the missing features, search for `unimplemented` in the code.

While `react-lua` is written in the Luau dialect, bundler tools such as [DarkLua](https://darklua.com/) can be used to transpile the implementation code to Lua code that is compatible with other Lua-based runtimes. Note that other Lua runtimes may need a new renderer implementation to be created, a [reference](packages/react-roblox) renderer based on the [React Native](https://github.com/facebook/react/tree/main/packages/react-native-renderer) renderer is included in this repository.

TODO: Write the rest of the README.
