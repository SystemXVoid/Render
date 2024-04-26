--[[

    Render Intents | a dusty trip
    The #1 vape mod you'll ever see.

    Version: 2.0
    discord.gg/render

]]
local GuiLibrary = shared.GuiLibrary
local playersService = game:GetService('Players')
local textservice = game:GetService('TextService')
local replicatedStorage = game:GetService('ReplicatedStorage')
local lplr = playersService.LocalPlayer
local lighting = game:GetService('Lighting')
local cam = workspace.Camera
local targetinfo = shared.VapeTargetInfo
local inputService = game:GetService('UserInputService')
local teleportService = game:GetService("TeleportService")
local mouse = lplr:GetMouse()
local robloxfriends = {}
local vapeInjected = true
local bedwars = {}
local getfunctions
local InfoNotification = function() end
local warningNotification = function() end
local getExistCar = function() return {} end
local runService = game:GetService("RunService")
local openCaps = function() end
local GetEnumItems = function() return {} end
local entityLibrary = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local queueteleport = queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local getasset = getsynasset or getcustomasset
local storedshahashes = {}
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
			RunLoops.RenderStepTable[name] = runService.RenderStepped:Connect(func)
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
			RunLoops.StepTable[name] = runService.Stepped:Connect(func)
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
			RunLoops.HeartTable[name] = runService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local run = function(v) v() end
local runFunction = function(v) v() end

runFunction(function()
    warningNotification = function(title, text, delay)
        local suc, res = pcall(function()
            local color = GuiLibrary.ObjectsThatCanBeSaved['Gui ColorSliderColor'].Api
            local frame = GuiLibrary.CreateNotification(title, text, delay, 'assets/WarningNotification.png')
            frame.Frame.Frame.ImageColor3 = Color3.fromHSV(color.Hue, color.Sat, color.Value)
            frame.IconLabel.ImageColor3 = Color3.fromHSV(color.Hue, color.Sat, color.Value)
            return frame
        end)
        return (suc and res)
    end
    openCaps = function(object, callback)
        if object.Value == callback or false then
            replicatedStorage.openclose:FireServer(unpack({
                [1] = object
            }))
        end
    end
    InfoNotification = function(title, text, delay)
        local success, frame = pcall(function()
            return GuiLibrary.CreateNotification(title, text, delay)
        end)
        return success and frame
    end
    errorNotification = function(title, text, delay)
        local success, frame = pcall(function()
            local notification = GuiLibrary.CreateNotification(title, text, delay or 6.5, 'assets/WarningNotification.png')
            notification.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
            notification.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
        end)
        return success and frame
    end
    GetEnumItems = function(enum)
        local fonts = {}
        for i,v in Enum[enum]:GetEnumItems() do 
            table.insert(fonts, v.Name) 
        end
        return fonts
    end    
    getExistCar = function()
        local car = {"Sedan", "Van"}
        if workspace:FindFirstChild("Truck") then
            table.insert(car, "Truck")
        end
        return car
    end
end)

GuiLibrary.SelfDestructEvent.Event:Connect(function()
    vapeInjected = false
	if chatconnection then
		chatconnection:Disconnect()
	end
	if oldchannelfunc and oldchanneltab then
		oldchanneltab.GetChannel = oldchannelfunc
	end
	for i2,v2 in oldchanneltabs do
		i2.AddMessageToChannel = v2
	end
    getgenv().RenderStore = nil
end)

RenderFunctions:AddCommand('lobby', function() 
	teleportService:Teleport(16389395869)
end)

GuiLibrary.RemoveObject('SilentAimOptionsButton')
GuiLibrary.RemoveObject('MouseTPOptionsButton')
GuiLibrary.RemoveObject('ReachOptionsButton')
GuiLibrary.RemoveObject('HitBoxesOptionsButton')
GuiLibrary.RemoveObject('KillauraOptionsButton')
GuiLibrary.RemoveObject('SafeWalkOptionsButton')
GuiLibrary.RemoveObject('TriggerBotOptionsButton')

