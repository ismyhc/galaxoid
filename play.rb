class Play < Chingu::GameState
  traits :timer
  
  class << self
    attr_accessor :score
  end
  
  def setup    
    @song = Song["background_song.ogg"]
    #@background = Image["play_background.png"]
    @parallax = Chingu::Parallax.create(:x => 100, :y => 100, :rotation_center => :top_left, :zorder => 5)
    @parallax << { :image => "outerspace_pattern.jpg", :damping => 1, :repeat_x => true, :repeat_y => true }
    @parallax << { :image => "moon.png", :damping => 2, :repeat_x => true, :repeat_y => false }
    @song.play(true)    
    @player = Player.create(:x => @x, :y => @y)
    @player.factor = 3
    
    @player.input = { [:holding_a, :holding_left, :holding_pad_left] => :move_left, 
                      [:holding_d, :holding_right, :holding_pad_right] => :move_right, 
                      [:holding_w, :holding_up, :holding_pad_up] => :move_up, 
                      [:holding_s, :holding_down, :holding_pad_down] => :move_down
                    }
    self.input = { [:q, :escape] => :exit, :p => :pause,
                   [:holding_a, :holding_left, :holding_pad_left] => :camera_left, 
                   [:holding_d, :holding_right, :holding_pad_right] => :camera_right, 
                   [:holding_w, :holding_up, :holding_pad_up] => :camera_up, 
                   [:holding_s, :holding_down, :holding_pad_down] => :camera_down
                 } 
    @enemy = []
    10.times { @enemy << new_enemy }
    @running = true
    @score = 0
    @score_font = Gosu::Font.new($window, "fonts/phaserbank.ttf", 20)
  end
  
  def camera_left
    @parallax.camera_x -= 1
  end
  def camera_right
    @parallax.camera_x += 1
  end
  def camera_up
    @parallax.camera_y -= 1
  end
  def camera_down
    @parallax.camera_y += 1
  end
  
  def new_enemy
    Enemy.create(:x => @x, :y => @y)
    #Enemy.factor = rand(1..3)
    
  end
  
  def update
    if @running
      @score = @score + 1
      super
    
      @player.each_collision(@enemy) do |player, enemy|
        player.die!
        enemy.die!
        if @player.life_points <= 0
          stop_game!        
        end
        
      end
      
    end
  end
  
  def stop_game!
    @running = false
    @song.stop
    after(1000) { end_game }
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
    @score_font.draw("Current Score: <c=fff000>#{@score}</c>", 10, 10, 20)
    $window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    super
  end
end