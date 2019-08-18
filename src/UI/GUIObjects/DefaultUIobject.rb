
class DefaultUIobject #data struct
  attr_accessor :enabled
  attr_reader :label
  
  def initialize drawable, label, update_func = nil, enabled = true
    @drawobj, @label, @update_callback, @enabled = drawable, label, update_func, enabled
  end
  
  def update width, height
    @update_callback.call @drawobj, width, height if @update_callback != nil
  end
  
  def draw_on window
    window.draw @drawobj
  end
  
end