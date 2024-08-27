Image = {}
Image.__index = Image

-- Constructor for Image class
function Image:new(image, anchorX, anchorY, width, height, x, y)
    local img = setmetatable({}, Image)
    
    if type(image) == "string" then
        img.image = love.graphics.newImage(image)
    else
        img.image = image
    end
    img.anchorX = anchorX or 0.5  -- Default to center if not specified
    img.anchorY = anchorY or 0.5  -- Default to center if not specified
    img.width = width or img.image:getWidth()  -- Use provided width or image's width
    img.height = height or img.image:getHeight()  -- Use provided height or image's height
    img.x = x or 0
    img.y = y or 0
    img.color = {1, 1, 1, 1}
    return img
end

-- Set the position of the image based on screen coordinates
function Image:setPosition(x, y)
    self.x = x
    self.y = y
end

-- Get the current position of the image
function Image:getPosition()
    return self.x, self.y
end

-- Set the size of the image
function Image:setSize(width, height)
    self.width = width
    self.height = height
end

-- Get the current size of the image
function Image:getSize()
    return self.width, self.height
end

function Image:setColor(color)
    self.color = color
end

-- Scale the image to fit the screen size while maintaining aspect ratio
function Image:fitToScreen()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local imgWidth, imgHeight = self.image:getWidth(), self.image:getHeight()
    
    -- Calculate aspect ratios
    local imgAspect = imgWidth / imgHeight
    local screenAspect = screenWidth / screenHeight
    
    -- Determine the scaling factor
    if imgAspect > screenAspect then
        -- Image is wider than screen
        self.width = screenWidth
        self.height = screenWidth / imgAspect
    else
        -- Image is taller than screen or aspect ratios are equal
        self.height = screenHeight
        self.width = screenHeight * imgAspect
    end
    
    -- Set the position to be centered on the screen
    self.x = (screenWidth - self.width) / 2
    self.y = (screenHeight - self.height) / 2
end

-- Scale the image to stretch to the screen size
function Image:stretchToScreen()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    
    -- Set the image's width and height to match the screen's dimensions
    self.width = screenWidth
    self.height = screenHeight
    
    -- Set the position to be centered on the screen
    self.x = 0
    self.y = 0
end

-- Draw the image on the screen
function Image:draw()
    if not self then
        return
    end

    local imgWidth, imgHeight = self.image:getWidth(), self.image:getHeight()
    
    -- Calculate draw position based on anchor
    local drawX = self.x - (self.anchorX * self.width)
    local drawY = self.y - (self.anchorY * self.height)

    love.graphics.setColor(self.color) -- Set the text color

    -- Draw the image with scaling and anchor adjustment
    love.graphics.draw(self.image, drawX, drawY, 0, self.width / imgWidth, self.height / imgHeight)

    love.graphics.setColor(1, 1, 1, 1) -- Reset to default color (white)
end

return Image
