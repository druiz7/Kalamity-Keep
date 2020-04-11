local composer = require( "composer" )

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local shadow = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    shadow:setFillColor(0,0,0,0.5)
    shadow:addEventListener("tap", function()
        composer.hideOverlay( "fade", 400 )
    end)

    local pauseBg = display.newImage(sceneGroup, "./assets/buttons/pause-bg.png", display.contentCenterX, display.contentCenterY)
    pauseBg:scale(4,4)
    pauseBg:addEventListener("tap", function () return true end)

    local btnScale = 1.5
    local playBtn = display.newImage(sceneGroup, "./assets/buttons/play.png", display.contentCenterX - 300, display.contentCenterY)
    playBtn:scale(btnScale,btnScale)
    playBtn:addEventListener("tap", function ()
        composer.hideOverlay( "fade", 400 )
    end)

    local restartBtn = display.newImage(sceneGroup, "./assets/buttons/restart.png", display.contentCenterX, display.contentCenterY)
    restartBtn:scale(btnScale,btnScale)

    local homeBtn = display.newImage(sceneGroup, "./assets/buttons/home.png", display.contentCenterX + 300, display.contentCenterY)
    homeBtn:scale(btnScale,btnScale)
    homeBtn:addEventListener("tap", function()
        composer.gotoScene("scenes.main_menu", {effect = "fade", time = 250})
    end)

    sceneGroup:toFront()
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  -- Reference to the parent scene object

    if ( phase == "did" ) then
        parent:resumeGame()
    end
end

scene:addEventListener("create", scene)
scene:addEventListener( "hide", scene )
return scene
