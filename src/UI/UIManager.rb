require "sfml/rbsfml"

include SFML

require_relative "UIBuilder.rb"

class UIManager
  
  def initialize width, height
    @ui = UIBuilder.new
    
    @ui.ui_update_resize width, height
    @ui.build_ui_objects 
  end
  
  def add_ext_ui_updater updater
    @ui.external_ui_updater.push(updater)
  end
  
  def resize_screen width, height
    @ui.ui_update_resize width, height
  end
  
  def inverse_visiblity_of ui_obj_key
    @ui.inverse_ui_obj_visiblity ui_obj_key
  end
  
  def send_command_str str
    @ui.commandstr = str
  end
  
  def draw_ui_objects window, do_update = true
    @ui.loaded_ui_objcets.each do |obj|
      if obj.enabled 
        obj.update if do_update
        window.draw obj.drawobj
      end 
    end
  end
  
end