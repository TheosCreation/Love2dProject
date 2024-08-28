Text = {}
Text.__index = Text

function Text:new(text, x, y, fontFileName, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY, color)
    local t = setmetatable({}, Text)
    
    -- Create font with the specified fontSize
    t.font = love.graphics.newFont(fontFileName, fontSize)
    t.fontFileName = fontFileName

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
    t.alignment = "center"
    
    -- Wrap text if needed
    if t.wrap then
        t:wrapText()
    end

    return t
end

function Text:wrapText()
    love.graphics.setFont(self.font)
    local width, lines = self.font:getWrap(self.text, self.width)
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

function Text:setAlignment(alignment)
    self.alignment = alignment
end

function Text:setColor(color)
    self.color = color
end

function Text:getColor()
    return self.color
end

function Text:setFontSize(fontSize)
    self.fontSize = fontSize
    self.font = love.graphics.newFont(self.fontFileName, fontSize)
    if self.wrap then
        self:wrapText()
    end
end

function Text:getFontSize()
    return self.fontSize
end

function Text:draw(x, y)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Calculate scale factors based on the reference resolution
    local scaleX = screenWidth / 2400
    local scaleY = screenHeight / 1080

    -- Scale the font size down by the smaller scale factor
    local scaledFontSize = self.fontSize * math.min(scaleX, scaleY)
    local scaledFont = love.graphics.newFont(self.fontFileName, scaledFontSize)

    local textX = self.x * scaleX
    local textY = self.y * scaleY

    local worldTextX = x or textX - (self.width * self.pivotX * scaleX) + (screenWidth * self.anchorX)
    local worldTextY = y or textY- (self.height * self.pivotY * scaleY) + (screenHeight * self.anchorY)

    love.graphics.setFont(scaledFont)  -- Set the scaled font
    love.graphics.setColor(self.color) -- Set the text color
    
    if self.wrap then
        love.graphics.printf(self.text, worldTextX, worldTextY, self.width * scaleX, self.alignment)
    else
        love.graphics.printf(self.text, worldTextX, worldTextY, self.width * scaleX, self.alignment)
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset to default color (white)
end

return Text