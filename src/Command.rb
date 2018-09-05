
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
    else
      puts "There is no such command : #{cmd.to_s}"
    end
  end
  
  def tele argu
    if argu.count == 3 #needs cordinates.
      begin
        @player.Resetby argu[0].to_f, argu[1].to_f, argu[2].to_f
        self.reload_camera(2, argu[0].to_f, argu[1].to_f, argu[2].to_f)
        puts "Teleported player to #{argu[0].to_f}, #{argu[1].to_f}, #{argu[2].to_f}"
      rescue
        puts "Arguments of the command is not vaild!"
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
          @player.ForceRotate(true, argu[1].to_f)
        when "y"
          @player.ForceRotate(false, argu[1].to_f)
        else
          puts "First argument of the command must be x or y."
          return
        end
        self.reload_camera
      rescue
        puts "The second argument of the command is not a vaild number"
      end
    elsif argu.count == 1
      case argu[0]
      when "reset"
        @player.ForceRotate(true, 0)
        @player.ForceRotate(false, 0)
      else
        puts "Usage : >rotate 'x/y/reset' [spin]"
      end
    else
      puts "Usage : >rotate 'x/y/reset' [spin]"
    end
  end
  
end