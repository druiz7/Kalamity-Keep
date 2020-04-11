local widget = require("widget")
local composer = require("composer")

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
    local group = display.newGroup()
    local image = display.newImage(group, "./assets/buttons/pause.png", 1920 - 100, 100)

    local options = { isModal = true, effect = "crossFade"};
    image:addEventListener("tap", function (event)
        Runtime:dispatchEvent({name = "pauseGame"})
        physics.pause()
        composer.showOverlay("scenes.pause", options );
    end)

    return group;
end

function _M.createHomeBtn()
end

function _M.createTowerButtons(towerAtr, handler)
    local group = display.newGroup()

    local wizBtn =
        widget.newButton(
        {
            id = "Wizard",
            x = 1750,
            y = 320,
            width = 320,
            height = 290,
            defaultFile = "assets/buttons/default.png",
            overFile = "assets/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Wizard: " .. towerAtr.Wizard.cost .. "g",
            onRelease = handler
        }
    )

    local kniBtn =
        widget.newButton(
        {
            id = "Knight",
            x = 1750,
            y = 620,
            width = 320,
            height = 290,
            defaultFile = "assets/buttons/default.png",
            overFile = "assets/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Knight: " .. towerAtr.Knight.cost .. "g",
            onRelease = handler
        }
    )

    local arcBtn =
        widget.newButton(
        {
            id = "Archer",
            x = 1750,
            y = 920,
            width = 320,
            height = 290,
            defaultFile = "assets/buttons/default.png",
            overFile = "assets/buttons/after.png",
            labelColor = {default = {0, 0, 0}, over = {1, 1, 1}},
            fontSize = 45,
            label = "Archer: " .. towerAtr.Archer.cost .. "g",
            onRelease = handler
        }
    )

    group:insert(wizBtn)
    group:insert(kniBtn)
    group:insert(arcBtn)

    return group
end

return _M
