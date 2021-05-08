require_relative "../Misc/Util.rb"
require_relative "../World/Block.rb"
require_relative "TextureManager.rb"

class VertexLoader
  include Debug_output
  include Singleton
  include TextureManager
  
  attr_reader :cube
  attr_reader :texture
  def initialize
    @cube = Array.new
    #The cordinate of a point
    vertex = [
      [0.0,0.0,0.0],
      [1.0,0.0,0.0],
      [1.0,0.0,1.0],
      [0.0,0.0,1.0],
      [0.0,1.0,1.0],
      [1.0,1.0,1.0],
      [1.0,1.0,0.0],
      [0.0,1.0,0.0]
    ]
    
    #Cube's each side. ORDERED! DO NOT CHANGE IT'S VALUE!
    elements = [
      [0,1,2,3],
      [0,7,6,1], #upright
      [3,4,7,0], #upright
      [1,6,5,2], #upright
      [2,5,4,3], #upright
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
  
  def get_vertex_with_cord x, y, z, sides_arr = nil
    generated_vertex = Hash.new #generating 6 for each side.
    cloned_vertex = Array.new
    @cube.each { |node| cloned_vertex << node.dup }
    cloned_vertex.each_with_index do |vtx, idx_side|
      vtx.each_with_index do |cord, idx_of_side_vtx|
        vtx[idx_of_side_vtx] = cord + x.to_f if idx_of_side_vtx % 3 == 0
        vtx[idx_of_side_vtx] = cord + y.to_f if idx_of_side_vtx % 3 == 1
        vtx[idx_of_side_vtx] = cord + z.to_f if idx_of_side_vtx % 3 == 2
      end
      if sides_arr != nil
        generated_vertex[idx_side] = vtx if sides_arr[idx_side]
      else #probably never used.
        generated_vertex[idx_side] = vtx
      end
    end
    #{ 0 => [vertex_of_bottom_side], 1=> [somwhat side_vertex...], ... }
    return generated_vertex
  end
  
  def get_texture_vtx_by_id block_id, which_side #texture atlas
    texture_position = get_texture_position_by(block_id, which_side)
    x = (texture_position % Util::Texture_Per_Image_Row) / Util::Texture_Per_Image_Row
    y = (texture_position / Util::Texture_Per_Image_Row).floor / Util::Texture_Per_Image_Row
    
    gap = 1.0 / Util::Texture_Per_Image_Row
    generated_tex_cord = [
      x, y + gap,
      x, y,
      x + gap, y,
      x + gap, y + gap
    ]
    
    return generated_tex_cord
  end
  
end