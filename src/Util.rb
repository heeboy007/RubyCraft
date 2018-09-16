require "sfml/rbsfml"
require "singleton"
require "time"

class FPS
  include Singleton
  
  attr_reader :fpscount
  
  def reset() @fpscount = 0; end
  
  def increase() @fpscount += 1; end
  
  def initialize
    @savt, @fpscount = Time.now.to_i, 0
  end
  
  def query?
    result = @savt < (now = Time.now.to_i) ? true : false
    @savt = now if result
    result
  end
  
end

module Debug_output
  @@debug = true
  
  def turnstate() @@debug = !@@debug; end
  
  def d_puts msg
    puts "DEBUG : " + msg.to_s if @@debug
  end
  
  def err_message msg
    puts "ERROR : " + msg.to_s
    self.postEndProgram
  end
  
end

class Numeric
  def degrees
    self * Math::PI / 180 
  end
end

class UIobject #data struct
  attr_reader :drawobj
  attr_accessor :enabled
  attr_reader :label
  
  def initialize obj, enabled, label, updatefunc = 0
    @drawobj, @enabled, @label, @update_callback = obj, enabled, label, updatefunc
  end
  
  def update
    @update_callback.call @drawobj if @update_callback != 0
  end
  
end

module Ascii_Code
  
  BACKSPACE = 8
  ESCAPE = 13
  
end
