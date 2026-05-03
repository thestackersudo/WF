-- I fucking hate key systems
-- https://discord.gg/hJCn7UnkVZ
_G.autoFarm = true
_G.openingStar = false

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Plink World Fighters v1.0.1",
    SubTitle = "by who?",
    TabWidth = 160,
	Transparency = false,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
	AutoFarm = Window:AddTab({ Title = "Auto Farm", Icon = "fast-forward" }),
	Raids = Window:AddTab({ Title = "Raids", Icon = "fast-forward" }),
	Stars = Window:AddTab({ Title = "Stars", Icon = "fast-forward" }),
	Gachas = Window:AddTab({ Title = "Gachas", Icon = "fast-forward" }),
	Units = Window:AddTab({ Title = "Units / Weapons", Icon = "fast-forward" }),
	Teleports = Window:AddTab({ Title = "Teleports", Icon = "fast-forward" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options


local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataRemote = replicatedStorage
    :WaitForChild("BridgeNet")
    :WaitForChild("dataRemoteEvent")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local client = workspace:FindFirstChild(localPlayer.Name)
local clientHRP = client.HumanoidRootPart
--Anti AFK
local VirtualUser = game:GetService("VirtualUser")
localPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local damageNumbers = {
	"K",
	"M",
	"B",
	"T",
	"Qd",
	"Qn",
	"Sx",
	"Sp",
	"Oc",
	"N"
}

function OnRuntime()
	TeleportFactory()
	RaidPriorityFactory()
end

function AutoRaidEnemies(raid) 
	local switch = {
		TrialEasy = function()
		end,
		TrialMedium = function()
		end,
		TrialHard = function()
		end,
		DragonDefense = function()
			local enemies = FindEnemies()
		end,
		TempestInvasion = function()
		end,
	}

	if switch[raid] then
		switch[raid]()
	end
end

function AutoSecretBoss()
_G.secretBoss = true
--Fruit Verse
Teleport("Fruits Verse", 1)
task.wait(3)
TP(6765.2353515625, 822.0428466796875, -1001.8450317382812)
task.wait(1)

Teleport("Fruits Verse", 2)
task.wait(3)
TP(11639.611328125, -8.973938941955566, -23025.291015625)
task.wait(1)


--Dragon Verse
Teleport("Dragon Verse", 1)
task.wait(3)
TP(15862.4375, 803.9520263671875, -2609.734375)
task.wait(1)

Teleport("Dragon Verse", 2)
task.wait(3)
TP(4341.9423828125, 795.0802001953125, 4636.07373046875)
task.wait(1)


--Slime Verse
Teleport("Slime Verse", 1)
task.wait(3)
TP(693.24755859375, 741.7731323242188, -412.68048095703125)
task.wait(1)

Teleport("Slime Verse", 2)
task.wait(3)
TP(573.9026489257812, 753.4492797851562, -3533.68701171875)
task.wait(1)


--Cursed Verse
Teleport("Cursed Verse", 1)
task.wait(3)
TP(5010.60546875, 776.83056640625, -5812.2958984375)
task.wait(1)

-- Teleport("Cursed Verse", 2)
-- task.wait(3)
-- TP(11639.611328125, -8.973938941955566, -23025.291015625)
-- task.wait(3)


-- --Leveling Verse
-- Teleport("Leveling Verse", 1)
-- task.wait(3)
-- TP(11639.611328125, -8.973938941955566, -23025.291015625)
-- task.wait(3)
_G.secretBoss = false
task.wait(Options.SecretBossInput.Value)
print("Wainting for:\t" .. Options.SecretBossInput.Value .. " Seconds")
end

function JoinRaid(raid)
	local args = {
	{
		{
			"General",
			"Gamemodes",
			"Join",
			raid,
			n = 4
		},
		"\002"
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("BridgeNet"):WaitForChild("dataRemoteEvent"):FireServer(unpack(args))
	repeat
		task.wait(1)
		print("Enemies not found.")
	until workspace.Server.Enemies.Gamemodes[raid]:GetChildren() ~= nil
	print("FOUND")
end

function FetchRaidPriorities()
	local gamemodeValues = {}

	for _,mode in pairs(FindGamemodes()) do
		local clean = RemoveSpaces(mode)

		gamemodeValues[clean] = {
			Enabled = Options["Auto" .. clean].Value,
			Priority = Options["RaidPriority" .. clean].Value,
			DisplayName = mode,
			CleanName = clean
		}
	end
	return gamemodeValues
end

function RaidPriorityFactory()
	local loadedModes = FindGamemodes()
	table.sort(loadedModes, function(a,b) 
		return a < b
	end)
	for _,mode in pairs(loadedModes) do
		local modeName = string.gsub(mode, "%s+", "")


		local prioritySlider = Tabs.Raids:AddSlider("RaidPriority" .. modeName, {
        Title = mode .. " Raid Priority",
        Description = "",
        Default = 0,
        Min = 0,
        Max = 20,
        Rounding = 0,
        Callback = function(Value)
            -- print("Slider was changed:", Value)
        end
    	})
		local roomSlider = Tabs.Raids:AddSlider("RaidRoom" .. modeName, {
        Title = mode .. " Room Leave",
        Description = "",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            -- print("Slider was changed:", Value)
        end
    	})
		Divider(Tabs.Raids)
	end
end

function TeleportFactory() 
-- Teleportation Button Creation
	Tabs.Teleports:AddParagraph({
        Title = "Can be buggy if you spam",
        Content = "Sometimes can cause an extra buggy click when \n trying to teleport to worlds you dont own."
    })
	for verse,worlds in pairs(FindVerses()) do
		CreateTeleport(verse, worlds[1])
		CreateTeleport(verse, worlds[2])
	end
end

function FindGamemodes()
	local gamemodes = workspace.Server.Enemies.Gamemodes:GetChildren()
	local returnGamemodes = {}

	for _,mode in pairs(gamemodes) do
		table.insert(returnGamemodes, mode.Name)
	end
	return returnGamemodes
end

function FindWorlds() 
	local maps = workspace.Server.Interactable:GetChildren()
	local returnMaps = {}

	for _,map in pairs(maps) do
		if map.Name ~= "Trial" then
			table.insert(returnMaps, map.Name)
		end 
	end
	return returnMaps
end

function FindVerses()
	local verses = workspace.Client.Maps:GetChildren()
	local returnedVerses = {}

	for _,verse in pairs(verses) do
		if verse.Name:match("([%w%s]+%sVerse)") then
			returnedVerses[verse.Name] = {1,2}
		end
	end
	return returnedVerses
end

function FindEnemies()
	local foundEnemies = {}
	for i,v in pairs(workspace.Client.Enemies:GetChildren()) do
		if not foundEnemies[v.Name] then
			foundEnemies[v] = string.format("%s", v.Head.EnemyHUD.Main.Health.Main.Title.Text:match("/(%S+)%s*%]"))
		end
	end
	return foundEnemies
end

function FindEnemyHealth(enemy)
	local health = string.format("%s", enemy.Head.EnemyHUD.Main.Health.Main.Title.Text:match("%[%s*(%S+)%s*/"))
	return health
end

function FindDropdownEnemies()
	local foundEnemies = {}
	for i,v in pairs(workspace.Client.Enemies:GetChildren()) do
		if not table.find(foundEnemies, v.Name) then
			table.insert(foundEnemies, v.Name)
		end
	end
	return foundEnemies
end

function FindEnemiesWithinRange()
	local playerRange = workspace.Cache.PlayerArea
	local touchingParts = workspace:GetPartBoundsInBox(playerRange.CFrame, playerRange.Size)
	local foundEnemies = {}

	for _, part in pairs(touchingParts) do
		local enemyID = part:GetAttribute("ID")

		if enemyID then
			foundEnemies[enemyID] = true
		end
	end
	return foundEnemies
end	


function Click() 
	task.wait(0.15)
	local args = {
	{
		{
			"General",
			"Attack",
			"Click",
			FindEnemiesWithinRange(),
			n = 4
		},
		"\002"
	}
}
dataRemote:FireServer(unpack(args))
end

function Awaken()
local args = {
	{
		{
			"General",
			"Awakening",
			"Awaken",
			n = 3
		},
		"\002"
	}
}
dataRemote:FireServer(unpack(args))
end


function OpenStar(world) 
local args = {
	{
		{
			"General",
			"Stars",
			"Open",
			world,
			50,
			n = 5
		},
		"\002"
	}
}
dataRemote:FireServer(unpack(args))
task.wait(2)
end



function Teleport(verse, world)
local args = {
	{
		{
			"Player",
			"Teleport",
			"Teleport",
			verse,
			world,
			n = 5
		},
		"\002"
	}
}
dataRemote:FireServer(unpack(args))
end

function TP(x,y,z)
	clientHRP.CFrame = CFrame.new(x,y,z)
end


function Notify(title, content, duration) 
	Fluent:Notify({
        Title = title,
        Content = content,
        Duration = duration -- Set to nil to make the notification not disappear
    	})
end

function NotifyToggle(content) 
	Fluent:Notify({
        Title = "Toggle Changed.",
        Content = content,
        Duration = 1
    	})
end

function printTable(table)
	for i,v in pairs(table) do
		print(i,v)
	end
end

function RemoveSpaces(text)
    local result = ""

    for i = 1, #text do
        local char = string.sub(text, i, i)

        if char ~= " " then
            result = result .. char
        end
    end

    return result
end


function CreateTeleport(verse, world)
	local cooldown = false
	Tabs.Teleports:AddButton({
        Title = verse,
        Description = world,
        Callback = function()
			task.spawn(function() 
				Teleport(verse, world)
        	end)
		end
    })
end

function Divider(tab)
	tab:AddParagraph({
        Title = "------------------------------------------------------------------------------------------------",
        Content = ""
    })
end


do
	OnRuntime()
	Tabs.Main:AddButton({
        Title = "Discord",
        Description = "Join the discord for updates <3 - ",
        Callback = function()
		Notify("Discord link copied to clipboard.")
			setclipboard("https://discord.gg/hJCn7UnkVZ")
        end
    })
	--TESTING BUTTON
	Tabs.Main:AddButton({
        Title = "Test",
        Description = "Debug button, likely does nothing.",
        Callback = function()
			AutoSecretBoss()
        end
    })


	--Main Tab
    local AutoClick = Tabs.Main:AddToggle("AutoClick", {Title = "Auto Click", Default = false })
	AutoClick:OnChanged(function()
        NotifyToggle("Auto Click")
		task.spawn(function() 
			while Options.AutoClick.Value == true do
				task.wait()
				Click()
			end
		end)
    end)

	local AutoAwaken = Tabs.Main:AddToggle("AutoAwaken", {Title = "Auto Awaken", Default = false })
	AutoAwaken:OnChanged(function()
        NotifyToggle("Auto Awaken")
		task.spawn(function() 
			while Options.AutoAwaken.Value == true do
				Awaken()
				task.wait(10)
			end
		end)
    end)

	local AutoSecretBossToggle = Tabs.Main:AddToggle("AutoSecretBossToggle", {Title = "Auto Secret Boss", Default = false })
	AutoSecretBossToggle:OnChanged(function()
        NotifyToggle("Auto Secret Boss")
		task.spawn(function() 
			while Options.AutoSecretBossToggle.Value == true do
				task.wait()
				AutoSecretBoss()
			end
		end)
    end)

	local SecretBossInput = Tabs.Main:AddInput("SecretBossInput", {
        Title = "Secret Boss Wait TIme",
        Default = "",
        Placeholder = "Wait time in seconds.",
        Numeric = true, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            
        end
    })


	--Auto Farm Tab
	Tabs.AutoFarm:AddParagraph({
        Title = "Make sure to turn on Auto Click",
        Content = "Its located within the Main Tab."
    })

	local EnemyDropdown = Tabs.AutoFarm:AddDropdown("EnemyDropdown", {
        Title = "Enemies:",
        Description = "Select enemies from list:",
        Values = FindDropdownEnemies(),
        Multi = true,
        Default = {},
    })

	local AutoFarm = Tabs.AutoFarm:AddToggle("AutoFarm", {Title = "Auto Farm", Default = false })
	AutoFarm:OnChanged(function()
		NotifyToggle("Auto Farm")
		task.spawn(function()
			while Options.AutoFarm.Value == true and _G.secretBoss == false do
				task.wait()
				local enemies = FindEnemies()
				local farmingEnemies = EnemyDropdown.Value

				for enemy, enemyMaxHealth in pairs(enemies) do
					if farmingEnemies[enemy.Name] and Options.AutoFarm.Value == true then
						if enemy.HumanoidRootPart.CFrame then
						
						repeat 
							task.wait(1)
							clientHRP.CFrame = enemy.HumanoidRootPart.CFrame
						until FindEnemyHealth(enemy) == "0" or Options.AutoFarm.Value == false or _G.openingStar == true
						end
					end
				end
			end
		end)
	end)

	Tabs.AutoFarm:AddButton({
        Title = "Refresh Enemies",
        Description = "Refresh Loaded Enemies",
        Callback = function()
			Notify("Refreshed Enemies.", "Enemies successfully refreshed.", 3)
			EnemyDropdown:SetValues(FindDropdownEnemies())
        end
    })


	--Star Tab
	local StarDropdown = Tabs.Stars:AddDropdown("StarDropdown", {
        Title = "World:",
        Description = "Select world from list:",
        Values = FindWorlds(),
        Multi = false,
        Default = 1,
    })

	local AutoStar = Tabs.Stars:AddToggle("AutoStar", {Title = "Auto Star", Default = false })
	AutoStar:OnChanged(function()
        NotifyToggle("Auto Star")
		task.spawn(function() 
			while Options.AutoStar.Value == true and _G.secretBoss == false do
				task.wait()
				if Options.AutoStarTP.Value == true then
					_G.openingStar = true
					local stars = workspace.Server.Stars
					repeat
						task.wait()
					until #stars:GetChildren() == 1

					local currentStar = stars:GetChildren()
					TP(currentStar[1].Part.Position.X, currentStar[1].Part.Position.Y, currentStar[1].Part.Position.Z)
					task.wait(0.2)
				end
				OpenStar(StarDropdown.Value)
				print(_G.openingStar)
				_G.openingStar = false
			end
		end)
    end)

	Tabs.Stars:AddParagraph({
        Title = "This will teleport you to the nearest star every 2 seconds.",
        Content = "So make sure its selected to your current world."
    })

	local AutoStarTP = Tabs.Stars:AddToggle("AutoStarTP", {Title = "Auto Star TP", Default = false })
	AutoStarTP:OnChanged(function()
        NotifyToggle("Auto Star TP")
    end)



	--Raid Tab

	local AutoTrialEasy = Tabs.Raids:AddToggle("AutoTrialEasy", {Title = "Auto Trial Easy", Default = false })
	AutoTrialEasy:OnChanged(function()
        NotifyToggle("Auto Trial Easy")
    end)
	local AutoTrialMedium = Tabs.Raids:AddToggle("AutoTrialMedium", {Title = "Auto Trial Medium", Default = false })
	AutoTrialMedium:OnChanged(function()
        NotifyToggle("Auto Trial Medium")
    end)
	local AutoTrialHard = Tabs.Raids:AddToggle("AutoTrialHard", {Title = "Auto Trial Hard", Default = false })
	AutoTrialHard:OnChanged(function()
        NotifyToggle("Auto Trial Hard")
    end)
	local AutoDragonDefense = Tabs.Raids:AddToggle("AutoDragonDefense", {Title = "Auto Dragon Defense", Default = false })
	AutoDragonDefense:OnChanged(function()
        NotifyToggle("Auto Dragon Defense")
    end)
	local AutoTempestInvasion = Tabs.Raids:AddToggle("AutoTempestInvasion", {Title = "Auto Tempest Invasion", Default = false })
	AutoTempestInvasion:OnChanged(function()
        NotifyToggle("Auto Tempest Invasion")
    end)

	Tabs.Raids:AddParagraph({
        Title = "Auto Raid Starts ALL Raids.",
        Content = "The Toggles below this are to toggle the script to start doing raids based on priority. \nPrioritises HIGHER numbers."
    })

	local AutoRaid = Tabs.Raids:AddToggle("AutoRaid", {Title = "Auto Raid", Default = false })
	AutoRaid:OnChanged(function()
        NotifyToggle("Auto Raid")
		task.spawn(function() 
			while Options.AutoRaid.Value == true and _G.secretBoss == false do
				task.wait()
				local raidPriorities = FetchRaidPriorities()
				local currentPriorities = {}

				for raid,options in pairs(raidPriorities) do
					if options.Enabled == true then
						table.insert(currentPriorities, {
							Name = raid,
							Priority = options.Priority,
							DisplayName = options.DisplayName,
							CleanName = options.CleanName
						})
					end
				end

				table.sort(currentPriorities, function(a,b) 
					return a.Priority > b.Priority
				end)


				for _,options in pairs(currentPriorities) do
					JoinRaid(options.DisplayName)
					AutoRaidEnemies(options.CleanName)
				end
			end
		end)
    end)
end



















-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("PlinkScriptHub")
SaveManager:SetFolder("PlinkScriptHub/world-fighters")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(3)

Fluent:Notify({
    Title = "Plink",
    Content = "Plonk.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
