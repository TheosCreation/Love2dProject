Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, font, fontSize, onClick, radiusX, radiusY, pivotX, pivotY, anchorX, anchorY)
    local button = setmetatable({}, Button)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.text = text
    button.font = font
    button.fontSize = fontSize
    button.onClick = onClick
    button.isHovered = false
    button.radiusX = radiusX or 0
    button.radiusY = radiusY or button.radiusX -- Use radiusX if radiusY is not provided
    button.pivotX = pivotX or 0.5
    button.pivotY = pivotY or 0.5
    button.anchorX = anchorX or 0
    button.anchorY = anchorY or 0
    return button
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    local buttonX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local buttonY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY
    self.isHovered = mx > buttonX and mx < buttonX + self.width and my > buttonY and my < buttonY + self.height
end

function Button:draw()
    local buttonX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local buttonY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY

    love.graphics.setFont(self.font, self.fontSize)

    if self.isHovered then
        love.graphics.setColor(0.7, 0.7, 0.7)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    
    if self.radiusX > 0 and self.radiusY > 0 then
        -- Draw rounded rectangle
        love.graphics.rectangle("fill", buttonX, buttonY, self.width, self.height, self.radiusX, self.radiusY)
    else
        -- Draw regular rectangle
        love.graphics.rectangle("fill", buttonX, buttonY, self.width, self.height)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.text, buttonX, buttonY + (self.height / 2) - 6, self.width, "center")
end

function Button:mousepressed(x, y, button)
    local buttonX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local buttonY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY

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
