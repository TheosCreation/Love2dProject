local ShaderManager = {}

ShaderManager.shaders = {}

-- Load the shader from a file
function ShaderManager:loadShaderFromFile(name, filepath)
    local file = love.filesystem.read(filepath)
    if not file then
        error("Shader file " .. filepath .. " not found!")
    end
    self.shaders[name] = love.graphics.newShader(file)
end

function ShaderManager:getShader(name)
    return self.shaders[name]
end

return ShaderManager