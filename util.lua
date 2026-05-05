local Utils = {}

Utils.Workspace = game:GetService("Workspace")
Utils.ReplicatedStorage = game:GetService("ReplicatedStorage")
Utils.WFDataRemote = Utils.ReplicatedStorage:WaitForChild("BridgeNet"):WaitForChild("dataRemoteEvent")
Utils.Players = game:GetService("Players")
Utils.VirtualUser = game:GetService("VirtualUser")


function Utils.BuildArgs(pathTable, nValue)
	local data = {}

	for i,value in ipairs(pathTable) do
		data[i] = value
	end

	if nValue ~= nil then
		data.n = nValue
	end	

	return { data, "\002" }
end

function Utils.RemoveSpaces(text)
	return text:gsub(" ", "")
end

function Utils.PrintTable(table)
	for i,v in pairs(table) do
		print(i,v)
	end
end


return Utils
