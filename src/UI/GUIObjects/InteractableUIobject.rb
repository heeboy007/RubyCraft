require_relative "DefaultUIobject.rb"

require_relative "../../Maths/General_Maths.rb"

class InteractableUIobject < DefaultUIobject
  include General_Maths
  
  def initialize drawable, label, rect, listener
    @box, @text = drawable
    super(@box, label, nil, true)
    @update_listener = listener
    @rect = rect #rect must be normalized
  end
  
  #override
  def update param
    width = param[0]
    height = param[1]
    pos_x, pos_y, pressed = param[2]
    pixel_left, pixel_top, pixel_width, pixel_height = width * @rect.left, height * @rect.top, width * @rect.width, height * @rect.height
    @box.position= Vector2.new(pixel_left, pixel_top)
    @text.position= Vector2.new(pixel_left + (pixel_width - @text.local_bounds.width) / 2.0, pixel_top + (pixel_height - @text.local_bounds.height) / 2.0)
    @box.scale= Vector2.new(pixel_width / 256.0, pixel_height / 64.0)
    @text.color= Color::White
    if is_in_range? pos_x, pos_y, [pixel_left, pixel_width], [pixel_width, pixel_height]
      @text.color= Color::Red
      @update_listener.call if pressed
    end
  end
  
  #override
  def draw_on window
    window.draw @box
    window.draw @text
  end
  
end
