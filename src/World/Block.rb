
class Block
  attr_reader :id
  attr_accessor :block_tag
  
  module BlockID
    Air = -1 #Dummy code
    Gravel = 0
    Red_Chiseled_Sand_Stone = 1
    Grass = 2
    Sand = 3
    Barrier = 4
    Wood_Log = 5
    Dirt = 6
  end
  
  def initialize id, block_tag
    @id = id
    @block_tag = block_tag
  end
  
  def get_block_info
    return "Id : #{@id}, Tag : #{@block_tag}"
  end
  
end