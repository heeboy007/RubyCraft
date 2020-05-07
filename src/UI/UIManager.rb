require "sfml/rbsfml"

include SFML

require_relative "../Misc/Util.rb"
require_relative "GamePlayUIBuilder.rb"
require_relative "PauseUIBuilder.rb"
require_relative "InitialUIBuilder.rb"

class UIManager
  
  def initialize width, height
    @ui_builders = Hash.new
    @ui_builders[GameState::GamePlay] = GamePlayUIBuilder.new
    @ui_builders[GameState::Paused_Menu] = PauseUIBuilder.new(width, height)
    @ui_builders[GameState::Initial_Menu] = InitialUIBuilder.new(width, height)
  end
  
  def build_ui_objects
    @ui_builders.each_value { |ui| ui.build_ui_objects }
  end
  
  def add_ui_updater for_state, updater
    @ui_builders[for_state].external_ui_callbacks.push(updater)
  end
  
  def inverse_visiblity_of for_state, ui_obj_key
    @ui_builders[for_state].inverse_ui_obj_visiblity ui_obj_key
  end
  
  def send_command_str str
    @ui_builders[GameState::GamePlay].commandstr = str
  end
  
  def draw_ui for_state, window, width, height, mouse_state = nil
    @ui_builders[for_state].loaded_ui_objects.each do |obj|
      if obj.enabled 
        obj.update [width, height, mouse_state]
        obj.draw_on window
      end 
    end
  end
  
end