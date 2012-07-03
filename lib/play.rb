class Play < Chingu::GameState

  traits :timer, :effect
  Chingu::Text.trait :asynchronous
  
  class << self
    attr_accessor :score
  end
  
  def setup 
    super
    @mode = :additive
    $window.caption = "GALAXOID alpha-0.2"
    @message
    @center_x = $window.width / 2
    @center_y = $window.height / 2   

    self.input = { :escape => :exit, :p => :pause,
                   [:holding_a, :holding_left, :holding_pad_left] => :camera_left, 
                   [:holding_d, :holding_right, :holding_pad_right] => :camera_right, 
                   [:holding_w, :holding_up, :holding_pad_up] => :camera_up, 
                   [:holding_s, :holding_down, :holding_pad_down] => :camera_down } 

    @background = Image["outerspace_pattern.jpg"]
    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => 5)
    @parallax << { :image => @background, :damping => 1, :repeat_x => true, :repeat_y => true }
    
    @song = Sound["song1.ogg"].play(0.8, 0.9, true)
    @running = true
    @score = 0
    
    # Setup and create player
    @player = Player.create(:x => @x, :y => @y)
  
    set_bullet_pattern(1)
  
    @player.input = { [:holding_a, :holding_left, :holding_pad_left] => :move_left, 
                      [:holding_d, :holding_right, :holding_pad_right] => :move_right, 
                      [:holding_w, :holding_up, :holding_pad_up] => :move_up, 
                      [:holding_s, :holding_down, :holding_pad_down] => :move_down,
                      [:space, :return, :pad_button_2] => :fire_bullet  }
                      
    @bullet_death = Sound["bullet_death.ogg"]
 
    # Setup and create enemies
    @enemy = []
    6.times { @enemy << new_enemy }
    every(30000) { 2.times { @enemy << new_enemy } }
    
    # Score multipliers
#    @score_multi = 0
#    @score_multi_timer = every(5000) { @score_multi = 0 }

    # Setup bonus objects
    life_bonus_time = rand(15000) + 5000
    score_bonus_time = rand(13000) + 3000
    weapon_bonus_time = rand(10000) + 25000
    every(life_bonus_time) { @life_bonus = new_life_bonus }
    every(score_bonus_time) { @score_bonus = new_score_bonus }
    every(weapon_bonus_time) { @weapon_bonus = new_weapon_bonus }
    
    @hs_text = Gosu::Font.new($window, $default_font, 20)
    new_hs = $hs.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    @hs_text.draw_rel("High Score", $window.width - 10, -3, 24, 1, 0)
    Chingu::Text.create("High Score", :font => $default_font, :size => 20, :x => $window.width - 10,
                        :y => -3, :zorder => 24, :rotation_center => :top_right).draw
    Chingu::Text.create("#{$hs_name} : <c=fff000>#{new_hs} </c>", :font => $default_font, :size => 20, :x => $window.width - 6,
                        :y => 16, :zorder => 24, :rotation_center => :top_right).draw
    @message = []
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
    @parallax.camera_y += 0.3
  end
  
  def set_bullet_pattern(pattern)
    @player.bullet_pattern(pattern)
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
  
  def new_weapon_bonus
    WeaponBonus.create(:x => @x, :y => @y)
  end
  
  def action_message(action, text, text_color, y)
    if !@message.empty?
      @message.each do |message|
        message.destroy!
        @message.pop
      end
    end
    
    text = Text.create("#{action} #{text_color}#{text}</c>", :font => $default_font,
                        :x => 10, :y => y, :size => 20)
    text.async do |q|
      q.tween(175, :alpha => 20, :scale => 2)
      q.call :destroy
    end

    during(200) { text.y=(y -= 5) }
  end
  
  def update
    if @running
      super

      
     # if @score_multi == 10
      #  @score_multi = 0
      #  stop_timer(@score_multi_timer)
       # @score = @score * 2
      #  @score_multi_timer = every(5000) { @score_multi = 0 }
      #  action_message("MULTIPLIER!", "Score.times 2!", "<c=00ff00>",  200)
      #end

      @parallax.camera_y -= 0.5
      @score = @score + 1
    
      # Player collision with Enemies
      @player.each_bounding_box_collision(@enemy) do |player, enemy|
        enemy.reset!
        player.die!
        
        action_message("HP", "-20", "<c=ff0000>",  100)
        
        if @player.life_points <= 0
          after(200) { stop_game! }
        end
        
      end

      # Player collisions with Life Bonuses
      @player.each_bounding_box_collision(@life_bonus) do |player, life_bonus|
        life_bonus.die!

        if @player.life_points >= 100
          @score = @score + 5000
          action_message("Score", "+5000", "<c=fff000>",  100)
        else
          player.life_bonus!
          action_message("HP", "+20", "<c=00ff00>",  100)
        end
        
      end
      
      # Player collisions with Weapons Bonuses
      @player.each_bounding_box_collision(@weapon_bonus) do |player, weapon_bonus|
        weapon_bonus.die!
        set_bullet_pattern(3)
        after(10000) { set_bullet_pattern(2) }
        after(20000) { set_bullet_pattern(1) }

        action_message("Weapon", "Upgrade!", "<c=00ff00>",  100)
        
      end

      # Player collisions with Score Bonuses
      @player.each_bounding_box_collision(@score_bonus) do |player, score_bonus|
        score_bonus.die!
        
        bonus = rand(1500) + 5000
        @score = @score + bonus
        
        action_message("Score", "+#{bonus}", "<c=fff000>",  100)
      end
      
      Bullet.each_bounding_box_collision(@enemy) do |bullet, enemy|

        if enemy.enemy_active == true
          # Score multiplier
          #@score_multi += 1
          enemy.enemy_active=(false)
          bonus = (rand(1900) + 100) + (bullet.y)

          @bullet_death.play(0.2)
          bullet.die!
        
          @score = @score + bonus
          action_message("Score", "+#{bonus}", "<c=fff000>",  100)        
       
          enemy.async do |q|
            q.tween(250, :alpha => 0, :x => enemy.x, :y => enemy.y, :angle => 270)
            q.call :die!
          end

          @enemy.delete_at(@enemy.index(enemy))
          @enemy << new_enemy
        end
        
      end
      
      Bullet.destroy_if { |bullet| bullet.outside_window? }
      
    end
  end
  
  def stop_game!
    @running = false
    @song.stop
    push_game_state(HighScore, :finalize => true)
  end
  
  def pause
    push_game_state(Chingu::GameStates::Pause, :finalize => false)
  end
  
  def finalize
    HighScore.score(@score)
    @enemy.each { |enemy| enemy.destroy! }
    @player.destroy!
  end
  
  def life_bar(size)
    life = size
    fill_rect([9,24,102,10], Color::WHITE, 25)
    fill_rect([10,25,100,8], Color::BLACK, 25)
    fill_rect([10,25,size,8], Color::RED, 25)
  end

  def weapon_indicator
    
  end
  
  def draw
    life_bar(@player.life)
    @score_font = Chingu::Text.new("Score: <c=fff000>#{@score}</c>", :font => $default_font, :size => 20, :x => 10, :y => -3, :zorder => 24).draw
    #$window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    super
  end
end