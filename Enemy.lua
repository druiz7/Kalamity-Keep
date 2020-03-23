


local Enemy = {name='Enemy', HP=1, damage=1, speed=1, reward=50, xSpawn=0, ySpawn=0};


function Enemy:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end


--> spawn the enemies
function Enemy:spawn(xSpawn, ySpawn)
	--> enemy creation expression
	self.shape.pp= self;      -- parent pointer to parent object
	self.shape.tag= self.tag; --“enemy”
	physics.addBody(self.shape, "kinematic"); 
end


function Enemy:hit(damageNum)
	--> function for when the enemy gets hit
	self.HP = self.HP - damageNum
	if (self.HP <= 0) then
		self.shape:removeSelf();
		self.shape=nil;
		self = nil;  
	end
end


function Enemy:move(path)
	--> make the enemy follow the designated path
	--> for the path, pass in an array of 1, 2, 3, and 4's
	--> the numbers will be based on the paths (1 = left, 2 = right, 3 = up, 4 = down)
	for i = 1,path do
		while (self.HP > 0) do
			if (path[i] == 1) then
				-->transition to the left
				transition.to(self.shape, {time = 500*self.speed, x=self.shape.x-130, y=self.shape.y})
			else if (path[i] == 2) then
				-->transition to the right
				transition.to(self.shape, {time = 500*self.speed, x=self.shape.x+130, y=self.shape.y})
			else if (path[i] == 3) then
				-->transition up
				transition.to(self.shape, {time = 500*self.speed, x=self.shape.x, y=self.shape.y+100})
			else if (path[i] == 4) then
				-->transition down
				transition.to(self.shape, {time = 500*self.speed, x=self.shape.x, y=self.shape.y-100})
			end
		end
	end
end
