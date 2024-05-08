local cloneref = (cloneref or function(instance) return instance end)
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