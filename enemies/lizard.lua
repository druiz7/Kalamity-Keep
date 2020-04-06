local Enemy = require("enemies.Enemy")

local lizard = Enemy:new( {name='lizard', HP=1, damage=1, speed=3} )


function lizard:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end


return lizard;