require "mathn"

include Math

require_relative "../Misc/Util.rb"
require_relative "../World/MapManager.rb"
require_relative "General_Maths.rb"

class RayTracer
  include General_Maths
  
  def is_there_a_block? x, y, z
    return false if MapManager.instance.get_block_at(x, y, z) == nil
    return true
  end
  
  def next_pos pitch, yaw
    scaler = 0.01
    
    @end_pos.x += sin(yaw.degrees) * scaler
    @end_pos.y -= tan(pitch.degrees) * scaler
    @end_pos.z -= cos(yaw.degrees) * scaler
  end 
  
  def get_block_info_updater
    updater = lambda do |obj|
      obj.string= "Traced Block : Empty"
      obj.string= "Traced Block : #{@end_pos.x.floor}, #{@end_pos.y.floor}, #{@end_pos.z.floor}" if End_Point.instance.is_a_block_there
    end
    
    return updater
  end
  
  def ray_trace pos, pitch, yaw, for_destroy = true
    @end_pos = Vector3.new(pos)
    @before_pos = Vector3.new(pos)
    #0.01 point step..... well this whole algorythm has a "MAJOR" flaw, but i woudln't bother about it.
    End_Point.instance.is_a_block_there= true
    1000.times do 
      @before_pos.x = @end_pos.x
      @before_pos.y = @end_pos.y
      @before_pos.z = @end_pos.z
      next_pos(pitch, yaw)
      End_Point.instance.before_point= @before_pos
      End_Point.instance.end_point= @end_pos
      x = @end_pos.x.floor
      y = @end_pos.y.floor
      z = @end_pos.z.floor
      return if is_there_a_block?(x, y, z)
    end
    End_Point.instance.is_a_block_there= false
    return 
  end
  
end