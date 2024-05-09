local GuiLibrary = shared.GuiLibrary
local cloneref = (cloneref or function(i) return i end)
local hookmetamethod = (hookmetamethod or hookmt or function() end)
local getservice = function(service)
	return cloneref(game.GetService(game, service))
end

local RenderFunctions = RenderFunctions
local players = getservice('Players')
local runservice = getservice('RunService')
local collection = getservice('CollectionService')
local repliactedstorage = getservice('ReplicatedStorage')
local getmetatable = (getmetatable or getrenv and getrenv().getmetatable or function(tab) return tab end)
local camera = (workspace.CurrentCamera or workspace:FindFirstChildWhichIsA('Camera') or Instance.new('Camera', workspace))
local vapeloaded = true
local vapeconnections = {}
local vapewhitelist = shared.vapewhitelist
local entitylib = shared.vapeentity
local vapetarget = shared.VapeTargetInfo
local lplr = players.LocalPlayer

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	vapeloaded = false
	for i,v in next, vapeconnections do 
		pcall(v.Disconnect, v)
	end
end)

local run = function(Function)
	return RenderFunctions:IsolateFunction(Function)
end

local newcolor = function()
	return setmetatable({Hue = 0, Sat = 0, Value = 0}, {__newindex = function() end})
end

local isAlive = function(plr, nohealth) 
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

local GetTarget = function(distance, healthmethod, raycast, npc, team)
	local magnitude, target = (distance or healthmethod and 0 or math.huge), {}
	for i,v in next, players:GetPlayers() do 
		if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
			if not RenderFunctions.whitelist:get(2) then 
				continue
			end
			if not ({vapewhitelist:GetWhitelist(v)})[2] then
				continue
			end
			if not entitylib.isPlayerTargetable(v) then 
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

local GetEnumItems = function(enum)
	local fonts = {}
	for i,v in next, Enum[enum]:GetEnumItems() do 
		table.insert(fonts, v.Name) 
	end
	return fonts
end

local GetAllTargets = function(distance, sort)
	local targets = {}
	for i,v in next, players:GetPlayers() do 
		if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
			if not RenderFunctions.whitelist:get(2) then 
				continue
			end
			if not ({vapewhitelist:GetWhitelist(v)})[2] then 
				continue
			end
			if not entitylib.isPlayerTargetable(v) then 
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

local dumptable = function(tab, tabtype, sortfunction)
	local data = {}
	for i,v in next, tab do
		local tabtype = (tabtype and tabtype == 1 and i or v)
		table.insert(data, tabtype)
	end
	if sortfunction then
		table.sort(data, sortfunction)
	end
	return data
end

local gethighestblock = function(position, smart, raycast, customvector)
	if not position then 
		return nil 
	end
	if raycast and not workspace:Raycast(position, Vector3.new(0, -2000, 0), RenderStore.raycast) then
		return nil
	end
	local lastblock
	for i = 1, 500 do 
		local newray = workspace:Raycast(lastblock and lastblock.Position or position, customvector or Vector3.new(0.55, 9e9, 0.55), RenderStore.raycast)
		local smartest = newray and smart and workspace:Raycast(lastblock and lastblock.Position or position, Vector3.new(0, 5.5, 0), RenderStore.raycast) or not smart
		if newray and smartest then
			lastblock = newray
		else
			break
		end
	end
	return lastblock
end

local isEnabled = function(module)
	return GuiLibrary.ObjectsThatCanBeSaved[module] and GuiLibrary.ObjectsThatCanBeSaved[module].Api.Enabled and true or false
end

local dumptable = function(tab, tabtype, sortfunction)
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

local getlowestblock = function(position, smart, raycast, customvector)
	if not position then 
		return nil 
	end
	if raycast and not workspace:Raycast(position, Vector3.new(0, -2000, 0), RenderStore.raycast) then
		return nil
	end
	local lastblock
	for i = 1, 500 do 
		local newray = workspace:Raycast(lastblock and lastblock.Position or position, customvector or Vector3.new(0.55, -9e9, 0.55), RenderStore.raycast)
		local smartest = newray and smart and workspace:Raycast(lastblock and lastblock.Position or position, Vector3.new(0, 5.5, 0), RenderStore.raycast) or not smart
		if newray and smartest then
			lastblock = newray
		else
			break
		end
	end
	return lastblock
