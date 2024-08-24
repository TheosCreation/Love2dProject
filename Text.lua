Text = {}
Text.__index = Text

function Text:new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY, color)
    local t = setmetatable({}, Text)
    
    -- Create or set the font with the specified fontSize
    if type(font) == "string" then
        t.font = love.graphics.newFont(font, fontSize)
    else
        t.font = font or love.graphics.newFont(fontSize)
    end

    t.text = text
    t.x = x
    t.y = y
    t.width = width
    t.height = height
    t.wrap = wrap
    t.textWrapped = {}
    t.pivotX = pivotX or 0.5
    t.pivotY = pivotY or 0.5
    t.anchorX = anchorX or 0
    t.anchorY = anchorY or 0
    t.color = color or {1, 1, 1, 1} -- Default to white color (RGBA)
    t.fontSize = fontSize -- Store the font size

    -- Wrap text if needed
    if t.wrap then
        t:wrapText()
    end

    return t
end

function Text:wrapText()
    love.graphics.setFont(self.font)
    local lines = love.graphics.getFont():getWrap(self.text, self.width)
    if type(lines) == "table" then
        self.textWrapped = lines
    else
        self.textWrapped = {self.text}
    end
end

function Text:setText(text)
    self.text = text
    if self.wrap then
        self:wrapText()
    end
end

function Text:getText()
    return self.text
end

function Text:setPosition(x, y)
    self.x = x
    self.y = y
end

function Text:getPosition()
    return self.x, self.y
end

function Text:setSize(width, height)
    self.width = width
    self.height = height
    if self.wrap then
        self:wrapText()
    end
end

function Text:getSize()
    return self.width, self.height
end

function Text:setColor(color)
    self.color = color
end

function Text:getColor()
    return self.color
end

function Text:setFontSize(fontSize)
    self.fontSize = fontSize
    self.font = love.graphics.newFont(self.font:getFilename(), fontSize)
    if self.wrap then
        self:wrapText()
    end
end

function Text:getFontSize()
    return self.fontSize
end

function Text:draw()
    local textX = self.x - self.width * self.pivotX + love.graphics.getWidth() * self.anchorX
    local textY = self.y - self.height * self.pivotY + love.graphics.getHeight() * self.anchorY

    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color) -- Set the text color
    
    if self.wrap then
        for i, line in ipairs(self.textWrapped) do
            love.graphics.print(line, textX, textY + (i - 1) * self.font:getHeight())
        end
    else
        love.graphics.print(self.text, textX, textY)
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset to default color (white)
end

return Text