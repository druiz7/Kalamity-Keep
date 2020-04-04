local Enemy = {name='Enemy', HP=1, damage=1, speed=1, path={}, reward=50, xSpawn=0, ySpawn=0};

local chars = require("chars.Chars")


function Enemy:new(o)    --constructor
	o = o or {}; 
	setmetatable(o, self);
	self.__index= self;
	return o;
end


--> spawn the enemies, same way David spawned in the towers
function Enemy:spawn()
	--> enemy creation expression
	self:createSprite(self.xSpawn, self.ySpawn)
	self.enemy = self.sprite
	self.enemy.pp= self;      -- parent pointer to parent object
	self.enemy.tag= self.tag; --“enemy”
	physics.addBody(self.enemy, "kinematic"); 
end


function Enemy:createSprite(x,y)
	local opt, seqData = chars.getFrames(self.name)
	local sheet = graphics.newImageSheet("./chars/all.png", opt)

	self.sprite = display.newSprite(sheet, seqData)
	self.sprite.x = x
	self.sprite.y = y

	self.sprite.xScale = 6
	self.sprite.yScale = 6

	self.sprite:setSequence("run")
	self.sprite:play()
end


--> function for when the enemy gets hit
function Enemy:hit(damageNum)
	self.HP = self.HP - damageNum
	if (self.HP <= 0) then
		self.enemy:removeSelf();
		self.enemy=nil;
		self = nil;  
	end
end


--> make the enemy follow the designated path
-- this movement isn't very well done, I will probably be changing this
function Enemy:move(path)
	--> for the path, pass in an array of 1, 2, 3, and 4's
	--> the numbers will be based on the paths (1 = left, 2 = right, 3 = up, 4 = down)
	for i = 1,path do
		-- while (self.HP > 0) do
		-- 	if (path[i] == 1) then
		-- 		-->transition to the left
		-- 		transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x-130, y=self.enemy.y})
		-- 	else if (path[i] == 2) then
		-- 		-->transition to the right
		-- 		transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x+130, y=self.enemy.y})
		-- 	else if (path[i] == 3) then
		-- 		-->transition up
		-- 		transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x, y=self.enemy.y+100})
		-- 	else if (path[i] == 4) then
		-- 		-->transition down
		-- 		transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x, y=self.enemy.y-100})
		-- 	end
		-- end
	end
end


-- custom event for the enemy dying
function Enemy:death(event)
	--something here to give the user money, take health from the user,  other actions for when the enemy either dies or reaches the end
	if (event.target == player) then
		player.hp = player.hp - 1
	else if (event.target ~= player) then
		player.wallet = player.wallet + self.reward
	end
	self.enemy:removeSelf()
	self.enemy = nil
end


--> get the remaining health of the enemy
function Enemy:getHealth()
	return self.HP
end

return Enemy