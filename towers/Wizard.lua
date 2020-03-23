local LongRange = require("towers.LongRange")

local Wizard = LongRange:new({damage=5, coolDownTime=700})

function Wizard:new(o)
   o = Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

return Wizard