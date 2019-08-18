require "sfml/rbsfml"

include SFML

require_relative "../Misc/Util.rb"

module GamePlayEventHandler
  
  def inverse_command_state #on each call, turns the state of commanding.
    @commandstr = ""
    @is_player_commanding = !@is_player_commanding
    @ui_manager.inverse_visiblity_of("Command")
    @ui_manager.inverse_visiblity_of("CommandLine")
  end
  
  def handle_gameplay_events
    while event = poll_event
      case event.type
        
      when Event::Closed
        post_end_program
        
      when Event::Resized
        @width, @height = event.width, event.height
        @ui_manager.resize_screen @width, @height
        self.gl_reshape @width, @height
        self.sfml_reshape
        
      when Event::TextEntered
        inverse_command_state() if event.unicode == Ascii_Code::Greater
        if @is_player_commanding
          #append the entered char at the end of the string if the char is not backspace.
          @commandstr += event.unicode.chr if event.unicode != Ascii_Code::Backspace
          #when there's no more chars to erase, turn off the command_mode
          inverse_command_state() if event.unicode == Ascii_Code::Backspace && @commandstr.empty?
          #if it is backspace, erase the char at the end of the char.
          @commandstr = @commandstr[0..-2] if event.unicode == Ascii_Code::Backspace
          @ui_manager.send_command_str @commandstr
          if event.unicode == Ascii_Code::Escape
            @ui_manager.send_command_str ""
            command(@commandstr)
            inverse_command_state()
          end
        end #if @is_player_commanding
        
      when Event::KeyPressed
        if !@is_player_commanding #not useing command.
          case event.code
          when Keyboard::F1 #if F1 is pressed, make all ui invisible.
            @has_ui_globaly_disabled = !@has_ui_globaly_disabled
          when Keyboard::F3 #if F3 is pressed, force to update every chunk.
            MapManager.instance.force_update_every_chunk
          when Keyboard::Up, Keyboard::Left, Keyboard::Down, Keyboard::Right #rotate camera
            if !@is_player_commanding && @is_window_being_focused
              @camera.rotate_cam_by_key event.code
            end
          when Keyboard::Escape #exit
            #menu will be added
            self.mouse_cursor_visible= true
            @game_state = GameState::Paused_Menu
          end
        else #when commanding. 
          inverse_command_state() if event.code == Keyboard::Escape
        end #if !@is_player_commanding
        
      when Event::GainedFocus 
        @is_window_being_focused = true
      when Event::LostFocus 
        @is_window_being_focused = false
      
      when Event::MouseWheelScrolled 
        if event.delta > 0
          @player.move_holding_left
        else
          @player.move_holding_right
        end
      
      when Event::MouseButtonPressed
        if @is_window_being_focused
          case event.button
          when Mouse::Left
            end_vec = End_Point.instance.end_point
            MapManager.instance.destroy_block_at(end_vec.x.floor, end_vec.y.floor, end_vec.z.floor)
          when Mouse::Right
            if End_Point.instance.is_a_block_there && @player.is_holding_item_placeable
              @player.use_selected_item
              before_vec = End_Point.instance.before_point
              MapManager.instance.add_block_at(before_vec.x.floor, before_vec.y.floor, before_vec.z.floor, @player.get_current_item_id)
            end
          end
        end
        @is_window_being_focused = true
      when Event::MouseButtonReleased 
        inverse_command_state() if @is_player_commanding
      when Event::MouseMoved
        if !@is_player_commanding && @is_window_being_focused
          @camera.rotate_cam_by_mouse(event.x-(@width/2.to_i), event.y-(@height/2).to_i)
        end
      end #case event.type
      
    end #while event = poll_event
    move_camera if @is_window_being_focused && !@is_player_commanding
  end
  
end
