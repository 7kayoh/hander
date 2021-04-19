local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvent = ReplicatedStorage:WaitForChild("Hander_Event")
local remoteFunction = ReplicatedStorage:WaitForChild("Hander_Function")
local common = ReplicatedStorage:WaitForChild("Common")
local promise = require(common:WaitForChild("Promise"))
local roact = require(common:WaitForChild("roact"))
local fzy = require(common:WaitForChild("fzy"))
local lang = require(common:WaitForChild("Lang"))
local spr = require(common:WaitForChild("spr"))
local logger = require(common:WaitForChild("Logger")).new(script.Name)
local bindable = Instance.new("BindableFunction")
local make = roact.createElement

-- TODO: Make it actually works and beautiful
local function makeItem(properties)
	return make("TextButton", {
		Name = properties.username,
		Text = properties.username,
		LayoutOrder = properties.order or 2,
		Size = UDim2.new(1, 0, 0, 30),
		
		[roact.Event.MouseButton1Click] = function()
			properties.oninvoke:Invoke(properties.username)
		end
	})
end

local UI = make("ScreenGui", {
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, {
	make("Frame", {
		Name = "UI",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 350, 0, 160),
		Position = UDim2.new(0.5, 0, 0.5, -110),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		make("UIListLayout", {
			Padding = UDim.new(0, 10)
		}),
		make("TextBox", {
			Name = "Input",
			Size = UDim2.new(1, 0, 0, 40),
			PlaceholderText = "search for players..."
		}),
		make(makeItem, {
			username = "nana_kon",
			oninvoke = bindable
		}),
		make(makeItem, {
			username = "notch",
			oninvoke = bindable
		}),
		make(makeItem, {
			username = "roblox",
			oninvoke = bindable
		})
	})
})

local handle = roact.mount(UI, script.Parent, "Handto utility")
bindable.OnInvoke = function(name)
	remoteFunction:InvokeServer("send", {target = name, toolName = tostring(Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"))})
	roact.unmount(handle)
end
