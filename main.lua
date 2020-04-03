-- David Ruiz, Nick Dea, Shuji Mizoguchi
-- Prof. Kim
local physics = require("physics")
physics.start()
physics.setGravity (0,0);

physics.setDrawMode("hybrid")

local Archer = require("towers.Archer")
local Wizard = require("towers.Wizard")

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

-- code that tests my longRange class
local archer = Archer:new({posX = 10 + (120*6), posY = 1070 - (95*9)})
archer:spawn()

local wizard = Wizard:new({posX = 10 + (120*6), posY = 1010 - (95*2)})
wizard:spawn()

local enemy = display.newRect(display.contentCenterX + 300, display.contentCenterY, 150, 150)
enemy.tag = "enemy"
enemy:setFillColor(1,1,0)
physics.addBody(enemy, "static")

enemy:addEventListener("touch", function(event)
    if event.phase == "began" then
      event.target.markX = event.target.x
      event.target.markY = event.target.y
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart) + event.target.markX
        local y = (event.y - event.yStart) + event.target.markY

        event.target.x = x
        event.target.y = y
    end
  end)

enemy.shape = enemy
enemy.shape.pp = enemy
enemy.HP = 100
function enemy:hit(pts)
    self.HP = (self.HP or 1) - pts
    print(self.HP)
end

local clearGame = display.newRect(1920 - 100, 100, 150, 100)
clearGame:addEventListener("tap", function() 
    Runtime:dispatchEvent({name="clearGame"})
end)

local cg_text = display.newText("Clear", 1920-100, 100)
cg_text:setFillColor(1,0,0)

