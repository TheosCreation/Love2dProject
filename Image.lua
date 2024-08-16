Image = {}
Image.__index = Image

function Image:new(filePath, x, y, width, height)
    local img = setmetatable({}, Image)
    img.image = love.graphics.newImage(filePath)  -- Load the image from the file path
    img.x = x
    img.y = y
    img.width = width or img.image:getWidth()  -- Use provided width or image's width
    img.height = height or img.image:getHeight()  -- Use provided height or image's height
    return img
end

function Image:setPosition(x, y)
    self.x = x
    self.y = y
end

function Image:getPosition()
    return self.x, self.y
end

function Image:setSize(width, height)
    self.width = width
    self.height = height
end

function Image:getSize()
    return self.width, self.height
end

function Image:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.width / self.image:getWidth(), self.height / self.image:getHeight())
end

return Image
