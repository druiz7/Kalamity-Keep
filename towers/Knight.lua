local ShortRange = require("towers.ShortRange")

local Knight = ShortRange:new({sheetName="knight_blue", damage=3, cooldownTime=1000})

function Knight:new(o)
   o = ShortRange:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

return Knight