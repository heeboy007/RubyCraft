
module TextureManager
  
  module Sides
    
    Top = 5
    Right = 1
    Front = 2
    Back = 3
    Left = 4
    Bottom = 0
    
  end
  
  module TexturePos
    
    Gravel = 0
    Barrier = 1
    Sand = 2
    Grass_Top = 3
    Grass_Side = 4
    Grass_Bottom = 5
    Log_Side = 6
    Log_Top_Bottom = 7
    Red_Chiseled_Sand_Stone = 8
    
  end
  include TexturePos
  
  @@texrure_link = [
    ["All", Gravel], #id : 0
    ["All", Red_Chiseled_Sand_Stone], #id : 1
    ["T_B_S", Grass_Top, Grass_Bottom, Grass_Side],
    ["All", Sand],
    ["All", Barrier],
    ["Log", Log_Top_Bottom, Log_Side],
    ["All", Grass_Bottom]
  ]
  
  def get_texture_position_by block_id, which_side
    
    info = @@texrure_link[block_id]
    type = info[0]
    
    if type.eql?("All")
      return info[1]
    elsif type.eql?("T_B_S")
      if Sides::Top == which_side
        return info[1]
      elsif Sides::Bottom == which_side
        return info[2]
      else
        return info[3]
      end
    elsif type.eql?("Log")
      if Sides::Top == which_side || Sides::Bottom == which_side
        return info[1]
      else
        return info[2]
      end
    end
    
  end
  
end