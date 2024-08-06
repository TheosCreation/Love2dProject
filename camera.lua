local Camera = {
    x = 0,
    y = 0,
    angle = 0,
    scaleX = 1,
    scaleY = 1
}

function Camera:set()
    love.graphics.push()
    love.graphics.rotate(-self.angle)
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Camera:setPosition(x, y)
    self.x = x
    self.y = y
end

function Camera:getPositionX()
    return self.x
end

function Camera:getPositionY()
    return self.y
end

return Camera