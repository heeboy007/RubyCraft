require "perlin"

require_relative "../Renderer/MapRenderer.rb"
require_relative "Chunk.rb"
require_relative "Block.rb"
require_relative "../Misc/Util.rb"
require_relative "../Misc/CooldownChecker.rb"
require_relative "../Misc/ConfigLoader.rb"

class MapManager
  include Singleton
  include Debug_output
  
  attr_reader :map_renderer
  attr_accessor :update_queryed_chunks
  
  def map_init texture
    @map_renderer = MapRenderer.new texture
    
    @chunk_hash = Hash.new
    @chunk_update_request = Array.new
    @cooldown_checker = CooldownChecker.new
    @called = 0
    
    @chuck_load_distance = Util::Chunk_Size * ConfigLoader.instance.get_int("chunk_load_distance")
    
    seed = Random.new.rand(100000)
    d_puts "MapManager : Seed #{seed}"
    generate_map_by_seed seed
  end
  
  def generate_map_by_seed seed
    #flat map generation first.
    block_range = Util::Chunk_Generate_Range * Util::Chunk_Size
    gen = Perlin::Generator.new(seed, 1.0, 1)
    
    (Util::Chunk_Generate_Range*2).times do |cx| #chucks bigger cord 
      (Util::Chunk_Generate_Range*2).times do |cz| 
        chunk = Chunk.new(cx-Util::Chunk_Generate_Range, -1, cz-Util::Chunk_Generate_Range, 
          gen, Block::BlockID::Grass, Block::BlockID::Dirt)
        @chunk_hash["#{cx-Util::Chunk_Generate_Range}:-1:#{cz-Util::Chunk_Generate_Range}"] = chunk
      end
    end
    
  end
  
  def add_block_at x, y, z, id = Block::BlockID::Gravel, tag = nil
    if @cooldown_checker.query?
      @cooldown_checker.cooldown_start 
      chx = (x / Util::Chunk_Size).floor
      chy = (y / Util::Chunk_Size).floor
      chz = (z / Util::Chunk_Size).floor
      inx = x - chx * Util::Chunk_Size
      iny = y - chy * Util::Chunk_Size
      inz = z - chz * Util::Chunk_Size
      @chunk_hash["#{chx}:#{chy}:#{chz}"] = Chunk.new(chx, chy, chz) if @chunk_hash["#{chx}:#{chy}:#{chz}"] == nil
      @chunk_hash["#{chx}:#{chy}:#{chz}"].add_block_at(inx, iny, inz, id, tag)
      query_each_side_has_a_block(x, y, z, true)
    end
  end
  
  def destroy_block_at x, y, z
    chx = (x / Util::Chunk_Size).floor
    chy = (y / Util::Chunk_Size).floor
    chz = (z / Util::Chunk_Size).floor
    inx = x - chx * Util::Chunk_Size
    iny = y - chy * Util::Chunk_Size
    inz = z - chz * Util::Chunk_Size
    if @chunk_hash["#{chx}:#{chy}:#{chz}"] != nil
       @chunk_hash["#{chx}:#{chy}:#{chz}"].delete_block_at(inx, iny, inz)
    end
    query_each_side_has_a_block(x, y, z, true)
  end
  
  def get_block_at x, y, z
    chx = (x / Util::Chunk_Size).floor
    chy = (y / Util::Chunk_Size).floor
    chz = (z / Util::Chunk_Size).floor
    inx = x - chx * Util::Chunk_Size
    iny = y - chy * Util::Chunk_Size
    inz = z - chz * Util::Chunk_Size
    return @chunk_hash["#{chx}:#{chy}:#{chz}"].get_block_at(inx, iny, inz) if @chunk_hash["#{chx}:#{chy}:#{chz}"] != nil
    return nil
  end
  
  #this method causes lag.
  def query_each_side_has_a_block x, y, z, do_update = false
    arr = Array.new(6, false)
    arr[0] = get_block_at(x, y - 1, z) == nil #bottom
    arr[1] = get_block_at(x, y, z - 1) == nil #sides
    arr[2] = get_block_at(x - 1, y, z) == nil #sides
    arr[3] = get_block_at(x + 1, y, z) == nil #sides
    arr[4] = get_block_at(x, y, z + 1) == nil #sides
    arr[5] = get_block_at(x, y + 1, z) == nil #top
    
    if do_update 
      chx = (x / Util::Chunk_Size).floor
      chy = (y / Util::Chunk_Size).floor
      chz = (z / Util::Chunk_Size).floor
      
      if chy != ((y - 1) / Util::Chunk_Size).floor
        add_chunk_update_request(chx, ((y - 1) / Util::Chunk_Size).floor, chz)
      elsif chy != ((y + 1) / Util::Chunk_Size).floor
        add_chunk_update_request(chx, ((y + 1) / Util::Chunk_Size).floor, chz)
      end
      
      if chx != ((x - 1) / Util::Chunk_Size).floor
        add_chunk_update_request(((x - 1) / Util::Chunk_Size).floor, chy, chz)
      elsif chx != ((x + 1) / Util::Chunk_Size).floor
        add_chunk_update_request(((x + 1) / Util::Chunk_Size).floor, chy, chz)
      end
      
      if chz != ((z + 1) / Util::Chunk_Size).floor
        add_chunk_update_request(chx, chy, ((z + 1) / Util::Chunk_Size).floor)
      elsif chz != ((z - 1) / Util::Chunk_Size).floor
        add_chunk_update_request(chx, chy, ((z - 1) / Util::Chunk_Size).floor)
      end
      
    end

    #@called += 1
    #puts @called
    
    return arr
  end 
  
  def add_chunk_update_request chx, chy, chz
    #puts "X: #{chx},Y: #{chy},Z: #{chz}"
    @chunk_update_request << "#{chx}:#{chy}:#{chz}"
  end
  
  def get_the_number_of_chunks
    return @chunk_count
  end
  
  def draw_map pos_x, pos_y, pos_z
    @chunk_count = 0
    @chunk_hash.each_pair do |key, chunk|
      if chunk_is_in_render_distance pos_x, pos_y, pos_z, key
        #if update request key matches the chunk key, then remove update the particular chunk.
        @chunk_update_request.each { |updater| chunk.flag_chunk_update = true if updater.eql? key }
        
        chunk_vertex = chunk.get_chunk_packed_vertex
        if chunk_vertex.size == 0
          @chunk_hash.delete(key)
        else
          @map_renderer.render_map_of chunk_vertex, chunk.get_tex_cord_vertex
          @chunk_count += 1;
        end
      end
    end
    #done all updates so empty requests.
    @chunk_update_request.clear
  end
  
  def chunk_is_in_render_distance pos_x, pos_y, pos_z, key
    kx, ky, kz = key.split ":" #unpack
    #chunk_center cord...
    cx = kx.to_i * Util::Chunk_Size + Util::Chunk_Size / 2
    cy = ky.to_i * Util::Chunk_Size + Util::Chunk_Size / 2
    cz = kz.to_i * Util::Chunk_Size + Util::Chunk_Size / 2
    dist = Math.sqrt((pos_x - cx)**2 + (pos_y - cy)**2 + (pos_z - cz)**2)
    return true if dist < @chuck_load_distance
    return false
  end
  
  def get_render_dist_updater
    updater = lambda do |text, progress|
      load = (5 + progress * 5).floor
      text.string= "Render Dist : #{(5 + progress * 5).floor}"
      @chuck_load_distance = Util::Chunk_Size * load
    end
    return updater
  end
  
  #called by command or keyboard f3 by eventhandler.
  def force_update_every_chunk
    @chunk_hash.each_value { |chunk| chunk.flag_chunk_update = true }
  end
  
  #called by destructor.
  def delete_all_buffers
    @map_renderer.delete_all_buffers
  end
  
end