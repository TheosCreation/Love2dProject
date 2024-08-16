local MainMenuScene = require("MainMenuScene")
local GameScene = require("GameScene")

function love.load()
    currentScene = MainMenuScene:new()
end

function love.update(dt)
    currentScene:update(dt)
end

function love.draw()
    currentScene:draw()
end

function love.mousepressed(x, y, button)
    currentScene:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    currentScene:mousereleased(x, y, button)
end