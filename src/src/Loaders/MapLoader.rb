require_relative '..\\Block.rb'

class MapLoader
  include Singleton
  
  attr_accessor :map_array
  
  def initialize #basicly, generates a array of blocks.
    @map_array = Array.new()
    
    #genterate a default block.
    @map_array << Block.new(Block::BlockID::Gravel,0.0, 0.0, 0.0)
  end
  
  def add_render_obj obj
    @map_array << obj
  end
  
  def add_render_block x, y, z
    @map_array << Block.new(Block::BlockID::Gravel, x, y, z)
  end
  
  def delete_render_block x, y, z
    @map_array.map { |block| @map_array.delete(block) if block.x == x.to_f && block.y == y.to_f && block.z == z.to_f }
  end
  
  def get_entire_amap
    return @map_array
  end
  
end