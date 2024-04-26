-- Render Custom Vape Signed File
--[[

    Render Intents | Skywars
    The #1 vape mod you'll ever see.

    Version: 2.0
    discord.gg/render

]]
local GuiLibrary = shared.GuiLibrary
local players = game:GetService('Players')
local textservice = game:GetService('TextService')
local replicatedStorageService = game:GetService('ReplicatedStorage')
local inputService = game:GetService("UserInputService")
local lplr = players.LocalPlayer
local vapeInjected = true
local workspace = game:GetService('Workspace')
local lighting = game:GetService('Lighting')
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService('UserInputService')
local mouse = lplr:GetMouse()
local robloxfriends = {}
local getfunctions
local getrandomvalue = function() return '' end
local InfoNotification = function() end
local GetEnumItems = function() return {} end
local entityLibrary = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == 'GET' then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	else
		return {
			Body = 'bad exploit',
			Headers = {},
			StatusCode = 404
		}
	end
end 
local skywars = {
	gameState = 0
}
local getcustomasset = getsynasset or getcustomasset or function(location) return 'rbxasset://'..location end
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

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
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

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj or type(v) == 'table' and v.hash == obj then
			return v
		end
	end
	return nil
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

isEnabled = function(button, category)
	local success, enabled = pcall(function()
		return GuiLibrary.ObjectsThatCanBeSaved[button..(category or 'OptionsButton')].Api.Enabled 
	end)
	return success and enabled
end

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

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == 'Client' then
			return tab[i + 1]
		end
	end
	return ''
end
local getcustomasset = getsynasset or getcustomasset or function(location) return 'rbxasset://'..location end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
GetAllTargets = function(distance, raycast, sort)
	local targets = {}
	for i,v in game:GetService("Players"):GetPlayers() do 
		if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
			local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if playerdistance <= (distance or math.huge) then 
				table.insert(targets, {Human = true, RootPart = v.Character.PrimaryPart, Humanoid = v.Character.Humanoid, Player = v, JumpTick = tick()})
			end
		end
	end
	if sort then 
		table.sort(targets, sort)
	end
	return targets
end

GetGameMap = function()
	for i,v in workspace:GetChildren() do
		if v:FindFirstChild("Map") then
			return v
		end
	end
end

isStarted = function()
	if #lplr.Backpack:GetChildren() > 0 then
		skywars.gameState = 1
	else
		skywars.gameState = 0
	end
end

GetAllOres = function(distance)
	local ores = {}
	for i,v in workspace:GetChildren() do
		if v:FindFirstChild("Map") then
			if isAlive(lplr, true) then
				local distance = (lplr.Character.HumanoidRootPart.Position - v.Map.Ores:FindFirstChild("Block").Position).Magnitude
				if distance < (distance or math.huge) then
					table.insert(ores, {ore = v.Map.Ores:FindFirstChild("Block"), orePos = v.Map.Ores:FindFirstChild("Block").Position})
				end
			end
		end
	end
	return ores
end

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	vapeinjected = false
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
	getgenv().RenderStore = nil
end)

task.spawn(function()
	repeat
		if isStarted() then
			skywars.matchState = 1 
		else
			skywars.matchState = 0
		end
		task.wait()
	until not vapeInjected
end)

local function getSword(char, autoequip, activate)
	local character = char or lplr.Character
	if isStarted() then
		if autoequip then
			lplr.Backpack:FindFirstChild("Sword").Parent = character
		end
		character:WaitForChild("Sword"):Activate()
	end
end

local function getPickaxe(autoequip)
	if isStarted() then
		if autoequip then
			lplr.Backpack:FindFirstChild("Axe").Parent = lplr.Character
		end
		lplr.Character:WaitForChild("Axe"):Activate()
	end
end
--[[
	run(function()
		local oldchar
		local clone
		local Lerp = {Enabled = false}
		local AnticheatBypass = {Enabled = false}
		AnticheatBypass = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
			Name = "AnticheatBypass",
			Function = function(run)
				if run then
					oldchar = lplr.Character
					oldchar.Archivable = true
					clone = oldchar:Clone()
					clone.Name = "playerclone"
					oldchar.PrimaryPart.Anchored = false
					task.spawn(function()
						repeat
							if oldchar.Humanoid.Health == 0 then
								lplr.Character = oldchar
								clone:Remove()
								cam.CameraSubject = lplr.Character
							end
							if Lerp.Enabled and #plrs < 0 then
								tweenService:Create(oldchar.HumanoidRootPart, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = clone.HumanoidRootPart.CFrame}):Play()
								task.wait(0.4)
							elseif not Lerp.Enabled and #plrs < 0 then
								oldchar:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame)
								task.wait(0.4)
							end
						until (not AnticheatBypass.Enabled)
					end)
					cam.CameraSubject = clone.Humanoid 
					clone.Parent = workspace
					lplr.Character = clone
					for i,v in clone:GetChildren() do
						if v:IsA("Part") then
							v.Transparency = 1
						end
					end
				else
					if clone == lplr.Character then
						lplr.Character = oldchar
						clone:Remove()
						cam.CameraSubject = lplr.Character
					end
				end
			end
		})
		Lerp = AnticheatBypass.CreateToggle({
			Name = "Tween",
			Function = function() end
		})
	end)
]]
run(function()
	local TpAura = {Enabled = false}
    local TpAuraDistance = {Value = 30}
    local AutoWin = {Enabled = false}
	TpAura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "TpAura",
		Function = function(run)
			if run then
                task.spawn(function()
                    repeat
                        local plrs = GetAllTargets(TpAuraDistance.Value)
                        if #plrs > 0 then
                            local sword = getSword(lplr, true, true)
                            for i,plr in plrs do
                                lplr.Character.HumanoidRootPart.CFrame = CFrame.new((plr.RootPart.Position + Vector3.new(-2, -5, 0)))
                            end
                        end
                        task.wait(0)
                    until (not TpAura.Enabled)
                end)
			end
		end
	})
    TpAuraDistance = TpAura.CreateSlider({
        Name = "Distance",
        Min = 1,
        Max = 900,
        Function = function(val) end
    })
end)
	
run(function()
	local AutoMine = {Enabled = false}
	AutoMine = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "AutoMine",
		HoverText = "Mine All Nearest Ores",
		Function = function(run)
			if run then
                task.spawn(function()
                    repeat
                        local ores = GetAllOres()
                        if #ores > 0 then
                            local pickaxe = getPickAxe(true)
                            for i,v in ores do
								lplr.Character:WaitForChild("Axe"):Activate()
								lplr.Character.HumanoidRootPart.CFrame = CFrame.new(v.orePos)
								lplr.Character.Axe.RemoteEvent:FireServer(unpack({
									[1] = v
								}))					
                            end
						else
							print("ore not found")
                        end
                        task.wait(0)
                    until (not AutoMine.Enabled)
                end)
			end
		end
	})
end)
