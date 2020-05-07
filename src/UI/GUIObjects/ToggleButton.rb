require_relative "DefaultUIobject.rb"
require_relative "../../Maths/General_Maths.rb"

#Also serves a roll of buttons...
class ToggleButton < InteractableUIobject
  include General_Maths
  
  def initialize drawable, label, rect, const_update, when_toggled
    super(drawable, label, rect, const_update)
    @const_update = const_update
    @when_toggled = when_toggled
    @prev_press = false
    @when_toggled.call(@text) if (@when_toggled != nil)
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
        @const_update.call(@text, pressed) if (@const_update != nil)
        if !@prev_press
          @when_toggled.call(@text) if (@when_toggled != nil)
        end
      end
      @prev_press = pressed
    end
  end
  
end
