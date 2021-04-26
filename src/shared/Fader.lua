local Fader = {}
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local function ReturnValues(Object: GuiObject)
	local Values = {
		["TextLabel"] = {
			["TextTransparency"] = 0,
			["TextStrokeTransparency"] = 0,
			["BackgroundTransparency"] = 0
		},

		["TextButton"] = {
			["TextTransparency"] = 0,
			["TextStrokeTransparency"] = 0,
			["BackgroundTransparency"] = 0
		},

		["TextBox"] = {
			["TextTransparency"] = 0,
			["TextStrokeTransparency"] = 0,
			["BackgroundTransparency"] = 0
		},

		["Frame"] = {
			["BackgroundTransparency"] = 0
		},

		["ViewportFrame"] = {
			["ImageTransparency"] = 0,
			["BackgroundTransparency"] = 0
		},

		["VideoFrame"] = {
			["BackgroundTransparency"] = 0
		},

		["ImageLabel"] = {
			["ImageTransparency"] = 0,
			["BackgroundTransparency"] = 0
		},

		["ImageButton"] = {
			["ImageTransparency"] = 0,
			["BackgroundTransparency"] = 0
		},
		
		["UIStroke"] = {
			["Transparency"] = 0
		}
	}
	local ActualValue = Values[Object.ClassName]
	if ActualValue then
		for name,_ in pairs(ActualValue) do
			if Object[name] >= 1 then
				ActualValue[name] = nil
			else
				ActualValue[name] = Object[name]
			end
		end
	end
	
	return ActualValue
end

function Fader:FadeIn(Duration: number?)
	local Items = self._Object:GetDescendants()
	table.insert(Items, self._Object)
	
	for _, child in ipairs(Items) do
		local Data = self._Data[child:GetAttribute("Identifier")]
		if Data then
			for name, value in pairs(Data) do
				child[name] = 1
				if Duration then
					local Tween = TweenService:Create(child, TweenInfo.new(Duration), {[name] = value})
					Tween.Completed:Connect(function()
						Tween:Destroy()
					end)
					
					Tween:Play()
				else
					child[name] = value
				end
			end
		end
	end
end

function Fader:FadeOut(Duration: number?)
	local Items = self._Object:GetDescendants()
	table.insert(Items, self._Object)
	
	for _, child in ipairs(Items) do
		local Data = self._Data[child:GetAttribute("Identifier")]
		if Data then
			for name, value in pairs(Data) do
				child[name] = value
				if Duration then
					local Tween = TweenService:Create(child, TweenInfo.new(Duration), {[name] = 1})
					Tween.Completed:Connect(function()
						Tween:Destroy()
					end)

					Tween:Play()
				else
					child[name] = 1
				end
			end
		end
	end
end

function Fader:Assign(Number: number, Duration: number?)
	local Items = self._Object:GetDescendants()
	table.insert(Items, self._Object)
	
	for _, child in ipairs(Items) do
		local Data = self._Data[child:GetAttribute("Identifier")]
		if Data then
			for name, _ in pairs(Data) do
				if Duration then
					local Tween = TweenService:Create(child, TweenInfo.new(Duration), {[name] = Number})
					Tween.Completed:Connect(function()
						Tween:Destroy()
					end)

					Tween:Play()
				else
					child[name] = Number
				end
			end
		end
	end
end

function Fader.new(Object: GuiObject)
	local TransparencyData = {}
	local Items = Object:GetDescendants()
	table.insert(Items, Object)
	
	for _, child in ipairs(Items) do
		if child:IsA("Instance") then
			child:SetAttribute("Identifier", HttpService:GenerateGUID())
			TransparencyData[child:GetAttribute("Identifier")] = ReturnValues(child)
		end
	end
	
	return setmetatable({
		_Data = TransparencyData,
		_Object = Object
	}, Fader)
end

Fader.__index = Fader
Fader.__call = Fader.new
return Fader