local Tower = {tag="tower", spaceWidth=120, spaceHeight=95, enemies={}, cooldown=false, posX=display.contentCenterX, posY=display.contentCenterY};

function Tower:new(o)
    o = o or {}
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function Tower:getEnemy()
    local enemy = enemies[math.random(#enemies)]
    return enemy
end

function Tower:onFrame()
    if cooldown then return end
    
    cooldown = true
    self:attack()
    timer.performWithDelay(self.cooldownTime, function()
        cooldown = false 
    end)
end

return Tower