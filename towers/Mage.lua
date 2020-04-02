local LongRange = require("towers.LongRange")

local Mage = LongRange:new({damage=3, cooldownTime=500, projColor={235/255, 155/255, 52/255}, selfColor = {61/255, 235/255, 52/255}})

function Mage:new(o)
   o = LongRange:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

return Mage