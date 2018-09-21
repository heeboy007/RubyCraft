require "opengl"
require "glu"

include Gl
include Glu

#require_relative "Util.rb"
#require_relative "Loaders\\VertexLoader.rb"
require_relative "Loaders\\TextureLoader.rb"
#require_relative "Renderer\\CubeRenderer.rb"
require_relative "Renderer\\MapRenderer.rb"
require_relative "Chunk\\MapManager.rb"

module GLManager #this thing NEEDS to be module!
  include Debug_output
  #include CubeRenderer
  
  def gl_init camera_data
    d_puts "GLManager : gl_init : glInit Start."
    d_puts "GLManager : gl_init : This program use VBO for Rendering."
    
    err_message "GLManager : gl_init : ResourceLoader or Player had a probelm" if camera_data == nil
    
    @camera_data = camera_data
    
    glClearColor(0.3, 0.6, 1.0, 0)
    glClearDepth(1.0)
    
    #glEnable GL_CULL_FACE
    glEnable GL_DEPTH_TEST
    glEnable GL_TEXTURE_2D
    glDepthMask GL_TRUE
    glDepthFunc GL_LESS
    glShadeModel GL_SMOOTH
    #glFrontFace GL_CCW
    
    glViewport(0, 0, @width, @height)
    
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    
    gluPerspective(60, @width / @height, 0.1, 100.0)
     
    glMatrixMode GL_MODELVIEW
    glLoadIdentity
    
    texture = glGenTextures(1)
    tex_data = TextureLoader.instance.get_texture("gravel")
    glBindTexture(GL_TEXTURE_2D, texture[0])
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexImage2D(
      GL_TEXTURE_2D, 0, GL_RGBA,
      tex_data.size.x, tex_data.size.y,
      0,
      GL_RGBA, GL_UNSIGNED_BYTE, tex_data.pixels
    )
    glGenerateMipmap GL_TEXTURE_2D
    
    un_bind_buffer
    
    @map_manager = MapManager.new texture
    un_bind_buffer
  end
  
  def gl_reshape width,height
    d_puts "GLManager : gl_reshape : Reshape GL by #{width},#{height}."
    height = 1 if height == 0
    aspect = width.to_f / height.to_f;
    
    glViewport 0, 0, width, height
    glMatrixMode GL_PROJECTION
    glLoadIdentity
    
    gluPerspective(60, aspect, 1.0, 100.0)
    
    glMatrixMode GL_MODELVIEW  
    
    reload_camera(1)
  end
  
  def draw_3d_objs
    glEnableClientState(GL_VERTEX_ARRAY)
    glEnableClientState(GL_TEXTURE_COORD_ARRAY)
    
    @map_manager.draw_map
    
    glDisableClientState(GL_VERTEX_ARRAY)
    glDisableClientState(GL_TEXTURE_COORD_ARRAY)
    
    #after drawing, unbind the buffer.
    un_bind_buffer
  end
  
  def un_bind_buffer
    glBindBuffer(GL_ARRAY_BUFFER, 0)
  end
  
  def update_camera
    #warning! This function calls are ORDERED!
    #if you don't have any idea what you're editing, don't do it!
    reload_camera #TODO: Fix to make camera up right. very unefficient algorithm.
    
    vec = @camera_data.CameraXaxis
    glRotatef(@camera_data.xspin, vec.x, 0.0, vec.z) #X rotate
    glRotatef(@camera_data.yspin, 0.0, 1.0, 0.0) #Y rotate
    
    # camera back to player pos and calculate speed 
    glTranslatef(-(@camera_data.pos.x + @camera_data.speed.x), -(@camera_data.pos.y + @camera_data.speed.y), -(@camera_data.pos.z + @camera_data.speed.z)) 
  end
  
  def reload_camera mode = 0, x = 0, y = 0, z = 0 #relocate, spins the camera (This method is called on resize)
    glLoadIdentity #locate the camera at 0, 0, 0
    gluLookAt(0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0) # make up vector as 0.0, 1.0, 0.0
    glRotatef(@camera_data.theta, 1.0, 0.0, 0.0) #X rotate
    glRotatef(@camera_data.phi, 0.0, 1.0, 0.0) #Y rotate
    
    glTranslatef(-@camera_data.pos.x, -@camera_data.pos.y, -@camera_data.pos.z) if mode == 1 #Resize : camera back to player pos
    glTranslatef(-x, -y, -z) if mode == 2 #Command : camera teleport
  end
  
  def clear_window
    glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
  end
  
  def check_gl_version
    res = ConfigLoader.instance
    context_ver_major = glGetDoublev(GL_MAJOR_VERSION).to_i
    context_ver_minor = glGetDoublev(GL_MINOR_VERSION).to_i
    d_puts "GLManager : check_gl_version : Fetched context version is #{context_ver_major}.#{context_ver_minor}."
    
    #check if versions are matched with the previous config
    err_message "GL Version to low." if  (10 * context_ver_major + context_ver_minor) < (10 * res.config.major_version + res.config.minor_version)
  end
  
  def clean_buffers
    @map_manager.delete_texture_buffers
  end
  
end