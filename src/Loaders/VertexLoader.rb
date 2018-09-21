require_relative "..\\Util.rb"

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
  
  def return_vertex_with_cord x, y, z
    generated_vertex = Array.new #generating 6 for each side.
    cloned_vertex = Array.new
    @cube.each { |node| cloned_vertex << node.dup }
    cloned_vertex.each_with_index do |vtx, idx_vertex|
      vtx.each_with_index do |cord, idx_of_side_vtx|
        vtx[idx_of_side_vtx] = cord + x.to_f if idx_of_side_vtx % 3 == 0
        vtx[idx_of_side_vtx] = cord + y.to_f if idx_of_side_vtx % 3 == 1
        vtx[idx_of_side_vtx] = cord + z.to_f if idx_of_side_vtx % 3 == 2
      end
      generated_vertex << vtx.pack("f*")
    end
    return generated_vertex
  end
  
end