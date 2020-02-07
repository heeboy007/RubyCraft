require_relative "DefaultUIobject.rb"

class PlayerThetaDisplay < DefaultUIobject
  
  def initialize label, graph, graph_point, point_updater
    super(nil, label, nil, true)
    @graph = graph
    @graph_point = graph_point
    @point_updater = point_updater
  end
  
  #override
  def update param
    width = param[0]
    height = param[1]
    @graph_point.position= Vector2.new((width-50).to_f, 50.0)
    @point_updater.call @graph_point
    @graph.position= Vector2.new((width-100).to_f, 0.0)
  end
  
  #override
  def draw_on window
    window.draw @graph
    window.draw @graph_point
  end
  
end