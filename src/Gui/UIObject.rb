
class UIobject #data struct
  attr_reader :drawobj
  attr_accessor :enabled
  attr_reader :label
  
  def initialize drawable, label, update_func = nil, enabled = true
    @drawobj, @label, @update_callback, @enabled = drawable, label, update_func, enabled
  end
  
  def update
    @update_callback.call @drawobj if @update_callback != nil
  end
  
end