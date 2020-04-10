-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

local widget = require("widget")
local json = require("json")
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

--physics.setDrawMode("hybrid")

local Archer = require("towers.Archer")
local Wizard = require("towers.Wizard")
local Knight = require("towers.Knight")

local composer = require("composer")
local barbarian = require("enemies.barbarian")
local lizard = require("enemies.lizard")
local troll = require("enemies.troll")

local scene = composer.newScene()
local sceneGroup

local game

local zone

local gold
local goldTxt

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
        logArr[clickPosX][clickPosY] = 1
        game.towerType = ""
        zone:removeEventListener("tap", zoneHandler)
    elseif (game.towerType == "Knight") then
        local knight = Knight:new({posX = _x, posY = _y})
        knight:spawn()
        logArr[clickPosX][clickPosY] = 1
        game.towerType = ""
        zone:removeEventListener("tap", zoneHandler)
    elseif (game.towerType == "Archer") then
        local archer = Archer:new({posX = _x, posY = _y})
        archer:spawn()
        logArr[clickPosX][clickPosY] = 1
        game.towerType = ""
        zone:removeEventListener("tap", zoneHandler)
    end

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
    physics.addBody(zone, "static")
    zone.isSensor = true
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
    local castle = display.newRect(game.castle.x, game.castle.y,
        game.castle.width, game.castle.height)
        
    castle.anchorX = 0
    castle.anchorY = 0
    castle.fill = {type = "image", filename = "assets/tiles/wood.png"}
    castle.fill.scaleX = 256 / castle.width
    castle.fill.scaleY = 256 / castle.height
    castle:setStrokeColor(0, 0, 0)
    castle.strokeWidth = 4
    sceneGroup:insert(castle)
    castle:toFront()

    --Creates the path
    local verticies = game.path.verticies
    local path = display.newPolygon(game.path.x, game.path.y, verticies);
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
    local towerAtr = {
        Wizard = {cost = 150},
        Knight = {cost = 50},
        Archer = {cost = 100}
    }

    local function handleButtonEvent(event)
        if game.towerType ~= "" then return end

        local tower = event.target.id
        local towerCost = towerAtr[tower].cost
        if (gold >= towerCost) then
            gold = gold - towerCost
            goldTxt.text = "Gold: " .. gold
            game.towerType = tower

            zone:addEventListener("tap", zoneHandler)
            zone.grid.isVisible = true
        end
    end

    local wizBtn =
        widget.newButton(
        {
            id = "Wizard",
            x = 1750,
            y = 320,
            width = 320,
            height = 290,
            defaultFile = "assets/buttons/default.png",
            overFile = "assets/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Wizard: 150g",
            onRelease = handleButtonEvent
        }
    )
    sceneGroup:insert(wizBtn)

    local kniBtn =
        widget.newButton(
        {
            id = "Knight",
            x = 1750,
            y = 620,
            width = 320,
            height = 290,
            defaultFile = "assets/buttons/default.png",
            overFile = "assets/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Knight: 50g",
            onRelease = handleButtonEvent
        }
    )
    sceneGroup:insert(kniBtn)

    local arcBtn =
        widget.newButton(
        {
            id = "Archer",
            x = 1750,
            y = 920,
            width = 320,
            height = 290,
            defaultFile = "assets/buttons/default.png",
            overFile = "assets/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Archer: 100g",
            onRelease = handleButtonEvent
        }
    )
    sceneGroup:insert(arcBtn)
end

local function createMenuBtns()
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

local function getLevelData(level)
    local path = system.pathForFile("./assets/level-data.json")
    local file = io.open( path, "r" );
    local data = file:read( "*a" ); --everything
    io.close( file );
    file = nil;

    local dataRead = json.decode(data)

    game = dataRead[level]
    game.towerType = ""

    print(json.encode(game))
end

function scene:create(event)
    sceneGroup = self.view

    getLevelData(event.params.level)
    createBg()
    createTowerBtns()
    createMenuBtns()

    --Creates the gold count
    gold = 500
    goldTxt = display.newText("Gold: " .. gold, 60, 60)
    sceneGroup:insert(goldTxt)
    goldTxt.anchorX = 0
    goldTxt.anchorY = 0
    goldTxt:setFillColor(0, 0, 0)
end

scene:addEventListener("create", scene)

return scene
