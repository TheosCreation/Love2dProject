Scene = {}
Scene.__index = Scene

function Scene:new()
    local scene = setmetatable({}, Scene)
    scene.objects = {} -- Store all objects in the scene
    return scene
end

function Scene:addObject(object)
    table.insert(self.objects, object)
end

function Scene:update(dt)
    for _, object in ipairs(self.objects) do
        if object.update then
            object:update(dt)
        end
    end
end

function Scene:draw()
    for _, object in ipairs(self.objects) do
        if object.draw then
            object:draw()
        end
    end
end

function Scene:mousepressed(x, y, button)
    for _, object in ipairs(self.objects) do
        if object.mousepressed then
            object:mousepressed(x, y, button)
        end
    end
end

function Scene:mousereleased(x, y, button)
    for _, object in ipairs(self.objects) do
        if object.mousereleased then
            object:mousereleased(x, y, button)
        end
    end
end

return Scene