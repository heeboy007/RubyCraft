require_relative "Block.rb"

class Player
  
  def initialize
    
    #maybe add hunger and hp to here?....
    @inventory = [
      [Block::BlockID::Gravel, Float::INFINITY], [Block::BlockID::Red_Chiseled_Sand_Stone, Float::INFINITY], 
      [Block::BlockID::Grass, Float::INFINITY], [Block::BlockID::Sand, Float::INFINITY],
      [nil, nil], [nil, nil], [nil, nil], [nil, nil], [nil, nil]
    ]
    @holding_hotbar = 0
    
  end
  
  def get_player_info_updater
    updater = lambda do |obj|
      if @inventory[@holding_hotbar][0] != nil
        obj.string= "Hold: #{@holding_hotbar}, Selected Item ID: #{@inventory[@holding_hotbar][0]}, Amount: #{@inventory[@holding_hotbar][1]}" 
      else
        obj.string= "Hold: #{@holding_hotbar}"
      end
    end
    
    return updater
  end
  
  def get_current_item_id
    return @inventory[@holding_hotbar][0]
  end
  
  def is_holding_item_placeable
    if @inventory[@holding_hotbar][0] == nil
      return false
    else
      if @inventory[@holding_hotbar][1] <= 0
        return false
      else
        return true
      end
    end
  end
  
  def move_holding_right
    if @holding_hotbar < 8
      @holding_hotbar = @holding_hotbar + 1
    else
      @holding_hotbar = 0
    end
  end
  
  def move_holding_left
    if @holding_hotbar > 0
      @holding_hotbar = @holding_hotbar - 1
    else
      @holding_hotbar = 8
    end 
  end
  
  def use_selected_item
    @inventory[@holding_hotbar][1] = @inventory[@holding_hotbar][1] - 1
  end
  
end