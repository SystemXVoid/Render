local lplr = game:GetService('Players').LocalPlayer
local queueonteleport = (queue_on_teleport or syn and syn.queue_on_teleport or function() end)
local vapesettings = (vapeconfig or {})
local httpService = game:GetService('HttpService')
local function getonlinefile(url) 
    if url:find('vape/Profiles/') then 
        if vapesettings[url] then 
            return httpService:JSONDecode(vapesettings[url])
        end
        local success, profile = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/SystemXVoid/Render/source/Libraries/Settings/{url:gsub('vape/Profiles/', '')}`)
        if success and profile ~= '404: Not Found' then 
            vapesettings[url] = httpService:JSONDecode(profile)
            return profile
        end
    end
    if url:find('vape/CustomModules/') then 
        local success, custom = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/SystemXVoid/Render/source/packages/{url:gsub('vape/CustomModules/', '')}`)
        if success and custom ~= '404: Not Found' then 
            return custom
        end
        success, custom = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/{url:gsub('vape/CustomModules/', '')}`)
        if success and custom ~= '404: Not Found' then 
            return custom
        end
    end
    if url:find('vape/Libraries/') then
        local success, file = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/Libraries/{url:gsub('vape/Libraries/', '')}`)
         if success and file ~= '404: Not Found' then 
             return file
         end
     end 
    if url:find('vape/Render/Libraries/') then 
        local success, lib = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/SystemXVoid/Render/source/Libraries/{url:gsub('vape/Render/Libraries/', '')}`)
        if success and lib ~= '404: Not Found' then 
            return lib
        end
    end
    if url:find('vape/') and url:find('vape/assets/') == nil then
       local success, file = pcall(game.HttpGet, game, `https://raw.githubusercontent.com/SystemXVoid/Render/source/packages/{url:gsub('vape/', '')}`)
        if success and file ~= '404: Not Found' then 
            return file
        end
    end 
end

getgenv().getcustomasset = nil
getgenv().getsynasset = nil
getgenv().vapeconfig = vapesettings

getgenv().isfile = function(file)
    return (file:find('vape/') ~= nil)
end

getgenv().writefile = function(file, contents) 
    if file:find('vape/Profiles/') then 
        vapesettings[file] = httpService:JSONDecode(contents)
    end
end 

getgenv().listfiles = function()
    return {}
end

getgenv().readfile = function(file)
    return (getonlinefile(file) or '[]')
end

getgenv().loadfile = function(file)
    return loadstring(readfile(file))
end

lplr.OnTeleport:Connect(function()
    if shared.VapeExecuted then 
        local teleportscript = `local vapesettings = [[{httpService:JSONEncode(vapesettings)}]]`
        teleportscript = `{teleportscript} getgenv().vapeconfig = game:GetService('HttpService'):JSONDecode(vapesettings)`
    end
end)
