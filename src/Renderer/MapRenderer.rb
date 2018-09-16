load "Loaders\\MapLoader.rb"
load "Renderer\\CubeRenderer.rb"

class MapRenderer
  include CubeRenderer
  #include Singleton
  
  def initialize textures
    cube_init
    un_bind_buffer
    
    size = 16
    @map_loader = MapLoader.instance
    @textures = textures
  end
  
  def render_map
    @map_loader.map_array.each_with_index do |block, index|
      if block != nil
        #0 = bottom
        #1 = z-
        #2 = x-
        #3 = x+
        #4 = z+
        #5 = top
        sides = Array.new(6,true)
        
        #block.vertex_information= return_vertex_with_cord(block.x, block.y, block.z) if block.is_vertex_cord_initalized?
        drawcube(block.vertex_information, sides, @textures[0])
      end
    end
  end
  
  def get_block_facing x, y, z
    
  end
  
  def un_bind_buffer
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
end
