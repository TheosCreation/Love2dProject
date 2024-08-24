local TextureManager = {}

TextureManager.textures = {}

-- Load the texture from a file
function TextureManager:loadTextureFromFile(name, filepath)
    self.textures[name] = love.graphics.newImage(filepath)
end

function TextureManager:getTexture(name)
    return self.textures[name]
end

return TextureManager