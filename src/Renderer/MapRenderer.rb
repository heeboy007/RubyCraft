require "opengl"
require "glu"

include Gl
include Glu

class MapRenderer
  
  def initialize textures
    vertex_buffer_init
    glBindBuffer(GL_ARRAY_BUFFER, 0)
    
    @textures = textures
  end
  
  def vertex_buffer_init
    @vbo = glGenBuffers(1)#for not crashing.
    @texv = glGenBuffers(1)#we will use same texture every side.
  end
  
  def make_VBO_with_given_vertex packed_vertex, packed_tex_cord
    delete_all_buffers
    @vbo = glGenBuffers(1)
    glBindBuffer(GL_ARRAY_BUFFER, @vbo[0])
    glBufferData(GL_ARRAY_BUFFER, packed_vertex.size, packed_vertex, GL_STATIC_DRAW)
    
    @texv = glGenBuffers(1)
    glBindBuffer(GL_ARRAY_BUFFER, @texv[0])
    glBufferData(GL_ARRAY_BUFFER, packed_tex_cord.size, packed_tex_cord, GL_STATIC_DRAW)
  end
  
  def draw_by_packed_vertex packed_vertex, texture, p_tex_cord
    make_VBO_with_given_vertex packed_vertex, p_tex_cord
    #GL can handle 5 array's at once.
    #Enabling 2 for vertex, texture.
    glEnableVertexAttribArray(0)
    glEnableVertexAttribArray(1)
    #bind the buffer that we currently have.(vertex)
    #Use the selected buffer to vertex drawings.
    #(0 = arraynumber, 3 = elements in array, GL_FLOAT = for float format, GL_FALSE = not normalized, 0, 0)
    glBindBuffer(GL_ARRAY_BUFFER, @vbo[0])
    glVertexPointer(3, GL_FLOAT, 0, 0)
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0)
      
    glBindBuffer(GL_ARRAY_BUFFER, @texv[0])
    glTexCoordPointer(2, GL_FLOAT, 0, 0)
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, 0)
        
    #The actual drawing. Use everything in our hands to draw.
    glEnable(GL_TEXTURE_2D)
        
    #Use the texture given.
    #puts p_texture.class.name
    glBindTexture(GL_TEXTURE_2D, texture)
    glDrawArrays(GL_QUADS, 0, packed_vertex.size / 12)
    
    glDisable(GL_TEXTURE_2D)
    #After on call, you should disable these for sfml and global gl issues.
    glDisableVertexAttribArray(0)
    glDisableVertexAttribArray(1)
    #Whatever we do, disable the buffers.
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
  def delete_all_buffers
    glDeleteBuffers(@vbo)
    glDeleteBuffers(@texv)
  end
  
  def render_map_of chunk_vertex, tex_cord
    draw_by_packed_vertex chunk_vertex, @textures[0], tex_cord
  end
  
end
