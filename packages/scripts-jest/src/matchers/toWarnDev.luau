local createConsoleMatcher = require(script.Parent.createConsoleMatcher)

return {
    -- Lua TODO: upstream this so console output is checked consistently across tests
    toLogDev = createConsoleMatcher("log", "toLogDev"),
    toWarnDev = createConsoleMatcher("warn", "toWarnDev"),
    toErrorDev = createConsoleMatcher("error", "toErrorDev")
}  