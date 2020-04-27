local Enemy = require("enemies.Enemy")

local troll = Enemy:new( {name='troll', HP=3, damage=3, speed=.5} )

function troll:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end

local unitTimer

function troll:unit(x,y, logArr)
    pcall( 
		function()
		unitTimer = timer.performWithDelay(800, 
			function() 
				local troll = self:new({xSpawn=x, ySpawn=y})
				troll:spawn()
				troll:move(logArr)
			end,3)
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

return troll