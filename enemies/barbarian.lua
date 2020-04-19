local Enemy = require("enemies.Enemy")

local barbarian = Enemy:new( {name='barbarian', HP=10, damage=2, speed=1, reward=100;} )


function barbarian:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end


return barbarian