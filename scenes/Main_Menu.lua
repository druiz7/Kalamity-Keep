local composer = require("composer");
local audio = require("audio")
local scene = composer.newScene()


function scene:create( event )
 
    local sceneGroup = self.view

    local title = display.newText("Kalamity Keep", display.contentCenterX, display.contentCenterY - 365, "assets/AquilineTwo.ttf", 188)
    title:setFillColor(160/256,33/256,36/256)
    title:toFront();

    local background = display.newRect(0, 0, 1920, 1080);
    background.anchorX = 0; background.anchorY = 0;
    background.fill = {type = "image", filename = "assets/backgrounds/Kalamity_Keep_bg.png"};
    background:toBack();

    local lev1 = display.newRect( display.contentCenterX - 500, display.contentCenterY + 80, 380, 100);
    local lev1txt = display.newText("Level 1", display.contentCenterX - 500, display.contentCenterY + 80);
    lev1txt:setFillColor(160/256,33/256,36/256)
    lev1:setFillColor(0,0,0,1);
    lev1:setStrokeColor(160/256,33/256,36/256);
    lev1.strokeWidth = 4;

    local lev2 = display.newRect( display.contentCenterX + 500, display.contentCenterY + 80, 380, 100);
    local lev2txt = display.newText("Level 2", display.contentCenterX + 500, display.contentCenterY + 80);
    lev2txt:setFillColor(160/256,33/256,36/256)
    lev2:setFillColor(0,0,0,1);
    lev2:setStrokeColor(160/256,33/256,36/256);
    lev2.strokeWidth = 4;

    local lore = display.newRect( display.contentCenterX, display.contentCenterY + 80, 380, 100);
    local loretxt = display.newText("Lore", display.contentCenterX, display.contentCenterY + 80);
    loretxt:setFillColor(160/256,33/256,36/256)
    lore:setFillColor(0,0,0,1);
    lore:setStrokeColor(160/256,33/256,36/256);
    lore.strokeWidth = 4;

    local exitButton = display.newRect( display.contentCenterX, display.contentCenterY + 500, 365, 80);
    local exitText = display.newText("Exit", display.contentCenterX, display.contentCenterY + 500);
    exitText:setFillColor(160/256,33/256,36/256)
    exitButton:setFillColor(0,0,0,1);
    exitButton:setStrokeColor(160/256,33/256,36/256);
    exitButton.strokeWidth = 4;

    lev1:addEventListener("tap", function()
        composer.gotoScene("scenes.level", {effect = "fade", time = 250, params = {level="level1"}});
    end);
    lev2:addEventListener("tap", function()
        composer.gotoScene("scenes.level", {effect = "fade", time = 250, params = {level="level2"}});
    end);
    lore:addEventListener("tap", function()
        composer.gotoScene("scenes.lorepages.lorepg1", {effect = "fade", time = 250});
    end);
    exitButton:addEventListener("tap", function()
        native.requestExit();
    end);

    sceneGroup:insert(background);
    sceneGroup:insert(title);

    sceneGroup:insert(lev1);
    sceneGroup:insert(lev1txt);

    sceneGroup:insert(lev2);
    sceneGroup:insert(lev2txt);

    sceneGroup:insert(lore);
    sceneGroup:insert(loretxt);

    sceneGroup:insert(exitButton);
    sceneGroup:insert(exitText);
    
end

function scene:show(event)
    if event.phase == "did" then
        composer.removeScene("scenes.level")
        local audioHandle = audio.loadStream("Kalamity Keep.wav")
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
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("create", scene)

return scene