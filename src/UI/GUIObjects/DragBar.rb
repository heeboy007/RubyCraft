require_relative "InteractableUIobject.rb"
require_relative "../../Maths/General_Maths.rb"

#drag bar can be dragggged.
class DragBar < InteractableUIobject
  include General_Maths
  
  def initialize drawable, label, rect, listener
    super(drawable, label, rect, listener)
    @drag_draw = drawable[2] #Actual Moving Button.
    @drag_draw_default_width, @drag_draw_default_height = @drag_draw.local_bounds.width, @drag_draw.local_bounds.height
    @drag_x = 0
    @drag_progress = 0.0
    @update_listener.call(@text, @drag_progress) if @update_listener != nil
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
    @drag_draw.position= Vector2.new(pixel_left + @drag_x, pixel_top)
    @drag_draw.rotation= 0.0
    
    width_scaler = @drag_draw_default_width.to_f / @box_default_width.to_f
    width_scaler *= 0.4
    
    @box.scale= Vector2.new(pixel_width / @box_default_width, pixel_height / @box_default_height)
    @drag_draw.scale= Vector2.new(pixel_width / (@drag_draw_default_width) * width_scaler, pixel_height / @drag_draw_default_height)
    @text.color= Color::White
    if is_in_range? pos_x, pos_y, [pixel_left, pixel_width], [pixel_top, pixel_height]
      @text.color= Color::Yellow
      if pressed
        #set x cord of the drager where cursor is.
        @drag_x = pos_x - pixel_left - pixel_width * width_scaler / 2.0
        @drag_x = 0 if @drag_x < 0 
        @drag_x = pixel_width - pixel_width * width_scaler if @drag_x > pixel_width - pixel_width * width_scaler
        
        #set output value to equal amout of draged distances max 1 min 0  
        @drag_progress = @drag_x.to_f / (pixel_width - pixel_width * width_scaler)
        
        #rotate 180 degrees to make it look like pressed.
        @drag_draw.rotation= 180.0
        @drag_draw.position= Vector2.new(pixel_left + @drag_x + pixel_width * width_scaler, pixel_top + pixel_height)
        @update_listener.call(@text, @drag_progress) if @update_listener != nil
      end
    end
  end
  
  #override
  def draw_on window
    window.draw @box
    window.draw @drag_draw
    window.draw @text
  end
  
end