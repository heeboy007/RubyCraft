require 'sfml/rbsfml'

include SFML

require_relative '..\\Util.rb'

class ConfigLoader
  include Debug_output
  include Singleton
  
  attr_reader :config
  def initialize
    load = []
    File.readlines("Resource\\config.txt").each do |line|
      load << line.split('=').last.to_i
    end
    
    d_puts "ResourceLoader : initialize : Loading config."
    @config = ContextSettings.new
    
    d_puts "Loaded : depth_bits : #{@config.depth_bits= load[0]}"
    d_puts "Loaded : stencil_bits : #{@config.stencil_bits= load[1]}"
    d_puts "Loaded : antialiasing_level : #{@config.antialiasing_level= load[2]}"
    d_puts "Loaded : major_version : #{@config.major_version= load[3]}"
    d_puts "Loaded : minor_version : #{@config.minor_version= load[4]}"
  end

end