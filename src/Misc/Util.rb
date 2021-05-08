require "sfml/rbsfml"
require "singleton"

module Debug_output
  @@debug = true
  
  def turnstate() @@debug = !@@debug; end
  
  def d_puts msg
    puts "DEBUG : " + msg.to_s if @@debug
  end
  
  def err_message msg
    puts "ERROR : " + msg.to_s
    self.post_end_program
  end
  
end

class Numeric
  def degrees
    self * Math::PI / 180 
  end
end

module Util
  
  Chunk_Size = 8
  Chunk_Generate_Range = 8
  Max_Range = 10
  Texture_Per_Image_Row = 8.0
  
end

module Ascii_Code
  
  Backspace = 8
  Escape = 13
  Greater = 62
  
end

module GameState
  
  Initial_Menu = 0
  GamePlay = 1
  Paused_Menu = 2
  
end
