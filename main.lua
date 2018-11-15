-- the same as Start function in C#
function love.load()
  button = {}
  button.x = 200
  button.y = 200
  button.size = 50

  score = 0
  timer = 10
  gameState = 1

  myFont = love.graphics.newFont(40)
end

-- updates 60 frames per second
function love.update(dt)
  if gameState == 2 then
    if timer > 0 then
      timer = timer - dt
    end
    if timer < 0 then
      timer = 0
      gameState = 1
      score = 0
    end
  end
end

-- used to draw graphics
function love.draw()
  if gameState == 2 then
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", button.x, button.y, button.size)
  end

  love.graphics.setFont(myFont)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Score: " .. score)
  -- math.ceil é usado para arredondar os valores (tirar as casas depois da vírgula)
  love.graphics.print("Time: " .. math.ceil(timer), 300, 0)

  if gameState == 1 then
    love.graphics.printf("Click anywhere to begin!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
  end

end

function love.mousepressed(x, y, b, isTouch)
  -- 1: mouse is pressed
  if b == 1 and gameState == 2 then
    -- vai calcular a distância entre o button da tela e o mouse, pra saber se tá clicando
    -- na região do button somente
    if distanceBetween(button.x, button.y, love.mouse.getX(), love.mouse.getY()) < button.size then
      score = score + 1
      -- love.graphics.getWidth: pega o Width da tela, independente do tamanho dela.
      button.x = math.random(button.size, love.graphics.getWidth() - button.size)
      button.y = math.random(button.size, love.graphics.getHeight() - button.size)
    end
  end

  if gameState == 1 then
    gameState = 2
    timer = 10
  end
end

function distanceBetween(x1, y1, x2, y2)
  -- square root (raiz quadrada)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
