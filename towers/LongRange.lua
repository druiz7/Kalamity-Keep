local Tower = require("towers.Tower")

local LongRange = Tower:new()

function LongRange:new(o)
   o = o or Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

function LongRange:attack()
    local enemy = self:getEnemy();
    if not enemy then return end

    -- sets up projectile to follow and hit enemy
    local p = display.newRect (self.shape.x, self.shape.y,10,10)
    p:setFillColor(unpack(self.projColor))
    physics.addBody (p, "dynamic", {isSensor=true})

    p:addEventListener("collision", function(event)
        if (event.phase == "began") then
            if event.other.tag == "enemy" then
                event.other:hit(self.damage)
                event.target:removeSelf();
                event.target = nil;
            end
        end
    end)

    local function chaseIt (h, p)
        if (h.moving == true) then
            transition.cancel(h.shape);
        end
    
        h.moving = true;
        local V = 0.5 -- V = D / T → T = D / V
        local t = math.sqrt ((p.shape.x - h.shape.x)^2 + (p.shape.y - h.shape.y)^2 ) / V;
    
        transition.to(h.shape, {time=t,x=p.shape.x, y=p.shape.y});
    end

    p.tid = timer.performWithDelay(100, function (e)
        if enemy then
            chaseIt(self, enemy)
        else
            timer.cancel(p.tid) 
            p:removeSelf
            p = nil
        end
    end, -1);
    
end