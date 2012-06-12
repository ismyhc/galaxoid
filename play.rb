class Play < Chingu::GameState
  traits :timer
  
  class << self
    attr_accessor :score
  end
  
  def setup    
    @song = Song["background_song.ogg"]
    @background = Image["play_background.png"]
    @song.play(true)    
    @player = Player.create(:x => @x, :y => @y)
    @player.factor = 3
    @player.input = { [:holding_a, :holding_left, :holding_pad_left] => :move_left, 
                      [:holding_d, :holding_right, :holding_pad_right] => :move_right, 
                      [:holding_w, :holding_up, :holding_pad_up] => :move_up, 
                      [:holding_s, :holding_down, :holding_pad_down] => :move_down
                    }
    self.input = { [:q, :escape] => :exit, :p => :pause }
    @enemy = []
    10.times { @enemy << new_enemy }
    @running = true
    @score = 0
    @score_font = Gosu::Font.new($window, "fonts/phaserbank.ttf", 20)
  end
  
  def new_enemy
    Enemy.create(:x => @x, :y => @y)
  end
  
  def update
    if @running
      @score = @score + 1
      super
    
      @player.each_collision(@enemy) do |player, enemy|
        player.die!
        enemy.die!
        stop_game!        
      end

    end
  end
  
  def stop_game!
    @running = false
    @song.stop
    after(2000) { end_game }
  end
  
  def pause
    push_game_state(Chingu::GameStates::Pause)
  end
  
  def end_game
    @enemy.each { |enemy| enemy.reset! }
    @player.reset!
    push_game_state(HighScore)
    #score_reset!
  end
  
  def finalize
    HighScore.score(@score)
  end
  
  def draw    
    #@background.draw(0, 0, 1)
    @score_font.draw("Current Score: <c=fff000>#{@score}</c>", 10, 10, 5)
    $window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    super
  end
end