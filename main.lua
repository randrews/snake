require 'Point'
require 'Clock'
require 'Snake'

local player = Snake()

----------------------------------------

function love.load()
   love.graphics.setBackgroundColor(120, 157, 245)
   Clock(0.1, player.update, player)
end

function love.update(dt)
   Clock.update(dt)
end

function love.keypressed(key)
   local new_dir = Point[key]
   if new_dir then
      player:turn(new_dir)
   end
end

function love.draw()
   local g = love.graphics

   g.clear()

   g.setColor(255, 255, 255)
   for pt in player.body:points() do
      local x, y = (pt * 8)()
      g.rectangle('fill', x, y, 8, 8)
   end

   local x, y = (player.head * 8 + Point(4,4))()
   g.setColor(255, 80, 80)
   g.circle('fill', x, y, 4)
end
