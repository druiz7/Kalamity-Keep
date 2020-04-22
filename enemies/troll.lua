local Enemy = require("enemies.Enemy")

local troll = Enemy:new( {name='troll', HP=3, damage=3, speed=.5} )

function troll:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end

function troll:unit(x,y, logArr)
    pcall( 
		function()
		print("troll troop")
		print("x: " .. x)
		print("y: " .. y)
		timer.performWithDelay(800, 
			function() 
				print("summon barbarian here")
				local troll = self:new({xSpawn=x, ySpawn=y})
				troll:spawn()
				troll:move(logArr)
			end,3)
	end)
end

return troll