local Utils = {}

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




return Utils
