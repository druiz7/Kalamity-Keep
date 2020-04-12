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

local Archer = require("towers.Archer")
local Wizard = require("towers.Wizard")
local Knight = require("towers.Knight")

local barbarian = require("enemies.barbarian")
local lizard = require("enemies.lizard")
local troll = require("enemies.troll")

local game
local zone

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

    --print(clickPosX);
    --print(clickPosY);

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
        --SHUJI IMPLEMENT THIS
        print("+++++++++++++++++++++++++++++++++")
        if(event.other.tag == 'enemy') then
            print("hit")
            print("what am I looking at????: ")
            apple = event.other.tag
            print(apple)
            --> game:updateHealth(-event.other.enemy.damage)
            game:updateHealth(-10) -- whatever health that is
        end
    end)

    sceneGroup:insert(castle)
    castle:toFront()

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
    sceneGroup:insert(components.createGold(game))
    sceneGroup:insert(components.createHealth(game))

    -- button uses an event to clear the game
    local clearGame = display.newRect(1920 - 100, 100, 150, 100)
    clearGame:addEventListener("tap", function()
            Runtime:dispatchEvent({name = "clearGame"})
        end
    )
    sceneGroup:insert(clearGame)
    local cg_text = display.newText("Clear", 1920 - 100, 100)
    cg_text:setFillColor(1, 0, 0)
    sceneGroup:insert(cg_text)

    -- button pauses the game
    local pg_text = display.newText("Pause", 1920 - 300, 100)
    pg_text:setFillColor(1, 0, 0)
    sceneGroup:insert(pg_text)
    local pauseGame = display.newRect(1920 - 300, 100, 150, 100)
    pauseGame:addEventListener("tap", function()
            if (pg_text.text == "Pause") then
                print("clicks")
                Runtime:dispatchEvent({name = "pauseGame"})
                physics.pause()
                pg_text.text = "Resume"
            else
                Runtime:dispatchEvent({name = "resumeGame"})
                physics.start()
                pg_text.text = "Pause"
            end
        end
    )
    sceneGroup:insert(pauseGame)
    pg_text:toFront()
end

local function setUpGameObj(level)
    local path = system.pathForFile("./assets/level-data.json")
    local file = io.open( path, "r" );
    local data = file:read( "*a" ); --everything
    io.close( file );
    file = nil;

    local dataRead = json.decode(data)

    game = dataRead[level]
    game.towerType = ""
    game.gold = 500
    game.health = 100
    game.towerAtr = {
        Wizard = {cost = 150},
        Knight = {cost = 50},
        Archer = {cost = 100}
    }
end

local function summonBarb(x, y)
    local barb = barbarian:new({xSpawn=x, ySpawn=y})
    barb:spawn()
    --enemyTimer = timer.performWithDelay(10000, barb:move(game.logArr), 0)
 
    barb:move(game.logArr)
end

local function summonLiz(x, y)
    local liz = lizard:new({xSpawn=x, ySpawn=y})
    liz:spawn()
    --enemyTimer = timer.performWithDelay(10000, barb:move(game.logArr), 0)
 
    liz:move(game.logArr)
end

local function summonTroll(x, y)
    local troll = troll:new({xSpawn=x, ySpawn=y})
    troll:spawn()
    --enemyTimer = timer.performWithDelay(10000, barb:move(game.logArr), 0)
 
    troll:move(game.logArr)
end

local function enemyDeath(enemy)
    game:updateGold(enemy.reward)

end

function scene:create(event)
    sceneGroup = self.view

    setUpGameObj(event.params.level)
    createBg()
    createTowerBtns()
    createMenuBtns()
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    end

    if (phase == "did") then
        summonBarb(75, 910)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene
