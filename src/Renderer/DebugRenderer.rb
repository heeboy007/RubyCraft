require "opengl"
require "glu"

include Gl
include Glu

class DebugRenderer
  include Singleton
  
  attr_writer :flag_render_debug_settings
  
  def initialize 
    @line_vao = [0,0,0,0,0,0].pack("f*")
    @line_vbo = glGenBuffers(1)
    @flag_render_debug_settings = false
  end
  
  def set_line_cord cord
    @line_vao = cord.pack("f*")
  end
  
  def make_VBO_for_line
    glDeleteBuffers(@line_vbo)
    
    @line_vbo = glGenBuffers(1)
    glBindBuffer(GL_ARRAY_BUFFER, @line_vbo[0])
    glBufferData(GL_ARRAY_BUFFER, @line_vao.size, @line_vao, GL_STATIC_DRAW)
  end
  
  def draw_debug_settings
    render_debug_settings if @flag_render_debug_settings
  end
  
  def render_debug_settings
    make_VBO_for_line
    #Enabling 2 for vertex, texture.
    glEnableVertexAttribArray(0)
    
    glBindBuffer(GL_ARRAY_BUFFER, @line_vbo[0])
    glVertexPointer(3, GL_FLOAT, 0, 0)
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0)
    
    glDrawArrays(GL_LINES, 0, 2)
    
    #After on call, you should disable these for sfml and global gl issues.
    glDisableVertexAttribArray(0)
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
end