require "mathn"

include Math

module General_Maths
  
  def get_distance from_here, to_there 
    return sqrt((from_here.x - to_there.x)**2 + (from_here.y - to_there.y)**2 + (from_here.z - to_there.z)**2)
  end
  
  def is_in_range? x, y, x_in_here, y_in_here
    if x_in_here[0] <= x && x <= (x_in_here[0] + x_in_here[1]) && y_in_here[0] <= y && y <= (y_in_here[0] + y_in_here[1])
      return true
    end
    return false
  end
  
end

class End_Point
  include Singleton 
  
  attr_accessor :end_point
  attr_accessor :before_point
  attr_accessor :is_a_block_there
  
  def initialize
    @end_point = Vector3.new(0, 0, 0)
    @before_point = Vector3.new(0, 0, 0)
    @is_a_block_there = false
  end
  
end