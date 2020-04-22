local composer = require( "composer" )

local xx = display.contentCenterX
local yy = display.contentCenterY

local scene = composer.newScene()

local status

function scene:create(event)
    local sceneGroup = self.view
    status = event.params.status

    local shadow = display.newRect(sceneGroup, xx, yy, display.contentWidth, display.contentHeight)
    shadow:setFillColor(0,0,0,0.5)

    local pauseBg = display.newImage(sceneGroup, "./assets/buttons/pause-bg.png", xx, yy)
    pauseBg:scale(4,4)
    pauseBg:addEventListener("tap", function () return true end)

    local btnScale = 1.5

    local topText
    local restBtnX
    local homeBtnX

    if(status == "paused") then
        topText = "PAUSED"
        restBtnX = xx
        homeBtnX = xx + 300

        local playBtn = display.newImage(sceneGroup, "./assets/buttons/play.png", xx - 300, yy)
        playBtn:scale(btnScale,btnScale)
        playBtn:addEventListener("tap", function()
            composer.hideOverlay( "fade", 400 )
        end)

        shadow:addEventListener("tap", function()
            composer.hideOverlay( "fade", 400 )
        end)

    else
        restBtnX = xx - 200
        homeBtnX = xx + 200

        if(status == "won") then
            topText = "YOU WIN!"
        else
            topText = "YOU LOSE!"
        end
    end

    local topText = display.newText(sceneGroup, topText, xx, yy - 300, "ComicSansMS-Bold", 128)

    local restartBtn = display.newImage(sceneGroup, "./assets/buttons/restart.png", restBtnX, yy)
    restartBtn:scale(btnScale,btnScale)
    restartBtn:addEventListener("tap", function ()
        composer.gotoScene("scenes.proxy", {effect = "fade", time = 0, params = {level = event.params.level}})
    end)

    local homeBtn = display.newImage(sceneGroup, "./assets/buttons/home.png", homeBtnX, yy)
    homeBtn:scale(btnScale,btnScale)
    homeBtn:addEventListener("tap", function()
        composer.gotoScene("scenes.main_menu", {effect = "fade", time = 250})
    end)


end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  -- Reference to the parent scene object

    if ( phase == "did" and status == "paused") then
        parent:resumeGame()
    end
end

scene:addEventListener("create", scene)
scene:addEventListener( "hide", scene )
return scene
