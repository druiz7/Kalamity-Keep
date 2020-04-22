local Enemy = require("enemies.Enemy")

local barbarian = Enemy:new( {name='barbarian', HP=10, damage=2, speed=1, reward=100;} )


function barbarian:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end

function barbarian:unit(x,y, logArr)
    pcall( 
		function()
		print("barb troop")
		print("x: " .. x)
		print("y: " .. y)
		timer.performWithDelay(800, 
			function() 
				print("summon barbarian here")
				local barb = self:new({xSpawn=x, ySpawn=y})
				barb:spawn(logArr)
			end,5)
	end)
end

return barbarian
