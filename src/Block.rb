load "Loaders\\VertexLoader.rb"

class Block
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :id
  attr_accessor :vertex_information
  
  module BlockID
    Air = 0 #Dummy code
    Gravel = 1
  end
  
  def initialize id, x, y, z
    @id = id
    @x, @y, @z = x, y, z
    @vertex_information = VertexLoader.instance.return_vertex_with_cord(@x, @y, @z)
  end
  
  def is_vertex_cord_initalized?
    return @vertex_information == nil
  end
  
end