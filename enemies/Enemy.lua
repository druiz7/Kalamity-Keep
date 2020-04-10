local Enemy = {tag = enemy, name='Enemy', HP=1, damage=1, speed=1, path={}, reward=50, xSpawn=0, ySpawn=0};

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
	self.enemy.curX = self.xSpawn
	self.enemy.curY = self.ySpawn

	physics.addBody(self.enemy, "kinematic"); 

	Runtime:addEventListener("pause", self)
	Runtime:addEventListener("resume", self)
	Runtime:addEventListener("clear", self)
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

--> take the path made in game logic and use it to move the enemy
function Enemy:move(path)
	while (self.HP > 0) do
		--> check up
		if(path[curX][curY-1] ~= path[lastX][lastY]) then
			transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x, y=self.enemy.y-100})
			self.enemy.lastY = self.enemy.curY
			self.enemy.curY = self.enemy.curY-1
		end

		--> check left
		if(path[curX-1][curY] ~= path[lastX][lastY]) then
			transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x-130, y=self.enemy.y})
			self.enemy.lastX = self.enemy.curX
			self.enemy.curX = self.enemy.curX - 1
		end

		--> check down
		if(path[curX][curY+1] ~= path[lastX][lastY]) then
			transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x, y=self.enemy.y+100})
			self.enemy.lastY = self.enemy.curY
			self.enemy.curY = self.enemy.curY+1
		end

		--> check right
		if(path[curX+1][curY] ~= path[lastX][lastY]) then
			transition.to(self.enemy, {time = 500*self.speed, x=self.enemy.x+130, y=self.enemy.y})
			self.enemy.lastX = self.enemy.curX
			self.enemy.curX = self.enemy.curX + 1
		end
	end
end

-- custom event for the enemy dying
function Enemy:death(event)
	--something here to give the user money, take health from the user,  other actions for when the enemy either dies or reaches the end
	if (event.target == player) then
		player.hp = player.hp - 1
	elseif (event.target ~= player) then
		player.wallet = player.wallet + self.reward
	end
	self.enemy:removeSelf()
	self.enemy = nil
end

--> get the remaining health of the enemy
function Enemy:getHealth()
	return self.HP
end

-- function to stop the movement of the enemies when the pause button is pressed
function Enemy:pause()
	self.enemy:pause()

	transition.pause()
end

-- fuction to resume the movement o the enemies when the resume button is pressed.
function Enemy:resume()
	self.enemy:play()

	transition.resume()
end

function Enemy:clear()
	Runtime:removeEventListener("pause", self)
	Runtime:removeEventListener("resume", self)
	Runtime:removeEventListener("clear", self)
	self.enemy:removeSelf()
	self.enemy=nil
end

return Enemy
