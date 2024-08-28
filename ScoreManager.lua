local ScoreManager = {}

-- Path to the file where the score is saved
local scoreFilePath = "highest_score.txt"

function ScoreManager:saveScore(score)
    local file = love.filesystem.newFile(scoreFilePath, "w")
    local file = love.filesystem.newFile(scoreFilePath, "w")
    if file then
        file:write(tostring(score))  -- Convert score to string
        file:close()
    else
        print("Error: Unable to save score.")
    end
end

function ScoreManager:loadScore()
    if love.filesystem.getInfo(scoreFilePath) then
        local file = love.filesystem.newFile(scoreFilePath, "r")
        local content = file:read()  -- Read content as string
        file:close()
        return tonumber(content) or 0  -- Convert content to number, default to 0 if conversion fails
    else
        return 0
    end
end

return ScoreManager
