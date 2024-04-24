--[[

    Render Intents | Anime RNG
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
local bedwars = {}
local getfunctions
local getrandomvalue = function() return '' end
local InfoNotification = function() end
local runService = game:GetService("RunService")
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

local function getSpeedMultiplier(reduce)
	local speed = 1
	if lplr.Character then 
		local speedboost = lplr.Character:GetAttribute('SpeedBoost')
		if speedboost and speedboost > 1 then 
			speed = speed + (speedboost - 1)
		end
		if lplr.Character:GetAttribute('GrimReaperChannel') then 
			speed = speed + 0.6
		end
		if lplr.Character:GetAttribute('SpeedPieBuff') then 
			speed = speed + (queueType == 'SURVIVAL' and 0.15 or 0.3)
		end
	end
	return reduce and speed ~= 1 and speed * (0.9 - (0.15 * math.floor(speed))) or speed
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

local function run(v)
	v()
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == 'table' and v.hash == obj then
			return v
		end
	end
	return nil
end

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	if chatconnection then
		chatconnection:Disconnect()
	end
	if oldchannelfunc and oldchanneltab then
		oldchanneltab.GetChannel = oldchannelfunc
	end
	for i2,v2 in pairs(oldchanneltabs) do
		i2.AddMessageToChannel = v2
	end
end)

GuiLibrary.RemoveObject('SilentAimOptionsButton')
GuiLibrary.RemoveObject('AutoClickerOptionsButton')
GuiLibrary.RemoveObject('MouseTPOptionsButton')
GuiLibrary.RemoveObject('ReachOptionsButton')
GuiLibrary.RemoveObject('HitBoxesOptionsButton')
GuiLibrary.RemoveObject('KillauraOptionsButton')
GuiLibrary.RemoveObject('LongJumpOptionsButton')
GuiLibrary.RemoveObject('HighJumpOptionsButton')
GuiLibrary.RemoveObject('SafeWalkOptionsButton')
GuiLibrary.RemoveObject('TriggerBotOptionsButton')
GuiLibrary.RemoveObject('ClientKickDisablerOptionsButton')

run(function()
	local AutoRolls = {Enabled = false}
	local isSuper = {Enabled = false}
	AutoRolls = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoRolls",
		Function = function()
			task.spawn(function()
				repeat
					for i = 1,6 do
						replicatedStorageService.Remotes.Roll:FireServer(isSuper.Enabled)
						replicatedStorageService.Remotes.RollDebounce:FireServer(isSuper.Enabled)
						replicatedStorageService.Remotes.Roll:FireServer(isSuper.Enabled)
						replicatedStorageService.Remotes.RollDebounce:FireServer(isSuper.Enabled)
					end
					task.wait(tick())
				until (not AutoRolls.Enabled)
			end)
		end,
		HoverText = "Automatic Roll For You (but faster :troll:)"
	})
	isSuper = AutoRolls.CreateToggle({
		Name = "SuperRoll",
		Function = function() end,
		HoverText = "use superroll"
	})
end)
task.spawn(function()
	local timeupdate = tick()
	wait(5)
	repeat 
		RenderStore.sessionInfo:addListText('Effect', 'nil')
		RenderStore.sessionInfo:addListText('Whitelist Rank', RenderFunctions:GetPlayerType(1))
		RenderStore.sessionInfo:addListText('Cash', lplr.Cash.Value)
		local time = os.date('*t')
		local hour = ((time.hour - 1) % 12 + 1)
		RenderStore.sessionInfo:addListText('Time', tostring(hour)..':'..(time.min < 10 and '0' or '')..tostring(time.min)..(time.hour < 12 and 'AM' or 'PM'))
		RenderStore.sessionInfo:addListText('Normal Rolls', lplr.RollsTilLuck.Value)
		RenderStore.sessionInfo:addListText('Mega Rolls', lplr.SuperRolls.Value)
		print("updated")
		task.wait(5)
	until (not vapeInjected)
end)