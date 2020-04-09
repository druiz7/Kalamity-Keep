-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

local composer = require("composer")

display.setStatusBar( display.HiddenStatusBar ) 

composer.gotoScene("scenes.Main_Menu", {effect = "fade", time = 250})