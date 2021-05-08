require_relative "../Misc/Util.rb"
require_relative "Block.rb"
require_relative "../Renderer/VertexLoader.rb"
require_relative "MapManager.rb"

class Chunk
  include Debug_output

  attr_reader :loaded_tex_cord
  attr_writer :flag_chunk_update
  attr_accessor :chunkmap
  
  def initialize cx, cy, cz, gen = nil, top_block = nil, bottom_block = nil
    @chunkmap = Array.new(Util::Chunk_Size**3)
    @loaded_vertex = nil
    @loaded_tex_cord = nil
    @flag_chunk_update = true
    @cx, @cy, @cz = cx, cy, cz
    if gen != nil
      Util::Chunk_Size.times do |x| #chucks bigger cord 
        Util::Chunk_Size.times do |z|
          height = gen[(@cx * Util::Chunk_Size + x)*0.01, (@cz * Util::Chunk_Size + z)*0.01]
          finy = ((height + 1) * 3.9).floor
          finy.times do |y|
            @chunkmap[(z*(Util::Chunk_Size**2) + y*Util::Chunk_Size + x)] = Block.new(bottom_block, nil)
          end
          @chunkmap[(z*(Util::Chunk_Size**2) + finy*Util::Chunk_Size + x)] = Block.new(top_block, nil)
        end
      end 
    end
  end
  
  def get_block_at x, y, z
    if x.between?(0, Util::Chunk_Size-1) && y.between?(0, Util::Chunk_Size-1) && z.between?(0, Util::Chunk_Size-1)
      return @chunkmap[(z*(Util::Chunk_Size**2) + y*Util::Chunk_Size + x)]
    else
      return nil
    end
  end
  
  def add_block_at x, y, z, id, tag = nil
    @chunkmap[(z*(Util::Chunk_Size**2) + y*Util::Chunk_Size + x)] = Block.new(id, tag)
    @flag_chunk_update = true
    return
  end
  
  def delete_block_at x, y, z
    result = @chunkmap[(z*(Util::Chunk_Size**2) + y*Util::Chunk_Size + x)] != nil
    @chunkmap[(z*(Util::Chunk_Size**2) + y*Util::Chunk_Size + x)] = nil
    @flag_chunk_update = true
    return result
  end

  def get_chunk_packed_vertex
    #if @loaded_vertex is empty or has an update, make one.
    if @flag_chunk_update
      @loaded_vertex = Array.new
      @loaded_tex_cord = Array.new
      vtxloader = VertexLoader.instance
      #each block~~~
      @chunkmap.each_with_index do |block, index|
        if block != nil
          cordx = @cx * Util::Chunk_Size + ((index % (Util::Chunk_Size**2)) % Util::Chunk_Size).floor
          cordy = @cy * Util::Chunk_Size + ((index % (Util::Chunk_Size**2)) / Util::Chunk_Size).floor
          cordz = @cz * Util::Chunk_Size + (index / (Util::Chunk_Size**2)).floor
          #for each block, make a gl vertex and store in a single array.
          adjacent_blocks = MapManager.instance.query_each_side_has_a_block(cordx, cordy, cordz)
          #this function returns a Hash like this:
          #{ 0 => [vertex_of_bottom_side], 1=> [somwhat side_vertex...], ... }
          vtxloader.get_vertex_with_cord(cordx, cordy, cordz, adjacent_blocks).each_pair do |which_side, one_side_vtx|
            #vertex for each side is in side_vtx(Array). So we need to access the elements of it to make vbo in a single array.
            one_side_vtx.each { |vtx| @loaded_vertex << vtx }
            #make texture cord with it! using texture atlas method...
            #generate texture per side.
            vtxloader.get_texture_vtx_by_id(block.id, which_side).each { |texture_cord| @loaded_tex_cord << texture_cord }
          end
        end
      end
      @loaded_vertex = @loaded_vertex.pack("f*")
      @loaded_tex_cord = @loaded_tex_cord.pack("f*")
      @flag_chunk_update = false
      return @loaded_vertex
    else #if chunk blocks are not changed, just use the remaining vertex and do not generate anything.
      return @loaded_vertex
    end
  end
  
  def get_tex_cord_vertex
    return @loaded_tex_cord
  end
  
end