Image = {}
Image.__index = Image

-- Constructor for Image class
function Image:new(image, anchorX, anchorY, width, height, x, y, pivotX, pivotY)
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
    img.overrideScale = false
    img.pivotX = pivotX or 0
    img.pivotY = pivotY or 0
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
    
    -- Set the position to be at the top-left corner of the screen
    self.x = 0
    self.y = 0

    self.overrideScale = true
end

function Image:draw()
    if not self then
        return
    end

    -- Define reference screen size for scaling
    local referenceWidth = 2400
    local referenceHeight = 1080

    -- Get current window size
    local windowWidth, windowHeight = love.graphics.getDimensions()

    -- Calculate scale factors based on window size and reference size
    local scaleX = windowWidth / referenceWidth
    local scaleY = windowHeight / referenceHeight

    -- Calculate the scaled width and height for the image
    local scaledWidth = self.width * scaleX
    local scaledHeight = self.height * scaleY

    -- Calculate the draw position based on anchor and pivot, including scaling
    local drawX = (self.x - (self.pivotX * scaledWidth)) + (windowWidth * self.anchorX)
    local drawY = (self.y - (self.pivotY * scaledHeight)) + (windowHeight * self.anchorY)

    -- Get image dimensions
    local imgWidth, imgHeight = self.image:getWidth(), self.image:getHeight()

    -- Calculate aspect ratio of the image
    local imgAspectRatio = imgWidth / imgHeight

    -- If maintaining aspect ratio is true
    if self.maintainAspectRatio then
        -- Calculate scaled dimensions while maintaining aspect ratio
        local windowAspectRatio = windowWidth / windowHeight
        if windowAspectRatio > imgAspectRatio then
            -- Window is wider relative to height
            scaledHeight = scaledWidth / imgAspectRatio
        else
            -- Window is taller relative to width
            scaledWidth = scaledHeight * imgAspectRatio
        end

        drawX = (self.x - (self.pivotX * scaledWidth)) + (windowWidth * self.anchorX)
        drawY = (self.y - (self.pivotY * scaledHeight)) + (windowHeight * self.anchorY)
    end

    -- Scale factors for the image
    local imgScaleX = scaledWidth / imgWidth
    local imgScaleY = scaledHeight / imgHeight

    love.graphics.setColor(self.color) -- Set the image color
    
    if self.overrideScale then
        -- Draw the image with specified scale and anchor adjustment
        love.graphics.draw(self.image, drawX, drawY, 0, self.width, self.height)
    else
        -- Draw the image with dynamic scaling and anchor adjustment
        love.graphics.draw(self.image, drawX, drawY, 0, imgScaleX, imgScaleY)
    end

    love.graphics.setColor(1, 1, 1, 1) -- Reset to default color (white)
end

return Image
