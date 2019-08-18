require "sfml/rbsfml"

include SFML

require_relative "UI/Command.rb"
require_relative "UI/UIManager.rb"

require_relative "Misc/Util.rb"
require_relative "Misc/ConfigLoader.rb"

require_relative "Renderer/GLManager.rb"
require_relative "Renderer/Camera.rb"

require_relative "Event/GamePlayEventHandler.rb"
require_relative "Event/PauseMenuEventHandler.rb"

require_relative "Maths/RayTracer.rb"

require_relative "World/Player.rb"

class SuperWindow < RenderWindow
  include GLManager
  include Debug_output
  include Command
  include GamePlayEventHandler
  include PauseMenuEventHandler
  
  def initialize
    config = ConfigLoader.instance
    @width, @height = config.get_int("width"), config.get_int("height")
    @is_program_running, @has_ui_globaly_disabled, @is_player_commanding, @is_window_being_focused = true, config.get_bool("ui_disabled"), false, false
    @game_state = GameState::GamePlay
    @camera, @clock = Camera.instance, Clock.new
    @commandstr = ""
    @ray_tracer = RayTracer.new
    @player = Player.new
    
    @ui_manager = UIManager.new(@width, @height)
    self.ui_init
    
    super((VideoMode.new @width, @height, 32), "RubyCraft #{config.version}", Style::Default, config.context)
    self.vertical_sync_enabled= config.get_bool("vertical_sync_default_enabled")
    self.framerate_limit= config.get_int("max_framerate") #it has no meaning.
    self.gl_init @camera
    self.check_gl_version
  end
  
  def ui_init
    commandline_updater = lambda do |obj|
      obj.string= @commandstr
    end
    @ui_manager.add_ext_ui_updater(@ray_tracer.get_block_info_updater)
    @ui_manager.add_ext_ui_updater(@player.get_player_info_updater)
    @ui_manager.add_ext_ui_updater(@camera.get_camera_info_updater)
    @ui_manager.add_ext_ui_updater(@camera.get_camera_graph_updater)
    @ui_manager.add_ext_ui_updater(commandline_updater)
    @ui_manager.build_ui_objects
  end
  
  def sfml_reshape
    self.view= View.new(Rect.new 0.0, 0.0, @width.to_f, @height.to_f)
    d_puts "SuperWindow : sfml_reshape : SFML fuction Resized."
  end
  
  def move_camera
    map = [Keyboard.key_pressed?(Keyboard::W),Keyboard.key_pressed?(Keyboard::A),
      Keyboard.key_pressed?(Keyboard::S),Keyboard.key_pressed?(Keyboard::D),
      Keyboard.key_pressed?(Keyboard::LShift),Keyboard.key_pressed?(Keyboard::Space)]
    @camera.move_cam map
  end
  
  def post_end_program
    @is_program_running = false
  end
  
  def run
    #fpscount = 0
    @camera.set_position_by 0.5, 3, 0.5
    @camera.set_rotate_angle false, 180
    while @is_program_running
      case @game_state
        
      when GameState::GamePlay
        #fisrt, handle the events
        handle_gameplay_events #event handler
        @camera.update #calculations of cordinates
        self.update_camera #graphical update
        
        self.clear_window # well, self.clear will work the same way, but not on depth tests.
        self.mouse_cursor_visible= @is_player_commanding
        
        #not commanding, while focused, set the mouse position at the center of the window.
        if !@is_player_commanding && @is_window_being_focused
          pos = [Vector2.new((@width/2).to_i, (@height/2).to_i), self]
          Mouse.set_position(pos)
        end
        #needs raytrace to be done after all cordinate moves. And helpfully, return some useful display infos!
        @ray_tracer.ray_trace(@camera.pos, @camera.pitch, @camera.yaw)
        
        self.draw_3d_objs #draw 3D stuffs.
        
        self.push_gl_states #sfml function : push gl states so it would be cleared.
        
        #According to sfml main forum, if I use over 2.0+ opengl,
        #I have to handle the newer gl states for my own, because SFML doesn't know it.
        
        if !@has_ui_globaly_disabled
          @ui_manager.draw_ui_objects self, @width, @height
        end
        
        self.pop_gl_states #sfml function : pop gl state from a stack so it would be displayed.
      
      when GameState::Paused_Menu
      
        handle_pausemenu_events
        self.clear_window
        
        self.draw_3d_objs
        
        self.push_gl_states #sfml function : push gl states so it would be cleared.
          
        #According to sfml main forum, if I use over 2.0+ opengl,
        #I have to handle the newer gl states for my own, because SFML doesn't know it.
          
        if !@has_ui_globaly_disabled
          @ui_manager.draw_ui_objects self, @width, @height, false
        end

        
        
        self.pop_gl_states
      
      end
      display #a.k.a glFlush, glutSwapBuffers.
    end
    self.clean_buffers
    self.close
  end
  
end