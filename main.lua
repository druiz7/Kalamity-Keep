-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

local composer = require("composer")

display.setStatusBar( display.HiddenStatusBar ) 

composer.gotoScene("scenes.level", {effect = "fade", time = 250, params={level="level1"}})