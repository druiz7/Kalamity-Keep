local Enemy = require("enemies.Enemy")

local barbarian = Enemy:new( {name='barbarian', HP=2, damage=2, speed=2} )


function barbarian:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end


return barbarian