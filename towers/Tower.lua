local Tower = {tag="tower", spaceWidth=120, spaceHeight=95, enemies={}, cooldown=false, posX=display.contentCenterX, posY=display.contentCenterY, range = 1};

function Tower:new(o)
    o = o or {}
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function Tower:spawn()
    self.shape = display.newCircle(self.posX, self.posY, 15)
    self.shape:setFillColor(unpack(self.selfColor));

    self.shape.pp = self
    self.shape.tag = self.tag

    self:createRange()
    Runtime:addEventListener("enterFrame", self)
    self.shape:toFront()
end

function Tower:createRange()
    local rangeWidth = self.spaceWidth + self.spaceWidth * self.range * 2
    local rangeHeight = self.spaceHeight + self.spaceHeight * self.range * 2
    self.rangeSensor = display.newRect(self.posX, self.posY, rangeWidth, rangeHeight)    
    physics.addBody(self.rangeSensor, "dynamic")
    self.rangeSensor.isSensor = true
    self.rangeSensor.isSleepingAllowed = false
    self.rangeSensor.isVisible = false;


    self.rangeSensor:addEventListener("collision", function(event)
        if(event.other.id ~= "enemy") then return end

        local enemyTriggered = event.other;
        if (event.phase == "began") then
            print("i see you")
            -- add enemy to enemies list
            local inTable = false
            for _, enemy in pairs(self.enemies) do
                if enemy == enemyTriggered then
                    inTable = true
                    break
                end
            end

            if(not inTable) then
                table.insert(self.enemies, enemyTriggered)
            end
        elseif(event.phase == "ended") then
            print("where did you go?")
            -- remove enemy from enemies list
            for i, enemy in pairs(self.enemies) do
                if(enemy == enemyTriggered) then
                    self.enemies[i] = nil
                end
            end
        end
    end)
end

function Tower:getEnemy()

    local enemy
    if(#self.enemies > 0) then 
        enemy = self.enemies[math.random(#self.enemies)]
    end

    return enemy
end

function Tower:enterFrame()
    if self.cooldown then return end
    
    self.cooldown = true
    self:attack()
    timer.performWithDelay(self.cooldownTime, function()
        self.cooldown = false 
    end)
end

return Tower