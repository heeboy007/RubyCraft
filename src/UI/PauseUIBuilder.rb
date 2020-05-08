require "sfml/rbsfml"
require 'singleton'

include SFML

require_relative "UIBuilder.rb"
require_relative "../Misc/ConfigLoader.rb"
require_relative "GUIObjects/DefaultUIObject.rb"
require_relative "GUIObjects/InteractableUIobject.rb"
require_relative "GUIObjects/DragBar.rb"
require_relative "GUIObjects/ToggleButton.rb"

class PauseUIBuilder < UIBuilder
  
  attr_reader :loaded_ui_objects
  attr_accessor :external_ui_callbacks
  
  def initialize width, height
    super("pause")
    @loaded_ui_objects = Array.new
    @external_ui_callbacks = Array.new
    @resbases = [
      ["sprite", "button", false, 256, 64],
      ["text", "Resource\\arial.ttf", "ArialText", 30],
      ["rect", width.to_f, height.to_f, 0, 0, 0, 75],
      ["sprite", "drager", false, 64, 64]
    ]
  end
  
  def build_ui_objects
    
    #background
    @loaded_ui_objects << DefaultUIobject.new(makerect(@resbases[2]), "Background", 
    lambda do |obj, width, height|
      obj.size= Vector2.new(width.to_f, height.to_f)
    end)
    
    #version....
    @loaded_ui_objects << DefaultUIobject.new(maketext(@resbases[1], ConfigLoader.instance.version), "VersionInfo",
    lambda do |obj, width, height|
      obj.position= Vector2.new(0.0, 0.0)
    end)
    
    #pause...
    @loaded_ui_objects << DefaultUIobject.new(maketext(@resbases[1], "Pause"), "PauseText",
    lambda do |obj, width, height|
      obj.position= Vector2.new((width.to_f - obj.local_bounds.width)/2, (height.to_f - obj.local_bounds.height)/10)
    end)
    
    #quit
    @loaded_ui_objects << InteractableUIobject.new([makesprite(@resbases[3]), maketext(@resbases[1],"Quit")], 
      "Init_St_Button", Rect.new(0.30, 0.32, 0.40, 0.08), @external_ui_callbacks[0])
    
    #title
    @loaded_ui_objects << InteractableUIobject.new([makesprite(@resbases[3]), maketext(@resbases[1],"To Title Screen")], 
      "Init_St_Button", Rect.new(0.30, 0.42, 0.40, 0.08), @external_ui_callbacks[1])
     
    #Vsync.
    @loaded_ui_objects << ToggleButton.new([makesprite(@resbases[3]), maketext(@resbases[1],"VSync : On")], 
      "VSync", Rect.new(0.30, 0.62, 0.40, 0.08), nil, @external_ui_callbacks[3])
    
    #dragbar
    @loaded_ui_objects << DragBar.new([makesprite(@resbases[0]), maketext(@resbases[1],"Render Dist :"), makesprite(@resbases[3])], 
      "Chunk_Dist", Rect.new(0.30, 0.72, 0.40, 0.08), @external_ui_callbacks[2])
    
    return nil
  end
  
end