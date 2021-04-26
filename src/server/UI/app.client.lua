local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Common = ReplicatedStorage:WaitForChild("Common")
local Modules = {}
local _UI
local Bindable = Instance.new("BindableFunction")

local function Invoke(Type)
	if _UI then
		if Type == "Toggle" then
			_UI.Properties.Toggled = not _UI.Properties.Toggled
			_UI:Deploy()
		end
	end
end

local function Init()
	local Container = Instance.new("ScreenGui")
	_UI = Modules.Cook.new(Container)
	Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Bindable.Parent = script
	Container.Parent = Players.LocalPlayer.PlayerGui
	
	Bindable.OnInvoke = Invoke
	
	_UI:Deploy()
end

for _, v in pairs(Common:GetChildren()) do
	if v:IsA("ModuleScript") then
		Modules[v.Name] = require(v)
	end
end

Init()