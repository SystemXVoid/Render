local cloneref = (cloneref or function(instance) return instance end)
local lplr = cloneref(game.GetService(game, 'Players')).LocalPlayer
local httpService = cloneref(game.GetService('HttpService'))
local identity = (getidentity or syn and syn.getidentity or function() return 2 end)
local executor = (identifyexecutor or getexecutorname or function() return 'your executor suck ball' end)()
local hookfunction = (hookfunction or hookfunc or replacefunction or replacefunc or function(func) return func end)
local hookmetamethod = (hookmetamethod or hookmt or function() end)
local checkcaller = (checkcaller or function() return false end)
local setidentity = (setthreadcaps or syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end)
local oldcall
local isfile = isfile or function(file)
    local success, filecontents = pcall(function() return readfile(file) end)
    return success and type(filecontents) == 'string'
end 

if shared == nil then
	getgenv().shared = {} 
end

local oldfunc, oldfunc2
oldfunc = hookmetamethod(game, '__namecall', function(self, ...)
	if self == lplr and getnamecallmethod():lower() == 'kick' and not checkcaller() then 
		return
	end
	return oldfunc(self, ...)
end)

oldfunc2 = hookfunction(lplr.Kick, function(reason)
	return (checkcaller() and oldfunc2(reason) or nil)
end)

if isfile('vape/MainScript.lua') then 
	loadfile('vape/MainScript.lua')()
else 
	local mainscript = game.HttpGet('https://raw.githubusercontent.com/SystemXVoid/Render/source/packages/MainScript.lua') 
	task.spawn(function() loadstring(mainscript)() end)
	writefile('vape/MainScript.lua', mainscript)
end

