require "sfml/rbsfml"
require_relative "Util.rb"

include SFML

class ConfigLoader
  include Debug_output
  include Singleton
  
  attr_reader :context
  attr_reader :version
  
  def initialize
    @values = Hash.new
    File.readlines("Resource\\config.txt").each do |line|
      @values[line.split('=')[0]] = line.split('=')[1]
    end
    
    @version = @values["build_ver"];
    @context = ContextSettings.new(@values["depth_bits"].to_i, @values["stencil_bits"].to_i, 
    @values["antialiasing_level"].to_i, @values["gl_major_ver"].to_i, @values["gl_minor_ver"].to_i)
    
    d_puts "ResourceLoader : initialize : Loading config."
    d_puts "Loaded : depth_bits : #{@context.depth_bits}"
    d_puts "Loaded : stencil_bits : #{@context.stencil_bits}"
    d_puts "Loaded : antialiasing_level : #{@context.antialiasing_level}"
    d_puts "Loaded : major_version : #{@context.major_version}"
    d_puts "Loaded : minor_version : #{@context.minor_version}"
    d_puts "Loaded : Current Version : #{@version}"
  end

  def get_int key
    return @values[key].to_i
  end
  
  def get_string key
    return @values[key]
  end
  
  def get_bool key
    return @values[key].downcase == "true"
  end

end