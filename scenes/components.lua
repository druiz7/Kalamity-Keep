local _M = {}

function _M.createGold(game)
    local group = display.newGroup()
    local image = display.newImage(group, "./assets/gold.png", 50, 125)
    image:scale(0.5, 0.5)

    local text = display.newText({parent = group, text = game.gold .. " g", x = 100, y = 125})
    text.anchorX = 0

    function game:updateGold(amount)
        self.gold = self.gold + amount
        text.text = self.gold .. " g"
    end

    return group
end

function _M.createHealth(game)
    local group = display.newGroup()
    local image = display.newImage(group, "./assets/heart.png", 50, 50)
    image:scale(0.5, 0.5)

    local text = display.newText({parent = group, text = game.health .. " hp", x = 100, y = 50})
    text.anchorX = 0

    function game:updateHealth(amount)
        self.health = self.health + amount
        text.text = self.health .. " hp"
    end

    return group
end

function _M.createPauseBtn()
end

function _M.createHomeBtn()
end

return _M
