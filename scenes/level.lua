-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

local json = require("json")
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local composer = require("composer")
local scene = composer.newScene()
local sceneGroup

local components = require("scenes.components")

local Tower = require("towers.Tower")
local Archer = require("towers.Archer")
local Wizard = require("towers.Wizard")
local Knight = require("towers.Knight")

local Enemy = require("enemies.Enemy")
local barbarian = require("enemies.barbarian")
local lizard = require("enemies.lizard")
local troll = require("enemies.troll")

local game
local zone  

--> initialize the wave variables, will hold the timers for each wave
local waveOne
local waveTwo
local waveThree
local timer2, timer3

local enemyCount = 0 --> keep track of the number of enemies that were killed or reached the tower.

local function zoneHandler(event)
    local zone = event.target
    local logArr = game.logArr

    local clickPosX = 0
    local clickPosY = 0
    clickPosX, clickPosY = zone:contentToLocal(event.x, event.y)

    --Converts the click into the indicies for a 2D array
    clickPosX = clickPosX + 780
    clickPosY = clickPosY + 450
    clickPosX = math.ceil(clickPosX / 130)
    clickPosY = math.ceil(clickPosY / 100)

    --Converts the clickPos coordinates back into x,y coordinates
    local _x, _y = zone:localToContent(-715 + 130 * (clickPosX - 1), -400 + 100 * (clickPosY - 1))

    if(logArr[clickPosX][clickPosY] ~= 0) then return end

    -- clicked space is available
    if (game.towerType == "Wizard") then
        local wizard = Wizard:new({posX = _x, posY = _y})
        wizard:spawn()

    elseif (game.towerType == "Knight") then
        local knight = Knight:new({posX = _x, posY = _y})
        knight:spawn()

    elseif (game.towerType == "Archer") then
        local archer = Archer:new({posX = _x, posY = _y})
        archer:spawn()

    end

    local towerCost = game.towerAtr[game.towerType].cost
    game:updateGold(-towerCost)

    logArr[clickPosX][clickPosY] = 1
    game.towerType = ""
    zone:removeEventListener("tap", zoneHandler)
    zone.grid.isVisible = false
end

local function createBg()
    -- sets up fill
    display.setDefault("textureWrapX", "repeat")
    display.setDefault("textureWrapY", "mirroredRepeat")

    --Creates a background
    local bg = display.newRect(display.contentCenterX, display.contentCenterY, 1920, 1080)
    bg.fill = {type = "image", filename = "assets/tiles/stone.png"}
    bg.fill.scaleX = 256 / bg.width
    bg.fill.scaleY = 256 / bg.height
    sceneGroup:insert(bg)

    --Creates the playable area
    zone = display.newRect(10, 170, 1560, 900)
    zone.anchorX = 0
    zone.anchorY = 0
    zone.strokeWidth = 4
    zone:setStrokeColor(0, 0, 0)
    zone.fill = {type = "image", filename = "assets/tiles/grass.png"}
    zone.fill.scaleX = 256 / zone.width
    zone.fill.scaleY = 256 / zone.height
    sceneGroup:insert(zone)

    zone.grid = display.newGroup()
    local vert = 10
    local vGridlines = display.newGroup()
    local horiz = 170
    local hGridlines = display.newGroup()

    for i = 1, 12 do
        local vertGrid = display.newRect(vert, horiz, 130, 900)
        vertGrid:setFillColor(1, 1, 1, 0)
        vertGrid:setStrokeColor(0, 0, 0)
        vertGrid.strokeWidth = 4
        vertGrid.anchorX = 0
        vertGrid.anchorY = 0
        vert = vert + 130
        vGridlines:insert(vertGrid)
    end

    for j = 1, 9 do
        local horizGrid = display.newRect(10, horiz, 1560, 100)
        horizGrid:setFillColor(1, 1, 1, 0)
        horizGrid:setStrokeColor(0, 0, 0)
        horizGrid.strokeWidth = 4
        horizGrid.anchorX = 0
        horizGrid.anchorY = 0
        horiz = horiz + 100
        hGridlines:insert(horizGrid)
    end

    zone.grid:insert(vGridlines)
    zone.grid:insert(hGridlines)
    sceneGroup:insert(zone.grid)
    zone.grid.isVisible = false

    --Creates the castle
    local castle = game.castle
    castle = display.newRect(castle.x, castle.y, castle.width, castle.height)
    castle.anchorX = 0
    castle.anchorY = 0
    castle.fill = {type = "image", filename = "assets/tiles/wood.png"}
    castle.fill.scaleX = 256 / castle.width
    castle.fill.scaleY = 256 / castle.height
    castle:setStrokeColor(0, 0, 0)
    castle.strokeWidth = 4
    physics.addBody(castle, "dynamic", {isSensor = true})
    castle:addEventListener("collision", function(event)
        if event.phase == "began" and event.other.tag == "enemy" then
                game:updateHealth(-event.other.damage)
                enemyCount = enemyCount + 1
                event.other.pp:clearGame()
                Runtime:dispatchEvent({name="checkWin"})
        end
    end)

    sceneGroup:insert(castle)

    --Creates the path
    local path = game.path
    path = display.newPolygon(path.x, path.y, path.verticies);
    path.fill = {type="image", filename="assets/tiles/dirt.png"}
    path.fill.scaleX = 256/ path.width
    path.fill.scaleY = 256/ path.height
    path:setStrokeColor(0,0,0);
    path.strokeWidth = 4;
    sceneGroup:insert(path);

    -- returns fill to default
    display.setDefault("textureWrapX", "clampToEdge")
    display.setDefault("textureWrapY", "clampToEdge")
