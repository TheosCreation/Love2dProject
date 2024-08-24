Slider = {}
Slider.__index = Slider

function Slider:new(x, y, width, height, minValue, maxValue, initialValue, onSliderValueChanged, pivotX, pivotY, anchorX, anchorY)
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
    slider.pivotX = pivotX or 0.5
    slider.pivotY = pivotY or 0.5
    slider.anchorX = anchorX or 0
    slider.anchorY = anchorY or 0
    return slider
end

function Slider:update(dt)
    local mx, my = love.mouse.getPosition()
    local sliderX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local sliderY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY

    if self.isDragging then
        local newValue = (mx - sliderX) / self.width
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
    local sliderX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local sliderY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY

    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle("fill", sliderX, sliderY, self.width, self.height)

    love.graphics.setColor(1, 1, 1)
    local thumbX = (self.value - self.minValue) / (self.maxValue - self.minValue) * self.width
    love.graphics.rectangle("fill", sliderX + thumbX - 10, sliderY - 10, 20, self.height + 20) -- Draw the thumb
end

function Slider:mousepressed(x, y, button)
    local sliderX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local sliderY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY

    if button == 1 and x >= sliderX and x <= sliderX + self.width and y >= sliderY and y <= sliderY + self.height then
        self.isDragging = true
        self:update(0) -- Update the slider immediately
    end
end

function Slider:mousereleased(x, y, button)
    if button == 1 then
        self.isDragging = false
    end
end

function Slider:setPosition(x, y)
    self.x = x
    self.y = y
end

function Slider:getPosition()
    return self.x, self.y
end

function Slider:setSize(width, height)
    self.width = width
    self.height = height
end

function Slider:getSize()
    return self.width, self.height
end

return Slider