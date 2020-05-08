require_relative "../World/MapManager.rb"
require_relative "../Renderer/Camera.rb"
require_relative "../Maths/General_Maths.rb"

module Command
  
  def command line
    cmdarr = line.split(' ') #spilt into array
    cmdarr[0][0] = '' #delete >
    cmd = cmdarr.shift #pop the first element of the array
    case cmd
    when "tele"
      tele(cmdarr)
    when "rotate"
      rotate(cmdarr)
    when "place_block"
      place_block(cmdarr)
    when "destroy_block"
      destroy_block(cmdarr)
    when "show_ray"
      show_ray
    when "hide_ray"
      hide_ray
    when "request_chunk_update"
      request_chunk_update(cmdarr)
    else
      puts "There is no such command : #{cmd.to_s}"
    end
  end
  
  def place_block argu
    if argu.count == 3 #needs cordinates.
      begin
        MapManager.instance.add_block_at argu[0].to_f.floor, argu[1].to_f.floor, argu[2].to_f.floor
      rescue
        puts "Arguments of the command is not vaild or somewhat error had occured."
        puts "Given array is : " + argu.to_s
      end
    else
      puts "Usage : >tele [x] [y] [z]"
    end
  end
  
  def destroy_block argu
    if argu.count == 3 #needs cordinates.
      begin
        MapManager.instance.destroy_block_at argu[0].to_f.floor, argu[1].to_f.floor, argu[2].to_f.floor
      rescue
        puts "Arguments of the command is not vaild or somewhat error had occured."
        puts "Given array is : " + argu.to_s
      end
    else
      puts "Usage : >tele [x] [y] [z]"
    end
  end
  
  def tele argu
    if argu.count == 3 #needs cordinates.
      begin
        Camera.instance.set_position_by argu[0].to_f, argu[1].to_f, argu[2].to_f
        self.reload_camera(2, argu[0].to_f, argu[1].to_f, argu[2].to_f)
        puts "Teleported player to #{argu[0].to_f}, #{argu[1].to_f}, #{argu[2].to_f}"
      rescue
        puts "Arguments of the command is not vaild!"
        puts "Given array is : " + argu.to_s
      end
    else
      puts "Usage : >tele [x] [y] [z]"
    end
  end
  
  def rotate argu #rotates the camera by force
    if argu.count == 2
      begin
        case argu [0]
        when "x"
          Camera.instance.set_rotate_angle(true, argu[1].to_f)
        when "y"
          Camera.instance.set_rotate_angle(false, argu[1].to_f)
        else
          puts "First argument of the command must be x, y or reset."
          return
        end
        self.reload_camera
      rescue
        puts "The second argument of the command is not a vaild number"
        puts "Given array is : " + argu.to_s
      end
    elsif argu.count == 1
      case argu[0]
      when "reset"
        Camera.instance.set_rotate_angle(true, 0)
        Camera.instance.set_rotate_angle(false, 0)
      else
        puts "Usage : >rotate 'x/y/reset' [spin]"
      end
    else
      puts "Usage : >rotate 'x/y/reset' [spin]"
    end
  end
  
  def show_ray
    line_cord = [Camera.instance.pos.x, Camera.instance.pos.y, Camera.instance.pos.z, 
      End_Point.instance.end_point.x, End_Point.instance.end_point.y, End_Point.instance.end_point.z]
    
    #setlinecord function is defined at GLRenderer
    DebugRenderer.instance.set_line_cord line_cord
    DebugRenderer.instance.flag_render_debug_settings = true
    
    puts "DEBUG : Command : Showing Temporary Rays..."
  end
  
  def hide_ray
    DebugRenderer.instance.flag_render_debug_settings = false
    puts "DEBUG : Command : Hiding Temporary Rays..."
  end
  
  def request_chunk_update argu
    MapManager.instance.add_chunk_update_request argu[0].to_i, argu[1].to_i, argu[2].to_i
    puts "DEBUG : Command : Added Force Chunk Update at #{argu[0].to_i}, #{argu[1].to_i}, #{argu[2].to_i}"
  end
  
end