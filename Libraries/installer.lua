return (function(ria) 
	local tweenService = game:GetService('TweenService')
	local httpService = game:GetService('HttpService')
	local maingui = Instance.new('ScreenGui') 
	local arceus = ((identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or 'Unknown') == 'Arceus X')
    local httprequest = (http and http.request or http_request or fluxus and fluxus.request or request or function() end)
	local initiate
	local isfile = isfile or function(file)
		local success, filecontents = pcall(function() return readfile(file) end)
		return success and type(filecontents) == 'string'
	end 
    ria = base64_decode(ria)
	local parent = pcall(function() 
		maingui.Parent = (gethui and gethui() or game:GetService('CoreGui')) 
	end)
	
	if not parent then 
		maingui.Parent = game:GetService('Players').LocalPlayer.PlayerGui 
	end
	
	maingui.IgnoreGuiInset = true
	local mainframe = Instance.new('Frame')
	mainframe.Position = UDim2.new(0.287, 0, 0.409, 0)
	mainframe.Size = UDim2.new(0, 539, 0, 236)
	mainframe.Parent = maingui
	mainframe.ZIndex = 1
	
	local mainrounding = Instance.new('UICorner')
	mainrounding.CornerRadius = UDim.new(0, 9)
	mainrounding.Parent = mainframe 
	
	local maingradient = Instance.new('UIGradient')
	maingradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 3, 42)), ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 7, 75))})
	maingradient.Parent = mainframe 
	
	local topbar = Instance.new('Frame')
	topbar.Size = UDim2.new(0, 539, 0, 34)
	topbar.ZIndex = 3
	topbar.Parent = mainframe 
	
	local topbargradient = Instance.new('UIGradient')
	topbargradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 152)), ColorSequenceKeypoint.new(1, Color3.fromRGB(42, 13, 147))})
	topbargradient.Parent = topbar
	
	local topbarRounding = Instance.new('UICorner') 
	topbarRounding.CornerRadius = UDim.new(0, 5)
	topbarRounding.Parent = topbar
	
	local installbutton = Instance.new('TextButton')
	installbutton.Text = 'Install'
	installbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
	installbutton.BackgroundColor3 = Color3.fromRGB(12, 9, 94)
	installbutton.TextSize = 16
	installbutton.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Light)
	installbutton.Position = UDim2.new(0.314, 0, 0.75, 0)
	installbutton.Size = UDim2.new(0, 200, 0, 41)
	installbutton.AutoButtonColor = false
	installbutton.ZIndex = 3
	installbutton.Parent = mainframe
	
	local installbuttonrounding = Instance.new('UICorner')
	installbuttonrounding.Parent = installbutton
	
	local rendericon = Instance.new('ImageLabel')
	rendericon.Image = 'rbxassetid://15688086520'
	rendericon.BackgroundTransparency = 1
	rendericon.Position = UDim2.new(0.722, 0, 0.237, 0)
	rendericon.Size = UDim2.new(0, 118, 0, 113)
	rendericon.Parent = mainframe
	
	local maintitle = Instance.new('TextLabel')
	maintitle.Text = 'Render Installer'
	maintitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	maintitle.Position = UDim2.new(0.2, 0, 0.078, 0)
	maintitle.TextSize = 17 
	maintitle.ZIndex = 3
	maintitle.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Light) 
	maintitle.Parent = mainframe
	
	local closebutton = Instance.new('ImageButton')
	closebutton.Name = 'Close Button'
	closebutton.Image = ''
	closebutton.Position = UDim2.new(0.024, 0, 0.038, 0)
	closebutton.BackgroundColor3 = Color3.fromRGB(143, 0, 0)
	closebutton.Size = UDim2.new(0, 22, 0, 18)
	closebutton.AutoButtonColor = false
	closebutton.ZIndex = 3
	closebutton.Parent = mainframe
	
	local closerounding = Instance.new('UICorner')
	closerounding.CornerRadius = UDim.new(0, 5)
	closerounding.Parent = closebutton
	
	closebutton.MouseEnter:Connect(function()
		tweenService:Create(closebutton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(189, 0, 0)}):Play() 
	end)
	
	closebutton.MouseLeave:Connect(function()
		tweenService:Create(closebutton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(143, 0, 0)}):Play() 
	end)
	
	closebutton.MouseButton1Click:Connect(function()
		maingui:Destroy()
	end)
	
	local buttons = {}
	local function createoption(args)
		local data = {Enabled = false} 
		local recent 
		if #buttons > 0 then 
			recent = buttons[#buttons]
		end
		local newpos = (recent == nil and UDim2.new(0.035, 0, 0.242, 0) or recent.Position + UDim2.new(0, 0, 0.22, 0))
		local togglebutton = Instance.new('TextButton')
		togglebutton.Name = (args.Name..'Button')
		togglebutton.Text = ''
		togglebutton.Position = newpos
		togglebutton.Size = UDim2.new(0, 31, 0, 31)
		togglebutton.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
		togglebutton.AutoButtonColor = false
		togglebutton.ZIndex = 3
		togglebutton.Parent = mainframe
		local togglerounding = Instance.new('UICorner')
		togglerounding.CornerRadius = UDim.new(0, 5)
		togglerounding.Parent = togglebutton
		local buttontext = Instance.new('TextLabel')
		buttontext.Name = 'Title'
		buttontext.Text = args.Name 
		buttontext.TextSize = 16 
		buttontext.Font = Enum.Font.Gotham
		buttontext.ZIndex = 3
		buttontext.Position = (buttontext.Position + UDim2.new(#args.Name / 5, 0, 0.5, 0))
		buttontext.BackgroundTransparency = 1
		buttontext.TextColor3 = Color3.fromRGB(255, 255, 255)
		buttontext.Parent = togglebutton
		table.insert(buttons, togglebutton)
		data.ToggleOption = function(calling)
			task.spawn(args.Function or function() end, calling)
			if calling then 
				data.Enabled = true
				tweenService:Create(togglebutton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(29, 0, 86)}):Play() 
			else 
				data.Enabled = false
				tweenService:Create(togglebutton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(39, 39, 39)}):Play() 
			end
		end
		togglebutton.MouseButton1Click:Connect(function() 
			data.ToggleOption(not data.Enabled)
		end)
		if args.Default then 
			data.ToggleOption(true)
		end
		return data
	end
	
	local profiles = {}
	profiles = createoption({
		Name = 'Install Profiles', 
		Default = isfile('ria.json') == false,
		Function = function(calling) 
			profiles.Enabled = calling 
		end
	})
	
	local taskfunctions = {}
	local progressbk = Instance.new('Frame')
	progressbk.Name = 'ProgressBackground'
	progressbk.Size = UDim2.new(1, 0, 1, 0)
	progressbk.BackgroundColor3 = Color3.new()
	progressbk.BackgroundTransparency = 0.1
	progressbk.ZIndex = 4
	progressbk.Parent = maingui
	progressbk.Visible = false
	
	local progressbar = Instance.new('Frame')
	progressbar.Name = 'Progress Bar'
	progressbar.AnchorPoint = Vector2.new(1, 1)
	progressbar.BackgroundColor3 = Color3.new()
	progressbar.Size = UDim2.new(0, 700, 0, 45)
	progressbar.Position = UDim2.new(0.84, 50, 0.65, 0)
	progressbar.ZIndex = 5
	progressbar.Visible = false
	progressbar.Parent = maingui
	
	local progessrounding = Instance.new('UICorner')
	progessrounding.CornerRadius = UDim.new(1, 9)
	progessrounding.Parent = progressbar
	
	local progressbar2 = progressbar:Clone()
	progressbar2.Name = 'Main Bar'
	progressbar2.AnchorPoint = Vector2.new(0, 0, 0, 0)
	progressbar2.ZIndex = 5
	progressbar2.Size = UDim2.new(0.3, 490, 0, 45)
	progressbar2.Position = UDim2.new(0.2, -140, 0, 0)
	progressbar2.BackgroundColor3 = Color3.fromRGB(42, 6, 103)
	progressbar2.Parent = progressbar
	
	local progesshighlight = Instance.new('UIStroke')
	progesshighlight.Color = Color3.fromRGB(255, 255, 255)
	progesshighlight.Thickness = 2 
	progesshighlight.Parent = progressbar
	
	local rendericon2 = Instance.new('ImageLabel')
	rendericon2.Image = 'rbxassetid://15688086520'
	rendericon2.BackgroundTransparency = 1
	rendericon2.AnchorPoint = Vector2.new(1, 1)
	rendericon2.Position = UDim2.new(0.575, 80, 0.569, 0)
	rendericon2.Size = UDim2.new(0, 309, 0, 285)
	rendericon2.ZIndex = 5
	rendericon2.Parent = progressbk
	
	local progresstext = Instance.new('TextLabel')
	progresstext.Text = ''
	progresstext.TextColor3 = Color3.fromRGB(255, 255, 255)
	progresstext.BackgroundTransparency = 1 
	progresstext.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Light)  
	progresstext.TextSize = 25 
	progresstext.ZIndex = 5
	progresstext.Position = UDim2.new(0.494, 0, 0.7, 0)
	progresstext.Parent = progressbk
	
	local abortbutton = installbutton:Clone() -- lazy moment
	abortbutton.Name = 'Abort Button'
	abortbutton.Text = 'Abort'
	abortbutton.BackgroundColor3 = Color3.fromRGB(135, 0, 0)
	abortbutton.AnchorPoint = Vector2.new(1, 1)
	abortbutton.Position = UDim2.new(0.550, 50, 0.8, 10) 
	abortbutton.ZIndex = 5
	abortbutton.Parent = progressbk 
	
	local function abortinstallation(stay)
		if stay then 
			mainframe.Visible = true
			progressbar.Visible = false
			progressbk.Visible = false
			progressbar2.Visible = false
			progressbar2.Size = UDim2.new(0, 0, 0, 0)
			progresstext.Text = ''
		else
			maingui:Destroy()
		end
	end
	
	local disconnectfunc = function() abortinstallation(true) end
	local aborted
	installbutton.MouseButton1Click:Connect(function()
		mainframe.Visible = false
		progressbar.Visible = true
		progressbk.Visible = true
		progressbar2.Visible = true
		initiate = true
		local tasknum = #taskfunctions
		local failures = 0
		pcall(function() abortbutton.Text = 'Abort' end) 
		task.wait(0.1)
		for i,v in next, taskfunctions do 
			pcall(function() progresstext.Text = v.Text end)
			pcall(function() progresstext.TextColor3 = Color3.fromRGB(255, 255, 255) end)
			local succeeded, res = pcall(v.Function)  
			if aborted then 
				aborted = false
				return 
			end
			if not succeeded then 
				failures = (failures + 1)
				pcall(function() tweenService:Create(progressbar2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(138, 0, 0)}):Play() end)
				pcall(function() progresstext.Text = (v.Text..' (FAILED)') end)
				pcall(function() progresstext.TextColor3 = Color3.fromRGB(255, 0, 0) end)
				task.delay(2, function()
					pcall(function() tweenService:Create(progressbar2, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(42, 6, 103)}):Play() end)
				end)
			end
			local offset = (tasknum <= 0 and 490 or 490 / tasknum)
			pcall(function() tweenService:Create(progressbar2, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, offset, 0, 45)}):Play() end)
			tasknum = (tasknum - 1)
		end 
		local color = (failures < #taskfunctions and failures > 0 and Color3.fromRGB(255, 255, 34) or failures >= #taskfunctions and failures > 0 and Color3.fromRGB(255, 0, 4) or Color3.fromRGB(43, 255, 10))
		if failures < #taskfunctions and failures > 0 then 
			pcall(function() progresstext.Text = 'Installation Partially Complete' end)
		end
		if failures >= #taskfunctions and failures > 0 then 
			pcall(function() progresstext.Text = 'Installation Failed' end)
		end
		if failures == 0 then 
			pcall(function() progresstext.Text = 'Installation Successful' end)
		end
		pcall(function() progresstext.TextColor3 = color end)
		pcall(function() abortbutton.Text = 'Close' end)
		local oldDisconnect = disconnectfunc
		disconnectfunc = function()
			abortinstallation()
			disconnectfunc = oldDisconnect
		end
	end)
	
	abortbutton.MouseButton1Click:Connect(function()
		if progressbk.Visible then 
			aborted = true
		end
		disconnectfunc()
	end)
	
	repeat task.wait() until initiate
	
	if type(shared.GuiLibrary) == 'table' then
		pcall(shared.GuiLibrary.SelfDestruct or function() end)
	end
	
	for i,v in next, ({'vape', 'vape/assets', 'vape/Profiles', 'vape/Libraries', 'vape/CustomModules'}) do 
		if not isfolder(v) then 
			makefolder(v) 
		end 
	end
	
	for i,v in next, ({'vape/Render', 'vape/Render/Libraries'}) do 
		if not isfolder(v) then 
			makefolder(v) 
		end 
	end
	
	local core = {'Universal.lua', 'MainScript.lua', 'NewMainScript.lua', 'GuiLibrary.lua'}
	for i,v in next, listfiles('vape/CustomModules') do 
		if isfile(v) then 
			delfile(v) 
		end 
	end

	for i,v in next, core do 
		if isfile('vape/'..v) then 
			delfile('vape/'..v)
		end 
	end
	
	table.insert(taskfunctions, {
		Text = 'Validating RIA key...',
		Function = function()
			local requested, userdata = pcall(function() return httpService:JSONDecode(httprequest({Url = 'https://api.renderintents.xyz/ria', Headers = {RIA = ria}}).Body) end)
			if requested then 
				if type(userdata) ~= 'table' or userdata.disabled then 
					pcall(function() progresstext.Text = 'The current RIA key is invalid/revoked. Try generating a new installer script from the discord.' end)
					pcall(function() progresstext.TextColor3 = Color3.fromRGB(255, 0, 4) end)
					while task.wait() do end
				end 
			else
				pcall(function() progresstext.Text = 'Failed to validate RIA from the api. Maybe try again later.' end)
				pcall(function() progresstext.TextColor3 = Color3.fromRGB(255, 0, 4) end)
				while task.wait() do end
			end
		end
	})
	
	local customs = {}
	local customsLoaded
	for i,v in next, core do 
		table.insert(taskfunctions, {
			Text = 'Writing vape/'..v,
			Function = function()
				local contents = httprequest({Url = 'https://raw.githubusercontent.com/SystemXVoid/Render/source/packages/'..v}).Body
				writefile('vape/'..v, contents)
			end
		}) 
	end
	
	table.insert(taskfunctions, {
		Text = 'Fetching CustomModules',
		Function = function()
			local customsTab = httpService:JSONDecode(httprequest({Url = 'https://raw.githubusercontent.com/SystemXVoid/Render/source/Libraries/games.json'}).Body) -- arceus :vomit:
			for i,v in next, customsTab do 
				local number = tonumber(v) 
				if number then 
					table.insert(customs, v..'.lua')
				end
			end
			customsLoaded = true
			task.wait(0.5)
		end
	}) 
	
	repeat task.wait() until customsLoaded 
	
	for i,v in next, customs do 
		table.insert(taskfunctions, {
			Text = 'Writing vape/CustomModules/'..v,
			Function = function()
				local contents = httprequest({Url = 'https://raw.githubusercontent.com/SystemXVoid/Render/source/packages/'..v}).Body
				writefile('vape/CustomModules/'..v, contents)
			end
		})
	end
	
	if profiles.Enabled then 
		local profiledata = {}
		local profilesLoaded
		table.insert(taskfunctions, {
			Text = 'Fetching Profiles',
			Function = function()
				local profiletab = httpService:JSONDecode(httprequest({Url = 'https://api.github.com/repos/SystemXVoid/Render/contents/Libraries/'..(arceus and 'arceusxmoment' or 'Profiles')}).Body) -- arceus :vomit:
				for i,v in next, profiletab do 
					assert(v.name, 'no name found lol')
					table.insert(profiledata, v.name) 
				end
				profilesLoaded = true
				task.wait(0.5)
			end
		}) 
		
		repeat task.wait() until profilesLoaded 
	
		local profiles = {}
		for i,v in next, profiledata do 
			table.insert(taskfunctions, {
				Text = 'Writing vape/Profiles/'..v,
				Function = function()
					local contents = httprequest({Url = 'https://raw.githubusercontent.com/SystemXVoid/Render/source/Libraries/'..(arceus and 'arceusxmoment' or 'Profiles')..'/'..v}).Body
					if v:find('vapeprofiles') and isfile('vape/Profiles/'..v) then 
						local onlinedata = httpService:JSONDecode(contents)
						local localdata = httpService:JSONDecode(readfile('vape/Profiles/'..v))
						local default = true
						for i2, v2 in next, onlinedata do 
							if localdata[i2] == nil or v2.Selected then 
								if not default then 
									default = (v2.Selected ~= true) 
								end
								localdata[i2] = {Selected = v2.Selected or localdata[i2].Selected, Keybind = v2.Keybind == '' and localdata[i2].Keybind or v2.Keybind}
							end
						end
						localdata.default = (localdata.default or {Selected = default, Keybind = ''})
						localdata.default.Selected = default
						writefile('vape/Profiles/'..v, httpService:JSONEncode(localdata)) 
					else 
						writefile('vape/Profiles/'..v, contents) 
					end
				end
			})
		end
	end

	writefile('ria.json', httpService:JSONEncode({Key = ria, Client = game:GetService('RbxAnalyticsService'):GetClientId()}))
	
	local assetsloaded 
	local assets = {}
	table.insert(taskfunctions, {
		Text = 'Fetching Assets',
		Function = function()
			local assetTab = httpService:JSONDecode(httprequest({Url = 'https://api.github.com/repos/7GrandDadPGN/VapeV4ForRoblox/contents/assets'}).Body)
			for i,v in next, assetTab do 
				assert(v.name, 'no name found lol')
				table.insert(assets, v.name) 
			end
			assetsloaded = true
			task.wait(0.5)
		end
	}) 
	
	repeat task.wait() until assetsloaded 
	
	for i,v in next, assets do 
		if not isfile('vape/assets/'..v) then 
			table.insert(taskfunctions, {
				Text = 'Writing vape/assets/'..v,
				Function = function()
					local contents = game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/assets/'..v)
					writefile('vape/assets/'..v, contents) 
				end
			}) 
		end
	end
	
	table.insert(taskfunctions, {
		Text = 'Writing vape/commithash.txt',
		Function = function()
			writefile('vape/commithash.txt', 'main')
			task.wait(0.2)
		end
	}) 
end)
