local Enemy = require("enemies.Enemy")

local lizard = Enemy:new( {name='lizard', HP=5, damage=10, speed=1.5, reward=5} )


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

Runtime:addEventListener("pauseGame", function(event)
    if (unitTimer) then
        timer.pause(unitTimer)
    end
end)

Runtime:addEventListener("resumeGame", function(event)
    if (unitTimer) then
        timer.resume(unitTimer)
    end
end)

Runtime:addEventListener("clearGame", function(event)
    if (unitTimer) then
        timer.resume(unitTimer)
    end
end)


return lizard;