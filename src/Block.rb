require_relative "Loaders\\VertexLoader.rb"

class Block
  #attr_accessor :X
  #attr_accessor :Y
  #attr_accessor :Z
  attr_accessor :facing_update
  attr_accessor :facing_information
  attr_accessor :id
  attr_accessor :vertex_information
  #attr_accessor :Chunk_handler
  
  module BlockID
    Air = 0 #Dummy code
    Gravel = 1
  end
  
  def initialize id, x, y, z, chunk_handler
    chunk_handler.add_block_at(x, y, z, self)
    @id = id
    @Chunk_handler = chunk_handler
    @X, @Y, @Z = x, y, z
    @facing_update = true
    @facing_information = chunk_handler.get_block_adj(x, y, z)
    @vertex_information = VertexLoader.instance.return_vertex_with_cord(x, y, z)
  end
  
  def update fracing_index
    #@facing_information = @Chunk_handler.get_block_adj(@X, @Y, @Z)
    @facing_information[fracing_index] = false
    @vertex_information = VertexLoader.instance.return_vertex_with_cord(@X, @Y, @Z)
  end
  
  def is_vertex_cord_initalized?
    return @vertex_information == nil
  end
  
end