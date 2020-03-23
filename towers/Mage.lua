local LongRange = require("towers.LongRange")

local Mage = LongRange:new({damage=3, coolDownTime=500})

function Mage:new(o)
   o = Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

return Mage