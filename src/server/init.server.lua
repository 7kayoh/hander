-- A simple, production-ready hand-to utility for your roleplay game's need
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local configuration = require(script.Configuration)
local common = ReplicatedStorage:WaitForChild("Common")
local promise = require(common:WaitForChild("Promise"))
local logger = require(common:WaitForChild("Logger")).new(script.Name)
local remoteEvent, remoteFunction = nil, nil
local cache = {}

local function fetchRank(client: player, groupId: number)
	return promise.new(function(resolve, reject)
		local ok, result = pcall(client.GetRankInGroup, client, groupId)
		
		if ok then
			resolve(result)
		else
			reject(result)
		end
	end)
end

local function checkAuthorize(rank: number)
	for index = 1, #configuration.ranks do
		local item = configuration.ranks[index]
		if type(item) == "string" and string.match(item, configuration.pattern) then
			local condition, itemRank = string.match(item, configuration.pattern)
			local difference = rank - tonumber(itemRank)
			if (condition == "" and difference == 0) or (condition == "<" and difference <= 0) or (condition == ">" and difference >= 0) then
				return true
			else
				return false
			end
		end
	end
end

local function cacheRank(client)
	if not cache[client.UserId] then
		local status = false
		logger:Info("cache; " .. client.Name .. "'s rank is not cached, caching...")
		promise.retry(fetchRank, configuration.maxRetries, client, configuration.groupId)
			:andThen(function(result)
				status = true
				table.insert(cache, client.UserId, tonumber(result))
			end)
			:catch(function(result)
				status = true
				logger:Warn("fetchRank; " .. result)
			end)
			
		repeat wait() until status
	end
end

local function onInvoke(client, protocol: string, attachment)
	local isUserAuthorized = false
	cacheRank(client)
	isUserAuthorized = checkAuthorize(cache[client.UserId])
	warn(isUserAuthorized)
	if protocol == "send" and isUserAuthorized then
		local targetName, toolName = attachment.target, attachment.toolName
		local target, tool = Players:FindFirstChild(targetName or ""), client.Character:FindFirstChild(toolName or "")
		if target and tool then
			client.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
			tool.Parent = target.Backpack
			target.Character:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
			logger:Info("send; " .. client.Name .. " sent tool \"" .. tool.Name .. "\" to " .. target.Name)
			return true
		end
	end
	
	return false
end

local function onCall()
	
end

local function onPlayerAdded(client)
	local isUserAuthorized = false
	cacheRank(client)
	isUserAuthorized = checkAuthorize(cache[client.UserId])
	
	if isUserAuthorized then
		local interface = script.UI:Clone()
		interface.Parent = client.PlayerGui
		--TODO: Interface
	end
end

local function onPlayerRemoving(client)
	if cache[client.UserId] then
		table.remove(cache, client.UserId)
	end
end

local function init()
	remoteEvent = Instance.new("RemoteEvent")
	remoteFunction = Instance.new("RemoteFunction")
	
	remoteEvent.Name = "Hander_Event"
	remoteFunction.Name = "Hander_Function"
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
	remoteEvent.OnServerEvent:Connect(onCall)
	remoteFunction.OnServerInvoke = onInvoke
	remoteEvent.Parent, remoteFunction.Parent = ReplicatedStorage, ReplicatedStorage
end

init()