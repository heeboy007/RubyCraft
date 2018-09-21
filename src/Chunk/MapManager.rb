require_relative "..\\Renderer\\MapRenderer.rb"
require_relative "..\\Chunk\\Chunk.rb"
require_relative "..\\Block.rb"

class MapManager
  
  def initialize texture
    @map_renderer = MapRenderer.new texture
    @chunk = Chunk.new
    Block.new(Block::BlockID::Gravel, 0, 0, 0, @chunk)
    Block.new(Block::BlockID::Gravel, 0, 0, 1, @chunk)
  end
  
  def draw_map
    @map_renderer.render_map_of @chunk.make_single_dimen_block_map
  end
  
  def delete_texture_buffers
    @map_renderer.delete_texture_buffers
  end
  
end