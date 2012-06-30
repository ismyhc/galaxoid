class Play < Chingu::GameState

  traits :timer, :effect
  
  class << self
    attr_accessor :score
  end
  
  def setup    

    self.input = { [:q, :escape] => :exit, :p => :pause,
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
#    @player.bullet_pattern(1)
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

    # Setup bonus objects
    life_bonus_time = rand(15000) + 5000
    score_bonus_time = rand(13000) + 3000
    weapon_bonus_time = rand(10000) + 20000
    every(life_bonus_time) { @life_bonus = new_life_bonus }
    every(score_bonus_time) { @score_bonus = new_score_bonus }
    every(weapon_bonus_time) { @weapon_bonus = new_weapon_bonus }

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
    @parallax.camera_y += 0.5
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
    Text.destroy_all
      
    message = Text.create("#{action} #{text_color}#{text}</c>", :font => $default_font, :x => 10, :y => y, :size => 20)
    after(2000) { message.destroy! }
  end
  
  def update
    if @running
      super
      @parallax.camera_y -= 2
      @score = @score + 1
    
      # Player collision with Enemies
      @player.each_bounding_box_collision(@enemy) do |player, enemy|
        player.die!
        enemy.die!
        
        action_message("HP", "-20", "<c=ff0000>",  60)
        
        if @player.life_points <= 0
          stop_game!        
        end
        
      end

      # Player collisions with Life Bonuses
      @player.each_bounding_box_collision(@life_bonus) do |player, life_bonus|
        puts "Player at: #{player.x}, #{player.y}"
        puts "Life bonus at: #{life_bonus.x}, #{life_bonus.y}"
        life_bonus.die!

        if @player.life_points >= 100
          @score = @score + 5000
          action_message("Score", "+5000", "<c=fff000>",  80)
        else
          player.life_bonus!
          action_message("HP", "+20", "<c=00ff00>",  80)
        end
        
      end
      
      # Player collisions with Weapons Bonuses
      @player.each_bounding_box_collision(@weapon_bonus) do |player, weapon_bonus|
        puts "Player at: #{player.x}, #{player.y}"
        puts "Weapon bonus at: #{weapon_bonus.x}, #{weapon_bonus.y}"
        weapon_bonus.die!
        set_bullet_pattern(3)
        after(10000) { set_bullet_pattern(2) }
        after(20000) { set_bullet_pattern(1) }

        action_message("Weapon", "Upgrade!", "<c=00ff00>",  80)
        
      end

      # Player collisions with Score Bonuses
      @player.each_bounding_box_collision(@score_bonus) do |player, score_bonus|
        puts "Player at: #{player.x}, #{player.y}"
        puts "Score bonus at: #{score_bonus.x}, #{score_bonus.y}"
        score_bonus.die!
        
        bonus = rand(1500) + 5000
        @score = @score + bonus
        
        action_message("Score", "+#{bonus}", "<c=fff000>",  100)
      end
      
      Bullet.each_bounding_box_collision(@enemy) do |bullet, enemy|

        bonus = (rand(1900) + 100) + (enemy.y + bullet.y)
        enemy.die!
        @bullet_death.play
        bullet.die!
        
        @score = @score + bonus
        action_message("Score", "+#{bonus}", "<c=fff000>",  120)
        
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
    push_game_state(Chingu::GameStates::Pause, :setup => true)
  end
  
  def finalize
    HighScore.score(@score)
    @enemy.each { |enemy| enemy.destroy! }
    @player.destroy!
  end
  
  def life_bar(size)
    life = size
    fill_rect([9,39,102,12], Color::WHITE, 25)
    fill_rect([10,40,100,10], Color::BLACK, 25)
    fill_rect([10,40,size,10], Color::RED, 25)
  end
  
  def draw
    life_bar(@player.life)
    @score_font = Chingu::Text.new("Current Score: <c=fff000>#{@score}</c>", :font => $default_font, :size => 20, :x => 10, :y => 10, :zorder => 20).draw
    $window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    #$window.caption = "GALAXOID"
    super
  end
end