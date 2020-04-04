local composer = require("composer");

local scene = composer.newScene()

function scene:create( event )
 
    local sceneGroup = self.view
    local lev1 = display.newRect( display.contentCenterX - 400, display.contentCenterY, 480, 240);
    local lev2 = display.newRect( display.contentCenterX + 400, display.contentCenterY, 480, 240);
    local lev1txt = display.newText("Level 1", display.contentCenterX - 400, display.contentCenterY);
    local lev2txt = display.newText("Level 2", display.contentCenterX + 400, display.contentCenterY);
    lev1:addEventListener("tap", function()
        composer.gotoScene("scenes.Level_1", {effect = "fade", time = 250});
    end);
    lev2:addEventListener("tap", function()
        composer.gotoScene("scenes.Level_2", {effect = "fade", time = 250});
    end);
    sceneGroup:insert(lev1);
    sceneGroup:insert(lev2);
    sceneGroup:insert(lev1txt);
    sceneGroup:insert(lev2txt);

end

scene:addEventListener("create", scene)

return scene