end

local function createTowerBtns()
    sceneGroup:insert(components.createTowerButtons(game.towerAtr, function (event)
        local tower = event.target.id

        -- if the user reclicked on the same button, cancel the placement operation
        if game.towerType == tower then
            game.towerType = ""
            zone:removeEventListener("tap", zoneHandler)
            zone.grid.isVisible = false
            return
        end

        -- if the user clicked on another tower button, ignore it
        if game.towerType ~= "" then return end

        -- if the user clicked on a tower button to place, perform the placement operation setup
        local towerCost = game.towerAtr[tower].cost
        if (game.gold >= towerCost) then
            game.towerType = tower

            zone:addEventListener("tap", zoneHandler)
            zone.grid.isVisible = true
        end
    end))
end

local function createMenuBtns()
    game.gui_gold = components.createGold(game)
    game.gui_health = components.createHealth(game)
    game.gui_pause = components.createPauseBtn(game)
    sceneGroup:insert(game.gui_gold)
    sceneGroup:insert(game.gui_health)
    sceneGroup:insert(game.gui_pause)
end

local function setUpGameObj(level)
    local path = system.pathForFile("./assets/level-data.json")
    local file = io.open( path, "r" );
    local data = file:read( "*a" ); --everything
    io.close( file );
    file = nil;

    local dataRead = json.decode(data)

    game = dataRead[level]
    game.level = level
    game.towerType = ""
    game.gold = 500
    game.health = 100
    game.towerAtr = {
        Wizard = {cost = 150},
        Knight = {cost = 50},
        Archer = {cost = 100}
    }
end

-- round 1
-- 2 waves of barbarians
local function wave1()
    waveOne = timer.performWithDelay(4000, function() barbarian:unit(game.path.x + game.path.verticies[1] + 65, game.path.y + game.path.verticies[2] + 40, game.logArr) end, 2)
end

-- round 2
-- 2 waves of barbarians
-- wave of speedy lizards
local function wave2()
    wave1()                       
    waveTwo = timer.performWithDelay(12000, function() lizard:unit(game.path.x + game.path.verticies[1] + 65, game.path.y + game.path.verticies[2] + 40, game.logArr) end)
end

-- round 3
-- 2 waves of barbarians
-- wave of speedy lizards
-- spawn trolls
local function wave3()
    wave2()                            
    waveThree = timer.performWithDelay(10000, function() troll:unit(game.path.x + game.path.verticies[1] + 65, game.path.y + game.path.verticies[2] + 40, game.logArr) end)
end

