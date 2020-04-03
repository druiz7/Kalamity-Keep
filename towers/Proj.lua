local Proj = {}

function Proj:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
 end
 
 function Proj:spawn()
    self.shape = display.newRect (self.posX, self.posY,50,50)
    self.shape:setFillColor(unpack(self.color))
    physics.addBody (self.shape, "dynamic", {isSensor=true})

    self.shape:addEventListener("collision", self)

    self.shape.tid = timer.performWithDelay(100, function (e) 
        if not (self.enemy and pcall(function () chaseIt() end)) then
            if(not self.shape) then 
                timer.cancel(self.shape.tid) 
                self.shape:removeSelf()
                self.shape = nil
            end
        end
    end)
 end

function Proj:chaseIt()
    if (self.shape.moving == true) then
        transition.cancel(self.shape);
    end

    self.shape.moving = true;
    local V = 0.5 -- V = D / T → T = D / V
    local t = math.sqrt ((self.enemy.shape.x - self.shape.x)^2 + (self.enemy.shape.y - self.shape.y)^2 ) / V;

    transition.to(self.shape, {time=t,x=self.enemy.shape.x, y=self.enemy.shape.y});
end

function Proj:collision(event)
    if (event.phase == "began") then
        if event.other == self.enemy then
            event.other.pp:hit(self.damage)
            event.target:removeSelf();
            event.target = nil;
        end
    end
end

 return Proj