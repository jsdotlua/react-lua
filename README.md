<img src="https://raw.githubusercontent.com/jsdotlua/branding/main/Logo.png" align="right" height="128"/>

# React Lua
### A library for building user interfaces in Lua.

[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jsdotlua/react-lua/blob/main/LICENSE.md)

---

## About

`react-lua` is a 1:1 translation of [ReactJS](https://github.com/facebook/react) v17, and is highly tuned for performance and correctness. Almost every feature from the original React is available in this translation, including hooks and devtools*.

Everything from ReactJS v17 applies to React-lua. This includes the documentation, knowledge base, and the learning process. When using React-lua, your resource is ReactJS. If you encounter a problem, the solution is almost certainly on StackOverflow or a blog post.

\* The core devtools packages are provided, but a devtools frontend plugin for Roblox is yet to be developed.

## What about [Roact](https://github.com/Roblox/roact)?

Roact is Roblox's legacy UI library. It is an *approximate* recreation of ReactJS v16, but it lacks several features and suffers from critical performance degradation cases. With the advent of the universal app, Roblox outgrew Roact and what its implementation could provide. The app exposed several inherent issues with Roact, both in terms of performance and developer experience. As a result, the decision was made to recreate React *exactly* in Luau, deviating as little as possible from ReactJS.

Within the context of React-lua, Roact is now considered *legacy*. It is no longer in internal use at Roblox and has been entirely superseded by React-lua in all shipping code. Consequently, it's unlikely that the Roact repository will see future updates beyond low-cost chores.

It is highly recommended that users transition to React-lua if they are currently using Roact. Migration is relatively straightforward, and you will immediately benefit from an improved developer experience and performance improvements. Additionally, you will have the option to adopt features like hooks and error boundaries. More information on migration can be found in the React-lua documentation.

## What about *insert other UI library here*?

It's important to evaluate your requirements and what you seek in a UI library. Each library usually has its own unique selling points, so do your research and make an informed decision.

React-lua is proven to work at scale, as evidenced by its successful deployment by Roblox to hundreds of engineers and tens of millions of DAU in a 500k+ LOC codebase. It's the only UI library that can make this claim. Therefore, if long-term stability is a requirement for you, React-lua could be a viable choice.

Additionally, React-lua *is* ReactJS, which means you benefit from the entire surrounding ecosystem. When using React-lua, you can leverage the decade+ of knowledge and learning that ReactJS offers. You can also tap into React's broad talent pool if you plan on hiring frontend UI developers for your game or project (they'll have to learn Luau, though!).

However, the same disadvantages that apply to ReactJS apply here as well. There are undoubtedly other Roblox UI libraries that are easier to use in some areas than React-lua. React is a sizable dependency, and while it has numerous features, you might find it challenging to learn or integrate into a project. Please refer to the documentation and make an informed decision.

## Acknowledgements

React-lua was created internally by [Roblox](https://roblox.com) for their universal desktop and mobile app. Inside Roblox, the project is used daily by hundreds of engineers in a 500k+ LOC codebase. Roblox created every package in this repository under a permissive open-source license (MIT), but they haven't officially released the project on GitHub.

This repository serves as a mirror of Roblox's internal MIT packages, pulled directly from their client distribution. The packages here have been made usable for developers by restructuring and updating them to work without Roblox's internal tools and privileged script environment.

It's unclear if Roblox will ever officially release React-lua under their own name, but until then, this repository holds the latest version of React-lua available to the community and already powers several UI-heavy games on Roblox.

## Contribution

The React-lua repository aims to deviate as little as possible from Roblox's client distribution. As such, we probably won't accept significant source changes or feature additions. However, we are happy to accept bug fixes and documentation improvements.
