require "sfml/rbsfml"

include SFML

require_relative "GamePlayUIBuilder.rb"
require_relative "PauseUIBuilder.rb"

class UIManager
  
  def initialize width, height
    @game_ui = GamePlayUIBuilder.new
    @pause_ui = PauseUIBuilder.new width, height
  end
  
  def build_ui_objects
    @game_ui.build_ui_objects
    @pause_ui.build_ui_objects
  end
  
  def add_ext_game_ui_updater updater
    @game_ui.external_ui_updater.push(updater)
  end
  
  def add_ext_pause_ui_callback updater
    @pause_ui.external_ui_callbacks.push(updater)
  end
  
  def inverse_visiblity_of ui_obj_key
    @game_ui.inverse_ui_obj_visiblity ui_obj_key
  end
  
  def send_command_str str
    @game_ui.commandstr = str
  end
  
  def draw_gameplay_ui window, width, height
    @game_ui.loaded_ui_objcets.each do |obj|
      if obj.enabled 
        obj.update [width, height]
        obj.draw_on window
      end 
    end
  end
  
  def draw_pause_menu_ui window, width, height, mouse_state
    @pause_ui.loaded_ui_menu.each do |obj|
      if obj.enabled
        obj.update [width, height, mouse_state]
        obj.draw_on window
      end
    end
  end
  
end