Text = {}
Text.__index = Text

function Text:new(text, x, y, font, fontSize, width, height, wrap)
    local t = setmetatable({}, Text)
    
    -- Create or set the font
    if type(font) == "string" then
        t.font = love.graphics.newFont(font, fontSize)
    else
        t.font = font or love.graphics.newFont(fontSize)
    end

    t.text = text
    t.x = x
    t.y = y
    t.fontSize = fontSize
    t.width = width
    t.height = height
    t.wrap = wrap
    t.textWrapped = {}

    -- Wrap text if needed
    if t.wrap then
        t:wrapText()
    end

    return t
end

function Text:wrapText()
    -- Ensure the font is set before wrapping text
    love.graphics.setFont(self.font, self.fontSize)
    
    -- Wrap text using the specified width
    local lines = love.graphics.getFont():getWrap(self.text, self.width)
    
    -- Ensure lines is a table
    if type(lines) == "table" then
        self.textWrapped = lines
    else
        -- Handle the case where getWrap does not return a table
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

function Text:draw()
    love.graphics.setFont(self.font, self.fontSize)
    
    if self.wrap then
        -- Draw each line of wrapped text
        for i, line in ipairs(self.textWrapped) do
            love.graphics.print(line, self.x, self.y + (i - 1) * self.font:getHeight())
        end
    else
        -- Draw the single line of text
        love.graphics.print(self.text, self.x, self.y)
    end
end

return Text