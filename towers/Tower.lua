local chars = require("chars.Chars")
local Tower = {tag="tower", spaceWidth=120, spaceHeight=95, enemies=nil, 
cooldown=false, posX=display.contentCenterX, posY=display.contentCenterY, 
scaleFactor = 6, range = 1};

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
    self.shape:toFront()

    Runtime:addEventListener("enterFrame", self)
    Runtime:addEventListener("clearGame", self)
    Runtime:addEventListener("pauseGame", self)
    Runtime:addEventListener("resumeGame", self)
end

function Tower:spawnSprite()
    local opt, seqData = chars.getFrames(self.sheetName)
    local sheet = graphics.newImageSheet("./chars/all.png", opt)
    
    self.sprite = display.newSprite(sheet, seqData)
    self.sprite.x = self.posX
    self.sprite.y = self.posY

    self.sprite.xScale = self.scaleFactor;
    self.sprite.yScale = self.scaleFactor;

    self.sprite.curSeq = "idle"
    self.sprite:setSequence("idle")
    self.sprite:play()
end

-- returns true if possible, false otherwise
function Tower:move(x,y)
    local currX = self.posX
    local currY = self.posY

    spaceSize = math.floor((self.spaceHeight + self.spaceWidth) / 2)
    local cost = math.floor(math.sqrt((x-currX)^2 + (y-currY)^2)) / spaceSize
    if(self.stamina < cost) then
       return false
    end
    
    self.stamina = self.stamina - cost

    self.sprite.x = x
    self.sprite.y = y

    self.rangeSensor.x = x
    self.rangeSensor.y = y

    return true
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
            print("adding enemy to list")
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
            print("removing enemy from list")
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
    -- updates the list of enemies to make sure they are all alive
    for index, enemy in pairs(self.enemies) do 
        if enemy and enemy.pp and (enemy.pp.HP < 1) then
            self.enemies[index] = nil
        end
    end

    -- now gets an enemy and attacks it if possible
    local enemy = self:getEnemy()
    if self.cooldown or not enemy then
        -- sets the sprite to play the animation if it hasnt been and if the tower isnt cooling down
        if not self.cooldown and self.sprite.curSeq ~= "idle" then 
            self.sprite.curSeq = "idle"
            self.sprite:setSequence("idle")
            self.sprite:play()
        end
    else
        -- rotates the tower if the enemy is infront or behind
        if enemy.shape.x < self.posX then self.sprite.xScale = -1 * self.scaleFactor
        else self.sprite.xScale = self.scaleFactor end

        -- sets the sprite to play the animation if it hasnt been
        if self.sprite.curSeq ~= "attack" then 
            self.sprite.curSeq = "attack"
            self.sprite:setSequence("attack")
            self.sprite:play()
        end

        self.cooldown = true
        self:attack(enemy)
        timer.performWithDelay(self.cooldownTime, function()
            self.cooldown = false 
        end)
    end
end

function Tower:clearGame()
    Runtime:removeEventListener("enterFrame", self)
    Runtime:removeEventListener("clearGame", self)
    self.shape:removeSelf()
    self.rangeSensor:removeSelf()
    
    if(self.projs) then
        for _, proj in pairs(self.projs) do
            proj:removeSelf()
        end
    end
end

function Tower:pauseGame()
    self.enemies = {}
    physics.removeBody(self.rangeSensor)

    if self.sprite.curSeq ~= "idle" then 
        self.sprite.curSeq = "idle"
        self.sprite:setSequence("idle")
        self.sprite:play()
    end

    if(self.projs) then
        for _, proj in pairs(self.projs) do
            --proj:pause()
        end
    end
end

function Tower:resumeGame()
    physics.addBody(self.rangeSensor, "dynamic")
    self.rangeSensor.isSensor = true
    self.rangeSensor.isSleepingAllowed = false

    if(self.projs) then
        for _, proj in pairs(self.projs) do
            --proj:resume()
        end
    end
end

return Tower