Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, onClick, radiusX, radiusY)
    local button = setmetatable({}, Button)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.text = text
    button.onClick = onClick
    button.isHovered = false
    button.radiusX = radiusX or 0
    button.radiusY = radiusY or button.radiusX -- Use radiusX if radiusY is not provided
    return button
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.isHovered = mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height
end

function Button:draw()
    if self.isHovered then
        love.graphics.setColor(0.7, 0.7, 0.7)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    
    if self.radiusX > 0 and self.radiusY > 0 then
        -- Draw rounded rectangle
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radiusX, self.radiusY)
    else
        -- Draw regular rectangle
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.text, self.x, self.y + (self.height / 2) - 6, self.width, "center")
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.isHovered then
        self:onClick()
    end
end

return Button