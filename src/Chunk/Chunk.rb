require_relative "..\\Util.rb"

class Chunk
  include Debug_output
  
  attr_accessor :chunkmap
  
  def initialize
    @chunk_size = 8
    @chunkmap = create_3D_Array
  end
  
  def create_3D_Array
    arr = Array.new(@chunk_size)
    for i in 0...@chunk_size
        arr[i] = Array.new(@chunk_size)
        for j in 0...@chunk_size
            arr[i][j] = Array.new(@chunk_size)
            for k in 0...@chunk_size
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
    @chunkmap[x][y][z] = nil
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
  
  def get_block_adj x, y, z
    #0 = bottom
    #1 = z-
    #2 = x-
    #3 = x+
    #4 = z+
    #5 = top
    adjacency = Array.new
    if @chunkmap[x][y-1][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y-1][z].update 5
    end
    if @chunkmap[x][y][z-1] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y][z-1].update 4
    end
    if @chunkmap[x-1][y][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x-1][y][z].update 3
    end
    if @chunkmap[x+1][y][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x+1][y][z].update 2
    end
    if @chunkmap[x][y][z+1] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y][z+1].update 1
    end
    if @chunkmap[x][y+1][z] == nil
      adjacency << true
    else
      adjacency << false
      @chunkmap[x][y+1][z].update 0
    end
    return adjacency
  end
  
end