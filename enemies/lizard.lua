local Enemy = require("enemies.Enemy")

local lizard = Enemy:new( {name='lizard', HP=1, damage=1, speed=1.5} )


function lizard:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end

local unitTimer

function lizard:unit(x,y, logArr)
    pcall( 
		function()
			unitTimer = timer.performWithDelay(800, 
				function()
					local liz = self:new({xSpawn=x, ySpawn=y})
					liz:spawn()
					liz:move(logArr)
				end,5)
		end)
end

Runtime:addEventListener("paused", function(event)
    print("paused unit here")
    if (unitTimer) then
        print(unitTimer)
        timer.pause(unitTimer)
    end
end)

Runtime:addEventListener("resumed", function(event)
    print("resumed unit here")
    if (unitTimer) then
        print(unitTimer)
        timer.resume(unitTimer)
    end
end)


return lizard;