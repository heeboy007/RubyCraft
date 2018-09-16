require "opengl"
require "glu"

include Gl
include Glu

load "Loaders\\VertexLoader.rb"

module CubeRenderer
  
  def cube_init
    #@vertex = VertexLoader.instance.cube
    texvec = VertexLoader.instance.texture
    @vbo = glGenBuffers(1)#for not crashing.
    @texv = glGenBuffers(1)#we will use same texture every side.
    glBindBuffer(GL_ARRAY_BUFFER, @texv[0])
    glBufferData(GL_ARRAY_BUFFER, texvec.size, texvec, GL_STATIC_DRAW)
  end
  
  def assign_with_given_vertex packed_vertex
    clear_vertex_buffers
    packed_vertex.each_with_index do |vtx,idx_vertex|
      glBindBuffer(GL_ARRAY_BUFFER, @vbo[idx_vertex])
      glBufferData(GL_ARRAY_BUFFER, vtx.size, vtx, GL_STATIC_DRAW)
    end
  end
  
  def drawcube p_vertex, p_side, p_texture
    assign_with_given_vertex p_vertex
    p_side.each_with_index do |draw,idx|
      if draw
        #GL can handle 5 array's at once.
        #Enabling 2 for vertex, texture.
        glEnableVertexAttribArray(0)
        glEnableVertexAttribArray(1)
        
        #bind the buffer that we currently have.(vertex)
        #Use the selected buffer to vertex drawings.
        #(0 = arraynumber, 3 = elements in array, GL_FLOAT = for float format, GL_FALSE = not normalized, 0, 0)
        glBindBuffer(GL_ARRAY_BUFFER, @vbo[idx])
        glVertexPointer(3, GL_FLOAT, 0, 0)
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0)
        
        glBindBuffer(GL_ARRAY_BUFFER, @texv[0])
        glTexCoordPointer(2, GL_FLOAT, 0, 0)
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, 0)
        
        #The actual drawing. Use everything in our hands to draw.
        glEnable(GL_TEXTURE_2D)
        
        #Use the texture given.
        glBindTexture(GL_TEXTURE_2D, p_texture)
        glDrawArrays(GL_QUADS, 0, 4)
        
        glDisable(GL_TEXTURE_2D)
        
        #After on call, you should disable these for sfml and global gl issues.
        glDisableVertexAttribArray(0)
        glDisableVertexAttribArray(1)
      end
    end
    #Whatever we do, disable the buffers.
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
  def clear_vertex_buffers
    glDeleteBuffers(@vbo)
    @vbo = glGenBuffers(6)
  end
  
  def delete_texture_buffers
    glDeleteBuffers(@vbo)
    glDeleteBuffers(@texv)
  end
  
end