local chars = require("assets.Chars")
local Tower = {
    tag = "tower",
    spaceWidth = 120,
    spaceHeight = 95,
    enemies = nil,
    cooldown = false,
    posX = display.contentCenterX,
    posY = display.contentCenterY,
    scaleFactor = 6,
    range = 1,
    displayGroup = display.newGroup()
}

function Tower:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Tower:spawn()
    self:spawnSprite()

    self.shape = self.sprite
    self.shape.pp = self
    self.shape.tag = self.tag

    self:createRange()

    Runtime:addEventListener("enterFrame", self)
    Runtime:addEventListener("clearGame", self)
    Runtime:addEventListener("pauseGame", self)
    Runtime:addEventListener("resumeGame", self)
end

function Tower:spawnSprite()
    local opt, seqData = chars.getFrames(self.sheetName)
    local sheet = graphics.newImageSheet("./assets/all.png", opt)

    self.sprite = display.newSprite(self.displayGroup, sheet, seqData)
    self.sprite.x = self.posX
    self.sprite.y = self.posY

    self.sprite.xScale = self.scaleFactor
    self.sprite.yScale = self.scaleFactor

    self:setSequence("idle")
end

-- returns true if possible, false otherwise
function Tower:move(x, y)
    local currX = self.posX
    local currY = self.posY

    local spaceSize = math.floor((self.spaceHeight + self.spaceWidth) / 2)
    local cost = math.floor(math.sqrt((x - currX) ^ 2 + (y - currY) ^ 2)) / spaceSize
    if (self.stamina < cost) then
        return false
    end

    self.stamina = self.stamina - cost

    self.sprite.x = x
    self.sprite.y = y

    self.rangeSensor.x = x
    self.rangeSensor.y = y

    return true
end

function Tower:setSequence(name)
    if (name == "pause" or name == "resume") then
        if (name == "pause") then
            self.sprite.paused = true
            self.sprite:pause()
        else
            self.sprite.paused = false
            self.sprite:play()
        end
    elseif (not self.sprite.paused and self.sprite.curSeq ~= name) then
        self.sprite.curSeq = name
        self.sprite:setSequence(name)
        self.sprite:play()
    end
end

function Tower:createRange()
    local rangeWidth = self.spaceWidth + self.spaceWidth * self.range * 2
    local rangeHeight = self.spaceHeight + self.spaceHeight * self.range * 2
    self.rangeSensor = display.newRect(self.posX, self.posY, rangeWidth, rangeHeight)
    physics.addBody(self.rangeSensor, "dynamic")
    self.rangeSensor.isSensor = true
    self.rangeSensor.isSleepingAllowed = false
    self.rangeSensor.isVisible = false

    self.enemies = {}
    self.rangeSensor:addEventListener("collision", function(event)
        if (event.other.tag ~= "enemy") then
            return
        end

        local enemyTriggered = event.other
        if (event.phase == "began") then
            -- add enemy to enemies list
            table.insert(self.enemies, enemyTriggered)
        elseif (event.phase == "ended") then
            -- remove enemy from enemies list
            for i, enemy in pairs(self.enemies) do
                if (enemy == enemyTriggered) then
                    table.remove(self.enemies, i)
                end
            end
        end
    end)
end

function Tower:getEnemy()
    if #self.enemies == 0 then return nil end

    -- gets enemy with furthest dist
    local currTime = os.clock()
    local enemy, larDist
    for _, e in pairs(self.enemies) do
        local eDist = (currTime - e.spwnTime) * e.pp.speed
        if(not enemy or eDist > larDist) then
            enemy = e
            larDist = eDist
        end
    end

    return enemy
end

function Tower:updateEnemies()
    -- updates the list of enemies to make sure they are all alive
    for index, enemy in pairs(self.enemies) do
        if enemy and ((enemy.pp.HP < 1) or enemy.removed) then
            self.enemies[index] = nil
        end
    end
end

function Tower:attackEnemy()
    if self.sprite.paused then
        return
    end

    -- now gets an enemy and attacks it if possible
    local targ = self:getEnemy()
    if not targ then
        self:setSequence("idle")
    else
        -- rotates the tower if the enemy is infront or behind
        if targ.x < self.posX then
            self.sprite.xScale = -1 * self.scaleFactor
        else
            self.sprite.xScale = self.scaleFactor
        end

        if not self.cooldown then
            self:setSequence("attack")
            self.cooldown = true
            self:attack(targ)

            self.cooldownTimer = timer.performWithDelay(self.cooldownTime, function()
                self.cooldownTimer = nil
                self.cooldown = false
            end)
        end
    end
end

function Tower:shoudRunThisFrame()
    local numFrames = 15
    self.frame = ((self.frame or 1) + 1) % 60

    return (self.frame % numFrames == 0)
end

function Tower:enterFrame(event)
    if (not self:shoudRunThisFrame()) then
        return
    end

    self:updateEnemies()
    self:attackEnemy()
end

function Tower:clearGame()
    Runtime:removeEventListener("enterFrame", self)
    Runtime:removeEventListener("clearGame", self)
    Runtime:removeEventListener("pauseGame", self)
    Runtime:removeEventListener("resumeGame", self)
    self.shape:removeSelf()
    self.rangeSensor:removeSelf()
end

function Tower:pauseGame()
    self:setSequence("pause")
    if self.cooldownTimer then
        timer.pause(self.cooldownTimer)
    end
end

function Tower:resumeGame()
    self:setSequence("resume")
    if self.cooldownTimer then
        timer.resume(self.cooldownTimer)
    end
end

return Tower
