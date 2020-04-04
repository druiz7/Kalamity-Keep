local composer = require("composer");

local scene = composer.newScene()

function scene:create( event )
 
    local sceneGroup = self.view
    
    local lev1 = display.newRect( display.contentCenterX - 400, display.contentCenterY, 480, 240);
    local lev1txt = display.newText("Level 1", display.contentCenterX - 400, display.contentCenterY);
    lev1txt:setFillColor(0,0,0)
    lev1:setStrokeColor(1,0,0);
    lev1.strokeWidth = 4;

    local lev2 = display.newRect( display.contentCenterX + 400, display.contentCenterY, 480, 240);
    local lev2txt = display.newText("Level 2", display.contentCenterX + 400, display.contentCenterY);
    lev2txt:setFillColor(0,0,0)
    lev2:setStrokeColor(1,0,0);
    lev2.strokeWidth = 4;

    local exitButton = display.newRect( display.contentCenterX, display.contentCenterY + 300, 360, 120);
    local exitText = display.newText("Exit", display.contentCenterX, display.contentCenterY + 300);
    exitText:setFillColor(0,0,0)
    exitButton:setStrokeColor(1,0,0);
    exitButton.strokeWidth = 4;

    lev1:addEventListener("tap", function()
        composer.gotoScene("scenes.Level_1", {effect = "fade", time = 250});
    end);
    lev2:addEventListener("tap", function()
        composer.gotoScene("scenes.Level_2", {effect = "fade", time = 250});
    end);
    exitButton:addEventListener("tap", function()
        native.requestExit();
    end);

    sceneGroup:insert(lev1);
    sceneGroup:insert(lev1txt);

    sceneGroup:insert(lev2);
    sceneGroup:insert(lev2txt);

    sceneGroup:insert(exitButton);
    sceneGroup:insert(exitText);

end

scene:addEventListener("create", scene)

return scene