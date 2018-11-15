-- Rodar o jogo no Sublime: Ctrl + B
function love.load()
  --criar uma tabela chamada Sprites, onde vai carregar todos os sprites do jogo
  sprites = {}
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.bullet = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')

  player = {}
  player.x = 100
  player.y = 100
  player.speed = 180

  --criar uma tabela para cada zombie e depois armazenar todas elas numa outra tabela
  --para que cada zombie possa se mover de forma diferente, etc.
  zombies = {}
  bullets = {}
  

end

function love.update(dt)
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end

  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  end

  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end

  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end

  -- função que faz o zumbi se mover:
  for i,z in ipairs(zombies) do 
    -- estamos olhando para o valor do x do zumbi atual e aumentando-o pelo valor x calculado a partir do
    -- círculo unitário usando a direção dos zumbis, e obtemos a direção dos zumbis utilizando a função zombie_player_angle
    z.x = z.x + math.cos(zombie_player_angle(z)) * z.speed * dt
    z.y = z.y + math.sin(zombie_player_angle(z)) * z.speed * dt

    -- para checar se existe colisão entre o player e o zombie:
    if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
      for i,z in ipairs(zombies) do 
        zombies[i] = nil
      end
    end
  end

  for i,b in ipairs(bullets) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end

  -- o # representa que o que virá em seguida é o nome de uma tabela
  -- o que vai retornar é o número de elementos dessa tabela
  for i=#bullets, 1, -1 do
    
  end

end

function love.draw()
  --a ordem dos elementos no draw determina qual será desenhado atrás do outro
  love.graphics.draw(sprites.background, 0, 0)
  --drawable parameter: objeto desenhável
  love.graphics.draw(sprites.player, player.x, player.y, player_mouse_angle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

  --passa por todos os objetos da tabela zombies, onde z se refere com zumbi que estamos "olhando"
  for i,z in ipairs(zombies) do
    love.graphics.draw(sprites.zombie, z.x, z.y, zombie_player_angle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
  end

  for i, b in ipairs(bullets) do
    love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
  end
end

function player_mouse_angle()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

--passar como parâmetro ENEMY para a função saber qual zumbi estamos olhando no momento
--porque existirão muitos zumbis ao mesmo tempo, e cada um deve ter um movimento diferente
function zombie_player_angle(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
  zombie = {}
  --gerar zumbi em pontos aleatórios da tela
  zombie.x = math.random(0, love.graphics.getWidth())
  zombie.y = math.random(0, love.graphics.getHeight())
  zombie.speed = 100
  --insere na tabela Zombies todo o conteúdo da tabela Zombie
  table.insert(zombies, zombie)
end

function love.mousepressed(x, y, b, istouch)
  if b == 1 then
    spawnBullet()
  end
end

function spawnBullet() 
  bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.direction = player_mouse_angle()

  table.insert(bullets, bullet)
end

--função que vai fazer aparecer um zumbi a cada vez que pressionarmos o botão space
function love.keypressed(key)
  if key == "space" then
    spawnZombie()
  end
end

function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y1 - y2)^2 + (x2 - x1)^2)
end
