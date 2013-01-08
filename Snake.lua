require 'middleclass'
require 'Point'
require 'PointSet'

Snake = class('Snake')

function Snake:initialize()
   self.head = Point(50, 37)
   self.head_dir = nil

   self.tail = Point(50, 37)
   self.tail_dir = nil

   self.turns = {} -- Pairs of {loc, dir} where the snake turned
   self.body = PointSet() -- Points that are in the snake's body (not counting head / tail)

   self.steps = 0
   self.length = 16 -- Length, including head and tail

   -- Possible states:
   -- start: at start, waiting for a keypress
   -- moving: moving around
   -- dead: hit something, waiting for animation to finish
   self.state = 'start'
end

----------------------------------------

function Snake:update()
   if self.state == 'start' then
      return
   elseif self.state == 'dead' then
      return
   elseif self.state == 'moving' then
      self:move()
   else
      error("Unknown state " .. self.state)
   end
end

function Snake:move()
   assert(self.head_dir)

   local old = self.head
   self.head = self.head + self.head_dir
   self.body:add(old)

   if self:is_dead() then
      print('Dead')
      self.state = 'dead'
      Clock.oneoff(1, Snake.initialize, self)
   end

   if self.steps > self.length-2 then
      self:move_tail()
   else
      self.steps = self.steps + 1
   end
end

function Snake:move_tail()
   while self.turns[1] and self.turns[1].loc == self.tail do
      self.tail_dir = self.turns[1].dir
      table.remove(self.turns, 1)
   end

   self.body:remove(self.tail)
   self.tail = self.tail + self.tail_dir
end

----------------------------------------

function Snake:turn(dir)
   if self.state == 'start' then self.state = 'moving' end
   if self.body:contains(self.head + dir) then return end -- Don't let us instakill

   self.head_dir = dir
      
   self:add_turn(self.head, dir)
end

function Snake:add_turn(loc, dir)
   table.insert(self.turns, { loc=loc, dir=dir })
end

----------------------------------------

function Snake:is_dead()
   return not(self.head >= Point(0,0) and
           self.head < Point(100, 75)) or self.body:contains(self.head)
end

----------------------------------------

return Snake