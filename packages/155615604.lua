-- Render Custom Vape Signed File
--- thanks relevant
local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local uis = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

local RenderStepTable = {}
local StepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function WarningNotification(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

local function targetCheck(plr, check)
	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
end

local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and isAlive(plr) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runFunction(func)
	func()
end

local function GetAllNearestHumanoidToPosition(player, distance, amount)
	local returnedplayer = {}
	local currentamount = 0
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and currentamount < amount then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= distance then
                    table.insert(returnedplayer, v)
					currentamount = currentamount + 1
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToPosition(player, distance)
	local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                if mag <= closest then
                    closest = mag
                    returnedplayer = v
                end
            end
        end
	end
	return returnedplayer
end

local function GetNearestHumanoidToMouse(player, distance, checkvis)
    local closest, returnedplayer = distance, nil
    if isAlive() then
        for i, v in pairs(players:GetChildren()) do
            if isPlayerTargetable((player and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and (checkvis == false or checkvis and (vischeck(v.Character, "Head") or vischeck(v.Character, "HumanoidRootPart"))) then
                local vec, vis = cam:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local mag = (uis:GetMouseLocation() - Vector2.new(vec.X, vec.Y)).magnitude
                    if mag <= closest then
                        closest = mag
                        returnedplayer = v
                    end
                end
            end
        end
    end
    return returnedplayer
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

--
runFunction(function()
    local getitem = {Enabled = false}
    local chosenitem = {Value = "M9"}
    getitem = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "Get item",
        HoverText = "get any item",
        Function = function(callback)
            if callback then
				local startpos = lplr.Character.HumanoidRootPart.Position
				lplr.Character:MoveTo(workspace.Prison_ITEMS.giver[chosenitem.Value]:WaitForChild("ITEMPICKUP").Position)
				wait(0.2)
                workspace:WaitForChild("Remote"):WaitForChild("ItemHandler"):InvokeServer(Workspace.Prison_ITEMS.giver[chosenitem.Value]:WaitForChild("ITEMPICKUP"))
				lplr.Character:MoveTo(startpos)
				getitem.ToggleButton(false)
            end
        end
    })
	local list = {}
	for i,v in pairs(workspace.Prison_ITEMS.giver:GetChildren()) do
		table.insert(list, v.Name)
	end
    chosenitem = getitem.CreateDropdown({
        Name = "Item",
        List = list,
        Function = function(val) end,
    })
end)

GuiLibrary.RemoveObject("KillauraOptionsButton")
--
runFunction(function()
	local smallkillaura = {Enabled = false}
	local function getclosest()
		local closest, returnedplayer = 17, nil
		if isAlive() then
			for i, v in pairs(players:GetChildren()) do
				if isPlayerTargetable((lplr and v or nil), true, true) and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
					local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
					if mag <= closest then
						closest = mag
						returnedplayer = v
					end
				end
			end
		end
		return returnedplayer
	end
	smallkillaura = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "killaura",
		HoverText = "kill players around you",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						local plr = getclosest()
						print(plr)
						if plr then
							game:GetService("ReplicatedStorage"):WaitForChild("meleeEvent"):FireServer(plr)
						end
						task.wait(0.01)
					until not smallkillaura.Enabled
				end)	
			end
		end
	})
end)


runFunction(function()
    local mousekill = {Enabled = false}
    mousekill = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
        Name = "Mouse kill",
        HoverText = "kill player under mouse",
        Function = function(callback)
            if callback then
                local humanoid = GetNearestHumanoidToMouse(lplr.Character, 9e9, false)
                if humanoid then
					local gun
					for i,v in pairs(lplr.Backpack:GetChildren()) do
						if v:IsA("Tool") then
							gun = v.Name
						end
					end 
					game:GetService("ReplicatedStorage").ShootEvent:FireServer({
						[1] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [2] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [3] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [4] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [5] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [6] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [7] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}, [8] = {
							["RayObject"] = Ray.new(Vector3.new(), Vector3.new()), 
							["Distance"] = 0, 
							["Cframe"] = CFrame.new(), 
							["Hit"] = workspace[humanoid.Name].Head
						}
					}, lplr.Backpack[gun])
					game:GetService("ReplicatedStorage"):WaitForChild("ReloadEvent"):FireServer(lplr.Backpack[gun])					
                    WarningNotification("Mouse kill", "Killed "..humanoid.Name, 5)
                end
				if mousekill.Enabled then
                	mousekill.ToggleButton(false)
				end
            end
        end
    })
	--[[range = mousekill.CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 25000,
		Def = 10000,
		Func = function(val) end
	})]]
