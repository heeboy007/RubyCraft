require "sfml/rbsfml"

include SFML

require_relative "../Misc/TextureLoader.rb"

class UIBuilder
  
  def initialize builder_name
    @builder_name = builder_name
    @textloader = TextureLoader.instance
  end
  
  def maketext info, initial_text = nil
    obj_font = Font.new
    obj_font.load_from_file info[1]
    if initial_text == nil
      obj = Text.new(info[2], obj_font, info[3]) 
    else
      obj = Text.new(initial_text, obj_font, info[3])
    end
    return obj
  end
  
  def makesprite info
    texture = @textloader.get_texture(info[1])
    texture.smooth= info[2]
    obj = Sprite.new
    obj.set_texture texture
    obj.texture_rect= Rect.new(0, 0, info[3], info[4])
    return obj
  end
  
  def makerect info
    obj = RectangleShape.new(Vector2.new(info[1], info[2]))
    obj.fill_color= Color.new(info[3], info[4], info[5], info[6])
    return obj
  end
  
  def makecircle info
    texture = @textloader.get_texture(info[1])
    texture.smooth= info[2]
    obj = CircleShape.new(info[3])
    obj.set_texture texture
    obj.texture_rect= Rect.new(0, 0, info[4], info[5])
    return obj
  end
  
end