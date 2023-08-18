-- Lua upstream https://github.com/facebook/react/blob/6d50a9d090a2a672fc3dea5ce77a3a05332a6caa/scripts/jest/shouldIgnoreConsoleError.js
--!strict
local function shouldIgnoreConsoleError(format, args)
	-- La deviation: instead of checking if `process.env.NODE_ENV ~= "production"`
	-- we use the __DEV__ global
	if _G.__DEV__ then
		if typeof(format) == "string" then
			if string.find(format, "Error: Uncaught %[") == 1 then
				-- This looks like an uncaught error from invokeGuardedCallback() wrapper
				-- in development that is reported by jsdom. Ignore because it's noisy.
				return true
			end
			if string.find(format, "The above error occurred") == 1 then
				-- This looks like an error addendum from ReactFiberErrorLogger.
				-- Ignore it too.
				return true
			end
			if string.find(format, "'ReactDOM.render is no longer supported in React 18'") ~= nil 
                or string.find(format, "'ReactDOM.hydrate is no longer supported in React 18'") ~= nil then 
				-- We haven't finished migrating our tests to use createRoot.
				return true
			end
		end
	else
		if
			format ~= nil
			and type(format.message) == "string"
			and type(format.stack) == "string"
			and #args == 0
		then
			-- In production, ReactFiberErrorLogger logs error objects directly.
			-- They are noisy too so we'll try to ignore them.
			return true
		end
	end
    -- Looks legit
	return false
end

return shouldIgnoreConsoleError

