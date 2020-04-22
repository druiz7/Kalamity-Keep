local Enemy = require("enemies.Enemy")

local lizard = Enemy:new( {name='lizard', HP=1, damage=1, speed=1.5} )


function lizard:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end

function lizard:unit(x,y, logArr)
    pcall( 
		function()
		print("barb troop")
		print("x: " .. x)
		print("y: " .. y)
		timer.performWithDelay(800, 
			function() 
				print("summon barbarian here")
				local liz = self:new({xSpawn=x, ySpawn=y})
				liz:spawn(logArr)
			end,5)
	end)
end


return lizard;