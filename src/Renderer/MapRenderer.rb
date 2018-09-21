require_relative "CubeRenderer.rb"

class MapRenderer
  include CubeRenderer
  #include Singleton
  
  def initialize textures
    cube_init
    un_bind_buffer
    
    @textures = textures
  end
  
  #0 = bottom
  #1 = z-
  #2 = x-
  #3 = x+
  #4 = z+
  #5 = top
  
  def render_map_of array
    array.each { |block| drawcube(block.vertex_information, block.facing_information, @textures[0]) if block != nil }
  end
  
  def un_bind_buffer
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
end
