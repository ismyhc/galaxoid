class Play < Chingu::GameState

  traits :timer, :effect
  Chingu::Text.trait :asynchronous
  
  class << self
    attr_accessor :score
  end
  
  def setup 
    super
    @mode = :additive
    $window.caption = "GALAXOID alpha-#{$galaxoid_version}"
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
    
    # Setup bonus objects
    life_bonus_time = rand(15000) + 5000
    score_bonus_time = rand(13000) + 3000
    weapon_bonus_time = rand(10000) + 25000
    every(life_bonus_time) { @life_bonus = new_life_bonus }
    every(score_bonus_time) { @score_bonus = new_score_bonus }
    every(weapon_bonus_time) { @weapon_bonus = new_weapon_bonus }
    
    @hs_text = Gosu::Font.new($window, $default_font, 20)
    @hs_text.text_width("0123456789")
    new_hs = $hs.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    #@hs_text.draw_rel("High Score", $window.width - 10, -3, 24, 1, 0)
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
      q.tween(1500, :alpha => 20, :scale => 5)
      q.call :destroy
    end

    during(1000) { text.y=(y -= 3) }
  end
  
  def update
    if @running
      super
      
      @parallax.camera_y -= 0.5
      @score = @score + 1
    
      # Player collision with Enemies
      @player.each_bounding_box_collision(@enemy) do |player, enemy|
        if enemy.enemy_active === true
          enemy.enemy_active=(false)
          
          if player.bullet_pattern > 1
            player.bullet_pattern=(player.bullet_pattern - 1)
          end
          
          enemy.reset!
          player.die!
        
          action_message("HP", "-20", "<c=ff0000>",  200)
        
          if @player.life_points <= 0
            after(200) { stop_game! }
          end
        end
        
      end

      # Player collisions with Life Bonuses
      @player.each_bounding_box_collision(@life_bonus) do |player, life_bonus|
        life_bonus.die!

        if player.life_points >= 100
          bonus = ((life_bonus.y + life_bonus.x) + (player.x + player.y)) * (rand(4) + 1)
          @score = @score + bonus
          action_message("Score", "+#{bonus}", "<c=fff000>",  200)
        elsif player.life_points < 100
          player.life_bonus!
          action_message("HP", "+20", "<c=00ff00>",  200)
        end
        
      end
      
      # Player collisions with Weapons Bonuses
      @player.each_bounding_box_collision(@weapon_bonus) do |player, weapon_bonus|

        if player.bullet_pattern < 4
          weapon_bonus.die!(true)
          player.bullet_pattern=(player.bullet_pattern + 1)
          action_message("Weapon", "Upgrade!", "<c=00ff00>",  200)
        elsif player.bullet_pattern === 4
          weapon_bonus.die!(false)
          bonus = ((weapon_bonus.y + weapon_bonus.x) + (player.x + player.y)) * (rand(15) + 1)
          @score = @score + bonus
          action_message("Score", "+#{bonus}", "<c=fff000>",  200)
        end
        
      end

      # Player collisions with Score Bonuses
      @player.each_bounding_box_collision(@score_bonus) do |player, score_bonus|
        score_bonus.die!
        bonus = ((score_bonus.y + score_bonus.x) + (player.x + player.y)) * (rand(4) + 1)
        @score = @score + bonus
        action_message("Score", "+#{bonus}", "<c=fff000>",  200)
      end
      
      # Bullet collisions with enemies
      Bullet.each_bounding_box_collision(@enemy) do |bullet, enemy|

        if enemy.enemy_active === true
          enemy.enemy_active=(false)
          enemy.async do |q|
            q.tween(500, :alpha => 0, :x => enemy.x, :y => enemy.y, :angle => 270)
            q.call :die!
          end
          @bullet_death.play(0.2)
          bullet.die!
        
          bonus = (rand(1900) + 100) + (bullet.y)
          @score = @score + bonus
       
        end
        
      end
      
      # Destroy bullet object if outside of window
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

  def draw
    life_bar(@player.life)
    @hs_text.draw_rel("Score: <c=fff000>#{@score}</c>", 10, -3, 24, 0, 0)
    #$window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    super
  end
end