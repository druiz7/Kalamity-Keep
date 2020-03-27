-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim

display.setStatusBar( display.HiddenStatusBar ) 

local y = display.newRect(display.contentCenterX, display.contentCenterY, 1920, 1080)
y:setFillColor(0,1,1)

local x = display.newRect(10, 1070, 1560, 900)
x.anchorX = -1; x.anchorY=1

--[[ local e = display.newRect(display.contentCenterX, display.contentCenterY, 130, 100)
e:setFillColor(1,0,0)
 ]]
local Grid = display.newGroup()

local vert = 10;
local vGridlines = display.newGroup();

local horiz = 170;
local hGridlines = display.newGroup();

for i = 1, 12 do
    local vertGrid = display.newRect(vert, horiz, 130, 900);
    vertGrid:setFillColor(1,1,1,0);
    vertGrid:setStrokeColor(0,0,0);
    vertGrid.strokeWidth = 4;
    vertGrid.anchorX = 0; vertGrid.anchorY = 0;
    vert = vert + 130;
    vGridlines:insert(vertGrid)
end

for j = 1, 9 do
    local horizGrid = display.newRect(10, horiz, 1560, 100);
    horizGrid:setFillColor(1,1,1,0);
    horizGrid:setStrokeColor(0,0,0);
    horizGrid.strokeWidth = 4;
    horizGrid.anchorX = 0; horizGrid.anchorY = 0;
    horiz = horiz + 100;
    hGridlines:insert(horizGrid);
end

Grid:insert(vGridlines);
Grid:insert(hGridlines);
