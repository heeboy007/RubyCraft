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