-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

local widget = require("widget")
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

local zone
local logArr

local gold
local goldTxt

local unitType = ""
local function zoneHandler(event)
    local zone = event.target
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

    if (logArr[clickPosX][clickPosY] ~= 0) then return end

    -- clicked space is available
    if (unitType == "Wizard") then
        local wizard = Wizard:new({posX = _x, posY = _y})
        wizard:spawn()
        logArr[clickPosX][clickPosY] = 1
        unitType = ""
        zone:removeEventListener("tap", zoneHandler)
    elseif (unitType == "Knight") then
        local knight = Knight:new({posX = _x, posY = _y})
        knight:spawn()
        logArr[clickPosX][clickPosY] = 1
        unitType = ""
        zone:removeEventListener("tap", zoneHandler)
    elseif (unitType == "Archer") then
        local archer = Archer:new({posX = _x, posY = _y})
        archer:spawn()
        logArr[clickPosX][clickPosY] = 1
        unitType = ""
        zone:removeEventListener("tap", zoneHandler)
    end
end

local function createBg()
    -- sets up fill
    display.setDefault("textureWrapX", "repeat")
    display.setDefault("textureWrapY", "mirroredRepeat")

    --Creates a background
    local bg = display.newRect(display.contentCenterX, display.contentCenterY, 1920, 1080)
    bg.fill = {type = "image", filename = "chars/tiles/stone.png"}
    bg.fill.scaleX = 256 / bg.width
    bg.fill.scaleY = 256 / bg.height
    sceneGroup:insert(bg)

    --Creates the playable area
    zone = display.newRect(10, 170, 1560, 900)
    zone.anchorX = 0
    zone.anchorY = 0
    zone.strokeWidth = 4
    zone:setStrokeColor(0, 0, 0)
    zone.fill = {type = "image", filename = "chars/tiles/grass.png"}
    zone.fill.scaleX = 256 / zone.width
    zone.fill.scaleY = 256 / zone.height
    physics.addBody(zone, "static")
    zone.isSensor = true
    sceneGroup:insert(zone)

    local Grid = display.newGroup()
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

    Grid:insert(vGridlines)
    Grid:insert(hGridlines)
    sceneGroup:insert(Grid)

    --Creates the castle
    local castle = display.newRect(1440, 770, 130, 300)
    castle.anchorX = 0
    castle.anchorY = 0
    castle.fill = {type = "image", filename = "chars/tiles/wood.png"}
    castle.fill.scaleX = 256 / castle.width
    castle.fill.scaleY = 256 / castle.height
    castle:setStrokeColor(0, 0, 0)
    castle.strokeWidth = 4
    sceneGroup:insert(castle)
    castle:toFront()

    --Creates the path
    local verticies = {-780,-150, -650,-150, -650,-450, -260,-450, -260,-250, -130,-250, -130,250, 0,250,
        0,350, 130,350, 130,-350, 780,-350, 780,50, 520,50, 520,250, 650,250,
        650,350, 390,350, 390,-50, 650,-50, 650,-250, 260,-250, 260,450, -130,450, 
        -130,350, -260,350, -260,-150, -390,-150, -390,-350, -520,-350, -520,-50, -780,-50}
    local path = display.newPolygon(790, 620, verticies);
    path.fill = {type="image", filename="chars/tiles/dirt.png"}
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
        if unitType ~= "" then return end

        local tower = event.target.id
        local towerCost = towerAtr[tower].cost
        if (gold >= towerCost) then
            gold = gold - towerCost
            goldTxt.text = "Gold: " .. gold
            unitType = tower

            zone:addEventListener("tap", zoneHandler)
        end
    end

    local wizBtn =
        widget.newButton(
        {
            id = "Wizard",
            x = 1740,
            y = 320,
            width = 340,
            height = 300,
            defaultFile = "chars/buttons/default.png",
            overFile = "chars/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Wizard: 150g",
            onRelease = handleButtonEvent
        }
    )

    local kniBtn =
        widget.newButton(
        {
            id = "Knight",
            x = 1740,
            y = 620,
            width = 340,
            height = 300,
            defaultFile = "chars/buttons/default.png",
            overFile = "chars/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Knight: 50g",
            onRelease = handleButtonEvent
        }
    )

    local arcBtn =
        widget.newButton(
        {
            id = "Archer",
            x = 1740,
            y = 920,
            width = 340,
            height = 300,
            defaultFile = "chars/buttons/default.png",
            overFile = "chars/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Archer: 100g",
            onRelease = handleButtonEvent
        }
    )

    sceneGroup:insert(wizBtn)
    sceneGroup:insert(kniBtn)
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

local function setUpLogArray()
    --Creates a 2D array used for logic within the game
    logArr = {}
    for L = 1, 12 do
        logArr[L] = {}
        for H = 1, 9 do
            logArr[L][H] = 0
        end
    end

    for i = 7, 9 do
        logArr[12][i] = 2
    end

    --Sets the path in the logical array
    logArr[1][4] = -1
    for i = 4, 1, -1 do
        logArr[2][i] = -1
    end
    for i = 2, 4 do
        logArr[i][1] = -1
    end
    for i = 1, 3 do
        logArr[4][i] = -1
    end
    for i = 3, 8 do
        logArr[5][i] = -1
    end
    logArr[6][8] = -1
    for i = 6, 8 do
        logArr[i][9] = -1
    end
    for i = 9, 2, -1 do
        logArr[8][i] = -1
    end
    for i = 8, 12 do
        logArr[i][2] = -1
    end
    for i = 2, 5 do
        logArr[12][i] = -1
    end
    for i = 12, 10, -1 do
        logArr[i][5] = -1
    end
    for i = 5, 8 do
        logArr[10][i] = -1
    end
    logArr[11][8] = -1
end

function scene:create(event)
    sceneGroup = self.view

    createBg()
    createTowerBtns()
    createMenuBtns()
    setUpLogArray()

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
