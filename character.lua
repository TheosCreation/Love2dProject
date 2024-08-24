local Character = {}
Character.__index = Character

function Character:new(x, y, width, height, particleImage)
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
    instance.particleSystem = love.graphics.newParticleSystem(particleImage, 650)
    instance.particleSystem:setParticleLifetime(0.3, 0.5)
    instance.particleSystem:setLinearAcceleration(0, 15000, 0, 20000)
    instance.particleSystem:setSpeed(200, 500)
    instance.isGrounded = false
    instance.timer = 0

    instance.soundSource = love.audio.newSource("Audio/jetpack1.wav",  "static")
    instance.soundSource:setVolume(0.05)

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

    self.particleSystem:update(dt)
    self.timer = self.timer - dt
    if self.isFlying then
        self.velocityY = self.velocityY + jetpackForce * dt
        self.particleSystem:setPosition(self.x + self.width/4, self.y + self.height/1.5)
        if self.timer < 0 then
            love.audio.play( self.soundSource )
            self.particleSystem:emit(1)
            self.timer = 0.01
        end
        self.currentAnimation = self.animations["flying"]
    else
        self.velocityY = self.velocityY + gravity * dt
        if self.isGrounded then
            self.currentAnimation = self.animations["walking"]
        end
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

    love.graphics.draw(self.particleSystem)
end

function Character:setFlying(isFlying)
    self.isFlying = isFlying
end

function Character:getPosition()
    return self.x, self.y
end

return Character
