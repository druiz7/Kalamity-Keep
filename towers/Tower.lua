local chars = require("chars.Chars")
local Tower = {tag="tower", spaceWidth=120, spaceHeight=95, enemies=nil, cooldown=false, posX=display.contentCenterX, posY=display.contentCenterY, range = 1};

function Tower:new(o)
    o = o or {}
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function Tower:spawn()
    self:spawnSprite()

    self.shape = self.sprite
    self.shape.pp = self
    self.shape.tag = self.tag

    self:createRange()
    Runtime:addEventListener("enterFrame", self)
    self.shape:toFront()
end

function Tower:spawnSprite()
    local opt, seqData = chars.getFrames(self.sheetName)
    local sheet = graphics.newImageSheet("./chars/all.png", opt)
    
    self.sprite = display.newSprite(sheet, seqData)
    self.sprite.x = self.posX
    self.sprite.y = self.posY

    self.sprite.xScale = 5;
    self.sprite.yScale = 5;

    self.sprite:setSequence("idle")
    self.sprite:play()
end

function Tower:createRange()
    local rangeWidth = self.spaceWidth + self.spaceWidth * self.range * 2
    local rangeHeight = self.spaceHeight + self.spaceHeight * self.range * 2
    self.rangeSensor = display.newRect(self.posX, self.posY, rangeWidth, rangeHeight)    
    physics.addBody(self.rangeSensor, "dynamic")
    self.rangeSensor.isSensor = true
    self.rangeSensor.isSleepingAllowed = false
    self.rangeSensor.isVisible = false;

    self.enemies = {}
    self.rangeSensor:addEventListener("collision", function(event)
        if(event.other.tag ~= "enemy") then return end

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
    for index, enemy in pairs(self.enemies) do 
        if enemy and enemy.pp and (enemy.pp.HP < 1) then
            self.enemies[index] = nil
        end
    end

    if not self.cooldown then
        self.cooldown = true
        self:attack()
        timer.performWithDelay(self.cooldownTime, function()
            self.cooldown = false 
        end)
    end
end

function Tower:removeTowers()
    Runtime:removeEventListener("enterFrame", self)

end

return Tower