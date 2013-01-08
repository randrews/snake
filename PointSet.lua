require 'middleclass'
require 'Point'

PointSet = class('PointSet')

function PointSet:initialize()
   self.cols = {}
end

function PointSet:clear()
   self:initialize()
end

function PointSet:add(pt)
   assert(instanceOf(Point, pt), "Can only add points")

   if self.cols[pt.x] then
      self.cols[pt.x][pt.y] = true
   else
      self.cols[pt.x] = {[pt.y] = true}
   end

   return self
end

function PointSet:remove(pt)
   assert(instanceOf(Point, pt), "Can only remove points")

   if self.cols[pt.x] then
      self.cols[pt.x][pt.y] = nil
   end

   return self
end

function PointSet:contains(pt)
   assert(instanceOf(Point, pt), "Can only contain points")
   return self.cols[pt.x] and self.cols[pt.x][pt.y]
end

function PointSet:points()
   local pts, curr, i = {}, nil, nil

   for x, col in pairs(self.cols) do
      for y in pairs(col) do
         pts[#pts+1] = Point(x,y)
      end
   end

   return function()
                i, curr = next(pts, i)
                return curr
             end
end