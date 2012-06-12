class End < Chingu::GameState
  def setup    
    @song = Song["end.ogg"]
    @song.play(true)
    self.input = { [:q, :escape] => :exit, :return => :load }
    
    @message = "The End..."
    @x = 200
    @y = 200
    @font = Chingu::Text.create(@message, :font => "LastResort", :size => 60, :color => Color::RED, :x => @x, :y => @y)
  end
  
  def update
    super
    
  end
  
  def load
    push_game_state(HighScore)
  end
  
  def finalize
    @song.stop
  end

  def draw
    $window.caption = "Game ended!"
   # fill_rect([10,10,100,100], Color::WHITE)
    super
  end
end