require "sfml/rbsfml"
require "singleton"

include SFML

class TextureLoader
  include Singleton
  
  def initialize
    @basicdir = "Resource\\Texture\\"
    @names = [
      ["gravel.png","img"],
      ["aim.png","tex"],
      ["graph.png","tex"]
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
    dir = @basicdir.clone
    dir.concat(name)
    texture = Texture.new
    texture.load_from_file dir
    return texture
  end
  
  def load_image_with_name name
    dir = @basicdir.clone
    dir.concat(name)
    img = Image.new
    img.load_from_file dir
    return img
  end
  
  def get_texture name
    result = @textures.fetch(name)
    return result unless result == nil
  end
  
end