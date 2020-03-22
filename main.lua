-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof Kim

display.setStatusBar( display.HiddenStatusBar ) 

local y = display.newRect(display.contentCenterX, display.contentCenterY, 1920, 1080)
y:setFillColor(0,1,1)

local x = display.newRect(10, 1070, 1560, 900)
x.anchorX = -1; x.anchorY=1

local e = display.newRect(display.contentCenterX, display.contentCenterY, 130, 100)
e:setFillColor(1,0,0)

