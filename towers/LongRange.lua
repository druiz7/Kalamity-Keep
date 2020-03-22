local Tower = require("towers.Tower")

local LongRange = Tower:new()

function LongRange:new(o)
   o = o or Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

function LongRange:attack()
    local function shotHandler (event)
        if (event.phase == "began") then
            event.target:removeSelf();
            event.target = nil;
            if event.other.tag == "enemy" then
                event.other:hit(self.damage)
            end
        end
    end

    local p = display.newRect (obj.shape.x + (x * 20), obj.shape.y+50,10,10);
    p:setFillColor(1,0,0);
    p.anchorY=0;
    physics.addBody (p, "dynamic", {filter=CF.enemyBullet});
    p:applyForce(x, 1, p.x, p.y);
    
    p:addEventListener("collision", shotHandler);
end