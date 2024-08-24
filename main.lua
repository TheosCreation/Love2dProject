local MainMenuScene = require("MainMenuScene")
local GameScene = require("GameScene")
local GameOverScene = require("GameOverScene")
local ShaderManager = require("ShaderManager")
local TextureManager = require("TextureManager")

function love.load()
    -- Load the shader from the external GLSL file
    ShaderManager:loadShaderFromFile("myShader", "shaders/myShader.glsl")
    ShaderManager:loadShaderFromFile("transitionShader", "shaders/transitionShader.glsl")

    --load general textures
    TextureManager:loadTextureFromFile("white", "Sprites/white.png");

    --load transitions
    TextureManager:loadTextureFromFile("brick", "Sprites/TransitionMasks/brick.png")
    TextureManager:loadTextureFromFile("cool", "Sprites/TransitionMasks/cool.png")
    TextureManager:loadTextureFromFile("dot", "Sprites/TransitionMasks/dot.png")
    TextureManager:loadTextureFromFile("circleMask", "Sprites/TransitionMasks/circle.png")
    TextureManager:loadTextureFromFile("leftToRightMask", "Sprites/TransitionMasks/LeftToRight.jpg")
    TextureManager:loadTextureFromFile("middleOutMask", "Sprites/TransitionMasks/middleOut.jpg")
    TextureManager:loadTextureFromFile("middleUpandDownMask", "Sprites/TransitionMasks/MiddleUpandDown.jpg")

    -- Set the initial scene
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