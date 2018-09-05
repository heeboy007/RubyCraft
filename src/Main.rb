require "sfml/rbsfml"

include SFML

load "Util.rb"
load "GLCore.rb"
load "Player.rb"
load "Loaders\\UILoader.rb"
load "Loaders\\ConfigLoader.rb"
load "Command.rb"

class SuperWindow < RenderWindow
  include GLManager
  include Debug_output
  include Command
  
  def initialize
    @width, @height = 640, 640
    @is_program_running, @has_ui_globaly_disabled, @is_player_commanding, @is_window_being_focused = true, false, false, true
    @player, @clock = Player.instance, Clock.new
    @uiobjects = Array.new
    @commandstr = ""
    
    self.ui_init
    
    super((VideoMode.new @width, @height, 32), "ver basic.3", Style::Default, ConfigLoader.instance.config)
    #self.vertical_sync_enabled= true
    self.framerate_limit= 60
    self.gl_init @player
    self.check_gl_version
  end
  
  def ui_init
    ui = UILoader.instance
    
    fpsupdate = lambda do |obj| #fps update
      clock = FPS.instance
      if clock.query?
        obj.string= "FPS : #{clock.fpscount}"
        clock.reset
      else
        clock.increase
      end
    end
    
    infoupdate = lambda do |obj| #keep update the playerinfo
      obj.position= Vector2.new 0.0, 20.0
      obj.string= @player.ReturnInfo
    end
    
    aimupdate = lambda do |obj| #put the aim at the center of the screen
      obj.position= Vector2.new(((@width-obj.texture_rect.width)/2).to_f,((@height-obj.texture_rect.height)/2).to_f)
    end
    
    graphupdate = lambda do |obj|
      obj.position= Vector2.new((@width-100).to_f, 0.0)
    end
    
    graphpointupdate = lambda do |obj|
      obj.position= Vector2.new((@width-50).to_f, 50.0)
      obj.rotation= @player.phi + 270.0
    end
    
    commandupdate = lambda do |obj|
      obj.position= Vector2.new(5.0, @height - 23.0)
      obj.size= Vector2.new(@width - 10.0, 18.0)
    end
    
    commandlineupdate = lambda do |obj|
      obj.position= Vector2.new(7.0, @height - 20.0)
      obj.string= @commandstr
    end
    
    add_ui_obj_to_display(ui.loadedobjs[0], "FPSCounter", fpsupdate)
    add_ui_obj_to_display(ui.loadedobjs[1], "PlayerInfo", infoupdate)
    add_ui_obj_to_display(ui.loadedobjs[2], "Aim", aimupdate)
    add_ui_obj_to_display(ui.loadedobjs[3], "VectorView", graphupdate)
    add_ui_obj_to_display(ui.loadedobjs[4], "Theta", graphpointupdate)
    add_ui_obj_to_display(ui.loadedobjs[5], "Command", commandupdate, false)
    add_ui_obj_to_display(ui.loadedobjs[6], "CommandLine", commandlineupdate, false)
  end
  
  def add_ui_obj_to_display obj, label, callback = 0, enabled = true
    uiobj = UIobject.new(obj, enabled, label, callback)
    @uiobjects << uiobj
  end
  
  def inverse_ui_obj_visiblity searchlabel
    @uiobjects.each_with_index do |obj,index|
      return obj.enabled = !obj.enabled if searchlabel == obj.label
    end
    return false
  end
  
  def sfml_reshape
    self.view= View.new(Rect.new 0.0, 0.0, @width.to_f, @height.to_f)
    d_puts "SuperWindow : sfml_reshape : SFML fuction Resized."
  end
  
  def handle_event
    while event = poll_event
      case event.type
      when Event::Closed
        @is_program_running = false
      when Event::Resized
        @width, @height = event.width, event.height
        self.gl_reshape @width, @height
        self.sfml_reshape
      when Event::TextEntered
        if @is_player_commanding
          #append the entered char at the end of the string if the char is not backspace.
          @commandstr += event.unicode.chr if event.unicode != Ascii_Code::BACKSPACE
          #if it is backspace, erase the char at the end of the char.
          @commandstr = @commandstr[0..-2] if event.unicode == Ascii_Code::BACKSPACE
          #when there's no more chars to erase, turn off the command_mode
          inverse_command_state() if event.unicode == Ascii_Code::BACKSPACE && @commandstr.empty?
          if event.unicode == Ascii_Code::ESCAPE
            command(@commandstr)
            inverse_command_state()
          end
        end #if @is_player_commanding
      when Event::KeyPressed
        if !@is_player_commanding #not useing command.
          case event.code
          when Keyboard::F1 #if F1 is pressed, make all ui invisible.
            @has_ui_globaly_disabled = !@has_ui_globaly_disabled
          when Keyboard::W, Keyboard::A, Keyboard::S, Keyboard::D, Keyboard::LShift, Keyboard::Space #move player
            @player.MoveCam event.code
          when Keyboard::Up, Keyboard::Left, Keyboard::Down, Keyboard::Right #rotate camera
            @player.RotateCamByKey event.code
          when Keyboard::Escape #exit
            @is_program_running = false
          when Keyboard::Period
            inverse_command_state() if @prevkey == Keyboard::RShift
          end
        else #when commanding. 
          inverse_command_state() if event.code == Keyboard::Escape
        end #if !@is_player_commanding
        @prevkey = event.code
      when Event::GainedFocus
        @is_window_being_focused = true
      when Event::LostFocus
        @is_window_being_focused = false
      when Event::MouseButtonReleased
        inverse_command_state() if @is_player_commanding
      when Event::MouseMoved
        @player.RotateCamByMouse(event.x-@width/2, event.y-@height/2) if !@is_player_commanding && @is_window_being_focused
      end #case event.type
    end #while event = poll_event
  end
  
  def inverse_command_state #on each call, turns the state of commanding.
    @commandstr = ""
    @is_player_commanding = !@is_player_commanding
    inverse_ui_obj_visiblity("Command")
    inverse_ui_obj_visiblity("CommandLine")
  end
  
  def postEndProgram
    @is_program_running = false
  end
  
  def run
    #fpscount = 0
    while @is_program_running
      #fisrt, handle the events
      handle_event #event handler
      @player.Update #calculations
      self.update_camera
      
      self.clear_window # well, self.clear will work the same way, but not on depth tests.
      self.mouse_cursor_visible= @is_player_commanding ? true : false
      
      #not commanding, while focused, set the mouse position at the center of the window.
      if !@is_player_commanding && @is_window_being_focused
        pos = [Vector2.new((@width/2).to_i, (@height/2).to_i), self]
        Mouse.set_position(pos) 
      end
      
      self.draw_3d_objs #draw 3D stuffs.
      
      self.push_gl_states #sfml function : push gl states so it would be cleared.
      
      #According to sfml main forum, if I use over 2.0+ opengl,
      #I have to handle the newer gl states for my own, because SFML doesn't know it.
      
      @uiobjects.each_with_index do |obj, index|
        obj.update
        draw obj.drawobj if obj.enabled && !@has_ui_globaly_disabled
      end
      
      self.pop_gl_states #sfml function : pop gl state from a stack so it would be displayed.
      
      display #a.k.a glFlush, glutSwapBuffers.
    end
    self.clean_buffers
    self.close
  end
  
end

app = SuperWindow.new

app.run
