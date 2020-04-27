local composer = require("composer")
local scene = composer.newScene()

local function loadButtons()
    local menubtn = display.newRect(1855, 60, 102, 102)
    menubtn.fill = {type = "image", filename = "assets/buttons/home.png"};
    menubtn:scale(.65,.65)
    menubtn:addEventListener("tap", function()
        composer.gotoScene("scenes.Main_Menu", {effect = "fade", time = 250});
    end);

    local prevbtn = display.newRect(240, 980, 180, 120)
    prevbtn.alpha = 0;
    prevbtn.isHitTestable = true;
    prevbtn:addEventListener("tap", function()
        composer.gotoScene("scenes.lorepages.lorepg3", {effect = "fade", time = 250});
    end);

    sceneGroup:insert(menubtn)
    sceneGroup:insert(prevbtn)
end

local function createBg()
    local bg = display.newRect(0, 0, 1920, 1080)
    bg.anchorX = 0; bg.anchorY = 0;
    bg.fill = {type = "image", filename = "assets/backgrounds/lorepg4.png"};
    sceneGroup:insert(bg)
end


function scene:create(event)
    sceneGroup = self.view
    createBg()
    loadButtons()
end

scene:addEventListener("create", scene);
return scene