require "sfml/rbsfml"
require "singleton"
require "opengl"
require "glu"

include Gl
include Glu
include SFML

class TextureLoader
  include Singleton
  
  def initialize
    @basedir = "Resource/Texture/"
    @names = [
      ["texture_0.png","img"], #imgs are for 3d drawing only...
      ["aim.png","tex"],
      ["graph.png","tex"],
      ["button.png","tex"],
      ["drager.png","tex"]
    ]
    @textures = Hash.new
    
    @names.each do |name|
      tex = load_texture_with_name(name[0]) if name[1] == "tex"
      tex = load_image_with_name(name[0]) if name[1] == "img"
      #store in hash, as (name(key), texinstance(value))
      @textures.store(name[0].chomp('.png'), tex)
    end
    
  end
  
  def load_texture_with_name name
    dir = @basedir.clone
    dir.concat(name)
    texture = Texture.new
    texture.load_from_file dir
    return texture
  end
  
  def load_image_with_name name
    dir = @basedir.clone
    dir.concat(name)
    img = Image.new
    img.load_from_file dir
    return img
  end
  
  def get_texture name
    result = @textures.fetch(name)
    return result unless result == nil
  end
  
  def make_gl_texture_image
    image = get_texture("texture_0")
    
    texture = glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D, texture[0])
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexImage2D(
      GL_TEXTURE_2D, 0, GL_RGBA,
      image.size.x, image.size.y,
      0, GL_RGBA, GL_UNSIGNED_BYTE, image.pixels
    )
    glGenerateMipmap GL_TEXTURE_2D
    
    return texture
  end
  
end