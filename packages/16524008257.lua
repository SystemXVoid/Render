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
local origC0 = nil
local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile('vape/'..scripturl)
	else
		return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/'..scripturl, true)
	end
end
local getrandomvalue = function() return '' end
local InfoNotification = function() end
local GetEnumItems = function() return {} end
local entity = shared.vapeentity
local WhitelistFunctions = shared.vapewhitelist
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local teleportfunc
local betterisfile = function(file)
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

local function GetURL(scripturl)
	if shared.VapeDeveloper then
		return readfile('vape/'..scripturl)
	else
		return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/'..scripturl, true)
	end
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
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

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == 'Client' then
			return tab[i + 1]
		end
	end
	return ''
end

local function getcustomassetfunc(path)
	if not betterisfile(path) then
		task.spawn(function()
			local textlabel = Instance.new('TextLabel')
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = 'Downloading '..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary['MainGui']
			repeat task.wait() until betterisfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = 'https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/'..path:gsub('vape/assets', 'assets'),
			Method = 'GET'
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

GuiLibrary['SelfDestructEvent'].Event:Connect(function()
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
end)

GuiLibrary['RemoveObject']('SilentAimOptionsButton')
GuiLibrary['RemoveObject']('AutoClickerOptionsButton')
GuiLibrary['RemoveObject']('MouseTPOptionsButton')
GuiLibrary['RemoveObject']('ReachOptionsButton')
GuiLibrary['RemoveObject']('HitBoxesOptionsButton')
GuiLibrary['RemoveObject']('KillauraOptionsButton')
GuiLibrary['RemoveObject']('LongJumpOptionsButton')
GuiLibrary['RemoveObject']('HighJumpOptionsButton')
GuiLibrary['RemoveObject']('SafeWalkOptionsButton')
GuiLibrary['RemoveObject']('TriggerBotOptionsButton')
GuiLibrary['RemoveObject']('ClientKickDisablerOptionsButton')

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
	local InfiniteStuff = {Enabled = false}
	local item = {Value = ""}
	InfiniteStuff = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'InfiniteStuff',
		Function = function()
			task.spawn(function()
				repeat
					replicatedStorageService.Remotes.Settings:FireServer(unpack({ 
						[1] = item.Value, 
						[2] = ''..math.huge 
					}))
					task.wait()
				until (not InfiniteStuff.Enabled)
			end)
		end
	})
	item = InfiniteStuff.CreateDropdown({
		Name = "InfiniteStuff",
		List = {"Cash", "SuperRolls", "DoubleLuck", "RollsTilLuck"},
		Function = function() end,
		HoverText = "Select any infinite thing you want"
	})
end)
run(function()
	local nomaxauraLimit = {Enabled = false}
	nomaxauraLimit = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Remove MaxAura Limit",
		Function = function(run)
			if run then
				task.spawn(function()
					replicatedStorageService.Remotes.Settings:FireServer(unpack({ 
						[1] = "MaxAuras", 
						[2] = ''..math.huge 
					}))
				end)
				nomaxauraLimit.ToggleButton()
				InfoNotification("Render", "Inventory Limit Has Been Changed", 5)
			end
		end,
		HoverText = "remove inventory limit :troll:"
	})
end)
run(function()
	local AutoRolls = {Enabled = false}
	local isSuper = {Enabled = false}
	AutoRolls = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "AutoRolls",
		Function = function()
			task.spawn(function()
				repeat
					for i = 1,4 do
						replicatedStorageService.Remotes.Roll:FireServer(isSuper.Enabled)
						replicatedStorageService.Remotes.RollDebounce:FireServer(isSuper.Enabled)
						replicatedStorageService.Remotes.Roll:FireServer(isSuper.Enabled)
						replicatedStorageService.Remotes.RollDebounce:FireServer(isSuper.Enabled)
					end
					task.wait(0)
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
		RenderStore.sessionInfo:addListText('Luck', "Inf")
		print("updated")
		task.wait(5)
	until (not vapeInjected)
end)