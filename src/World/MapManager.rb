require_relative "..\\Renderer\\MapRenderer.rb"
require_relative "Chunk.rb"
require_relative "..\\Block.rb"

class MapManager
  include Singleton
  
  def map_init texture
    @map_renderer = MapRenderer.new texture
    @chunk = Chunk.new 0, 0, 0
    @chunk.add_block_at 0, 0, 0, Block.new(Block::BlockID::Gravel, 0, 0, 0, @chunk)
    @chunk.add_block_at 0, 0, 1, Block.new(Block::BlockID::Gravel, 0, 0, 1, @chunk)
  end
  
  def add_block_at x, y, z, id = Block::BlockID::Gravel
    @chunk.add_block_at x, y, z, Block.new(id, x, y, z, @chunk)
  end
  
  def destroy_block_at x, y, z
    @chunk.delete_block_at x, y, z
  end
  
  def draw_map
    @map_renderer.render_map_of @chunk.make_single_dimen_block_map
  end
  
  def delete_texture_buffers
    @map_renderer.delete_texture_buffers
  end
  
end