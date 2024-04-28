local httpService = game:GetService('HttpService')
local requestfunctions = {http and http.request, fluxus and fluxus.request, request, syn and syn.request, http_request}
local websocketfunctions = {ws and ws.connect, ws and ws.Connect, Ws and Ws.Connect or Ws.connect or WS and WS.Connect or WS and WS.connect or Websocket and Websocket.Connect or Websocket and Websocket.connect or websocket and websocket.Connect or websocket and websocket.connect}
local hookfunction = (hookfunction or hookfunc or function(...) end)
local hookmetamethod = (hookmetamethod or function(...) end)
local newcclosure = (newcclosure or function(func) return func end)
local clonefunc = (clonefunction or clonefunc or function(func) return func end) 
if (isfunctionhooked or function() end)(clonefunc) and restorefunction then 
	restorefunction(clonefunc)
end 
local checkcaller = clonefunc(checkcaller or function() return true end)
local saferequest = clonefunc(#requestfunctions > 0 and requestfunctions[math.random(1, #requestfunctions)] or function() end)
local tablefind = clonefunc(table.find)
local type = clonefunc(type)
local find = clonefunc(string.find)
local tostring = clonefunc(tostring)
local warn = clonefunc(warn)
local sub = clonefunc(string.sub)
local rawget = clonefunc(rawget or function(tab, index) return tab[index] end)
local whitelist = {'github.com', 'pastebin.com', 'voidwareclient.xyz', 'renderintents.xyz', 'luarmor.net', 'controlc.com', 'raw.githubusercontent.com', 'roblox.com'}
local blacklist = {'httpbin.org', 'ipify.org', 'discord.com/api/webhooks/', 'grabify.org'}
local scriptsettings = (type(getgenv().antiloggersettings) == 'table' and getgenv().antiloggersettings or {HTTPService = true})
local whitelistonly = scriptsettings.whitelistonly

getgenv().antiloggersettings = nil

local function whitelistedurl(url)
	url = tostring(url):lower()
	for i,v in next, whitelist do 
		if find(url, v:lower()) then
			return true
		end
	end 
	for i,v in next, blacklist do 
		if find(url, v) then 
			return
		end
	end
	if not whitelistonly then 
		return true 
	end
end

local function blank(url, str) 
	url = tostring(url):lower()
	local blankstring = '[]'
	warn('AntiLogger - Successfully stopped the client from sending an http request to '..url) 
	if shared.GuiLibrary then 
		pcall(function() shared.GuiLibrary.CreateNotification('AntiLogger', ' Successfully stopped the client from sending an http request. (check console for details)', 15) end)
	end
	if sub(url, 1, 33) == '://discord.com/api/webhooks/' then 
		saferequest({Url = url, Method = 'DELETE'})
	end
	if sub(url, 1, 23) == '://httpbin.org/get' then 
		blankstring = httpService:JSONEncode({args = {}, headers = {}, origin = 'protected', url = url})
	end
	return str and blankstring or {Body = blankstring, StatusCode = 200}
end

local function hookrequestfunc(func)
	local oldrequest = func
	getgenv()[func] = newcclosure(function(self, ...)
		if type(self) == 'table' and rawget(self, 'Url') then 
			if whitelistedurl(rawget(self, 'Url')) == nil then 
				return blank(rawget(self, 'Url'))
			end
		end
		return oldrequest(self, ...)
	end)
end

for i,v in next, requestfunctions do
	for i2, v2 in next, getgenv() do 
		if v2 == v then 
			hookrequestfunc(i2) 
		end
	end
end

local oldmethod
oldmethod = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
	if not scriptsettings.HTTPService then 
		return oldmethod(self, ...) 
	end
	local method = getnamecallmethod()
	if method == 'PostAsync' or method == 'CallAsync' or method == 'GetAsync' or method == 'HttpGetAsync' or method == 'HttpGet' then 
		if checkcaller() and whitelistedurl(self) == nil then
			return blank(self, true)
		end
		if method == 'RequestAsync' and whitelistedurl(rawget(self, 'Url')) == nil then  
			return blank(self)
		end
	end
	return oldmethod(self, ...)
end))

for i,v in next, ({'GetAsync'}) do 
	if not scriptsettings.HTTPService then 
		continue 
	end
	local oldrequest
	oldrequest = hookfunction(httpService[v], newcclosure(function(self, url, ...)
		 if checkcaller() and whitelistedurl(url) == nil then
			return blank(url, true)
		end 
		return oldrequest(self, url, ...)
	end))
end

local oldrequest 
oldrequest = hookfunction(httpService.RequestAsync, newcclosure(function(self, tab, ...)
	if checkcaller() and whitelistedurl(rawget(tab, 'Url')) == nil then 
		return blank(tab, true) 
	end
	return oldrequest(self, tab, ...)
end))

local oldrequest2
oldrequest2 = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
	if whitelistedurl(url) == nil then
		return blank(url, true)
	end 
	return oldreques2(self, url, ...) 
end))

local oldrequest3
oldrequest3 = hookfunction(game.HttpGetAsync, newcclosure(function(self, url, ...)
	if checkcaller() and whitelistedurl(url) == nil then
		return blank(url, true)
	end 
	return oldrequest3(self, url, ...) 
end))

if getgenv().hookfunction == nil and getgenv().hookfunc == nil then 
	print('⚠ AntiLogger - Your exploit doesn\'t support hookfunction. Protection may not be as efficient.')
end

if getgenv().hookmetamethod == nil then 
	print('⚠ AntiLogger - Your exploit doesn\'t support hookmetamethod. Protection may not be as efficient.')
end

if #({getgenv().hookfunction, getgenv().hookfunc, getgenv().hookmetamethod}) == 0 then 
	error('❌ AntiLogger - Failed to execute. Your exploit doesn\'t support hookfunction or hookmetamethod.')
end

local oldishooked
oldishooked = hookfunction(isfunctionhooked or function() end, newcclosure(function(func)
	for i,v in next, requestfunctions do 
		if v == func then 
			return false 
		end
	end
	for i,v in next, ({'PostAsync', 'GetAsync'}) do 
		if v == httpService[v] then 
			return false 
		end
	end
	return oldishooked(func)
end))

hookfunction(restorefunction or function() end, function() end)
print('✅ AntiLogger - Successfully Executed.')
