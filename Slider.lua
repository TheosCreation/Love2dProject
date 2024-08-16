Slider = {}
Slider.__index = Slider

function Slider:new(x, y, width, height, minValue, maxValue, initialValue, onSliderValueChanged)
    local slider = setmetatable({}, Slider)
    slider.x = x
    slider.y = y
    slider.width = width
    slider.height = height
    slider.minValue = minValue
    slider.maxValue = maxValue
    slider.value = initialValue
    slider.onSliderValueChanged = onSliderValueChanged
    slider.isDragging = false
    return slider
end

function Slider:update(dt)
    local mx, my = love.mouse.getPosition()

    if self.isDragging then
        local newValue = (mx - self.x) / self.width
        newValue = math.max(self.minValue, math.min(self.maxValue, newValue * (self.maxValue - self.minValue) + self.minValue))
        
        if newValue ~= self.value then
            self.value = newValue
            if self.onSliderValueChanged then
                self.onSliderValueChanged(self.value)
            end
        end
    end
end

function Slider:draw()
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1)
    local thumbX = (self.value - self.minValue) / (self.maxValue - self.minValue) * self.width
    love.graphics.rectangle("fill", self.x + thumbX - 10, self.y - 10, 20, self.height + 20) -- Draw the thumb
end

function Slider:mousepressed(x, y, button)
    if button == 1 and x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
        self.isDragging = true
        self:update(0) -- Update the slider immediately
    end
end

function Slider:mousereleased(x, y, button)
    if button == 1 then
        self.isDragging = false
    end
end

return Slider