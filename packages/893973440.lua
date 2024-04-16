--[[

    Render Intents | Flee the facility
    The #1 vape mod you'll ever see.

    Version: 2.0
    discord.gg/render

]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService('Players')
local textservice = game:GetService('TextService')
local replicatedStorageService = game:GetService('ReplicatedStorage')
local lplr = players.LocalPlayer
local workspace = game:GetService('Workspace')
local lighting = game:GetService('Lighting')
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService('UserInputService')
local mouse = lplr:GetMouse()
local robloxfriends = {}
local vapeInjected = true
local getfunctions
local getrandomvalue = function() return '' end
local InfoNotification = function() end
local GetEnumItems = function() return {} end
local isAlive = function() return end
local getGameMap = function() return end
local isBeast = function() return end
local findBeast = function() return end
local getAllComputer = function() return end
local entity = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local facilityStore = {}
local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}
local networkownertick = tick()
local networkownerfunc = isnetworkowner or function(part)
	if gethiddenproperty(part, 'NetworkOwnershipRule') == Enum.NetworkOwnership.Manual then 
		sethiddenproperty(part, 'NetworkOwnershipRule', Enum.NetworkOwnership.Automatic)
		networkownertick = tick() + 8
	end
	return networkownertick <= tick()
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService('RunService').RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService('RunService').Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService('RunService').Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local function run(v)
	v()
end

run(function()
    facilityStore = {
        gameState = 0,
        computerFinished = 0,
        currentBeast = "nil",
        beastChance = 0
    }

    getrandomvalue = function(tab)
        return #tab > 0 and tab[math.random(1, #tab)] or ''
    end
    
    GetEnumItems = function(enum)
        local fonts = {}
        for i,v in next, Enum[enum]:GetEnumItems() do 
            table.insert(fonts, v.Name) 
        end
        return fonts
    end
    
    InfoNotification = function(title, text, delay)
        local success, frame = pcall(function()
            return GuiLibrary.CreateNotification(title, text, delay)
        end)
        return success and frame
    end

    updateStore = function()
        for i,v in workspace:GetChildren() do
            if v:FindFirstChild("ComputerTable") then
                facilityStore.gameState = 1
                for i2,v2 in game:GetService("Players"):GetPlayers() do
                    if v2.TempPlayerStatsModule.IsBeast.Value then
                        facilityStore.currentBeast = v2
                    end
                end
                if v.Screen.BrickColor == "Dark green" then
                    v.Name = "Finished ComputerTable"
                    facilityStore.computerFinished += 1
                end
            else
                facilityStore.gameState = 0
                facilityStore.computerFinished = 0
            end
        end
        facilityStore.beastChance = lplr.SavedPlayerStatsModule.BeastChance.Value
    end 

    task.spawn(function()
        repeat
            updateStore()
            wait(2)
        until (not vapeInjected)
    end)
    isAlive = function(plr, nohealth) 
        plr = plr or lplr
        local alive = false
        if plr.Character and plr.Character:FindFirstChildWhichIsA('Humanoid') and plr.Character.PrimaryPart and plr.Character:FindFirstChild('Head') then 
            alive = true
        end
        local success, health = pcall(function() return plr.Character:FindFirstChildWhichIsA('Humanoid').Health end)
        if success and health <= 0 and not nohealth then
            alive = false
        end
        return alive
    end
    
    getGameMap = function()
        if facilityStore.gameState ~= 0 then return end
        for i,v in workspace:GetChildren() do
            if v:FindFirstChild("ComputerTable") then
                return v.Name
            end
        end
    end

    isBeast = function(plr)
        if lplr.TempPlayerStatsModule.IsBeast.Value then
            return true
        else
            return false
        end
    end

    findBeast = function()
        for i,v in game:GetService("Players"):GetPlayers() do
            if v.TempPlayerStatsModule.IsBeast.Value then
                return v
            end
        end
    end

    getAllComputer = function(distances)
        local computerTable = {}
        local gameMatch = getGameMap()
        for i,v in gameMatch:FindFirstChild("ComputerTable") do
            if isAlive(lplr, true) and facilityStore.gameState ~= 0 then
                local distance = (lplr.Character.HumanoidRootPart.Position - v.Screen.Position).Magnitude
                if distance < (distances or math.huge) then
                    table.insert(computerTable, {computer = v, Positions = v.Screen.Position})
                end
            end
        end
        return computerTable
    end
end)


GuiLibrary.SelfDestructEvent.Event:Connect(function()
	if chatconnection then
		chatconnection:Disconnect()
	end
	if teleportfunc then
		teleportfunc:Disconnect()
	end
	if oldchannelfunc and oldchanneltab then
		oldchanneltab.GetChannel = oldchannelfunc
	end
	for i2,v2 in pairs(oldchanneltabs) do
		i2.AddMessageToChannel = v2
	end
    vapeInjected = false
end)

GuiLibrary.RemoveObject('SilentAimOptionsButton')
GuiLibrary.RemoveObject('KillauraOptionsButton')
GuiLibrary.RemoveObject('SafeWalkOptionsButton')
GuiLibrary.RemoveObject('TriggerBotOptionsButton')

local teleportedServers = false
teleportfunc = lplr.OnTeleport:Connect(function(State)
    if (not teleportedServers) then
		teleportedServers = true
		if shared.vapeoverlay then
			queueteleport("shared.vapeoverlay = "..shared.vapeoverlay)
		end
    end
end)

run(function()
	local AutoComputer = {Enabled = false}
    local Range = {Value = 25}
    local map
    local trigger
    local Teleport = {Enabled = false}
	AutoComputer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoComputer",
		Function = function(call)
            if call then
                task.spawn(function()
                    repeat
                        if isBeast() then return end
                        local computers = getAllComputer(Range.Value)   
                        if Teleport.Enabled then
                           return computer.Positions
                        end
                        for i = 1,3 do
                            trigger = "ComputerTrigger".. i
                            replicatedStorageService.RemoteEvent:FireServer(unpack({
                                [1] = "SetPlayerMinigameResult",
                                [2] = true
                            }))
                            replicatedStorageService.RemoteEvent:FireServer(unpack({
                                [1] = "Input",
                                [2] = "Trigger",
                                [3] = false,
                                [4] = computers.computer[trigger].Event
                            }))
                        end
                        task.wait(0.5)
                    until (not AutoComputer.Enabled)
                end)
            end
		end,
		HoverText = "funny"
	})
end)

task.spawn(function()
	local timeupdate = tick()
    local isStarting
	wait(5)
	repeat 
        if facilityStore.gameState == 1 then
            isStarting = "true"
        else
            isStarting = "false"
        end
		RenderStore.sessionInfo:addListText('GameMap', getGameMap())
		RenderStore.sessionInfo:addListText('CurrentBeast', findBeast())
		RenderStore.sessionInfo:addListText('ComputerFinished', facilityStore.computerFinished)
		local time = os.date('*t')
		local hour = ((time.hour - 1) % 12 + 1)
		RenderStore.sessionInfo:addListText('Time', tostring(hour)..':'..(time.min < 10 and '0' or '')..tostring(time.min)..(time.hour < 12 and 'AM' or 'PM'))
		RenderStore.sessionInfo:addListText('Match Started', isStarting)
		RenderStore.sessionInfo:addListText('beastChance', facilityStore.beastChance)
		print("updated")
		task.wait(5)
	until (not vapeInjected)
end)