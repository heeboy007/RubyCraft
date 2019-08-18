require "sfml/rbsfml"

include SFML

require_relative "UIBuilder.rb"

class UIManager
  
  def initialize width, height
    @ui = UIBuilder.new
  end
  
  def build_ui_objects
    @ui.build_ui_objects 
  end
  
  def add_ext_ui_updater updater
    @ui.external_ui_updater.push(updater)
  end
  
  def inverse_visiblity_of ui_obj_key
    @ui.inverse_ui_obj_visiblity ui_obj_key
  end
  
  def send_command_str str
    @ui.commandstr = str
  end
  
  def draw_ui_objects window, width, height, do_update = true
    @ui.loaded_ui_objcets.each do |obj|
      if obj.enabled 
        obj.update width, height if do_update
        obj.draw_on window
      end 
    end
  end
  
end