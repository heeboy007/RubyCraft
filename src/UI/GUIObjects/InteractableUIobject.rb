require_relative "DefaultUIobject.rb"
require_relative "../../Maths/General_Maths.rb"

#Also serves a roll of buttons...
class InteractableUIobject < DefaultUIobject
  include General_Maths
  
  def initialize drawable, label, rect, listener
    @box, @text = drawable
    @box_default_width, @box_default_height = @box.local_bounds.width, @box.local_bounds.height
    super(@box, label, nil, true)
    @rect = rect #rect must be normalized
    @update_listener = listener
  end
  
  #override
  def update param
    width = param[0]
    height = param[1]
    #puts "upda #{width}, #{height}"
    pos_x, pos_y, pressed = param[2]
    pixel_left, pixel_top, pixel_width, pixel_height = width * @rect.left, height * @rect.top, width * @rect.width, height * @rect.height
    @box.position= Vector2.new(pixel_left, pixel_top)
    @text.position= Vector2.new(pixel_left + (pixel_width - @text.local_bounds.width) / 2.0, pixel_top + (pixel_height - @text.local_bounds.height) / 2.0 - 5)
    
    @box.rotation= 0.0
    
    @box.scale= Vector2.new(pixel_width / @box_default_width, pixel_height / @box_default_height)
    @text.color= Color::White
    if is_in_range? pos_x, pos_y, [pixel_left, pixel_width], [pixel_top, pixel_height]
      @text.color= Color::Yellow
      
      if pressed
        @box.rotation= 180.0
        @box.position= Vector2.new(pixel_left + pixel_width, pixel_top + pixel_height)
        @update_listener.call(@text) if (@update_listener != nil)
      end
    end
  end
  
  #override
  def draw_on window
    window.draw @box
    window.draw @text
  end
  
end
