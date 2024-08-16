Button = {}
Button.__index = Button

function Button:new(x, y, width, height, text, onClick)
    local button = setmetatable({}, Button)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.text = text
    button.onClick = onClick
    button.isHovered = false
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
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.text, self.x, self.y + (self.height / 2) - 6, self.width, "center")
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.isHovered then
        self:onClick()
    end
end

return Button
