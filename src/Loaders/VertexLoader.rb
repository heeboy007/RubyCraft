
class VertexLoader
  include Debug_output
  include Singleton
  
  attr_reader :cube
  attr_reader :texture
  def initialize
    @cube = Array.new
    #The cordinate of a point
    vertex = [
      [-0.5,-0.5,-0.5],
      [0.5,-0.5,-0.5],
      [0.5,-0.5,0.5],
      [-0.5,-0.5,0.5],
      [-0.5,0.5,0.5],
      [0.5,0.5,0.5],
      [0.5,0.5,-0.5],
      [-0.5,0.5,-0.5]
    ]
    #Texture vertices
    @texture = [
      0.0,1.0,
      0.0,0.0,
      1.0,0.0,
      1.0,1.0
    ].pack("f*")
    #Cube's each side. ORDERED! DO NOT CHANGE IT'S VALUE!
    elements = [
      [0,1,2,3],
      [7,6,1,0],
      [0,3,4,7],
      [6,5,2,1],
      [5,4,3,2],
      [4,5,6,7]
    ]
    
    d_puts "VertexLoader : initialize : Making basic cube vertex."
    elements.each do |side|
      vertices = Array.new
      side.each do |load|
        vertex[load].each do |points|
          vertices << points
        end
      end
      @cube << vertices
    end
  end
  
end