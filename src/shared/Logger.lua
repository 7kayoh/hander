-- Simple logging library that allows using four log levels (print, info, warn, error)

local Logger = {}
Logger.__index = Logger
Logger.Prefix = "[Logger] "
local RunService = game:GetService("RunService")

function Logger:Print(message)
	if self.DebugOnly and not RunService:IsStudio() then return end
	print("TestService: " .. self.Prefix .. tostring(message))
end

function Logger:Warn(message)
	if self.DebugOnly and not RunService:IsStudio() then return end
	warn("TestService: " .. self.Prefix .. tostring(message))
end

function Logger:Error(message)
	if self.DebugOnly and not RunService:IsStudio() then return end
	error("TestService: " .. self.Prefix .. tostring(message))
end

function Logger:Info(message)
	if self.DebugOnly and not RunService:IsStudio() then return end
	game:GetService("TestService"):Message(self.Prefix .. tostring(message))
end

function Logger.new(prefix)
	local loggerInstance = {
		Prefix = "[" .. tostring(prefix) .. "] ",
		DebugOnly = false
	}
	return setmetatable(loggerInstance, Logger)
end

return Logger