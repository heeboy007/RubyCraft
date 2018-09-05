load "Loaders\\MapLoader.rb"
load "Renderer\\CubeRenderer.rb"

class MapRenderer
  include CubeRenderer
  #include Singleton
  
  def initialize textures
    size = 16
    @map_array = Array.new(size, Array.new(size, Array.new(size, nil)))
    #7.times { |idx| @map_array[idx][idx][idx] = Block.new(Block::BlockID::Gravel, idx, idx, idx)}
    
    @map_array[0][0][0] = Block.new(Block::BlockID::Gravel, 0, 0, 0)
    
    #@map_loader = MapLoader.new
    @textures = textures
    
    cube_init
    un_bind_buffer
  end
  
  def render_map
    
    @map_array.each_with_index do |arry, x|
      arry.each_with_index do |arrz, y|
        arrz.each_with_index do |block, z|
          if block != nil
            block.vertex_information= return_vertex_with_cord(x, y, z) if block.is_vertex_cord_initalized?
            drawing = Array.new(6,true)
    
            #0 = bottom
            #1 = z-
            #2 = x-
            #3 = x+
            #4 = z+
            #5 = top
            
            #drawing[4] = false
            
            assign_with_given_vertex block.vertex_information
            drawcube(drawing, @textures[0])
          end
        end
      end
    end
    
  end
  
  def get_block_facing x, y, z
    each_facing = Array.new(6,true)
    
    
    
    return @map_array[x][y][z]
  end
  
  def un_bind_buffer
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
end