end

GuiLibrary.RemoveObject('PlayerTPOptionsButton')
GuiLibrary.RemoveObject('AutoRewindOptionsButton')
GuiLibrary.RemoveObject('ClientKickDisablerOptionsButton')

local knit = require(repliactedstorage:WaitForChild('Packages'):WaitForChild('Knit'))
local store = {
	blocks = collection:GetTagged('Blocks'),
	toolservice = knit.GetService('ToolService'),
	settings = knit.GetService('SettingsService'),
	viewmodel = knit.GetController('ViewmodelController'),
	blocks = collection:GetTagged('Blocks')
}

store.attackEntity = function(self, ...)
	return store.toolservice.AttackPlayerWithSword(store.toolservice, ...)
end

local oldattack = store.toolservice.AttackPlayerWithSword
store.toolservice.AttackPlayerWithSword = function(self, character, ...)
	local success, player = pcall(players.GetPlayerFromCharacter, players, character)
	if success and not RenderFunctions.whitelist:get(2, player) then 
		return 
	end
	return oldattack(self, character, ...)
end

table.insert(vapeconnections, {Disconnect = function(self) store.toolservice.AttackPlayerWithSword = oldattack end})
table.insert(vapeconnections, collection:GetInstanceAddedSignal('Block'):Connect(function(block)
	table.insert(store.blocks, block)
	RenderStore.raycast.FilterDescendantsInstances = {store.blocks}
end))

table.insert(vapeconnections, workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
	if workspace.CurrentCamera then 
		camera = workspace.CurrentCamera
	end
end))

RenderStore.raycast.FilterDescendantsInstances = {store.blocks}

run(function()
	local KillauraRange = {Value = 22}
	local KillauraCooldown = {Value = 10}
	local KillauraNoSwing = {}
	local KillauraAutoBlock = {}
	local oldtarget
	local animationdelay = tick()
	local KillauraSortMethod = {Value = 'Health'}
	local KillauraSort = {
		Distance = function(a, b)
			local newmag = (a.RootPart.Position - RenderStore.LocalPosition).Magnitude
			local oldmag = (a.RootPart.Position - b.RootPart.Position).Magnitude
			return (newmag < oldmag)
		end,
		Health = function(a, b)
			return (b.Humanoid.Health > a.Humanoid.Health)
		end,
		Switch = false
	}
	Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = 'Killaura',
		HoverText = 'Automatically attack nearby targets.',
		Function = function(calling)
			if calling then 
				table.insert(Killaura.Connections, runservice.Heartbeat:Connect(function()
					local targets = GetAllTargets(KillauraRange.Value, KillauraSort[KillauraSortMethod.Value])
					if #targets == 0 then 
						RenderStore.UpdateTargetUI()
						vapetarget.Targets.Killaura = nil
						if oldtarget then 
							lplr:SetAttribute('Blocking', false)
							store.toolservice:ToggleBlockSword(false, 'Sword')
							store.viewmodel:ToggleLoopedAnimation('Sword', false)
							oldtarget = nil
						end
					end
					for i,v in next, targets do 
						RenderStore.UpdateTargetUI(v)
						oldtarget = true
						vapetarget.Targets.Killaura = v
						if KillauraAutoBlock.Enabled then 
							lplr:SetAttribute('Blocking', false)
							if not KillauraNoSwing.Enabled then 
								store.toolservice:ToggleBlockSword(true, 'Sword')
							end
						end
						store:attackEntity(v.Player.Character, true, 'Sword')
						if KillauraSortMethod.Value ~= 'Switch' then 
							break
						end
					end
				end))
				repeat 
					if tick() > animationdelay and oldtarget and not KillauraNoSwing.Enabled then 
						store.viewmodel:PlayAnimation('Sword')
						animationdelay = (tick() + (KillauraCooldown.Value / 10))
						continue
					end
					task.wait()
				until (not Killaura.Enabled)
			end
		end
	})
	KillauraRange = Killaura.CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 20,
		Default = 20,
		Function = function() end
	})
	KillauraCooldown = Killaura.CreateSlider({
		Name = 'Animation Delay',
		Min = 1,
		Max = 100,
		Default = 3,
		Function = function() end
	})
	KillauraSortMethod = Killaura.CreateDropdown({
		Name = 'Sort',
		List = dumptable(KillauraSort, 1),
		Function = function() end
	})
	KillauraNoSwing = Killaura.CreateToggle({
		Name = 'No Animation',
		HoverText = 'No client side viewmodel animation',
		Function = function() end
	})
	KillauraAutoBlock = Killaura.CreateToggle({
		Name = 'Block',
		Default = true,
		HoverText = 'Automatically blocks attacks',
		Function = function() end
	})
