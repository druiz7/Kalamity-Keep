local LongRange = require("towers.LongRange")

local Archer = LongRange:new({damage=3, cooldownTime=500, projColor={235/255, 155/255, 52/255}, selfColor = {61/255, 235/255, 52/255}})

function Archer:new(o)
   o = LongRange:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

return Archer