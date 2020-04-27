local Enemy = require("enemies.Enemy")

local barbarian = Enemy:new( {name='barbarian', HP=10, damage=2, speed=1, reward=100;} )


function barbarian:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end

local unitTimer

function barbarian:unit(x,y, logArr)
    pcall(
		function()
			unitTimer = timer.performWithDelay(800, 
				function()
					local barb = self:new({xSpawn=x, ySpawn=y})
					barb:spawn()
					barb:move(logArr)
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

return barbarian
