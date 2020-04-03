local Tower = require("towers.Tower")

local LongRange = Tower:new()

function LongRange:new(o)
   o = Tower:new(o)
   setmetatable(o, self)
   self.__index = self
   return o
end

function LongRange:attack(enemy)
    self.projs = self.projs or {}

    -- sets up projectile to follow and hit enemy
    local p = display.newRect (self.shape.x, self.shape.y,50,50)
    p:setFillColor(unpack(self.projColor))
    physics.addBody (p, "dynamic", {isSensor=true})
    table.insert(self.projs, p)

    p:addEventListener("collision", function(event)
        if (event.phase == "began") then
            if event.other == enemy then
                event.other.pp:hit(self.damage)
                event.target:removeSelf();
                event.target = nil;

                -- removes itself from the list of projs
                for i, proj in pairs(self.projs) do
                    if proj == p then
                        self.projs[i] = nil
                    end
                end
            end
        end
    end)

    local function chaseIt (hunter, prey)
        if (hunter.moving == true) then
            transition.cancel(hunter);
        end
    
        hunter.moving = true;
        local V = 0.5 -- V = D / T → T = D / V
        local t = math.sqrt ((prey.shape.x - hunter.x)^2 + (prey.shape.y - hunter.y)^2 ) / V;
    
        transition.to(hunter, {time=t,x=prey.shape.x, y=prey.shape.y});
    end

    p.tid = timer.performWithDelay(100, function (e)
        if not (enemy and pcall(function () chaseIt(p, enemy) end)) then
            if(not p) then 
                timer.cancel(p.tid) 
                p:removeSelf()
                p = nil
            end
        end
    end, -1);
end

return LongRange