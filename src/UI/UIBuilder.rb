require "sfml/rbsfml"
require 'singleton'

include SFML

require_relative "../Misc/TextureLoader.rb"
require_relative "GUIObjects/DefaultUIobject.rb"
require_relative "GUIObjects/CommandLine.rb"
require_relative "GUIObjects/PlayerThetaDisplay.rb"
require_relative "GUIObjects/DebugInformation.rb"
require_relative "FPSChecker.rb"
require_relative "../World/MapManager.rb"

class UIBuilder
  
  attr_reader :loaded_ui_objcets
  attr_writer :commandstr
  attr_accessor :external_ui_updater
  
  def initialize
    @external_ui_updater = Array.new
    @commandstr = ""
    @loaded_drawables = Array.new
    @textloader = TextureLoader.instance
    resbases = [
      ["text", "Resource\\arial.ttf", "FPS : 0", 15],
      ["text", "Resource\\arial.ttf", "PlayerInfo", 15],
      ["sprite", "aim", false, 32, 32],
      ["circle", "graph", true, 50.0, 200, 200],
      ["rect", 50.0, 1.0, 0, 200, 50, 255],
      ["rect", 630.0, 18.0, 0, 0, 0, 128],
      ["text", "Resource\\arial.ttf", "Command", 10],
      ["text", "Resource\\arial.ttf", "RayTracedBlock", 10],
      ["text", "Resource\\arial.ttf", "MapInfo", 10],
      ["text", "Resource\\arial.ttf", "PlayerInventory", 10]
    ]
    resbases.each do |info|
      case info.first
      when "text"
        @loaded_drawables.push(maketext(info))
      when "sprite"
        @loaded_drawables.push(makesprite(info))
      when "circle"
        @loaded_drawables.push(makecircle(info))
      when "rect"
        @loaded_drawables.push(makerect(info))
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
  
  def inverse_ui_obj_visiblity searchlabel
    @loaded_ui_objcets.each_with_index do |obj,index|
      return obj.enabled = !obj.enabled if searchlabel == obj.label
    end
    return false
  end
  
  def build_ui_objects
    aimupdate = lambda do |obj, width, height| #put the aim at the center of the screen
      obj.position= Vector2.new(((width-obj.texture_rect.width)/2).to_f,((height-obj.texture_rect.height)/2).to_f)
    end
    
    mapinfoupdate = lambda do |obj|
      obj.string= "Loaded Chunks : #{MapManager.instance.get_the_number_of_chunks}"
    end
    
    @loaded_ui_objcets = Array.new
    @loaded_ui_objcets << DebugInformation.new("Debug", 
      @loaded_drawables[0], @loaded_drawables[1], @loaded_drawables[7], @loaded_drawables[8], @loaded_drawables[9],
      @external_ui_updater[2], @external_ui_updater[0], mapinfoupdate, @external_ui_updater[1])
    @loaded_ui_objcets << DefaultUIobject.new(@loaded_drawables[2], "Aim", aimupdate)
    @loaded_ui_objcets << PlayerThetaDisplay.new("VectorView", @loaded_drawables[3], @loaded_drawables[4], @external_ui_updater[3])
    @loaded_ui_objcets << CommandLine.new("Command", @loaded_drawables[5], @loaded_drawables[6], @external_ui_updater[4])
    return nil
  end
  
end