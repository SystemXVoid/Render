local GuiLibrary = shared.GuiLibrary
local guilib = GuiLibrary
local identifyexecutor = identifyexecutor or function() return 'Unknown' end
local getconnections = getconnections or function() return {} end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local setclipboard = setclipboard or function(data) writefile('clipboard.txt', data) end
local httpService = game:GetService('HttpService')
local teleportService = game:GetService('TeleportService')
local playersService = game:GetService('Players')
local textService = game:GetService('TextService')
local lightingService = game:GetService('Lighting')
local core = {}
local textChatService = game:GetService('TextChatService')
local inputService = game:GetService('UserInputService')
local runService = game:GetService('RunService')
local replicatedStorageService = game:GetService('ReplicatedStorage')
local repliactedstore = replicatedStorageService
local proximityService = game:GetService('ProximityPromptService')
local debris = game:GetService('Debris')
local HWID = game:GetService('RbxAnalyticsService'):GetClientId()		
local tweenService = game:GetService('TweenService')
local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local vapeConnections = {}
local vapeCachedAssets = {}
local vapeTargetInfo = shared.VapeTargetInfo
local vapeInjected = true
local setidentity = (setthreadcaps or set_thread_caps or set_thread_identity or function() end)
local httprequest = (http and http.request or http_request or fluxus and fluxus.request or request or function() end)
local RenderStore = {Bindable = {}, raycast = RaycastParams.new(), MessageReceived = Instance.new('BindableEvent'), tweens = {}, ping = 0, platform = inputService:GetPlatform(), LocalPosition = Vector3.zero, groundTime = tick(), UpdateGroundTick = function() end, sessionInfo = {labelInstances = {}}, clonedata = {}}
local vec3 = Vector3.new
local vec2 = Vector2.new
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

getgenv().ria = (isfile('ria.ren') and readfile('ria.ren') or nil)
getgenv().RenderStore = RenderStore

if readfile == nil then
	task.spawn(error, 'Render - Exploit not supported. Your exploit doesn\'t have filesystem support.')
	while task.wait() do end
end 

pcall(function() core = game:GetService('CoreGui') end)

for i,v in ({'vape/', 'vape/Render', 'vape/Render/Libraries', 'vape/Render/scripts'}) do 
	if not isfolder(v) then 
		makefolder(v) 
	end
end

local success, res = pcall(function() loadfile('vape/Render/Libraries/renderfunctions.lua')() end) 
if not success then 
	if RenderDeveloper then 
		return assert('RenderFunctions error | '..res)
	end
	local res = game.HttpGet(game, 'https://raw.githubusercontent.com/SystemXVoid/Render/source/Libraries/renderfunctions.lua')
	writefile('vape/Render/Libraries/renderfunctions.lua', res)
	loadstring(res)()
end

table.insert(vapeConnections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA("Camera")
end))

local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

local RenderFunctions = RenderFunctions
local isAlive = function() return false end 
local playSound = function() end
local dumptable = function() return {} end
local sendmessage = function() end
local sendprivatemessage = function() end
local characterDescendant = function() return end
local playerRaycasted = function() return true end
local GetTarget = function() return {} end
local GetAllTargets = function() return {} end
local getnewserver = function() return end
local switchserver = function() end
local GetEnumItems = function() return {} end
local getraypart = function() return {Position = Vector3.zero} end
local getTablePosition = function() return 1 end
local warningNotification = function() end 
local InfoNotification = function() end
local errorNotification = function() end
local newcolor = function() return {Hue = 0, Sat = 0, Value = 0} end

local networkownerswitch = tick()
local isnetworkowner = function(part)
	local suc, res = pcall(function() return gethiddenproperty(part, "NetworkOwnershipRule") end)
	if suc and res == Enum.NetworkOwnership.Manual then
		sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
		networkownerswitch = tick() + 8
	end
	return networkownerswitch <= tick()
end
local vapeAssetTable = {["vape/assets/VapeCape.png"] = "rbxassetid://13380453812", ["vape/assets/ArrowIndicator.png"] = "rbxassetid://13350766521"}
local getcustomasset = getsynasset or getcustomasset or function(location) return vapeAssetTable[location] or "" end
local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local synapsev3 = syn and syn.toast_notification and "V3" or ""
local worldtoscreenpoint = function(pos)
	if synapsev3 == "V3" then
		local scr = worldtoscreen({pos})
		return scr[1] - Vector3.new(0, 36, 0), scr[1].Z > 0
	end
	return gameCamera.WorldToScreenPoint(gameCamera, pos)
end
local worldtoviewportpoint = function(pos)
	if synapsev3 == "V3" then
		local scr = worldtoscreen({pos})
		return scr[1], scr[1].Z > 0
	end
	return gameCamera.WorldToViewportPoint(gameCamera, pos)
end

local function vapeGithubRequest(scripturl)
	if not isfile("vape/"..scripturl) then
		local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
		assert(suc, res)
		assert(res ~= "404: Not Found", res)
		if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
		writefile("vape/"..scripturl, res)
	end
	return readfile("vape/"..scripturl)
end

local function downloadVapeAsset(path)
	if not isfile(path) then
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary.MainGui
			repeat task.wait() until isfile(path)
			textlabel:Destroy()
		end)
		local suc, req = pcall(function() return vapeGithubRequest(path:gsub("vape/assets", "assets")) end)
        if suc and req then
		    writefile(path, req)
        else
            return ""
        end
	end
	if not vapeCachedAssets[path] then vapeCachedAssets[path] = getcustomasset(path) end
	return vapeCachedAssets[path]
end

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

local function removeTags(str)
	str = str:gsub("<br%s*/>", "\n")
	return (str:gsub("<[^<>]->", ""))
end

local function run(func) setidentity(8) func() end
local runFunction = run

local function isFriend(plr, recolor)
	if GuiLibrary.ObjectsThatCanBeSaved["Use FriendsToggle"].Api.Enabled then
		local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectList, plr.Name)
		friend = friend and GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.ObjectListEnabled[friend]
		if recolor then
			friend = friend and GuiLibrary.ObjectsThatCanBeSaved["Recolor visualsToggle"].Api.Enabled
		end
		return friend
	end
end

local function isTarget(plr)
	local friend = table.find(GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectList, plr.Name)
	friend = friend and GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList.Api.ObjectListEnabled[friend]
	return friend
end

local function isVulnerable(plr)
	return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField")
end

local function getPlayerColor(plr)
	if isFriend(plr, true) then
		return Color3.fromHSV(GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Hue, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Sat, GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"].Api.Value)
	end
	return tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color
end

local function isEnabled(module)
	return GuiLibrary.ObjectsThatCanBeSaved[module] and GuiLibrary.ObjectsThatCanBeSaved[module].Api.Enabled and true or false
end

task.spawn(function()
	local function chatfunc(plr)
		table.insert(vapeConnections, plr.Chatted:Connect(function(message)
			RenderStore.MessageReceived:Fire(plr, message)
		end))
	end
	table.insert(vapeConnections, textChatService.MessageReceived:Connect(function(data)
		local success, player = pcall(function() 
			return playersService:GetPlayerByUserId(data.TextSource.UserId) 
		end)
		if success then 
			RenderStore.MessageReceived:Fire(player, data.Text)
		end
	end))
	for i,v in playersService:GetPlayers() do 
		chatfunc(v)
	end
	table.insert(vapeConnections, playersService.PlayerAdded:Connect(chatfunc))
end)

getTablePosition = function(tab, val, first)
	local count = 0
	for i,v in tab do
		count += 1 
		if (first and i or v) == val then 
			break
		end
	end
	return count
end

getraypart = function(player)
	if not isAlive(player, true) then 
		return
	end
	local foot = (player.Character:FindFirstChild('LeftFoot') or lplr.Character:FindFirstChild('RightFoot'))
	local lowertorso = player.Character:FindFirstChild('LowerTorso')
	if foot then 
		return foot 
	end
	for i,v in next, player.Character:GetChildren() do 
		if v.Name:find('Leg') then 
			return v 
		end
	end
	if lowertorso then 
		return lowertorso 
	end
	return player.Character.HumanoidRootPart
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

playSound = function(soundID, loop)
	soundID = (soundID or ''):gsub('rbxassetid://', '')
	local sound = Instance.new('Sound')
	sound.Looped = loop and true or false
	sound.Parent = workspace
	sound.SoundId = 'rbxassetid://'..soundID
	sound:Play()
	sound.Ended:Connect(function() sound:Destroy() end)
	return sound
end

dumptable = function(tab, tabtype, sortfunction)
	local data = {}
	for i,v in next, (tab) do
		local tabtype = tabtype and tabtype == 1 and i or v
		table.insert(data, tabtype)
	end
	if sortfunction and type(sortfunction) == 'function' then
		table.sort(data, sortfunction)
	end
	return data
end

playerRaycasted = function(plr, customvector)
	plr = plr or lplr
	return workspace:Raycast(getraypart(plr).Position, customvector or Vector3.new(0, -10000, 0), RenderStore.objectraycast)
end

GetTarget = function(distance, healthmethod, raycast, npc, team)
	local magnitude, target = (distance or healthmethod and 0 or math.huge), {}
	for i,v in playersService:GetPlayers() do 
		if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
			if not RenderFunctions.whitelist:get(2) then 
				continue
			end
			if not ({shared.vapewhitelist:GetWhitelist(v)})[2] then
				continue
			end
			if not shared.vapeentity.isPlayerTargetable(v) then 
				continue
			end
			if not playerRaycasted(v) and raycast then 
				continue
			end
			if healthmethod and v.Character.Humanoid.Health < magnitude then 
				magnitude = v.Character.Humanoid.Health
				target.Human = true
				target.RootPart = v.Character.HumanoidRootPart
				target.Humanoid = v.Character.Humanoid
				target.Player = v
				continue
			end 
			local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if playerdistance < magnitude then 
				magnitude = playerdistance
				target.Human = true
				target.RootPart = v.Character.HumanoidRootPart
				target.Humanoid = v.Character.Humanoid
				target.Player = v
			end
		end
	end
	return target
end

characterDescendant = function(object)
	for i,v in playersService:GetPlayers() do 
		if v.Character and object:IsDescendantOf(v.Character) then 
			return v 
		end
	end
end

GetAllTargets = function(distance, sort)
	local targets = {}
	for i,v in playersService:GetPlayers() do 
		if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
			if not RenderFunctions.whitelist:get(2) then 
				continue
			end
			if not ({whitelist:GetWhitelist(v)})[2] then 
				continue
			end
			if not entityLibrary.isPlayerTargetable(v) then 
				continue
			end
			local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if playerdistance <= (distance or math.huge) then 
				table.insert(targets, {Human = true, RootPart = v.Character.PrimaryPart, Humanoid = v.Character.Humanoid, Player = v})
			end
		end
	end
	if sort then 
		table.sort(targets, sort)
	end
	return targets
end

GetEnumItems = function(enum)
	local fonts = {}
	for i,v in next, Enum[enum]:GetEnumItems() do 
		table.insert(fonts, v.Name) 
	end
	return fonts
end

getnewserver = function(customgame, popular, performance)
	local players, server = 0, nil
	local success, serverTable = pcall(function() return httpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/'..(customgame or game.PlaceId)..'/servers/Public?sortOrder=Asc&limit=100', true)) end)
	if success and type(serverTable) == 'table' and type(serverTable.data) == 'table' then 
		for i,v in serverTable.data do 
			if v.id and v.playing and v.maxPlayers and tonumber(v.maxPlayers) > tonumber(v.playing) and tonumber(v.playing) > 0 then 
				if v.id == tostring(game.JobId) then 
					continue 
				end
				if tonumber(v.playing) < players and popular then 
					continue
				end
				if performance and v.ping and tonumber(v.ping) > 170 then
					continue
				end
				players = tonumber(v.playing)
				server = v.id
			end
		end
	end
	return server
end

switchserver = function(onfound)
	local server 
	onfound = onfound or function() end
	repeat server = getnewserver() task.wait() until server
	task.spawn(onfound, server)
	game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, server, lplr)
end

sendmessage = function(text)
	if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(text)
	else
		replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, 'All')
	end
end

sendprivatemessage = function(player, text)
	if player then
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			local oldchannel = textChatService.ChatInputBarConfiguration.TargetTextChannel
			local whisperchannel = game:GetService('RobloxReplicatedStorage').ExperienceChat.WhisperChat:InvokeServer(player.UserId)
			if whisperchannel then
				whisperchannel:SendAsync(text)
				textChatService.ChatInputBarConfiguration.TargetTextChannel = oldchannel
			end
		else
			replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('/w '..player.Name.." "..text, 'All')
		end
	end
end

local whitelist = {data = {WhitelistedUsers = {}}, hashes = {}, said = {}, alreadychecked = {}, customtags = {}, loaded = false, localprio = 0, hooked = false, get = function() return 0, true end}
local WhitelistFunctions = whitelist
local entityLibrary = loadstring(vapeGithubRequest("Libraries/entityHandler.lua"))()
shared.vapeentity = entityLibrary
do
	entityLibrary.selfDestruct()
	table.insert(vapeConnections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendRefresh.Event:Connect(function()
		entityLibrary.fullEntityRefresh()
	end))
	table.insert(vapeConnections, GuiLibrary.ObjectsThatCanBeSaved["Teams by colorToggle"].Api.Refresh.Event:Connect(function()
		entityLibrary.fullEntityRefresh()
	end))
	local oldUpdateBehavior = entityLibrary.getUpdateConnections
	entityLibrary.getUpdateConnections = function(newEntity)
		local oldUpdateConnections = oldUpdateBehavior(newEntity)
		table.insert(oldUpdateConnections, {Connect = function()
			newEntity.Friend = isFriend(newEntity.Player) and true
			newEntity.Target = isTarget(newEntity.Player) and true
			return {Disconnect = function() end}
		end})
		return oldUpdateConnections
	end
	entityLibrary.isPlayerTargetable = function(plr)
		if isFriend(plr) then return false end
		if not ({whitelist:get(plr)})[2] then return false end
		if (not GuiLibrary.ObjectsThatCanBeSaved["Teams by colorToggle"].Api.Enabled) then return true end
		if (not lplr.Team) then return true end
		if (not plr.Team) then return true end
		if plr.Team ~= lplr.Team then return true end
        return #plr.Team:GetPlayers() == playersService.NumPlayers
	end
	entityLibrary.fullEntityRefresh()
	entityLibrary.LocalPosition = Vector3.zero

	task.spawn(function()
		local postable = {}
		repeat
			task.wait()
			if isAlive(lplr, true) then
				table.insert(postable, {Time = tick(), Position = lplr.Character.HumanoidRootPart.Position})
				if #postable > 100 then
					table.remove(postable, 1)
				end
				local closestmag = 9e9
				local closestpos = lplr.Character.HumanoidRootPart.Position
				local currenttime = tick()
				for i, v in pairs(postable) do
					local mag = 0.1 - (currenttime - v.Time)
					if mag < closestmag and mag > 0 then
						closestmag = mag
						closestpos = v.Position
					end
				end
				entityLibrary.LocalPosition = closestpos
			end
		until not vapeInjected
	end)
end

local function calculateMoveVector(cameraRelativeMoveVector)
	local c, s
	local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = gameCamera.CFrame:GetComponents()
	if R12 < 1 and R12 > -1 then
		c = R22
		s = R02
	else
		c = R00
		s = -R01*math.sign(R12)
	end
	local norm = math.sqrt(c*c + s*s)
	return Vector3.new(
		(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
		0,
		(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
	)
end

local raycastWallProperties = RaycastParams.new()
local function raycastWallCheck(char, checktable)
	if not checktable.IgnoreObject then
		checktable.IgnoreObject = raycastWallProperties
		local filter = {lplr.Character, gameCamera}
		for i,v in pairs(entityLibrary.entityList) do
			if v.Targetable then
				table.insert(filter, v.Character)
			end
		end
		for i,v in pairs(checktable.IgnoreTable or {}) do
			table.insert(filter, v)
		end
		raycastWallProperties.FilterDescendantsInstances = filter
	end
	local ray = workspace.Raycast(workspace, checktable.Origin, (char[checktable.AimPart].Position - checktable.Origin), checktable.IgnoreObject)
	return not ray
end

local function EntityNearPosition(distance, checktab)
	checktab = checktab or {}
	if isAlive(lplr, true) then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do -- loop through playersService
			if not v.Targetable then continue end
            if isVulnerable(v) then -- checks
				local playerPosition = v.RootPart.Position
				local mag = (lplr.Character.HumanoidRootPart.Position - playerPosition).magnitude
				if checktab.Prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then -- mag check
					table.insert(sortedentities, {entity = v, Magnitude = v.Target and -1 or mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i, v in pairs(sortedentities) do
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			return v.entity
		end
	end
end

local function EntityNearMouse(distance, checktab)
	checktab = checktab or {}
    if isAlive(lplr, true) then
		local sortedentities = {}
		local mousepos = inputService.GetMouseLocation(inputService)
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local vec, vis = worldtoscreenpoint(v[checktab.AimPart].Position)
				local mag = (mousepos - Vector2.new(vec.X, vec.Y)).magnitude
                if vis and mag <= distance then
					table.insert(sortedentities, {entity = v, Magnitude = v.Target and -1 or mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i, v in pairs(sortedentities) do
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			return v.entity
		end
    end
end

local function AllNearPosition(distance, amount, checktab)
	local returnedplayer = {}
	local currentamount = 0
	checktab = checktab or {}
    if isAlive(lplr, true) then
		local sortedentities = {}
		for i, v in pairs(entityLibrary.entityList) do
			if not v.Targetable then continue end
            if isVulnerable(v) then
				local playerPosition = v.RootPart.Position
				local mag = (lplr.Character.HumanoidRootPart.Position - playerPosition).magnitude
				if checktab.Prediction and mag > distance then
					mag = (entityLibrary.LocalPosition - playerPosition).magnitude
				end
                if mag <= distance then
					table.insert(sortedentities, {entity = v, Magnitude = mag})
                end
            end
        end
		table.sort(sortedentities, function(a, b) return a.Magnitude < b.Magnitude end)
		for i,v in pairs(sortedentities) do
			if checktab.WallCheck then
				if not raycastWallCheck(v.entity, checktab) then continue end
			end
			table.insert(returnedplayer, v.entity)
			currentamount = currentamount + 1
			if currentamount >= amount then break end
		end
	end
	return returnedplayer
end

local sha = loadstring(vapeGithubRequest("Libraries/sha.lua"))()
run(function()
	local olduninject
	function whitelist:get(plr)
		local plrstr = self:hash(plr.Name..plr.UserId)
		for i,v in self.data.WhitelistedUsers do
			if v.hash == plrstr then
				return v.level, v.attackable or whitelist.localprio >= v.level, v.tags
			end
		end
		return 0, true
	end

	function whitelist:isingame()
		for i, v in playersService:GetPlayers() do
			if self:get(v) ~= 0 then
				return true
			end
		end
		return false
	end

	function whitelist:tag(plr, text, rich)
		local plrtag = ({self:get(plr)})[3] or self.customtags[plr.Name] or {}
		if not text then return plrtag end
		local newtag = ''
		for i, v in plrtag do
			newtag = newtag..(rich and '<font color="#'..v.color:ToHex()..'">['..v.text..']</font>' or '['..removeTags(v.text)..']')..' '
		end
		return newtag
	end

	function whitelist:hash(str)
		if self.hashes[str] == nil and sha then
			self.hashes[str] = sha.sha512(str..'SelfReport')
		end
		return self.hashes[str] or ''
	end

	function whitelist:getplayer(arg)
		if arg == 'default' and self.localprio == 0 then return true end
		if arg == 'private' and self.localprio == 1 then return true end
		if arg and lplr.Name:lower():sub(1, arg:len()) == arg:lower() then return true end
		return false
	end

	function whitelist:playeradded(v, joined)
		if self:get(v) ~= 0 then
			if self.alreadychecked[v.UserId] then return end
			self.alreadychecked[v.UserId] = true
			self:hook()
			if self.localprio == 0 then
				olduninject = GuiLibrary.SelfDestruct
				GuiLibrary.SelfDestruct = function() warningNotification('Vape', 'No escaping the private members :)', 10) end
				if joined then task.wait(10) end
				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
					local oldchannel = textChatService.ChatInputBarConfiguration.TargetTextChannel
					local newchannel = cloneref(game:GetService('RobloxReplicatedStorage')).ExperienceChat.WhisperChat:InvokeServer(v.UserId)
					if newchannel then newchannel:SendAsync('helloimusinginhaler') end
					textChatService.ChatInputBarConfiguration.TargetTextChannel = oldchannel
				elseif replicatedStorageService:FindFirstChild('DefaultChatSystemChatEvents') then
					replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('/w '..v.Name..' helloimusinginhaler', 'All')
				end
			end
		end
	end

	function whitelist:checkmessage(msg, plr)
		local otherprio = self:get(plr)
		if plr == lplr and msg == 'helloimusinginhaler' then return true end
		if self.localprio > 0 and self.said[plr.Name] == nil and msg == 'helloimusinginhaler' and plr ~= lplr then
			self.said[plr.Name] = true
			notif('Vape', plr.Name..' is using vape!', 60)
			self.customtags[plr.Name] = {{text = 'VAPE USER', color = Color3.new(1, 1, 0)}}
			local newent = entityLibrary.getEntity(plr)
			if newent then entityLibrary.Events.EntityUpdated:Fire(newent) end
			return true
		end
		if self.localprio < otherprio or plr == lplr then
			local args = msg:split(' ')
			table.remove(args, 1)
			if self:getplayer(args[1]) then
				table.remove(args, 1)
				for i,v in self.commands do
					if msg:len() >= (i:len() + 1) and msg:sub(1, i:len() + 1):lower() == ";"..i:lower() then
						v(plr, args)
						return true
					end
				end
			end
		end
		return false
	end

	function whitelist:newchat(obj, plr, skip)
		obj.Text = self:tag(plr, true, true)..obj.Text
		local sub = obj.ContentText:find(': ')
		if sub then
			if not skip and self:checkmessage(obj.ContentText:sub(sub + 3, #obj.ContentText), plr) then
				obj.Visible = false
			end
		end
	end

	function whitelist:oldchat(func)
		local msgtable = debug.getupvalue(func, 3)
		if typeof(msgtable) == 'table' and msgtable.CurrentChannel then
			whitelist.oldchattable = msgtable
		end
		local oldchat

		oldchat = hookfunction(func, function(data, ...)
			local plr = playersService:GetPlayerByUserId(data.SpeakerUserId)
			if plr then
				data.ExtraData.Tags = data.ExtraData.Tags or {}
				for i, v in self:tag(plr) do
					table.insert(data.ExtraData.Tags, {TagText = v.text, TagColor = v.color})
				end
				if data.Message and self:checkmessage(data.Message, plr) then data.Message = '' end
			end
			return oldchat(data, ...)
		end)
		table.insert(vapeConnections, {Disconnect = function() hookfunction(func, oldchat) end})
	end

	function whitelist:hook()
		if self.hooked then return end
		self.hooked = true
		local exp = coreGui:FindFirstChild('ExperienceChat')
		if exp then
			local bubblechat = exp:WaitForChild('bubbleChat', 5)
			if bubblechat then
				table.insert(vapeConnections, bubblechat.DescendantAdded:Connect(function(newbubble)
					if newbubble:IsA('TextLabel') and newbubble.Text:find('helloimusinginhaler') then
						newbubble.Parent.Parent.Visible = false
					end
				end))
			end
		end
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			if exp then
				table.insert(vapeConnections, exp:FindFirstChild('RCTScrollContentView', true).ChildAdded:Connect(function(obj)
					local plr = playersService:GetPlayerByUserId(tonumber(obj.Name:split('-')[1]) or 0)
					obj = obj:FindFirstChild('TextMessage', true)
					if obj then
						if plr then
							self:newchat(obj, plr, true)
							obj:GetPropertyChangedSignal('Text'):Wait()
							self:newchat(obj, plr)
						end
						if obj.ContentText:sub(1, 35) == 'You are now privately chatting with' then
							obj.Visible = false
						end
					end
				end))
			end
		elseif replicatedStorageService:FindFirstChild('DefaultChatSystemChatEvents') then
			pcall(function()
				for i, v in getconnections(replicatedStorageService.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent) do
					if v.Function and table.find(debug.getconstants(v.Function), 'UpdateMessagePostedInChannel') then
						whitelist:oldchat(v.Function)
						break
					end
				end
				for i, v in getconnections(replicatedStorageService.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent) do
					if v.Function and table.find(debug.getconstants(v.Function), 'UpdateMessageFiltered') then
						whitelist:oldchat(v.Function)
						break
					end
				end
			end)
		end
	end

	function whitelist:check(first)
		local whitelistloaded, err = pcall(function()
			local _, subbed = pcall(function() return game:HttpGet('https://github.com/7GrandDadPGN/whitelists'):sub(100000, 160000) end)
			local commit = subbed:find('spoofed_commit_check')
			commit = commit and subbed:sub(commit + 21, commit + 60) or nil
			commit = commit and #commit == 40 and commit or 'main'
			whitelist.textdata = game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/whitelists/'..commit..'/PlayerWhitelist.json', true)
		end)
		if not whitelistloaded or not sha or not whitelist.get then return true end
		whitelist.loaded = true
		if not first or whitelist.textdata ~= whitelist.olddata then
			if not first then
				whitelist.olddata = isfile('vape/profiles/whitelist.json') and readfile('vape/profiles/whitelist.json') or nil
			end
			whitelist.data = game:GetService('HttpService'):JSONDecode(whitelist.textdata)
			whitelist.localprio = whitelist:get(lplr)

			for i, v in whitelist.data.WhitelistedUsers do
				if v.tags then
					for i2, v2 in v.tags do
						v2.color = Color3.fromRGB(unpack(v2.color))
					end
				end
			end

			for i, v in playersService:GetPlayers() do whitelist:playeradded(v) end
			if not whitelist.connection then
				whitelist.connection = playersService.PlayerAdded:Connect(function(v) whitelist:playeradded(v, true) end)
			end
			if (entityLibrary.isAlive or #entityLibrary.entityList > 0) then
				entityLibrary.fullEntityRefresh()
			end

			if whitelist.textdata ~= whitelist.olddata then
				if whitelist.data.Announcement.expiretime > os.time() then
					local targets = whitelist.data.Announcement.targets == 'all' and {tostring(lplr.UserId)} or targets:split(',')
					if table.find(targets, tostring(lplr.UserId)) then
						local hint = Instance.new('Hint')
						hint.Text = 'VAPE ANNOUNCEMENT: '..whitelist.data.Announcement.text
						hint.Parent = workspace
						game:GetService('Debris'):AddItem(hint, 20)
					end
				end
				whitelist.olddata = whitelist.textdata
				pcall(function() writefile('vape/profiles/whitelist.json', whitelist.textdata) end)
			end

			if whitelist.data.KillVape then
				GuiLibrary.SelfDestruct()
				return true
			end

			if whitelist.data.BlacklistedUsers[tostring(lplr.UserId)] then
				task.spawn(lplr.kick, lplr, whitelist.data.BlacklistedUsers[tostring(lplr.UserId)])
				return true
			end
		end
	end

	whitelist.commands = {
		byfron = function()
			task.spawn(function()
				if setthreadidentity then setthreadidentity(8) end
				if setthreadcaps then setthreadcaps(8) end
				local UIBlox = getrenv().require(game:GetService('CorePackages').UIBlox)
				local Roact = getrenv().require(game:GetService('CorePackages').Roact)
				UIBlox.init(getrenv().require(game:GetService('CorePackages').Workspace.Packages.RobloxAppUIBloxConfig))
				local auth = getrenv().require(coreGui.RobloxGui.Modules.LuaApp.Components.Moderation.ModerationPrompt)
				local darktheme = getrenv().require(game:GetService('CorePackages').Workspace.Packages.Style).Themes.DarkTheme
				local gotham = getrenv().require(game:GetService('CorePackages').Workspace.Packages.Style).Fonts.Gotham
				local tLocalization = getrenv().require(game:GetService('CorePackages').Workspace.Packages.RobloxAppLocales).Localization
				local a = getrenv().require(game:GetService('CorePackages').Workspace.Packages.Localization).LocalizationProvider
				lplr.PlayerGui:ClearAllChildren()
				GuiLibrary.MainGui.Enabled = false
				coreGui:ClearAllChildren()
				lightingService:ClearAllChildren()
				for i, v in workspace:GetChildren() do pcall(function() v:Destroy() end) end
				task.wait(0.2)
				lplr.kick(lplr)
				game:GetService('GuiService'):ClearError()
				task.wait(2)
				local gui = Instance.new('ScreenGui')
				gui.IgnoreGuiInset = true
				gui.Parent = coreGui
				local frame = Instance.new('ImageLabel')
				frame.BorderSizePixel = 0
				frame.Size = UDim2.fromScale(1, 1)
				frame.BackgroundColor3 = Color3.new(1, 1, 1)
				frame.ScaleType = Enum.ScaleType.Crop
				frame.Parent = gui
				task.delay(0.1, function() frame.Image = 'rbxasset://textures/ui/LuaApp/graphic/Auth/GridBackground.jpg' end)
				task.delay(2, function()
					local e = Roact.createElement(auth, {
						style = {},
						screenSize = gameCamera.ViewportSize or Vector2.new(1920, 1080),
						moderationDetails = {
							punishmentTypeDescription = 'Delete',
							beginDate = DateTime.fromUnixTimestampMillis(DateTime.now().UnixTimestampMillis - ((60 * math.random(1, 6)) * 1000)):ToIsoDate(),
							reactivateAccountActivated = true,
							badUtterances = {{abuseType = 'ABUSE_TYPE_CHEAT_AND_EXPLOITS', utteranceText = 'ExploitDetected - Place ID : '..game.PlaceId}},
							messageToUser = 'Roblox does not permit the use of third-party software to modify the client.'
						},
						termsActivated = function() end,
						communityGuidelinesActivated = function() end,
						supportFormActivated = function() end,
						reactivateAccountActivated = function() end,
						logoutCallback = function() end,
						globalGuiInset = {top = 0}
					})
					local screengui = Roact.createElement('ScreenGui', {}, Roact.createElement(a, {
							localization = tLocalization.new('en-us')
						}, {Roact.createElement(UIBlox.Style.Provider, {
								style = {
									Theme = darktheme,
									Font = gotham
								},
							}, {e})}))
					Roact.mount(screengui, coreGui)
				end)
			end)
		end,
		crash = function()
			task.spawn(setfpscap, 9e9)
			task.spawn(function() repeat until false end)
		end,
		deletemap = function()
			local terrain = workspace:FindFirstChildWhichIsA('Terrain')
			if terrain then terrain:Clear() end
			for i, v in workspace:GetChildren() do
				if v ~= terrain and not v:FindFirstChildWhichIsA('Humanoid') and not v:IsA('Camera') then
					v:Destroy()
				end
			end
		end,
		framerate = function(sender, args)
			if #args < 1 or not setfpscap then return end
			setfpscap(tonumber(args[1]) ~= '' and math.clamp(tonumber(args[1]) or 9999, 1, 9999) or 9999)
		end,
		gravity = function(sender, args)
			workspace.Gravity = tonumber(args[1]) or workspace.Gravity
		end,
		jump = function()
			if entityLibrary.isAlive and entityLibrary.character.Humanoid.FloorMaterial ~= Enum.Material.Air then
				entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end,
		kick = function(sender, args)
			task.spawn(function() lplr:Kick(table.concat(args, ' ')) end)
		end,
		kill = function()
			if entityLibrary.isAlive then
				entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				entityLibrary.character.Humanoid.Health = 0
			end
		end,
		reveal = function(args)
			task.delay(0.1, function()
				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('I am using the inhaler client')
                else
                    replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('I am using the inhaler client', 'All')
                end
			end)
		end,
		shutdown = function()
			game:Shutdown()
		end,
		toggle = function(sender, args)
			if #args < 1 then return end
			if args[1]:lower() == 'all' then
				for i, v in GuiLibrary.ObjectsThatCanBeSaved do
					local newname = i:gsub('OptionsButton', '')
					if v.Type == "OptionsButton" and newname ~= 'Panic' then
						v.Api.ToggleButton()
					end
				end
			else
				for i, v in GuiLibrary.ObjectsThatCanBeSaved do
					local newname = i:gsub('OptionsButton', '')
					if v.Type == "OptionsButton" and newname:lower() == args[1]:lower() then
						v.Api.ToggleButton()
						break
					end
				end
			end
		end,
		trip = function()
			if entityLibrary.isAlive then
				entityLibrary.character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
			end
		end,
		uninject = function()
			if olduninject then
				olduninject(vape)
			else
				GuiLibrary.SelfDestruct()
			end
		end,
		void = function()
			if entityLibrary.isAlive then
				entityLibrary.character.HumanoidRootPart.CFrame = entityLibrary.character.HumanoidRootPart.CFrame + Vector3.new(0, -1000, 0)
			end
		end
	}

	task.spawn(function()
		repeat
			if whitelist:check(whitelist.loaded) then return end
			task.wait(10)
		until shared.VapeInjected == nil
	end)
	table.insert(vapeConnections, {Disconnect = function()
		if whitelist.connection then whitelist.connection:Disconnect() end
		table.clear(whitelist.commands)
		table.clear(whitelist.data)
		table.clear(whitelist)
	end})
end)

whitelist.GetWhitelist = whitelist.get
shared.vapewhitelist = whitelist

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, func)
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

	function RunLoops:BindToStepped(name, func)
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

	function RunLoops:BindToHeartbeat(name, func)
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

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	vapeInjected = false
	entityLibrary.selfDestruct()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)

run(function()
	local radargameCamera = Instance.new("Camera")
	radargameCamera.FieldOfView = 45
	local Radar = GuiLibrary.CreateCustomWindow({
		Name = "Radar",
		Icon = "vape/assets/RadarIcon1.png",
		IconSize = 16
	})
	local RadarColor = Radar.CreateColorSlider({
		Name = "Player Color",
		Function = function(val) end
	})
	local RadarFrame = Instance.new("Frame")
	RadarFrame.BackgroundColor3 = Color3.new()
	RadarFrame.BorderSizePixel = 0
	RadarFrame.BackgroundTransparency = 0.5
	RadarFrame.Size = UDim2.new(0, 250, 0, 250)
	RadarFrame.Parent = Radar.GetCustomChildren()
	local RadarBorder1 = RadarFrame:Clone()
	RadarBorder1.Size = UDim2.new(0, 6, 0, 250)
	RadarBorder1.Parent = RadarFrame
	local RadarBorder2 = RadarBorder1:Clone()
	RadarBorder2.Position = UDim2.new(0, 6, 0, 0)
	RadarBorder2.Size = UDim2.new(0, 238, 0, 6)
	RadarBorder2.Parent = RadarFrame
	local RadarBorder3 = RadarBorder1:Clone()
	RadarBorder3.Position = UDim2.new(1, -6, 0, 0)
	RadarBorder3.Size = UDim2.new(0, 6, 0, 250)
	RadarBorder3.Parent = RadarFrame
	local RadarBorder4 = RadarBorder1:Clone()
	RadarBorder4.Position = UDim2.new(0, 6, 1, -6)
	RadarBorder4.Size = UDim2.new(0, 238, 0, 6)
	RadarBorder4.Parent = RadarFrame
	local RadarBorder5 = RadarBorder1:Clone()
	RadarBorder5.Position = UDim2.new(0, 0, 0.5, -1)
	RadarBorder5.BackgroundColor3 = Color3.new(1, 1, 1)
	RadarBorder5.Size = UDim2.new(0, 250, 0, 2)
	RadarBorder5.Parent = RadarFrame
	local RadarBorder6 = RadarBorder1:Clone()
	RadarBorder6.Position = UDim2.new(0.5, -1, 0, 0)
	RadarBorder6.BackgroundColor3 = Color3.new(1, 1, 1)
	RadarBorder6.Size = UDim2.new(0, 2, 0, 124)
	RadarBorder6.Parent = RadarFrame
	local RadarBorder7 = RadarBorder1:Clone()
	RadarBorder7.Position = UDim2.new(0.5, -1, 0, 126)
	RadarBorder7.BackgroundColor3 = Color3.new(1, 1, 1)
	RadarBorder7.Size = UDim2.new(0, 2, 0, 124)
	RadarBorder7.Parent = RadarFrame
	local RadarMainFrame = Instance.new("Frame")
	RadarMainFrame.BackgroundTransparency = 1
	RadarMainFrame.Size = UDim2.new(0, 250, 0, 250)
	RadarMainFrame.Parent = RadarFrame
	local radartable = {}
	table.insert(vapeConnections, Radar.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):Connect(function()
		RadarFrame.Position = UDim2.new(0, 0, 0, (Radar.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
	end))
	GuiLibrary.ObjectsThatCanBeSaved.GUIWindow.Api.CreateCustomToggle({
		Name = "Radar",
		Icon = "vape/assets/RadarIcon2.png",
		Function = function(callback)
			Radar.SetVisible(callback)
			if callback then
				RunLoops:BindToRenderStep("Radar", function()
					if isAlive(lplr, true) then
						local v278 = (CFrame.new(0, 0, 0):inverse() * lplr.Character.HumanoidRootPart.CFrame).p * 0.2 * Vector3.new(1, 1, 1);
						local v279, v280, v281 = gameCamera.CFrame:ToOrientation();
						local u90 = v280 * 180 / math.pi;
						local v277 = 0 - u90;
						local v276 = v278 + Vector3.zero;
						radargameCamera.CFrame = CFrame.new(v276 + Vector3.new(0, 50, 0)) * CFrame.Angles(0, -v277 * (math.pi / 180), 0) * CFrame.Angles(-90 * (math.pi / 180), 0, 0)
						local done = {}
						for i, plr in pairs(entityLibrary.entityList) do
							table.insert(done, plr)
							local thing
							if radartable[plr] then
								thing = radartable[plr]
								if thing.Visible then
									thing.Visible = false
								end
							else
								thing = Instance.new("Frame")
								thing.BackgroundTransparency = 0
								thing.Size = UDim2.new(0, 4, 0, 4)
								thing.BorderSizePixel = 1
								thing.BorderColor3 = Color3.new()
								thing.BackgroundColor3 = Color3.new()
								thing.Visible = false
								thing.Name = plr.Player.Name
								thing.Parent = RadarMainFrame
								radartable[plr] = thing
							end

							local v238, v239 = radargameCamera:WorldToViewportPoint((CFrame.new(0, 0, 0):inverse() * plr.RootPart.CFrame).p * 0.2)
							thing.Visible = true
							thing.BackgroundColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(RadarColor.Value, 1, 1)
							thing.Position = UDim2.new(math.clamp(v238.X, 0.03, 0.97), -2, math.clamp(v238.Y, 0.03, 0.97), -2)
						end
						for i, v in pairs(radartable) do
							if not table.find(done, i) then
								radartable[i] = nil
								v:Destroy()
							end
						end
					end
				end)
			else
				RunLoops:UnbindFromRenderStep("Radar")
				RadarMainFrame:ClearAllChildren()
				table.clear(radartable)
			end
		end,
		Priority = 1
	})
end)

run(function()
	local SilentAimSmartWallTable = {}
	local SilentAim = {Enabled = false}
	local SilentAimFOV = {Value = 1}
	local SilentAimMode = {Value = "Legit"}
	local SilentAimMethod = {Value = "FindPartOnRayWithIgnoreList"}
	local SilentAimRaycastMode = {Value = "Whitelist"}
	local SilentAimCircleToggle = {Enabled = false}
	local SilentAimCircleColor = {Value = 0.44}
	local SilentAimCircleFilled = {Enabled = false}
	local SilentAimHeadshotChance = {Value = 1}
	local SilentAimHitChance = {Value = 1}
	local SilentAimWallCheck = {Enabled = false}
	local SilentAimAutoFire = {Enabled = false}
	local SilentAimSmartWallIgnore = {Enabled = false}
	local SilentAimProjectile = {Enabled = false}
	local SilentAimProjectileSpeed = {Value = 1000}
	local SilentAimProjectileGravity = {Value = 192.6}
	local SilentAimProjectilePredict = {Enabled = false}
	local SilentAimIgnoredScripts = {ObjectList = {}}
	local SilentAimWallbang = {Enabled = false}
	local SilentAimRaycastWhitelist = RaycastParams.new()
	SilentAimRaycastWhitelist.FilterType = Enum.RaycastFilterType.Whitelist
	local SlientAimShotTick = tick()
	local SilentAimFilterObject = synapsev3 == "V3" and AllFilter.new({NamecallFilter.new(SilentAimMethod.Value), CallerFilter.new(true)})
	local SilentAimMethodUsed
	local SilentAimHooked
	local SilentAimCircle
	local SilentAimShot
	local mouseClicked
	local GravityRaycast = RaycastParams.new()
	GravityRaycast.RespectCanCollide = true

	local function predictGravity(pos, vel, mag, targetPart, Gravity)
		local newVelocity = vel.Y
		GravityRaycast.FilterDescendantsInstances = {targetPart.Character}
		local rootSize = (targetPart.Humanoid.HipHeight + (targetPart.RootPart.Size.Y / 2))
		for i = 1, math.floor(mag / 0.016) do
			newVelocity = newVelocity - (Gravity * 0.016)
			local floorDetection = workspace:Raycast(pos, Vector3.new(0, (newVelocity * 0.016) - rootSize, 0), GravityRaycast)
			if floorDetection then
				pos = Vector3.new(pos.X, floorDetection.Position.Y + rootSize, pos.Z)
				break
			end
			pos = pos + Vector3.new(0, newVelocity * 0.016, 0)
		end
		return pos, Vector3.new(vel.X, 0, vel.Z)
	end

	local function LaunchAngle(v: number, g: number, d: number, h: number, higherArc: boolean)
		local v2 = v * v
		local v4 = v2 * v2
		local root = math.sqrt(v4 - g*(g*d*d + 2*h*v2))
		if not higherArc then root = -root end
		return math.atan((v2 + root) / (g * d))
	end

	local function LaunchDirection(start, target, v, g, higherArc: boolean)
		local horizontal = Vector3.new(target.X - start.X, 0, target.Z - start.Z)
		local h = target.Y - start.Y
		local d = horizontal.Magnitude
		local a = LaunchAngle(v, g, d, h, higherArc)
		if a ~= a then return nil end
		local vec = horizontal.Unit * v
		local rotAxis = Vector3.new(-horizontal.Z, 0, horizontal.X)
		return CFrame.fromAxisAngle(rotAxis, a) * vec
	end

	local function FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, Gravityity: Number)
		local distance = (targetPosition - shooterPosition).Magnitude
		local p = targetPosition - shooterPosition
		local v = targetVelocity - shooterVelocity
		local a = Vector3.zero
		local timeTaken = (distance / projectileSpeed)
		local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
		local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
		local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
		return Vector3.new(goalX, goalY, goalZ)
	end

	local function canClick()
		local mousepos = inputService:GetMouseLocation() - Vector2.new(0, 36)
		for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do
			if v.Active and v.Visible and v:FindFirstAncestorOfClass("ScreenGui").Enabled then
				return false
			end
		end
		return true
	end

	local SilentAimFunctions = {
		FindPartOnRayWithIgnoreList = function(Args)
			local targetPart = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHeadshotChance.Value or SilentAimAutoFire.Enabled) and "Head" or "RootPart"
			local origin = Args[1].Origin
			local plr
			if SilentAimMode.Value == "Mouse" then
				plr = EntityNearMouse(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			else
				plr = EntityNearPosition(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			end
			if not plr then return end
			targetPart = plr[targetPart]
			if SilentAimWallbang.Enabled then
				return {targetPart, targetPart.Position, Vector3.zero, targetPart.Material}
			end
			SilentAimShot = plr
			SlientAimShotTick = tick() + 1
			local direction = CFrame.lookAt(origin, targetPart.Position)
			if SilentAimProjectile.Enabled then
				local targetPosition, targetVelocity = targetPart.Position, targetPart.Velocity
				if SilentAimProjectilePredict.Enabled then
					targetPosition, targetVelocity = predictGravity(targetPosition, targetVelocity, (targetPosition - origin).Magnitude / SilentAimProjectileSpeed.Value, plr, workspace.Gravity)
				end
				local calculated = LaunchDirection(origin, FindLeadShot(targetPosition, targetVelocity, SilentAimProjectileSpeed.Value, origin, Vector3.zero, SilentAimProjectileGravity.Value), SilentAimProjectileSpeed.Value,  SilentAimProjectileGravity.Value, false)
				if calculated then
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			Args[1] = Ray.new(origin, direction.lookVector * Args[1].Direction.Magnitude)
			return
		end,
		Raycast = function(Args)
			local targetPart = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHeadshotChance.Value or SilentAimAutoFire.Enabled) and "Head" or "RootPart"
			local origin = Args[1]
			local plr
			if SilentAimMode.Value == "Mouse" then
				plr = EntityNearMouse(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreObject = Args[3]
				})
			else
				plr = EntityNearPosition(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreObject = Args[3]
				})
			end
			if not plr then return end
			targetPart = plr[targetPart]
			SilentAimShot = plr
			SlientAimShotTick = tick() + 1
			local direction = CFrame.lookAt(origin, targetPart.Position)
			if SilentAimProjectile.Enabled then
				local targetPosition, targetVelocity = targetPart.Position, targetPart.Velocity
				if SilentAimProjectilePredict.Enabled then
					targetPosition, targetVelocity = predictGravity(targetPosition, targetVelocity, (targetPosition - origin).Magnitude / SilentAimProjectileSpeed.Value, plr, workspace.Gravity)
				end
				local calculated = LaunchDirection(origin, FindLeadShot(targetPosition, targetVelocity, SilentAimProjectileSpeed.Value, origin, Vector3.zero, SilentAimProjectileGravity.Value), SilentAimProjectileSpeed.Value,  SilentAimProjectileGravity.Value, false)
				if calculated then
					direction = CFrame.lookAt(origin, origin + calculated)
				end
			end
			Args[2] = direction.lookVector * Args[2].Magnitude
			if SilentAimWallbang.Enabled then
				SilentAimRaycastWhitelist.FilterDescendantsInstances = {targetPart}
				Args[3] = SilentAimRaycastWhitelist
			end
			return
		end,
		ScreenPointToRay = function(Args)
			local targetPart = ((math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100)) <= SilentAimHeadshotChance.Value or SilentAimAutoFire.Enabled) and "Head" or "RootPart"
			local origin = gameCamera.CFrame.p
			local plr
			if SilentAimMode.Value == "Mouse" then
				plr = EntityNearMouse(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			else
				plr = EntityNearPosition(SilentAimFOV.Value, {
					WallCheck = SilentAimWallCheck.Enabled,
					AimPart = targetPart,
					Origin = origin,
					IgnoreTable = SilentAimSmartWallTable
				})
			end
			if not plr then return end
			targetPart = plr[targetPart]
			SilentAimShot = plr
			SlientAimShotTick = tick() + 1
			local direction = CFrame.lookAt(origin, targetPart.Position)
			if SilentAimProjectile.Enabled then
				if SilentAimProjectile.Enabled then
					local targetPosition, targetVelocity = targetPart.Position, targetPart.Velocity
					if SilentAimProjectilePredict.Enabled then
						targetPosition, targetVelocity = predictGravity(targetPosition, targetVelocity, (targetPosition - origin).Magnitude / SilentAimProjectileSpeed.Value, plr, workspace.Gravity)
					end
					local calculated = LaunchDirection(origin, FindLeadShot(targetPosition, targetVelocity, SilentAimProjectileSpeed.Value, origin, Vector3.zero, SilentAimProjectileGravity.Value), SilentAimProjectileSpeed.Value,  SilentAimProjectileGravity.Value, false)
					if calculated then
						direction = CFrame.lookAt(origin, origin + calculated)
					end
				end
			end
			return {Ray.new(direction.p + (Args[3] and direction.lookVector * Args[3] or Vector3.zero), direction.lookVector)}
		end
	}
	SilentAimFunctions.FindPartOnRayWithWhitelist = SilentAimFunctions.FindPartOnRayWithIgnoreList
	SilentAimFunctions.FindPartOnRay = SilentAimFunctions.FindPartOnRayWithIgnoreList
	SilentAimFunctions.ViewportPointToRay = SilentAimFunctions.ScreenPointToRay

	local SilentAimEnableFunctions = {
		Normal = function()
			if not SilentAimHooked then
				SilentAimHooked = true
				local oldnamecall
				oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
					if getnamecallmethod() ~= SilentAimMethod.Value then
						return oldnamecall(self, ...)
					end
					if checkcaller() then
						return oldnamecall(self, ...)
					end
					if not SilentAim.Enabled then
						return oldnamecall(self, ...)
					end
					local calling = getcallingscript()
					if calling then
						local list = #SilentAimIgnoredScripts.ObjectList > 0 and SilentAimIgnoredScripts.ObjectList or {"ControlScript", "ControlModule"}
						if table.find(list, tostring(calling)) then
							return oldnamecall(self, ...)
						end
					end
					local Args = {...}
					local res = SilentAimFunctions[SilentAimMethod.Value](Args)
					if res then
						return unpack(res)
					end
					return oldnamecall(self, unpack(Args))
				end)
			end
		end,
		NormalV3 = function()
			if not SilentAimHooked then
				SilentAimHooked = true
				local oldnamecall
				oldnamecall = hookmetamethod(game, "__namecall", getfilter(SilentAimFilterObject, function(self, ...) return oldnamecall(self, ...) end, function(self, ...)
					local calling = getcallingscript()
					if calling then
						local list = #SilentAimIgnoredScripts.ObjectList > 0 and SilentAimIgnoredScripts.ObjectList or {"ControlScript", "ControlModule"}
						if table.find(list, tostring(calling)) then
							return oldnamecall(self, ...)
						end
					end
					local Args = {...}
					local res = SilentAimFunctions[SilentAimMethod.Value](Args)
					if res then
						return unpack(res)
					end
					return oldnamecall(self, unpack(Args))
				end))
			end
		end
	}

	SilentAim = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "SilentAim",
		Function = function(callback)
			if callback then
				SilentAimMethodUsed = "Normal"..synapsev3
				task.spawn(function()
					repeat
						vapeTargetInfo.Targets.SilentAim = SlientAimShotTick >= tick() and SilentAimShot or nil
						task.wait()
					until not SilentAim.Enabled
				end)
				if SilentAimCircle then SilentAimCircle.Visible = SilentAimMode.Value == "Mouse" end
				if SilentAimEnableFunctions[SilentAimMethodUsed] then
					SilentAimEnableFunctions[SilentAimMethodUsed]()
				end
			else
				if restorefunction then
					restorefunction(getrawmetatable(game).__namecall)
					SilentAimHooked = false
				end
				if SilentAimCircle then SilentAimCircle.Visible = false end
				vapeTargetInfo.Targets.SilentAim = nil
			end
		end,
		ExtraText = function()
			return SilentAimMethod.Value:gsub("FindPartOn", ""):gsub("PointToRay", "")
		end
	})
	SilentAimMode = SilentAim.CreateDropdown({
		Name = "Mode",
		List = {"Mouse", "Position"},
		Function = function(val) if SilentAimCircle then SilentAimCircle.Visible = SilentAim.Enabled and val == "Mouse" end end
	})
	SilentAimMethod = SilentAim.CreateDropdown({
		Name = "Method",
		List = {"FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist", "Raycast", "FindPartOnRay", "ScreenPointToRay", "ViewportPointToRay"},
		Function = function(val)
			SilentAimRaycastMode.Object.Visible = val == "Raycast"
			if SilentAimFilterObject then SilentAimFilterObject.Filters[1].NamecallMethod = val end
		end
	})
	SilentAimRaycastMode = SilentAim.CreateDropdown({
		Name = "Method Type",
		List = {"All", "Whitelist", "Blacklist"},
		Function = function(val) end
	})
	SilentAimRaycastMode.Object.Visible = false
	SilentAimFOV = SilentAim.CreateSlider({
		Name = "FOV",
		Min = 1,
		Max = 1000,
		Function = function(val) if SilentAimCircle then SilentAimCircle.Radius = val end  end,
		Default = 80
	})
	SilentAimHitChance = SilentAim.CreateSlider({
		Name = "Hit Chance",
		Min = 1,
		Max = 100,
		Function = function(val) end,
		Default = 100,
	})
	SilentAimHeadshotChance = SilentAim.CreateSlider({
		Name = "Headshot Chance",
		Min = 1,
		Max = 100,
		Function = function(val) end,
		Default = 25
	})
	SilentAimCircleToggle = SilentAim.CreateToggle({
		Name = "FOV Circle",
		Function = function(callback)
			if SilentAimCircleColor.Object then SilentAimCircleColor.Object.Visible = callback end
			if SilentAimCircleFilled.Object then SilentAimCircleFilled.Object.Visible = callback end
			if callback then
				SilentAimCircle = Drawing.new("Circle")
				SilentAimCircle.Transparency = 0.5
				SilentAimCircle.NumSides = 100
				SilentAimCircle.Filled = SilentAimCircleFilled.Enabled
				SilentAimCircle.Thickness = 1
				SilentAimCircle.Visible =  SilentAim.Enabled and SilentAimMode.Value == "Mouse"
				SilentAimCircle.Color = Color3.fromHSV(SilentAimCircleColor.Hue, SilentAimCircleColor.Sat, SilentAimCircleColor.Value)
				SilentAimCircle.Radius = SilentAimFOV.Value
				SilentAimCircle.Position = Vector2.new(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2)
				table.insert(SilentAimCircleToggle.Connections, gameCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					SilentAimCircle.Position = Vector2.new(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2)
				end))
			else
				if SilentAimCircle then
					SilentAimCircle:Destroy()
					SilentAimCircle = nil
				end
			end
		end,
	})
	SilentAimCircleColor = SilentAim.CreateColorSlider({
		Name = "Circle Color",
		Function = function(hue, sat, val)
			if SilentAimCircle then SilentAimCircle.Color = Color3.fromHSV(hue, sat, val) end
		end
	})
	SilentAimCircleColor.Object.Visible = false
	SilentAimCircleFilled = SilentAim.CreateToggle({
		Name = "Filled Circle",
		Function = function(callback)
			if SilentAimCircle then SilentAimCircle.Filled = callback end
		end,
		Default = true
	})
	SilentAimCircleFilled.Object.Visible = false
	SilentAimWallCheck = SilentAim.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	SilentAimWallbang = SilentAim.CreateToggle({
		Name = "Wall Bang",
		Function = function() end
	})
	SilentAimAutoFire = SilentAim.CreateToggle({
		Name = "AutoFire",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if SilentAim.Enabled then
							local plr
							if SilentAimMode.Value == "Mouse" then
								plr = EntityNearMouse(SilentAimFOV.Value, {
									WallCheck = SilentAimWallCheck.Enabled,
									AimPart = "Head",
									Origin = gameCamera.CFrame.p,
									IgnoreTable = SilentAimSmartWallTable
								})
							else
								plr = EntityNearPosition(SilentAimFOV.Value, {
									WallCheck = SilentAimWallCheck.Enabled,
									AimPart = "Head",
									Origin = gameCamera.CFrame.p,
									IgnoreTable = SilentAimSmartWallTable
								})
							end
							if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
								if plr then
									if canClick() and GuiLibrary.MainGui.ScaledGui.ClickGui.Visible == false and not inputService:GetFocusedTextBox() then
										if mouseClicked then mouse1release() else mouse1press() end
										mouseClicked = not mouseClicked
									else
										if mouseClicked then mouse1release() end
										mouseClicked = false
									end
								else
									if mouseClicked then mouse1release() end
									mouseClicked = false
								end
							end
						end
						task.wait()
					until not SilentAimAutoFire.Enabled
				end)
			end
		end,
		HoverText = "Automatically fires gun",
	})
	SilentAimProjectile = SilentAim.CreateToggle({
		Name = "Projectile",
		Function = function(callback)
			if SilentAimProjectileSpeed.Object then SilentAimProjectileSpeed.Object.Visible = callback end
			if SilentAimProjectileGravity.Object then SilentAimProjectileGravity.Object.Visible = callback end
		end
	})
	SilentAimProjectileSpeed = SilentAim.CreateSlider({
		Name = "Projectile Speed",
		Min = 1,
		Max = 1000,
		Default = 1000,
		Function = function() end
	})
	SilentAimProjectileSpeed.Object.Visible = false
	SilentAimProjectileGravity = SilentAim.CreateSlider({
		Name = "Projectile Gravity",
		Min = 1,
		Max = 192.6,
		Default = 192.6,
		Function = function() end
	})
	SilentAimProjectileGravity.Object.Visible = false
	SilentAimProjectilePredict = SilentAim.CreateToggle({
		Name = "Projectile Prediction",
		Function = function() end,
		HoverText = "Predicts the player's movement"
	})
	SilentAimProjectilePredict.Object.Visible = false
	SilentAimSmartWallIgnore = SilentAim.CreateToggle({
		Name = "Smart Ignore",
		Function = function(callback)
			if callback then
				table.insert(SilentAimSmartWallIgnore.Connections, workspace.DescendantAdded:Connect(function(v)
					local lowername = v.Name:lower()
					if lowername:find("junk") or lowername:find("trash") or lowername:find("ignore") or lowername:find("particle") or lowername:find("spawn") or lowername:find("bullet") or lowername:find("debris") then
						table.insert(SilentAimSmartWallTable, v)
					end
				end))
				for i,v in pairs(workspace:GetDescendants()) do
					local lowername = v.Name:lower()
					if lowername:find("junk") or lowername:find("trash") or lowername:find("ignore") or lowername:find("particle") or lowername:find("spawn") or lowername:find("bullet") or lowername:find("debris") then
						table.insert(SilentAimSmartWallTable, v)
					end
				end
			else
				table.clear(SilentAimSmartWallTable)
			end
		end,
		HoverText = "Ignores certain folders and what not with certain names"
	})
	SilentAimIgnoredScripts = SilentAim.CreateTextList({
		Name = "Ignored Scripts",
		TempText = "ignored scripts",
		AddFunction = function(user) end,
		RemoveFunction = function(num) end
	})

	local function getTriggerBotTarget()
		local rayparams = RaycastParams.new()
		rayparams.FilterDescendantsInstances = {lplr.Character, gameCamera}
		rayparams.RespectCanCollide = true
		local ray = workspace:Raycast(gameCamera.CFrame.p, gameCamera.CFrame.lookVector * 10000, rayparams)
		if ray and ray.Instance then
			for i,v in pairs(entityLibrary.entityList) do
				if v.Targetable and v.Character then
					if ray.Instance:IsDescendantOf(v.Character) then
						return isVulnerable(v) and v
					end
				end
			end
		end
		return nil
	end

	local TriggerBot = {Enabled = false}
	TriggerBot = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "TriggerBot",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						local plr = getTriggerBotTarget()
						if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
							if plr then
								if canClick() and GuiLibrary.MainGui.ScaledGui.ClickGui.Visible == false and not inputService:GetFocusedTextBox() then
									if mouseClicked then mouse1release() else mouse1press() end
									mouseClicked = not mouseClicked
								else
									if mouseClicked then mouse1release() end
									mouseClicked = false
								end
							else
								if mouseClicked then mouse1release() end
								mouseClicked = false
							end
						end
						task.wait()
					until not TriggerBot.Enabled
				end)
			else
				if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
					if mouseClicked then mouse1release() end
					mouseClicked = false
				end
			end
		end
	})
end)

run(function()
	local AutoClicker = {Enabled = false}
	local AutoClickerCPS = {GetRandomValue = function() return 1 end}
	local AutoClickerMode = {Value = "Sword"}
	AutoClicker = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "AutoClicker",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if AutoClickerMode.Value == "Tool" then
							local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
							if tool and inputService:IsMouseButtonPressed(0) then
								tool:Activate()
								task.wait(1 / AutoClickerCPS.GetRandomValue())
							end
						else
							if mouse1click and (isrbxactive and isrbxactive() or iswindowactive and iswindowactive()) then
								if GuiLibrary.MainGui.ScaledGui.ClickGui.Visible == false then
									local clickfunc = (AutoClickerMode.Value == "Click" and mouse1click or mouse2click)
									clickfunc()
									task.wait(1 / AutoClickerCPS.GetRandomValue())
								end
							end
						end
						task.wait()
					until not AutoClicker.Enabled
				end)
			end
		end
	})
	AutoClickerMode = AutoClicker.CreateDropdown({
		Name = "Mode",
		List = {"Tool", "Click", "RightClick"},
		Function = function() end
	})
	AutoClickerCPS = AutoClicker.CreateTwoSlider({
		Name = "CPS",
		Min = 1,
		Max = 20,
		Default = 8,
		Default2 = 12
	})
end)

run(function()
	local ClickTP = {Enabled = false}
	local ClickTPMethod = {Value = "Normal"}
	local ClickTPDelay = {Value = 1}
	local ClickTPAmount = {Value = 1}
	local ClickTPVertical = {Enabled = true}
	local ClickTPVelocity = {Enabled = false}
	local ClickTPRaycast = RaycastParams.new()
	ClickTPRaycast.RespectCanCollide = true
	ClickTPRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	ClickTP = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "MouseTP",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("MouseTP", function()
					if isAlive(lplr, true) and ClickTPVelocity.Enabled and ClickTPMethod.Value == "SlowTP" then
						lplr.Character.HumanoidRootPart.Velocity = Vector3.zero
					end
				end)
				if isAlive(lplr, true) then
					ClickTPRaycast.FilterDescendantsInstances = {lplr.Character, gameCamera}
					local ray = workspace:Raycast(gameCamera.CFrame.p, lplr:GetMouse().UnitRay.Direction * 10000, ClickTPRaycast)
					local selectedPosition = ray and ray.Position + Vector3.new(0, lplr.Character.Humanoid.HipHeight + (lplr.Character.HumanoidRootPart.Size.Y / 2), 0)
					if selectedPosition then
						if ClickTPMethod.Value == "Normal" then
							lplr.Character.HumanoidRootPart.CFrame = CFrame.new(selectedPosition)
							ClickTP.ToggleButton(false)
						else
							task.spawn(function()
								repeat
									if isAlive(lplr, true) then
										local newpos = (selectedPosition - lplr.Character.HumanoidRootPart.CFrame.p).Unit
										newpos = newpos == newpos and newpos * math.min((selectedPosition - lplr.Character.HumanoidRootPart.CFrame.p).Magnitude, ClickTPAmount.Value) or Vector3.zero
										lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(newpos.X, (ClickTPVertical.Enabled and newpos.Y or 0), newpos.Z)
										if (selectedPosition - lplr.Character.HumanoidRootPart.CFrame.p).Magnitude <= 5 then
											break
										end
									end
									task.wait(ClickTPDelay.Value / 100)
								until isAlive(lplr, true) and (selectedPosition - lplr.Character.HumanoidRootPart.CFrame.p).Magnitude <= 5 or not ClickTP.Enabled
								if ClickTP.Enabled then ClickTP.ToggleButton(false) end
							end)
						end
					else
						ClickTP.ToggleButton(false)
						warningNotification("ClickTP", "No position found.", 1)
					end
				else
					if ClickTP.Enabled then ClickTP.ToggleButton(false) end
				end
			else
				RunLoops:UnbindFromHeartbeat("MouseTP")
			end
		end,
		HoverText = "Teleports to where your mouse is."
	})
	ClickTPMethod = ClickTP.CreateDropdown({
		Name = "Method",
		List = {"Normal", "SlowTP"},
		Function = function(val)
			if ClickTPAmount.Object then ClickTPAmount.Object.Visible = val == "SlowTP" end
			if ClickTPDelay.Object then ClickTPDelay.Object.Visible = val == "SlowTP" end
			if ClickTPVertical.Object then ClickTPVertical.Object.Visible = val == "SlowTP" end
			if ClickTPVelocity.Object then ClickTPVelocity.Object.Visible = val == "SlowTP" end
		end
	})
	ClickTPAmount = ClickTP.CreateSlider({
		Name = "Amount",
		Min = 1,
		Max = 50,
		Function = function() end
	})
	ClickTPAmount.Object.Visible = false
	ClickTPDelay = ClickTP.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Function = function() end
	})
	ClickTPDelay.Object.Visible = false
	ClickTPVertical = ClickTP.CreateToggle({
		Name = "Vertical",
		Default = true,
		Function = function() end
	})
	ClickTPVertical.Object.Visible = false
	ClickTPVelocity = ClickTP.CreateToggle({
		Name = "No Velocity",
		Default = true,
		Function = function() end
	})
	ClickTPVelocity.Object.Visible = false
end)

run(function()
	local Fly = {Enabled = false}
	local FlySpeed = {Value = 1}
	local FlyVerticalSpeed = {Value = 1}
	local FlyTPOff = {Value = 10}
	local FlyTPOn = {Value = 10}
	local FlyCFrameVelocity = {Enabled = false}
	local FlyWallCheck = {Enabled = false}
	local FlyVertical = {Enabled = false}
	local FlyMethod = {Value = "Normal"}
	local FlyMoveMethod = {Value = "MoveDirection"}
	local FlyKeys = {Value = "Space/LeftControl"}
	local FlyState = {Value = "Normal"}
	local FlyPlatformToggle = {Enabled = false}
	local FlyPlatformStanding = {Enabled = false}
	local FlyRaycast = RaycastParams.new()
	FlyRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	FlyRaycast.RespectCanCollide = true
	local FlyJumpCFrame = CFrame.new(0, 0, 0)
	local FlyAliveCheck = false
	local FlyUp = false
	local FlyDown = false
	local FlyY = 0
	local FlyPlatform
	local w = 0
	local s = 0
	local a = 0
	local d = 0
	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C", "AntiCheat D"}
	Fly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Fly",
		Function = function(callback)
			if callback then
				local FlyPlatformTick = tick() + 0.2
				w = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				table.insert(Fly.Connections, inputService.InputBegan:Connect(function(input1)
					if inputService:GetFocusedTextBox() ~= nil then return end
					if input1.KeyCode == Enum.KeyCode.W then
						w = -1
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 1
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = -1
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 1
					end
					if FlyVertical.Enabled then
						local divided = FlyKeys.Value:split("/")
						if input1.KeyCode == Enum.KeyCode[divided[1]] then
							FlyUp = true
						elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
							FlyDown = true
						end
					end
				end))
				table.insert(Fly.Connections, inputService.InputEnded:Connect(function(input1)
					local divided = FlyKeys.Value:split("/")
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 0
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = 0
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 0
					elseif input1.KeyCode == Enum.KeyCode[divided[1]] then
						FlyUp = false
					elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
						FlyDown = false
					end
				end))
				if inputService.TouchEnabled then
					pcall(function()
						local jumpButton = lplr.PlayerGui.TouchGui.TouchControlFrame.JumpButton
						table.insert(Fly.Connections, jumpButton:GetPropertyChangedSignal("ImageRectOffset"):Connect(function()
							FlyUp = jumpButton.ImageRectOffset.X == 146
						end))
						FlyUp = jumpButton.ImageRectOffset.X == 146
					end)
				end
				if FlyMethod.Value == "Jump" and isAlive(lplr, true) then
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				local FlyTP = false
				local FlyTPTick = tick()
				local FlyTPY
				RunLoops:BindToHeartbeat("Fly", function(delta)
					if isAlive(lplr, true) and (typeof(lplr.Character.HumanoidRootPart) ~= "Instance" or isnetworkowner(lplr.Character.HumanoidRootPart)) then
						lplr.Character.Humanoid.PlatformStand = FlyPlatformStanding.Enabled
						if not FlyY then FlyY = lplr.Character.HumanoidRootPart.CFrame.p.Y end
						local movevec = (FlyMoveMethod.Value == "Manual" and calculateMoveVector(Vector3.new(a + d, 0, w + s)) or lplr.Character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero
						if FlyState.Value ~= "None" then
							lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType[FlyState.Value])
						end
						if FlyMethod.Value == "Normal" or FlyMethod.Value == "Bounce" then
							if FlyPlatformStanding.Enabled then
								lplr.Character.HumanoidRootPart.CFrame = CFrame.new(lplr.Character.HumanoidRootPart.CFrame.p, lplr.Character.HumanoidRootPart.CFrame.p + gameCamera.CFrame.lookVector)
								lplr.Character.HumanoidRootPart.RotVelocity = Vector3.zero
							end
							lplr.Character.HumanoidRootPart.Velocity = (movevec * FlySpeed.Value) + Vector3.new(0, 0.85 + (FlyMethod.Value == "Bounce" and (tick() % 0.5 > 0.25 and -10 or 10) or 0) + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0)
						else
							if FlyUp then
								FlyY = FlyY + (FlyVerticalSpeed.Value * delta)
							end
							if FlyDown then
								FlyY = FlyY - (FlyVerticalSpeed.Value * delta)
							end
							local newMovementPosition = (movevec * (math.max(FlySpeed.Value - lplr.Character.Humanoid.WalkSpeed, 0) * delta))
							newMovementPosition = Vector3.new(newMovementPosition.X, (FlyY - lplr.Character.HumanoidRootPart.CFrame.p.Y), newMovementPosition.Z)
							if FlyWallCheck.Enabled then
								FlyRaycast.FilterDescendantsInstances = {lplr.Character, gameCamera}
								local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, newMovementPosition, FlyRaycast)
								if ray and ray.Instance.CanCollide then
									newMovementPosition = (ray.Position - lplr.Character.HumanoidRootPart.Position)
									FlyY = ray.Position.Y
								end
							end
							local origvelo = lplr.Character.HumanoidRootPart.Velocity
							if FlyMethod.Value == "CFrame" then
								lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newMovementPosition
								if FlyCFrameVelocity.Enabled then
									lplr.Character.HumanoidRootPart.Velocity = Vector3.new(origvelo.X, 0, origvelo.Z)
								end
								if FlyPlatformStanding.Enabled then
									lplr.Character.HumanoidRootPart.CFrame = CFrame.new(lplr.Character.HumanoidRootPart.CFrame.p, lplr.Character.HumanoidRootPart.CFrame.p + gameCamera.CFrame.lookVector)
								end
							elseif FlyMethod.Value == "Jump" then
								lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(newMovementPosition.X, 0, newMovementPosition.Z)
								if lplr.Character.HumanoidRootPart.Velocity.Y < -(lplr.Character.Humanoid.JumpPower - ((FlyUp and FlyVerticalSpeed.Value or 0) - (FlyDown and FlyVerticalSpeed.Value or 0))) then
									FlyJumpCFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0, -lplr.Character.Humanoid.HipHeight, 0)
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							else
								if FlyTPTick <= tick() then
									FlyTP = not FlyTP
									if FlyTP then
										if FlyTPY then FlyY = FlyTPY end
									else
										FlyTPY = FlyY
										FlyRaycast.FilterDescendantsInstances = {lplr.Character, gameCamera}
										local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -10000, 0), FlyRaycast)
										if ray then FlyY = ray.Position.Y + ((lplr.Character.HumanoidRootPart.Size.Y / 2) + lplr.Character.Humanoid.HipHeight) end
									end
									FlyTPTick = tick() + ((FlyTP and FlyTPOn.Value or FlyTPOff.Value) / 10)
								end
								lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newMovementPosition
								if FlyPlatformStanding.Enabled then
									lplr.Character.HumanoidRootPart.CFrame = CFrame.new(lplr.Character.HumanoidRootPart.CFrame.p, lplr.Character.HumanoidRootPart.CFrame.p + gameCamera.CFrame.lookVector)
									lplr.Character.HumanoidRootPart.RotVelocity = Vector3.zero
								end
							end
						end
						if FlyPlatform then
							FlyPlatform.CFrame = (FlyMethod.Value == "Jump" and FlyJumpCFrame or lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0, -(lplr.Character.Humanoid.HipHeight + (lplr.Character.HumanoidRootPart.Size.Y / 2) + 0.53), 0))
							FlyPlatform.Parent = gameCamera
							if FlyUp or FlyPlatformTick >= tick() then
								lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							end
						end
					else
						FlyY = nil
					end
				end)
			else
				FlyUp = false
				FlyDown = false
				FlyY = nil
				RunLoops:UnbindFromHeartbeat("Fly")
				if isAlive(lplr, true) and FlyPlatformStanding.Enabled then
					lplr.Character.Humanoid.PlatformStand = false
				end
				if FlyPlatform then
					FlyPlatform.Parent = nil
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				end
			end
		end,
		ExtraText = function()
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"].Api.Enabled then
				return alternatelist[table.find(FlyMethod.List, FlyMethod.Value)]
			end
			return FlyMethod.Value
		end
	})
	FlyMethod = Fly.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "CFrame", "Jump", "TP", "Bounce"},
		Function = function(val)
			FlyY = nil
			if FlyTPOn.Object then FlyTPOn.Object.Visible = val == "TP" end
			if FlyTPOff.Object then FlyTPOff.Object.Visible = val == "TP" end
			if FlyWallCheck.Object then FlyWallCheck.Object.Visible = val == "CFrame" or val == "Jump" end
			if FlyCFrameVelocity.Object then FlyCFrameVelocity.Object.Visible = val == "CFrame" end
		end
	})
	FlyMoveMethod = Fly.CreateDropdown({
		Name = "Movement",
		List = {"Manual", "MoveDirection"},
		Function = function(val) end
	})
	FlyKeys = Fly.CreateDropdown({
		Name = "Keys",
		List = {"Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q"},
		Function = function(val) end
	})
	local states = {"None"}
	for i,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do if v.Name ~= "Dead" and v.Name ~= "None" then table.insert(states, v.Name) end end
	FlyState = Fly.CreateDropdown({
		Name = "State",
		List = states,
		Function = function(val) end
	})
	FlySpeed = Fly.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 150,
		Function = function(val) end
	})
	FlyVerticalSpeed = Fly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 150,
		Function = function(val) end
	})
	FlyTPOn = Fly.CreateSlider({
		Name = "TP Time Ground",
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function() end,
		Double = 10
	})
	FlyTPOn.Object.Visible = false
	FlyTPOff = Fly.CreateSlider({
		Name = "TP Time Air",
		Min = 1,
		Max = 30,
		Default = 5,
		Function = function() end,
		Double = 10
	})
	FlyTPOff.Object.Visible = false
	FlyPlatformToggle = Fly.CreateToggle({
		Name = "FloorPlatform",
		Function = function(callback)
			if callback then
				FlyPlatform = Instance.new("Part")
				FlyPlatform.Anchored = true
				FlyPlatform.CanCollide = true
				FlyPlatform.Size = Vector3.new(2, 1, 2)
				FlyPlatform.Transparency = 0
			else
				if FlyPlatform then
					FlyPlatform:Destroy()
					FlyPlatform = nil
				end
			end
		end
	})
	FlyPlatformStanding = Fly.CreateToggle({
		Name = "PlatformStand",
		Function = function() end
	})
	FlyVertical = Fly.CreateToggle({
		Name = "Y Level",
		Function = function() end
	})
	FlyWallCheck = Fly.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	FlyWallCheck.Object.Visible = false
	FlyCFrameVelocity = Fly.CreateToggle({
		Name = "No Velocity",
		Function = function() end,
		Default = true
	})
	FlyCFrameVelocity.Object.Visible = false
end)

run(function()
	local Hitboxes = {Enabled = false}
	local HitboxMode = {Value = "HumanoidRootPart"}
	local HitboxExpand = {Value = 1}
	Hitboxes = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "HitBoxes",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						for i,plr in pairs(entityLibrary.entityList) do
							if plr.Targetable then
								if HitboxMode.Value == "HumanoidRootPart" then
									plr.RootPart.Size = Vector3.new(2 * (HitboxExpand.Value / 10), 2 * (HitboxExpand.Value / 10), 1 * (HitboxExpand.Value / 10))
								else
									plr.Head.Size = Vector3.new((HitboxExpand.Value / 10), (HitboxExpand.Value / 10), (HitboxExpand.Value / 10))
								end
							end
						end
						task.wait()
					until not Hitboxes.Enabled
				end)
			else
				for i,plr in pairs(entityLibrary.entityList) do
					plr.RootPart.Size = Vector3.new(2, 2, 1)
					plr.Head.Size = Vector3.new(1, 1, 1)
				end
			end
		end
	})
	HitboxMode = Hitboxes.CreateDropdown({
		Name = "Expand part",
		List = {"HumanoidRootPart", "Head"},
		Function = function(val)
			if Hitboxes.Enabled then
				for i,plr in pairs(entityLibrary.entityList) do
					if plr.Targetable then
						if HitboxMode.Value == "HumanoidRootPart" then
							plr.RootPart.Size = Vector3.new(2 * (HitboxExpand.Value / 10), 2 * (HitboxExpand.Value / 10), 1 * (HitboxExpand.Value / 10))
						else
							plr.Head.Size = Vector3.new((HitboxExpand.Value / 10), (HitboxExpand.Value / 10), (HitboxExpand.Value / 10))
						end
					end
				end
			end
		end
	})
	HitboxExpand = Hitboxes.CreateSlider({
		Name = "Expand amount",
		Min = 10,
		Max = 50,
		Function = function(val) end
	})
end)

local KillauraNearTarget = false
run(function()
	local attackIgnore = OverlapParams.new()
	attackIgnore.FilterType = Enum.RaycastFilterType.Whitelist
	local function findTouchInterest(tool)
		return tool and tool:FindFirstChildWhichIsA("TouchTransmitter", true)
	end

	local Reach = {Enabled = false}
	local ReachRange = {Value = 1}
	Reach = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "Reach",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if isAlive(lplr, true) then
							local tool = lplr and lplr.Character and lplr.Character:FindFirstChildWhichIsA("Tool")
							local touch = findTouchInterest(tool)
							if tool and touch then
								touch = touch.Parent
								local chars = {}
								for i,v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
								ignorelist.FilterDescendantsInstances = chars
								local parts = workspace:GetPartBoundsInBox(touch.CFrame, touch.Size + Vector3.new(reachrange.Value, 0, reachrange.Value), ignorelist)
								for i,v in pairs(parts) do
									firetouchinterest(touch, v, 1)
									firetouchinterest(touch, v, 0)
								end
							end
						end
						task.wait()
					until not Reach.Enabled
				end)
			end
		end
	})
	ReachRange = Reach.CreateSlider({
		Name = "Range",
		Min = 1,
		Max = 20,
		Function = function(val) end,
	})

	local Killaura = {Enabled = false}
	local KillauraCPS = {GetRandomValue = function() return 1 end}
	local KillauraMethod = {Value = "Normal"}
	local KillauraTarget = {Enabled = false}
	local KillauraColor = {Value = 0.44}
	local KillauraRange = {Value = 1}
	local KillauraAngle = {Value = 90}
	local KillauraFakeAngle = {Enabled = false}
	local KillauraPrediction = {Enabled = true}
	local KillauraButtonDown = {Enabled = false}
	local KillauraTargetHighlight = {Enabled = false}
	local KillauraRangeCircle = {Enabled = false}
	local KillauraRangeCirclePart
	local KillauraSwingTick = tick()
	local KillauraBoxes = {}
	local OriginalNeckC0
	local OriginalRootC0
	for i = 1, 10 do
		local KillauraBox = Instance.new("BoxHandleAdornment")
		KillauraBox.Transparency = 0.5
		KillauraBox.Color3 = Color3.fromHSV(KillauraColor.Hue, KillauraColor.Sat, KillauraColor.Value)
		KillauraBox.Adornee = nil
		KillauraBox.AlwaysOnTop = true
		KillauraBox.Size = Vector3.new(3, 6, 3)
		KillauraBox.ZIndex = 11
		KillauraBox.Parent = GuiLibrary.MainGui
		KillauraBoxes[i] = KillauraBox
	end

	Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Killaura",
		Function = function(callback)
			if callback then
				if KillauraRangeCirclePart then KillauraRangeCirclePart.Parent = gameCamera end
				RunLoops:BindToHeartbeat("Killaura", function()
					for i,v in pairs(KillauraBoxes) do
						if v.Adornee then
							local onex, oney, onez = v.Adornee.CFrame:ToEulerAnglesXYZ()
							v.CFrame = CFrame.new() * CFrame.Angles(-onex, -oney, -onez)
						end
					end
					if isAlive(lplr, true) then
						if KillauraRangeCirclePart then
							KillauraRangeCirclePart.CFrame = lplr.Character.HumanoidRootPart.CFrame - Vector3.new(0, lplr.Character.Humanoid.HipHeight + (lplr.Character.HumanoidRootPart.Size.Y / 2) - 0.3, 0)
						end
						if KillauraFakeAngle.Enabled then
							local Neck = lplr.Character.Head:FindFirstChild("Neck")
							local LowerTorso = lplr.Character.HumanoidRootPart.Parent and lplr.Character.HumanoidRootPart.Parent:FindFirstChild("LowerTorso")
							local RootC0 = LowerTorso and LowerTorso:FindFirstChild("Root")
							if Neck and RootC0 then
								if not OriginalNeckC0 then OriginalNeckC0 = Neck.C0.p end
								if not OriginalRootC0 then OriginalRootC0 = RootC0.C0.p end
								if OriginalRootC0 then
									if targetedplayer ~= nil then
										local targetPos = targetedplayer.RootPart.Position + Vector3.new(0, targetedplayer.Humanoid.HipHeight + (targetedplayer.RootPart.Size.Y / 2), 0)
										local lookCFrame = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace((Vector3.new(targetPos.X, targetPos.Y, targetPos.Z) - lplr.Character.Head.Position).Unit)))
										Neck.C0 = CFrame.new(OriginalNeckC0) * CFrame.Angles(lookCFrame.LookVector.Unit.y, 0, 0)
										RootC0.C0 = (CFrame.new(Vector3.zero, (Root.CFrame):VectorToObjectSpace((Vector3.new(targetPos.X, Root.Position.Y, targetPos.Z) - Root.Position).Unit))) + OriginalRootC0
									else
										Neck.C0 = CFrame.new(OriginalNeckC0)
										RootC0.C0 = CFrame.new(OriginalRootC0)
									end
								end
							end
						end
					end
				end)
				task.spawn(function()
					repeat
						local attackedplayers = {}
						KillauraNearTarget = false
						vapeTargetInfo.Targets.Killaura = nil
						if isAlive(lplr, true) and (not KillauraButtonDown.Enabled or inputService:IsMouseButtonPressed(0)) then
							local plrs = AllNearPosition(KillauraRange.Value, 100, {Prediction = KillauraPrediction.Enabled})
							if #plrs > 0 then
								local tool = lplr.Character:FindFirstChildWhichIsA("Tool")
								local touch = findTouchInterest(tool)
								if tool and touch then
									for i,v in pairs(plrs) do
										if math.acos(lplr.Character.HumanoidRootPart.CFrame.lookVector:Dot((v.RootPart.Position - lplr.Character.HumanoidRootPart.Position).Unit)) >= (math.rad(KillauraAngle.Value) / 2) then continue end
										KillauraNearTarget = true
										if KillauraTarget.Enabled then
											table.insert(attackedplayers, v)
										end
										vapeTargetInfo.Targets.Killaura = v
										KillauraNearTarget = true
										if KillauraPrediction.Enabled then
											if (entityLibrary.LocalPosition - v.RootPart.Position).Magnitude > KillauraRange.Value then
												continue
											end
										end
										if KillauraSwingTick <= tick() then
											tool:Activate()
											KillauraSwingTick = tick() + (1 / KillauraCPS.GetRandomValue())
										end
										if KillauraMethod.Value == "Bypass" then
											attackIgnore.FilterDescendantsInstances = {v.Character}
											local parts = workspace:GetPartBoundsInBox(v.RootPart.CFrame, v.Character:GetExtentsSize(), attackIgnore)
											for i,v2 in pairs(parts) do
												firetouchinterest(touch.Parent, v2, 1)
												firetouchinterest(touch.Parent, v2, 0)
											end
										elseif KillauraMethod.Value == "Normal" then
											for i,v2 in pairs(v.Character:GetChildren()) do
												if v2:IsA("BasePart") then
													firetouchinterest(touch.Parent, v2, 1)
													firetouchinterest(touch.Parent, v2, 0)
												end
											end
										else
											firetouchinterest(touch.Parent, v.RootPart, 1)
											firetouchinterest(touch.Parent, v.RootPart, 0)
										end
									end
								end
							end
						end
						for i,v in pairs(KillauraBoxes) do
							local attacked = attackedplayers[i]
							v.Adornee = attacked and attacked.RootPart
						end
						task.wait()
					until not Killaura.Enabled
				end)
			else
				RunLoops:UnbindFromHeartbeat("Killaura")
                KillauraNearTarget = false
				vapeTargetInfo.Targets.Killaura = nil
				for i,v in pairs(KillauraBoxes) do v.Adornee = nil end
				if KillauraRangeCirclePart then KillauraRangeCirclePart.Parent = nil end
			end
		end,
		HoverText = "Attack players around you\nwithout aiming at them."
	})
	KillauraMethod = Killaura.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "Bypass", "Root Only"},
		Function = function() end
	})
	KillauraCPS = Killaura.CreateTwoSlider({
		Name = "Attacks per second",
		Min = 1,
		Max = 20,
		Default = 8,
		Default2 = 12
	})
	KillauraRange = Killaura.CreateSlider({
		Name = "Attack range",
		Min = 1,
		Max = 150,
		Function = function(val)
			if KillauraRangeCirclePart then
				KillauraRangeCirclePart.Size = Vector3.new(val * 0.7, 0.01, val * 0.7)
			end
		end
	})
	KillauraAngle = Killaura.CreateSlider({
		Name = "Max angle",
		Min = 1,
		Max = 360,
		Function = function(val) end,
		Default = 90
	})
	KillauraColor = Killaura.CreateColorSlider({
		Name = "Target Color",
		Function = function(hue, sat, val)
			for i,v in pairs(KillauraBoxes) do
				v.Color3 = Color3.fromHSV(hue, sat, val)
			end
			if KillauraRangeCirclePart then
				KillauraRangeCirclePart.Color = Color3.fromHSV(hue, sat, val)
			end
		end,
		Default = 1
	})
	KillauraButtonDown = Killaura.CreateToggle({
		Name = "Require mouse down",
		Function = function() end
	})
	KillauraTarget = Killaura.CreateToggle({
        Name = "Show target",
        Function = function(callback) end,
		HoverText = "Shows a red box over the opponent."
    })
	KillauraPrediction = Killaura.CreateToggle({
		Name = "Prediction",
		Function = function() end
	})
	KillauraFakeAngle = Killaura.CreateToggle({
        Name = "Face target",
        Function = function() end,
		HoverText = "Makes your character face the opponent."
    })
	KillauraRangeCircle = Killaura.CreateToggle({
		Name = "Range Visualizer",
		Function = function(callback)
			if callback then
				KillauraRangeCirclePart = Instance.new("MeshPart")
				KillauraRangeCirclePart.MeshId = "rbxassetid://3726303797"
				KillauraRangeCirclePart.Color = Color3.fromHSV(KillauraColor.Hue, KillauraColor.Sat, KillauraColor.Value)
				KillauraRangeCirclePart.CanCollide = false
				KillauraRangeCirclePart.Anchored = true
				KillauraRangeCirclePart.Material = Enum.Material.Neon
				KillauraRangeCirclePart.Size = Vector3.new(KillauraRange.Value * 0.7, 0.01, KillauraRange.Value * 0.7)
				KillauraRangeCirclePart.Parent = gameCamera
			else
				if KillauraRangeCirclePart then
					KillauraRangeCirclePart:Destroy()
					KillauraRangeCirclePart = nil
				end
			end
		end
	})
end)

run(function()
	local LongJump = {Enabled = false}
	local LongJumpBoost = {Value = 1}
	local LongJumpChange = true
	LongJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "LongJump",
		Function = function(callback)
			if callback then
				if isAlive(lplr, true) and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				RunLoops:BindToHeartbeat("LongJump", function()
					if isAlive(lplr, true) then
						if (lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall or lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping) and lplr.Character.Humanoid.MoveDirection ~= Vector3.zero then
							local velo = lplr.Character.Humanoid.MoveDirection * LongJumpBoost.Value
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(velo.X, lplr.Character.HumanoidRootPart.Velocity.Y, velo.Z)
						end
						local check = lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air
						if LongJumpChange ~= check then
							if check then LongJump.ToggleButton(true) end
							LongJumpChange = check
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("LongJump")
				LongJumpChange = true
			end
		end
	})
	LongJumpBoost = LongJump.CreateSlider({
		Name = "Boost",
		Min = 1,
		Max = 150,
		Function = function(val) end
	})

	local HighJump = {Enabled = false}
	local HighJumpMethod = {Value = "Toggle"}
	local HighJumpMode = {Value = "Normal"}
	local HighJumpBoost = {Value = 1}
	local HighJumpDelay = {Value = 20}
	local HighJumpTick = tick()
	local highjumpBound = true
	HighJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "HighJump",
		Function = function(callback)
			if callback then
				if HighJumpMethod.Value == "Toggle" then
					if HighJumpTick > tick()  then
						warningNotification("HighJump", "Wait "..(math.floor((HighJumpTick - tick()) * 10) / 10).."s before retoggling.", 1)
						HighJump.ToggleButton(false)
						return
					end
					if isAlive(lplr, true) and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
						HighJumpTick = tick() + (HighJumpDelay.Value / 10)
						if HighJumpMode.Value == "Normal" then
							lplr.Character.HumanoidRootPart.Velocity = lplr.Character.HumanoidRootPart.Velocity + Vector3.new(0, HighJumpBoost.Value, 0)
						else
							task.spawn(function()
								local start = HighJumpBoost.Value
								repeat
									lplr.Character.HumanoidRootPart.CFrame += Vector3.new(0, start * 0.016, 0)
									start = start - (workspace.Gravity * 0.016)
									task.wait()
								until start <= 0
							end)
						end
					end
					HighJump.ToggleButton(false)
				else
					local debounce = 0
					RunLoops:BindToRenderStep("HighJump", function()
						if isAlive(lplr, true) and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and inputService:IsKeyDown(Enum.KeyCode.Space) and (tick() - debounce) > 0.3 then
							debounce = tick()
							if HighJumpMode.Value == "Normal" then
								lplr.Character.HumanoidRootPart.Velocity = lplr.Character.HumanoidRootPart.Velocity + Vector3.new(0, HighJumpBoost.Value, 0)
							else
								task.spawn(function()
									local start = HighJumpBoost.Value
									repeat
										lplr.Character.HumanoidRootPart.CFrame += Vector3.new(0, start * 0.016, 0)
										start = start - (workspace.Gravity * 0.016)
										task.wait()
									until start <= 0
								end)
							end
						end
					end)
				end
			else
				RunLoops:UnbindFromRenderStep("HighJump")
			end
		end,
		HoverText = "Lets you jump higher"
	})
	HighJumpMethod = HighJump.CreateDropdown({
		Name = "Method",
		List = {"Toggle", "Normal"},
		Function = function(val) end
	})
	HighJumpMode = HighJump.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "CFrame"},
		Function = function(val) end
	})
	HighJumpBoost = HighJump.CreateSlider({
		Name = "Boost",
		Min = 1,
		Max = 150,
		Function = function(val) end,
		Default = 100
	})
	HighJumpDelay = HighJump.CreateSlider({
		Name = "Delay",
		Min = 0,
		Max = 50,
		Function = function(val) end,
	})
end)

local spiderHoldingShift = false
local Spider = {Enabled = false}
local Phase = {Enabled = false}
run(function()
	local PhaseMode = {Value = "Normal"}
	local PhaseStudLimit = {Value = 1}
	local PhaseModifiedParts = {}
	local PhaseRaycast = RaycastParams.new()
	PhaseRaycast.RespectCanCollide = true
	PhaseRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	local PhaseOverlap = OverlapParams.new()
	PhaseOverlap.MaxParts = 9e9
	PhaseOverlap.FilterDescendantsInstances = {}

	local PhaseFunctions = {
		Part = function()
			local chars = {gameCamera, lplr.Character}
			for i, v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
			PhaseOverlap.FilterDescendantsInstances = chars
			local rootpos = lplr.Character.HumanoidRootPart.CFrame.p
			local parts = workspace:GetPartBoundsInRadius(rootpos, 2, PhaseOverlap)
			for i, v in pairs(parts) do
				if v.CanCollide and (v.Position.Y + (v.Size.Y / 2)) > (rootpos.Y - lplr.Character.Humanoid.HipHeight) and (not Spider.Enabled or spiderHoldingShift) then
					PhaseModifiedParts[v] = true
					v.CanCollide = false
				end
			end
			for i,v in pairs(PhaseModifiedParts) do
				if not table.find(parts, i) then
					PhaseModifiedParts[i] = nil
					i.CanCollide = true
				end
			end
		end,
		Character = function()
			for i, part in pairs(lplr.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide and (not Spider.Enabled or spiderHoldingShift) then
					PhaseModifiedParts[part] = true
					part.CanCollide = Spider.Enabled and not spiderHoldingShift
				end
			end
		end,
		TP = function()
			local chars = {gameCamera, lplr.Character}
			for i, v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
			PhaseRaycast.FilterDescendantsInstances = chars
			local phaseRayCheck = workspace:Raycast(lplr.Character.Head.CFrame.p, lplr.Character.Humanoid.MoveDirection * 1.1, PhaseRaycast)
			if phaseRayCheck and (not Spider.Enabled or spiderHoldingShift) then
				local phaseDirection = phaseRayCheck.Normal.Z ~= 0 and "Z" or "X"
				if phaseRayCheck.Instance.Size[phaseDirection] <= PhaseStudLimit.Value then
					lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + (phaseRayCheck.Normal * (-(phaseRayCheck.Instance.Size[phaseDirection]) - (lplr.Character.HumanoidRootPart.Size.X / 1.5)))
				end
			end
		end
	}

	Phase = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Phase",
		Function = function(callback)
			if callback then
				RunLoops:BindToStepped("Phase", function() -- has to be ran on stepped idk why
					if isAlive(lplr, true) then
						PhaseFunctions[PhaseMode.Value]()
					end
				end)
			else
				RunLoops:UnbindFromStepped("Phase")
				for i,v in pairs(PhaseModifiedParts) do if i then i.CanCollide = true end end
				table.clear(PhaseModifiedParts)
			end
		end,
		HoverText = "Lets you Phase/Clip through walls. (Hold shift to use Phase over spider)"
	})
	PhaseMode = Phase.CreateDropdown({
		Name = "Mode",
		List = {"Part", "Character", "TP"},
		Function = function(val)
			if PhaseStudLimit.Object then
				PhaseStudLimit.Object.Visible = val == "TP"
			end
		end
	})
	PhaseStudLimit = Phase.CreateSlider({
		Name = "Studs",
		Function = function() end,
		Min = 1,
		Max = 20,
		Default = 5,
	})
end)

run(function()
	local SpiderSpeed = {Value = 0}
	local SpiderState = {Enabled = false}
	local SpiderMode = {Value = "Normal"}
	local SpiderRaycast = RaycastParams.new()
	SpiderRaycast.RespectCanCollide = true
	SpiderRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	local SpiderActive
	local SpiderPart

	local function clampSpiderPosition(dir, pos, size)
		local suc, res = pcall(function() return Vector3.new(math.clamp(dir.X, pos.X - (size.X / 2), pos.X + (size.X / 2)), math.clamp(dir.Y, pos.Y - (size.Y / 2), pos.Y + (size.Y / 2)), math.clamp(dir.Z, pos.Z - (size.Z / 2), pos.Z + (size.Z / 2))) end)
		return suc and res or Vector3.zero
	end

	Spider = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Spider",
		Function = function(callback)
			if callback then
				if SpiderPart then SpiderPart.Parent = gameCamera end
				RunLoops:BindToHeartbeat("Spider", function(delta)
					if isAlive(lplr, true) then
						local chars = {gameCamera, lplr.Character, SpiderPart}
						for i, v in pairs(entityLibrary.entityList) do table.insert(chars, v.Character) end
						SpiderRaycast.FilterDescendantsInstances = chars
						if SpiderMode.Value ~= "Classic" then
							local vec = lplr.Character.Humanoid.MoveDirection * 2
							local newray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, vec + Vector3.new(0, 0.1, 0), SpiderRaycast)
							local newray2 = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, vec - Vector3.new(0, lplr.Character.Humanoid.HipHeight, 0), SpiderRaycast)
							if SpiderActive and not newray and not newray2 then
								lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 0, lplr.Character.HumanoidRootPart.Velocity.Z)
							end
							SpiderActive = ((newray or newray2) and true or false)
							spiderHoldingShift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)
							if SpiderActive and (newray or newray2).Normal.Y == 0 then
								if not Phase.Enabled or not spiderHoldingShift then
									if SpiderState.Enabled then lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Climbing) end
									if SpiderMode.Value == "CFrame" then
										lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(-(lplr.Character.HumanoidRootPart.CFrame.lookVector.X * 18) * delta, SpiderSpeed.Value * delta, -(lplr.Character.HumanoidRootPart.CFrame.lookVector.Z * 18) * delta)
									else
										lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X - (lplr.Character.HumanoidRootPart.CFrame.lookVector.X / 2), SpiderSpeed.Value, lplr.Character.HumanoidRootPart.Velocity.Z - (lplr.Character.HumanoidRootPart.CFrame.lookVector.Z / 2))
									end
								end
							end
						else
							local vec = lplr.Character.HumanoidRootPart.CFrame.lookVector * 1.5
							local newray2 = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, (vec - Vector3.new(0, lplr.Character.Humanoid.HipHeight, 0)), SpiderRaycast)
							spiderHoldingShift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)
							if newray2 and (not Phase.Enabled or not spiderHoldingShift) then
								local newray2pos = newray2.Instance.Position
								local newpos = clampSpiderPosition(lplr.Character.HumanoidRootPart.Position, Vector3.new(newray2pos.X, math.min(lplr.Character.HumanoidRootPart.Position.Y, newray2pos.Y), newray2pos.Z), newray2.Instance.Size - Vector3.new(1.9, 1.9, 1.9))
								SpiderPart.Position = newpos
							else
								SpiderPart.Position = Vector3.zero
							end
						end
					end
				end)
			else
				if SpiderPart then SpiderPart.Parent = nil end
				RunLoops:UnbindFromHeartbeat("Spider")
			end
		end,
		HoverText = "Lets you climb up walls"
	})
	SpiderMode = Spider.CreateDropdown({
		Name = "Mode",
		List = {"Normal", "CFrame", "Classic"},
		Function = function(val)
			if SpiderPart then SpiderPart:Destroy() SpiderPart = nil end
			if val == "Classic" then
				SpiderPart = Instance.new("TrussPart")
				SpiderPart.Size = Vector3.new(2, 2, 2)
				SpiderPart.Transparency = 1
				SpiderPart.Anchored = true
				SpiderPart.Parent = Spider.Enabled and gameCamera or nil
			end
		end
	})
	SpiderSpeed = Spider.CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 100,
		Function = function() end,
		Default = 30
	})
	SpiderState = Spider.CreateToggle({
		Name = "Climb State",
		Function = function() end
	})
end)

run(function()
	local Speed = {Enabled = false}
	local SpeedValue = {Value = 1}
	local SpeedMethod = {Value = "AntiCheat A"}
	local SpeedMoveMethod = {Value = "MoveDirection"}
	local SpeedDelay = {Value = 0.7}
	local SpeedPulseDuration = {Value = 100}
	local SpeedWallCheck = {Enabled = true}
	local SpeedJump = {Enabled = false}
	local SpeedJumpHeight = {Value = 20}
	local SpeedJumpVanilla = {Enabled = false}
	local SpeedJumpAlways = {Enabled = false}
	local SpeedAnimation = {Enabled = false}
	local SpeedDelayTick = tick()
	local SpeedRaycast = RaycastParams.new()
	SpeedRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	SpeedRaycast.RespectCanCollide = true
	local oldWalkSpeed
	local SpeedDown
	local SpeedUp
	local w = 0
	local s = 0
	local a = 0
	local d = 0

	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C", "AntiCheat D"}
	Speed = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Speed",
		Function = function(callback)
			if callback then
				w = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				table.insert(Speed.Connections, inputService.InputBegan:Connect(function(input1)
					if inputService:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = -1
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = 1
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = -1
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = 1
						end
					end
				end))
				table.insert(Speed.Connections, inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = 0
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = 0
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = 0
					end
				end))
				local pulsetick = tick()
				task.spawn(function()
					repeat
						pulsetick = tick() + (SpeedPulseDuration.Value / 100)
						task.wait((SpeedDelay.Value / 10) + (SpeedPulseDuration.Value / 100))
					until (not Speed.Enabled)
				end)
				RunLoops:BindToHeartbeat("Speed", function(delta)
					if isAlive(lplr, true) and (typeof(lplr.Character.HumanoidRootPart) ~= "Instance" or isnetworkowner(lplr.Character.HumanoidRootPart)) then
						local movevec = (SpeedMoveMethod.Value == "Manual" and calculateMoveVector(Vector3.new(a + d, 0, w + s)) or lplr.Character.Humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero
						SpeedRaycast.FilterDescendantsInstances = {lplr.Character, cam}
						if SpeedMethod.Value == "Velocity" then
							if SpeedAnimation.Enabled then
								for i,v in pairs(lplr.Character.Humanoid:GetPlayingAnimationTracks()) do
									if v.Name == "WalkAnim" or v.Name == "RunAnim" then
										v:AdjustSpeed(lplr.Character.Humanoid.WalkSpeed / 16)
									end
								end
							end
							local newvelo = movevec * SpeedValue.Value
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, lplr.Character.HumanoidRootPart.Velocity.Y, newvelo.Z)
						elseif SpeedMethod.Value == "CFrame" then
							local newpos = (movevec * (math.max(SpeedValue.Value - lplr.Character.Humanoid.WalkSpeed, 0) * delta))
							if SpeedWallCheck.Enabled then
								local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, newpos, SpeedRaycast)
								if ray then newpos = (ray.Position - lplr.Character.HumanoidRootPart.Position) end
							end
							lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newpos
						elseif SpeedMethod.Value == "TP" then
							if SpeedDelayTick <= tick() then
								SpeedDelayTick = tick() + (SpeedDelay.Value / 10)
								local newpos = (movevec * SpeedValue.Value)
								if SpeedWallCheck.Enabled then
									local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, newpos, SpeedRaycast)
									if ray then newpos = (ray.Position - lplr.Character.HumanoidRootPart.Position) end
								end
								lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + newpos
							end
						elseif SpeedMethod.Value == "Pulse" then
							local pulsenum = (SpeedPulseDuration.Value / 100)
							local newvelo = movevec * (SpeedValue.Value + (lplr.Character.Humanoid.WalkSpeed - SpeedValue.Value) * (1 - (math.max(pulsetick - tick(), 0)) / pulsenum))
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(newvelo.X, lplr.Character.HumanoidRootPart.Velocity.Y, newvelo.Z)
						elseif SpeedMethod.Value == "WalkSpeed" then
							if oldWalkSpeed == nil then
								oldWalkSpeed = lplr.Character.Humanoid.WalkSpeed
							end
							lplr.Character.Humanoid.WalkSpeed = SpeedValue.Value
						end
						if SpeedJump.Enabled and (SpeedJumpAlways.Enabled or KillauraNearTarget) then
							if (lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air) and lplr.Character.Humanoid.MoveDirection ~= Vector3.zero then
								if SpeedJumpVanilla.Enabled then
									lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								else
									lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, SpeedJumpHeight.Value, lplr.Character.HumanoidRootPart.Velocity.Z)
								end
							end
						end
					end
				end)
			else
				SpeedDelayTick = 0
				if oldWalkSpeed then
					lplr.Character.Humanoid.WalkSpeed = oldWalkSpeed
					oldWalkSpeed = nil
				end
				RunLoops:UnbindFromHeartbeat("Speed")
			end
		end,
		ExtraText = function()
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"].Api.Enabled then
				return alternatelist[table.find(SpeedMethod.List, SpeedMethod.Value)]
			end
			return SpeedMethod.Value
		end
	})
	SpeedMethod = Speed.CreateDropdown({
		Name = "Mode",
		List = {"Velocity", "CFrame", "TP", "Pulse", "WalkSpeed"},
		Function = function(val)
			if oldWalkSpeed then
				lplr.Character.Humanoid.WalkSpeed = oldWalkSpeed
				oldWalkSpeed = nil
			end
			SpeedDelay.Object.Visible = val == "TP" or val == "Pulse"
			SpeedWallCheck.Object.Visible = val == "CFrame" or val == "TP"
			SpeedPulseDuration.Object.Visible = val == "Pulse"
			SpeedAnimation.Object.Visible = val == "Velocity"
		end
	})
	SpeedMoveMethod = Speed.CreateDropdown({
		Name = "Movement",
		List = {"Manual", "MoveDirection"},
		Function = function(val) end
	})
	SpeedValue = Speed.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 150,
		Function = function(val) end
	})
	SpeedDelay = Speed.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Function = function(val)
			SpeedDelayTick = tick() + (val / 10)
		end,
		Default = 7,
		Double = 10
	})
	SpeedPulseDuration = Speed.CreateSlider({
		Name = "Pulse Duration",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 50,
		Double = 100
	})
	SpeedJump = Speed.CreateToggle({
		Name = "AutoJump",
		Function = function(callback)
			if SpeedJumpHeight.Object then SpeedJumpHeight.Object.Visible = callback end
			if SpeedJumpAlways.Object then
				SpeedJump.Object.ToggleArrow.Visible = callback
				SpeedJumpAlways.Object.Visible = callback
			end
			if SpeedJumpVanilla.Object then SpeedJumpVanilla.Object.Visible = callback end
		end,
		Default = true
	})
	SpeedJumpHeight = Speed.CreateSlider({
		Name = "Jump Height",
		Min = 0,
		Max = 30,
		Default = 25,
		Function = function() end
	})
	SpeedJumpAlways = Speed.CreateToggle({
		Name = "Always Jump",
		Function = function() end
	})
	SpeedJumpVanilla = Speed.CreateToggle({
		Name = "Real Jump",
		Function = function() end
	})
	SpeedWallCheck = Speed.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	SpeedAnimation = Speed.CreateToggle({
		Name = "Slowdown Anim",
		Function = function() end
	})
end)

run(function()
	local SpinBot = {Enabled = false}
	local SpinBotX = {Enabled = false}
	local SpinBotY = {Enabled = false}
	local SpinBotZ = {Enabled = false}
	local SpinBotSpeed = {Value = 1}
	SpinBot = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "SpinBot",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("SpinBot", function()
					if isAlive(lplr, true) then
						local originalRotVelocity = lplr.Character.HumanoidRootPart.RotVelocity
						lplr.Character.HumanoidRootPart.RotVelocity = Vector3.new(SpinBotX.Enabled and SpinBotSpeed.Value or originalRotVelocity.X, SpinBotY.Enabled and SpinBotSpeed.Value or originalRotVelocity.Y, SpinBotZ.Enabled and SpinBotSpeed.Value or originalRotVelocity.Z)
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("SpinBot")
			end
		end,
		HoverText = "Makes your character spin around in circles (does not work in first person)"
	})
	SpinBotSpeed = SpinBot.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 100,
		Default = 40,
		Function = function() end
	})
	SpinBotX = SpinBot.CreateToggle({
		Name = "Spin X",
		Function = function() end
	})
	SpinBotY = SpinBot.CreateToggle({
		Name = "Spin Y",
		Function = function() end,
		Default = true
	})
	SpinBotZ = SpinBot.CreateToggle({
		Name = "Spin Z",
		Function = function() end
	})
end)

local GravityChangeTick = tick()
run(function()
	local Gravity = {Enabled = false}
	local GravityValue = {Value = 100}
	local oldGravity
	Gravity = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Gravity",
		Function = function(callback)
			if callback then
				oldGravity = workspace.Gravity
				workspace.Gravity = GravityValue.Value
				table.insert(Gravity.Connections, workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
					if GravityChangeTick > tick() then return end
					oldGravity = workspace.Gravity
					GravityChangeTick = tick() + 0.1
					workspace.Gravity = GravityValue.Value
				end))
			else
				workspace.Gravity = oldGravity
			end
		end,
		HoverText = "Changes workspace gravity"
	})
	GravityValue = Gravity.CreateSlider({
		Name = "Gravity",
		Min = 0,
		Max = 192,
		Function = function(val)
			if Gravity.Enabled then
				GravityChangeTick = tick() + 0.1
				workspace.Gravity = val
			end
		end,
		Default = 192
	})
end)

run(function()
    local ArrowsFolder = Instance.new("Folder")
    ArrowsFolder.Name = "ArrowsFolder"
    ArrowsFolder.Parent = GuiLibrary.MainGui
    local ArrowsFolderTable = {}
    local ArrowsColor = {Value = 0.44}
    local ArrowsTeammate = {Enabled = true}

    local arrowAddFunction = function(plr)
        if ArrowsTeammate.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
        local arrowObject = Instance.new("ImageLabel")
        arrowObject.BackgroundTransparency = 1
        arrowObject.BorderSizePixel = 0
        arrowObject.Size = UDim2.new(0, 256, 0, 256)
        arrowObject.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowObject.Position = UDim2.new(0.5, 0, 0.5, 0)
        arrowObject.Visible = false
        arrowObject.Image = downloadVapeAsset("vape/assets/ArrowIndicator.png")
		arrowObject.ImageColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(ArrowsColor.Hue, ArrowsColor.Sat, ArrowsColor.Value)
        arrowObject.Name = plr.Player.Name
        arrowObject.Parent = ArrowsFolder
        ArrowsFolderTable[plr.Player] = {entity = plr, Main = arrowObject}
    end

    local arrowRemoveFunction = function(ent)
        local v = ArrowsFolderTable[ent]
        ArrowsFolderTable[ent] = nil
        if v then v.Main:Destroy() end
    end

    local arrowColorFunction = function(hue, sat, val)
        local color = Color3.fromHSV(hue, sat, val)
        for i,v in pairs(ArrowsFolderTable) do
            v.Main.ImageColor3 = getPlayerColor(v.entity.Player) or color
        end
    end

    local arrowLoopFunction = function()
        for i,v in pairs(ArrowsFolderTable) do
            local rootPos, rootVis = worldtoscreenpoint(v.entity.RootPart.Position)
            if rootVis then
                v.Main.Visible = false
                continue
            end
            local camcframeflat = CFrame.new(gameCamera.CFrame.p, gameCamera.CFrame.p + gameCamera.CFrame.lookVector * Vector3.new(1, 0, 1))
            local pointRelativeToCamera = camcframeflat:pointToObjectSpace(v.entity.RootPart.Position)
            local unitRelativeVector = (pointRelativeToCamera * Vector3.new(1, 0, 1)).unit
            local rotation = math.atan2(unitRelativeVector.Z, unitRelativeVector.X)
            v.Main.Visible = true
            v.Main.Rotation = math.deg(rotation)
        end
    end

    local Arrows = {Enabled = false}
	Arrows = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
        Name = "Arrows",
        Function = function(callback)
            if callback then
				table.insert(Arrows.Connections, entityLibrary.entityRemovedEvent:Connect(arrowRemoveFunction))
				for i,v in pairs(entityLibrary.entityList) do
                    if ArrowsFolderTable[v.Player] then arrowRemoveFunction(v.Player) end
                    arrowAddFunction(v)
                end
                table.insert(Arrows.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
                    if ArrowsFolderTable[ent.Player] then arrowRemoveFunction(ent.Player) end
                    arrowAddFunction(ent)
                end))
				table.insert(Arrows.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
                    arrowColorFunction(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
                end))
				RunLoops:BindToRenderStep("Arrows", arrowLoopFunction)
            else
                RunLoops:UnbindFromRenderStep("Arrows")
				for i,v in pairs(ArrowsFolderTable) do
                    arrowRemoveFunction(i)
                end
            end
        end,
        HoverText = "Draws arrows on screen when entities\nare out of your field of view."
    })
    ArrowsColor = Arrows.CreateColorSlider({
        Name = "Player Color",
        Function = function(hue, sat, val)
			if Arrows.Enabled then
				arrowColorFunction(hue, sat, val)
			end
		end,
    })
    ArrowsTeammate = Arrows.CreateToggle({
        Name = "Teammate",
        Function = function() end,
        Default = true
    })
end)


run(function()
	local Disguise = {Enabled = false}
	local DisguiseId = {Value = ""}
	local DisguiseDescription

	local function Disguisechar(char)
		task.spawn(function()
			if not char then return end
			local hum = char:WaitForChild("Humanoid", 9e9)
			char:WaitForChild("Head", 9e9)
			local DisguiseDescription
			if DisguiseDescription == nil then
				local suc = false
				repeat
					suc = pcall(function()
						DisguiseDescription = playersService:GetHumanoidDescriptionFromUserId(DisguiseId.Value == "" and 239702688 or tonumber(DisguiseId.Value))
					end)
					if suc then break end
					task.wait(1)
				until suc or (not Disguise.Enabled)
			end
			if (not Disguise.Enabled) then return end
			local desc = hum:WaitForChild("HumanoidDescription", 2) or {HeightScale = 1, SetEmotes = function() end, SetEquippedEmotes = function() end}
			DisguiseDescription.HeightScale = desc.HeightScale
			char.Archivable = true
			local Disguiseclone = char:Clone()
			Disguiseclone.Name = "Disguisechar"
			Disguiseclone.Parent = workspace
			for i,v in pairs(Disguiseclone:GetChildren()) do
				if v:IsA("Accessory") or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") then
					v:Destroy()
				end
			end
			if not Disguiseclone:FindFirstChildWhichIsA("Humanoid") then
				Disguiseclone:Destroy()
				return
			end
			Disguiseclone.Humanoid:ApplyDescriptionClientServer(DisguiseDescription)
			for i,v in pairs(char:GetChildren()) do
				if (v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("Folder") or v:IsA("Model") then
					v.Parent = game
				end
			end
			char.ChildAdded:Connect(function(v)
				if ((v:IsA("Accessory") and v:GetAttribute("InvItem") == nil and v:GetAttribute("ArmorSlot") == nil) or v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors")) and v:GetAttribute("Disguise") == nil then
					repeat task.wait() v.Parent = game until v.Parent == game
				end
			end)
			for i,v in pairs(Disguiseclone:WaitForChild("Animate"):GetChildren()) do
				v:SetAttribute("Disguise", true)
				if not char:FindFirstChild("Animate") then return end
				local real = char.Animate:FindFirstChild(v.Name)
				if v:IsA("StringValue") and real then
					real.Parent = game
					v.Parent = char.Animate
				end
			end
			for i,v in pairs(Disguiseclone:GetChildren()) do
				v:SetAttribute("Disguise", true)
				if v:IsA("Accessory") then
					for i2,v2 in pairs(v:GetDescendants()) do
						if v2:IsA("Weld") and v2.Part1 then
							v2.Part1 = char[v2.Part1.Name]
						end
					end
					v.Parent = char
				elseif v:IsA("ShirtGraphic") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then
					v.Parent = char
				elseif v.Name == "Head" and char.Head:IsA("MeshPart") then
					char.Head.MeshId = v.MeshId
				end
			end
			local localface = char:FindFirstChild("face", true)
			local cloneface = Disguiseclone:FindFirstChild("face", true)
			if localface and cloneface then localface.Parent = game cloneface.Parent = char.Head end
			desc:SetEmotes(DisguiseDescription:GetEmotes())
			desc:SetEquippedEmotes(DisguiseDescription:GetEquippedEmotes())
			Disguiseclone:Destroy()
		end)
	end

	Disguise = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Disguise",
		Function = function(callback)
			if callback then
				table.insert(Disguise.Connections, lplr.CharacterAdded:Connect(Disguisechar))
				Disguisechar(lplr.Character)
			end
		end
	})
	DisguiseId = Disguise.CreateTextBox({
		Name = "Disguise",
		TempText = "Disguise User Id",
		FocusLost = function(enter)
			if Disguise.Enabled then
				Disguise.ToggleButton(false)
				Disguise.ToggleButton(false)
			end
		end
	})
end)

run(function()
	local ESPColor = {Value = 0.44}
	local ESPHealthBar = {Enabled = false}
	local ESPBoundingBox = {Enabled = true}
	local ESPName = {Enabled = true}
	local ESPMethod = {Value = "2D"}
	local ESPTeammates = {Enabled = true}
	local espfolderdrawing = {}
	local espconnections = {}
	local methodused

	local function floorESPPosition(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local function ESPWorldToViewport(pos)
		local newpos = worldtoviewportpoint(gameCamera.CFrame:pointToWorldSpace(gameCamera.CFrame:pointToObjectSpace(pos)))
		return Vector2.new(newpos.X, newpos.Y)
	end

	local espfuncs1 = {
		Drawing2D = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Quad1 = Drawing.new("Square")
			thing.Quad1.Transparency = ESPBoundingBox.Enabled and 1 or 0
			thing.Quad1.ZIndex = 2
			thing.Quad1.Filled = false
			thing.Quad1.Thickness = 1
			thing.Quad1.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			thing.QuadLine2 = Drawing.new("Square")
			thing.QuadLine2.Transparency = ESPBoundingBox.Enabled and 0.5 or 0
			thing.QuadLine2.ZIndex = 1
			thing.QuadLine2.Thickness = 1
			thing.QuadLine2.Filled = false
			thing.QuadLine2.Color = Color3.new()
			thing.QuadLine3 = Drawing.new("Square")
			thing.QuadLine3.Transparency = ESPBoundingBox.Enabled and 0.5 or 0
			thing.QuadLine3.ZIndex = 1
			thing.QuadLine3.Thickness = 1
			thing.QuadLine3.Filled = false
			thing.QuadLine3.Color = Color3.new()
			if ESPHealthBar.Enabled then
				thing.Quad3 = Drawing.new("Line")
				thing.Quad3.Thickness = 1
				thing.Quad3.ZIndex = 2
				thing.Quad3.Color = Color3.new(0, 1, 0)
				thing.Quad4 = Drawing.new("Line")
				thing.Quad4.Thickness = 3
				thing.Quad4.Transparency = 0.5
				thing.Quad4.ZIndex = 1
				thing.Quad4.Color = Color3.new()
			end
			if ESPName.Enabled then
				thing.Drop = Drawing.new("Text")
				thing.Drop.Color = Color3.new()
				thing.Drop.Text = whitelist:tag(plr.Player, true)..(plr.Player.DisplayName or plr.Player.Name)
				thing.Drop.ZIndex = 1
				thing.Drop.Center = true
				thing.Drop.Size = 20
				thing.Text = Drawing.new("Text")
				thing.Text.Text = thing.Drop.Text
				thing.Text.ZIndex = 2
				thing.Text.Color = thing.Quad1.Color
				thing.Text.Center = true
				thing.Text.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing2DV3 = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local toppoint = PointInstance.new(plr.RootPart, CFrame.new(2, 3, 0))
			local bottompoint = PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0))
			local newobj = RectDynamic.new(toppoint)
			newobj.BottomRight = bottompoint
			newobj.Outlined = ESPBoundingBox.Enabled
			newobj.Opacity = ESPBoundingBox.Enabled and 1 or 0
			newobj.OutlineOpacity = 0.5
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			local newobj2 = {}
			local newobj3 = {}
			if ESPHealthBar.Enabled then
				local topoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, 3, 0)), Vector2.new(-5, -1))
				local bottomoffset = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(-2, -3.5, 0)), Vector2.new(-3, 1))
				local healthoffset = PointOffset.new(bottomoffset, Vector2.new(0, -1))
				local healthoffset2 = PointOffset.new(bottomoffset, Vector2.new(-1, -((bottomoffset.ScreenPos.Y - topoffset.ScreenPos.Y) - 1)))
				newobj2.Bkg = RectDynamic.new(topoffset)
				newobj2.Bkg.Filled = true
				newobj2.Bkg.Opacity = 0.5
				newobj2.Bkg.BottomRight = bottomoffset
				newobj2.Line = RectDynamic.new(healthoffset)
				newobj2.Line.Filled = true
				newobj2.Line.YAlignment = YAlignment.Bottom
				newobj2.Line.BottomRight = healthoffset2
				newobj2.Line.Color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				newobj2.Offset = healthoffset2
				newobj2.TopOffset = topoffset
				newobj2.BottomOffset = bottomoffset
			end
			if ESPName.Enabled then
				local nameoffset1 = PointOffset.new(PointInstance.new(plr.RootPart, CFrame.new(0, 3, 0)), Vector2.new(0, -15))
				local nameoffset2 = PointOffset.new(nameoffset1, Vector2.new(1, 1))
				newobj3.Text = TextDynamic.new(nameoffset1)
				newobj3.Text.Text = whitelist:tag(plr.Player, true)..(plr.Player.DisplayName or plr.Player.Name)
				newobj3.Text.Color = newobj.Color
				newobj3.Text.ZIndex = 2
				newobj3.Text.Size = 20
				newobj3.Drop = TextDynamic.new(nameoffset2)
				newobj3.Drop.Text = newobj3.Text.Text
				newobj3.Drop.Color = Color3.new()
				newobj3.Drop.ZIndex = 1
				newobj3.Drop.Size = 20
			end
			espfolderdrawing[plr.Player] = {entity = plr, Main = newobj, HealthBar = newobj2, Name = newobj3}
		end,
		DrawingSkeleton = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Head = Drawing.new("Line")
			thing.Head2 = Drawing.new("Line")
			thing.Torso = Drawing.new("Line")
			thing.Torso2 = Drawing.new("Line")
			thing.Torso3 = Drawing.new("Line")
			thing.LeftArm = Drawing.new("Line")
			thing.RightArm = Drawing.new("Line")
			thing.LeftLeg = Drawing.new("Line")
			thing.RightLeg = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		DrawingSkeletonV3 = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {Main = {}, entity = plr}
			local rigcheck = plr.Humanoid.RigType == Enum.HumanoidRigType.R6
			local head = PointInstance.new(plr.Head)
			head.RotationType = CFrameRotationType.TargetRelative
			local headfront = PointInstance.new(plr.Head, CFrame.new(0, 0, -0.5))
			headfront.RotationType = CFrameRotationType.TargetRelative
			local toplefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-1.5, 0.8, 0))
			toplefttorso.RotationType = CFrameRotationType.TargetRelative
			local toprighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(1.5, 0.8, 0))
			toprighttorso.RotationType = CFrameRotationType.TargetRelative
			local toptorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, 0.8, 0))
			toptorso.RotationType = CFrameRotationType.TargetRelative
			local bottomtorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0, -0.8, 0))
			bottomtorso.RotationType = CFrameRotationType.TargetRelative
			local bottomlefttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(-0.5, -0.8, 0))
			bottomlefttorso.RotationType = CFrameRotationType.TargetRelative
			local bottomrighttorso = PointInstance.new(plr.Character[(rigcheck and "Torso" or "UpperTorso")], CFrame.new(0.5, -0.8, 0))
			bottomrighttorso.RotationType = CFrameRotationType.TargetRelative
			local leftarm = PointInstance.new(plr.Character[(rigcheck and "Left Arm" or "LeftHand")], CFrame.new(0, -0.8, 0))
			leftarm.RotationType = CFrameRotationType.TargetRelative
			local rightarm = PointInstance.new(plr.Character[(rigcheck and "Right Arm" or "RightHand")], CFrame.new(0, -0.8, 0))
			rightarm.RotationType = CFrameRotationType.TargetRelative
			local leftleg = PointInstance.new(plr.Character[(rigcheck and "Left Leg" or "LeftFoot")], CFrame.new(0, -0.8, 0))
			leftleg.RotationType = CFrameRotationType.TargetRelative
			local rightleg = PointInstance.new(plr.Character[(rigcheck and "Right Leg" or "RightFoot")], CFrame.new(0, -0.8, 0))
			rightleg.RotationType = CFrameRotationType.TargetRelative
			thing.Main.Head = LineDynamic.new(toptorso, head)
			thing.Main.Head2 = LineDynamic.new(head, headfront)
			thing.Main.Torso = LineDynamic.new(toplefttorso, toprighttorso)
			thing.Main.Torso2 = LineDynamic.new(toptorso, bottomtorso)
			thing.Main.Torso3 = LineDynamic.new(bottomlefttorso, bottomrighttorso)
			thing.Main.LeftArm = LineDynamic.new(toplefttorso, leftarm)
			thing.Main.RightArm = LineDynamic.new(toprighttorso, rightarm)
			thing.Main.LeftLeg = LineDynamic.new(bottomlefttorso, leftleg)
			thing.Main.RightLeg = LineDynamic.new(bottomrighttorso, rightleg)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing.Main) do v.Thickness = 2 v.Color = color end
			espfolderdrawing[plr.Player] = thing
		end,
		Drawing3D = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			thing.Line1 = Drawing.new("Line")
			thing.Line2 = Drawing.new("Line")
			thing.Line3 = Drawing.new("Line")
			thing.Line4 = Drawing.new("Line")
			thing.Line5 = Drawing.new("Line")
			thing.Line6 = Drawing.new("Line")
			thing.Line7 = Drawing.new("Line")
			thing.Line8 = Drawing.new("Line")
			thing.Line9 = Drawing.new("Line")
			thing.Line10 = Drawing.new("Line")
			thing.Line11 = Drawing.new("Line")
			thing.Line12 = Drawing.new("Line")
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing3DV3 = function(plr)
			if ESPTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {}
			local point1 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, 1.5))
			point1.RotationType = CFrameRotationType.Ignore
			local point2 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, 1.5))
			point2.RotationType = CFrameRotationType.Ignore
			local point3 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, 1.5))
			point3.RotationType = CFrameRotationType.Ignore
			local point4 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, 1.5))
			point4.RotationType = CFrameRotationType.Ignore
			local point5 = PointInstance.new(plr.RootPart, CFrame.new(1.5, 3, -1.5))
			point5.RotationType = CFrameRotationType.Ignore
			local point6 = PointInstance.new(plr.RootPart, CFrame.new(1.5, -3, -1.5))
			point6.RotationType = CFrameRotationType.Ignore
			local point7 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, 3, -1.5))
			point7.RotationType = CFrameRotationType.Ignore
			local point8 = PointInstance.new(plr.RootPart, CFrame.new(-1.5, -3, -1.5))
			point8.RotationType = CFrameRotationType.Ignore
			thing.Line1 = LineDynamic.new(point1, point2)
			thing.Line2 = LineDynamic.new(point3, point4)
			thing.Line3 = LineDynamic.new(point5, point6)
			thing.Line4 = LineDynamic.new(point7, point8)
			thing.Line5 = LineDynamic.new(point1, point3)
			thing.Line6 = LineDynamic.new(point1, point5)
			thing.Line7 = LineDynamic.new(point5, point7)
			thing.Line8 = LineDynamic.new(point7, point3)
			thing.Line9 = LineDynamic.new(point2, point4)
			thing.Line10 = LineDynamic.new(point2, point6)
			thing.Line11 = LineDynamic.new(point6, point8)
			thing.Line12 = LineDynamic.new(point8, point4)
			local color = getPlayerColor(plr.Player) or Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			for i,v in pairs(thing) do v.Thickness = 1 v.Color = color end
			espfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end
	}
	local espfuncs2 = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				v.Main.Visible = false
				for i2,v2 in pairs(v.HealthBar) do
					if typeof(v2):find("Point") == nil then
						v2.Visible = false
					end
				end
				for i2,v2 in pairs(v.Name) do
					if typeof(v2):find("Point") == nil then
						v2.Visible = false
					end
				end
			end
		end,
		Drawing3D = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		Drawing3DV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then
						v2.Visible = false
					end
				end
			end
		end,
		DrawingSkeleton = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end,
		DrawingSkeletonV3 = function(ent)
			local v = espfolderdrawing[ent]
			espfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then
						v2.Visible = false
					end
				end
			end
		end
	}
	local espupdatefuncs = {
		Drawing2D = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.Main.Quad3 then
				local color = Color3.fromHSV(math.clamp(ent.Humanoid.Health / ent.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				v.Main.Quad3.Color = color
			end
			if v and v.Text then
				v.Text.Text = whitelist:tag(ent.Player, true)..(ent.Player.DisplayName or ent.Player.Name)
				v.Drop.Text = v.Text.Text
			end
		end,
		Drawing2DV3 = function(ent)
			local v = espfolderdrawing[ent.Player]
			if v and v.HealthBar.Line then
				local health = ent.Humanoid.Health / ent.Humanoid.MaxHealth
				local color = Color3.fromHSV(math.clamp(health, 0, 1) / 2.5, 0.89, 1)
				v.HealthBar.Line.Color = color
			end
			if v and v.Name and v.Name.Text then
				v.Name.Text.Text = whitelist:tag(ent.Player, true)..(ent.Player.DisplayName or ent.Player.Name)
				v.Name.Drop.Text = v.Name.Text.Text
			end
		end
	}
	local espcolorfuncs = {
		Drawing2D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do
				v.Main.Quad1.Color = getPlayerColor(v.entity.Player) or color
				if v.Main.Text then
					v.Main.Text.Color = v.Main.Quad1.Color
				end
			end
		end,
		Drawing2DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do
				v.Main.Color = getPlayerColor(v.entity.Player) or color
				if v.Name.Text then
					v.Name.Text.Color = v.Main.Color
				end
			end
		end,
		Drawing3D = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					v2.Color = newcolor
				end
			end
		end,
		Drawing3DV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then
						v2.Color = newcolor
					end
				end
			end
		end,
		DrawingSkeleton = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					v2.Color = newcolor
				end
			end
		end,
		DrawingSkeletonV3 = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(espfolderdrawing) do
				local newcolor = getPlayerColor(v.entity.Player) or color
				for i2,v2 in pairs(v.Main) do
					if typeof(v2):find("Dynamic") then
						v2.Color = newcolor
					end
				end
			end
		end,
	}
	local esploop = {
		Drawing2D = function()
			for i,v in pairs(espfolderdrawing) do
				local rootPos, rootVis = worldtoviewportpoint(v.entity.RootPart.Position)
				if not rootVis then
					v.Main.Quad1.Visible = false
					v.Main.QuadLine2.Visible = false
					v.Main.QuadLine3.Visible = false
					if v.Main.Quad3 then
						v.Main.Quad3.Visible = false
						v.Main.Quad4.Visible = false
					end
					if v.Main.Text then
						v.Main.Text.Visible = false
						v.Main.Drop.Visible = false
					end
					continue
				end
				local topPos, topVis = worldtoviewportpoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + gameCamera.CFrame.lookVector) * CFrame.new(2, 3, 0)).p)
				local bottomPos, bottomVis = worldtoviewportpoint((CFrame.new(v.entity.RootPart.Position, v.entity.RootPart.Position + gameCamera.CFrame.lookVector) * CFrame.new(-2, -3.5, 0)).p)
				local sizex, sizey = topPos.X - bottomPos.X, topPos.Y - bottomPos.Y
				local posx, posy = (rootPos.X - sizex / 2),  ((rootPos.Y - sizey / 2))
				v.Main.Quad1.Position = floorESPPosition(Vector2.new(posx, posy))
				v.Main.Quad1.Size = floorESPPosition(Vector2.new(sizex, sizey))
				v.Main.Quad1.Visible = true
				v.Main.QuadLine2.Position = floorESPPosition(Vector2.new(posx - 1, posy + 1))
				v.Main.QuadLine2.Size = floorESPPosition(Vector2.new(sizex + 2, sizey - 2))
				v.Main.QuadLine2.Visible = true
				v.Main.QuadLine3.Position = floorESPPosition(Vector2.new(posx + 1, posy - 1))
				v.Main.QuadLine3.Size = floorESPPosition(Vector2.new(sizex - 2, sizey + 2))
				v.Main.QuadLine3.Visible = true
				if v.Main.Quad3 then
					local healthposy = sizey * math.clamp(v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth, 0, 1)
					v.Main.Quad3.Visible = v.entity.Humanoid.Health > 0
					v.Main.Quad3.From = floorESPPosition(Vector2.new(posx - 4, posy + (sizey - (sizey - healthposy))))
					v.Main.Quad3.To = floorESPPosition(Vector2.new(posx - 4, posy))
					v.Main.Quad4.Visible = true
					v.Main.Quad4.From = floorESPPosition(Vector2.new(posx - 4, posy))
					v.Main.Quad4.To = floorESPPosition(Vector2.new(posx - 4, (posy + sizey)))
				end
				if v.Main.Text then
					v.Main.Text.Visible = true
					v.Main.Drop.Visible = true
					v.Main.Text.Position = floorESPPosition(Vector2.new(posx + (sizex / 2), posy + (sizey - 25)))
					v.Main.Drop.Position = v.Main.Text.Position + Vector2.new(1, 1)
				end
			end
		end,
		Drawing2DV3 = function()
			for i,v in pairs(espfolderdrawing) do
				if v.HealthBar.Offset then
					v.HealthBar.Offset.Offset = Vector2.new(-1, -(((v.HealthBar.BottomOffset.ScreenPos.Y - v.HealthBar.TopOffset.ScreenPos.Y) - 1) * (v.entity.Humanoid.Health / v.entity.Humanoid.MaxHealth)))
					v.HealthBar.Line.Visible = v.entity.Humanoid.Health > 0
				end
			end
		end,
		Drawing3D = function()
			for i,v in pairs(espfolderdrawing) do
				local rootPos, rootVis = worldtoviewportpoint(v.entity.RootPart.Position)
				if not rootVis then
					for i,v in pairs(v.Main) do
						v.Visible = false
					end
					continue
				end
				for i,v in pairs(v.Main) do
					v.Visible = true
				end
				local point1 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, 3, 1.5))
				local point2 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, -3, 1.5))
				local point3 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, 3, 1.5))
				local point4 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, -3, 1.5))
				local point5 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, 3, -1.5))
				local point6 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(1.5, -3, -1.5))
				local point7 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, 3, -1.5))
				local point8 = ESPWorldToViewport(v.entity.RootPart.Position + Vector3.new(-1.5, -3, -1.5))
				v.Main.Line1.From = point1
				v.Main.Line1.To = point2
				v.Main.Line2.From = point3
				v.Main.Line2.To = point4
				v.Main.Line3.From = point5
				v.Main.Line3.To = point6
				v.Main.Line4.From = point7
				v.Main.Line4.To = point8
				v.Main.Line5.From = point1
				v.Main.Line5.To = point3
				v.Main.Line6.From = point1
				v.Main.Line6.To = point5
				v.Main.Line7.From = point5
				v.Main.Line7.To = point7
				v.Main.Line8.From = point7
				v.Main.Line8.To = point3
				v.Main.Line9.From = point2
				v.Main.Line9.To = point4
				v.Main.Line10.From = point2
				v.Main.Line10.To = point6
				v.Main.Line11.From = point6
				v.Main.Line11.To = point8
				v.Main.Line12.From = point8
				v.Main.Line12.To = point4
			end
		end,
		DrawingSkeleton = function()
			for i,v in pairs(espfolderdrawing) do
				local rootPos, rootVis = worldtoviewportpoint(v.entity.RootPart.Position)
				if not rootVis then
					for i,v in pairs(v.Main) do
						v.Visible = false
					end
					continue
				end
				for i,v in pairs(v.Main) do
					v.Visible = true
				end
				local rigcheck = v.entity.Humanoid.RigType == Enum.HumanoidRigType.R6
				local head = ESPWorldToViewport((v.entity.Head.CFrame).p)
				local headfront = ESPWorldToViewport((v.entity.Head.CFrame * CFrame.new(0, 0, -0.5)).p)
				local toplefttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-1.5, 0.8, 0)).p)
				local toprighttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(1.5, 0.8, 0)).p)
				local toptorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, 0.8, 0)).p)
				local bottomtorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local bottomlefttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(-0.5, -0.8, 0)).p)
				local bottomrighttorso = ESPWorldToViewport((v.entity.Character[(rigcheck and "Torso" or "UpperTorso")].CFrame * CFrame.new(0.5, -0.8, 0)).p)
				local leftarm = ESPWorldToViewport((v.entity.Character[(rigcheck and "Left Arm" or "LeftHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightarm = ESPWorldToViewport((v.entity.Character[(rigcheck and "Right Arm" or "RightHand")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local leftleg = ESPWorldToViewport((v.entity.Character[(rigcheck and "Left Leg" or "LeftFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				local rightleg = ESPWorldToViewport((v.entity.Character[(rigcheck and "Right Leg" or "RightFoot")].CFrame * CFrame.new(0, -0.8, 0)).p)
				v.Main.Torso.From = toplefttorso
				v.Main.Torso.To = toprighttorso
				v.Main.Torso2.From = toptorso
				v.Main.Torso2.To = bottomtorso
				v.Main.Torso3.From = bottomlefttorso
				v.Main.Torso3.To = bottomrighttorso
				v.Main.LeftArm.From = toplefttorso
				v.Main.LeftArm.To = leftarm
				v.Main.RightArm.From = toprighttorso
				v.Main.RightArm.To = rightarm
				v.Main.LeftLeg.From = bottomlefttorso
				v.Main.LeftLeg.To = leftleg
				v.Main.RightLeg.From = bottomrighttorso
				v.Main.RightLeg.To = rightleg
				v.Main.Head.From = toptorso
				v.Main.Head.To = head
				v.Main.Head2.From = head
				v.Main.Head2.To = headfront
			end
		end
	}

	local ESP = {Enabled = false}
	ESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ESP",
		Function = function(callback)
			if callback then
				methodused = "Drawing"..ESPMethod.Value..synapsev3
				if espfuncs2[methodused] then
					table.insert(ESP.Connections, entityLibrary.entityRemovedEvent:Connect(espfuncs2[methodused]))
				end
				if espfuncs1[methodused] then
					local addfunc = espfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do
						if espfolderdrawing[v.Player] then espfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(ESP.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if espfolderdrawing[ent.Player] then espfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if espupdatefuncs[methodused] then
					table.insert(ESP.Connections, entityLibrary.entityUpdatedEvent:Connect(espupdatefuncs[methodused]))
					for i,v in pairs(entityLibrary.entityList) do
						espupdatefuncs[methodused](v)
					end
				end
				if espcolorfuncs[methodused] then
					table.insert(ESP.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						espcolorfuncs[methodused](ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
					end))
				end
				if esploop[methodused] then
					RunLoops:BindToRenderStep("ESP", esploop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("ESP")
				if espfuncs2[methodused] then
					for i,v in pairs(espfolderdrawing) do
						espfuncs2[methodused](i)
					end
				end
			end
		end,
		HoverText = "Extra Sensory Perception\nRenders an ESP on players."
	})
	ESPColor = ESP.CreateColorSlider({
		Name = "Player Color",
		Function = function(hue, sat, val)
			if ESP.Enabled and espcolorfuncs[methodused] then
				espcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	ESPMethod = ESP.CreateDropdown({
		Name = "Mode",
		List = {"2D", "3D", "Skeleton"},
		Function = function(val)
			if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end
			ESPBoundingBox.Object.Visible = (val == "2D")
			ESPHealthBar.Object.Visible = (val == "2D")
			ESPName.Object.Visible = (val == "2D")
		end,
	})
	ESPBoundingBox = ESP.CreateToggle({
		Name = "Bounding Box",
		Function = function() if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end,
		Default = true
	})
	ESPTeammates = ESP.CreateToggle({
		Name = "Priority Only",
		Function = function() if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end,
		Default = true
	})
	ESPHealthBar = ESP.CreateToggle({
		Name = "Health Bar",
		Function = function(callback) if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end
	})
	ESPName = ESP.CreateToggle({
		Name = "Name",
		Function = function(callback) if ESP.Enabled then ESP.ToggleButton(true) ESP.ToggleButton(true) end end
	})
end)


run(function()
	local ChamsFolder = Instance.new("Folder")
	ChamsFolder.Name = "ChamsFolder"
	ChamsFolder.Parent = GuiLibrary.MainGui
	local chamstable = {}
	local ChamsColor = {Value = 0.44}
	local ChamsOutlineColor = {Value = 0.44}
	local ChamsTransparency = {Value = 1}
	local ChamsOutlineTransparency = {Value = 1}
	local ChamsOnTop = {Enabled = true}
	local ChamsTeammates = {Enabled = true}

	local function addfunc(ent)
		local chamfolder = Instance.new("Highlight")
		chamfolder.Name = ent.Player.Name
		chamfolder.Enabled = true
		chamfolder.Adornee = ent.Character
		chamfolder.OutlineTransparency = ChamsOutlineTransparency.Value / 100
		chamfolder.DepthMode = Enum.HighlightDepthMode[(ChamsOnTop.Enabled and "AlwaysOnTop" or "Occluded")]
		chamfolder.FillColor = getPlayerColor(ent.Player) or Color3.fromHSV(ChamsColor.Hue, ChamsColor.Sat, ChamsColor.Value)
		chamfolder.OutlineColor = getPlayerColor(ent.Player) or Color3.fromHSV(ChamsOutlineColor.Hue, ChamsOutlineColor.Sat, ChamsOutlineColor.Value)
		chamfolder.FillTransparency = ChamsTransparency.Value / 100
		chamfolder.Parent = ChamsFolder
		chamstable[ent.Player] = {Main = chamfolder, entity = ent}
	end

	local function removefunc(ent)
		local v = chamstable[ent]
		chamstable[ent] = nil
		if v then
			v.Main:Destroy()
		end
	end

	local Chams = {Enabled = false}
	Chams = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Chams",
		Function = function(callback)
			if callback then
				table.insert(Chams.Connections, entityLibrary.entityRemovedEvent:Connect(removefunc))
				for i,v in pairs(entityLibrary.entityList) do
					if chamstable[v.Player] then removefunc(v.Player) end
					addfunc(v)
				end
				table.insert(Chams.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
					if chamstable[ent.Player] then removefunc(ent.Player) end
					addfunc(ent)
				end))
				table.insert(Chams.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
					for i,v in pairs(chamstable) do
						v.Main.FillColor = getPlayerColor(i) or Color3.fromHSV(ChamsColor.Hue, ChamsColor.Sat, ChamsColor.Value)
						v.Main.OutlineColor = getPlayerColor(i) or Color3.fromHSV(ChamsOutlineColor.Hue, ChamsOutlineColor.Sat, ChamsOutlineColor.Value)
					end
				end))
			else
				for i,v in pairs(chamstable) do
					removefunc(i)
				end
			end
		end,
		HoverText = "Render players through walls"
	})
	ChamsColor = Chams.CreateColorSlider({
		Name = "Player Color",
		Function = function(val)
			for i,v in pairs(chamstable) do
				v.Main.FillColor = getPlayerColor(i) or Color3.fromHSV(ChamsColor.Hue, ChamsColor.Sat, ChamsColor.Value)
			end
		end
	})
	ChamsOutlineColor = Chams.CreateColorSlider({
		Name = "Outline Player Color",
		Function = function(val)
			for i,v in pairs(chamstable) do
				v.Main.OutlineColor = getPlayerColor(i) or Color3.fromHSV(ChamsOutlineColor.Hue, ChamsOutlineColor.Sat, ChamsOutlineColor.Value)
			end
		end
	})
	ChamsTransparency = Chams.CreateSlider({
		Name = "Transparency",
		Min = 1,
		Max = 100,
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end,
		Default = 50
	})
	ChamsOutlineTransparency = Chams.CreateSlider({
		Name = "Outline Transparency",
		Min = 1,
		Max = 100,
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end,
		Default = 1
	})
	ChamsTeammates = Chams.CreateToggle({
		Name = "Teammates",
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end,
		Default = true
	})
	ChamsOnTop = Chams.CreateToggle({
		Name = "Bypass Walls",
		Function = function(callback) if Chams.Enabled then Chams.ToggleButton(true) Chams.ToggleButton(true) end end
	})
end)

run(function()
	local lightingsettings = {}
	local lightingchanged = false
	local Fullbright = {Enabled = false}
	Fullbright = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Fullbright",
		Function = function(callback)
			if callback then
				lightingsettings.Brightness = lightingService.Brightness
				lightingsettings.ClockTime = lightingService.ClockTime
				lightingsettings.FogEnd = lightingService.FogEnd
				lightingsettings.GlobalShadows = lightingService.GlobalShadows
				lightingsettings.OutdoorAmbient = lightingService.OutdoorAmbient
				lightingchanged = true
				lightingService.Brightness = 2
				lightingService.ClockTime = 14
				lightingService.FogEnd = 100000
				lightingService.GlobalShadows = false
				lightingService.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
				lightingchanged = false
				table.insert(Fullbright.Connections, lightingService.Changed:Connect(function()
					if not lightingchanged then
						lightingsettings.Brightness = lightingService.Brightness
						lightingsettings.ClockTime = lightingService.ClockTime
						lightingsettings.FogEnd = lightingService.FogEnd
						lightingsettings.GlobalShadows = lightingService.GlobalShadows
						lightingsettings.OutdoorAmbient = lightingService.OutdoorAmbient
						lightingchanged = true
						lightingService.Brightness = 2
						lightingService.ClockTime = 14
						lightingService.FogEnd = 100000
						lightingService.GlobalShadows = false
						lightingService.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
						lightingchanged = false
					end
				end))
			else
				for name, val in pairs(lightingsettings) do
					lightingService[name] = val
				end
			end
		end
	})
end)

run(function()
	local Health = {Enabled = false}
	Health =  GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Health",
		Function = function(callback)
			if callback then
				HealthText = Drawing.new("Text")
				HealthText.Size = 20
				HealthText.Text = "100HP"
				HealthText.Position = Vector2.new(0, 0)
				HealthText.Color = Color3.fromRGB(0, 255, 0)
				HealthText.Center = true
				HealthText.Visible = true
				task.spawn(function()
					repeat
						if isAlive(lplr, true) then
							HealthText.Text = tostring(math.round(lplr.Character.Humanoid.Health)).."HP"
							HealthText.Color = Color3.fromHSV(math.clamp(lplr.Character.Humanoid.Health / lplr.Character.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
						end
						HealthText.Position = Vector2.new(gameCamera.ViewportSize.X / 2, gameCamera.ViewportSize.Y / 2 + 70)
						task.wait(0.1)
					until not Health.Enabled
				end)
			else
				if HealthText then HealthText:Remove() end
				RunLoops:UnbindFromRenderStep("Health")
			end
		end,
		HoverText = "Displays your health in the center of your screen."
	})
end)

run(function()
	local function floorNameTagPosition(pos)
		return Vector2.new(math.floor(pos.X), math.floor(pos.Y))
	end

	local NameTagsFolder = Instance.new("Folder")
	NameTagsFolder.Name = "NameTagsFolder"
	NameTagsFolder.Parent = GuiLibrary.MainGui
	local nametagsfolderdrawing = {}
	local NameTagsColor = {Value = 0.44}
	local NameTagsDisplayName = {Enabled = false}
	local NameTagsHealth = {Enabled = false}
	local NameTagsDistance = {Enabled = false}
	local NameTagsBackground = {Enabled = true}
	local NameTagsScale = {Value = 10}
	local NameTagsFont = {Value = "SourceSans"}
	local NameTagsTeammates = {Enabled = true}
	local fontitems = {"SourceSans"}
	local nametagstrs = {}
	local nametagsizes = {}

	local nametagfuncs1 = {
		Normal = function(plr)
			if NameTagsTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = Instance.new("TextLabel")
			thing.BackgroundColor3 = Color3.new()
			thing.BorderSizePixel = 0
			thing.Visible = false
			thing.RichText = true
			thing.AnchorPoint = Vector2.new(0.5, 1)
			thing.Name = plr.Player.Name
			thing.Font = Enum.Font[NameTagsFont.Value]
			thing.TextSize = 14 * (NameTagsScale.Value / 10)
			thing.BackgroundTransparency = NameTagsBackground.Enabled and 0.5 or 1
			nametagstrs[plr.Player] = whitelist:tag(plr.Player, true)..(NameTagsDisplayName.Enabled and plr.Player.DisplayName or plr.Player.Name)
			if NameTagsHealth.Enabled then
				local color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				nametagstrs[plr.Player] = nametagstrs[plr.Player]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(plr.Humanoid.Health).."</font>"
			end
			if NameTagsDistance.Enabled then
				nametagstrs[plr.Player] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..nametagstrs[plr.Player]
			end
			local nametagSize = textService:GetTextSize(removeTags(nametagstrs[plr.Player]), thing.TextSize, thing.Font, Vector2.new(100000, 100000))
			thing.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
			thing.Text = nametagstrs[plr.Player]
			thing.TextColor3 = getPlayerColor(plr.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			thing.Parent = NameTagsFolder
			nametagsfolderdrawing[plr.Player] = {entity = plr, Main = thing}
		end,
		Drawing = function(plr)
			if NameTagsTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local thing = {Main = {}, entity = plr}
			thing.Main.Text = Drawing.new("Text")
			thing.Main.Text.Size = 17 * (NameTagsScale.Value / 10)
			thing.Main.Text.Font = (math.clamp((table.find(fontitems, NameTagsFont.Value) or 1) - 1, 0, 3))
			thing.Main.Text.ZIndex = 2
			thing.Main.BG = Drawing.new("Square")
			thing.Main.BG.Filled = true
			thing.Main.BG.Transparency = 0.5
			thing.Main.BG.Visible = NameTagsBackground.Enabled
			thing.Main.BG.Color = Color3.new()
			thing.Main.BG.ZIndex = 1
			nametagstrs[plr.Player] = whitelist:tag(plr.Player, true)..(NameTagsDisplayName.Enabled and plr.Player.DisplayName or plr.Player.Name)
			if NameTagsHealth.Enabled then
				local color = Color3.fromHSV(math.clamp(plr.Humanoid.Health / plr.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
				nametagstrs[plr.Player] = nametagstrs[plr.Player]..' '..math.round(plr.Humanoid.Health)
			end
			if NameTagsDistance.Enabled then
				nametagstrs[plr.Player] = '[%s] '..nametagstrs[plr.Player]
			end
			thing.Main.Text.Text = nametagstrs[plr.Player]
			thing.Main.BG.Size = Vector2.new(thing.Main.Text.TextBounds.X + 4, thing.Main.Text.TextBounds.Y)
			thing.Main.Text.Color = getPlayerColor(plr.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			nametagsfolderdrawing[plr.Player] = thing
		end
	}

	local nametagfuncs2 = {
		Normal = function(ent)
			local v = nametagsfolderdrawing[ent]
			nametagsfolderdrawing[ent] = nil
			if v then
				v.Main:Destroy()
			end
		end,
		Drawing = function(ent)
			local v = nametagsfolderdrawing[ent]
			nametagsfolderdrawing[ent] = nil
			if v then
				for i2,v2 in pairs(v.Main) do
					pcall(function() v2.Visible = false v2:Remove() end)
				end
			end
		end
	}

	local nametagupdatefuncs = {
		Normal = function(ent)
			local v = nametagsfolderdrawing[ent.Player]
			if v then
				nametagstrs[ent.Player] = whitelist:tag(ent.Player, true)..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				if NameTagsHealth.Enabled then
					local color = Color3.fromHSV(math.clamp(ent.Humanoid.Health / ent.Humanoid.MaxHealth, 0, 1) / 2.5, 0.89, 1)
					nametagstrs[ent.Player] = nametagstrs[ent.Player]..' <font color="rgb('..tostring(math.floor(color.R * 255))..','..tostring(math.floor(color.G * 255))..','..tostring(math.floor(color.B * 255))..')">'..math.round(ent.Humanoid.Health).."</font>"
				end
				if NameTagsDistance.Enabled then
					nametagstrs[ent.Player] = '<font color="rgb(85, 255, 85)">[</font><font color="rgb(255, 255, 255)">%s</font><font color="rgb(85, 255, 85)">]</font> '..nametagstrs[ent.Player]
				end
				local nametagSize = textService:GetTextSize(removeTags(nametagstrs[ent.Player]), v.Main.TextSize, v.Main.Font, Vector2.new(100000, 100000))
				v.Main.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
				v.Main.Text = nametagstrs[ent.Player]
			end
		end,
		Drawing = function(ent)
			local v = nametagsfolderdrawing[ent.Player]
			if v then
				nametagstrs[ent.Player] = whitelist:tag(ent.Player, true)..(NameTagsDisplayName.Enabled and ent.Player.DisplayName or ent.Player.Name)
				if NameTagsHealth.Enabled then
					nametagstrs[ent.Player] = nametagstrs[ent.Player]..' '..math.round(ent.Humanoid.Health)
				end
				if NameTagsDistance.Enabled then
					nametagstrs[ent.Player] = '[%s] '..nametagstrs[ent.Player]
					v.Main.Text.Text = isAlive(lplr, true) and string.format(nametagstrs[ent.Player], math.floor((lplr.Character.HumanoidRootPart.Position - ent.RootPart.Position).Magnitude)) or nametagstrs[ent.Player]
				else
					v.Main.Text.Text = nametagstrs[ent.Player]
				end
				v.Main.BG.Size = Vector2.new(v.Main.Text.TextBounds.X + 4, v.Main.Text.TextBounds.Y)
				v.Main.Text.Color = getPlayerColor(ent.Player) or Color3.fromHSV(NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
			end
		end
	}

	local nametagcolorfuncs = {
		Normal = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(nametagsfolderdrawing) do
				v.Main.TextColor3 = getPlayerColor(v.entity.Player) or color
			end
		end,
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(nametagsfolderdrawing) do
				v.Main.Text.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}

	local nametagloop = {
		Normal = function()
			for i,v in pairs(nametagsfolderdrawing) do
				local headPos, headVis = worldtoscreenpoint((v.entity.RootPart:GetRenderCFrame() * CFrame.new(0, v.entity.Head.Size.Y + v.entity.RootPart.Size.Y, 0)).Position)
				if not headVis then
					v.Main.Visible = false
					continue
				end
				if NameTagsDistance.Enabled and isAlive(lplr, true) then
					local mag = math.floor((lplr.Character.HumanoidRootPart.Position - v.entity.RootPart.Position).Magnitude)
					local stringsize = tostring(mag):len()
					if nametagsizes[v.entity.Player] ~= stringsize then
						local nametagSize = textService:GetTextSize(removeTags(string.format(nametagstrs[v.entity.Player], mag)), v.Main.TextSize, v.Main.Font, Vector2.new(100000, 100000))
						v.Main.Size = UDim2.new(0, nametagSize.X + 4, 0, nametagSize.Y)
					end
					nametagsizes[v.entity.Player] = stringsize
					v.Main.Text = string.format(nametagstrs[v.entity.Player], mag)
				end
				v.Main.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
				v.Main.Visible = true
			end
		end,
		Drawing = function()
			for i,v in pairs(nametagsfolderdrawing) do
				local headPos, headVis = worldtoscreenpoint((v.entity.RootPart:GetRenderCFrame() * CFrame.new(0, v.entity.Head.Size.Y + v.entity.RootPart.Size.Y, 0)).Position)
				if not headVis then
					v.Main.Text.Visible = false
					v.Main.BG.Visible = false
					continue
				end
				if NameTagsDistance.Enabled and isAlive(lplr, true) then
					local mag = math.floor((lplr.Character.HumanoidRootPart.Position - v.entity.RootPart.Position).Magnitude)
					local stringsize = tostring(mag):len()
					v.Main.Text.Text = string.format(nametagstrs[v.entity.Player], mag)
					if nametagsizes[v.entity.Player] ~= stringsize then
						v.Main.BG.Size = Vector2.new(v.Main.Text.TextBounds.X + 4, v.Main.Text.TextBounds.Y)
					end
					nametagsizes[v.entity.Player] = stringsize
				end
				v.Main.BG.Position = Vector2.new(headPos.X - (v.Main.BG.Size.X / 2), (headPos.Y + v.Main.BG.Size.Y))
				v.Main.Text.Position = v.Main.BG.Position + Vector2.new(2, 0)
				v.Main.Text.Visible = true
				v.Main.BG.Visible = NameTagsBackground.Enabled
			end
		end
	}

	local methodused

	local NameTags = {Enabled = false}
	NameTags = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NameTags",
		Function = function(callback)
			if callback then
				methodused = NameTagsDrawing.Enabled and "Drawing" or "Normal"
				if nametagfuncs2[methodused] then
					table.insert(NameTags.Connections, entityLibrary.entityRemovedEvent:Connect(nametagfuncs2[methodused]))
				end
				if nametagfuncs1[methodused] then
					local addfunc = nametagfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do
						if nametagsfolderdrawing[v.Player] then nametagfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(NameTags.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if nametagsfolderdrawing[ent.Player] then nametagfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if nametagupdatefuncs[methodused] then
					table.insert(NameTags.Connections, entityLibrary.entityUpdatedEvent:Connect(nametagupdatefuncs[methodused]))
					for i,v in pairs(entityLibrary.entityList) do
						nametagupdatefuncs[methodused](v)
					end
				end
				if nametagcolorfuncs[methodused] then
					table.insert(NameTags.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						nametagcolorfuncs[methodused](NameTagsColor.Hue, NameTagsColor.Sat, NameTagsColor.Value)
					end))
				end
				if nametagloop[methodused] then
					RunLoops:BindToRenderStep("NameTags", nametagloop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("NameTags")
				if nametagfuncs2[methodused] then
					for i,v in pairs(nametagsfolderdrawing) do
						nametagfuncs2[methodused](i)
					end
				end
			end
		end,
		HoverText = "Renders nametags on entities through walls."
	})
	for i,v in pairs(Enum.Font:GetEnumItems()) do
		if v.Name ~= "SourceSans" then
			table.insert(fontitems, v.Name)
		end
	end
	NameTagsFont = NameTags.CreateDropdown({
		Name = "Font",
		List = fontitems,
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
	})
	NameTagsColor = NameTags.CreateColorSlider({
		Name = "Player Color",
		Function = function(hue, sat, val)
			if NameTags.Enabled and nametagcolorfuncs[methodused] then
				nametagcolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	NameTagsScale = NameTags.CreateSlider({
		Name = "Scale",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = 10,
		Min = 1,
		Max = 50
	})
	NameTagsBackground = NameTags.CreateToggle({
		Name = "Background",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsDisplayName = NameTags.CreateToggle({
		Name = "Use Display Name",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsHealth = NameTags.CreateToggle({
		Name = "Health",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end
	})
	NameTagsDistance = NameTags.CreateToggle({
		Name = "Distance",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end
	})
	NameTagsTeammates = NameTags.CreateToggle({
		Name = "Teammates",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
		Default = true
	})
	NameTagsDrawing = NameTags.CreateToggle({
		Name = "Drawing",
		Function = function() if NameTags.Enabled then NameTags.ToggleButton(false) NameTags.ToggleButton(false) end end,
	})
end)

run(function()
	local Search = {Enabled = false}
	local SearchTextList = {RefreshValues = function() end, ObjectList = {}}
	local SearchColor = {Value = 0.44}
	local SearchFolder = Instance.new("Folder")
	SearchFolder.Name = "SearchFolder"
	SearchFolder.Parent = GuiLibrary.MainGui
	local function searchFindBoxHandle(part)
		for i,v in pairs(SearchFolder:GetChildren()) do
			if v.Adornee == part then
				return v
			end
		end
		return nil
	end
	local searchRefresh = function()
		SearchFolder:ClearAllChildren()
		if Search.Enabled then
			for i,v in pairs(workspace:GetDescendants()) do
				if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList.ObjectList, v.Name) and searchFindBoxHandle(v) == nil then
					local highlight = Instance.new("Highlight")
					highlight.Name = v.Name
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.FillColor = Color3.fromHSV(SearchColor.Hue, SearchColor.Sat, SearchColor.Value)
					highlight.Adornee = v
					highlight.Parent = SearchFolder
				end
			end
		end
	end
	Search = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Search",
		Function = function(callback)
			if callback then
				searchRefresh()
				table.insert(Search.Connections, workspace.DescendantAdded:Connect(function(v)
					if (v:IsA("BasePart") or v:IsA("Model")) and table.find(SearchTextList.ObjectList, v.Name) and searchFindBoxHandle(v) == nil then
						local highlight = Instance.new("Highlight")
						highlight.Name = v.Name
						highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						highlight.FillColor = Color3.fromHSV(SearchColor.Hue, SearchColor.Sat, SearchColor.Value)
						highlight.Adornee = v
						highlight.Parent = SearchFolder
					end
				end))
				table.insert(Search.Connections, workspace.DescendantRemoving:Connect(function(v)
					if v:IsA("BasePart") or v:IsA("Model") then
						local boxhandle = searchFindBoxHandle(v)
						if boxhandle then
							boxhandle:Remove()
						end
					end
				end))
			else
				SearchFolder:ClearAllChildren()
			end
		end,
		HoverText = "Draws a box around selected parts\nAdd parts in Search frame"
	})
	SearchColor = Search.CreateColorSlider({
		Name = "new part color",
		Function = function(hue, sat, val)
			for i,v in pairs(SearchFolder:GetChildren()) do
				v.FillColor = Color3.fromHSV(hue, sat, val)
			end
		end
	})
	SearchTextList = Search.CreateTextList({
		Name = "SearchList",
		TempText = "part name",
		AddFunction = function(user)
			searchRefresh()
		end,
		RemoveFunction = function(num)
			searchRefresh()
		end
	})
end)

run(function()
	local Xray = {Enabled = false}
	Xray = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Xray",
		Function = function(callback)
			if callback then
				table.insert(Xray.Connections, workspace.DescendantAdded:Connect(function(v)
					if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
						v.LocalTransparencyModifier = 0.5
					end
				end))
				for i, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
						v.LocalTransparencyModifier = 0.5
					end
				end
			else
				for i, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") and not v.Parent.Parent:FindFirstChild("Humanoid") then
						v.LocalTransparencyModifier = 0
					end
				end
			end
		end
	})
end)

run(function()
	local TracersColor = {Value = 0.44}
	local TracersTransparency = {Value = 1}
	local TracersStartPosition = {Value = "Middle"}
	local TracersEndPosition = {Value = "Head"}
	local TracersTeammates = {Enabled = true}
	local tracersfolderdrawing = {}
	local methodused

	local tracersfuncs1 = {
		Drawing = function(plr)
			if TracersTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local newobj = Drawing.new("Line")
			newobj.Thickness = 1
			newobj.Transparency = 1 - (TracersTransparency.Value / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
		DrawingV3 = function(plr)
			if TracersTeammates.Enabled and (not plr.Targetable) and (not plr.Friend) then return end
			local toppoint = PointInstance.new(plr[TracersEndPosition.Value == "Torso" and "RootPart" or "Head"])
			local bottompoint = TracersStartPosition.Value == "Mouse" and PointMouse.new() or Point2D.new(UDim2.new(0.5, 0, TracersStartPosition.Value == "Middle" and 0.5 or 1, 0))
			local newobj = LineDynamic.new(toppoint, bottompoint)
			newobj.Opacity = 1 - (TracersTransparency.Value / 100)
			newobj.Color = getPlayerColor(plr.Player) or Color3.fromHSV(TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
			tracersfolderdrawing[plr.Player] = {entity = plr, Main = newobj}
		end,
	}
	local tracersfuncs2 = {
		Drawing = function(ent)
			local v = tracersfolderdrawing[ent]
			tracersfolderdrawing[ent] = nil
			if v then
				pcall(function() v.Main.Visible = false v.Main:Remove() end)
			end
		end,
	}
	local tracerscolorfuncs = {
		Drawing = function(hue, sat, value)
			local color = Color3.fromHSV(hue, sat, value)
			for i,v in pairs(tracersfolderdrawing) do
				v.Main.Color = getPlayerColor(v.entity.Player) or color
			end
		end
	}
	tracerscolorfuncs.DrawingV3 = tracerscolorfuncs.Drawing
	tracersfuncs2.DrawingV3 = tracersfuncs2.Drawing
	local tracersloop = {
		Drawing = function()
			for i,v in pairs(tracersfolderdrawing) do
				local rootPart = v.entity[TracersEndPosition.Value == "Torso" and "RootPart" or "Head"].Position
				local rootPos, rootVis = worldtoviewportpoint(rootPart)
				local screensize = gameCamera.ViewportSize
				local startVector = TracersStartPosition.Value == "Mouse" and inputService:GetMouseLocation() or Vector2.new(screensize.X / 2, (TracersStartPosition.Value == "Middle" and screensize.Y / 2 or screensize.Y))
				local endVector = Vector2.new(rootPos.X, rootPos.Y)
				v.Main.Visible = rootVis
				v.Main.From = startVector
				v.Main.To = endVector
			end
		end,
	}

	local Tracers = {Enabled = false}
	Tracers = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Tracers",
		Function = function(callback)
			if callback then
				methodused = "Drawing"..synapsev3
				if tracersfuncs2[methodused] then
					table.insert(Tracers.Connections, entityLibrary.entityRemovedEvent:Connect(tracersfuncs2[methodused]))
				end
				if tracersfuncs1[methodused] then
					local addfunc = tracersfuncs1[methodused]
					for i,v in pairs(entityLibrary.entityList) do
						if tracersfolderdrawing[v.Player] then tracersfuncs2[methodused](v.Player) end
						addfunc(v)
					end
					table.insert(Tracers.Connections, entityLibrary.entityAddedEvent:Connect(function(ent)
						if tracersfolderdrawing[ent.Player] then tracersfuncs2[methodused](ent.Player) end
						addfunc(ent)
					end))
				end
				if tracerscolorfuncs[methodused] then
					table.insert(Tracers.Connections, GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList.Api.FriendColorRefresh.Event:Connect(function()
						tracerscolorfuncs[methodused](TracersColor.Hue, TracersColor.Sat, TracersColor.Value)
					end))
				end
				if tracersloop[methodused] then
					RunLoops:BindToRenderStep("Tracers", tracersloop[methodused])
				end
			else
				RunLoops:UnbindFromRenderStep("Tracers")
				for i,v in pairs(tracersfolderdrawing) do
					if tracersfuncs2[methodused] then
						tracersfuncs2[methodused](i)
					end
				end
			end
		end,
		HoverText = "Extra Sensory Perception\nRenders an Tracers on players."
	})
	TracersStartPosition = Tracers.CreateDropdown({
		Name = "Start Position",
		List = {"Middle", "Bottom", "Mouse"},
		Function = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end
	})
	TracersEndPosition = Tracers.CreateDropdown({
		Name = "End Position",
		List = {"Head", "Torso"},
		Function = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end
	})
	TracersColor = Tracers.CreateColorSlider({
		Name = "Player Color",
		Function = function(hue, sat, val)
			if Tracers.Enabled and tracerscolorfuncs[methodused] then
				tracerscolorfuncs[methodused](hue, sat, val)
			end
		end
	})
	TracersTransparency = Tracers.CreateSlider({
		Name = "Transparency",
		Min = 1,
		Max = 100,
		Function = function(val)
			for i,v in pairs(tracersfolderdrawing) do
				if v.Main then
					v.Main[methodused == "DrawingV3" and "Opacity" or "Transparency"] = 1 - (val / 100)
				end
			end
		end,
		Default = 0
	})
	TracersTeammates = Tracers.CreateToggle({
		Name = "Priority Only",
		Function = function() if Tracers.Enabled then Tracers.ToggleButton(true) Tracers.ToggleButton(true) end end,
		Default = true
	})
end)

run(function()
	Spring = {} do
		Spring.__index = Spring

		function Spring.new(freq, pos)
			local self = setmetatable({}, Spring)
			self.f = freq
			self.p = pos
			self.v = pos*0
			return self
		end

		function Spring:Update(dt, goal)
			local f = self.f*2*math.pi
			local p0 = self.p
			local v0 = self.v

			local offset = goal - p0
			local decay = math.exp(-f*dt)

			local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
			local v1 = (f*dt*(offset*f - v0) + v0)*decay

			self.p = p1
			self.v = v1

			return p1
		end

		function Spring:Reset(pos)
			self.p = pos
			self.v = pos*0
		end
	end

	local cameraPos = Vector3.zero
	local cameraRot = Vector2.new()
	local velSpring = Spring.new(5, Vector3.zero)
	local panSpring = Spring.new(5, Vector2.new())

	Input = {} do

		keyboard = {
			W = 0,
			A = 0,
			S = 0,
			D = 0,
			E = 0,
			Q = 0,
			Up = 0,
			Down = 0,
			LeftShift = 0,
		}

		mouse = {
			Delta = Vector2.new(),
		}

		NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
		PAN_MOUSE_SPEED = Vector2.new(3, 3)*(math.pi/64)
		NAV_ADJ_SPEED = 0.75
		NAV_SHIFT_MUL = 0.25

		navSpeed = 1

		function Input.Vel(dt)
			navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

			local kKeyboard = Vector3.new(
				keyboard.D - keyboard.A,
				keyboard.E - keyboard.Q,
				keyboard.S - keyboard.W
			)*NAV_KEYBOARD_SPEED

			local shift = inputService:IsKeyDown(Enum.KeyCode.LeftShift)

			return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
		end

		function Input.Pan(dt)
			local kMouse = mouse.Delta*PAN_MOUSE_SPEED
			mouse.Delta = Vector2.new()
			return kMouse
		end

		do
			function Keypress(action, state, input)
				keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
				return Enum.ContextActionResult.Sink
			end

			function MousePan(action, state, input)
				local delta = input.Delta
				mouse.Delta = Vector2.new(-delta.y, -delta.x)
				return Enum.ContextActionResult.Sink
			end

			function Zero(t)
				for k, v in pairs(t) do
					t[k] = v*0
				end
			end

			function Input.StartCapture()
				game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard",Keypress,false,Enum.ContextActionPriority.High.Value,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D,
				Enum.KeyCode.E,
				Enum.KeyCode.Q,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
				)
				game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan",MousePan,false,Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseMovement)
			end

			function Input.StopCapture()
				navSpeed = 1
				Zero(keyboard)
				Zero(mouse)
				game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
				game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
			end
		end
	end

	local function GetFocusDistance(cameraFrame)
		local znear = 0.1
		local viewport = gameCamera.ViewportSize
		local projy = 2*math.tan(cameraFov/2)
		local projx = viewport.x/viewport.y*projy
		local fx = cameraFrame.rightVector
		local fy = cameraFrame.upVector
		local fz = cameraFrame.lookVector

		local minVect = Vector3.zero
		local minDist = 512

		for x = 0, 1, 0.5 do
			for y = 0, 1, 0.5 do
				local cx = (x - 0.5)*projx
				local cy = (y - 0.5)*projy
				local offset = fx*cx - fy*cy + fz
				local origin = cameraFrame.p + offset*znear
				local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
				local dist = (hit - origin).magnitude
				if minDist > dist then
					minDist = dist
					minVect = offset.unit
				end
			end
		end

		return fz:Dot(minVect)*minDist
	end

	local playerstate = {} do
		mouseBehavior = ""
		mouseIconEnabled = ""
		cameraType = ""
		cameraFocus = ""
		cameraCFrame = ""
		cameraFieldOfView = ""

		function playerstate.Push()
			cameraFieldOfView = gameCamera.FieldOfView
			gameCamera.FieldOfView = 70

			cameraType = gameCamera.CameraType
			gameCamera.CameraType = Enum.CameraType.Custom

			cameraCFrame = gameCamera.CFrame
			cameraFocus = gameCamera.Focus

			mouseBehavior = inputService.MouseBehavior
			inputService.MouseBehavior = Enum.MouseBehavior.Default

			mouseIconEnabled = inputService.MouseIconEnabled
			inputService.MouseIconEnabled = true
		end

		function playerstate.Pop()
			gameCamera.FieldOfView = cameraFieldOfView
			cameraFieldOfView = nil

			gameCamera.CameraType = cameraType
			cameraType = nil

			gameCamera.CFrame = cameraCFrame
			cameraCFrame = nil

			gameCamera.Focus = cameraFocus
			cameraFocus = nil

			inputService.MouseIconEnabled = mouseIconEnabled
			mouseIconEnabled = nil

			inputService.MouseBehavior = mouseBehavior
			mouseBehavior = nil
		end
	end

	local Freecam = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Freecam",
		Function = function(callback)
			if callback then
				local cameraCFrame = gameCamera.CFrame
				local pitch, yaw, roll = cameraCFrame:ToEulerAnglesYXZ()
				cameraRot = Vector2.new(pitch, yaw)
				cameraPos = cameraCFrame.p
				cameraFov = gameCamera.FieldOfView

				velSpring:Reset(Vector3.zero)
				panSpring:Reset(Vector2.new())

				playerstate.Push()
				RunLoops:BindToRenderStep("Freecam", function(dt)
					local vel = velSpring:Update(dt, Input.Vel(dt))
					local pan = panSpring:Update(dt, Input.Pan(dt))

					local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

					cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
					cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

					local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
					cameraPos = cameraCFrame.p

					gameCamera.CFrame = cameraCFrame
					gameCamera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
					gameCamera.FieldOfView = cameraFov
				end)
				Input.StartCapture()
			else
				Input.StopCapture()
				RunLoops:UnbindFromRenderStep("Freecam")
				playerstate.Pop()
			end
		end,
		HoverText = "Lets you fly and clip through walls freely\nwithout moving your player server-sided."
	})
	Freecam.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 150,
		Function = function(val) NAV_KEYBOARD_SPEED = Vector3.new(val / 75,  val / 75, val / 75) end,
		Default = 75
	})
end)

run(function()
	local Panic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "Panic",
		Function = function(callback)
			if callback then
				for i,v in pairs(GuiLibrary.ObjectsThatCanBeSaved) do
					if v.Type == "OptionsButton" then
						if v.Api.Enabled then
							v.Api.ToggleButton()
						end
					end
				end
			end
		end
	})
end)

run(function()
	local ChatSpammer = {Enabled = false}
	local ChatSpammerDelay = {Value = 10}
	local ChatSpammerHideWait = {Enabled = true}
	local ChatSpammerMessages = {ObjectList = {}}
	local chatspammerfirstexecute = true
	local chatspammerhook = false
	local oldchanneltab
	local oldchannelfunc
	local oldchanneltabs = {}
	local waitnum = 0
	ChatSpammer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ChatSpammer",
		Function = function(callback)
			if callback then
				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
					task.spawn(function()
						repeat
							if ChatSpammer.Enabled then
								pcall(function()
									textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync((#ChatSpammerMessages.ObjectList > 0 and ChatSpammerMessages.ObjectList[math.random(1, #ChatSpammerMessages.ObjectList)] or 'render is just better | renderintents.xyz'))
								end)
							end
							if waitnum ~= 0 then
								task.wait(waitnum)
								waitnum = 0
							else
								task.wait(ChatSpammerDelay.Value / 10)
							end
						until not ChatSpammer.Enabled
					end)
				else
					task.spawn(function()
						if chatspammerfirstexecute then
							lplr.PlayerGui:WaitForChild("Chat", 10)
							chatspammerfirstexecute = false
						end
						if lplr.PlayerGui:FindFirstChild("Chat") and lplr.PlayerGui.Chat:FindFirstChild("Frame") and lplr.PlayerGui.Chat.Frame:FindFirstChild("ChatChannelParentFrame") and replicatedStorageService:FindFirstChild("DefaultChatSystemChatEvents") then
							if not chatspammerhook then
								task.spawn(function()
									chatspammerhook = true
									for i,v in pairs(getconnections(replicatedStorageService.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
										if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
											oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
											oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
											getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
												local tab = oldchannelfunc(Self, Name)
												if tab and tab.AddMessageToChannel then
													local addmessage = tab.AddMessageToChannel
													if oldchanneltabs[tab] == nil then
														oldchanneltabs[tab] = tab.AddMessageToChannel
													end
													tab.AddMessageToChannel = function(Self2, MessageData)
														if MessageData.MessageType == "System" then
															if MessageData.Message:find("You must wait") and ChatSpammer.Enabled then
																return nil
															end
														end
														return addmessage(Self2, MessageData)
													end
												end
												return tab
											end
										end
									end
								end)
							end
							task.spawn(function()
								repeat
									pcall(function()
										replicatedStorageService.DefaultChatSystemChatEvents.SayMessageRequest:FireServer((#ChatSpammerMessages.ObjectList > 0 and ChatSpammerMessages.ObjectList[math.random(1, #ChatSpammerMessages.ObjectList)] or "vxpe on top"), "All")
									end)
									if waitnum ~= 0 then
										task.wait(waitnum)
										waitnum = 0
									else
										task.wait(ChatSpammerDelay.Value / 10)
									end
								until not ChatSpammer.Enabled
							end)
						else
							warningNotification("ChatSpammer", "Default chat not found.", 3)
							if ChatSpammer.Enabled then ChatSpammer.ToggleButton(false) end
						end
					end)
				end
			else
				waitnum = 0
			end
		end,
		HoverText = "Spams chat with text of your choice (Default Chat Only)"
	})
	ChatSpammerDelay = ChatSpammer.CreateSlider({
		Name = "Delay",
		Min = 1,
		Max = 50,
		Default = 10,
		Function = function() end
	})
	ChatSpammerHideWait = ChatSpammer.CreateToggle({
		Name = "Hide Wait Message",
		Function = function() end,
		Default = true
	})
	ChatSpammerMessages = ChatSpammer.CreateTextList({
		Name = "Message",
		TempText = "message to spam",
		Function = function() end
	})
end)

run(function()
	local controlmodule
	local oldmove
	local SafeWalk = {Enabled = false}
	local SafeWalkRaycast = RaycastParams.new()
	SafeWalkRaycast.RespectCanCollide = true
	SafeWalkRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	SafeWalk = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "SafeWalk",
		Function = function(callback)
			if callback then
				if not controlmodule then
					local suc = pcall(function() controlmodule = require(lplr.PlayerScripts.PlayerModule).controls end)
					if not suc then controlmodule = {} end
				end
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam)
					if isAlive(lplr, true) then
						SafeWalkRaycast.FilterDescendantsInstances = {lplr.Character}
						local ray = workspace:Raycast(lplr.Character.HumanoidRootPart.Position + (vec * 0.5), Vector3.new(0, -1000, 0), SafeWalkRaycast)
						if not ray then
							if workspace:Raycast(lplr.Character.HumanoidRootPart.Position, Vector3.new(0, -((lplr.Character.Humanoid.HipHeight + (lplr.Character.HumanoidRootPart.Size.Y / 2)) + 1), 0), SafeWalkRaycast) then
								vec = Vector3.zero
							end
						end
					end
					return oldmove(Self, vec, facecam)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end,
		HoverText = "stop you from walking off because you suck at this game"
	})
end)

run(function()
	local function capeFunction(char, texture)
		for i,v in pairs(char:GetDescendants()) do
			if v.Name == "Cape" then
				v:Destroy()
			end
		end
		local hum = char:WaitForChild("Humanoid")
		local torso = nil
		if hum.RigType == Enum.HumanoidRigType.R15 then
			torso = char:WaitForChild("UpperTorso")
		else
			torso = char:WaitForChild("Torso")
		end
		local p = Instance.new("Part", torso.Parent)
		p.Name = "Cape"
		p.Anchored = false
		p.CanCollide = false
		p.TopSurface = 0
		p.BottomSurface = 0
		p.FormFactor = "Custom"
		p.Size = Vector3.new(0.2,0.2,0.08)
		p.Transparency = 1
		local decal
		local video = false
		if texture:find(".webm") then
			video = true
			local decal2 = Instance.new("SurfaceGui", p)
			decal2.Adornee = p
			decal2.CanvasSize = Vector2.new(1, 1)
			decal2.Face = "Back"
			decal = Instance.new("VideoFrame", decal2)
			decal.Size = UDim2.new(0, 9, 0, 17)
			decal.BackgroundTransparency = 1
			decal.Position = UDim2.new(0, -4, 0, -8)
			decal.Video = texture
			decal.Looped = true
			decal:Play()
		else
			decal = Instance.new("Decal", p)
			decal.Texture = texture
			decal.Face = "Back"
		end
		local msh = Instance.new("BlockMesh", p)
		msh.Scale = Vector3.new(9, 17.5, 0.5)
		local motor = Instance.new("Motor", p)
		motor.Part0 = p
		motor.Part1 = torso
		motor.MaxVelocity = 0.01
		motor.C0 = CFrame.new(0, 2, 0) * CFrame.Angles(0, math.rad(90), 0)
		motor.C1 = CFrame.new(0, 1, 0.45) * CFrame.Angles(0, math.rad(90), 0)
		local wave = false
		repeat task.wait(1/44)
			if video then
				decal.Visible = torso.LocalTransparencyModifier ~= 1
			else
				decal.Transparency = torso.Transparency
			end
			local ang = 0.1
			local oldmag = torso.Velocity.magnitude
			local mv = 0.002
			if wave then
				ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
				wave = false
			else
				wave = true
			end
			ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
			motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
			motor.DesiredAngle = -ang
			if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
				motor.MaxVelocity = 0.04
			end
			repeat task.wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
			if torso.Velocity.magnitude < 0.1 then
				task.wait(0.1)
			end
		until not p or p.Parent ~= torso.Parent
	end

	local Cape = {Enabled = false}
	local CapeBox = {Value = ""}
	Cape = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Cape",
		Function = function(callback)
			if callback then
				local successfulcustom
				if CapeBox.Value ~= "" then
					if (tonumber(CapeBox.Value)) then
						local suc, id = pcall(function() return string.match(game:GetObjects("rbxassetid://"..CapeBox.Value)[1].Texture, "%?id=(%d+)") end)
						if not suc then
							id = CapeBox.Value
						end
						successfulcustom = "rbxassetid://"..id
					elseif (not isfile(CapeBox.Value)) then
						warningNotification("Cape", "Missing file", 5)
					else
						successfulcustom = CapeBox.Value:find(".") and getcustomasset(CapeBox.Value) or CapeBox.Value
					end
				end
				table.insert(Cape.Connections, lplr.CharacterAdded:Connect(function(char)
					task.spawn(function()
						pcall(function()
							capeFunction(char, (successfulcustom or "rbxassetid://17140106485"))
						end)
					end)
				end))
				if lplr.Character then
					task.spawn(function()
						pcall(function()
							capeFunction(lplr.Character, (successfulcustom or "rbxassetid://17140106485"))
						end)
					end)
				end
			else
				if lplr.Character then
					for i,v in pairs(lplr.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Destroy()
						end
					end
				end
			end
		end,
		ExtraText = function()
			return "Render"
		end
	})
	CapeBox = Cape.CreateTextBox({
		Name = "File",
		TempText = "File (link)",
		FocusLost = function(enter)
			if enter then
				if Cape.Enabled then
					Cape.ToggleButton(false)
					Cape.ToggleButton(false)
				end
			end
		end
	})
end)

run(function()
	local ChinaHat = {Enabled = false}
	local ChinaHatColor = {Hue = 1, Sat=1, Value=0.33}
	local chinahattrail
	local chinahatattachment
	local chinahatattachment2
	ChinaHat = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ChinaHat",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("ChinaHat", function()
					if isAlive(lplr, true) then
						if chinahattrail == nil or chinahattrail.Parent == nil then
							chinahattrail = Instance.new("Part")
							chinahattrail.CFrame = lplr.Character.Head.CFrame * CFrame.new(0, 1.1, 0)
							chinahattrail.Size = Vector3.new(3, 0.7, 3)
							chinahattrail.Name = "ChinaHat"
							chinahattrail.Material = Enum.Material.Neon
							chinahattrail.Color = Color3.fromHSV(ChinaHatColor.Hue, ChinaHatColor.Sat, ChinaHatColor.Value)
							chinahattrail.CanCollide = false
							chinahattrail.Transparency = 0.3
							local chinahatmesh = Instance.new("SpecialMesh")
							chinahatmesh.Parent = chinahattrail
							chinahatmesh.MeshType = "FileMesh"
							chinahatmesh.MeshId = "rbxassetid://1778999"
							chinahatmesh.Scale = Vector3.new(3, 0.6, 3)
							chinahattrail.Parent = workspace.Camera
						end
						chinahattrail.CFrame = lplr.Character.Head.CFrame * CFrame.new(0, 1.1, 0)
						chinahattrail.Velocity = Vector3.zero
						chinahattrail.LocalTransparencyModifier = ((gameCamera.CFrame.Position - gameCamera.Focus.Position).Magnitude <= 0.6 and 1 or 0)
					else
						if chinahattrail then
							chinahattrail:Destroy()
							chinahattrail = nil
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("ChinaHat")
				if chinahattrail then
					chinahattrail:Destroy()
					chinahattrail = nil
				end
			end
		end,
		HoverText = "Puts a china hat on your character (mastadawn ty for)"
	})
	ChinaHatColor = ChinaHat.CreateColorSlider({
		Name = "Hat Color",
		Function = function(h, s, v)
			if chinahattrail then
				chinahattrail.Color = Color3.fromHSV(h, s, v)
			end
		end
	})
end)

run(function()
	local FieldOfView = {Enabled = false}
	local FieldOfViewZoom = {Enabled = false}
	local FieldOfViewValue = {Value = 70}
	local oldfov
	FieldOfView = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "FOVChanger",
		Function = function(callback)
			if callback then
				oldfov = gameCamera.FieldOfView
				if FieldOfViewZoom.Enabled then
					task.spawn(function()
						repeat
							task.wait()
						until inputService:IsKeyDown(Enum.KeyCode[FieldOfView.Keybind ~= "" and FieldOfView.Keybind or "C"]) == false
						if FieldOfView.Enabled then
							FieldOfView.ToggleButton(false)
						end
					end)
				end
				task.spawn(function()
					repeat
						gameCamera.FieldOfView = FieldOfViewValue.Value
						task.wait()
					until (not FieldOfView.Enabled)
				end)
			else
				gameCamera.FieldOfView = oldfov
			end
		end
	})
	FieldOfViewValue = FieldOfView.CreateSlider({
		Name = "FOV",
		Min = 30,
		Max = 120,
		Function = function(val) end
	})
	FieldOfViewZoom = FieldOfView.CreateToggle({
		Name = "Zoom",
		Function = function() end,
		HoverText = "optifine zoom lol"
	})
end)

run(function()
	local Swim = {Enabled = false}
	local SwimVertical = {Value = 1}
	local swimconnection
	local oldgravity

	Swim = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Swim",
		Function = function(callback)
			if callback then
				oldgravity = workspace.Gravity
				if isAlive(lplr, true) then
					GravityChangeTick = tick() + 0.1
					workspace.Gravity = 0
					local enums = Enum.HumanoidStateType:GetEnumItems()
					table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
					for i,v in pairs(enums) do
						lplr.Character.Humanoid:SetStateEnabled(v, false)
					end
					lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
					RunLoops:BindToHeartbeat("Swim", function()
						local rootvelo = lplr.Character.HumanoidRootPart.Velocity
						local moving = lplr.Character.Humanoid.MoveDirection ~= Vector3.zero
						lplr.Character.HumanoidRootPart.Velocity = ((moving or inputService:IsKeyDown(Enum.KeyCode.Space)) and Vector3.new(moving and rootvelo.X or 0, inputService:IsKeyDown(Enum.KeyCode.Space) and SwimVertical.Value or rootvelo.Y, moving and rootvelo.Z or 0) or Vector3.zero)
					end)
				end
			else
				GravityChangeTick = tick() + 0.1
				workspace.Gravity = oldgravity
				RunLoops:UnbindFromHeartbeat("Swim")
				if isAlive(lplr, true) then
					local enums = Enum.HumanoidStateType:GetEnumItems()
					table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
					for i,v in pairs(enums) do
						lplr.Character.Humanoid:SetStateEnabled(v, true)
					end
				end
			end
		end
	})
	SwimVertical = Swim.CreateSlider({
		Name = "Y Speed",
		Min = 1,
		Max = 50,
		Default = 50,
		Function = function() end
	})
end)


run(function()
	local Breadcrumbs = {Enabled = false}
	local BreadcrumbsLifetime = {Value = 20}
	local BreadcrumbsThickness = {Value = 7}
	local BreadcrumbsFadeIn = {Value = 0.44}
	local BreadcrumbsFadeOut = {Value = 0.44}
	local breadcrumbtrail
	local breadcrumbattachment
	local breadcrumbattachment2
	Breadcrumbs = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "Breadcrumbs",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						if isAlive(lplr, true) then
							if not breadcrumbtrail then
								breadcrumbattachment = Instance.new("Attachment")
								breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.7, 0)
								breadcrumbattachment2 = Instance.new("Attachment")
								breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.7, 0)
								breadcrumbtrail = Instance.new("Trail")
								breadcrumbtrail.Attachment0 = breadcrumbattachment
								breadcrumbtrail.Attachment1 = breadcrumbattachment2
								breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn.Hue, BreadcrumbsFadeIn.Sat, BreadcrumbsFadeIn.Value), Color3.fromHSV(BreadcrumbsFadeOut.Hue, BreadcrumbsFadeOut.Sat, BreadcrumbsFadeOut.Value))
								breadcrumbtrail.FaceCamera = true
								breadcrumbtrail.Lifetime = BreadcrumbsLifetime.Value / 10
								breadcrumbtrail.Enabled = true
							else
								local suc = pcall(function()
									breadcrumbattachment.Parent = lplr.Character.HumanoidRootPart
									breadcrumbattachment2.Parent = lplr.Character.HumanoidRootPart
									breadcrumbtrail.Parent = gameCamera
								end)
								if not suc then
									if breadcrumbtrail then breadcrumbtrail:Destroy() breadcrumbtrail = nil end
									if breadcrumbattachment then breadcrumbattachment:Destroy() breadcrumbattachment = nil end
									if breadcrumbattachment2 then breadcrumbattachment2:Destroy() breadcrumbattachment2 = nil end
								end
							end
						end
						task.wait(0.3)
					until not Breadcrumbs.Enabled
				end)
			else
				if breadcrumbtrail then breadcrumbtrail:Destroy() breadcrumbtrail = nil end
				if breadcrumbattachment then breadcrumbattachment:Destroy() breadcrumbattachment = nil end
				if breadcrumbattachment2 then breadcrumbattachment2:Destroy() breadcrumbattachment2 = nil end
			end
		end,
		HoverText = "Shows a trail behind your character"
	})
	BreadcrumbsFadeIn = Breadcrumbs.CreateColorSlider({
		Name = "Fade In",
		Function = function(hue, sat, val)
			if breadcrumbtrail then
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(hue, sat, val), Color3.fromHSV(BreadcrumbsFadeOut.Hue, BreadcrumbsFadeOut.Sat, BreadcrumbsFadeOut.Value))
			end
		end
	})
	BreadcrumbsFadeOut = Breadcrumbs.CreateColorSlider({
		Name = "Fade Out",
		Function = function(hue, sat, val)
			if breadcrumbtrail then
				breadcrumbtrail.Color = ColorSequence.new(Color3.fromHSV(BreadcrumbsFadeIn.Hue, BreadcrumbsFadeIn.Sat, BreadcrumbsFadeIn.Value), Color3.fromHSV(hue, sat, val))
			end
		end
	})
	BreadcrumbsLifetime = Breadcrumbs.CreateSlider({
		Name = "Lifetime",
		Min = 1,
		Max = 100,
		Function = function(val)
			if breadcrumbtrail then
				breadcrumbtrail.Lifetime = val / 10
			end
		end,
		Default = 20,
		Double = 10
	})
	BreadcrumbsThickness = Breadcrumbs.CreateSlider({
		Name = "Thickness",
		Min = 1,
		Max = 30,
		Function = function(val)
			if breadcrumbattachment then
				breadcrumbattachment.Position = Vector3.new(0, (val / 100) - 2.7, 0)
			end
			if breadcrumbattachment2 then
				breadcrumbattachment2.Position = Vector3.new(0, -(val / 100) - 2.7, 0)
			end
		end,
		Default = 7,
		Double = 10
	})
end)

run(function()
	local AutoReport = {Enabled = false}
	local AutoReportList = {ObjectList = {}}
	local AutoReportNotify = {Enabled = false}
	local alreadyreported = {}

	local function removerepeat(str)
		local newstr = ""
		local lastlet = ""
		for i,v in pairs(str:split("")) do
			if v ~= lastlet then
				newstr = newstr..v
				lastlet = v
			end
		end
		return newstr
	end

	local reporttable = {
		gay = "Bullying",
		gae = "Bullying",
		gey = "Bullying",
		hack = "Scamming",
		exploit = "Scamming",
		cheat = "Scamming",
		hecker = "Scamming",
		haxker = "Scamming",
		hacer = "Scamming",
		report = "Bullying",
		fat = "Bullying",
		black = "Bullying",
		getalife = "Bullying",
		fatherless = "Bullying",
		report = "Bullying",
		fatherless = "Bullying",
		disco = "Offsite Links",
		yt = "Offsite Links",
		dizcourde = "Offsite Links",
		retard = "Swearing",
		bad = "Bullying",
		trash = "Bullying",
		nolife = "Bullying",
		nolife = "Bullying",
		loser = "Bullying",
		killyour = "Bullying",
		kys = "Bullying",
		hacktowin = "Bullying",
		bozo = "Bullying",
		kid = "Bullying",
		adopted = "Bullying",
		linlife = "Bullying",
		commitnotalive = "Bullying",
		vape = "Offsite Links",
		futureclient = "Offsite Links",
		download = "Offsite Links",
		youtube = "Offsite Links",
		die = "Bullying",
		lobby = "Bullying",
		ban = "Bullying",
		wizard = "Bullying",
		wisard = "Bullying",
		witch = "Bullying",
		magic = "Bullying",
	}
	local reporttableexact = {
		L = "Bullying",
	}


	local function findreport(msg)
		local checkstr = removerepeat(msg:gsub("%W+", ""):lower())
		for i,v in pairs(reporttable) do
			if checkstr:find(i) then
				return v, i
			end
		end
		for i,v in pairs(reporttableexact) do
			if checkstr == i then
				return v, i
			end
		end
		for i,v in pairs(AutoReportList.ObjectList) do
			if checkstr:find(v) then
				return "Bullying", v
			end
		end
		return nil
	end

	AutoReport = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AutoReport",
		Function = function(callback)
			if callback then
				if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
					table.insert(AutoReport.Connections, textChatService.MessageReceived:Connect(function(tab)
						if tab.TextSource then
							local plr = playersService:GetPlayerByUserId(tab.TextSource.UserId)
							local args = tab.Text:split(" ")
							if plr and plr ~= lplr and whitelist:get(plr) == 0 then
								local reportreason, reportedmatch = findreport(tab.Text)
								if reportreason then
									if alreadyreported[plr] then return end
									task.spawn(function()
										if syn == nil or reportplayer then
											if reportplayer then
												reportplayer(plr, reportreason, "he said a bad word")
											else
												playersService:ReportAbuse(plr, reportreason, "he said a bad word")
											end
										end
									end)
									if AutoReportNotify.Enabled then
										warningNotification("AutoReport", "Reported "..plr.Name.." for "..reportreason..' ('..reportedmatch..')', 15)
									end
									alreadyreported[plr] = true
								end
							end
						end
					end))
				else
					if replicatedStorageService:FindFirstChild("DefaultChatSystemChatEvents") then
						table.insert(AutoReport.Connections, replicatedStorageService.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(tab, channel)
							local plr = playersService:FindFirstChild(tab.FromSpeaker)
							local args = tab.Message:split(" ")
							if plr and plr ~= lplr and whitelist:get(plr) == 0 then
								local reportreason, reportedmatch = findreport(tab.Message)
								if reportreason then
									if alreadyreported[plr] then return end
									task.spawn(function()
										if syn == nil or reportplayer then
											if reportplayer then
												reportplayer(plr, reportreason, "he said a bad word")
											else
												playersService:ReportAbuse(plr, reportreason, "he said a bad word")
											end
										end
									end)
									if AutoReportNotify.Enabled then
										warningNotification("AutoReport", "Reported "..plr.Name.." for "..reportreason..' ('..reportedmatch..')', 15)
									end
									alreadyreported[plr] = true
								end
							end
						end))
					else
						warningNotification("AutoReport", "Default chat not found.", 5)
						AutoReport.ToggleButton(false)
					end
				end
			end
		end
	})
	AutoReportNotify = AutoReport.CreateToggle({
		Name = "Notify",
		Function = function() end
	})
	AutoReportList = AutoReport.CreateTextList({
		Name = "Report Words",
		TempText = "phrase (to report)"
	})
end)

run(function()
	local targetstrafe = {Enabled = false}
	local targetstraferange = {Value = 0}
	local oldmove
	local controlmodule
	targetstrafe = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "TargetStrafe",
		Function = function(callback)
			if callback then
				if not controlmodule then
					local suc = pcall(function() controlmodule = require(lplr.PlayerScripts.PlayerModule).controls end)
					if not suc then controlmodule = {} end
				end
				oldmove = controlmodule.moveFunction
				controlmodule.moveFunction = function(Self, vec, facecam, ...)
					if isAlive(lplr, true) then
						local plr = EntityNearPosition(targetstraferange.Value, {
							WallCheck = false,
							AimPart = "RootPart"
						})
						if plr then
							facecam = false
							--code stolen from roblox since the way I tried to make it apparently sucks
							local c, s
							local plrCFrame = CFrame.lookAt(lplr.Character.HumanoidRootPart.Position, Vector3.new(plr.RootPart.Position.X, 0, plr.RootPart.Position.Z))
							local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = plrCFrame:GetComponents()
							if R12 < 1 and R12 > -1 then
								c = R22
								s = R02
							else
								c = R00
								s = -R01*math.sign(R12)
							end
							local norm = math.sqrt(c*c + s*s)
							local cameraRelativeMoveVector = controlmodule:GetMoveVector()
							vec = Vector3.new(
								(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
								0,
								(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
							)
						end
					end
					return oldmove(Self, vec, facecam, ...)
				end
			else
				controlmodule.moveFunction = oldmove
			end
		end
	})
	targetstraferange = targetstrafe.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 0,
		Max = 100,
		Default = 14
	})
end)

run(function()
	local AutoLeave = {Enabled = false}
	local AutoLeaveMode = {Value = "UnInject"}
	local AutoLeaveGroupId = {Value = "0"}
	local AutoLeaveRank = {Value = "1"}
	local getrandomserver
	local alreadyjoining = false
	getrandomserver = function(pointer)
		alreadyjoining = true
		local decodeddata = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"..(pointer and "&cursor="..pointer or "")))
		local chosenServer
		for i, v in pairs(decodeddata.data) do
			if (tonumber(v.playing) < tonumber(playersService.MaxPlayers)) and tonumber(v.ping) < 300 and v.id ~= game.JobId then
				chosenServer = v.id
				break
			end
		end
		if chosenServer then
			alreadyjoining = false
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chosenServer, lplr)
		else
			if decodeddata.nextPageCursor then
				getrandomserver(decodeddata.nextPageCursor)
			else
				alreadyjoining = false
			end
		end
	end

	local function getRole(plr, id)
		local suc, res = pcall(function() return plr:GetRankInGroup(id) end)
		if not suc then
			repeat
				suc, res = pcall(function() return plr:GetRankInGroup(id) end)
				task.wait()
			until suc
		end
		return res
	end

	local function autoleaveplradded(plr)
		task.spawn(function()
			pcall(function()
				if AutoLeaveGroupId.Value == "" or AutoLeaveRank.Value == "" then return end
				if getRole(plr, tonumber(AutoLeaveGroupId.Value) or 0) >= (tonumber(AutoLeaveRank.Value) or 1) then
					local _, ent = entityLibrary.getEntityFromPlayer(plr)
					if ent then
						entityLibrary.entityUpdatedEvent:Fire(ent)
					end
					if AutoLeaveMode.Value == "UnInject" then
						task.spawn(function()
							if not shared.VapeFullyLoaded then
								repeat task.wait() until shared.VapeFullyLoaded
							end
							GuiLibrary.SelfDestruct()
						end)
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "AutoLeave",
							Text = "Staff Detected\n"..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name),
							Duration = 60,
						})
					elseif AutoLeaveMode.Value == "Rejoin" then
						getrandomserver()
					else
						createwarning("AutoLeave", "Staff Detected : "..(plr.DisplayName and plr.DisplayName.." ("..plr.Name..")" or plr.Name), 60)
					end
				end
			end)
		end)
	end

	local function autodetect(roles)
		local highest = 9e9
		for i,v in pairs(roles) do
			local low = v.Name:lower()
			if (low:find("admin") or low:find("mod") or low:find("dev")) and v.Rank < highest then
				highest = v.Rank
			end
		end
		return highest
	end

	AutoLeave = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "AutoLeave",
		Function = function(callback)
			if callback then
				if AutoLeaveGroupId.Value == "" or AutoLeaveRank.Value == "" then
					task.spawn(function()
						local placeinfo = {Creator = {CreatorTargetId = tonumber(AutoLeaveGroupId.Value)}}
						if AutoLeaveGroupId.Value == "" then
							placeinfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
							if placeinfo.Creator.CreatorType ~= "Group" then
								local desc = placeinfo.Description:split("\n")
								for i, str in pairs(desc) do
									local _, begin = str:find("roblox.com/groups/")
									if begin then
										local endof = str:find("/", begin + 1)
										placeinfo = {Creator = {CreatorType = "Group", CreatorTargetId = str:sub(begin + 1, endof - 1)}}
									end
								end
							end
							if placeinfo.Creator.CreatorType ~= "Group" then
								warningNotification("AutoLeave", "Automatic Setup Failed (no group detected)", 60)
								return
							end
						end
						local groupinfo = game:GetService("GroupService"):GetGroupInfoAsync(placeinfo.Creator.CreatorTargetId)
						AutoLeaveGroupId.SetValue(placeinfo.Creator.CreatorTargetId)
						AutoLeaveRank.SetValue(autodetect(groupinfo.Roles))
						if AutoLeave.Enabled then
							AutoLeave.ToggleButton(false)
							AutoLeave.ToggleButton(false)
						end
					end)
					table.insert(AutoLeave.Connections, playersService.PlayerAdded:Connect(autoleaveplradded))
					for i, plr in pairs(playersService:GetPlayers()) do
						autoleaveplradded(plr)
					end
				end
			end
		end,
		HoverText = "Leaves if a staff member joins your game."
	})
	AutoLeaveMode = AutoLeave.CreateDropdown({
		Name = "Mode",
		List = {"UnInject", "Rejoin", "Notify"},
		Function = function() end
	})
	AutoLeaveGroupId = AutoLeave.CreateTextBox({
		Name = "Group Id",
		TempText = "0 (group id)",
		Function = function() end
	})
	AutoLeaveRank = AutoLeave.CreateTextBox({
		Name = "Rank Id",
		TempText = "1 (rank id)",
		Function = function() end
	})
end)

run(function()
	GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "AntiVoid",
		Function = function(callback)
			if callback then
				local rayparams = RaycastParams.new()
				rayparams.RespectCanCollide = true
				local lastray
				RunLoops:BindToHeartbeat("AntiVoid", function()
					if isAlive(lplr, true) then
						rayparams.FilterDescendantsInstances = {gameCamera, lplr.Character}
						lastray = lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and lplr.Character.HumanoidRootPart.CFrame or lastray
						if (lplr.Character.HumanoidRootPart.Position.Y + (lplr.Character.HumanoidRootPart.Velocity.Y * 0.016)) <= (workspace.FallenPartsDestroyHeight + 5) then
							local comp = {lplr.Character.HumanoidRootPart.CFrame:GetComponents()}
							comp[2] = (workspace.FallenPartsDestroyHeight + 20)
							if lastray then
								comp[1] = lastray.Position.X
								comp[2] = lastray.Position.Y + (lplr.Character.Humanoid.HipHeight + (lplr.Character.HumanoidRootPart.Size.Y / 2))
								comp[3] = lastray.Position.Z
							end
							lplr.Character.HumanoidRootPart.CFrame = CFrame.new(unpack(comp))
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 0, lplr.Character.HumanoidRootPart.Velocity.Z)
						end
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("AntiVoid")
			end
		end
	})
end)

run(function()
	local Blink = {Enabled = false}
	Blink = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Blink",
		Function = function(callback)
			if callback then
				if sethiddenproperty then
					RunLoops:BindToHeartbeat("Blink", function()
						if isAlive(lplr, true) then
							sethiddenproperty(lplr.Character.HumanoidRootPart, "NetworkIsSleeping", true)
						end
					end)
				else
					warningNotification("Blink", "missing function", 5)
					Blink.ToggleButton(false)
				end
			else
				RunLoops:UnbindFromHeartbeat("Blink")
			end
		end
	})
end)

run(function()
	local AnimationPlayer = {Enabled = false}
	local AnimationPlayerBox = {Value = ""}
	local AnimationPlayerSpeed = {Speed = 1}
	local playedanim
	AnimationPlayer = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AnimationPlayer",
		Function = function(callback)
			if callback then
				if isAlive(lplr, true) then
					if playedanim then
						playedanim:Stop()
						playedanim.Animation:Destroy()
						playedanim = nil
					end
					local anim = Instance.new("Animation")
					local suc, id = pcall(function() return string.match(game:GetObjects("rbxassetid://"..AnimationPlayerBox.Value)[1].AnimationId, "%?id=(%d+)") end)
                    if not suc then
                        id = AnimationPlayerBox.Value
                    end
                    anim.AnimationId = "rbxassetid://"..id
					local suc, res = pcall(function() playedanim = lplr.Character.Humanoid.Animator:LoadAnimation(anim) end)
					if suc then
						playedanim.Priority = Enum.AnimationPriority.Action4
						playedanim.Looped = true
						playedanim:Play()
						playedanim:AdjustSpeed(AnimationPlayerSpeed.Value / 10)
						table.insert(AnimationPlayer.Connections, playedanim.Stopped:Connect(function()
							if AnimationPlayer.Enabled then
								AnimationPlayer.ToggleButton(false)
								AnimationPlayer.ToggleButton(false)
							end
						end))
					else
						warningNotification("AnimationPlayer", "failed to load anim : "..(res or "invalid animation id"), 5)
					end
				end
				table.insert(AnimationPlayer.Connections, lplr.CharacterAdded:Connect(function()
					repeat task.wait() until isAlive(lplr, true) or not AnimationPlayer.Enabled
					task.wait(0.5)
					if not AnimationPlayer.Enabled then return end
					if playedanim then
						playedanim:Stop()
						playedanim.Animation:Destroy()
						playedanim = nil
					end
					local anim = Instance.new("Animation")
					local suc, id = pcall(function() return string.match(game:GetObjects("rbxassetid://"..AnimationPlayerBox.Value)[1].AnimationId, "%?id=(%d+)") end)
                    if not suc then
                        id = AnimationPlayerBox.Value
                    end
                    anim.AnimationId = "rbxassetid://"..id
					local suc, res = pcall(function() playedanim = lplr.Character.Humanoid.Animator:LoadAnimation(anim) end)
					if suc then
						playedanim.Priority = Enum.AnimationPriority.Action4
						playedanim.Looped = true
						playedanim:Play()
						playedanim:AdjustSpeed(AnimationPlayerSpeed.Value / 10)
						playedanim.Stopped:Connect(function()
							if AnimationPlayer.Enabled then
								AnimationPlayer.ToggleButton(false)
								AnimationPlayer.ToggleButton(false)
							end
						end)
					else
						warningNotification("AnimationPlayer", "failed to load anim : "..(res or "invalid animation id"), 5)
					end
				end))
			else
				if playedanim then playedanim:Stop() playedanim = nil end
			end
		end
	})
	AnimationPlayerBox = AnimationPlayer.CreateTextBox({
		Name = "Animation",
		TempText = "anim (num only)",
		Function = function(enter)
			if enter and AnimationPlayer.Enabled then
				AnimationPlayer.ToggleButton(false)
				AnimationPlayer.ToggleButton(false)
			end
		end
	})
	AnimationPlayerSpeed = AnimationPlayer.CreateSlider({
		Name = "Speed",
		Function = function(val)
			if playedanim then
				playedanim:AdjustSpeed(val / 10)
			end
		end,
		Min = 1,
		Max = 20,
		Double = 10
	})
end)

run(function()
	local GamingChair = {Enabled = false}
	local GamingChairColor = {Value = 1}
	local chair
	local chairanim
	local chairhighlight
	local movingsound
	local flyingsound
	local wheelpositions = {
		Vector3.new(-0.8, -0.6, -0.18),
		Vector3.new(0.1, -0.6, -0.88),
		Vector3.new(0, -0.6, 0.7)
	}
	local currenttween
	GamingChair = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "GamingChair",
		Function = function(callback)
			if callback then
				chair = Instance.new("MeshPart")
				chair.Color = Color3.fromRGB(21, 21, 21)
				chair.Size = Vector3.new(2.16, 3.6, 2.3) / Vector3.new(12.37, 20.636, 13.071)
				chair.CanCollide = false
				chair.MeshId = "rbxassetid://12972961089"
				chair.Material = Enum.Material.SmoothPlastic
				chair.Parent = workspace
				movingsound = Instance.new("Sound")
				movingsound.SoundId = downloadVapeAsset("vape/assets/ChairRolling.mp3")
				movingsound.Volume = 0.4
				movingsound.Looped = true
				movingsound.Parent = workspace
				flyingsound = Instance.new("Sound")
				flyingsound.SoundId = downloadVapeAsset("vape/assets/ChairFlying.mp3")
				flyingsound.Volume = 0.4
				flyingsound.Looped = true
				flyingsound.Parent = workspace
				local chairweld = Instance.new("WeldConstraint")
				chairweld.Part0 = chair
				chairweld.Parent = chair
				if isAlive(lplr, true) then
					chair.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
					chairweld.Part1 = lplr.Character.HumanoidRootPart
				end
				chairhighlight = Instance.new("Highlight")
				chairhighlight.FillTransparency = 1
				chairhighlight.OutlineColor = Color3.fromHSV(GamingChairColor.Hue, GamingChairColor.Sat, GamingChairColor.Value)
				chairhighlight.DepthMode = Enum.HighlightDepthMode.Occluded
				chairhighlight.OutlineTransparency = 0.2
				chairhighlight.Parent = chair
				local chairarms = Instance.new("MeshPart")
				chairarms.Color = chair.Color
				chairarms.Size = Vector3.new(1.39, 1.345, 2.75) / Vector3.new(97.13, 136.216, 234.031)
				chairarms.CFrame = chair.CFrame * CFrame.new(-0.169, -1.129, -0.013)
				chairarms.MeshId = "rbxassetid://12972673898"
				chairarms.CanCollide = false
				chairarms.Parent = chair
				local chairarmsweld = Instance.new("WeldConstraint")
				chairarmsweld.Part0 = chairarms
				chairarmsweld.Part1 = chair
				chairarmsweld.Parent = chair
				local chairlegs = Instance.new("MeshPart")
				chairlegs.Color = chair.Color
				chairlegs.Name = "Legs"
				chairlegs.Size = Vector3.new(1.8, 1.2, 1.8) / Vector3.new(10.432, 8.105, 9.488)
				chairlegs.CFrame = chair.CFrame * CFrame.new(0.047, -2.324, 0)
				chairlegs.MeshId = "rbxassetid://13003181606"
				chairlegs.CanCollide = false
				chairlegs.Parent = chair
				local chairfan = Instance.new("MeshPart")
				chairfan.Color = chair.Color
				chairfan.Name = "Fan"
				chairfan.Size = Vector3.zero
				chairfan.CFrame = chair.CFrame * CFrame.new(0, -1.873, 0)
				chairfan.MeshId = "rbxassetid://13004977292"
				chairfan.CanCollide = false
				chairfan.Parent = chair
				local trails = {}
				for i,v in pairs(wheelpositions) do
					local attachment = Instance.new("Attachment")
					attachment.Position = v
					attachment.Parent = chairlegs
					local attachment2 = Instance.new("Attachment")
					attachment2.Position = v + Vector3.new(0, 0, 0.18)
					attachment2.Parent = chairlegs
					local trail = Instance.new("Trail")
					trail.Texture = "rbxassetid://13005168530"
					trail.TextureMode = Enum.TextureMode.Static
					trail.Transparency = NumberSequence.new(0.5)
					trail.Color = ColorSequence.new(Color3.new(0.5, 0.5, 0.5))
					trail.Attachment0 = attachment
					trail.Attachment1 = attachment2
					trail.Lifetime = 20
					trail.MaxLength = 60
					trail.MinLength = 0.1
					trail.Parent = chairlegs
					table.insert(trails, trail)
				end
				chairanim = {Stop = function() end}
				local oldmoving = false
				local oldflying = false
				task.spawn(function()
					repeat
						task.wait()
						if not GamingChair.Enabled then break end
						if isAlive(lplr, true) and lplr.Character.Humanoid.Health > 0 then
							if not chairanim.IsPlaying then
								local temp2 = Instance.new("Animation")
								temp2.AnimationId = lplr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 and "rbxassetid://2506281703" or "rbxassetid://178130996"
								chairanim = lplr.Character.Humanoid:LoadAnimation(temp2)
								chairanim.Priority = Enum.AnimationPriority.Movement
								chairanim.Looped = true
								chairanim:Play()
							end
							--welds didn't work for these idk why so poop code :troll:
							chair.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-90), 0)
							chairweld.Part1 = lplr.Character.HumanoidRootPart
							chairlegs.Velocity = Vector3.zero
							chairlegs.CFrame = chair.CFrame * CFrame.new(0.047, -2.324, 0)
							chairfan.Velocity = Vector3.zero
							chairfan.CFrame = chair.CFrame * CFrame.new(0.047, -1.873, 0) * CFrame.Angles(0, math.rad(tick() * 180 % 360), math.rad(180))
							local moving = lplr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running and lplr.Character.Humanoid.MoveDirection ~= Vector3.zero
							local flying = GuiLibrary.ObjectsThatCanBeSaved.FlyOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.LongJumpOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.LongJumpOptionsButton.Api.Enabled or GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton and GuiLibrary.ObjectsThatCanBeSaved.InfiniteFlyOptionsButton.Api.Enabled
							if movingsound.TimePosition > 1.9 then
								movingsound.TimePosition = 0.2
							end
							movingsound.PlaybackSpeed = (lplr.Character.HumanoidRootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude / 16
							for i,v in pairs(trails) do
								v.Enabled = not flying and moving
								v.Color = ColorSequence.new(movingsound.PlaybackSpeed > 1.5 and Color3.new(1, 0.5, 0) or Color3.new())
							end
							if moving ~= oldmoving then
								if movingsound.IsPlaying then
									if not moving then movingsound:Stop() end
								else
									if not flying and moving then movingsound:Play() end
								end
								oldmoving = moving
							end
							if flying ~= oldflying then
								if flying then
									if movingsound.IsPlaying then
										movingsound:Stop()
									end
									if not flyingsound.IsPlaying then
										flyingsound:Play()
									end
									if currenttween then currenttween:Cancel() end
									tween = tweenService:Create(chairlegs, TweenInfo.new(0.15), {Size = Vector3.zero})
									tween.Completed:Connect(function(state)
										if state == Enum.PlaybackState.Completed then
											chairfan.Transparency = 0
											chairlegs.Transparency = 1
											tween = tweenService:Create(chairfan, TweenInfo.new(0.15), {Size = Vector3.new(1.534, 0.328, 1.537) / Vector3.new(791.138, 168.824, 792.027)})
											tween:Play()
										end
									end)
									tween:Play()
								else
									if flyingsound.IsPlaying then
										flyingsound:Stop()
									end
									if not movingsound.IsPlaying and moving then
										movingsound:Play()
									end
									if currenttween then currenttween:Cancel() end
									tween = tweenService:Create(chairfan, TweenInfo.new(0.15), {Size = Vector3.zero})
									tween.Completed:Connect(function(state)
										if state == Enum.PlaybackState.Completed then
											chairfan.Transparency = 1
											chairlegs.Transparency = 0
											tween = tweenService:Create(chairlegs, TweenInfo.new(0.15), {Size = Vector3.new(1.8, 1.2, 1.8) / Vector3.new(10.432, 8.105, 9.488)})
											tween:Play()
										end
									end)
									tween:Play()
								end
								oldflying = flying
							end
						else
							chair.Anchored = true
							chairlegs.Anchored = true
							chairfan.Anchored = true
							repeat task.wait() until isAlive(lplr, true) and lplr.Character.Humanoid.Health > 0
							chair.Anchored = false
							chairlegs.Anchored = false
							chairfan.Anchored = false
							chairanim:Stop()
						end
					until not GamingChair.Enabled
				end)
			else
				if chair then chair:Destroy() end
				if chairanim then chairanim:Stop() end
				if movingsound then movingsound:Destroy() end
				if flyingsound then flyingsound:Destroy() end
			end
		end
	})
	GamingChairColor = GamingChair.CreateColorSlider({
		Name = "Color",
		Function = function(h, s, v)
			if chairhighlight then
				chairhighlight.OutlineColor = Color3.fromHSV(h, s, v)
			end
		end
	})
end)

run(function()
	local SongBeats = {Enabled = false}
	local SongBeatsList = {ObjectList = {}}
	local SongTween
	local SongAudio
	local SongFOV

	local function PlaySong(arg)
		local args = arg:split(":")
		local song = isfile(args[1]) and getcustomasset(args[1]) or tonumber(args[1]) and "rbxassetid://"..args[1]
		if not song then
			warningNotification("SongBeats", "missing music file "..args[1], 5)
			SongBeats.ToggleButton(false)
			return
		end
		local bpm = 1 / (args[2] / 60)
		SongAudio = Instance.new("Sound")
		SongAudio.SoundId = song
		SongAudio.Parent = workspace
		SongAudio:Play()
		repeat
			repeat task.wait() until SongAudio.IsLoaded or (not SongBeats.Enabled)
			if (not SongBeats.Enabled) then break end
			gameCamera.FieldOfView = SongFOV - 5
			if SongTween then SongTween:Cancel() end
			SongTween = tweenService:Create(gameCamera, TweenInfo.new(0.2), {FieldOfView = SongFOV})
			SongTween:Play()
			task.wait(bpm)
		until (not SongBeats.Enabled) or SongAudio.IsPaused
	end

	SongBeats = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "SongBeats",
		Function = function(callback)
			if callback then
				SongFOV = gameCamera.FieldOfView
				task.spawn(function()
					if #SongBeatsList.ObjectList <= 0 then
						warningNotification("SongBeats", "no songs", 5)
						SongBeats.ToggleButton(false)
						return
					end
					local lastChosen
					repeat
						local newSong
						repeat newSong = SongBeatsList.ObjectList[Random.new():NextInteger(1, #SongBeatsList.ObjectList)] task.wait() until newSong ~= lastChosen or #SongBeatsList.ObjectList <= 1
						lastChosen = newSong
						PlaySong(newSong)
						if not SongBeats.Enabled then break end
						task.wait(2)
					until (not SongBeats.Enabled)
				end)
			else
				if SongAudio then SongAudio:Destroy() end
				if SongTween then SongTween:Cancel() end
				gameCamera.FieldOfView = SongFOV
			end
		end
	})
	SongBeatsList = SongBeats.CreateTextList({
		Name = "SongList",
		TempText = "songpath:bpm"
	})
end)

runFunction(function()
	local Atmosphere = {}
	local AtmosphereMethod = {Value = 'Custom'}
	local skythemeobjects = {}
	local SkyUp = {Value = ''}
	local SkyDown = {Value = ''}
	local SkyLeft = {Value = ''}
	local SkyRight = {Value = ''}
	local SkyFront = {Value = ''}
	local SkyBack = {Value = ''}
	local SkySun = {Value = ''}
	local SkyMoon = {Value = ''}
	local SkyColor = {Value = 1}
	local skyobj
	local skyatmosphereobj
	local oldtime
	local oldobjects = {}
	local themetable = {
		Custom = function() 
			skyobj.SkyboxBk = tonumber(SkyBack.Value) and 'rbxassetid://'..SkyBack.Value or SkyBack.Value
			skyobj.SkyboxDn = tonumber(SkyDown.Value) and 'rbxassetid://'..SkyDown.Value or SkyDown.Value
			skyobj.SkyboxFt = tonumber(SkyFront.Value) and 'rbxassetid://'..SkyFront.Value or SkyFront.Value
			skyobj.SkyboxLf = tonumber(SkyLeft.Value) and 'rbxassetid://'..SkyLeft.Value or SkyLeft.Value
			skyobj.SkyboxRt = tonumber(SkyRight.Value) and 'rbxassetid://'..SkyRight.Value or SkyRight.Value
			skyobj.SkyboxUp = tonumber(SkyUp.Value) and 'rbxassetid://'..SkyUp.Value or SkyUp.Value
			skyobj.SunTextureId = tonumber(SkySun.Value) and 'rbxassetid://'..SkySun.Value or SkySun.Value
			skyobj.MoonTextureId = tonumber(SkyMoon.Value) and 'rbxassetid://'..SkyMoon.Value or SkyMoon.Value
		end,
		Purple = function()
            skyobj.SkyboxBk = 'rbxassetid://8539982183'
            skyobj.SkyboxDn = 'rbxassetid://8539981943'
            skyobj.SkyboxFt = 'rbxassetid://8539981721'
            skyobj.SkyboxLf = 'rbxassetid://8539981424'
            skyobj.SkyboxRt = 'rbxassetid://8539980766'
            skyobj.SkyboxUp = 'rbxassetid://8539981085'
			skyobj.MoonAngularSize = 0
            skyobj.SunAngularSize = 0
            skyobj.StarCount = 3e3
		end,
		Galaxy = function()
            skyobj.SkyboxBk = 'rbxassetid://159454299'
            skyobj.SkyboxDn = 'rbxassetid://159454296'
            skyobj.SkyboxFt = 'rbxassetid://159454293'
            skyobj.SkyboxLf = 'rbxassetid://159454293'
            skyobj.SkyboxRt = 'rbxassetid://159454293'
            skyobj.SkyboxUp = 'rbxassetid://159454288'
			skyobj.SunAngularSize = 0
		end,
		BetterNight = function()
			skyobj.SkyboxBk = 'rbxassetid://155629671'
            skyobj.SkyboxDn = 'rbxassetid://12064152'
            skyobj.SkyboxFt = 'rbxassetid://155629677'
            skyobj.SkyboxLf = 'rbxassetid://155629662'
            skyobj.SkyboxRt = 'rbxassetid://155629666'
            skyobj.SkyboxUp = 'rbxassetid://155629686'
			skyobj.SunAngularSize = 0
		end,
		BetterNight2 = function()
			skyobj.SkyboxBk = 'rbxassetid://248431616'
            skyobj.SkyboxDn = 'rbxassetid://248431677'
            skyobj.SkyboxFt = 'rbxassetid://248431598'
            skyobj.SkyboxLf = 'rbxassetid://248431686'
            skyobj.SkyboxRt = 'rbxassetid://248431611'
            skyobj.SkyboxUp = 'rbxassetid://248431605'
			skyobj.StarCount = 3000
		end,
		MagentaOrange = function()
			skyobj.SkyboxBk = 'rbxassetid://566616113'
            skyobj.SkyboxDn = 'rbxassetid://566616232'
            skyobj.SkyboxFt = 'rbxassetid://566616141'
            skyobj.SkyboxLf = 'rbxassetid://566616044'
            skyobj.SkyboxRt = 'rbxassetid://566616082'
            skyobj.SkyboxUp = 'rbxassetid://566616187'
			skyobj.StarCount = 3000
		end,
		Purple2 = function()
			skyobj.SkyboxBk = 'rbxassetid://8107841671'
			skyobj.SkyboxDn = 'rbxassetid://6444884785'
			skyobj.SkyboxFt = 'rbxassetid://8107841671'
			skyobj.SkyboxLf = 'rbxassetid://8107841671'
			skyobj.SkyboxRt = 'rbxassetid://8107841671'
			skyobj.SkyboxUp = 'rbxassetid://8107849791'
			skyobj.SunTextureId = 'rbxassetid://6196665106'
			skyobj.MoonTextureId = 'rbxassetid://6444320592'
			skyobj.MoonAngularSize = 0
		end,
		Galaxy2 = function()
			skyobj.SkyboxBk = 'rbxassetid://14164368678'
			skyobj.SkyboxDn = 'rbxassetid://14164386126'
			skyobj.SkyboxFt = 'rbxassetid://14164389230'
			skyobj.SkyboxLf = 'rbxassetid://14164398493'
			skyobj.SkyboxRt = 'rbxassetid://14164402782'
			skyobj.SkyboxUp = 'rbxassetid://14164405298'
			skyobj.SunTextureId = 'rbxassetid://8281961896'
			skyobj.MoonTextureId = 'rbxassetid://6444320592'
			skyobj.SunAngularSize = 0
			skyobj.MoonAngularSize = 0
		end,
		Pink = function()
		skyobj.SkyboxBk = 'rbxassetid://271042516'
		skyobj.SkyboxDn = 'rbxassetid://271077243'
		skyobj.SkyboxFt = 'rbxassetid://271042556'
		skyobj.SkyboxLf = 'rbxassetid://271042310'
		skyobj.SkyboxRt = 'rbxassetid://271042467'
		skyobj.SkyboxUp = 'rbxassetid://271077958'
	end,
	Purple3 = function()
		skyobj.SkyboxBk = 'rbxassetid://433274085'
		skyobj.SkyboxDn = 'rbxassetid://433274194'
		skyobj.SkyboxFt = 'rbxassetid://433274131'
		skyobj.SkyboxLf = 'rbxassetid://433274370'
		skyobj.SkyboxRt = 'rbxassetid://433274429'
		skyobj.SkyboxUp = 'rbxassetid://433274285'
	end,
	DarkishPink = function()
		skyobj.SkyboxBk = 'rbxassetid://570555736'
		skyobj.SkyboxDn = 'rbxassetid://570555964'
		skyobj.SkyboxFt = 'rbxassetid://570555800'
		skyobj.SkyboxLf = 'rbxassetid://570555840'
		skyobj.SkyboxRt = 'rbxassetid://570555882'
		skyobj.SkyboxUp = 'rbxassetid://570555929'
	end,
	Space = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://166509999'
		skyobj.SkyboxDn = 'rbxassetid://166510057'
		skyobj.SkyboxFt = 'rbxassetid://166510116'
		skyobj.SkyboxLf = 'rbxassetid://166510092'
		skyobj.SkyboxRt = 'rbxassetid://166510131'
		skyobj.SkyboxUp = 'rbxassetid://166510114'
	end,
	Galaxy3 = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://14543264135'
		skyobj.SkyboxDn = 'rbxassetid://14543358958'
		skyobj.SkyboxFt = 'rbxassetid://14543257810'
		skyobj.SkyboxLf = 'rbxassetid://14543275895'
		skyobj.SkyboxRt = 'rbxassetid://14543280890'
		skyobj.SkyboxUp = 'rbxassetid://14543371676'
	end,
	NetherWorld = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://14365019002'
		skyobj.SkyboxDn = 'rbxassetid://14365023350'
		skyobj.SkyboxFt = 'rbxassetid://14365018399'
		skyobj.SkyboxLf = 'rbxassetid://14365018705'
		skyobj.SkyboxRt = 'rbxassetid://14365018143'
		skyobj.SkyboxUp = 'rbxassetid://14365019327'
	end,
	Nebula = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://5260808177'
		skyobj.SkyboxDn = 'rbxassetid://5260653793'
		skyobj.SkyboxFt = 'rbxassetid://5260817288'
		skyobj.SkyboxLf = 'rbxassetid://5260800833'
		skyobj.SkyboxRt = 'rbxassetid://5260811073'
		skyobj.SkyboxUp = 'rbxassetid://5260824661'
	end,
	PurpleSpace = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://15983968922'
		skyobj.SkyboxDn = 'rbxassetid://15983966825'
		skyobj.SkyboxFt = 'rbxassetid://15983965025'
		skyobj.SkyboxLf = 'rbxassetid://15983967420'
		skyobj.SkyboxRt = 'rbxassetid://15983966246'
		skyobj.SkyboxUp = 'rbxassetid://15983964246'
		skyobj.SkyboxFt = 'rbxassetid://5260817288'
		skyobj.StarCount = 3000
	end,
	PurpleNight = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://5260808177'
		skyobj.SkyboxDn = 'rbxassetid://5260653793'
		skyobj.SkyboxFt = 'rbxassetid://5260817288'
		skyobj.SkyboxLf = 'rbxassetid://5260800833'
		skyobj.SkyboxRt = 'rbxassetid://5260800833'
		skyobj.SkyboxUp = 'rbxassetid://5084576400'
	end,
	Aesthetic = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://1417494030'
		skyobj.SkyboxDn = 'rbxassetid://1417494146'
		skyobj.SkyboxFt = 'rbxassetid://1417494253'
		skyobj.SkyboxLf = 'rbxassetid://1417494402'
		skyobj.SkyboxRt = 'rbxassetid://1417494499'
		skyobj.SkyboxUp = 'rbxassetid://1417494643'
	end,
	Aesthetic2 = function()
		skyobj.MoonAngularSize = 0
		skyobj.SunAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://600830446'
		skyobj.SkyboxDn = 'rbxassetid://600831635'
		skyobj.SkyboxFt = 'rbxassetid://600832720'
		skyobj.SkyboxLf = 'rbxassetid://600886090'
		skyobj.SkyboxRt = 'rbxassetid://600833862'
		skyobj.SkyboxUp = 'rbxassetid://600835177'
	end,
	Pastel = function()
		skyobj.SunAngularSize = 0
		skyobj.MoonAngularSize = 0
		skyobj.SkyboxBk = 'rbxassetid://2128458653'
		skyobj.SkyboxDn = 'rbxassetid://2128462480'
		skyobj.SkyboxFt = 'rbxassetid://2128458653'
		skyobj.SkyboxLf = 'rbxassetid://2128462027'
		skyobj.SkyboxRt = 'rbxassetid://2128462027'
		skyobj.SkyboxUp = 'rbxassetid://2128462236'
	end,
	PurpleClouds = function()
		skyobj.SkyboxBk = 'rbxassetid://570557514'
		skyobj.SkyboxDn = 'rbxassetid://570557775'
		skyobj.SkyboxFt = 'rbxassetid://570557559'
		skyobj.SkyboxLf = 'rbxassetid://570557620'
		skyobj.SkyboxRt = 'rbxassetid://570557672'
		skyobj.SkyboxUp = 'rbxassetid://570557727'
	end,
	BetterSky = function()
		if skyobj then
		skyobj.SkyboxBk = 'rbxassetid://591058823'
		skyobj.SkyboxDn = 'rbxassetid://591059876'
		skyobj.SkyboxFt = 'rbxassetid://591058104'
		skyobj.SkyboxLf = 'rbxassetid://591057861'
		skyobj.SkyboxRt = 'rbxassetid://591057625'
		skyobj.SkyboxUp = 'rbxassetid://591059642'
		end
	end,
	BetterNight3 = function()
		skyobj.MoonTextureId = 'rbxassetid://1075087760'
		skyobj.SkyboxBk = 'rbxassetid://2670643994'
		skyobj.SkyboxDn = 'rbxassetid://2670643365'
		skyobj.SkyboxFt = 'rbxassetid://2670643214'
		skyobj.SkyboxLf = 'rbxassetid://2670643070'
		skyobj.SkyboxRt = 'rbxassetid://2670644173'
		skyobj.SkyboxUp = 'rbxassetid://2670644331'
		skyobj.MoonAngularSize = 1.5
		skyobj.StarCount = 500
	end,
	Orange = function()
		skyobj.SkyboxBk = 'rbxassetid://150939022'
		skyobj.SkyboxDn = 'rbxassetid://150939038'
		skyobj.SkyboxFt = 'rbxassetid://150939047'
		skyobj.SkyboxLf = 'rbxassetid://150939056'
		skyobj.SkyboxRt = 'rbxassetid://150939063'
		skyobj.SkyboxUp = 'rbxassetid://150939082'
	end,
	DarkMountains = function()
		skyobj.SkyboxBk = 'rbxassetid://5098814730'
		skyobj.SkyboxDn = 'rbxassetid://5098815227'
		skyobj.SkyboxFt = 'rbxassetid://5098815653'
		skyobj.SkyboxLf = 'rbxassetid://5098816155'
		skyobj.SkyboxRt = 'rbxassetid://5098820352'
		skyobj.SkyboxUp = 'rbxassetid://5098819127'
	end,
	FlamingSunset = function()
		skyobj.SkyboxBk = 'rbxassetid://415688378'
		skyobj.SkyboxDn = 'rbxassetid://415688193'
		skyobj.SkyboxFt = 'rbxassetid://415688242'
		skyobj.SkyboxLf = 'rbxassetid://415688310'
		skyobj.SkyboxRt = 'rbxassetid://415688274'
		skyobj.SkyboxUp = 'rbxassetid://415688354'
	end,
	NewYork = function()
		skyobj.SkyboxBk = 'rbxassetid://11333973069'
		skyobj.SkyboxDn = 'rbxassetid://11333969768'
		skyobj.SkyboxFt = 'rbxassetid://11333964303'
		skyobj.SkyboxLf = 'rbxassetid://11333971332'
		skyobj.SkyboxRt = 'rbxassetid://11333982864'
		skyobj.SkyboxUp = 'rbxassetid://11333967970'
		skyobj.SunAngularSize = 0
	end,
	Aesthetic3 = function()
		skyobj.SkyboxBk = 'rbxassetid://151165214'
		skyobj.SkyboxDn = 'rbxassetid://151165197'
		skyobj.SkyboxFt = 'rbxassetid://151165224'
		skyobj.SkyboxLf = 'rbxassetid://151165191'
		skyobj.SkyboxRt = 'rbxassetid://151165206'
		skyobj.SkyboxUp = 'rbxassetid://151165227'
	end,
	FakeClouds = function()
		skyobj.SkyboxBk = 'rbxassetid://8496892810'
		skyobj.SkyboxDn = 'rbxassetid://8496896250'
		skyobj.SkyboxFt = 'rbxassetid://8496892810'
		skyobj.SkyboxLf = 'rbxassetid://8496892810'
		skyobj.SkyboxRt = 'rbxassetid://8496892810'
		skyobj.SkyboxUp = 'rbxassetid://8496897504'
		skyobj.SunAngularSize = 0
	end,
	LunarNight = function()
		skyobj.SkyboxBk = 'rbxassetid://187713366'
		skyobj.SkyboxDn = 'rbxassetid://187712428'
		skyobj.SkyboxFt = 'rbxassetid://187712836'
		skyobj.SkyboxLf = 'rbxassetid://187713755'
		skyobj.SkyboxRt = 'rbxassetid://187714525'
		skyobj.SkyboxUp = 'rbxassetid://187712111'
		skyobj.SunAngularSize = 0
		skyobj.StarCount = 0
	end,
	FPSBoost = function()
		skyobj.SkyboxBk = 'rbxassetid://11457548274'
		skyobj.SkyboxDn = 'rbxassetid://11457548274'
		skyobj.SkyboxFt = 'rbxassetid://11457548274'
		skyobj.SkyboxLf = 'rbxassetid://11457548274'
		skyobj.SkyboxRt = 'rbxassetid://11457548274'
		skyobj.SkyboxUp = 'rbxassetid://11457548274'
		skyobj.SunAngularSize = 0
		skyobj.StarCount = 3000
	end,
	PurplePlanet = function()
		skyobj.SkyboxBk = 'rbxassetid://16262356578'
		skyobj.SkyboxDn = 'rbxassetid://16262358026'
		skyobj.SkyboxFt = 'rbxassetid://16262360469'
		skyobj.SkyboxLf = 'rbxassetid://16262362003'
		skyobj.SkyboxRt = 'rbxassetid://16262363873'
		skyobj.SkyboxUp = 'rbxassetid://16262366016'
		skyobj.SunAngularSize = 21
		skyobj.StarCount = 3000
	end
}

Atmosphere = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'Atmosphere',
		ExtraText = function()
			return AtmosphereMethod.Value ~= 'Custom' and AtmosphereMethod.Value or ''
		end,
		Function = function(callback)
			if callback then 
				for i,v in next, (lightingService:GetChildren()) do 
					if v:IsA('PostEffect') or v:IsA('Sky') then 
						table.insert(oldobjects, v)
						v.Parent = game
					end
				end
				skyobj = Instance.new('Sky')
				skyobj.Parent = lightingService
				skyatmosphereobj = Instance.new('ColorCorrectionEffect')
			    skyatmosphereobj.TintColor = Color3.fromHSV(SkyColor.Hue, SkyColor.Sat, SkyColor.Value)
			    skyatmosphereobj.Parent = lightingService
				task.spawn(themetable[AtmosphereMethod.Value])
			else
				if skyobj then skyobj:Destroy() end
				if skyatmosphereobj then skyatmosphereobj:Destroy() end
				for i,v in next, (oldobjects) do 
					v.Parent = lightingService
				end
				if oldtime then 
					lightingService.TimeOfDay = oldtime
					oldtime = nil
				end
				table.clear(oldobjects)
			end
		end
	})
	local themetab = {'Custom'}
	for i,v in themetable do 
		table.insert(themetab, i)
	end
	AtmosphereMethod = Atmosphere.CreateDropdown({
		Name = 'Mode',
		List = themetab,
		Function = function(val)
			task.spawn(function()
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				if val == 'Custom' then task.wait() end -- why is this needed :bruh:
				Atmosphere.ToggleButton()
			end
			for i,v in skythemeobjects do 
				v.Object.Visible = AtmosphereMethod.Value == 'Custom'
			end
		    end)
		end
	})
	SkyUp = Atmosphere.CreateTextBox({
		Name = 'SkyUp',
		TempText = 'Sky Top ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyDown = Atmosphere.CreateTextBox({
		Name = 'SkyDown',
		TempText = 'Sky Bottom ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyLeft = Atmosphere.CreateTextBox({
		Name = 'SkyLeft',
		TempText = 'Sky Left ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyRight = Atmosphere.CreateTextBox({
		Name = 'SkyRight',
		TempText = 'Sky Right ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyFront = Atmosphere.CreateTextBox({
		Name = 'SkyFront',
		TempText = 'Sky Front ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyBack = Atmosphere.CreateTextBox({
		Name = 'SkyBack',
		TempText = 'Sky Back ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkySun = Atmosphere.CreateTextBox({
		Name = 'SkySun',
		TempText = 'Sky Sun ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyMoon = Atmosphere.CreateTextBox({
		Name = 'SkyMoon',
		TempText = 'Sky Moon ID',
		FocusLost = function(enter) 
			if Atmosphere.Enabled then 
				Atmosphere.ToggleButton()
				Atmosphere.ToggleButton()
			end
		end
	})
	SkyColor = Atmosphere.CreateColorSlider({
		Name = 'Color',
		Function = function(h, s, v)
			if skyatmosphereobj then 
				skyatmosphereobj.TintColor = Color3.fromHSV(SkyColor.Hue, SkyColor.Sat, SkyColor.Value)
			end
		end
	})
	table.insert(skythemeobjects, SkyUp)
	table.insert(skythemeobjects, SkyDown)
	table.insert(skythemeobjects, SkyLeft)
	table.insert(skythemeobjects, SkyRight)
	table.insert(skythemeobjects, SkyFront)
	table.insert(skythemeobjects, SkyBack)
	table.insert(skythemeobjects, SkySun)
	table.insert(skythemeobjects, SkyMoon)
end)

run(function()
	local Disabler = {Enabled = false}
	local DisablerAntiKick = {Enabled = false}
	local disablerhooked = false

	local hookmethod = function(self)
		if (not Disabler.Enabled) then return end
		if type(self) == "userdata" and self == lplr then
			return true
		end
	end


	Disabler = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "ClientKickDisabler",
		Function = function(callback)
			if callback then
				if not disablerhooked then
					disablerhooked = true
					local oldnamecall
					oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
						local method = getnamecallmethod()
						if method ~= "Kick" and method ~= "kick" then return oldnamecall(self, ...) end
						if not Disabler.Enabled then
							return oldnamecall(self, ...)
						end
						if not hookmethod(self) then return oldnamecall(self, ...) end
						return
					end)
					local antikick
					antikick = hookfunction(lplr.Kick, function(self, ...)
						if not Disabler.Enabled then return antikick(self, ...) end
						if type(self) == "userdata" and self == lplr then
							return
						end
						return antikick(self, ...)
					end)
				end
			else
				if restorefunction then
					restorefunction(lplr.Kick)
					restorefunction(getrawmetatable(game).__namecall)
					disablerhooked = false
				end
			end
		end
	})
end)

run(function()
	local FPS = {}
	local FPSLabel
	FPS = GuiLibrary.CreateLegitModule({
		Name = "FPS",
		Function = function(callback)
			if callback then
				local frames = {}
				local framerate = 0
				local startClock = os.clock()
				local updateTick = tick()
				RunLoops:BindToHeartbeat("FPS", function()
					-- https://devforum.roblox.com/t/get-client-fps-trough-a-script/282631, annoying math, I thought either adding dt to a table or doing 1 / dt would work, but this is just better lol
					local updateClock = os.clock()
					for i = #frames, 1, -1 do
						frames[i + 1] = frames[i] >= updateClock - 1 and frames[i] or nil
					end
					frames[1] = updateClock
					if updateTick < tick() then
						updateTick = tick() + 1
						FPSLabel.Text = math.floor(os.clock() - startClock >= 1 and #frames or #frames / (os.clock() - startClock)).." FPS"
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("FPS")
			end
		end
	})
	FPSLabel = Instance.new("TextLabel")
	FPSLabel.Size = UDim2.new(0, 100, 0, 41)
	FPSLabel.BackgroundTransparency = 0.5
	FPSLabel.TextSize = 15
	FPSLabel.Font = Enum.Font.Gotham
	FPSLabel.Text = "inf FPS"
	FPSLabel.TextColor3 = Color3.new(1, 1, 1)
	FPSLabel.BackgroundColor3 = Color3.new()
	FPSLabel.Parent = FPS.GetCustomChildren()
	local ReachCorner = Instance.new("UICorner")
	ReachCorner.CornerRadius = UDim.new(0, 4)
	ReachCorner.Parent = FPSLabel
end)


run(function()
	local Ping = {}
	local PingLabel
	Ping = GuiLibrary.CreateLegitModule({
		Name = "Ping",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						PingLabel.Text = math.floor(tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())).." ms"
						task.wait(1)
					until false
				end)
			end
		end
	})
	PingLabel = Instance.new("TextLabel")
	PingLabel.Size = UDim2.new(0, 100, 0, 41)
	PingLabel.BackgroundTransparency = 0.5
	PingLabel.TextSize = 15
	PingLabel.Font = Enum.Font.Gotham
	PingLabel.Text = "0 ms"
	PingLabel.TextColor3 = Color3.new(1, 1, 1)
	PingLabel.BackgroundColor3 = Color3.new()
	PingLabel.Parent = Ping.GetCustomChildren()
	local PingCorner = Instance.new("UICorner")
	PingCorner.CornerRadius = UDim.new(0, 4)
	PingCorner.Parent = PingLabel
end)

run(function()
	local Keystrokes = {}
	local keys = {}
	local keystrokesframe
	local keyconnection1
	local keyconnection2

	local function createKeystroke(keybutton, pos, pos2)
		local key = Instance.new("Frame")
		key.Size = keybutton == Enum.KeyCode.Space and UDim2.new(0, 110, 0, 24) or UDim2.new(0, 34, 0, 36)
		key.BackgroundColor3 = Color3.new()
		key.BackgroundTransparency = 0.5
		key.Position = pos
		key.Name = keybutton.Name
		key.Parent = keystrokesframe
		local keytext = Instance.new("TextLabel")
		keytext.BackgroundTransparency = 1
		keytext.Size = UDim2.new(1, 0, 1, 0)
		keytext.Font = Enum.Font.Gotham
		keytext.Text = keybutton == Enum.KeyCode.Space and "______" or keybutton.Name
		keytext.TextXAlignment = Enum.TextXAlignment.Left
		keytext.TextYAlignment = Enum.TextYAlignment.Top
		keytext.Position = pos2
		keytext.TextSize = keybutton == Enum.KeyCode.Space and 18 or 15
		keytext.TextColor3 = Color3.new(1, 1, 1)
		keytext.Parent = key
		local keycorner = Instance.new("UICorner")
		keycorner.CornerRadius = UDim.new(0, 4)
		keycorner.Parent = key
		keys[keybutton] = {Key = key}
	end

	Keystrokes = GuiLibrary.CreateLegitModule({
		Name = "Keystrokes",
		Function = function(callback)
			if callback then
				keyconnection1 = inputService.InputBegan:Connect(function(inputType)
					local key = keys[inputType.KeyCode]
					if key then
						if key.Tween then key.Tween:Cancel() end
						if key.Tween2 then key.Tween2:Cancel() end
						key.Tween = tweenService:Create(key.Key, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0})
						key.Tween:Play()
						key.Tween2 = tweenService:Create(key.Key.TextLabel, TweenInfo.new(0.1), {TextColor3 = Color3.new()})
						key.Tween2:Play()
					end
				end)
				keyconnection2 = inputService.InputEnded:Connect(function(inputType)
					local key = keys[inputType.KeyCode]
					if key then
						if key.Tween then key.Tween:Cancel() end
						if key.Tween2 then key.Tween2:Cancel() end
						key.Tween = tweenService:Create(key.Key, TweenInfo.new(0.1), {BackgroundColor3 = Color3.new(), BackgroundTransparency = 0.5})
						key.Tween:Play()
						key.Tween2 = tweenService:Create(key.Key.TextLabel, TweenInfo.new(0.1), {TextColor3 = Color3.new(1, 1, 1)})
						key.Tween2:Play()
					end
				end)
			else
				if keyconnection1 then keyconnection1:Disconnect() end
				if keyconnection2 then keyconnection2:Disconnect() end
			end
		end
	})
	keystrokesframe = Instance.new("Frame")
	keystrokesframe.Size = UDim2.new(0, 110, 0, 176)
	keystrokesframe.BackgroundTransparency = 1
	keystrokesframe.Parent = Keystrokes.GetCustomChildren()
	createKeystroke(Enum.KeyCode.W, UDim2.new(0, 38, 0, 0), UDim2.new(0, 6, 0, 5))
	createKeystroke(Enum.KeyCode.S, UDim2.new(0, 38, 0, 42), UDim2.new(0, 8, 0, 5))
	createKeystroke(Enum.KeyCode.A, UDim2.new(0, 0, 0, 42), UDim2.new(0, 7, 0, 5))
	createKeystroke(Enum.KeyCode.D, UDim2.new(0, 76, 0, 42), UDim2.new(0, 8, 0, 5))
	createKeystroke(Enum.KeyCode.Space, UDim2.new(0, 0, 0, 83), UDim2.new(0, 25, 0, -10))
end)


task.spawn(function()
	repeat 
		local success, ping = pcall(function() return game:GetService('Stats').PerformanceStats.Ping:GetValue() end)
		if success and tonumber(ping) then 
			RenderStore.ping = tonumber(ping)
		end
		task.wait()
	until not vapeInjected
end)

table.insert(vapeConnections, runService.Stepped:Connect(function()
	if isAlive() then 
		RenderStore.LocalPosition = lplr.Character.HumanoidRootPart.Position
	end
end))

textChatService.OnIncomingMessage = function(message) 
	local properties = Instance.new('TextChatMessageProperties')
	if message.TextSource then 
		local player = playersService:GetPlayerByUserId(message.TextSource.UserId) 
		local rendertag = (player and RenderFunctions.playerTags[player])
		if rendertag then 
			properties.PrefixText = "<font color='#"..rendertag.Color.."'>["..rendertag.Text.."] </font> " ..message.PrefixText or message.PrefixText
		end
	end
	return properties
end

pcall(function()
	local chatTables = {}
	local oldchatfunc
	for i,v in next, getconnections(replicatedStorageService.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent) do 
		if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == 'table' then
			local chatvalues = getmetatable(debug.getupvalues(v.Function)[1]) 
			if chatvalues and chatvalues.GetChannel then  
				oldchatfunc = chatvalues.GetChannel 
				chatvalues.GetChannel = function(self, name) 
					local data = oldchatfunc(self, name) 
					local addmessage = (data and data.AddMessageToChannel)
					if data and data.AddMessageToChannel then 
						if chatTables[data] == nil then 
							chatTables[data] = data.AddMessageToChannel 
						end 
						data.AddMessageToChannel = function(self2, data2)
							pcall(function()
								local plr = playersService:FindFirstChild(data2.FromSpeaker)
								local rendertag = (plr and RenderFunctions.playerTags[plr])
								if data2.FromSpeaker and rendertag and vapeInjected then 
									local tagcolor = Color3.fromHex(rendertag.Color)
									data2.ExtraData = {
										Tags = {unpack(data2.ExtraData.Tags), {TagText = rendertag.Text, TagColor = tagcolor}},
										NameColor = plr.Team == nil and Color3.fromRGB(tagcolor.R * 235, tagcolor.G * 235, tagcolor.B * 235) or plr.TeamColor.Color
									}
								end 
							end)
							return addmessage(self2, data2)
						end
						return data
					end
				end
			end
		end
	end 
end)

task.spawn(function()
	local function whitelistFunction(plr)
		repeat task.wait() until (RenderFunctions.whitelist.state > 0)
		local rank = RenderFunctions.whitelist:get(1, plr)
		local prio = RenderFunctions.whitelist:get(3, plr)
		if prio > 1 and prio > RenderFunctions.whitelist:get(3) and rank ~= 'BETA' then 
			sendprivatemessage(plr, 'rendermoment')
		end
	end
	for i,v in next, playersService:GetPlayers() do 
		task.spawn(whitelistFunction, v) 
	end 
	table.insert(vapeConnections, playersService.PlayerAdded:Connect(whitelistFunction))
	repeat
		if shared.VapeFullyLoaded and RenderFunctions.whitelist:get(3) > 1 then 
			warningNotification('Render Whitelist', 'You\'ve successfully been authenticated.', 4.5)
			break
		end
		task.wait()
	until (not vapeInjected)
end)

runFunction(function()
	local HudAnimation = {Enabled = false}
	local ModrenGui = Instance.new("ScreenGui")
	local TargetInfo = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local TargetProfile = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local DisplayName = Instance.new("TextLabel")
	local TargetName = Instance.new("TextLabel")
	local TargetHealthBar = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local FullHealthBar = Instance.new("Frame")
	local FullHealthBarCorners = Instance.new("UICorner")
	local HP = Instance.new("TextLabel")
	local TargetHP = Instance.new("TextLabel")

	ModrenGui.Name = "ModrenGui"
	ModrenGui.Parent = lplr.PlayerGui
	ModrenGui.ResetOnSpawn = false

	TargetInfo.Name = "TargetInfo"
	TargetInfo.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	TargetInfo.BackgroundTransparency = 0.180
	TargetInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetInfo.BorderSizePixel = 0
	TargetInfo.Size = UDim2.new(0, 336, 0, 108)

	UICorner.CornerRadius = UDim.new(0, 20)
	UICorner.Parent = TargetInfo

	TargetProfile.Name = "TargetProfile"
	TargetProfile.Parent = TargetInfo
	TargetProfile.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TargetProfile.BackgroundTransparency = 0.800
	TargetProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetProfile.BorderSizePixel = 0
	TargetProfile.Position = UDim2.new(0.0457316823, 0, 0.171846747, 0)
	TargetProfile.Size = UDim2.new(0, 70, 0, 70)
	TargetProfile.Image = "rbxassetid://16504243510"

	UICorner_2.CornerRadius = UDim.new(0, 13)
	UICorner_2.Parent = TargetProfile

	DisplayName.Name = "DisplayName"
	DisplayName.Parent = TargetInfo
	DisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DisplayName.BackgroundTransparency = 1.000
	DisplayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DisplayName.BorderSizePixel = 0
	DisplayName.Position = UDim2.new(0.283972234, 0, 0.22989513, 0)
	DisplayName.Size = UDim2.new(0, 206, 0, 20)
	DisplayName.Font = Enum.Font.Unknown
	DisplayName.Text = "Username:"
	DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	DisplayName.TextScaled = true
	DisplayName.TextSize = 14.000
	DisplayName.TextWrapped = true
	DisplayName.TextXAlignment = Enum.TextXAlignment.Left

	TargetName.Name = "TargetName"
	TargetName.Parent = TargetInfo
	TargetName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TargetName.BackgroundTransparency = 1.000
	TargetName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetName.BorderSizePixel = 0
	TargetName.Position = UDim2.new(0.579703927, 0, 0.229895085, 0)
	TargetName.Size = UDim2.new(0, 133, 0, 20)
	TargetName.Font = Enum.Font.Unknown
	TargetName.Text = lplr.DisplayName
	TargetName.TextColor3 = Color3.fromRGB(170, 0, 255)
	TargetName.TextScaled = true
	TargetName.TextSize = 14.000
	TargetName.TextWrapped = true
	TargetName.TextXAlignment = Enum.TextXAlignment.Left

	TargetHealthBar.Name = "TargetHealthBar"
	TargetHealthBar.Parent = TargetInfo
	TargetHealthBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	TargetHealthBar.BackgroundTransparency = 0.100
	TargetHealthBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetHealthBar.BorderSizePixel = 0
	TargetHealthBar.Position = UDim2.new(0.28273809, 0, 0.471865892, 0)
	TargetHealthBar.Size = UDim2.new(0, 216, 0, 12)

	UICorner_3.CornerRadius = UDim.new(0, 10)
	UICorner_3.Parent = TargetHealthBar

	FullHealthBar.Name = "FullHealthBar"
	FullHealthBar.Parent = TargetHealthBar
	FullHealthBar.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
	FullHealthBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FullHealthBar.BorderSizePixel = 0
	FullHealthBar.Position = UDim2.new(-0.00462934701, 0, -0.00961558055, 0)
	FullHealthBar.Size = UDim2.new(0, 216, 0, 12)

	FullHealthBarCorners.CornerRadius = UDim.new(0, 10)
	FullHealthBarCorners.Name = "FullHealthBarCorner"
	FullHealthBarCorners.Parent = FullHealthBar

	HP.Name = "HP"
	HP.Parent = TargetInfo
	HP.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HP.BackgroundTransparency = 1.000
	HP.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HP.BorderSizePixel = 0
	HP.Position = UDim2.new(0.28273809, 0, 0.638888896, 0)
	HP.Size = UDim2.new(0, 73, 0, 19)
	HP.Font = Enum.Font.Unknown
	HP.Text = "HP:"
	HP.TextColor3 = Color3.fromRGB(255, 255, 255)
	HP.TextScaled = true
	HP.TextSize = 14.000
	HP.TextWrapped = true
	HP.TextXAlignment = Enum.TextXAlignment.Left
	HP.TextYAlignment = Enum.TextYAlignment.Top

	TargetHP.Name = "TargetHP"
	TargetHP.Parent = TargetInfo
	TargetHP.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TargetHP.BackgroundTransparency = 1.000
	TargetHP.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TargetHP.BorderSizePixel = 0
	TargetHP.Position = UDim2.new(0.389880955, 0, 0.638888896, 0)
	TargetHP.Size = UDim2.new(0, 73, 0, 19)
	TargetHP.Font = Enum.Font.Unknown
	TargetHP.Text = "100"
	TargetHP.TextColor3 = Color3.fromRGB(170, 0, 255)
	TargetHP.TextScaled = true
	TargetHP.TextSize = 14.000
	TargetHP.TextWrapped = true
	TargetHP.TextXAlignment = Enum.TextXAlignment.Left
	TargetHP.TextYAlignment = Enum.TextYAlignment.Top

	local NewTargetHud
	local NewRenderHud 
	local HudCorner
	local PlayerProfile
	local UICorner
	local Names
	local DisPlayName
	local HealthBar 
	local HealthBarCorner 
	local HealthBarFull 
	local FullHealthBarCorner 
	local UIGradient
	local PlayerHealth
	local HudGradient
	local HudAspectRatio
	local HudStroke
	local HealthStroke
	local UIGradient2
	local NewRender = {}
	NewTargetHud = Instance.new("ScreenGui")
    NewRenderHud = Instance.new("Frame")
    HudCorner = Instance.new("UICorner")
    PlayerProfile = Instance.new("ImageLabel")
    UICorner = Instance.new("UICorner")
    Names = Instance.new("TextLabel")
    DisPlayName = Instance.new("TextLabel")
    HealthBar = Instance.new("Frame")
    HealthBarCorner = Instance.new("UICorner")
    HealthBarFull = Instance.new("Frame")
    FullHealthBarCorner = Instance.new("UICorner")
    UIGradient = Instance.new("UIGradient")
    PlayerHealth = Instance.new("TextLabel")
    HudGradient = Instance.new("UIGradient")
    HudAspectRatio = Instance.new("UIAspectRatioConstraint")
    HudStroke = Instance.new("UIStroke")
    HealthStroke = Instance.new("UIStroke")
    UIGradient2 = Instance.new("UIGradient")

    NewTargetHud.Name = "NewTargetHud"
    NewTargetHud.Parent = lplr.PlayerGui
    NewTargetHud.ResetOnSpawn = false
    
    NewRenderHud.Name = "NewRenderHud"
    NewRenderHud.Active = true
    NewRenderHud.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NewRenderHud.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NewRenderHud.BorderSizePixel = 0
    NewRenderHud.Size = UDim2.new(0, 281, 0, 88)

    HudCorner.CornerRadius = UDim.new(0, 20)
    HudCorner.Name = "HudCorner"
    HudCorner.Parent = NewRenderHud
    
    PlayerProfile.Name = "PlayerProfile"
    PlayerProfile.Parent = NewRenderHud
    PlayerProfile.BackgroundColor3 = Color3.fromRGB(19, 22, 29)
    PlayerProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PlayerProfile.BorderSizePixel = 0
    PlayerProfile.Position = UDim2.new(0.0387954451, 0, 0.163921848, 0)
    PlayerProfile.Size = UDim2.new(0, 60, 0, 60)
    PlayerProfile.Image = "rbxassetid://16504243510"
    
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = PlayerProfile
    
    Names.Name = "Name"
    Names.Parent = NewRenderHud
    Names.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Names.BackgroundTransparency = 1.000
    Names.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Names.Position = UDim2.new(0.293499917, 0, 0.161067262, 0)
    Names.Size = UDim2.new(0, 50, 0, 18)
    Names.Font = Enum.Font.Gotham
    Names.Text = "Name:"
    Names.TextColor3 = Color3.fromRGB(255, 255, 255)
    Names.TextScaled = true
    Names.TextSize = 14.000
    Names.TextWrapped = true
    Names.TextXAlignment = Enum.TextXAlignment.Left
    Names.TextYAlignment = Enum.TextYAlignment.Top
    
    DisPlayName.Name = "DisPlayName"
    DisPlayName.Parent = Names
    DisPlayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DisPlayName.BackgroundTransparency = 1.000
    DisPlayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DisPlayName.Position = UDim2.new(1.17893863, 0, -0.00483025424, 0)
    DisPlayName.Size = UDim2.new(0, 127, 0, 17)
    DisPlayName.Font = Enum.Font.Gotham
    DisPlayName.Text = ""
    DisPlayName.TextColor3 = Color3.fromRGB(255, 255, 255)
    DisPlayName.TextScaled = true
    DisPlayName.TextSize = 14.000
    DisPlayName.TextWrapped = true
    DisPlayName.TextXAlignment = Enum.TextXAlignment.Left
    DisPlayName.TextYAlignment = Enum.TextYAlignment.Top
    
    HealthBar.Name = "HealthBar"
    HealthBar.Parent = NewRenderHud
    HealthBar.BackgroundColor3 = Color3.fromRGB(22, 27, 35)
    HealthBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    HealthBar.BorderSizePixel = 0
    HealthBar.Position = UDim2.new(0.293607324, 0, 0.684782565, 0)
    HealthBar.Size = UDim2.new(0, 132, 0, 15)
    
    HealthBarCorner.CornerRadius = UDim.new(0, 7)
    HealthBarCorner.Name = "HealthBarCorner"
    HealthBarCorner.Parent = HealthBar
    
    HealthBarFull.Name = "HealthBarFull"
    HealthBarFull.Parent = HealthBar
    HealthBarFull.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HealthBarFull.BorderColor3 = Color3.fromRGB(0, 0, 0)
    HealthBarFull.BorderSizePixel = 0
    HealthBarFull.Position = UDim2.new(0.00336657069, 0, -0.0295039583, 0)
    HealthBarFull.Size = UDim2.new(0, 132, 0, 15)
    
    FullHealthBarCorner.CornerRadius = UDim.new(0, 7)
    FullHealthBarCorner.Name = "FullHealthBarCorner"
    FullHealthBarCorner.Parent = HealthBarFull
    
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(116, 24, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(176, 19, 255))}
    UIGradient.Rotation = 90
    UIGradient.Parent = HealthBarFull
    
    PlayerHealth.Name = "PlayerHealth"
    PlayerHealth.Parent = HealthBar
    PlayerHealth.BackgroundColor3 = Color3.fromRGB(115, 0, 255)
    PlayerHealth.BackgroundTransparency = 1.000
    PlayerHealth.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PlayerHealth.BorderSizePixel = 0
    PlayerHealth.Position = UDim2.new(1.08270681, 0, -0.0714285746, 0)
    PlayerHealth.Size = UDim2.new(0, 41, 0, 14)
    PlayerHealth.Font = Enum.Font.GothamMedium
    PlayerHealth.Text = "50.0%"
    PlayerHealth.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerHealth.TextScaled = true
    PlayerHealth.TextSize = 14.000
    PlayerHealth.TextWrapped = true
    
    HudGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 28, 38)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(31, 32, 50))}
    HudGradient.Rotation = 30
    HudGradient.Name = "HudGradient"
    HudGradient.Parent = NewRenderHud
    
    HudAspectRatio.Name = "HudAspectRatio"
    HudAspectRatio.Parent = NewRenderHud
    HudAspectRatio.AspectRatio = 3.193
    
    HudStroke.Color = Color3.fromRGB(255, 255, 255)
    HudStroke.Thickness = 4
    HudStroke.Name = "HudStroke"
    HudStroke.Parent = NewRenderHud
    
    HealthStroke.Thickness = 0.699999988079071
    HealthStroke.Name = "HealthStroke"
    HealthStroke.Parent = PlayerHealth    

    UIGradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(119, 0, 255)), ColorSequenceKeypoint.new(0.39, Color3.fromRGB(129, 1, 234)), ColorSequenceKeypoint.new(0.54, Color3.fromRGB(111, 1, 214)), ColorSequenceKeypoint.new(0.78, Color3.fromRGB(89, 0, 191)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(2, 6, 255))}
    UIGradient2.Parent = HudStroke

	local targetui = Instance.new('Frame') 
	local targetactive = false
	targetui.AnchorPoint = Vector2.new(-0.5, 0)
	targetui.Size = UDim2.new(0, 320, 0, 109)
	targetui.BackgroundColor3 = Color3.fromRGB(60, 12, 127)
	targetui.BackgroundTransparency = 0.25
	targetui.Visible = false
	local targetinforounding = Instance.new('UICorner')
	targetinforounding.Parent = targetui
	local targetinfostroke = Instance.new('UIStroke')
	targetinfostroke.Color = Color3.fromRGB(255, 255, 255)
	targetinfostroke.Thickness = 3
	targetinfostroke.Parent = targetui
	local targetstrokeround = Instance.new('UIGradient')
	targetstrokeround.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 92, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(146, 23, 254))})
	targetstrokeround.Parent = targetinfostroke
	local targethealthbarBK = Instance.new('Frame')
	targethealthbarBK.Size = UDim2.new(0, 171, 0, 18)
	targethealthbarBK.Position = UDim2.new(0.35, 0, 0.477, 0)
	targethealthbarBK.BackgroundColor3 = Color3.fromRGB(45, 7, 91)
	targethealthbarBK.Parent = targetui 
	local healthbarBKRound = Instance.new('UICorner')
	healthbarBKRound.CornerRadius = UDim.new(1, 8)
	healthbarBKRound.Parent = targethealthbarBK 
	local targethealthbar = targethealthbarBK:Clone() 
	targethealthbar.ZIndex = 2 
	targethealthbar.BackgroundColor3 = Color3.fromRGB(130, 21, 255) 
	targethealthbar.Parent = targetui
	local targeticon = Instance.new('ImageLabel')
	targeticon.Image = 'rbxthumb://type=AvatarHeadShot&id='..(lplr.UserId)..'&w=420&h=420'
	targeticon.BackgroundTransparency = 1 
	targeticon.Size = UDim2.new(0, 84, 0, 82)
	targeticon.Position = UDim2.new(0.035, 0, 0.123, 0)
	targeticon.Parent = targetui
	local targeticonround = Instance.new('UICorner')
	targeticonround.Parent = targeticon
	local tagretinfohealth = Instance.new('TextLabel')
	tagretinfohealth.Text = (math.round(isAlive(lplr, true) and lplr.Character.Humanoid.Health or 100)..' HP')
	tagretinfohealth.TextSize = 15
	tagretinfohealth.BackgroundTransparency = 1 
	tagretinfohealth.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold)
	tagretinfohealth.Position = UDim2.new(0.291, 0, 0.532, 0)
	tagretinfohealth.Size = UDim2.new(0, 208, 0, 64)
	tagretinfohealth.TextColor3 = Color3.fromRGB(255, 255, 255)
	tagretinfohealth.Parent = targetui
	local targetname = tagretinfohealth:Clone() -- lazy ok 
	targetname.Text = lplr.DisplayName 
	targetname.Position = UDim2.new(0.291, 0, 0, 0)
	targetname.Size = UDim2.new(0, 208, 0, 64)
	targetname.TextSize = 18
	targetname.Parent = targetui	
	local targetinfomainframe = Instance.new('Frame') -- pasted from my old project Voidware
    local targetinfomaingradient = Instance.new('UIGradient')
    local targetinfomainrounding = Instance.new('UICorner')
	local targetinfopfpbox = Instance.new('Frame')
    local targetinfopfpboxrounding = Instance.new('UICorner')
	local targetinfoname = Instance.new('TextLabel')
	local targetinfohealthinfo = Instance.new('TextLabel')
	local targetinfonamefont = Font.new('rbxasset://fonts/families/GothamSSm.json')
	local targetinfohealthbarbackground = Instance.new('Frame')
	local targetinfohealthbarbkround = Instance.new('UICorner')
	local targetinfohealthbar = Instance.new('Frame')
	local targetinfoprofilepicture = Instance.new('ImageLabel')  
	local targetinfoprofilepictureround = Instance.new('UICorner')
	targetinfonamefont.Weight = Enum.FontWeight.Heavy
	targetinfomainframe.Name = 'VoidwareTargetInfo'
	targetinfomainframe.Size = UDim2.new(0, 350, 0, 96)
	targetinfomainframe.BackgroundTransparency = 0.13
	targetinfomaingradient.Parent = targetinfomainframe
	targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(69, 13, 136)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))})
	targetinfomainrounding.Parent = targetinfomainframe
	targetinfomainrounding.CornerRadius = UDim.new(0, 8)
	targetinfopfpbox.Parent = targetinfomainframe
	targetinfopfpbox.Name = 'ProfilePictureBox'
	targetinfopfpbox.BackgroundColor3 = Color3.fromRGB(130, 0, 166)
	targetinfopfpbox.Position = UDim2.new(0.035, 0, 0.165, 0)
	targetinfopfpbox.Size = UDim2.new(0, 70, 0, 69)
	targetinfopfpboxrounding.Parent = targetinfopfpbox
	targetinfomainrounding.CornerRadius = UDim.new(0, 8)
	targetinfoname.Parent = targetinfomainframe
	targetinfoname.Name = 'TargetNameInfo'
	targetinfoname.Text = lplr.DisplayName
	targetinfoname.TextXAlignment = Enum.TextXAlignment.Left
	targetinfoname.RichText = true
	targetinfoname.Size = UDim2.new(0, 215, 0, 31)
	targetinfoname.Position = UDim2.new(0.289, 0, 0.058, 0)
	targetinfoname.FontFace = targetinfonamefont
	targetinfoname.BackgroundTransparency = 1
	targetinfoname.TextSize = 20
	targetinfoname.TextColor3 = Color3.fromRGB(255, 255, 255)
	targetinfohealthinfo.Parent = targetinfomainframe
	targetinfohealthinfo.Text = ''
	targetinfohealthinfo.Name = 'TargetHealthInfo'
	targetinfohealthinfo.Size = UDim2.new(0, 112, 0, 31)
	targetinfohealthinfo.Position = UDim2.new(0.223, 0, 0.252, 0)
	targetinfohealthinfo.FontFace = targetinfonamefont
	targetinfohealthinfo.BackgroundTransparency = 1
	targetinfohealthinfo.TextSize = 13
	targetinfohealthinfo.TextColor3 = Color3.fromRGB(255, 255, 255)
	targetinfohealthbarbackground.Parent = targetinfomainframe
	targetinfohealthbarbackground.Name = 'HealthbarBackground'
	targetinfohealthbarbackground.BackgroundColor3 = Color3.fromRGB(59, 0, 88)
	targetinfohealthbarbackground.Size = UDim2.new(0, 205, 0, 15)
	targetinfohealthbarbackground.Position = UDim2.new(0.32, 0, 0.650, 0)
	targetinfohealthbarbkround.Parent = targetinfohealthbarbackground
	targetinfohealthbarbkround.CornerRadius = UDim.new(0, 8)
	targetinfohealthbar.Parent = targetinfomainframe
	targetinfohealthbar.Name = 'Healthbar'
	targetinfohealthbar.Size = UDim2.new(0, 205, 0, 15)
	targetinfohealthbar.Position = UDim2.new(0.32, 0, 0.650, 0)
	targetinfohealthbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	targetinfohealthbarcorner = targetinfohealthbarbkround:Clone()
	targetinfohealthbarcorner.Parent = targetinfohealthbar
	targetinfoprofilepicture.Parent = targetinfomainframe
	targetinfoprofilepicture.Name = 'TargetProfilePictureInfo'
	targetinfoprofilepicture.BackgroundTransparency = 1
	targetinfoprofilepicture.Size = UDim2.new(0, 69, 0, 69)
	targetinfoprofilepicture.Position = UDim2.new(0.035, 0, 0.162, 0)
	targetinfoprofilepicture.Image = 'rbxthumb://type=AvatarHeadShot&id='..(lplr.UserId)..'&w=420&h=420'
	targetinfohealthinfo.Text = '100/100%'
	targetinfoprofilepictureround.Parent = targetinfoprofilepicture


	local function bestOffsetX(num, min)
		local newnum = num
		for i = 1, 9e9, 0.1 do 
			if (num / i) <= min then 
				newnum = (num / i) 
				break
			end
		end
		return newnum
	end
	local function updateTargetUI(target)
		if type(target) ~= 'table' or target.Player == nil then 
			targetui.Visible = GuiLibrary.MainGui.ScaledGui.ClickGui.Visible
			targetactive = false
			return 
		end
		local health = (target.Humanoid and target.Humanoid.Health or isAlive(target.Player) and target.Player.Character.Humanoid.Health or 0)
		local maxhealth = (target.Humanoid and target.Humanoid.MaxHealth or isAlive(target.Player, true) and target.Player.Character.Humanoid.MaxHealth or 100)
		local damage = (maxhealth - health)
		local npctarget = false 
		if target.Player.UserId == 1443379645 then 
			npctarget = true 
		end
		targetui.Visible = true
		tweenService:Create(targethealthbar, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, (health == maxhealth or npctarget) and 171 or 100 - (bestOffsetX(damage, 100)), 0, 18)}):Play()
		tagretinfohealth.Text = ((math.round(health))..' HP')
		targeticon.Image = 'rbxthumb://type=AvatarHeadShot&id='..(target.Player.UserId)..'&w=420&h=420'
		targetname.Text = (target.Player.DisplayName or target.Player.Name or 'Target')
	end
	local function updateTargetUI2(target)
		if type(target) ~= 'table' or target.Player == nil then 
			targetinfomainframe.Visible = GuiLibrary.MainGui.ScaledGui.ClickGui.Visible
			targetactive = false
			return 
		end
		local health = (target.Humanoid and target.Humanoid.Health or isAlive(target.Player) and target.Player.Character.Humanoid.Health or 0)
		local maxhealth = (target.Humanoid and target.Humanoid.MaxHealth or isAlive(target.Player, true) and target.Player.Character.Humanoid.MaxHealth or 100)
		local damage = (maxhealth - health)
		local npctarget = false 
		if target.Player.UserId == 1443379645 then 
			npctarget = true 
		end
		targetinfomainframe.Visible = true
		tweenService:Create(targetinfohealthbar, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, (health == maxhealth or npctarget) and 205 or 100 - (bestOffsetX(damage, 100)), 0, 15)}):Play()
		targetinfohealthinfo.Text = ((math.round(health))..' HP')
		targetinfoprofilepicture.Image = 'rbxthumb://type=AvatarHeadShot&id='..(target.Player.UserId)..'&w=420&h=420'
		targetinfoname.Text = (target.Player.DisplayName or target.Player.Name or 'Target')
	end
	local function updateTargetUI3(target)
		if type(target) ~= 'table' or target.Player == nil then 
			NewRenderHud.Visible = GuiLibrary.MainGui.ScaledGui.ClickGui.Visible
			targetactive = false
			return 
		end
		task.spawn(function()
			repeat task.wait()
				if HudAnimation.Enabled then
					UIGradient2.Rotation = UIGradient2.Rotation + 3
				end
			until (not NewRender.Enabled)
		end)
		local health = (target.Humanoid and target.Humanoid.Health or isAlive(target.Player) and target.Player.Character.Humanoid.Health or 0)
		local maxhealth = (target.Humanoid and target.Humanoid.MaxHealth or isAlive(target.Player, true) and target.Player.Character.Humanoid.MaxHealth or 100)
		local damage = (maxhealth - health)
		local npctarget = false 
		if target.Player.UserId == 1443379645 then 
			npctarget = true
		end
		NewRenderHud.Visible = true
		tweenService:Create(HealthBarFull, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, (health == maxhealth or npctarget) and 132 or 132 - (bestOffsetX(damage, 100)), 0, 15)}):Play()
		PlayerHealth.Text = ((math.round(health))..'.0%')
		PlayerProfile.Image = 'rbxthumb://type=AvatarHeadShot&id='..(target.Player.UserId)..'&w=420&h=420'
		DisPlayName.Text = (target.Player.DisplayName or target.Player.Name or 'Target')
	end
	local function updateTargetUI4(target)
		local trashcheck = 0
		if type(target) ~= 'table' or target.Player == nil then
			TargetInfo.Visible = GuiLibrary.MainGui.ScaledGui.ClickGui.Visible
			targetactive = false
			return 
		end
		local health = (target.Humanoid and target.Humanoid.Health or isAlive(target.Player) and target.Player.Character.Humanoid.Health or 0)
		local maxhealth = (target.Humanoid and target.Humanoid.MaxHealth or isAlive(target.Player, true) and target.Player.Character.Humanoid.MaxHealth or 100)
		local damage = (maxhealth - health)
		local npctarget = false 
		task.spawn(function()
			task.wait(0.3)
			tweenService:Create(TargetProfile, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(255, 0, 0)}):Play()
			task.wait(0.5)
			tweenService:Create(TargetProfile, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		if target.Player.UserId == 1443379645 then 
			npctarget = true 
		end
		TargetInfo.Visible = true
		tweenService:Create(FullHealthBar, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, (health == maxhealth or npctarget) and 216 or 100 - (bestOffsetX(damage, 100)), 0, 15)}):Play()
		TargetHP.Text = tostring(math.round(health))
		TargetProfile.Image = 'rbxthumb://type=AvatarHeadShot&id='..(target.Player.UserId)..'&w=420&h=420'
		TargetName.Text = (target.Player.DisplayName or target.Player.Name or 'Target')
		
	end
	local RenderUI = GuiLibrary.CreateCustomWindow({
		Name = 'OG Render HUD',
		Icon = 'vape/assets/TargetIcon3.png',
		IconSize = 16
	})
	local NewRenderUI = GuiLibrary.CreateCustomWindow({
		Name = 'Render HUD',
		Icon = 'vape/assets/TargetIcon3.png',
		IconSize = 16
	})
	local VoidwareUI = GuiLibrary.CreateCustomWindow({
		Name = 'Voidware HUD',
		Icon = 'vape/assets/TargetIcon3.png',
		IconSize = 16
	})
	local ModrenUI = GuiLibrary.CreateCustomWindow({
		Name = 'Modern HUD',
		Icon = 'vape/assets/TargetIcon3.png',
		IconSize = 16
	})
	local Modren = GuiLibrary.ObjectsThatCanBeSaved.TargetHUDWindow.Api.CreateOptionsButton({
		Name = 'Modern',
		Function = function(calling)		
			ModrenUI.SetVisible(calling)
		end
	})
	NewRender = GuiLibrary.ObjectsThatCanBeSaved.TargetHUDWindow.Api.CreateOptionsButton({
		Name = 'Render',
		Function = function(calling)		
			NewRenderUI.SetVisible(calling)
		end
	})
	local RenderOG = GuiLibrary.ObjectsThatCanBeSaved.TargetHUDWindow.Api.CreateOptionsButton({
		Name = 'Render Original',
		Function = function(calling)
			RenderUI.SetVisible(calling)
		end
	})
	local VoidwareHUD =  GuiLibrary.ObjectsThatCanBeSaved.TargetHUDWindow.Api.CreateOptionsButton({
		Name = 'Voidware Original',
		Function = function(calling)
			VoidwareUI.SetVisible(calling)
		end
	})

	RenderOG.CreateColorSlider({
		Name = 'Background Color',
		Function = function(h, s, v)
			targetui.BackgroundColor3 = Color3.fromHSV(h, s, v)
		end
	})

	local rendercolor1 = newcolor()
	local renderogcolor = RenderOG.CreateColorSlider({
		Name = 'Outline Color 1',
		Function = function(h, s, v)
			targetstrokeround.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(h, s, v)), ColorSequenceKeypoint.new(1, Color3.fromHSV(rendercolor1.Hue, rendercolor1.Sat, rendercolor1.Value))})
		end
	})

	local rendercolor2 = newcolor()
	renderogcolor2 = RenderOG.CreateColorSlider({
		Name = 'Outline Color 2',
		Function = function()
			targetstrokeround.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(renderogcolor.Hue, renderogcolor.Sat, renderogcolor.Value)), ColorSequenceKeypoint.new(1, Color3.fromHSV(renderogcolor2.Hue, renderogcolor2.Sat, renderogcolor2.Value))})
		end
	})

	
	local newrendercolor2 = newcolor()
	local newrendercolor = NewRender.CreateColorSlider({
		Name = 'Outline Color 1',
		Function = function(h, s, v) 
			UIGradient2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(h, s, v)), ColorSequenceKeypoint.new(1, Color3.fromHSV(newrendercolor2.Hue, newrendercolor2.Sat, newrendercolor2.Value))})
		end
	})

	newrenderuicolor2 = NewRender.CreateColorSlider({
		Name = 'Outline Color 2',
		Function = function(h, s, v) 
			UIGradient2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(newrendercolor.Hue, newrendercolor.Sat, newrendercolor.Value)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, v))})
		end
	})
	

	local newrenderhealthbarcolor2 = newcolor()
	local renderhealthbarcolor = NewRender.CreateColorSlider({
		Name = 'Healthbar Color 1',
		Function = function(h, s, v) 
			UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(h, s, v)), ColorSequenceKeypoint.new(1, Color3.fromHSV(newrenderhealthbarcolor2.Hue, newrenderhealthbarcolor2.Sat, newrenderhealthbarcolor2.Value))})
		end
	})

	newrenderuicolor2 = NewRender.CreateColorSlider({
		Name = 'Healthbar Color 2',
		Function = function(h, s, v) 
			UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(renderhealthbarcolor.Hue, renderhealthbarcolor.Sat, renderhealthbarcolor.Value)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, v))})
		end
	})
	
	HudAnimation = NewRender.CreateToggle({
		Name = 'Gradient Animation',
		Function = function(calling) 
			HudAnimation.Enabled = calling
		end,
		Default = true
	})

	RenderOG.CreateColorSlider({
		Name = 'Healthbar Color',
		Function = function(h, s, v)
			targethealthbar.BackgroundColor3 = Color3.fromHSV(h, s, v)
		end
	})

	RenderOG.CreateColorSlider({
		Name = 'Healthbar Background Color',
		Function = function(h, s, v)
			targethealthbarBK.BackgroundColor3 = Color3.fromHSV(h, s, v) 
		end
	})

	local voidwareuicolor2 = newcolor()
	local voidwareuicolor = VoidwareHUD.CreateColorSlider({
		Name = 'Background Color 1',
		Function = function(h, s, v) 
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(h, s, v)), ColorSequenceKeypoint.new(1, Color3.fromHSV(voidwareuicolor2.Hue, voidwareuicolor2.Sat, voidwareuicolor2.Value))})
		end
	})

	voidwareuicolor2 = VoidwareHUD.CreateColorSlider({
		Name = 'Background Color 2',
		Function = function(h, s, v) 
			targetinfomaingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(voidwareuicolor.Hue, voidwareuicolor.Sat, voidwareuicolor.Value)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, v))})
		end
	})

	VoidwareHUD.CreateColorSlider({
		Name = 'PFP Background Color',
		Function = function(h, s, v)
			targetinfopfpbox.BackgroundColor3 = Color3.fromHSV(h, s, v) 
		end
	})

	VoidwareHUD.CreateColorSlider({
		Name = 'Healthbar Color',
		Function = function(h, s, v)
			targetinfohealthbar.BackgroundColor3 = Color3.fromHSV(h, s, v) 
		end
	})

	VoidwareHUD.CreateColorSlider({
		Name = 'Healthbar Background Color',
		Function = function(h, s, v)
			targetinfohealthbarbackground.BackgroundColor3 = Color3.fromHSV(h, s, v) 
		end
	})

	task.spawn(function()
		repeat
			targetstrokeround.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(rendercolor2.Hue, rendercolor2.Sat, rendercolor2.Value)), ColorSequenceKeypoint.new(1, Color3.fromHSV(rendercolor1.Hue, rendercolor1.Sat, rendercolor1.Value))})
			task.wait()
		until (not vapeInjected)
	end)
	
	RenderStore.UpdateTargetUI = function(...)
		pcall(updateTargetUI, ...)
		pcall(updateTargetUI2, ...)
		pcall(updateTargetUI3, ...)
		pcall(updateTargetUI4, ...)
	end

	targetui.Parent = RenderUI.GetCustomChildren()
	targetinfomainframe.Parent = VoidwareUI.GetCustomChildren()
	NewRenderHud.Parent = NewRenderUI.GetCustomChildren()
	TargetInfo.Parent = ModrenUI.GetCustomChildren()
	table.insert(vapeConnections, GuiLibrary.MainGui.ScaledGui.ClickGui:GetPropertyChangedSignal('Visible'):Connect(function()
		if GuiLibrary.MainGui.ScaledGui.ClickGui.Visible then 
			targetui.Visible = true 
			targetinfomainframe.Visible = true
		else
			targetui.Visible = targetactive 
			targetinfomainframe.Visible = targetactive
		end
	end))
	table.insert(vapeConnections, targethealthbar:GetPropertyChangedSignal('Size'):Connect(function()
		if targethealthbar.Size.X.Offset > 171 then 
			targethealthbar.Size = UDim2.new(0, 171, 0, 18)
		end
	end))
	table.insert(vapeConnections, targetinfohealthbar:GetPropertyChangedSignal('Size'):Connect(function()
		if targetinfohealthbar.Size.X.Offset > 205 then 
			targethealthbar.Size = UDim2.new(0, 205, 0, 15)
		end
	end))
end)

runFunction(function()
	local sessionui = Instance.new('Frame')
	local sessiongradient = Instance.new('UIGradient', sessionui)
	local sessiontitle = Instance.new('TextLabel', sessionui)
	local sessionlayoutframe = Instance.new('Frame', sessionui)
	local sessionlayout = Instance.new('UIListLayout', sessionlayoutframe)
	sessionui.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	--sessionui.BackgroundTransparency = 0.250
	sessionui.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sessionui.BorderSizePixel = 0
	sessionui.Position = UDim2.new(0, 0, 0, 0)
	sessionui.Size = UDim2.new(0, 218, 0, 174) 
	sessionui.Visible = false	
	sessiongradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 182)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(135, 0, 188)), ColorSequenceKeypoint.new(1, Color3.fromRGB(95, 0, 121))})
	sessiongradient.Rotation = 122
	sessiontitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sessiontitle.BackgroundTransparency = 1
	sessiontitle.BorderColor3 = Color3.fromRGB(255, 255, 255)
	sessiontitle.BorderSizePixel = 0
	sessiontitle.Position = UDim2.new(0, 13, 0, 10)
	sessiontitle.Size = UDim2.new(0, 205, 0, 23)
	sessiontitle.Font = Enum.Font.GothamBold
	sessiontitle.Text = 'Session Info'
	sessiontitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	sessiontitle.TextScaled = true
	sessiontitle.TextSize = 14
	sessiontitle.TextXAlignment = Enum.TextXAlignment.Left
	sessiontitle.TextYAlignment = Enum.TextYAlignment.Top
	sessionlayout.SortOrder = Enum.SortOrder.LayoutOrder
	sessionlayout.Padding = UDim.new(0, 3)
	sessionlayoutframe.BackgroundTransparency = 1
	sessionlayoutframe.Position = UDim2.new(0.0523809493, 0, 0.236077666, 0)
	sessionlayoutframe.Size = UDim2.new(0, 194, 0, 132)
	Instance.new('UICorner', sessionui).CornerRadius = UDim.new(0, 13)
	RenderStore.sessionInfo.Instance = sessionui
	RenderStore.sessionInfo.addListText = function(self, name, value)
		local object = RenderStore.sessionInfo.labelInstances[name]
		if object == nil then 
			local listText = Instance.new('TextLabel', sessionlayoutframe)
			listText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			listText.BackgroundTransparency = 1
			listText.Position = UDim2.new(0, 12, 0, 61)
			listText.Size = UDim2.new(0, 208, 0, 15)
			listText.Font = Enum.Font.GothamMedium
			listText.TextColor3 = Color3.fromRGB(255, 255, 255)
			listText.TextScaled = true
			listText.TextSize = 14
			listText.TextXAlignment = Enum.TextXAlignment.Left
			object = listText
		end
		object.Text = (name..': '..value)
		RenderStore.sessionInfo.labelInstances[name] = object
	end
	local sessioncolor1 = newcolor()
	local sessioncolor2 = newcolor()
	local SessionInfo = GuiLibrary.CreateCustomWindow({
		Name = 'Overlay',
		Icon = 'vape/assets/TargetIcon3.png',
		IconSize = 16
	})
	local sessionInfoToggle = GuiLibrary.ObjectsThatCanBeSaved.SessionHUDWindow.Api.CreateOptionsButton({
		Name = 'Main',
		Function = function(calling)	
			sessionui.Visible = calling	
			SessionInfo.SetVisible(calling)
		end
	})
	sessioncolor1 = sessionInfoToggle.CreateColorSlider({
		Name = 'Background Color',
		Function = function(h, s, v) 
			sessiongradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(h, s, v)), ColorSequenceKeypoint.new(1, Color3.fromHSV(sessioncolor2.Hue, sessioncolor2.Sat, sessioncolor2.Value))})
		end
	})

	sessioncolor2 = sessionInfoToggle.CreateColorSlider({
		Name = 'Background Color 2',
		Function = function(h, s, v) 
			sessiongradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(sessioncolor1.Hue, sessioncolor1.Sat, sessioncolor1.Value)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, v))})
		end
	})
	
	sessionui.Parent = SessionInfo.GetCustomChildren()
end)

RenderStore.UpdateGroundTick = function()
	if isAlive(lplr, true) and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then 
		RenderStore.groundTime = tick() 
	end
end

task.spawn(function()
	repeat 
		RenderStore.UpdateGroundTick()
		task.wait(0)
	until (not vapeInjected)
end)

task.spawn(function()
	local ray = RaycastParams.new()
	local instances = {}
	ray.FilterType = Enum.RaycastFilterType.Include
	for i,v in next, workspace:GetChildren() do 
		if characterDescendant(v) == nil and playersService:FindFirstChild(v.Name) == nil then 
			table.insert(instances, v)
		end
	end
	ray.FilterDescendantsInstances = {instances}
	table.insert(vapeConnections, workspace.ChildAdded:Connect(function(v)
		if characterDescendant(v) == nil and playersService:FindFirstChild(v.Name) == nil then 
			table.insert(instances, v)
			ray.FilterDescendantsInstances = {instances}
		end
	end))
end)

runFunction(function()
	local FlyTP = {}
	local FlyTPVertical = {Value = 15}
	FlyTP = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'FlyTP',
		NoSave = true,
		Function = function(callback)
			if callback then 
				repeat 
					if not isAlive() or not isnetworkowner(lplr.Character.HumanoidRootPart) then
						FlyTP.ToggleButton() 
						break 
					end
				   lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, FlyTPVertical.Value <= 0 and 1 or FlyTPVertical.Value, 0)
				   lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1, 0)
				   task.wait(0.1)
				 until not FlyTP.Enabled
			end
		end
	})
	FlyTPVertical = FlyTP.CreateSlider({
		Name = 'Vertical',
		Min = 15,
		Max = 60,
		Function = function() end
	})
end)

runFunction(function()
	local BoostJump = {}
	local BoostJumpPower = {Value = 5}
	local BoostJumpTime = {Value = 30}
	local boost = 5
	local toggleTick = tick()
	BoostJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'BoostJump',
		HoverText = 'An indeed interesting high jump.',
		Function = function(callback)
			if callback then 
				toggleTick = tick() + (BoostJumpTime.Value / 35)
				repeat 
					if tick() > toggleTick or not isAlive() then 
						BoostJump.ToggleButton()
						break 
					end
					lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, boost, 0)
					boost = boost + (BoostJumpPower.Value <= 0 and 1 or BoostJumpPower.Value / 10)
					task.wait()
				until not BoostJump.Enabled
			else
				boost = 5
			end
		end
	})
	BoostJumpPower = BoostJump.CreateSlider({
		Name = 'Vertical',
		Min = 10, 
		Max = 20,
		Default = 35,
		Function = function() end
	})
	BoostJumpTime = BoostJump.CreateSlider({
		Name = 'Time',
		Min = 10, 
		Max = 60,
		Default = 32,
		Function = function() end
	})
end)

pcall(function()
	local Rejoin = {}
	Rejoin = GuiLibrary.ObjectsThatCanBeSaved.MatchmakingWindow.Api.CreateOptionsButton({
		Name = 'Rejoin',
		Function = function(callback)
			if callback then
				Rejoin.ToggleButton()
				teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lplr)
			end
		end
	})
end)

runFunction(function()
	local AntiLogger = {Enabled = false}
	local AntiLoggerSP = {Enabled = false}
	AntiLogger = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'AntiLogger',
		HoverText = 'Stops most loggers',
		Function = function(callback)
			if callback then
				loadstring(RenderFunctions:GetFile('scripts/antilogger.lua'))()
			end
		end
	})
	AntiLoggerSP = AntiLogger.CreateToggle({
		Name = 'Strict Protection',
		HoverText = 'Enabled Strict Protection',
		Default = false,
		Function = function() end
	})
end)

runFunction(function()
	local ServerHop = {}
	local ServerHopSort = {Value = 'Popular'}
	local newserver
	ServerHop = GuiLibrary.ObjectsThatCanBeSaved.MatchmakingWindow.Api.CreateOptionsButton({
		Name = 'ServerHop',
		Function = function(callback)
			if callback then 
				ServerHop.ToggleButton()
				if RenderStore.serverhopping then 
					return
				end
				RenderStore.serverhopping = true
				InfoNotification('ServerHop', 'Searching for a new server..', 10)
				local popularcheck = ServerHopSort.Value == 'Popular'
				local performancecheck = ServerHopSort.Value == 'Performance'
				repeat newserver = getnewserver(nil, popularcheck, performancecheck) task.wait() until newserver
				InfoNotification('ServerHop', 'Server Found. Joining..', 10)
				teleportService:TeleportToPlaceInstance(game.PlaceId, newserver, lplr)
			end
		end
	})
	ServerHopSort = ServerHop.CreateDropdown({
		Name = 'Sort',
		List = {'Popular', 'Performance', 'Random'},
		Function = function() end
	})
end)

runFunction(function()
	local AutoRejoin = {}
	local AutoRejoinSwitch = {}
	AutoRejoin = GuiLibrary.ObjectsThatCanBeSaved.MatchmakingWindow.Api.CreateOptionsButton({
		Name = 'AutoRejoin',
		HoverText = 'Automatically rejoins the game on disconnect/kick.',
		Function = function(callback)
			if callback then 
				table.insert(AutoRejoin.Connections, RenderStore.Bindable.PlayerKick.Event:Connect(function()
					if RenderStore.serverhopping then 
						return 
					end
					RenderStore.serverhopping = true
					if not AutoRejoinSwitch.Enabled then 
						InfoNotification('AutoRejoin', 'Rejoining the server..', 10)
						teleportService:Teleport(game.PlaceId)
						return
					end
					InfoNotification('AutoRejoin', 'Player disconnect detected. Searching for a new server.', 10)
					switchserver(function() 
						warningNotification('AutoRejoin', 'Successfully found server. Teleporting...', 10)
					end)
				end))
			end
		end
	})
	AutoRejoinSwitch = AutoRejoin.CreateToggle({
		Name = 'ServerHop',
		HoverText = 'Switches servers (good when vote kicks).',
		Function = function() end
	})
end)

runFunction(function()
	local PlayerAttach = {}
	local PlayerAttachNPC = {}
	local PlayerAttachTween = {}
	local PlayerAttachRaycast = {}
	local PlayerAttachRange = {Value = 30}
	local PlayerAttachTS = {Value = 15}
	PlayerAttach = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'PlayerAttach',
		HoverText = 'Rapes others :omegalol:',
		Function = function(callback)
			if callback then 
				repeat 
					local target = GetTarget(PlayerAttachTween.Enabled and PlayerAttachRange.Value + 5 or PlayerAttachRange.Value, nil, PlayerAttachRaycast.Enabled, PlayerAttachNPC.Enabled)
					if target.RootPart == nil or not isAlive() then 
						PlayerAttach.ToggleButton()
						break 
					end
					lplr.Character.Humanoid.Sit = false
					if PlayerAttachTween.Enabled then 
						tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(PlayerAttachTS.Value / 100, Enum.EasingStyle.Linear), {CFrame = target.RootPart.CFrame}):Play()
					else
					   lplr.Character.HumanoidRootPart.CFrame = target.RootPart.CFrame
					end
					task.wait()
				until not PlayerAttach.Enabled
			end
		end
	})
	PlayerAttachRange = PlayerAttach.CreateSlider({
		Name = 'Max Range',
		Min = 10,
		Max = 50, 
		Function = function() end,
		Default = 20
	})
	PlayerAttachTS = PlayerAttach.CreateSlider({
		Name = 'Tween Speed',
		Min = 1, 
		Max = 50,
		Default = 15,
		Function = function() end
	})
	PlayerAttachRaycast = PlayerAttach.CreateToggle({
		Name = 'Void Check',
		HoverText = 'Doesn\'t target those in the void.',
		Function = function() end
	})
	PlayerAttachTween = PlayerAttach.CreateToggle({
		Name = 'Tween',
		HoverText = 'Smooth animation instead of teleporting.',
		Function = function() end
	})
end)

runFunction(function()
	local FPSBoost = {}
	local FPSBoostTextures = {}
	local FPSBoostParticles = {}
	local FPSBoostNoCharacter = {}
	local FPSBoostExplosion = {}
	local FPSBoostShadows = {}
	local FPSBoostLessRender = {}
	local textures = {}
	local particles = {}
	local meshtextures = {}
	local specialmeshtextures = {}
	local partmaterials = {}
	local materials2 = {}
	local cameraeffects = {}
	local oldquality = settings().Rendering.QualityLevel
	local oldmeshquality = settings().Rendering.MeshPartDetailLevel
	local function modifypart(part)
		local charitem = characterDescendant(part)
		if not FPSBoostNoCharacter.Enabled then
			charitem = nil 
		end
		if part:IsA('Texture') and charitem == nil and FPSBoostTextures.Enabled then 
			textures[part] = part.Texture
			table.insert(FPSBoost.Connections, part:GetPropertyChangedSignal('Texture'):Connect(function()
				part.Texture = ''
			end))
			part.Texture = ''
		end
		if part:IsA('MeshPart') and charitem == nil and FPSBoostTextures.Enabled then 
			meshtextures[part] = part.TextureID
			table.insert(FPSBoost.Connections, part:GetPropertyChangedSignal('TextureID'):Connect(function()
				part.TextureID = ''
			end))
			part.TextureID = ''
		end
		if part:IsA('SpecialMesh') and charitem == nil and FPSBoostTextures.Enabled then
			specialmeshtextures[part] = part.TextureId
			table.insert(FPSBoost.Connections, part:GetPropertyChangedSignal('TextureId'):Connect(function()
				part.TextureId = ''
			end))
			part.TextureId = ''
		end
		if part:IsA('Part') or part:IsA('UnionOperation') and charitem == nil and FPSBoostTextures.Enabled then 
			partmaterials[part] = part.Material
			table.insert(FPSBoost.Connections, part:GetPropertyChangedSignal('Material'):Connect(function()
				part.Material = Enum.Material.SmoothPlastic
			end))
			part.Material = Enum.Material.SmoothPlastic
		end
		if part:IsA('Explosion') and FPSBoostExplosion.Enabled then 
			part:Destroy() 
		end
		for i,v in ({'ParticleEmitter', 'Trail', 'Smoke', 'Fire', 'Sparkles'}) do 
			if part:IsA(v) and FPSBoostParticles.Enabled then 
				if v == 'Fire' and isEnabled('FireEffect') then 
					continue 
				end
				part:Destroy()
				break
			end
		end
		if part:IsA('PostEffect') and FPSBoostParticles.Enabled and part.Enabled then 
			part.Enabled = false
			table.insert(cameraeffects, part)
		end
	end
	FPSBoost = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'FPSBoost',
		HoverText = 'Removes textures of objects to slightly improve\nyour framerate.',
		Function = function(callback)
			if callback then 
				for i,v in workspace:GetDescendants() do 
					modifypart(v)
				end
				if FPSBoostTextures.Enabled then 
					for i,v in game:GetService('MaterialService'):GetChildren() do 
						local material = v:Clone()
						material.Parent = nil
						table.insert(materials2, material)
						v:Destroy()
					end
				end
				if FPSBoostLessRender.Enabled then 
					settings().Rendering.QualityLevel = 1
					settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
				end
				for i,v in cameraeffects do 
					pcall(function() v.Enabled = true end)
				end
				table.insert(FPSBoost.Connections, workspace.DescendantAdded:Connect(modifypart))
				for i,v in materials2 do 
					v.Parent = game:GetService('MaterialService')
				end
				table.clear(materials2)
				if FPSBoostShadows.Enabled then 
					lightingService.GlobalShadows = false
				else
					if not isEnabled('Fullbright') then
						lightingService.GlobalShadows = false
					end
					settings().Rendering.QualityLevel = oldquality
					settings().Rendering.MeshPartDetailLevel = oldmeshquality
				end
			else
				for texturepart, old in textures do 
					pcall(function() texturepart.Material = old end)
				end
				for meshpart, old in meshtextures do  
					pcall(function() meshpart.TextureID = old end)
				end
				for specialmesh, old in specialmeshtextures do 
					pcall(function() specialmesh.TextureId = old end)
				end
				for part, old in partmaterials do 
					pcall(function() part.Material = old end)
				end
				for particle, old in particles do 
					pcall(function() particle.Parent = old end)
				end
			end
		end
	})
	FPSBoostTextures = FPSBoost.CreateToggle({
		Name = 'Remove Textures',
		Default = true,
		Function = function() 
			if FPSBoost.Enabled then 
				FPSBoost.ToggleButton()
				FPSBoost.ToggleButton()
			end
		end
	})
	FPSBoostParticles = FPSBoost.CreateToggle({
		Name = 'Ignore Character',
		HoverText = 'ignores objects that are a descendant of someone\'s character.',
		Default = true,
		Function = function() 
			if FPSBoost.Enabled then 
				FPSBoost.ToggleButton()
				FPSBoost.ToggleButton()
			end
		end
	})
	FPSBoostParticles = FPSBoost.CreateToggle({
		Name = 'Remove Effects',
		Default = true,
		Function = function() 
			if FPSBoost.Enabled then 
				FPSBoost.ToggleButton()
				FPSBoost.ToggleButton()
			end
		end
	})
	FPSBoostExplosion = FPSBoost.CreateToggle({
		Name = 'Remove Explosions',
		Default = true,
		Function = function() 
			if FPSBoost.Enabled then 
				FPSBoost.ToggleButton()
				FPSBoost.ToggleButton()
			end
		end
	})
	FPSBoostShadows = FPSBoost.CreateToggle({
		Name = 'No Shadows',
		Default = true,
		Function = function() 
			if FPSBoost.Enabled then 
				FPSBoost.ToggleButton()
				FPSBoost.ToggleButton()
			end
		end
	})
	FPSBoostLessRender = FPSBoost.CreateToggle({
		Name = 'Less Render',
		Function = function() 
			if FPSBoost.Enabled then 
				FPSBoost.ToggleButton()
				FPSBoost.ToggleButton()
			end
		end
	})
end)

runFunction(function()
	local ZoomUnlocker = {Enabled = false}
	local ZoomUnlockerMode = {Value = 'Infinite'}
	local ZoomUnlockerZoom = {Value = 25}
	local ZoomConnection, OldZoom = nil, nil
	ZoomUnlocker = GuiLibrary.ObjectsThatCanBeSaved['RenderWindow'].Api.CreateOptionsButton({
		Name = 'CameraUnlocker',
        HoverText = 'Unlocks the abillity to zoom more',
		Function = function(callback)
			if callback then
				OldZoom = lplr.CameraMaxZoomDistance
				ZoomUnlocker = runService.Heartbeat:Connect(function()
					if ZoomUnlockerMode.Value == 'Infinite' then
						lplr.CameraMaxZoomDistance = 9e9
					else
						lplr.CameraMaxZoomDistance = ZoomUnlockerZoom.Value
					end
				end)
			else
				if ZoomUnlocker then ZoomUnlocker:Disconnect() end
				lplr.CameraMaxZoomDistance = OldZoom
				OldZoom = nil
			end
		end,
        Default = false,
		ExtraText = function()
            return ZoomUnlockerMode.Value
        end
	})
	ZoomUnlockerMode = ZoomUnlocker.CreateDropdown({
		Name = 'Mode',
		List = {
			'Infinite',
			'Custom'
		},
		HoverText = 'Mode to unlock the zoom',
		Value = 'Infinite',
		Function = function(val)
			if val == 'Infinite' then
				ZoomUnlockerZoom.Object.Visible = false
			elseif val == 'Custom' then
				ZoomUnlockerZoom.Object.Visible = true
			end
		end
	})
	ZoomUnlockerZoom = ZoomUnlocker.CreateSlider({
		Name = 'Zoom',
		Min = 14,
		Max = 50,
		HoverText = 'Zoom Unlock Amount',
		Function = function() end,
		Default = 25
	})
end)

runFunction(function()
	local FireEffect = {}
	local FirePosition = {Value = 'Head'}
	local FireFlame = {Value = 25}
	local FireColor1 = newcolor()
	local FireColor2 = newcolor()
	local ishidden
	local fireobject = {}
	local createfire
	createfire = function(part)
		if not isAlive(lplr, true) then 
			repeat task.wait() until isAlive(lplr, true) or not FireEffect.Enabled 
		end
		if not FireEffect.Enabled then 
			return 
		end
		if fireobject.Parent then 
			return 
		end
		local fire = Instance.new('Fire')
		fire.Color = Color3.fromHSV(FireColor1.Hue, FireColor1.Sat, FireColor1.Value)
		fire.SecondaryColor = Color3.fromHSV(FireColor2.Hue, FireColor2.Sat, FireColor2.Value)
		fire.Heat = FireFlame.Value
		fire.Parent = lplr.Character[FirePosition.Value]
		fireobject = fire
		table.insert(FireEffect.Connections, lplr.CharacterAdded:Connect(createfire))
		table.insert(FireEffect.Connections, lplr.CharacterRemoving:Connect(function() ishidden = nil end))
		table.insert(FireEffect.Connections, gameCamera:GetPropertyChangedSignal('CFrame'):Connect(function()
			if not fireobject or not isAlive(lplr, true) then 
				return 
			end
			if (gameCamera.CFrame.p - gameCamera.Focus.p).Magnitude < 0.8 and fire.Parent then 
				ishidden = true 
				fire.Parent = game
			else
				ishidden = nil
				fire.Parent = lplr.Character[FirePosition.Value]
			end
		end))
	end
	FireEffect = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'FireEffect',
		HoverText = 'A client side fire effect for your character.',
		Function = function(callback)
			if callback then 
				createfire()
			else
				if fireobject.Parent then 
					fireobject:Destroy() 
				end
			end
		end
	})
	FireColor1 = FireEffect.CreateColorSlider({
		Name = 'Color',
		Function = function()
			if fireobject.Parent and isAlive(lplr, true) then 
				fireobject.Color = Color3.fromHSV(FireColor1.Hue, FireColor1.Sat, FireColor1.Value)
			end
		end
	})
	FireColor2 = FireEffect.CreateColorSlider({
		Name = 'Second Color',
		Function = function()
			if fireobject.Parent and isAlive(lplr, true) then 
				fireobject.SecondaryColor = Color3.fromHSV(FireColor2.Hue, FireColor2.Sat, FireColor2.Value)
			end
		end
	})
	FirePosition = FireEffect.CreateDropdown({
		Name = 'Position',
		List = {'Head', 'HumanoidRootPart'},
		Function = function(value)
			if fireobject.Parent and isAlive(lplr, true) then  
				fireobject.Parent = lplr.Character[value]
			end 
		end
	})
	FireFlame = FireEffect.CreateSlider({
		Name = 'Flame',
		Min = 1, 
		Max = 25,
		Default = 25,
		Function = function(value) 
			if fireobject.Parent and isAlive(lplr, true) then 
				fireobject.Heat = value
			end
		end
	})
end)

runFunction(function()
	local ChatMimic = {}
	local ChatShowSender = {Enabled = true}
	local customblocklist = {ObjectList = {}}
	local blacklisted = {'niga', 'niger', 'retard', 'ah', 'monkey', 'black', 'hitler', 'nazi', 'vape', 'shit', 'cum', 'dick', 'pussy', 'cock'}
	local lastsent = {}
	local messages = {}
	ChatMimic = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'ChatMimic',
		HoverText = 'Mimics others in chat.',
		Function = function(callback)
			if callback then 
				table.insert(ChatMimic.Connections, RenderStore.MessageReceived.Event:Connect(function(plr, text)
					task.wait()
					if plr == lplr or lastsent[plr] and lastsent[plr] > tick() then 
						return 
					end
					text = text:gsub('/bedwars', '/tptolobby')
					text = text:gsub('/lobby', '/tptolobby')
					local begin = (ChatShowSender.Enabled and '['..plr.DisplayName..']: ' or '')
					messages[plr] = (messages[plr] or {})
					if table.find(messages[plr], text) then 
						return 
					end
					for i,v in blacklisted do 
						if text:lower():find(v) then 
							return 
						end
					end
					for i,v in next, ({'hack', 'exploit'}) do 
						if text:lower():find(v) and (text:lower():find('i\'m') or text:lower():find('me') or text:lower():find('i am')) then
							return 
						end
					end 
					for i,v in customblocklist.ObjectList do 
						if text:lower():find(v) and v ~= '' then 
							return 
						end
					end
					sendmessage(begin..''..text)
					table.insert(messages, text)
					lastsent[plr] = tick() + 0.45
				end))
			end
		end
	})
	ChatShowSender = ChatMimic.CreateToggle({
		Name = 'Show Sender',
		Default = true,
		Function = function() end
	})
	customblocklist = ChatMimic.CreateTextList({
		Name = 'Blacklisted',
		TempText = 'Blacklisted Characters',
		AddFunction = function() end,
		RemoveFunction = function() end
	})
end)

runFunction(function()
	local PlayerTP = {}
	local PlayerTPSortMethod = {Value = 'Distance'}
	local PlayerTPDelayMethod = {Value = 'Instant'}
	local PlayerTPMode = {Value = 'Teleport'}
	local PlayerTweenSpeed = {Value = 30}
	local playertween
	local tempevent
	local function teleportfunc()
		if not PlayerTP.Enabled then 
			return 
		end
		if #RenderStore.tweens > 0 then 
			PlayerTP.ToggleButton()
			return 
		end
		if not isAlive(lplr, true) then 
			repeat task.wait() until isAlive(lplr, true)
		end
		local healthcheck = (PlayerTPSortMethod.Value == 'Health')
		local target = GetTarget(nil, healthcheck, nil, nil)
		if target.RootPart == nil then 
			PlayerTP.ToggleButton()
			return 
		end
		if not isnetworkowner(lplr.Character.HumanoidRootPart) then 
			PlayerTP.ToggleButton()
			return
		end
		if lplr.Character.Humanoid.Sit and not isEnabled('GamingChair') then 
			lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
			task.wait()
		end
		local magnitude = (lplr.Character.HumanoidRootPart.Position - target.RootPart.Position).Magnitude
		playertween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(magnitude / 100), {CFrame = target.RootPart.CFrame})
		if PlayerTPMode.Value == 'Teleport' then 
			lplr.Character.HumanoidRootPart.CFrame = target.RootPart.CFrame
			PlayerTP.ToggleButton()
		else
			playertween:Play()
		    tempevent = playertween.Completed:Connect(function()
				tempevent:Disconnect()
				if PlayerTP.Enabled then 
					PlayerTP.ToggleButton()
				end
			end)
		end
	end
	PlayerTP = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = 'PlayerTP',
		NoSave = true,
		Function = function(callback)
			if callback then 
				if isAlive(lplr, true) and PlayerTPDelayMethod.Value == 'Instant' then 
					task.spawn(teleportfunc)
				else
					if PlayerTPDelayMethod.Value == 'Instant' then 
						PlayerTP.ToggleButton()
						return
					end
					if isAlive() then
						lplr.Character.Humanoid:TakeDamage(lplr.Character.Humanoid.Health)
						lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
					end
					table.insert(PlayerTP.Connections, lplr.CharacterAdded:Connect(teleportfunc))
				end
			end
		end
	})
	PlayerTPSortMethod = PlayerTP.CreateDropdown({
		Name = 'Method',
		List = {'Distance', 'Health'},
		Function = function() end
	})
	PlayerTPDelayMethod = PlayerTP.CreateDropdown({
		Name = 'Delay Method',
		List = {'Instant', 'Respawn'},
		Function = function() end
	})
	PlayerTPMode = PlayerTP.CreateDropdown({
		Name = 'Teleport Method',
		List = {'Teleport', 'Tween'},
		Function = function() end
	})
end)

runFunction(function()
	local HealthNotifications = {}
	local HealthSlider = {Value = 50}
	local HealthSound = {}
	local oldhealth = 0
	local strikedhealth
	HealthNotifications = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'HealthAlerts',
		HoverText = 'runs actions whenever your health was under threshold.',
		ExtraText = function() return 'Vanilla' end,
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait() until isAlive() or not HealthNotifications.Enabled
					if not HealthNotifications.Enabled then 
						return 
					end
					table.insert(HealthNotifications.Connections, lplr.Character.Humanoid:GetPropertyChangedSignal('Health'):Connect(function()
						if not isAlive() then return end
						local health = lplr.Character.Humanoid.Health
						local maxhealth = lplr.Character.Humanoid.MaxHealth
						if health == oldhealth then return end
						oldhealth = health
						if strikedhealth and health > strikedhealth then strikedhealth = nil end
						if strikedhealth and health <= strikedhealth then return end
						if health < maxhealth and health <= HealthSlider.Value then
							task.spawn(playSound, '7396762708')
							strikedhealth = health + 10
							local healthcheck = health < HealthSlider.Value and 'below' or 'at'
							warningNotification('HealthNotifications', 'Your health is '..healthcheck..' '..HealthSlider.Value, 10)
						end
					end))
					table.insert(HealthNotifications.Connections, lplr.CharacterAdded:Connect(function()
						HealthNotifications.ToggleButton()
						HealthNotifications.ToggleButton()
					end))
				end)
			else
				strikedhealth = nil
				oldhealth = 0
			end
		end
	})
	HealthSlider = HealthNotifications.CreateSlider({
		Name = 'Health',
		Min = 5,
		Max = 80,
		Default = 30,
		Function = function() end
	})
	HealthSound = HealthNotifications.CreateToggle({
		Name = 'Sound',
		HoverText = 'Plays an alarm sound on trigger.',
		Default = true,
		Function = function() end
	})
end)

runFunction(function()
	local LightingMods = {}
	local LightingAmbient = newcolor()
	local LightingShiftBottom = newcolor()
	local LightingOutdoor = newcolor()
	local LightingFogColor = newcolor()
	local LightingBlur = {Value = 0}
	local LightingShiftTop = newcolor()
	local LightingBrightness = {Value = 0}
	local LightingShadowSoft = {Value = 0}
	local LightingTimeOfDay = {Value = 14}
	local LightingEnvDiffuse = {Value = 1}
	local LightingEnvSpecular = {Value = 1}
	local LightingBlurSize = {Value = 7.8}
	local LightingFogStart = {Value = 1}
	local LightingFogEnd = {Value = 1}
	local LightingTechnology = {Value = 'ShadowMap'}
	local LightingGlobal = {Enabled = false}
	local LightingBlur = {}
	local oldlighting = {}
	local blur = {}
	local function lightingUpdateFunc()
		lightingService.Ambient = Color3.fromHSV(LightingAmbient.Hue, LightingAmbient.Sat, LightingAmbient.Value)
		lightingService.OutdoorAmbient = Color3.fromHSV(LightingOutdoor.Hue, LightingOutdoor.Sat, LightingOutdoor.Value)
		lightingService.Brightness = LightingBrightness.Value 
		lightingService.ColorShift_Bottom = Color3.fromHSV(LightingShiftBottom.Hue, LightingShiftBottom.Sat, LightingShiftBottom.Value)
		lightingService.ColorShift_Top = Color3.fromHSV(LightingShiftTop.Hue, LightingShiftTop.Sat, LightingShiftTop.Value)
		lightingService.EnvironmentDiffuseScale = LightingEnvDiffuse.Value  
		lightingService.EnvironmentDiffuseScale = LightingEnvSpecular.Value 
		lightingService.GlobalShadows = LightingGlobal.Enabled
		lightingService.ShadowSoftness = LightingShadowSoft.Value
		lightingService.TimeOfDay = tostring(LightingTimeOfDay.Value)
		lightingService.FogEnd = LightingFogEnd.Value
		lightingService.FogStart = LightingFogStart.Value
		blur.Size = LightingBlurSize.Value  
		blur.Enabled = (LightingBlurSize.Value > 0)
		if sethiddenproperty then 
			sethiddenproperty(lightingService, 'Technology', LightingTechnology.Value) 
		end
	end
	LightingMods = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'LightingMods',
		HoverText = 'Mods settings in lightingService',
		Function = function(calling) 
			if calling then 
				oldlighting.Ambient = lightingService.Ambient
				oldlighting.Brightness = lightingService.Brightness
				oldlighting.ColorShift_Bottom = lightingService.ColorShift_Bottom
				oldlighting.ColorShift_Top = lightingService.ColorShift_Top
				oldlighting.OutdoorAmbient = lightingService.OutdoorAmbient
				oldlighting.EnvironmentDiffuseScale = lightingService.EnvironmentDiffuseScale
				oldlighting.EnvironmentSpecularScale = lightingService.EnvironmentSpecularScale
				oldlighting.GlobalShadows = lightingService.GlobalShadows
				oldlighting.ShadowSoftness = lightingService.ShadowSoftness	
				oldlighting.TimeOfDay = lightingService.TimeOfDay
				oldlighting.FogEnd = lightingService.FogEnd
				oldlighting.FogStart = lightingService.FogStart
				if gethiddenproperty then 
					oldlighting.Technology = gethiddenproperty(lightingService, 'Technology')
				end
				if blur.Parent == nil then 
					blur = Instance.new('BlurEffect', lightingService) 
				end
				table.insert(LightingMods.Connections, runService.Heartbeat:Connect(lightingUpdateFunc))
		   else
			if blur.Parent then 
				blur:Remove()
			end
			   for i,v in next, oldlighting do 
				  pcall(function() lightingService[i] = v end)
				  if i == 'Technology' then 
					 sethiddenproperty(lightingService, i, v)
				  end 
			   end
			end
		end
	})
	LightingAmbient = LightingMods.CreateColorSlider({
		Name = 'Ambient',
		Function = function() end
	})
	LightingOutdoor = LightingMods.CreateColorSlider({
		Name = 'Outdoor Ambient',
		Function = function() end
	})
	LightingShiftTop = LightingMods.CreateColorSlider({
		Name = 'ColorShift Top',
		Function = function() end
	})
	LightingShiftBottom = LightingMods.CreateColorSlider({
		Name = 'ColorShift Bottom',
		Function = function() end
	})
	LightingBrightness = LightingMods.CreateSlider({
		Name = 'Brightness',
		Min = 0,
		Max = 2,
		Default = 1,
		Function = function() end
	})
	LightingEnvDiffuse = LightingMods.CreateSlider({
		Name = 'EnvironmentDiffuseScale',
		Min = 0,
		Max = 100,
		Function = function() end
	})
	LightingEnvSpecular = LightingMods.CreateSlider({
		Name = 'EnvironmentSpecularScale',
		Min = 0,
		Max = 100,
		Function = function() end
	})
	LightingShadowSoft = LightingMods.CreateSlider({
		Name = 'ShadowSoftness',
		Min = 0,
		Max = 1,
		Function = function() end
	})
	LightingBlur = LightingMods.CreateSlider({
		Name = 'Blur',
		Min = 0, 
		Max = 10,
		Function = function() end 
	})
	LightingTimeOfDay = LightingMods.CreateSlider({
		Name = 'Time',
		Min = 0,
		Max = 24,
		Default = 8,
		Function = function() end
	})
	LightingFogStart = LightingMods.CreateSlider({
		Name = 'FogStart',
		Min = 0,
		Max = 1000,
		Default = 1000,
		Function = function() end 
	})
	LightingFogEnd = LightingMods.CreateSlider({
		Name = 'FogEnd',
		Min = 0,
		Max = 1000,
		Default = 1000,
		Function = function() end 
	})
	LightingTechnology = LightingMods.CreateDropdown({
		Name = 'Technology',
		List = GetEnumItems('Technology'),
		Function = function() end 
	})
end)

runFunction(function()
	local PingDetector = {}
	local PingSwitch = {}
	local PingValue = {Value = 10000}
	local detected
	PingDetector = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'PingDetector',
		HoverText = 'Notifies when reaches/goes above threshold.',
		Function = function(callback)
			if callback then 
				repeat
					if shared.VapeFullyLoaded and PingValue.Value <= RenderStore.ping and not detected then 
						detected = true 
						warningNotification('PingDetector', 'Your ping is currently at '..math.floor(RenderStore.ping)..'.', 15)
						if PingSwitch.Enabled then 
							switchserver(function()
								warningNotification('PingDetector', 'Teleporting to a new server.', 10)
							end)
						end
					end
					task.wait()
				until not PingDetector.Enabled
			end
		end
	})
	PingValue = PingDetector.CreateSlider({
		Name = 'Ping',
		Min = 60,
		Max = 10000,
		Default = 1000,
		Function = function() end
	})
end)

runFunction(function()
	local Blink = {}
	local BlinkRepeat = {}
	local BlinkDuration = {Value = 0.5}
	local BlinkDelay = {Value = 0.2}
	local blinkdelay = tick()
	Blink = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'Blink',
		HoverText = 'Freezes your movement server sided.',
		Function = function(calling)
			if calling then 
				table.insert(Blink.Connections, runService.Heartbeat:Connect(function()
					if not isAlive(lplr, true) then 
						return 
					end
					if tick() >= blinkdelay and BlinkRepeat.Enabled then 
						sethiddenproperty(lplr.Character.HumanoidRootPart, 'NetworkIsSleeping', true) 
						if BlinkRepeat.Enabled then 
							blinkdelay = (tick() + (BlinkDuration.Value / 100))
							task.wait(BlinkDelay.Value / 100) 
						end
					end
					sethiddenproperty(lplr.Character.HumanoidRootPart, 'NetworkIsSleeping', not BlinkRepeat.Enabled)
				end))
			end
		end
	})
	BlinkRepeat = Blink.CreateToggle({
		Name = 'Rapid',
		HoverText = 'Rapidly blinks and unblinks.',
		Default = true,
		Function = function(calling) 
			if not calling then 
				blinkdelay = tick() 
			end
			pcall(function() BlinkDuration.Object.Visible = calling end)
			pcall(function() BlinkDelay.Object.Visible = calling end)
		end
	})
	BlinkDuration = Blink.CreateSlider({
		Name = 'Blink Duration',
		Min = 8,
		Max = 95,
		Function = function() end
	})
	BlinkDelay = Blink.CreateSlider({
		Name = 'Delay',
		Min = 8,
		Max = 95,
		Function = function() end
	})
	BlinkDuration.Object.Visible = false
	BlinkDelay.Object.Visible = false 
	task.spawn(function()
		repeat task.wait() until shared.VapeFullyLoaded 
		BlinkDuration.Object.Visible = BlinkRepeat.Enabled
		BlinkDelay.Object.Visible = BlinkRepeat.Enabled 
	end)
end)

runFunction(function()
	local InfiniteJump = {}
	local InfiniteJumpMode = {Value = 'State'}
	local InfiniteJumpPower = {Value = 1}
	local oldpower
	InfiniteJump = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'InfiniteJump',
		HoverText = 'Jump on air without limitations (unless ac lol)',
		Function = function(calling)
			if calling then 
				repeat task.wait() until (isAlive(lplr, true) or not InfiniteJump.Enabled)
				if not InfiniteJump.Enabled then
					return 
				end
				oldpower = lplr.Character.Humanoid.JumpPower
				table.insert(InfiniteJump.Connections, inputService.JumpRequest:Connect(function()
					if isAlive(lplr, true) then 
						if InfiniteJumpMode.Value == 'State' then 
							lplr.Character.Humanoid.JumpPower = (oldpower + InfiniteJumpPower.Value) 
							lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						else
							lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, lplr.Character.Humanoid.JumpPower + InfiniteJumpPower.Value, lplr.Character.HumanoidRootPart.Velocity.Y) 
						end
					end 
				end))
			else
				if oldpower then 
					pcall(function() lplr.Character.Humanoid.JumpPower = oldpower end) 
					oldpower = nil
				end
			end
		end
	})
	InfiniteJumpMode = InfiniteJump.CreateDropdown({
		Name = 'Mode',
		List = {'State', 'Velocity'},
		Function = function()
			if InfiniteJump.Enabled then 
				InfiniteJump.ToggleButton()
				InfiniteJump.ToggleButton()
			end
		end
	})
	InfiniteJumpPower = InfiniteJump.CreateSlider({
		Name = 'Extra Power',
		Min = 0,
		Max = 15,
		Default = 1,
		Function = function() end
	})
end)

runFunction(function()
	local P2CLongJump = {Enabled = false}
    local P2CLongJumpHigh = {Value = "StateTypeJumping"}
    local P2CLongJumpLow = {Value = "Velocity"}
    local P2CLongJumpLowEnable = {Enabled = true}
    local P2CLongJumpElseEndGrav = {Enabled = true}
    local CurrentGrav = workspace.Gravity
    local P2CLongJumpCFHigh = {Value = 8}
    local P2CLongJumpCFDelayHigh = {Value = 16}
    local P2CLongJumpCFDelayLow = {Value = 27}
    local P2CLongJumpVelHigh = {Value = 15}
    local P2CLongJumpVelDelayHigh = {Value = 15}
    local P2CLongJumpVelDelayLow = {Value = 24}
    local P2CLongJumpGravity = {Value = 10}
    local P2CLongJumpStateJumpLow = {Value = 5}
    local P2CLongJumpStateJumpDelayHigh = {Value = 13}
    local P2CLongJumpStateJumpDelayLow = {Value = 8}
    local function lowModes()
        if P2CLongJumpLow.Value == "CFrame" then
            if P2CLongJumpHigh.Value == "CFrame" then
                task.wait(LongJumpSettings.CFDelayHigh)
                local vall = LongJumpSettings.CFHigh - 2
                lplr.Character.HumanoidRootPart.CFrame += vec3(0,-vall,0)
                task.wait(LongJumpSettings.CFDelayLow)
            elseif P2CLongJumpHigh.Value == "Velocity" then
                task.wait(LongJumpSettings.VelDelayHigh)
                local vall1 = LongJumpSettings.VelHigh/2
				lplr.Character.HumanoidRootPart.CFrame += vec3(0,-vall1,0)
                task.wait(LongJumpSettings.VelDelayLow)
            elseif P2CLongJumpHigh.Value == "StateTypeJumping" then
                task.wait(LongJumpSettings.JumpDelayHigh)
                lplr.Character.HumanoidRootPart.CFrame += vec3(0,-LongJumpSettings.JumpLow,0)
                task.wait(LongJumpSettings.JumpDelayLow)
            end
        elseif P2CLongJumpLow.Value == "Velocity" then
            if P2CLongJumpHigh.Value == "Velocity" then
                task.wait(LongJumpSettings.VelDelayHigh)
                local vall1 = LongJumpSettings.VelHigh/2
                lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0,-vall1,0)
                task.wait(LongJumpSettings.VelDelayLow)
            elseif P2CLongJumpHigh.Value == "CFrame" then
                task.wait(LongJumpSettings.CFDelayHigh)
                local vall = LongJumpSettings.CFHigh - 2
                lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0,-vall,0)
                task.wait(LongJumpSettings.CFDelayLow)
            elseif P2CLongJumpHigh.Value == "StateTypeJumping" then
                task.wait(LongJumpSettings.JumpDelayHigh)
                lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0,-LongJumpSettings.JumpLow,0)
                task.wait(LongJumpSettings.JumpDelayLow)
            end
        end
    end
    local LongJumpSettings = {
        Grav = P2CLongJumpGravity.Value,
        CFHigh = P2CLongJumpCFHigh.Value,
        VelHigh = P2CLongJumpVelHigh.Value,
        CFDelayHigh = P2CLongJumpCFDelayHigh.Value/100,
        CFDelayLow = P2CLongJumpCFDelayLow.Value/100,
        VelDelayHigh = P2CLongJumpVelDelayHigh.Value/100,
        VelDelayLow = P2CLongJumpVelDelayLow.Value/100,
        JumpDelayHigh = P2CLongJumpStateJumpDelayHigh.Value/100,
        JumpDelayLow = P2CLongJumpStateJumpDelayLow.Value/100,
        JumpLow = P2CLongJumpStateJumpLow.Value
    }
	P2CLongJump = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"]["CreateOptionsButton"]({
		Name = "LunarFly",
        HoverText = "Custom Fly",
		Function = function(callback)
			if callback then
				workspace.Gravity = LongJumpSettings.Grav
				if P2CLongJumpHigh.Value == "CFrame" then
					task.spawn(function()
						repeat task.wait()
							if isAlive(lplr, true) then
								workspace.Gravity = LongJumpSettings.Grav
								lplr.Character.HumanoidRootPart.CFrame += vec3(0,LongJumpSettings.CFHigh,0)
								if P2CLongJumpLowEnable.Enabled then
									lowModes()
								else
									task.wait(LongJumpSettings.CFDelayLow)
								end
							end
						until not P2CLongJump.Enabled or P2CLongJumpHigh.Value ~= "CFrame"
					end)
				elseif P2CLongJumpHigh.Value == "Velocity" then
					task.spawn(function()
						repeat task.wait()
							if isAlive(lplr, true) then
								workspace.Gravity = LongJumpSettings.Grav
								lplr.Character.HumanoidRootPart.Velocity += vec3(0,LongJumpSettings.VelHigh,0)
								if P2CLongJumpLowEnable.Enabled then
									lowModes()
								else
									task.wait(LongJumpSettings.VelDelayLow)
								end
							end
						until not P2CLongJump.Enabled or P2CLongJumpHigh.Value ~= "Velocity"
					end)
				elseif P2CLongJumpHigh.Value == "StateTypeJumping" then
					task.spawn(function()
						repeat task.wait()
							if isAlive(lplr, true) then
								workspace.Gravity = LongJumpSettings.Grav
								lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								if P2CLongJumpLowEnable.Enabled then
									lowModes()
								else
									task.wait(LongJumpSettings.JumpDelayLow)
								end
							end
						until not P2CLongJump.Enabled or P2CLongJumpHigh.Value ~= "StateTypeJumping"
					end)    
				end
            else
                if P2CLongJumpElseEndGrav.Enabled then
                    workspace.Gravity = CurrentGrav
                else
                    workspace.Gravity = 196.2
                end
			end
		end,
		ExtraText = function()
			return P2CLongJumpHigh.Value
		end
	})
    P2CLongJumpHigh = P2CLongJump.CreateDropdown({
        Name = "High",
        List = {
			"CFrame",
			"Velocity",
			"StateTypeJumping"
		},
        Function = function() end,
    })
    P2CLongJumpLow = P2CLongJump.CreateDropdown({
        Name = "Low",
        List = {
			"CFrame",
			"Velocity"
		},
        Function = function() end,
    })
    P2CLongJumpLowEnable = P2CLongJump.CreateToggle({
        Name = "LowEnable",
        Function = function() end,
    })
    P2CLongJumpElseEndGrav = P2CLongJump.CreateToggle({
        Name = "ElseEndGrav",
        Function = function() end,
    })
    P2CLongJumpCFHigh = P2CLongJump.CreateSlider({
        Name = "CFHigh",
        Min = 1,
        Max = 20,
        Function = function() end,
        Default = 8
    })
    P2CLongJumpCFDelayHigh = P2CLongJump.CreateSlider({
        Name = "CFDelayHigh",
        Min = 5,
        Max = 40,
        Function = function() end,
        Default = 16
    })
    P2CLongJumpCFDelayLow = P2CLongJump.CreateSlider({
        Name = "CFDelayLow",
        Min = 5,
        Max = 40,
        Function = function() end,
        Default = 27
    })
    P2CLongJumpVelHigh = P2CLongJump.CreateSlider({
        Name = "VelHigh",
        Min = 1,
        Max = 30,
        Function = function() end,
        Default = 15
    })
    P2CLongJumpVelDelayHigh = P2CLongJump.CreateSlider({
        Name = "VelDelayHigh",
        Min = 10,
        Max = 20,
        Function = function() end,
        Default = 15
    })
    P2CLongJumpVelDelayLow = P2CLongJump.CreateSlider({
        Name = "VelDelayLow",
        Min = 7,
        Max = 40,
        Function = function() end,
        Default = 24
    })
    P2CLongJumpGravity = P2CLongJump.CreateSlider({
        Name = "Gravity",
        Min = 0,
        Max = 192,
        Function = function() end,
        Default = 50
    })
    P2CLongJumpStateJumpLow = P2CLongJump.CreateSlider({
        Name = "StateJumpLow",
        Min = 1,
        Max = 15,
        Function = function() end,
        Default = 5
    })
    P2CLongJumpStateJumpDelayHigh = P2CLongJump.CreateSlider({
        Name = "StateJumpDelayHigh",
        Min = 8,
        Max = 25,
        Function = function() end,
        Default = 13
    })
    P2CLongJumpStateJumpDelayLow = P2CLongJump.CreateSlider({
        Name = "StateJumpDelayLow",
        Min = 1,
        Max = 15,
        Function = function() end,
        Default = 8
    })
end)

runFunction(function()
	local GameWeather = {Enabled = false}
	local GameWeatherMode = {Value = "Snow"}
	local SnowflakesSpread = {Value = 35}
	local SnowflakesRate = {Value = 28}
	local SnowflakesHigh = {Value = 100}
	GameWeather = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"]["CreateOptionsButton"]({
		Name = 'GameWeather',
		HoverText = 'Changes the weather',
		Function = function(callback) 
			if callback then
				task.spawn(function()
					if RenderPerformance then 
						return 
					end
					local snowpart = Instance.new("Part")
					snowpart.Size = Vector3.new(240,0.5,240)
					snowpart.Name = "SnowParticle"
					snowpart.Transparency = 1
					snowpart.CanCollide = false
					snowpart.Position = Vector3.new(0,120,286)
					snowpart.Anchored = true
					snowpart.Parent = workspace
					local snow = Instance.new("ParticleEmitter")
					snow.RotSpeed = NumberRange.new(300)
					snow.VelocitySpread = SnowflakesSpread.Value
					snow.Rate = SnowflakesRate.Value
					snow.Texture = "rbxassetid://8158344433"
					snow.Rotation = NumberRange.new(110)
					snow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
					snow.Lifetime = NumberRange.new(8,14)
					snow.Speed = NumberRange.new(8,18)
					snow.EmissionDirection = Enum.NormalId.Bottom
					snow.SpreadAngle = Vector2.new(35,35)
					snow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
					snow.Parent = snowpart
					local windsnow = Instance.new("ParticleEmitter")
					windsnow.Acceleration = Vector3.new(0,0,1)
					windsnow.RotSpeed = NumberRange.new(100)
					windsnow.VelocitySpread = SnowflakesSpread.Value
					windsnow.Rate = SnowflakesRate.Value
					windsnow.Texture = "rbxassetid://8158344433"
					windsnow.EmissionDirection = Enum.NormalId.Bottom
					windsnow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.16939899325371,0),NumberSequenceKeypoint.new(0.23365999758244,0.62841498851776,0.37158501148224),NumberSequenceKeypoint.new(0.56209099292755,0.38797798752785,0.2771390080452),NumberSequenceKeypoint.new(0.90577298402786,0.51912599802017,0),NumberSequenceKeypoint.new(1,1,0)})
					windsnow.Lifetime = NumberRange.new(8,14)
					windsnow.Speed = NumberRange.new(8,18)
					windsnow.Rotation = NumberRange.new(110)
					windsnow.SpreadAngle = Vector2.new(35,35)
					windsnow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.039760299026966,1.3114800453186,0.32786899805069),NumberSequenceKeypoint.new(0.7554469704628,0.98360699415207,0.44038599729538),NumberSequenceKeypoint.new(1,0,0)})
					windsnow.Parent = snowpart
					repeat
						task.wait()
						if isAlive(lplr, true) then 
							snowpart.Position = lplr.Character.HumanoidRootPart.Position + vec3(0,SnowflakesHigh.Value,0)
						end
					until not vapeInjected
				end)
			else
				for _, v in next, workspace:GetChildren() do
					if v.Name == "SnowParticle" then
						v:Remove()
					end
				end
			end
		end
	})
	SnowflakesSpread = GameWeather.CreateSlider({
		Name = "Snow Spread",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 35
	})
	SnowflakesRate = GameWeather.CreateSlider({
		Name = "Snow Rate",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 28
	})
	SnowflakesHigh = GameWeather.CreateSlider({
		Name = "Snow High",
		Min = 1,
		Max = 200,
		Function = function() end,
		Default = 100
	})
end)

runFunction(function()
	local FakeLag = {Enabled = false}
	local FakeLagUsage = {Value = "Blatant"}
	local FakeLagSpeed = {Enabled = false}
	local FakeLagDelay1 = {Value = 2}
	local FakeLagDelay2 = {Value = 7}
	local FakeLagDelayLegit = {Value = 3}
	local FakeLagSpeed1 = {Value = 22}
	local FakeLagSpeed2 = {Value = 18}
	local FakeLagSpeed3 = {Value = 20}
	local FakeLagSpeed4 = {Value = 2.7}
	local FakeLagSpeed5 = {Value = 1.5}
	local function ChangeSpeeds()
		lplr.Character.Humanoid.WalkSpeed = FakeLagSpeed1.Value
		task.wait(FakeLagSpeed4.Value/10)
		lplr.Character.Humanoid.WalkSpeed = FakeLagSpeed2.Value
		task.wait(FakeLagSpeed5.Value/10)
		lplr.Character.Humanoid.WalkSpeed = FakeLagSpeed3.Value
	end
	FakeLag = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"]["CreateOptionsButton"]({
		Name = "FakeLag",
        HoverText = "Makes people think you're laggy",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat task.wait()
						if FakeLagUsage.Value == "Blatant" then
							lplr.Character.HumanoidRootPart.Anchored = true
							task.wait(FakeLagDelay1.Value/10)
							lplr.Character.HumanoidRootPart.Anchored = false
							ChangeSpeeds()
							task.wait(FakeLagDelay2.Value/10)
						elseif FakeLagUsage.Value == "Legit" then
							lplr.Character.HumanoidRootPart.Anchored = true
							task.wait(FakeLagDelay1.Value/10 + FakeLagDelayLegit.Value)
							lplr.Character.HumanoidRootPart.Anchored = false
							ChangeSpeeds()
							task.wait(FakeLagDelay2.Value/10 + FakeLagDelayLegit.Value)
						end
					until not FakeLag.Enabled
				end)
			else
				if lplr.Character.HumanoidRootPart.Anchored then
					lplr.Character.HumanoidRootPart.Anchored = false
				end
			end
		end,
		ExtraText = function()
			return FakeLagUsage.Value
		end
	})
	FakeLagUsage = FakeLag.CreateDropdown({
		Name = "Mode",
		List = {
			"Blatant",
			"Legit"
		},
		HoverText = "FakeLag Mode",
		Function = function() end,
	})
	FakeLagSpeed = FakeLag.CreateToggle({
		Name = "Speed",
		Default = false,
		HoverText = "Changes speed",
		Function = function() end,
	})
	FakeLagDelay1 = FakeLag.CreateSlider({
		Name = "Anchored Delay",
		Min = 0,
		Max = 20,
		HoverText = "Anchored Delay Value",
		Function = function() end,
		Default = 2
	})
	FakeLagDelay2 = FakeLag.CreateSlider({
		Name = "Unanchored Delay",
		Min = 0,
		Max = 20,
		HoverText = "Not Anchored Delay Value",
		Function = function() end,
		Default = 7
	})
	FakeLagDelayLegit = FakeLag.CreateSlider({
		Name = "Legit",
		Min = 1,
		Max = 10,
		HoverText = "Legit Time",
		Function = function() end,
		Default = 3
	})
	FakeLagSpeed1 = FakeLag.CreateSlider({
		Name = "Speed 1",
		Min = 1,
		Max = 22,
		HoverText = "Speed 1 Value",
		Function = function() end,
		Default = 22
	})
	FakeLagSpeed2 = FakeLag.CreateSlider({
		Name = "Speed 2",
		Min = 1,
		Max = 20,
		HoverText = "Speed 2 Value",
		Function = function() end,
		Default = 18
	})
	FakeLagSpeed3 = FakeLag.CreateSlider({
		Name = "Speed 3",
		Min = 1,
		Max = 20,
		HoverText = "Speed 3 Value",
		Function = function() end,
		Default = 20
	})
	FakeLagSpeed4 = FakeLag.CreateSlider({
		Name = "Speed Delay 1",
		Min = 1,
		Max = 3,
		HoverText = "Speed Delay 1 Value",
		Function = function() end,
		Default = 2.7
	})
	FakeLagSpeed5 = FakeLag.CreateSlider({
		Name = "Speed Delay 2",
		Min = 1,
		Max = 3,
		HoverText = "Speed Delay 2 Value",
		Function = function() end,
		Default = 1.5
	})
end)

runFunction(function()
	local chatDisable = {Enabled = false}
	local chatVersion = function()
		if game.Chat:GetChildren()[1] then return true else return false end
	end
	chatDisable = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"]["CreateOptionsButton"]({
		Name = "ChatDisable",
		HoverText = "Disables the chat",
		Function = function(callback)
			if callback then
				if chatVersion() then
					lplr.PlayerGui.Chat.Enabled = false
					game:GetService("CoreGui").TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = false
				elseif (not chatVersion()) then
					game.CoreGui.ExperienceChat.Enabled = false
					game:GetService("CoreGui").TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = false
					textChatService.ChatInputBarConfiguration.Enabled = false
					textChatService.BubbleChatConfiguration.Enabled = false
				end
			else
				if chatVersion() then
					lplr.PlayerGui.Chat.Enabled = true
					core.TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = true
				else
					gcore.ExperienceChat.Enabled = true
					core.TopBarApp.TopBarFrame.LeftFrame.ChatIcon.Visible = true
					textChatService.ChatInputBarConfiguration.Enabled = true
					textChatService.BubbleChatConfiguration.Enabled = true
				end
			end
		end
	})
end)

runFunction(function()
	local Translation = {}
	local language = {Value = 'chinese'} 
	local oldnames = {}
	local sitrequests = 0
	local function addtranslated(old, translated)
		if not isfolder('vape/Render/translations') then 
			makefolder('vape/Render/translations') 
		end
		local success, data = pcall(function()
			return httpService:JSONDecode(readfile('vape/Render/translations/'..language.Value:lower()..'.json')) 
		end) 
		if type(data) ~= 'table' then data = {} end 
		data[old] = translated 
		writefile('vape/Render/translations/'..language.Value:lower()..'.json', httpService:JSONEncode(data))
	end
	local function translatedata(text)
		local success, data = pcall(function()
			return httpService:JSONDecode(readfile('vape/Render/translations/'..language.Value:lower()..'.json')) 
		end) 
		if type(data) ~= 'table' then data = {} end  
		if data[text] then 
			return (data[text] ~= '' and data[text])
		end
		local timeTaken = tick()
		local translation = httprequest({Url = 'https://translate.renderintents.xyz', Method = 'GET', Headers = {Language = language.Value, Text = text}}) 
		sitrequests += 1
		if translation.StatusCode == 200 then 
			local new = httpService:JSONDecode(translation.Body).translated
			addtranslated(text, new) 
			timeTaken = (tick() - timeTaken) 
			if timeTaken < 10 and sitrequests >= 9 then -- site rate limits lol 
				task.wait(10 - timeTaken)
				sitrequests = 0
			end
			return (new ~= '' and new)
		end
	end
	Translation = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'Translation',
		HoverText = 'Translates stuff in vape.',
		Function = function(calling) 
			if calling then 
				for i,v in next, GuiLibrary.ObjectsThatCanBeSaved do 
					if v.Type == 'OptionsButton' and i ~= 'TranslationOptionsButton' then
						pcall(function()
							if not Translation.Enabled then return end
							local translated = translatedata(v.Object.ButtonText.Text)
							if translated and Translation.Enabled then 
								oldnames[i] = {ApiText = v.Api.Name, ObjectText = v.Object.ButtonText.Text}
								v.Object.ButtonText.Text = translated
								v.Api.Name = translated
								if v.Api.Enabled then 
									GuiLibrary.UpdateTextGUI() 
								end
							end 
						end)
					end 
				end
			else
				if vapeInjected then 
					for i,v in next, oldnames do 
						GuiLibrary.ObjectsThatCanBeSaved[i].Object.ButtonText.Text = v.ObjectText
						GuiLibrary.ObjectsThatCanBeSaved[i].Api.Name = v.ApiText 
					end
					GuiLibrary.UpdateTextGUI()  
					table.clear(oldnames)
				end
			end 
		end
	})
	language = Translation.CreateDropdown({
		Name = 'Language', 
		List = {'Spanish', 'French', 'Japanese', 'Chinese', 'Hindi', 'Russian'},
		Function = function(calling) 
			task.spawn(function()
				if calling == false or not shared.VapeFullyLoaded then return end
				Translation.ToggleButton()
				if not Translation.Enabled then Translation.ToggleButton() end 
			end)
		end,
	})
end)

runFunction(function()
	local BubbleMods = {}
	local BubbleModsColorToggle = {}
	local BubbleModsTextSizeToggle = {}
	local BubbleModsTextColorToggle = {}
	local BubbleModsTextSize = {Value = 16}
	local BubbleModsTextColor = newcolor()
	local BubbleModsColor = newcolor()
	local chatbubbles = {}
	local function bubbleFunction(bubble)
		pcall(function() 
			local name = 'ChatBubbleFrame'
			if core:FindFirstChild('BubbleChat') then 
				name = 'Frame' 
			end
			if tostring(bubble) ~= name and tostring(bubble) ~= 'RoundedFrame' then 
				return 
			end
			if BubbleModsColorToggle.Enabled then 
				bubble.BackgroundColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value)
				pcall(function() bubble.Parent.Caret.ImageColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value) end)
				pcall(function() bubble.Parent.Carat.ImageColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value) end)
			end
			if BubbleModsTextColorToggle.Enabled then 
				pcall(function() bubble.Text.TextColor3 = Color3.fromHSV(BubbleModsTextColor.Hue, BubbleModsTextColor.Sat, BubbleModsTextColor.Value) end)
				pcall(function() bubble.Contents.Ellipsis.TextColor3 = Color3.fromHSV(BubbleModsTextColor.Hue, BubbleModsTextColor.Sat, BubbleModsTextColor.Value) end)
			end
			if BubbleModsTextSizeToggle.Enabled then 
				pcall(function() bubble.Text.TextSize = BubbleModsTextSize.Value end)
				pcall(function() bubble.Contents.Ellipsis.TextSize = BubbleModsTextSize.Value end)
			end
			table.insert(chatbubbles, bubble)
		end)
	end
	BubbleMods = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'BubbleMods',
		HoverText = 'Mods the bubble chat experience.',
		Function = function(calling) 
			if calling then 
				local bubblechat = (core:FindFirstChild('ExperienceChat') and core.ExperienceChat.bubbleChat or core:FindFirstChild('BubbleChat') or Instance.new('ScreenGui'))
				for i,v in next, bubblechat:GetDescendants() do 
					bubbleFunction(v)
				end
				table.insert(BubbleMods.Connections, bubblechat.DescendantAdded:Connect(bubbleFunction))
			else 
				for i,v in next, chatbubbles do 
					pcall(function() v.Text.TextColor3 = Color3.fromRGB(57, 59, 61) end)
					pcall(function() v.Text.TextSize = 16 end)
					pcall(function() v.Parent.Carat.ImageColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value) end)
				end
			end
		end
	})
	BubbleModsColorToggle = BubbleMods.CreateToggle({
		Name = 'Background Color',
		Function = function(calling)
			pcall(function() BubbleModsColor.Object.Visible = calling end)
		end
	})
	BubbleModsTextColorToggle = BubbleMods.CreateToggle({
		Name = 'Text Color',
		Function = function(calling)
			pcall(function() BubbleModsTextColor.Object.Visible = calling end)
		end
	})
	BubbleModsTextSizeToggle = BubbleMods.CreateToggle({
		Name = 'Text Size',
		Function = function(calling)
			pcall(function() BubbleModsTextSize.Object.Visible = calling end)
		end
	})
	BubbleModsColor = BubbleMods.CreateColorSlider({
		Name = 'Background Color',
		Function = function()
			if BubbleModsColorToggle.Enabled then 
				for i,v in next, chatbubbles do 
					pcall(function() 
						v.BackgroundColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value) 
						pcall(function() v.Parent.Caret.ImageColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value) end)
						pcall(function() v.Parent.Carat.ImageColor3 = Color3.fromHSV(BubbleModsColor.Hue, BubbleModsColor.Sat, BubbleModsColor.Value) end)
					end)
				end  
			end
		end
	})
	BubbleModsTextColor = BubbleMods.CreateColorSlider({
		Name = 'Text Color',
		Function = function()
			if BubbleModsTextColorToggle.Enabled then   
				for i,v in next, chatbubbles do 
					pcall(function() v.Text.TextColor3 = Color3.fromHSV(BubbleModsTextColor.Hue, BubbleModsTextColor.Sat, BubbleModsTextColor.Value) end)
					pcall(function() v.Contents.Ellipsis.TextColor3 =  Color3.fromHSV(BubbleModsTextColor.Hue, BubbleModsTextColor.Sat, BubbleModsTextColor.Value) end) 
				end 
			end
		end
	})
	BubbleModsTextSize = BubbleMods.CreateSlider({
		Name = 'Text Size',
		Min = 10,
		Max = 23,
		Function = function(size)
			if BubbleModsTextSizeToggle.Enabled then 
				for i,v in next, chatbubbles do 
					pcall(function() v.Text.TextSize = 16 end)
					pcall(function() v.Contents.Ellipsis.TextSize = BubbleModsTextSize.Value end)
				end 
			end
		end
	})
	BubbleModsColor.Object.Visible = false 
	BubbleModsTextColor.Object.Visible = false
	BubbleModsTextSize.Object.Visible = false
end)

runFunction(function()
	local AutoRewind = {}
	local AutoRewindRaycast = {Enabled = true}
	local AutoRewindSpeed = {Value = 0.49}
	local AutoRewindMode = {Value = 'Position'}
	local AutoRewindTween = {Value = 'Linear'}
	local deathtween
	local deathposition 
	AutoRewind = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = 'AutoRewind',
		HoverText = 'Automatically teleports you to\nthe position you died whenever you respawn.',
		Function = function(calling)
			if calling then 
				table.insert(AutoRewind.Connections, lplr.CharacterAdded:Connect(function()
					local speed, position = (AutoRewindSpeed.Value / 35) + 0.0001, deathposition
					repeat task.wait() until isAlive(lplr, true) 
					if not position then return end
					if AutoRewindMode.Value == 'Target' then 
						local target = GetTarget()
						if target.RootPart then 
							speed, position = (AutoRewindSpeed.Value / 35) + 0.0001, target.RootPart.Position
						end
					end 
					if speed <= 0 then 
						speed = 0.0001 
					end
					deathtween = tweenService:Create(lplr.Character.HumanoidRootPart, TweenInfo.new(speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)}) 
					deathtween:Play()
					deathtween.Completed:Wait()
					deathtween = nil
				end))
				table.insert(AutoRewind.Connections, runService.Heartbeat:Connect(function()
					if isAlive() then 
						local ray = (AutoRewindRaycast.Enabled and workspace:Raycast(getraypart(lplr).Position, Vector3.new(0, -9e9, 0), RenderStore.raycast) or AutoRewindRaycast.Enabled == false and {Position = getraypart(lplr).Position})
						if ray then 
							deathposition = (ray.Position + Vector3.new(0, 5, 0))
						end 
					end
				end))
			else
				pcall(function() deathtween:Cancel() end)
				deathtween = nil
			end
		end
	})
	AutoRewindMode = AutoRewind.CreateDropdown({
		Name = 'Rewind Mode',
		List = {'Position', 'Target'},
		Function = function() end
	})
	AutoRewindTween = AutoRewind.CreateDropdown({
		Name = 'Tween Method',
		List = GetEnumItems('EasingStyle'),
		Function = function() end
	})
	AutoRewindSpeed = AutoRewind.CreateSlider({
		Name = 'Speed',
		Min = 0,
		Max = 50,
		Function = function() end
	})
end) 

runFunction(function()
	local MotionBlur = {}
	local MotionBlurTarget = {}
	local MotionBlurIntensity = {Value = 8.5}
	local blur = {}
	MotionBlur = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = 'MotionBlur',
		HoverText = 'Adds background blur when you\'re moving.',
		Function = function(calling)
			if calling then 
				repeat task.wait() until (isAlive(lplr, true) or not MotionBlur.Enabled)
				table.insert(MotionBlur.Connections, lplr.Character.HumanoidRootPart:GetPropertyChangedSignal('CFrame'):Connect(function()
					if MotionBlurTarget.Enabled and vapeTargetInfo.Targets.Killaura == nil then 
						return 
					end
					if blur.Parent == nil then 
						blur = Instance.new('BlurEffect', lightingService)
						debris:AddItem(blur, 0)
					end
					blur.Size = MotionBlurIntensity.Value
				end))
				table.insert(MotionBlur.Connections, lplr.CharacterAdded:Connect(function()
					MotionBlur.ToggleButton()
					MotionBlur.ToggleButton()
				end))
			end
		end
	})
	MotionBlurTarget = MotionBlur.CreateToggle({
		Name = 'Killaura Only',
		HoverText = 'Only works when killaura is active.',
		Default = true,
		Function = function() end
	})
	MotionBlurIntensity = MotionBlur.CreateSlider({
		Name = 'Intensity',
		Min = 2,
		Max = 10,
		Default = 8.5,
		Function = function() end
	})
end)

runFunction(function()
	local RichShader = {}
	local ShaderColor = {Hue = 0, Sat = 0, Value = 0}
	local ShaderBlur
	local ShaderTint
	local oldlightingsettings = {}
	local function refreshsettings()
		oldlightingsettings = {
			Brightness = lightingService.Brightness,
			ColorShift_Top = lightingService.ColorShift_Top,
			ColorShift_Bottom = lightingService.ColorShift_Bottom,
			OutdoorAmbient = lightingService.OutdoorAmbient,
			ClockTime = lightingService.ClockTime,
			FogColor = lightingService.FogColor,
			FogStart = lightingService.FogStart,
			FogEnd = lightingService.FogEnd,
			ExposureCompensation = lightingService.ExposureCompensation,
			ShadowSoftness = lightingService.ShadowSoftness,
			Ambient = lightingService.Ambient
		}
	end
	RichShader = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = 'RichShader',
		HoverText = 'cool shader mhm.',
		Function = function(callback)
			if callback then
				refreshsettings()
				ShaderBlur = Instance.new('BlurEffect')
				ShaderBlur.Parent = lightingService
				ShaderBlur.Size = 5
				ShaderTint = Instance.new('ColorCorrectionEffect')
				ShaderTint.Parent = lightingService
				ShaderTint.Saturation = -0.2
				ShaderTint.TintColor = Color3.fromRGB(255, 224, 219)
				lightingService.ColorShift_Bottom = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.ColorShift_Top = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.OutdoorAmbient = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.ClockTime = 8.7
				lightingService.FogColor = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.FogEnd = 1000
				lightingService.FogStart = 0
				lightingService.ExposureCompensation = 0.30
				lightingService.ShadowSoftness = 0
				lightingService.Ambient = Color3.fromRGB(59, 33, 27)
			else
				for i,v in oldlightingsettings do 
					lightingService[i] = v 
				end 
				if ShaderTint and ShaderTint.Parent then 
					ShaderTint:Destroy() 
				end
				if ShaderBlur and ShaderBlur.Parent then 
					ShaderBlur:Destroy()
				end
			end
		end
	})
	ShaderColor = RichShader.CreateColorSlider({
		Name = 'Main Color',
		Function = function()
			if RichShader.Enabled then 
				lightingService.ColorShift_Bottom = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.ColorShift_Top = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.OutdoorAmbient = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
				lightingService.FogColor = Color3.fromHSV(ShaderColor.Hue, ShaderColor.Sat, ShaderColor.Value)
			end
		end
	})
end)

run(function()
	local ProximityPromptAdjust = {Enabled = false}
	local FastInteract = {Enabled = false}
	local interactCooldown = {Value = 0}
	ProximityPromptAdjust = guilib.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "AdjustProximity",
		Function = function(call)
			if not call then
				if FastInteract then FastInteract:Disconnect() end
			end
		end,
		ExtraText = function()
			if FastInteract.Enabled then
				return "Cooldown: ".. interactCooldown.Value
			end
		end
	})
	FastInteract = ProximityPromptAdjust.CreateToggle({
		Name = "instaInteract",
		Function = function(call)
			interactCooldown.Object.Visible = call
			if ProximityPromptAdjust.Enabled then
				FastInteract = proximityService.PromptButtonHoldBegan:Connect(function(v)
					task.wait(interactCooldown.Value)
					fireproximityprompt(v)
				end)
			end
		end
	})
	interactCooldown = ProximityPromptAdjust.CreateSlider({
		Name = "interactCooldown",
		Min = 0,
		Max = 15,
		Function = function() end,
		Default = 0
	})
end)

run(function()
	local ReplicatedLag = {}
	local ReplicatedLagTick = {Value = 5}
	ReplicatedLag = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "ReplicatedLag",
		Function = function(call)
			if call then
				settings():GetService("NetworkSettings").IncomingReplicationLag = ReplicatedLagTick.Value
			else
                settings():GetService("NetworkSettings").IncomingReplicationLag = 0 
			end
		end,
		HoverText = "Ping Increased."
	})
	ReplicatedLagTick = ReplicatedLag.CreateSlider({
		Name = "Tick",
		Min = 0.1,
		Max = 5,
		Default = 0.23,
	})
end)
