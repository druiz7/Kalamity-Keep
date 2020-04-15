local Enemy = {displayGroup = display.newGroup(), tag = "enemy", name='Enemy', HP=1, damage=1, speed=1, path={}, reward=50, xSpawn=0, ySpawn=0};

local chars = require("assets.Chars")

local components = require("scenes.components")

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
	self.enemy.pp = self;      -- parent pointer to parent object
	self.enemy.tag = self.tag; --“enemy”
	self.enemy.name = self.name; --name”
	self.enemy.damage = self.damage; --damage”
	self.enemy.HP = self.HP; --HP”
	self.enemy.shape = self.sprite

	self.enemy.curX = 1
	self.enemy.curY = 8
	
	self.enemy.lastX = 1
	self.enemy.lastY = 1

	physics.addBody(self.enemy, "kinematic"); 

	Runtime:addEventListener("pause", self)
	Runtime:addEventListener("resume", self)
	Runtime:addEventListener("clear", self)
end

function Enemy:createSprite(x,y)
	local opt, seqData = chars.getFrames(self.name)
	local sheet = graphics.newImageSheet("./assets/all.png", opt)

	self.sprite = display.newSprite(self.displayGroup, sheet, seqData)
	self.sprite.x = x
	self.sprite.y = y

	self.sprite.xScale = 6
	self.sprite.yScale = 6

	self.sprite:setSequence("run")
	self.sprite:play()
end

--> function for when the enemy gets hit
function Enemy:hit(damageNum)
	print("got hit")
	self.HP = self.HP - damageNum
	if (self.HP <= 0) then
		self.enemy:removeSelf();
		self.enemy=nil;
		self = nil;
	end
end

--> take the path made in game logic and use it to move the enemy
function Enemy:move(enemyPath)

	--> check right
	if(enemyPath[self.enemy.curX+1][self.enemy.curY] == -1 and self.enemy.curX+1 ~= self.enemy.lastX) then
		transition.to(self.enemy, {time = 500, x=self.enemy.x+130, y=self.enemy.y, onComplete=function()
			self.enemy.lastX = self.enemy.curX
			self.enemy.lastY = self.enemy.curY
			self.enemy.curX = self.enemy.curX + 1
			self:move(enemyPath)
		end
		})

	--> check down
	elseif(enemyPath[self.enemy.curX][self.enemy.curY+1] == -1 and self.enemy.curY+1 ~= self.enemy.lastY) then
		transition.to(self.enemy, {time = 500, x=self.enemy.x, y=self.enemy.y+100, onComplete=function()
			self.enemy.lastX = self.enemy.curX
			self.enemy.lastY = self.enemy.curY
			self.enemy.curY = self.enemy.curY + 1
			self:move(enemyPath)
		end
		})

	--> check up
	elseif(enemyPath[self.enemy.curX][self.enemy.curY-1] == -1 and self.enemy.curY-1 ~= self.enemy.lastY) then
		transition.to(self.enemy, {time = 500, x=self.enemy.x, y=self.enemy.y-100, onComplete=function()
			self.enemy.lastX = self.enemy.curX
			self.enemy.lastY = self.enemy.curY
			self.enemy.curY = self.enemy.curY-1
			self:move(enemyPath)
		end
		})

	--> check left
	elseif(enemyPath[self.enemy.curX-1][self.enemy.curY] == -1 and self.enemy.curX-1 ~= self.enemy.lastX) then
		transition.to(self.enemy, {time = 500, x=self.enemy.x-130, y=self.enemy.y, onComplete=function()
			self.enemy.lastY = self.enemy.curY
			self.enemy.lastX = self.enemy.curX
			self.enemy.curX = self.enemy.curX - 1
			self:move(enemyPath)
		end
		})

	--> if there's nowhere else to go	
		else
		transition.to(self.enemy, {time = 10, x=self.enemy.x+130, y=self.enemy.y})
		-- self.HP = 0
		-- self.enemy:removeSelf()
		-- self.enemy = nil
	end
end

-- custom event for the enemy dying
function Enemy:death(event)
	--something here to give the user money, take health from the user,  other actions for when the enemy either dies or reaches the end
	game:updateHealth(self.reward)
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