end)
--
runFunction(function()
	local notoolkill = {Enabled = false}
	notoolkill = GuiLibrary.ObjectsThatCanBeSaved.CombatWindow.Api.CreateOptionsButton({
		Name = "No tool kill",
		HoverText = "kill player without tool",
		Function = function(callback)
			if callback then
				task.spawn(function()
					local humanoid = GetNearestHumanoidToMouse(lplr.Character, 500, false)
					if humanoid then
						local test32 = false
						local originalpos = lplr.Character.HumanoidRootPart.Position
						lplr.Character:MoveTo(humanoid.Character.HumanoidRootPart.Position)
						repeat
							game:GetService("ReplicatedStorage"):WaitForChild("meleeEvent"):FireServer(humanoid)
							wait()
						until humanoid.Character.Humanoid.Health <= 0
						lplr.Character:MoveTo(originalpos)
						WarningNotification("No tool kill", "Killed "..humanoid.Name, 3)
					end
				end)
			end
			if notoolkill.Enabled then
				notoolkill.ToggleButton(false)
			end
		end
	})
end)

runFunction(function()
	local setteam = {Enabled = false}
	local team = {Value = "Inmate"}
	local teamtocolor = {
		["Inmate"] = "Bright orange",
		["Police"] = "Bright blue",
		["Criminal"] = "Bright red"
	}
	setteam = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "Set team",
		HoverText = "set your team to inmate, police or criminal",
		Function = function(callback)
			if callback then
				local teamcolor = teamtocolor[team.Value]
				local origpos = lplr.Character.HumanoidRootPart.Position
					if teamcolor == 'Bright blue' or teamcolor == 'Bright orange' then
						workspace:WaitForChild("Remote"):WaitForChild("TeamEvent"):FireServer(teamcolor)
					else
						lplr.Character:MoveTo(workspace["Criminals Spawn"]:GetChildren()[2].Position)
						wait(0.2)
						lplr.Character:MoveTo(origpos)
					end
			end
			if setteam.Enabled then
				setteam.ToggleButton(false)
			end
		end
	})
	team = setteam.CreateDropdown({
		Name = "Team",
		List = {"Inmate", "Police", "Criminal"},
		Function = function() end,
	})
end)



runFunction(function()
	local killall = {Enabled = false}
	local killallteam = {Value = "Criminals"}
	killall = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Kill all",
		HoverText = "kill all players",
		Function = function(callback)
			if callback then
				task.spawn(function()
					local origpos = lplr.Character.HumanoidRootPart.Position
					for i,v in pairs(game.Teams[killallteam.Value]:GetPlayers()) do
						if v ~= lplr and v.Character then
							lplr.Character:MoveTo(v.Character.HumanoidRootPart.Position)
							repeat								
								game:GetService("ReplicatedStorage"):WaitForChild("meleeEvent"):FireServer(v)
								task.wait()
							until v.Character:FindFirstChild("Humanoid").Health <= 0
							wait()
						end
					end
					lplr.Character:MoveTo(origpos)
				end)
			end
			if killall.Enabled then
				wait(1)
				killall.ToggleButton(false)
				WarningNotification("Kill all", "Killed all players on "..killallteam.Value.." team.", 5)
			end
		end
	})
	killallteam = killall.CreateDropdown({
		Name = "Team",
		List = {"Criminals", "Guards", "Inmates"},
		Function = function() end,
	})
end)

runFunction(function()
	local arrestaura = {Enabled = false}
	arrestaura = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
		Name = "Arrest aura",
		HoverText = "arrest players around you",
		Function = function(callback)
			if callback then
				task.spawn(function()
					repeat
						local closestplr = GetNearestHumanoidToPosition(lplr.Character, 25)
						if closestplr then
							workspace:WaitForChild("Remote"):WaitForChild("arrest"):InvokeServer(closestplr.Character.Torso)							
						end
						task.wait()
					until not arrestaura.Enabled
				end)
			end
		end
	})
end)



runFunction(function()
    local arrestall = {Enabled = false}
    arrestall = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
        Name = "Arrest all",
        HoverText = "arrest all criminals",
        Function = function(callback)
            if callback then
                local origpos = lplr.Character.HumanoidRootPart.Position
                task.spawn(function()
					for i,v in pairs(game.Teams:WaitForChild("Criminals"):GetPlayers()) do
						if v.Name ~= lplr.Name then
							repeat
								lplr.Character:MoveTo(v.Character.HumanoidRootPart.Position)
								workspace.Remote.arrest:InvokeServer(v.Character.Head)
								wait()
							until v.Character:FindFirstChild("Head"):FindFirstChild("handcuffedGui")
						end
					end
                    wait(0.1)
                    lplr.Character:MoveTo(origpos)
                end)
            end
            if arrestall.Enabled then
                arrestall.ToggleButton(false)
            end
        end
    })
end)
