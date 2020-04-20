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

	self.enemy.curX = 1
	self.enemy.curY = math.floor(self.ySpawn/12/9)
	
	self.enemy.lastX = 0
	self.enemy.lastY = 0

	physics.addBody(self.enemy, "kinematic"); 

	Runtime:addEventListener("pauseGame", self)
	Runtime:addEventListener("resumeGame", self)
	Runtime:addEventListener("clearGame", self)
	self.enemy:addEventListener("death", self)
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
		transition.cancel(self.enemy)

		self:death()
	end
end

function Enemy:moveEnemy(enemyPath)
	print("Moving unit")
	print("current X: " .. self.enemy.curX .. " current Y: " .. self.enemy.curY)
	print("last X: " .. self.enemy.lastX .. " last Y: " .. self.enemy.lastY)

	if(self.enemy.curX ~= #enemyPath and enemyPath[self.enemy.curX+1][self.enemy.curY] == -1 and self.enemy.curX+1 ~= self.enemy.lastX) then
		print("\nmoved right")
		transition.to(self.enemy, {time = 500/self.speed, x=self.enemy.x+130, y=self.enemy.y, onComplete= function() 
			pcall(function()
				self.enemy.lastX = self.enemy.curX
				self.enemy.lastY = self.enemy.curY
				self.enemy.curX = self.enemy.curX + 1
				self:move(enemyPath)
			end)
		end})
		
	--> check down
	elseif(self.enemy.curY ~= #enemyPath[1] and enemyPath[self.enemy.curX][self.enemy.curY+1] == -1 and self.enemy.curY+1 ~= self.enemy.lastY) then
		print("\nmoved down")
		transition.to(self.enemy, {time = 500/self.speed, x=self.enemy.x, y=self.enemy.y+100, onComplete= function() 
			pcall(function()
				self.enemy.lastX = self.enemy.curX
				self.enemy.lastY = self.enemy.curY
				self.enemy.curY = self.enemy.curY + 1
				self:move(enemyPath)
			end)
		end})
		
	--> check up
	elseif(self.enemy.curY ~= 1 and enemyPath[self.enemy.curX][self.enemy.curY-1] == -1 and self.enemy.curY-1 ~= self.enemy.lastY) then
		print("\nmoved up")
		transition.to(self.enemy, {time = 500/self.speed, x=self.enemy.x, y=self.enemy.y-100, onComplete= function() 
			pcall(function()
				self.enemy.lastX = self.enemy.curX
				self.enemy.lastY = self.enemy.curY
				self.enemy.curY = self.enemy.curY-1
				self:move(enemyPath)
			end)
		end})
		
	--> check left
	elseif(self.enemy.curX ~= 1 and enemyPath[self.enemy.curX-1][self.enemy.curY] == -1 and self.enemy.curX-1 ~= self.enemy.lastX) then
		print("\nmoved down")
		transition.to(self.enemy, {time = 500/self.speed, x=self.enemy.x-130, y=self.enemy.y, onComplete= function() 
			pcall(function()
				self.enemy.lastY = self.enemy.curY
				self.enemy.lastX = self.enemy.curX
				self.enemy.curX = self.enemy.curX - 1
				self:move(enemyPath)
			end)
		end})
		
	--> if there's nowhere else to go
	else
		transition.to(self.enemy, {time = 500/self.speed, x=self.enemy.x+130, y=self.enemy.y})
	end
end

--> take the path made in game logic and use it to move the enemy
function Enemy:move(enemyPath)
	if not pcall(self.moveEnemy, self, enemyPath) then
		print("failed to move enemy")
	end
end

-- custom event for the enemy dying
function Enemy:death(event)
	--something here to give the user money, take health from the user,  other actions for when the enemy either dies or reaches the end
	self:clearGame()
end

--> get the remaining health of the enemy
function Enemy:getHealth()
	return self.HP
end

-- function to stop the movement of the enemies when the pause button is pressed
function Enemy:pauseGame()
	self.enemy:pause()

	transition.pause()
end

-- fuction to resume the movement o the enemies when the resume button is pressed.
function Enemy:resumeGame()
	self.enemy:play()

	transition.resume()
end

function Enemy:clearGame()
	Runtime:removeEventListener("pauseGame", self)
	Runtime:removeEventListener("resumeGame", self)
	Runtime:removeEventListener("clearGame", self)
	self.enemy:removeSelf()
	self.enemy=nil
end

return Enemy

