module.exports = {
    lastSync: {
        ref: "12adaffef7105e2714f82651ea51936c563fe15c",
        conversionToolVersion: "ffc56d3952bd9ce9ccecc900f6632b0a1c08f222"
    },
    upstream: {
        owner: "facebook",
        repo: "react",
        primaryBranch: "main"
    },
    downstream: {
        owner: "jsdotlua",
        repo: "react-lua",
        primaryBranch: "main",
        patterns: [
            "**/*.luau"
        ],
        ignorePatterns: [
            "Packages/**/*"
        ]
    },
    renameFiles: [
        [
            (filename) => filename.includes("packages/"),
            (filename) => filename.replace("packages/", "modules/")

        ],
        [
            (filename) => filename.includes("modules/shared") && !filename.includes("modules/shared/src"),
            (filename) => filename.replace("modules/shared", "modules/shared/src")

        ],
        [
            (filename) => filename.includes("modules/react/src/ReactSharedInternals.luau"),
            (filename) => filename.replace("modules/react/src/ReactSharedInternals.luau", "modules/shared/src/ReactSharedInternals/init.luau")
        ],
        [
            (filename) => filename.includes("modules/react/src/ReactCurrentDispatcher.luau") || filename.includes("modules/react/src/ReactCurrentBatchConfig.luau") || filename.includes("modules/react/src/ReactCurrentActQueue.luau") || filename.includes("modules/react/src/ReactCurrentOwner.luau") || filename.includes("modules/react/src/ReactDebugCurrentFrame.luau"),
            (filename) => filename.replace("modules/react/src/", "modules/shared/src/ReactSharedInternals/")
        ],
        [
            (filename) => filename.includes("modules/react-reconciler/src/ReactFiberHostConfigWithNoHydration.luau"),
            (filename) => filename.replace("modules/react-reconciler/src/ReactFiberHostConfigWithNoHydration.luau", "modules/shared/src/ReactFiberHostConfig/WithNoHydration.luau")
        ],
        [
            (filename) => filename.includes("modules/react-reconciler/src/ReactFiberHostConfigWithNoPersistence.luau"),
            (filename) => filename.replace("modules/react-reconciler/src/ReactFiberHostConfigWithNoPersistence.luau", "modules/shared/src/ReactFiberHostConfig/WithNoPersistence.luau")
        ],
        [
            (filename) => filename.includes("modules/react-reconciler/src/ReactFiberHostConfigWithNoTestSelectors.luau"),
            (filename) => filename.replace("modules/react-reconciler/src/ReactFiberHostConfigWithNoTestSelectors.luau", "modules/shared/src/ReactFiberHostConfig/WithNoTestSelectors.luau")
        ],
        [
            (filename) => filename.includes("__tests__/") && !filename.includes("src/__tests__/") && !filename.includes("PropMarkers/__tests__/") && !filename.includes("client/__tests__/"),
            (filename) => filename.replace("__tests__/", "src/__tests__/")
        ],
        [
            (filename) => filename.endsWith("-test.luau"),
            (filename) => filename.replace("-test.luau", ".spec.luau")

        ],
        [
            (filename) => filename.endsWith("-test.internal.luau"),
            (filename) => filename.replace("-test.internal.luau", "-internal.spec.luau")

        ],
        [
            (filename) => filename.includes("scripts/jest/matchers"),
            (filename) => filename.replace("scripts/jest/matchers", "WorkspaceStatic/jest/matchers")
        ],
        [
            (filename) => filename.endsWith("fixtures/legacy-jsx-runtimes/setupTests.luau"),
            (filename) => filename.replace("fixtures/legacy-jsx-runtimes/setupTests.luau", "WorkspaceStatic/jest/matchers/createConsoleMatcher.luau")
        ],
    ],
}