run(function()
    local InfiniteItem = {}
    local item = {Value = ""}
    local time = {Value = 0}
    local vehicle = {Value = "Sedan"}
    InfiniteItem = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "InfiniteItem",
        Function = function(call)
            if call then
                task.spawn(function()
                    if item.Value == "OilCan" then
                        for i,v in workspace:GetChildren() do
                            if v.Name == "Engine" then
                                openCaps(v.tank.tankhit.isopen)
                            end
                        end
                    elseif item.Value == "WaterCan" then
                        openCaps(workspace:FindFirstChild("radiator").water.tankhit.isopen)
                    else
                        openCaps(workspace[vehicle.Value].Misc.tank.tankhit.isopen)
                    end
                end)
                if item.Value == "OilCan" then
                    for i,v in workspace:GetChildren() do
                        if v.Name == "Engine" then
                            for i2,v2 in workspace.Base:GetChildren() do
                                if v2.Name == "OilCan" then
                                    for i = 1,time.Value do
                                        replicatedStorage.fill:FireServer(unpack({
                                            [1] = v.tank.main.tank,
                                            [2] = v2.main.tank
                                        }))
                                    end
                                    openCaps(true)
                                end
                            end
                        end
                    end
                else
                    for i,v in workspace.Base:GetChildren() do
                        if v.Name == item.Value then
                            for i = 1,time.Value do
                                if item.Value == "GasCan" then
                                    replicatedStorage.fill:FireServer(unpack({
                                        [1] = workspace[vehicle.Value].Misc.tank.main.tank,
                                        [2] = v.main.tank
                                    }))
                                else
                                    replicatedStorage.fill:FireServer(unpack({
                                        [1] = workspace.radiator.tank.main.tank,
                                        [2] = v.main.tank
                                    }))
                                end
                            end
                            if item.Value == "GasCan" then
                                openCaps(workspace[vehicle.Value].Misc.tank.tankhit.isopen, true)
                            else
                                openCaps(workspace.radiator.water.tankhit.isopen, true)
                            end
                        end
                    end
                end   
                InfiniteItem.ToggleButton()                 
            end
        end,
        ExtraText = function()
            return item.Value
        end,
        HoverText = "Choose infiniteStuff For your car."
    })
    local carlist = {}
    for i,v in getExistCar() do table.insert(carlist, v) end
    vehicle = InfiniteItem.CreateDropdown({
        Name = "Vehicle",
        List = carlist,
        Function = function() end,
        HoverText = "Your vehicle. <3"
    })
    item = InfiniteItem.CreateDropdown({
        Name = "Item",
        List = {"GasCan", "OilCan", "WaterCan"},
        Function = function() end,
        HoverText = "Stuff for your car if you wanna look like legit."
    })
    time = InfiniteItem.CreateSlider({
        Name = "Time",
        Min = 1,
        Max = 50,
        Default = 25,
        Function = function() end,
        HoverText = "25 is default if you wanna look like legit."
    })
end)

run(function()
    local removeEngine = {}
    local oldison 
    local oldmaxspeed
    local oldtorque
    local oldturnspeed
    local vehicle = {Value = ""}
    removeEngine = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "removeEngine",
        Function = function(call)
            if call then
                oldison = workspace[vehicle.Value].values.ison.Value
                oldmaxspeed = workspace[vehicle.Value].DriveSeat.MaxSpeed
                oldtorque = workspace[vehicle.Value].DriveSeat.Torque
                oldturnspeed = workspace[vehicle.Value].DriveSeat.TurnSpeed
                workspace[vehicle.Value].DriveSeat.MaxSpeed = math.huge
                workspace[vehicle.Value].DriveSeat.TurnSpeed = 0.1
                workspace[vehicle.Value].values.ison.Value = true
                workspace[vehicle.Value].DriveSeat.Torque = math.huge
            else
                workspace[vehicle.Value].DriveSeat.MaxSpeed = oldmaxspeed
                workspace[vehicle.Value].DriveSeat.TurnSpeed = oldturnspeed
                workspace[vehicle.Value].values.ison.Value = oldison
                workspace[vehicle.Value].DriveSeat.Torque = oldtorque
            end
        end,
        ExtraText = function()
            return vehicle.Value
        end,
        HoverText = "This makes you drive without needing engine (only wheels)"
    })
    local list = {}
    for i,v in getExistCar() do table.insert(list, v) end
    vehicle = removeEngine.CreateDropdown({
        Name = "Vehicle",
        List = list,
        Function = function() end
    })
end)
