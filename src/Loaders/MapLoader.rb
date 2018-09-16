load "Block.rb"

class MapLoader
  include Singleton
  
  attr_accessor :map_array
  
  def initialize #basicly, generates a array of blocks.
    @map_array = Array.new()
    
    #genterate a default block.
    @map_array << Block.new(Block::BlockID::Gravel,0.0, 0.0, 0.0)
  end
  
  def add_render_obj obj
    @map_array.append(obj)
  end
  
  def get_entire_amap
    return @map_array
  end
  
end