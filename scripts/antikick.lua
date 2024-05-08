local cloneref = (cloneref or function(instance) return instance end)
local hookfunction = (hookfunction or hookfunc or function() end)
local hookmetamethod = (hookmetamethod or hookmt or function() end)
local getnamecallmethod = (getnamecallmethod or function() return '' end)
local checkcaller = (checkcaller or function() return false end)

local lplr = cloneref(game.GetService(game, 'Players')).LocalPlayer

hookfunction(lplr.Kick, function(self) print('no kick') end)
hookfunction(lplr.kick, function(self) print('no kick') end)

local oldfunc
oldfunc = hookmetamethod(game, '__namecall', function(self, ...)
    if self == lplr and getnamecallmethod():lower() == 'kick' and not checkcaller() then 
        return task.wait(9e9)
    end
    return oldfunc(self, ...)
end)