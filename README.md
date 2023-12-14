<img src="https://raw.githubusercontent.com/jsdotlua/branding/main/Logo.png" align="right" height="128"/>

# React Lua

<h3>A comprehensive, but not exhaustive, translation of upstream ReactJS 17.x into Lua.</h3>

[![Coverage Status](https://coveralls.io/repos/github/Roblox/roact-alignment/badge.svg?branch=master&t=TvTSze)](https://coveralls.io/github/Roblox/roact-alignment?branch=master)
[![Docs](https://img.shields.io/badge/docs-website-green.svg)](https://jsdotlua.github.io/react-lua/)

---

## TL;DR

React Lua is a comprehensive translation of upstream [ReactJS](https://github.com/facebook/react) from JavaScript into Lua, and is highly-turned for both performance and correctness.

When possible, upstream flowtype and definitely-typed types have been translated into Luau type annotations. The major and minor version of React Lua is aligned to the upstream used for the translation, except where noted. Due to the close nature of the two implementations, most article, video, or blog posts that gives React JS advice can be applied to React Lua -- modulo language differences, of course.

## About this Fork

This repository is a fork of [`roblox/react-lua`](https://github.com/roblox/react-lua) with the intention of being the Roblox and global Lua community go-to for React in Lua. Roblox's repository is a read-only mirror of their internal project, and as such cannot be contributed to by the community. They have not published React to any public package registry and have not made alterations for easier use by the community.

### Original Project Authors

Roblox has removed commit author history in their public mirror, which means the original project authors cannot be properly credited. Below is a list of people who originally worked on React Lua, extracted from the `rotriever.toml` file in Roblox's repository.

Please note that many of these emails may be inactive, as much of the original team working on React Lua are no longer at Roblox.

```
"Paul Doyle <pdoyle@roblox.com>",
"Matt Hargett <mhargett@roblox.com>",
"Max Mines <mmines@roblox.com>",
"Carlo Conte <cconte@roblox.com>",
"Henry Allen <hallen@roblox.com>",
"Olivier Trepanier <otrepanier@roblox.com>",
"Hugh Collins <hcollins@roblox.com>"
```

## Status

The [react repo](https://github.com/facebook/react) is a monorepo with a number of member projects in its `packages` folder, managed by a Yarn workspace. Below is a description of each of those package, its status in React Lua, and how it likely fits into our future plans.

📌 _Considered part of react's core functionality or testing capabilities; some or all of this package is necessary to build and validate an MVP._

| Project                              | Description                                                        | Status       | Plan                                        | Notes                                                                                                                                                     |
| ------------------------------------ | ------------------------------------------------------------------ | ------------ | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `create-subscription`                | Used for subscribing to external data                              | ❌ Not ported | ❔ Not yet assessed                          |                                                                                                                                                           |
| `dom-event-testing-library`          | Dom event simulation for tests                                     | ❌ Not ported | ❔ Not yet assessed                          |                                                                                                                           |
| `eslint-plugin-react-hooks`          | Linting plugin for hooks rules                                     | ❌ Not ported | ❔ Not yet assessed                          | Depends on future linting tools                                                                                                                           |
| `jest-mock-scheduler`                | Reexports scheduler testing utilities                              | ❌ Not ported | ❔ Not yet assessed                          |                                                                                                                                                           |
| 📌`jest-react`                        | Jest matchers and utilities                                        | ✔️ Ported     |                                             | Used for testing React component implementations.                                                            |
| 📌`react`                             | Base react interface                                               | ✔️ Ported     |                                             | Defines basic shape of internals like Components and Elements. We added added Roblox-specifics like Bindings, but otherwise comply with upstream ReactJS. |
| `react-art`                          | For drawing vector graphics                                        | ❌ Not ported | ➖ Unlikely to be ported                     |                                                                                                                                                           |
| `react-cache`                        | Basic cache for use with experimental React features               | ✔️ Ported     | ❔                                           | API is flagged as unstable, is stable in React 18, used in advanced Suspense cases                                                                        |
| `react-client`                       | Experimental package for consuming React streaming models          | ❌ Not ported | ❔ Not yet assessed                          | API considered unstable. Might be worth investigating if it stabilizes                                                                                    |
| `react-debug-tools`                  | Experimental debugger package                                      | ✔️ Ported     |                                             | Used by DevTools and (_the Roblox internal_) Roblox Studio Inspector                                                                                                              |
| `react-devtools`                     | Top-level app for react devtools                                   | ❌ Not ported | ➕ Likely to be ported                       | Devtools needs to be addressed as a whole to see where/how it translates                                                                                  |
| `react-devtools-core`                | Standalone devtools impl                                           | ❌ Not ported | ➕ Likely to be ported                       | Devtools needs to be addressed as a whole to see where/how it translates                                                                                  |
| `react-devtools-extensions`          | Devtools browser extension                                         | ❌ Not ported | ➖ Unlikely to be ported                     |                                                                                                                                                           |
| `react-devtools-inline`              | Impl for embedding in browser-based IDEs                           | ❌ Not ported | ➕ Likely to be ported                       | Devtools needs to be addressed as a whole to see where/how it translates                                                                                  |
| `react-devtools-scheduling-profiler` | Experimental concurrent mode profiler                              | ❌ Not ported | ❔ Not yet assessed                          |                                                                                                                                                           |
| `react-devtools-shared`              | Private shared utilities for devtools                              | ✔️ Ported     |                                             | Used by Roblox Studio Inspector                                                                                                                           |
| `react-devtools-shell`               | Harness for testing other devtools packages                        | ❌ Not ported | ❔ Not yet assessed                          | Devtools needs to be addressed as a whole to see where/how it translates                                                                                  |
| `react-dom`                          | Entrypoint for DOM and server renderers                            | ❌ Not ported | ➖ Unlikely to be ported                     | Heavily inspired the top-level interface of the React-Roblox Renderer                                                                                     |
| `react-fetch`                        | For use with experimental React features                           | ❌ Not ported | ❔ Not yet assessed                          | API considered unstable                                                                                                                                   |
| `react-interactions`                 | For use with experimental React features                           | ❌ Not ported | ❔ Not yet assessed                          |                                                                                                                                                           |
| 📌`react-is`                          | Runtime type checks for React elements                             | ✔️ Ported     |                                             |                                                                                                                                                           |
| `react-native-renderer`              | Renderer interface for react-native                                | ❌ Not ported | ❔ Not yet assessed                          | This package has no readme, so it's hard to understand its scope                                                                                          |
| 📌`react-noop-renderer`               | Renderer used for debugging Fiber                                  | ✔️ Ported     |                                             | Used heavily for internal framework testing                                                                                                               |
| 📌`react-reconciler`                  | Reconciler implementation used with various renderers              | ✔️ Ported     |                                             | Bulk of React's complicated logic lives here                                                                                                              |
| `react-refresh`                      | Wiring for Fast Refresh                                            | ❌ Not ported | ❔ Not yet assessed, depend on applicability | Officially supported successor to "hot reloading"                                                                                                         |
| `react-server`                       | Experimental package for creating React streaming server renderers | ❌ Not ported | ❔ Not yet assessed                          |                                                                                                                                                           |
| `react-test-renderer`                | Test renderer helpful utilities and snapshot support               | ✔️ Ported     |                                             | Used for testing much of React's internals, can be used by external developers                                                                              |
| `react-transport-dom-delay`          | Internal package, likely for testing                               | ❌ Not ported | ➖ Unlikely to be ported                     | No readme in package                                                                                                                                      |
| `react-transport-dom-webpack`        | Related to above                                                   | ❌ Not ported | ➖ Unlikely to be ported                     | Appears to be webpack-specific                                                                                                                            |
| 📌`scheduler`                         | Cooperative scheduling implementation                              | ✔️ Ported     |                                             | Includes Tracing and Profiling features, which are enabled through ReactFeatureFlags                                                                      |
| 📌`shared`                            | Loose collection of shared utilities and definitions               | ✔️ Ported     |                                             | We pushed many things into this leaf node module to fix circular dependencies. Working with upstream to clean this up.                                    |
| `use-subscription`                   | Hook for managing subscriptions in concurrent mode                 | ❌ Not ported | ❔ Not yet assessed                          | Not sure if/how this will apply to Roblox and Lua                                                                                                              |

Projects not in the upstream React repo:
| Project                   | Description                                                                                                                                                                               | Notes                                                                                                                                                                                                     |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 📌`react-shallow-renderer` | Shallow renderer used in tests for some older React features. Re-exported alongside `react-test-renderer`, source of truth [here](https://github.com/NMinhNguyen/react-shallow-renderer). | ✔️ Ported - with tests that are helping us exercise functionality in the `react` package                                                                                                                   |
| `react-roblox`            | Based on react-dom renderer, shares much of its code and public interface.                                                                                                                | Also exports [`act()`](https://github.com/threepointone/react-act-examples/blob/master/sync.md) functionality, which is _required_ for testing components that are asynchronously rendered (the default). |
| `roact-compat`            | A comaptibility layer that emulates some deprecated behaviors of legacy Roact                                                                                                             | Meant to ease initial adoption of Roact 17, using React APIs directly is encouraged and necessary for newer functonality (eg Hooks)                                                                       |

## Deviations from [Roact](https://github.com/roblox/roact)

This repo is meant to supplant the `Roact` project, which is an open-source project that currently powers many Roblox projects. Our goal is to be as compatible as possible with Roact.

With that in mind, however, there will still be a small number of behavioral deviations that make the transition from existing Roact smoother, or account for nuances of the Roblox ecosystem:

* Stable Keys: Aligned Roact will allow table keys to be used as stable keys for child elements, equivalent to the behavior relied upon in Roact today
* Context: Roact's deprecated `_context` feature will not be present in React Lua; users will have to switch to the `createContext` feature, which is present in both Roact and React Lua and is semantically equivalent
* Class Component Refs: React Lua will allow refs provided to class components (referred to in Roact documentation as "stateful components") to point to the actual component instance. This is not supported in Roact, and there may be changes around the `Roact.Ref` prop key to support this with minimal disruption
* Bindings: We intend to keep `createBindings` and `joinBindings`, a feature unique to Roact and [documented here](https://roblox.github.io/roact/api-reference#roactcreatebinding)

See [this document](DEVIATIONS.md) for details about any deviations and the design and refactoring efforts being proposed to address them.

## Contribution Guidelines

* Try to keep the directory structure, file name/location, and code symbol names aligned with React upstream. At the top of the mirrored files, put a comment in this format that includes the specific hash of the version of the file you're mirroring:

```lua
-- ROBLOX upstream https://github.com/facebook/react/blob/9abc2785cb070148d64fae81e523246b90b92016/packages/scheduler/src/Scheduler.js
```

* If you have a deviation from upstream code logic for Lua-specific reasons (1-based array indices, etc) put a comment above the deviated line:

```lua
-- ROBLOX deviation: use explicit nil check instead of falsey
```

* For deviations due to Lua language differences (no spread operator) that don't involve changing the logic, don't put a deviation comment. Just use the appropriate equivalent from LuauPolyfill and other utility libraries.

* For files that are new and Roblox-specific, use the file name: `Timeout.roblox.lua`

* and for Roblox-specific tests, use the file name format: `Timeout.roblox.spec.lua`
