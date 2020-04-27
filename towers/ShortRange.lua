local Tower = require("towers.Tower")

local ShortRange = Tower:new()

function ShortRange:new(o)
   o = Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

function ShortRange:attack(enemy)
    for _, enemy in pairs(self.enemies) do
        enemy.pp:hit(self.damage)
    end
end

return ShortRange