end)

run(function()
	local AntiVoid = {}
	local AntiVoidMode = {Value = 'Bounce'}
	local AntiVoidMaterial = {Value = 'Plastic'}
	local AntiVoidDown = {Value = 16.5}
	local AntiVoidColor = newcolor()
	local antivoidpart
	local antivoidmethods = {
		Bounce = function()
			lplr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 80, 0)
		end,
		Collide = function() end
	}
	local noclipmethods = {}
	AntiVoid = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = 'AntiVoid',
		HoverText = 'walk on the void real',
		Function = function(calling)
			if calling then 
				repeat task.wait() until isAlive(lplr, true)
				if not AntiVoid.Enabled then 
					return 
				end
				antivoidpart = Instance.new('Part', workspace)
				antivoidpart.Size = Vector3.new(3000, 1, 3000)
				antivoidpart.Color = Color3.fromHSV(AntiVoidColor.Hue, AntiVoidColor.Sat, AntiVoidColor.Value)
				antivoidpart.Material = Enum.Material[AntiVoidMaterial.Value]
				antivoidpart.Anchored = true 
				antivoidpart.CanCollide = (table.find(noclipmethods, AntiVoidMode.Value) == nil)
				table.insert(AntiVoid.Connections, runservice.Heartbeat:Connect(function()
					if workspace:Raycast(RenderStore.LocalPosition, Vector3.new(0, -10, 0), RenderStore.raycast) then 
						local lowest = getlowestblock(RenderStore.LocalPosition)
						if lowest then
							antivoidpart.Position = (lowest.Position - Vector3.new(0, AntiVoidDown.Value, 0))
						end
					end
				end))
				table.insert(AntiVoid.Connections, antivoidpart.Touched:Connect(function(instance)
					if isEnabled('Fly') then 
						return 
					end
					if isAlive(lplr, true) and instance == lplr.Character.HumanoidRootPart and isnetworkowner(lplr.Character.HumanoidRootPart) then 
						if workspace:Raycast(RenderStore.LocalPosition, Vector3.new(0, -100, 0), RenderStore.raycast) == nil then 
							antivoidmethods[AntiVoidMode.Value]()
						end
					end
				end))
			else
				pcall(function() antivoidpart:Destroy() end)
			end
		end
	})
	AntiVoidMode = AntiVoid.CreateDropdown({
		Name = 'Method',
		List = dumptable(antivoidmethods, 1),
		Function = function() end
	})
	AntiVoidMaterial = AntiVoid.CreateDropdown({
		Name = 'Material',
		List = GetEnumItems('Material'),
		Function = function() 
			pcall(function() antivoidpart.Material = Enum.Material[AntiVoidMaterial.Value] end)
		end
	})
	AntiVoidDown = AntiVoid.CreateSlider({
		Name = 'Y Level',
		Min = 5, 
		Max = 26,
		Default = AntiVoidDown.Value,
		Function = function() 
			if AntiVoid.Enabled and workspace:Raycast(RenderStore.LocalPosition, Vector3.new(0, -10, 0), RenderStore.raycast) then 
				local lowest = getlowestblock(RenderStore.LocalPosition)
				if lowest then
					pcall(function() antivoidpart.Position = (lowest.Position - Vector3.new(0, AntiVoidDown.Value, 0)) end)
				end
			end
		end
	})
	AntiVoidColor = AntiVoid.CreateColorSlider({
		Name = 'Color',
		Function = function()
			pcall(function() antivoidpart.Color = Color3.fromHSV(AntiVoidColor.Hue, AntiVoidColor.Sat, AntiVoidColor.Value) end)
		end
	})
end)