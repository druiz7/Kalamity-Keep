local Enemy = require("enemies.Enemy")

local troll = Enemy:new( {name='troll', HP=3, damage=3, speed=.5} )


function troll:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end


return troll