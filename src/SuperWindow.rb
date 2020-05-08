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
require_relative "Event/InitialMenuEventHandler.rb"

require_relative "Maths/RayTracer.rb"

require_relative "World/Player.rb"

class SuperWindow < RenderWindow
  include GLManager
  include Debug_output
  include Command
  include GamePlayEventHandler
  include PauseMenuEventHandler
  include InitialMenuEventHandler
  
  def initialize
    config = ConfigLoader.instance
    @width, @height = config.get_int("width"), config.get_int("height")
    @is_program_running, @has_ui_globaly_disabled, @is_player_commanding, @is_window_being_focused = true, config.get_bool("ui_disabled"), false, false
    @game_state = GameState::Initial_Menu
    @commandstr, @vsync = "", config.get_bool("vertical_sync_default_enabled")
    
    @camera, @clock = Camera.instance, Clock.new
    @ray_tracer, @player = RayTracer.new, Player.new
    @ui_manager = UIManager.new(@width, @height)
    
    super((VideoMode.new @width, @height, 32), "RubyCraft #{config.get_string("build_ver")}", Style::Default, config.context)
    self.framerate_limit= config.get_int("max_framerate") #it has no meaning.
    self.gl_init @camera
    self.ui_init
    self.check_gl_version
  end
  
  def ui_init
    @ui_manager.add_ui_updater(GameState::GamePlay, @ray_tracer.get_block_info_updater)
    @ui_manager.add_ui_updater(GameState::GamePlay, @player.get_player_info_updater)
    @ui_manager.add_ui_updater(GameState::GamePlay, @camera.get_camera_info_updater)
    @ui_manager.add_ui_updater(GameState::GamePlay, @camera.get_camera_graph_updater)
    @ui_manager.add_ui_updater(GameState::GamePlay, lambda { |obj| obj.string= @commandstr })
    @ui_manager.add_ui_updater(GameState::Paused_Menu, lambda { |text| post_end_program })
    @ui_manager.add_ui_updater(GameState::Paused_Menu, lambda { |text| quit_title_screen })
    @ui_manager.add_ui_updater(GameState::Paused_Menu, @map_manager.get_render_dist_updater)
    @ui_manager.add_ui_updater(GameState::Paused_Menu,
    lambda do |text|
      @vsync = !@vsync
      text.string= "VSync : On" if @vsync
      text.string= "VSync : Off" if !@vsync
      self.vertical_sync_enabled= @vsync
    end)
    @ui_manager.add_ui_updater(GameState::Initial_Menu, lambda { |text| enter_gameplay})
    @ui_manager.add_ui_updater(GameState::Initial_Menu, lambda { |text| post_end_program })
    
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
  
  def enter_gameplay
    @game_state = GameState::GamePlay
  end
  
  def quit_title_screen
    @game_state = GameState::Initial_Menu
  end
  
  def run
    #fpscount = 0
    @camera.set_position_by 0.5, 3, 0.5
    @camera.set_rotate_angle false, 180
    while @is_program_running
      case @game_state
        
      when GameState::Initial_Menu #STATE : INIT
        handle_initialmenu_events #event handler
        self.clear_window
        self.mouse_cursor_visible= true
        
        self.push_gl_states
        
        mouse_state = [Mouse.get_position([self]).x, Mouse.get_position([self]).y,
          Mouse.button_pressed?(Mouse::Left)]
        @ui_manager.draw_ui(GameState::Initial_Menu, self, @width, @height, mouse_state)
        
        self.pop_gl_states
        
      when GameState::GamePlay # STATE : PLAY
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
        #raytrace needs to be done after all cord translations.
        @ray_tracer.ray_trace(@camera.pos, @camera.pitch, @camera.yaw)
        
        self.draw_3d_objs #draw 3D stuffs.
        
        self.push_gl_states #sfml function : push gl states so it would be cleared.
        
        #According to sfml main forum, if I use over 2.0+ opengl,
        #I have to handle newer gl states for my own, because SFML doesn't know it.
        
        if !@has_ui_globaly_disabled
          @ui_manager.draw_ui(GameState::GamePlay, self, @width, @height)
        end
        
        self.pop_gl_states #sfml function : pop gl state from a stack so it would be displayed.
      
      when GameState::Paused_Menu # STATE : PAUSE
      
        handle_pausemenu_events
        self.clear_window
        self.mouse_cursor_visible= true
        
        self.draw_3d_objs
        
        self.push_gl_states #sfml function : push gl states so it would be cleared.
          
        #According to sfml main forum, if I use over 2.0+ opengl,
        #I have to handle newer gl states for my own, because SFML doesn't know it.
          
        if !@has_ui_globaly_disabled
          @ui_manager.draw_ui(GameState::GamePlay, self, @width, @height)
          #puts "main #{@width}, #{@height}"
        end

        mouse_state = [Mouse.get_position([self]).x, Mouse.get_position([self]).y,
          Mouse.button_pressed?(Mouse::Left)]
        @ui_manager.draw_ui GameState::Paused_Menu, self, @width, @height, mouse_state
        
        self.pop_gl_states
      
      end
      display #a.k.a glFlush, glutSwapBuffers.
    end
    self.clean_buffers
    self.close
  end
  
end