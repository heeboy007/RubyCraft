require "mathn"

include Math

module General_Maths
  
  def get_distance from_here, to_there 
    return sqrt((from_here.x - to_there.x)**2 + (from_here.y - to_there.y)**2 + (from_here.z - to_there.z)**2)
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