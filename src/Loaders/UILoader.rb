require "sfml/rbsfml"
require "singleton"

include SFML

load "Loaders\\TextureLoader.rb"

class UILoader
  include Singleton
  
  attr_reader :loadedobjs
  def initialize
    @loadedobjs = Array.new
    @textloader = TextureLoader.instance
    resbases = [
      ["text", "Resource\\arial.ttf", "FPS : 0", 15],
      ["text", "Resource\\arial.ttf", "PlayerInfo", 15],
      ["sprite", "aim", false, 32, 32],
      ["circle", "graph", true, 50.0, 200, 200],
      ["rect", 50.0, 1.0, 0, 200, 50, 255],
      ["rect", 630.0, 18.0, 0, 0, 0, 128],
      ["text", "Resource\\arial.ttf", "Command", 10]
      ]
    resbases.each do |info|
      case info.first
      when "text"
        @loadedobjs.push(maketext(info))
      when "sprite"
        @loadedobjs.push(makesprite(info))
      when "circle"
        @loadedobjs.push(makecircle(info))
      when "rect"
        @loadedobjs.push(makerect(info))
      end
    end
  end
  
  def maketext info
    obj_font = Font.new
    obj_font.load_from_file info[1]
    obj = Text.new(info[2], obj_font, info[3])
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
  
  def makecircle info
    texture = @textloader.get_texture(info[1])
    texture.smooth= info[2]
    obj = CircleShape.new(info[3])
    obj.set_texture texture
    obj.texture_rect= Rect.new(0, 0, info[4], info[5])
    return obj
  end
  
  def makerect info
    obj = RectangleShape.new(Vector2.new(info[1], info[2]))
    obj.fill_color= Color.new(info[3], info[4], info[5], info[6])
    return obj
  end
  
end