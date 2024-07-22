local time = 0
local framerate = 0

scrWidth = 0
scrHeight = 0

ball = {
    x = 0,
    y = 0,
    radius = 10,
    velocity = {
        x = 0,
        y = 0,
    }
}

mousePosition = {
    x = 0,
    y = 0,
}

acceleration = 5
maxSpeed = 1.5
ballSpeed = 0
input = { left = false, right = false, up = false, down = false }

function love.load()
    scrWidth = love.graphics.getWidth()
    scrHeight = love.graphics.getHeight()

    ball.x = scrWidth / 2
    ball.y = scrHeight / 2

    love.window.setTitle("Hello Love")
    love.graphics.setNewFont(24)
end

function love.draw()
    love.graphics.printf("Current Time: " .. math.floor(time), -5, 0, love.graphics.getWidth(), "right")
    love.graphics.printf("FPS: " .. framerate, 5, 0, love.graphics.getWidth(), "left")
    love.graphics.printf("Mouse Position: x: " .. mousePosition.x .. " y: ".. mousePosition.y, 5, 30, love.graphics.getWidth(), "left")
    love.graphics.printf("Speed: "..  ballSpeed, 5, 60, love.graphics.getWidth(), "left")
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end

function love.update(dt)
    framerate = math.floor(1 / dt)
    time = time + dt

    -- Apply movement based on input
    local dx, dy = 0, 0
    if input.right then dx = 1 end
    if input.left then dx = -1 end
    if input.down then dy = 1 end
    if input.up then dy = -1 end
    move(dx, dy, dt)

    ballSpeed = math.abs(ball.velocity.x) + math.abs(ball.velocity.y)

    -- Apply movement
    ball.x = ball.x + ball.velocity.x 
    if ball.x > scrWidth - ball.radius then
        ball.x = scrWidth - ball.radius
        ball.velocity.x = 0
    elseif ball.x < 0 then
        ball.x = 0 + ball.radius
        ball.velocity.x = 0
    end

    ball.y = ball.y + ball.velocity.y
    if ball.y > scrHeight - ball.radius then
        ball.y = scrHeight - ball.radius
        ball.velocity.y = 0
    elseif ball.y < 0 then
        ball.y = 0 + ball.radius
        ball.velocity.y = 0
    end
end

function love.keypressed(key, scancode, isrepeat)
    if scancode == "d" then input.right = true end
    if scancode == "a" then input.left = true end
    if scancode == "s" then input.down = true end
    if scancode == "w" then input.up = true end
end

function love.keyreleased(key, scancode)
    if scancode == "d" then input.right = false end
    if scancode == "a" then input.left = false end
    if scancode == "s" then input.down = false end
    if scancode == "w" then input.up = false end
end

function move(dx, dy, dt)
    -- Update the ball's velocity based on acceleration
    ball.velocity.x = ball.velocity.x + acceleration * dx * dt
    ball.velocity.y = ball.velocity.y + acceleration * dy * dt

    -- Clamp the velocity to maxSpeed
    if ball.velocity.x > maxSpeed then ball.velocity.x = maxSpeed end
    if ball.velocity.x < -maxSpeed then ball.velocity.x = -maxSpeed end
    if ball.velocity.y > maxSpeed then ball.velocity.y = maxSpeed end
    if ball.velocity.y < -maxSpeed then ball.velocity.y = -maxSpeed end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- LMB
        mousePosition.x = x
        mousePosition.y = y
    elseif button == 2 then
        -- RMB
    elseif button == 3 then
        -- MMB
    end
end
