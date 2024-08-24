Transition = {}
Transition.__index = Transition

function Transition:new(duration, shader, image, textureMask)
    local transition = setmetatable({}, Transition)
    transition.shader = shader
    transition.textureMask = textureMask
    transition.active = false
    transition.callback = nil
    transition.time = 0
    transition.duration = duration

    transition.shader:send("duration", duration)

    transition.image = image

    -- Send the mask to the shader
    if textureMask then
        transition.shader:send("trans", textureMask)
    end
    return transition
end

function Transition:start(callback)
    self.active = true
    self.time = 0
    self.callback = callback
end

function Transition:update(dt)
    if self.active then
        self.time = self.time + dt
        self.shader:send("time", self.time)
        if self.time > self.duration then
            self.active = false
            if self.callback then
                self.callback()
            end
        end
    end
end

function Transition:draw()
    if self.active then
        local screenWidth, screenHeight = love.graphics.getDimensions()
        love.graphics.setShader(self.shader)
        love.graphics.draw(self.image, 0, 0, 0, screenWidth / self.image:getWidth(), screenHeight / self.image:getHeight())
        love.graphics.setShader()
    end
end

return Transition