-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

local json = require("json")
local composer = require("composer")
local scene = composer.newScene()
local sceneGroup
local lore

local components = require("scenes.components")

local Tower = require("towers.Tower")
local Archer = require("towers.Archer")
local Wizard = require("towers.Wizard")
local Knight = require("towers.Knight")

local Enemy = require("enemies.Enemy")
local barbarian = require("enemies.barbarian")
local lizard = require("enemies.lizard")
local troll = require("enemies.troll")

local function setUpLoreObj(page)
    local path = system.pathForFile("./assets/lore-data.json")
    local file = io.open( path, "r" );
    local data = file:read( "*a" ); --everything
    io.close( file );
    file = nil;

    local dataRead = json.decode(data)

    lore = dataRead[page]
    lore.page = page;
end

local function loadButtons()
    local menubtn = display.newRect(1820, 100 , 102, 102)
    local nextbtn = display.newRect(1670, 980, 180, 120)
    local prevbtn = display.newRect(240, 980, 180, 120)
    if lore.page == "lorepg1"  then 
        sceneGroup:insert(nextbtn)
        prevbtn = nil 
    elseif lore.page == "lorepg4" then
        sceneGroup:insert(prevbtn) 
        nextbtn = nil 
    else
        sceneGroup:insert(nextbtn)
        sceneGroup:insert(prevbtn) 
    end
    sceneGroup:insert(menubtn)
end

local function loadSprites()
    local sp1 
    local sp2
    local sp1PosX = 480
    local sp2PosX = 1440
    local spPosY = 800
    if lore.page == "lorepg2"  then
        sp1 = Archer:new({posX = sp1PosX, posY = spPosY})
        sp2 = Knight:new({posX = sp1PosX, posY = spPosY})
    elseif lore.page == "lorepg3"  then
        sp1 = Wizard:new({posX = sp1PosX, posY = spPosY})
        sp2 = lizard:new({posX = sp1PosX, posY = spPosY})
    elseif lore.page == "lorepg4"  then
        sp1 = barbarian:new({posX = sp1PosX, posY = spPosY})
        sp2 = troll:new({posX = sp1PosX, posY = spPosY})
    end
    sceneGroup:insert(sp1)
    sceneGroup:insert(sp2)
end

local function createBg()
    local bg = display.newRect(0, 0, 1920, 1080)
    bg.anchorX = 0; bg.anchorY = 0;
    if lore.page == "lorepg1"  then
        bg.fill = {type = "image", filename = "assets/tiles/backgrounds/lorepg1.png"};
    elseif lore.page == "lorepg2"  then
        bg.fill = {type = "image", filename = "assets/tiles/backgrounds/lorepg2.png"};
    elseif lore.page == "lorepg3"  then
        bg.fill = {type = "image", filename = "assets/tiles/backgrounds/lorepg3.png"};
    elseif lore.page == "lorepg4"  then
        bg.fill = {type = "image", filename = "assets/tiles/backgrounds/lorepg4.png"};
    end
    sceneGroup:insert(bg)
end


function scene:create(event)
    sceneGroup = self.view

    setUpLoreObj(event.params.page)
    createBg()
    loadButtons()
    if lore.page ~= "lorepg1" then
        loadSprites()
    end
end
scene:addEventListener("create", scene);
return scene