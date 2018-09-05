require "sfml/rbsfml"
require "mathn"

include SFML
include Math

class Player
  include Singleton
  include Debug_output
  
  attr_reader :pos
  attr_reader :speed
  attr_reader :theta #y-axis spin
  attr_reader :phi #x-axis spin
  attr_reader :xspin
  attr_reader :yspin
  def initialize x = 0, y = 0, z = 0
    d_puts "Player : initialize : player set by #{x}, #{y}, #{z}."
    @pos = Vector3.new x.to_f, y.to_f, z.to_f
    @speed = Vector3.new 0.0, 0.0, 0.0
    @theta, @phi, @xspin, @yspin = 0.0, 0.0, 0.0, 0.0
  end
  
  def Check
    smallnum = 0.00001
    @speed.x= 0.0 if -smallnum < @speed.x && @speed.x < smallnum #speed regulator
    @speed.x= -10.0 if @speed.x < -10.0 #speed limit
    @speed.x= 10.0 if @speed.x > 10.0 #speed limit
    @speed.y= 0.0 if -smallnum < @speed.y && @speed.y < smallnum
    @speed.y = -10.0 if @speed.y < -10.0
    @speed.y = 10.0 if @speed.y > 10.0
    @speed.z= 0.0 if -smallnum < @speed.z && @speed.z < smallnum
    @speed.z= -10.0 if @speed.z < -10.0
    @speed.z = 10.0 if @speed.z > 10.0
    @xspin = 0.0 if -smallnum < @xspin && @xspin < smallnum #speed regulator
    @yspin = 0.0 if -smallnum < @yspin && @yspin < smallnum
    @theta = 360 + @theta if @theta < 0
    @theta %= 360 if @theta >= 360
    @phi = 360 + @phi if @phi < 0
    @phi %= 360 if @phi >= 360
  end
  
  def ReturnInfo
    retstr = "X : #{@pos.x}, Y : #{@pos.y}, Z : #{@pos.z}\n" +
    "SX : #{@speed.x}, SY : #{@speed.y}, SZ : #{@speed.z}\n" +
    "Theta : #{@theta}, Phi : #{@phi}\n" +
    "TS : #{@xspin}, PS : #{@yspin}"
    return retstr
  end
  
  def Update
    @speed *= 0.70
    @xspin *= 0.70
    @yspin *= 0.70
    @pos += @speed
    @theta += @xspin
    @phi += @yspin
    Check()
  end
  
  def Resetby x, y, z #called by teleport command
    @pos.x= x
    @pos.y= y
    @pos.z= z
  end
  
  def RotateCamByKey key
    case key
      when 71 #left
        @yspin -= 2.0
      when 72 #right
        @yspin += 2.0
      when 73 #up
        @xspin -= 2.0
      when 74 #down
        @xspin += 2.0
    end
  end
  
  def RotateCamByMouse x, y #Mouse
    @yspin += x * 0.02
    @xspin += y * 0.02
  end
  
  def MoveCam key
    realKey = (key+97).chr.to_s if key != 38 || key != 57
    realKey = "shift" if key == 38
    realKey = "space" if key == 57
    vec = Vector3.new 0.0, 0.0, 0.0
    case realKey
      when "w", "a", "s", "d"
        spd = 0.3
        sectheta = @phi if realKey == "w"
        sectheta = (@phi + 270) % 360 if realKey == "a"
        sectheta = (@phi + 180) % 360 if realKey == "s"
        sectheta = (@phi + 90) % 360 if realKey == "d"
        vec.z= (-cos(sectheta.degrees) * spd)
        vec.x= (sin(sectheta.degrees) * spd)
        @speed += vec #add the speed to the actual player
    when "shift"
      @speed.y= @speed.y - 0.25
    when "space"
      @speed.y= @speed.y + 0.25
    end
  end
  
  def ForceRotate isx, spin
    if isx == true
      @theta = spin
    else
      @phi = spin
    end
  end
  
  def CameraXaxis
    theta = (@phi + 90) % 360
    retvec= Vector3.new(0.0, theta, 0.0)
    retvec.z= -cos(theta.degrees)
    retvec.x= sin(theta.degrees)
    return retvec
  end
  
end