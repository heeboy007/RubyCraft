require "sfml/rbsfml"
require 'singleton'

include SFML

require_relative "../Misc/TextureLoader.rb"
require_relative "../Misc/ConfigLoader.rb"
require_relative "GUIObjects/DefaultUIObject.rb"
require_relative "GUIObjects/InteractableUIobject.rb"

class PauseUIBuilder
  
  attr_reader :loaded_ui_menu
  attr_accessor :external_ui_callbacks
  
  def initialize width, height
    @loaded_ui_menu = Array.new
    @external_ui_callbacks = Array.new
    @textloader = TextureLoader.instance
    @resbases = [
      ["sprite", "button", false, 256, 64],
      ["text", "Resource\\arial.ttf", "ArialText", 10],
      ["text", "Resource\\AdineKirnberg-Script.ttf", "AdineText", 50],
      ["rect", width.to_f, height.to_f, 0, 0, 0, 75]
    ]
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
  
  def build_ui_objects
    
    #background
    @loaded_ui_menu << DefaultUIobject.new(makerect(@resbases[3]), "Background", 
    lambda do |obj, width, height|
      obj.size= Vector2.new(width.to_f, height.to_f)
    end)
    
    #version....
    @loaded_ui_menu << DefaultUIobject.new(maketext(@resbases[2], ConfigLoader.instance.version), "VersionInfo",
    lambda do |obj, width, height|
      obj.position= Vector2.new(width.to_f - obj.local_bounds.width - 2, height.to_f - obj.local_bounds.height + 29)
    end)
    
    #pause...
    @loaded_ui_menu << DefaultUIobject.new(maketext(@resbases[2], "Pause"), "PauseText",
    lambda do |obj, width, height|
      obj.position= Vector2.new((width.to_f - obj.local_bounds.width)/2, (height.to_f - obj.local_bounds.height)/10)
    end)
    
    #tester
    @loaded_ui_menu << InteractableUIobject.new([makesprite(@resbases[0]), maketext(@resbases[2],"Quit")], 
      "BoxTest", Rect.new(0.36, 0.28, 0.28, 0.12), @external_ui_callbacks[0])
    
    return nil
  end
  
end