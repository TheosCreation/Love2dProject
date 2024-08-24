local Character = {}
Character.__index = Character

function Character:new(x, y, width, height)
    local instance = setmetatable({}, Character)
    instance.x = x
    instance.y = y
    instance.width = width
    instance.height = height
    instance.velocityY = 0
    instance.isFlying = false
    instance.angle = 0
    instance.animations = {}
    instance.currentAnimation = nil
    return instance
end

function Character:addAnimation(name, animation)
    self.animations[name] = animation
end

function Character:setAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Character:update(dt, gravity, jetpackForce, maxSpeedJetpack)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.isFlying then
        self.velocityY = self.velocityY + jetpackForce * dt
    else
        self.velocityY = self.velocityY + gravity * dt
    end

    -- Clamp the velocity to the maximum speed for jetpack usage
    if self.velocityY < maxSpeedJetpack then
        self.velocityY = maxSpeedJetpack
    end

    self.y = self.y + self.velocityY * dt
end

function Character:draw()
    love.graphics.setColor(1, 1, 1)
    
    if self.currentAnimation then
        self.currentAnimation:draw(self.x, self.y, self.spriteScaleX, self.spriteScaleY)
    end
end

function Character:setFlying(isFlying)
    self.isFlying = isFlying
end

function Character:getPosition()
    return self.x, self.y
end

return Character
