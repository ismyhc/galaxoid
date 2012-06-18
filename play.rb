class Play < Chingu::GameState
  traits :timer
  
  class << self
    attr_accessor :score
  end
  
  def setup    
    @parallax = Chingu::Parallax.create(:x => 100, :y => 100, :rotation_center => :top_left, :zorder => 5)
    @parallax << { :image => "outerspace_pattern.jpg", :damping => 1, :repeat_x => true, :repeat_y => true }
    @parallax << { :image => "moon.png", :damping => 2, :repeat_x => true, :repeat_y => false }
    
    @song = Song["background_song.ogg"]
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
    6.times { @enemy << new_enemy }
    every(30000) { 2.times { @enemy << new_enemy } }
    #@life_bonus = []
    life_bonus_time = rand(5000...20000)
    score_bonus_time = rand(3000...16000)
    every(life_bonus_time) { @life_bonus = new_life_bonus }
    every(score_bonus_time) { @score_bonus = new_score_bonus }
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
  end

  def new_life_bonus
    LifeBonus.create(:x => @x, :y => @y)
  end

  def new_score_bonus
    ScoreBonus.create(:x => @x, :y => @y)
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

      @player.each_collision(@life_bonus) do |player, life_bonus|
        life_bonus.die!
        if @player.life_points >= 100
          @score = @score + 500
        else
          player.life_bonus!
        end
      end

      @player.each_collision(@score_bonus) do |player, score_bonus|
        score_bonus.die!
        @score = @score + 1000
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
  
  def life_bar(size)
    life = size
    fill_rect([9,39,102,12], Color::WHITE, 25)
    fill_rect([10,40,100,10], Color::BLACK, 25)
    fill_rect([10,40,size,10], Color::RED, 25)
  end
  
  def draw    
    @score_font.draw("Current Score: <c=fff000>#{@score}</c>", 10, 10, 20)
    life_bar(@player.life)
    $window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    super
  end
end