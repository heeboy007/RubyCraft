require_relative "..\\Util.rb"
require_relative "..\\Block.rb"

class Chunk
  include Debug_output
  
  attr_reader :Cx
  attr_reader :Cy
  attr_reader :Cz
  attr_accessor :chunkmap
  
  def initialize cx, cy, cz
    @Cx, @Cy, @Cz = cx, cy, cz
    @chunkmap = create_3D_Array
  end
  
  def create_3D_Array
    arr = Array.new(Util::Chunk_Size)
    for i in 0...Util::Chunk_Size
        arr[i] = Array.new(Util::Chunk_Size)
        for j in 0...Util::Chunk_Size
            arr[i][j] = Array.new(Util::Chunk_Size)
            for k in 0...Util::Chunk_Size
                arr[i][j][k] = nil
            end
        end
    end
    return arr
  end
  
  def get_block_at x, y, z
    return @chunkmap[x][y][z]
  end
  
  def add_block_at x, y, z, block
    #d_puts "add_block called"
    @chunkmap[x][y][z] = block
  end
  
  def delete_block_at x, y, z
    #puts "Called"
    @chunkmap[x][y][z] = nil
    update_blocks_fetch_facing x, y, z, false
  end
  
  #Try best to not to use this method.
  def get_cord_of_block block
    @chunkmap.each_with_index do |rowy, idxx|
      rowy.each_with_index do |rowz, idxy|
        rowz.each_with_index do |block_obj, idxz|
          return [idxx, idxy, idxz] if block == block_obj
        end
      end
    end
  end
  
  def make_single_dimen_block_map
    retmap = Array.new
    @chunkmap.each { |rowy| rowy.each { |rowz| rowz.each { |block_obj| retmap << block_obj } } }
    return retmap
  end
  
  #0 = bottom
  #1 = z-
  #2 = x-
  #3 = x+
  #4 = z+
  #5 = top
  #TODO: more than two function exists in this method.
  #This method returns array of boolean.
  #If there is block nearby value is true.
  #Also it updates the nearby block's facing_information too. 
  def update_blocks_fetch_facing x, y, z, is_placing
    adjacency = Array.new
    if @chunkmap[x][y-1][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y-1][z].update_facing 5, is_placing
    end
    if @chunkmap[x][y][z-1] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y][z-1].update_facing 4, is_placing
    end
    if @chunkmap[x-1][y][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x-1][y][z].update_facing 3, is_placing
    end
    if @chunkmap[x+1][y][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x+1][y][z].update_facing 2, is_placing
    end
    if @chunkmap[x][y][z+1] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y][z+1].update_facing 1, is_placing
    end
    if @chunkmap[x][y+1][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y+1][z].update_facing 0, is_placing
    end
    return adjacency
  end
  
end