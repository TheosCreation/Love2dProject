local Character = {}
Character.__index = Character

function Character:new(x, y, width, height, spritePath)
    local instance = setmetatable({}, Character)
    instance.x = x
    instance.y = y
    instance.width = width
    instance.height = height
    instance.velocityY = 0
    instance.isFlying = false
    instance.angle = 0
    instance.sprite = love.graphics.newImage(spritePath)
    instance.spriteScaleX = width / instance.sprite:getWidth()
    instance.spriteScaleY = height / instance.sprite:getHeight()

    return instance
end

function Character:update(dt, gravity, jetpackForce, maxSpeedJetpack)
    if self.isFlying then
        self.velocityY = self.velocityY + jetpackForce * dt
    else
        self.velocityY = self.velocityY + gravity * dt
    end

    if self.velocityY < maxSpeedJetpack then
        self.velocityY = maxSpeedJetpack
    end

    self.y = self.y + self.velocityY * dt
end

function Character:draw()
    love.graphics.setColor(1, 1, 1)
    -- Centering the sprite
    love.graphics.draw(
        self.sprite,
        self.x,
        self.y,
        self.angle,
        self.spriteScaleX,
        self.spriteScaleY,
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

function Character:setFlying(isFlying)
    self.isFlying = isFlying
end

function Character:getPosition()
    return self.x, self.y
end

return Character