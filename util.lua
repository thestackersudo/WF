local Utils = {}

Utils.Workspace = game:GetService("Workspace")
Utils.ReplicatedStorage = game:GetService("ReplicatedStorage")
if Utils.ReplicatedStorage.BridgeNet then
	Utils.WFDataRemote = Utils.ReplicatedStorage.BridgeNet.dataRemoteEvent
end
Utils.Players = game:GetService("Players")
Utils.VirtualUser = game:GetService("VirtualUser")
Utils.HttpService = game:GetService("HttpService")


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

function Utils.SendDiscordWebhook(body)
	return Utils.PostAsync("https://webhook.site/dcf66f2e-c2d5-4c6b-83fb-035a5a94b660", body)
end

function Utils.PostAsync(url,body)
	local response = request({
	Url = url,
	Method = "POST",
	Headers = {
		["Content-Type"] = "application/json"
	},
	Body = httpService:JSONEncode(body)
	})
return response
end

return Utils

