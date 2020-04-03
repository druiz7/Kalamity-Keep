local Tower = require("towers.Tower")
local Proj = require("towers.Proj")

local LongRange = Tower:new()

function LongRange:new(o)
   o = Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

function LongRange:attack(enemy)
    Proj:new({posX = self.posX, posY = self.posY, color = self.projColor, enemy = enemy, damage=self.damage})
        :spawn()
end

return LongRange