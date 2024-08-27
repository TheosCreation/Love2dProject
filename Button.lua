local Text = require("Text")

Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, font, fontSize, onClick, radiusX, radiusY, pivotX, pivotY, anchorX, anchorY)
    local button = setmetatable({}, Button)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.radiusX = radiusX or 0
    button.radiusY = radiusY or button.radiusX -- Use radiusX if radiusY is not provided
    button.pivotX = pivotX or 0.5
    button.pivotY = pivotY or 0.5
    button.anchorX = anchorX or 0
    button.anchorY = anchorY or 0
    button.onClick = onClick
    button.isHovered = false
    button.color = {1, 1, 1, 1} 

    -- Create a Text object new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY, color)
    button.text = Text:new(text, 0, 0, font, fontSize, width, height, false, 0, 0)

    return button
end

function Button:setColor(color)
    self.color = color
end

function Button:setTextColor(color)
    self.text:setColor(color)
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local scaleX = screenWidth / 2400
    local scaleY = screenHeight / 1080
    
    local buttonX = self.x - (self.width * self.pivotX * scaleX) + (screenWidth * self.anchorX)
    local buttonY = self.y - (self.height * self.pivotY * scaleY) + (screenHeight * self.anchorY)
    self.isHovered = mx > buttonX and mx < buttonX + self.width and my > buttonY and my < buttonY + self.height
end

function Button:draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local scaleX = screenWidth / 2400
    local scaleY = screenHeight / 1080

    local buttonX = self.x - (self.width * self.pivotX * scaleX) + (screenWidth * self.anchorX)
    local buttonY = self.y - (self.height * self.pivotY * scaleY) + (screenHeight * self.anchorY)

    if self.isHovered then
        love.graphics.setColor(0.7, 0.7, 0.7)
    else
        love.graphics.setColor(self.color)
    end
    
    if self.radiusX > 0 and self.radiusY > 0 then
        -- Draw rounded rectangle
        love.graphics.rectangle("fill", buttonX, buttonY, self.width, self.height, self.radiusX, self.radiusY)
    else
        -- Draw regular rectangle
        love.graphics.rectangle("fill", buttonX, buttonY, self.width, self.height)
    end

    -- Draw the text
    love.graphics.setColor(1, 1, 1)
    self.text:draw(buttonX, buttonY + self.height * 0.35)
end

function Button:mousepressed(x, y, button)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local scaleX = screenWidth / 2400
    local scaleY = screenHeight / 1080
    
    local buttonX = self.x - (self.width * self.pivotX * scaleX) + (screenWidth * self.anchorX)
    local buttonY = self.y - (self.height * self.pivotY * scaleY) + (screenHeight * self.anchorY)

    if button == 1 and x > buttonX and x < buttonX + self.width and y > buttonY and y < buttonY + self.height then
        self:onClick()
    end
end

function Button:setPosition(x, y)
    self.x = x
    self.y = y
end

function Button:getPosition()
    return self.x, self.y
end

return Button
