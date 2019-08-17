require "time"

class CooldownChecker
  
  def cooldown_start
    @savt = current_time
  end
  
  def initialize
    @savt = 0
  end
  
  def current_time
    return (Time.now.to_f*1000).to_i
  end
  
  def query?
    return @savt < current_time
  end
  
end