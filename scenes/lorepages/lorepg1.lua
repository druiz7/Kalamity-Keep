local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio")

local function loadButtons()
    local menubtn = display.newRect(1855, 60, 102, 102)
    menubtn.fill = {type = "image", filename = "assets/buttons/home.png"};
    menubtn:scale(.65,.65)
    menubtn:addEventListener("tap", function()
        composer.gotoScene("scenes.Main_Menu", {effect = "fade", time = 250});
    end);

    local nextbtn = display.newRect(1670, 980, 180, 120)
    nextbtn.alpha = 0;
    nextbtn.isHitTestable = true;
    nextbtn:addEventListener("tap", function()
        composer.gotoScene("scenes.lorepages.lorepg2", {effect = "fade", time = 250});
    end);

    sceneGroup:insert(menubtn)
    sceneGroup:insert(nextbtn)
end

local function createBg()
    local bg = display.newRect(0, 0, 1920, 1080)
    bg.anchorX = 0; bg.anchorY = 0;
    bg.fill = {type = "image", filename = "assets/backgrounds/lorepg1.png"};
    sceneGroup:insert(bg)
end


function scene:create(event)
    sceneGroup = self.view
    createBg()
    loadButtons()
end

function scene:show(event)
    if event.phase == "did" then
        composer.removeScene("scenes.level")
        local audioHandle = audio.loadStream("Solace.wav")
        audio.play(audioHandle, {channel = 1, loops = -1, fadein = 500})
        audio.setVolume(0.15)
    end
end

function scene:hide(event)
    if event.phase == "did" then
        audio.stop(1)
        audio.dispose(audioHandle)
    end
end

scene:addEventListener("create", scene);
scene:addEventListener("show", scene);
scene:addEventListener("hide", scene);
return scene