--> the following couple of functions are used to pause/resume the spawning of the units and various other events
local function setUpGameEvents()
    function game:pauseGame(event)
        if (waveOne) then
            timer.pause(waveOne)
        end

        if (waveTwo) then
            timer.pause(waveTwo)
        end

        if (waveThree) then
            timer.pause(waveThree)
        end

        if (timer2) then
            timer.pause(timer2)
        end

        if (timer3) then
            timer.pause(timer3)
        end
    end

    function game:resumeGame(event)
        if (waveOne) then
            timer.resume(waveOne)
        end

        if (waveTwo) then
            timer.resume(waveTwo)
        end

        if (waveThree) then
            timer.resume(waveThree)
        end

        if (timer2) then
            timer.resume(timer2)
        end

        if (timer3) then
            timer.resume(timer3)
        end
    end

    function game:clearGame(event)
        if (waveOne) then
            timer.cancel(waveOne)
        end

        if (waveTwo) then
            timer.cancel(waveTwo)
        end

        if (waveThree) then
            timer.cancel(waveThree)
        end

        if (timer2) then
            timer.cancel(timer2)
        end

        if (timer3) then
            timer.cancel(timer3)
        end
    end

    --> Win Condition
    function game:checkWin(event)
        if (enemyCount >= 43 and game.health > 0) then
            Runtime:dispatchEvent({name = "clearGame"})
            enemyCount = 0;
            composer.gotoScene("scenes.End_Screen", {effect = "fade", time = 250});
        end
    end

    function game:EnemyKilledEvent(event)
        enemyCount = enemyCount + 1 --> count up enemyCount for each enemy killed
        game:updateGold(event.target.reward)
        Runtime:dispatchEvent({name="checkWin"})
    end
end

local function createDragEnemy()
    local enemy = display.newRect(sceneGroup, display.contentCenterX + 300, display.contentCenterY, 150, 150)
    enemy.sprite = enemy
    enemy.tag = "enemy"
    enemy.damage = 150
    enemy:setFillColor(1,1,0)
    physics.addBody(enemy, "dynamic")

    enemy:addEventListener("touch", function(event)
        if event.phase == "began" then
        event.target.markX = event.target.x
        event.target.markY = event.target.y
        elseif event.phase == "moved" then
            local x = (event.x - event.xStart) + event.target.markX
            local y = (event.y - event.yStart) + event.target.markY

            event.target.x = x
            event.target.y = y
        end
    end)

    enemy.spwnTime = os.clock()
    enemy.speed = 1
    enemy.pp = enemy
    enemy.HP = 100
    function enemy:hit(pts)
        self.HP = (self.HP or 1) - pts
        print(self.HP)
    end

    function enemy:clearGame()
        enemy:removeSelf()
    end
end

function scene:resumeGame()
    Runtime:dispatchEvent({name = "resumeGame"})
    physics.start()
end

function scene:create(event)
    sceneGroup = self.view

    setUpGameObj(event.params.level)
    createBg()
    createTowerBtns()
    createMenuBtns()
    setUpGameEvents()

    Tower.displayGroup = display.newGroup()
    Enemy.displayGroup = display.newGroup()
    sceneGroup:insert(Tower.displayGroup)
    sceneGroup:insert(Enemy.displayGroup)

    --createDragEnemy()
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        Runtime:addEventListener("EnemyKilledEvent", game)
        Runtime:addEventListener("checkWin", game)
        Runtime:addEventListener("pauseGame", game)
        Runtime:addEventListener("resumeGame", game)
        Runtime:addEventListener("clearGame", game)
    end

    if (phase == "did") then
        --pull coordinates to start spawn from the level-data.json file

        wave1()
        timer2 = timer.performWithDelay(33000, function() wave2() end)
        timer3 = timer.performWithDelay(67000, function() wave3() end)
    end
end

function scene:destroy(event)
    Runtime:dispatchEvent({name = "clearGame"})
    Runtime:removeEventListener("EnemyKilledEvent", game)
    Runtime:removeEventListener("checkWin", game)
    Runtime:removeEventListener("pauseGame", game)
    Runtime:removeEventListener("resumeGame", game)
    Runtime:removeEventListener("clearGame", game)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("destroy", scene)

return scene
