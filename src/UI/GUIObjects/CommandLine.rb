require_relative "DefaultUIobject.rb"

class CommandLine < DefaultUIobject
  
  def initialize label, box_draw, text_draw, text_update
    super(nil, label, nil, false)
    @command_text = text_draw
    @command_box = box_draw
    @command_text_updater = text_update
  end
  
  #override
  def update param
    width = param[0]
    height = param[1]
    @command_text.position= Vector2.new(7.0, height - 20.0)
    @command_text_updater.call @command_text
    @command_box.position= Vector2.new(5.0, height - 23.0)
    @command_box.size= Vector2.new(width - 10.0, 18.0)
  end
  
  #override
  def draw_on window
    window.draw @command_box
    window.draw @command_text
  end
  
end
