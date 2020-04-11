local composer = require("composer")
local scene = composer.newScene()

function scene:show(event)
    local level = event.params.level
    if event.phase == "did" then
        composer.removeScene("scenes.level")
        composer.gotoScene("scenes.level", {effect = "fade", time = 250, params = {level=level}})
    end
end

scene:addEventListener("show", scene)
return scene