require "sfml/rbsfml"
require 'singleton'

include SFML

require_relative "UIBuilder.rb"
require_relative "../Misc/ConfigLoader.rb"
require_relative "GUIObjects/DefaultUIObject.rb"
require_relative "GUIObjects/InteractableUIobject.rb"

class InitialUIBuilder < UIBuilder
  
  attr_reader :loaded_ui_objects
  attr_accessor :external_ui_callbacks
  
  def initialize width, height
    super("init")
    @loaded_ui_objects = Array.new
    @external_ui_callbacks = Array.new
    @resbases = [
      ["sprite", "drager", false, 64, 64],
      ["text", "src\\Resource\\arial.ttf", "ArialText", 32],
      ["text", "src\\Resource\\AdineKirnberg-Script.ttf", "AdineText", 72],
      ["rect", width.to_f, height.to_f, 0, 216, 255, 255]
    ]
  end
  
  def build_ui_objects
    
    @loaded_ui_objects << DefaultUIobject.new(makerect(@resbases[3]), "Background", 
    lambda do |obj, width, height|
      obj.size= Vector2.new(width.to_f, height.to_f)
    end)
    
    @loaded_ui_objects << DefaultUIobject.new(maketext(@resbases[2], "RUBY - Craft"), "Title",
    lambda do |obj, width, height|
      obj.character_size= 100
      obj.position= Vector2.new((width.to_f - obj.local_bounds.width)/2,(height.to_f - obj.local_bounds.height)/2 - 200)
    end)
    
    @loaded_ui_objects << DefaultUIobject.new(maketext(@resbases[2], ConfigLoader.instance.version), "VersionInfo",
    lambda do |obj, width, height|
      obj.position= Vector2.new(width.to_f - obj.local_bounds.width - 2, height.to_f - obj.local_bounds.height + 29)
    end)
    
    @loaded_ui_objects << InteractableUIobject.new([makesprite(@resbases[0]), maketext(@resbases[1],"Play")], 
      "Play_Button", Rect.new(0.30, 0.72, 0.40, 0.08), @external_ui_callbacks[0])
      
    #Quit.
    @loaded_ui_objects << InteractableUIobject.new([makesprite(@resbases[0]), maketext(@resbases[1],"Quit")], 
      "Quit_Button", Rect.new(0.30, 0.82, 0.40, 0.08), @external_ui_callbacks[1])
    
    return nil
  end
  
end