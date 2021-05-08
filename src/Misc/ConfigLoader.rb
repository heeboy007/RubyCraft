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
    File.readlines("src\\Resource\\config.txt").each do |line|
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
    
    #Override
    if !ARGV.empty?
      ARGV.each do |args|
        sp = args.split("=")
        if @values.key?(sp[0])
          d_puts "Manual Argument Override By #{sp[0]} = #{sp[1]}"
          @values[sp[0]] = sp[1]
        end
      end
    end
  end

  def get_int key
    return @values[key].to_i
  end
  
  def get_string key
    return @values[key]
  end
  
  def get_bool key
    return @values[key].downcase.chomp.eql?("true")
  end
  
  def set_int key, value
    @values[key] = value.to_i
    return nil
  end
  
  def set_string key, value
    @values[key] = value.to_s
    return nil
  end
  
  def set_bool key, value
    value = !(value == nil || value == false)
    @values[key] = value
    return nil
  end

end