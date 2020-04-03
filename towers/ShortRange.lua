local Tower = require("towers.Tower")

local ShortRange = Tower:new()

function ShortRange:new(o)
   o = Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

function ShortRange:attack(enemy)
    enemy.pp:hit(self.damage)
end

return ShortRange