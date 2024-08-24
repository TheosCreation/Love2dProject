Animation = {}
Animation.__index = Animation

function Animation:new(image, frameWidth, frameHeight, duration)
    local animation = setmetatable({}, Animation)
    animation.spriteSheet = image
    animation.frameWidth = frameWidth
    animation.frameHeight = frameHeight
    animation.duration = duration or 1
    animation.frames = {}
    animation.currentTime = 0

    local imageWidth = image:getWidth()
    local imageHeight = image:getHeight()

    for y = 0, imageHeight - frameHeight, frameHeight do
        for x = 0, imageWidth - frameWidth, frameWidth do
            local quad = love.graphics.newQuad(x, y, frameWidth, frameHeight, imageWidth, imageHeight)
            table.insert(animation.frames, quad)
        end
    end

    animation.totalFrames = #animation.frames
    return animation
end

function Animation:update(dt)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
end

function Animation:draw(x, y, rotation, scaleX, scaleY, originX, originY)
    local frameIndex = math.floor(self.currentTime / self.duration * self.totalFrames) + 1
    
    -- Ensure frameIndex is within bounds
    if frameIndex < 1 then
        frameIndex = 1
    elseif frameIndex > self.totalFrames then
        frameIndex = self.totalFrames
    end
    
    -- Default values for optional parameters
    rotation = rotation or 0
    scaleX = scaleX or 1
    scaleY = scaleY or 1
    originX = originX or 0
    originY = originY or 0
    
    -- Draw the current frame with the specified parameters
    love.graphics.draw(
        self.spriteSheet,           -- The sprite sheet
        self.frames[frameIndex],    -- The current frame
        x,                          -- X position
        y,                          -- Y position
        rotation,                   -- Rotation (in radians)
        scaleX,                     -- X scale
        scaleY,                     -- Y scale
        originX,                    -- X origin (center of the sprite)
        originY                     -- Y origin (center of the sprite)
    )
end

return Animation
