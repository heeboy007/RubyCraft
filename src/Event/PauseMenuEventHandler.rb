require "sfml/rbsfml"

include SFML

require_relative "../Misc/Util.rb"

module PauseMenuEventHandler
  
  def handle_pausemenu_events
    while event = poll_event
      case event.type
        
      when Event::Closed
        post_end_program
      
      when Event::Resized
        @width, @height = event.width, event.height
        @ui_manager.resize_screen @width, @height
        self.gl_reshape @width, @height
        self.sfml_reshape
      
      when Event::KeyPressed
        case event.code
        when Keyboard::Escape
          #switch back to normal game play.
          @game_state = GameState::GamePlay
        end
      
      when Event::MouseButtonPressed
        post_end_program
      
      end
    end #while event = poll_event
  end
  
end