require_relative "DefaultUIobject.rb"
require_relative "../FPSChecker.rb"

class DebugInformation < DefaultUIobject
  
  def initialize label, fps, playerinfo, raytraceblock, mapinfo, playerinvinfo, player_updater, raytrace_updater, map_updater, playerinv_updater, show
    super(nil, label, nil, show)
    @fps = fps
    @playerinfo = playerinfo
    @raytraceblock = raytraceblock
    @mapinfo = mapinfo
    @playerinvinfo = playerinvinfo
    @player_updater = player_updater
    @raytrace_updater = raytrace_updater
    @map_updater = map_updater
    @playerinv_updater = playerinv_updater
  end
  
  #override
  def update param
    width = param[0]
    height = param[1]
    clock = FPS.instance
    if clock.query?
      @fps.string= "FPS : #{clock.fpscount}"
      clock.reset
    else
      clock.increase
    end
    @playerinfo.position= Vector2.new 0.0, 20.0
    @player_updater.call @playerinfo
    @raytraceblock.position= Vector2.new(5.0, height - 40.0)
    @raytrace_updater.call @raytraceblock
    @mapinfo.position= Vector2.new(5.0, height - 55.0)
    @map_updater.call @mapinfo
    @playerinvinfo.position= Vector2.new(5.0, height - 70.0)
    @playerinv_updater.call @playerinvinfo
  end
  
  #override
  def draw_on window
    window.draw @fps
    window.draw @playerinfo
    window.draw @raytraceblock
    window.draw @mapinfo
    window.draw @playerinvinfo
  end
  
end