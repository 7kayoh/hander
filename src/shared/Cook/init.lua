local Hander = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Common = ReplicatedStorage:WaitForChild("Common")
local Modules = {}

local function animateIn(self)
	if self._Active.Promise then
		self._Active.Promise:cancel()
		Modules.spr.stop(self._Object, "Position")
		Modules.spr.stop(self._Object.UIScale, "Scale")
	end
	
	self._Active.Promise = Modules.Promise.new(function(Resolve, Reject)
		self._FadeObject:FadeIn(0.15)
		self._Object.UIScale.Scale = 1.1
		self._Object.Position = UDim2.fromScale(0.5, 0.25)
		self._Object.Visible = true
		Modules.spr.target(self._Object, 0.6, 2.0, {
			Position = UDim2.fromScale(0.5, 0.3)
		})
		Modules.spr.target(self._Object.UIScale, 0.6, 2.0, {
			Scale = 1
		})
	end)
end

local function animateOut(self)
	if self._Active.Promise then
		self._Active.Promise:cancel()
		Modules.spr.stop(self._Object, "Position")
		Modules.spr.stop(self._Object.UIScale, "Scale")
	end

	self._Active.Promise = Modules.Promise.new(function(Resolve, Reject)
		self._FadeObject:FadeOut(0.2)
		Modules.spr.target(self._Object.UIScale, 2, 8, {
			Scale = 1.1
		})
		wait(0.2)
		self._Object.Visible = false
	end)
end

local function match(Content: sring)
	local Players = {}
	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		table.insert(Players, v.Name)
	end
	
	return Modules.Matcher.new(Players, true, true):match(Content)
end

function Hander.new(Parent: instance)
	return setmetatable({
		_Active = {},
		Events = {},
		Properties = {
			["Parent"] = Parent,
			["Toggled"] = false
		}
	}, Hander)
end

function Hander:Deploy()
	self._Object = self._Object or script.TextField:Clone()
	self._Object.Parent = self.Properties.Parent
	self._Object.Name = self.Properties.Name or "Hander"
	
	if #self._Object.Suggestion:GetChildren() ~= 4 then
		for i = 1, 3 do
			local Item = script.Item:Clone()
			Item.Name, Item.LayoutOrder = i, i
			Item.Visible = false
			Item.Parent = self._Object.Suggestion
			
			Item.Trigger.MouseButton1Click:Connect(function()
				local Tool = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool")
				ReplicatedStorage:WaitForChild("Hander_Function"):InvokeServer("send", {["target"] = Item.Input.Text, ["toolName"] = Tool.Name})
				self.Properties.Toggled = false
				self:Deploy()
			end)
		end
	end

	self._FadeObject = self._FadeObject or Modules.Fader.new(self._Object)
	
	if self.Properties.Toggled then
		animateIn(self)
	else
		animateOut(self)
	end
	
	if not self.Events.TextChanged then
		self.Events.TextChanged = self._Object.Input:GetPropertyChangedSignal("Text"):Connect(function()
			for _, object in pairs(self._Object.Suggestion:GetChildren()) do
				if object:IsA("Frame") then
					object.Visible = false
				end
			end
			
			if string.gsub(self._Object.Input.Text, "%s", "") and string.len(string.gsub(self._Object.Input.Text, "%s", "")) >= 1 then
				for index, name in ipairs(match(self._Object.Input.Text)) do
					if index <= 3 then
						local Player = game:GetService("Players"):FindFirstChild(name)
						self._Object.Suggestion[index].Input.Text = Player.Name
						self._Object.Suggestion[index].Avatar.Image.Image = "rbxthumb://type=AvatarHeadShot&id=" .. Player.UserId .. "&w=150&h=150"
						self._Object.Suggestion[index].Visible = true
					end
				end
			end
		end)
	end
end

for _, v in pairs(Common:GetChildren()) do
	if v:IsA("ModuleScript") and v ~= script then
		Modules[v.Name] = require(v)
	end
end

Hander.__index = Hander
Hander.__call = Hander.new
return Hander