load "Block.rb"

class MapLoader
  include Singleton
  
  def initialize #basicly, generates a array of blocks.
    @map_array = Array.new(100, Array.new(100, Array.new(nil)))
    @map_array[0][0][0] = Block.new(Block::BlockID::Gravel, 0, 0 ,0)
  end
  
  
  
  def create_each_block_vertex
    
  end
  
  def get_entire_amap
    return @map_array
  end
  
end