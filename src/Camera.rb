require "sfml/rbsfml"
require "mathn"

include SFML
include Math

class Camera
  include Singleton
  include Debug_output
  
  attr_reader :pos
  attr_reader :speed
  attr_reader :theta #y-axis spin
  attr_reader :phi #x-axis spin
  attr_reader :xspin
  attr_reader :yspin
  def initialize x = 0, y = 0, z = 0
    d_puts "Camera : initialize : player set by #{x}, #{y}, #{z}."
    @pos = Vector3.new x.to_f, y.to_f, z.to_f
    @speed = Vector3.new 0.0, 0.0, 0.0
    @theta, @phi, @xspin, @yspin = 0.0, 0.0, 0.0, 0.0
  end
  
  def Check
    smallnum = 0.00001
    speed_limit = 10.0
    
    #speed limit
    @speed.x= -speed_limit if @speed.x < -speed_limit
    @speed.x= speed_limit if @speed.x > speed_limit
    @speed.y = -speed_limit if @speed.y < -speed_limit
    @speed.y = speed_limit if @speed.y > speed_limit
    @speed.z= -speed_limit if @speed.z < -speed_limit
    @speed.z = speed_limit if @speed.z > speed_limit
    
    #if speed is to small, stop calculate.
    @speed.x= 0.0 if -smallnum < @speed.x && @speed.x < smallnum
    @speed.y= 0.0 if -smallnum < @speed.y && @speed.y < smallnum
    @speed.z= 0.0 if -smallnum < @speed.z && @speed.z < smallnum
    @xspin = 0.0 if -smallnum < @xspin && @xspin < smallnum
    @yspin = 0.0 if -smallnum < @yspin && @yspin < smallnum
    
    #spinings..
    @theta = 360 + @theta if @theta < 0
    @theta %= 360 if @theta >= 360
    @phi = 360 + @phi if @phi < 0
    @phi %= 360 if @phi >= 360
    
    #prevent spinning.
    if 90.0 <= @theta && @theta <= 270.0
      @theta = 90.0 if @theta <= 180.0
      @theta = 270.0 if @theta > 180.0
      @xspin = 0.0
    end 
    
  end
  
  def ReturnInfo
    retstr = "X : #{@pos.x}, Y : #{@pos.y}, Z : #{@pos.z}\n" +
    "SX : #{@speed.x}, SY : #{@speed.y}, SZ : #{@speed.z}\n" +
    "Theta : #{@theta}, Phi : #{@phi}\n" +
    "TS : #{@xspin}, PS : #{@yspin}"
    return retstr
  end
  
  def Update
    @speed *= 0.65
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
  
  def MoveCam keys
    
    if keys[0] || keys[1] || keys[2] || keys[3] #W, A, S, D
      vec = Vector3.new 0.0, 0.0, 0.0
      added_speed_multiplier = 0.05
      if keys[0]
        vec.z= (-cos(@phi.degrees) * added_speed_multiplier)
        vec.x= (sin(@phi.degrees) * added_speed_multiplier)
      end
      if keys[1]
        vec.z= (-cos((@phi + 270).degrees) * added_speed_multiplier)
        vec.x= (sin((@phi + 270).degrees) * added_speed_multiplier)
      end
      if keys[2]
        vec.z= (-cos((@phi + 180).degrees) * added_speed_multiplier)
        vec.x= (sin((@phi + 180).degrees) * added_speed_multiplier)
      end
      if keys[3]
        vec.z= (-cos((@phi + 90).degrees) * added_speed_multiplier)
        vec.x= (sin((@phi + 90).degrees) * added_speed_multiplier)
      end
      @speed += vec #add the speed to the actual player
    end
    if keys[4] #LShift
      @speed.y= @speed.y - 0.08
    end
    if keys[5] #Space
      @speed.y= @speed.y + 0.08
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
