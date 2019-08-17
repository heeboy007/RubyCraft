require "sfml/rbsfml"
require "mathn"

include SFML
include Math

require_relative "../Misc/Util.rb"

class Camera
  include Singleton
  include Debug_output
  
  attr_reader :pos
  attr_reader :speed
  attr_reader :pitch #y-axis spin
  attr_reader :yaw #x-axis spin
  attr_reader :xspin #pitch accelerator
  attr_reader :yspin #yaw accelerator
  def initialize x = 0, y = 0, z = 0
    d_puts "Camera : initialize : player set by #{x}, #{y}, #{z}."
    @pos = Vector3.new x.to_f, y.to_f, z.to_f
    @speed = Vector3.new 0.0, 0.0, 0.0
    @pitch, @yaw, @xspin, @yspin = 0.0, 0.0, 0.0, 0.0
    @is_gravity_enabled = true
  end
  
  def check
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
    @pitch = 360 + @pitch if @pitch < 0
    @pitch %= 360 if @pitch >= 360
    @yaw = 360 + @yaw if @yaw < 0
    @yaw %= 360 if @yaw >= 360
    
    #prevent spinning.
    if 89.5 <= @pitch && @pitch <= 270.5
      @pitch = 89.5 if @pitch <= 180
      @pitch = 270.5 if @pitch > 180
      @xspin = 0.0
    end 
    
  end

  def update #called constantly by main thread.
    #@speed.y -= 0.1 if @is_gravity_enabled
    @speed.x *= 0.65
    @speed.y *= 0.65
    @speed.z *= 0.65
    @xspin *= 0.70
    @yspin *= 0.70
    @pos += @speed
    
    
    @pitch += @xspin
    @yaw += @yspin
    self.check
  end
  
  def set_position_by x, y, z #called by teleport command, main initializer.
    @pos.x= x
    @pos.y= y
    @pos.z= z
  end
  
  def rotate_cam_by_key key #called by event handler.
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
  
  def rotate_cam_by_mouse x, y #called by event handler.
    @yspin += x * 0.02
    @xspin += y * 0.02
  end
  
  def move_cam keys #called by event handler.
    
    if keys[0] || keys[1] || keys[2] || keys[3] #W, A, S, D
      vec = Vector3.new 0.0, 0.0, 0.0
      added_speed_multiplier = 0.05
      if keys[0]
        vec.z= (-cos(@yaw.degrees) * added_speed_multiplier)
        vec.x= (sin(@yaw.degrees) * added_speed_multiplier)
      end
      if keys[1]
        vec.z= (-cos((@yaw + 270).degrees) * added_speed_multiplier)
        vec.x= (sin((@yaw + 270).degrees) * added_speed_multiplier)
      end
      if keys[2]
        vec.z= (-cos((@yaw + 180).degrees) * added_speed_multiplier)
        vec.x= (sin((@yaw + 180).degrees) * added_speed_multiplier)
      end
      if keys[3]
        vec.z= (-cos((@yaw + 90).degrees) * added_speed_multiplier)
        vec.x= (sin((@yaw + 90).degrees) * added_speed_multiplier)
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
  
  def set_rotate_angle isx, spin #set rotate angle of x or y axis.
    if isx == true
      @pitch = spin
    else
      @yaw = spin
    end
  end
  
  def get_camera_x_axis_vector #called by glcore glRotatef.
    pitch = (@yaw + 90) % 360
    retvec= Vector3.new(sin(pitch.degrees), 0.0, -cos(pitch.degrees))
    return retvec
  end
  
  def get_camera_info_updater #called by UIs in main thread.
    updater = lambda do |obj| #keep update the camerainfo
      obj.string= "X : #{@pos.x}, Y : #{@pos.y}, Z : #{@pos.z}\n" +
      "SX : #{@speed.x}, SY : #{@speed.y}, SZ : #{@speed.z}\n" +
      "Pitch : #{@pitch}, Yaw : #{@yaw}\n" +
      "TS : #{@xspin}, PS : #{@yspin}"
    end
    
    return updater
  end
  
  def get_camera_graph_updater #called by UIs in main thread.
    updater = lambda do |obj|
      obj.rotation= @yaw + 270.0
    end
    
    return updater
  end
  
end
    