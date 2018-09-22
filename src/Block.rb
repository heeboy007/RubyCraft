require_relative "Loaders\\VertexLoader.rb"

class Block
  #attr_accessor :X
  #attr_accessor :Y
  #attr_accessor :Z
  attr_accessor :facing_update
  attr_accessor :facing_information
  attr_reader :Id
  attr_accessor :vertex_information
  #attr_accessor :Chunk_handler
  
  module BlockID
    Air = 0 #Dummy code
    Gravel = 1
  end
  
  def initialize id, x, y, z, chunk_handler
    #chunk_handler.add_block_at(x, y, z, self)
    @Id = id
    @Chunk_handler = chunk_handler
    @X, @Y, @Z = x, y, z
    @facing_update = true
    @facing_information = chunk_handler.update_blocks_fetch_facing(x, y, z, true)
    @vertex_information = VertexLoader.instance.return_vertex_with_cord(x, y, z)
  end
  
  def update_facing fracing_index, is_placing
    #infinite loop.
    #@facing_information = @Chunk_handler.get_block_adj(@X, @Y, @Z)
    @facing_information[fracing_index] = !is_placing
  end
  
  #no use right now.
  def update_vertex
    @vertex_information = VertexLoader.instance.return_vertex_with_cord(@X, @Y, @Z)
  end
  
  def is_vertex_cord_initalized?
    return @vertex_information == nil
  end
  
end