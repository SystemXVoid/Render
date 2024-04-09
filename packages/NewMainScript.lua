local httpService = game:GetService('HttpService')
local identity = (getidentity or syn and syn.getidentity or function() return 2 end)
local executor = (identifyexecutor or getexecutorname or function() return 'your executor suck ball' end)()
local setidentity = (setthreadcaps or syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end)
local oldcall
local isfile = isfile or function(file)
    local success, filecontents = pcall(function() return readfile(file) end)
    return success and type(filecontents) == 'string'
end 

if shared == nil then
	getgenv().shared = {} 
end

if executor == 'Wave' then 
    loadstring(game.HttpGet(game, 'https://raw.githubusercontent.com/MuhXd/Roblox-mobile-script/main/FileFixes.lua'))() -- credits to MuhXd for making such a wonderful fix for detected executor!!!!
end

if isfile('vape/MainScript.lua') then 
	loadfile('vape/MainScript.lua')()
else 
	local mainscript = game.HttpGet('https://raw.githubusercontent.com/SystemXVoid/Render/source/packages/MainScript.lua') 
	task.spawn(function() loadstring(mainscript)() end)
	writefile('vape/MainScript.lua', mainscript)
end

