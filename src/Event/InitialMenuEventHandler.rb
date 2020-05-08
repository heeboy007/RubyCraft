require "sfml/rbsfml"

include SFML

require_relative "../Misc/Util.rb"

module InitialMenuEventHandler
  
  def handle_initialmenu_events
    while event = poll_event
      case event.type
        
      when Event::Closed
        post_end_program
      
      when Event::Resized
        @width, @height = event.width, event.height
        self.gl_reshape @width, @height
        self.sfml_reshape
      
      when Event::MouseButtonPressed
        #nothing to do here really.
      end
    end #while event = poll_event
  end
  
end