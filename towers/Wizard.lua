local LongRange = require("towers.LongRange")

local Wizard = LongRange:new({sheetName="wizard",damage=5, cooldownTime=1500, projColor = {50/255, 74/255, 168/255}, range=2, stamina=2})

function Wizard:new(o)
   o = LongRange:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

return Wizard