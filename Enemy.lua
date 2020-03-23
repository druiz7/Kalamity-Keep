


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
	self.enemy.pp= self;      -- parent pointer to parent object
	self.enemy.tag= self.tag; --“enemy”
	physics.addBody(self.enemy, "kinematic"); 
end


function Enemy:hit(damageNum)
	--> function for when the enemy gets hit
	self.HP = self.HP - damageNum
	if (self.HP <= 0) then
		self.enemy:removeSelf();
		self.enemy=nil;
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
				transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x-130, y=self.enemy.y})
			else if (path[i] == 2) then
				-->transition to the right
				transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x+130, y=self.enemy.y})
			else if (path[i] == 3) then
				-->transition up
				transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x, y=self.enemy.y+100})
			else if (path[i] == 4) then
				-->transition down
				transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x, y=self.enemy.y-100})
			end
		end
	end
end
