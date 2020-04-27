local LongRange = require("towers.LongRange")

local Archer =
  LongRange:new(
  {sheetName = "basic_bow", damage = 1, cooldownTime = 500, projColor = {235 / 255, 155 / 255, 52 / 255}, stamina = 1, range=2}
)

function Archer:new(o)
  o = LongRange:new(o)
  setmetatable(o, self)
  self.__index = self
  return o
end

return Archer
