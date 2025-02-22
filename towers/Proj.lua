local Proj = {}

function Proj:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Proj:spawn()
    self.shape = display.newRect(self.displayGroup, self.posX, self.posY, 20, 20)
    self.shape:setFillColor(unpack(self.color))
    physics.addBody(self.shape, "dynamic", {isSensor = true})
    self:chase()

    self.shape:addEventListener("collision", self)
    Runtime:addEventListener("clearGame", self)
    Runtime:addEventListener("pauseGame", self)
    Runtime:addEventListener("resumeGame", self)
end

function Proj:chase()
    self.shape.tid = timer.performWithDelay(100, function (e) 
        if not (self.enemy and not self.enemy.removed and pcall(function () self:chaseIt() end)) then
            if (self.shape) then
                pcall(function()
                    timer.cancel(self.shape.tid)
                    self.shape:removeSelf()
                    self.shape = nil
                end)
            end
        end
    end, -1)
end

function Proj:chaseIt()
    if (self.shape.moving == true) then
        transition.cancel(self.shape)
    end

    self.shape.moving = true
    local V = 0.9 -- V = D / T → T = D / V
    local t = math.sqrt((self.enemy.x - self.shape.x) ^ 2 + (self.enemy.y - self.shape.y) ^ 2) / V

    transition.to(self.shape, {time = t, x = self.enemy.x, y = self.enemy.y})
end

function Proj:collision(event)
    if (event.phase == "began") then
        if event.other == self.enemy or event.other.tag == "enemy" then
            event.other.pp:hit(self.damage)
            self:clearGame()
        end
    end
end

function Proj:clearGame()
    if (self.shape) then    
        self.shape:removeSelf()
        self.shape = nil
    end
    Runtime:removeEventListener("clearGame", self)
    Runtime:removeEventListener("pauseGame", self)
    Runtime:removeEventListener("resumeGame", self)
end

function Proj:pauseGame()
    if (self.shape) then
        if (self.shape.moving == true) then
            transition.cancel(self.shape)
        end
        timer.pause(self.shape.tid)
    end
end

function Proj:resumeGame()
    if (self.shape) then
        timer.resume(self.shape.tid)
    end
    end

return Proj
