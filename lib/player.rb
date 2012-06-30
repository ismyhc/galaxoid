class Player < Chingu::GameObject
  trait :bounding_box, :debug => true, :scale => 0.8
  traits :collision_detection, :timer
  attr_accessor :color
  
  def initialize(options = {})
    super
    @mode = :default

    @hit_sound = Sound["hit.ogg"]
    @move_sound = Sound["robot_move.ogg"]
    @player_speed = 8
    @player_image_width = 10 * 4
    @player_image_height = 10 * 4
    @x = ($window.width - (@player_image_width / 2)) / 2
    @y = ($window.height - @player_image_height)
    @color = Gosu::Color.argb(0xffff8b40)
    @life_points = 100
    # Load the full animation from tile-file
    @animation = Chingu::Animation.new(:file => "player_10x10.png", :delay => 300, :bounce => true)
    @animation.frame_names = { :main => 0..2 }
    
    # Start out by animation frames 0-5 (contained by @animation[:scan])
    @frame_name = :main
  
    @last_x, @last_y = @x, @y
    update

    cache_bounding_box # This does a lot for performance
    
  end
  
  def life
    @life_points
  end

  def bullet_pattern(pattern)
    @bullet_pattern = pattern
  end
  
  def fire_bullet
    case @bullet_pattern
    when 1
      Bullet.create(:x => @x, :y => @y)
    when 2
      Bullet.create(:x => @x - 15, :y => @y)
      Bullet.create(:x => @x + 15, :y => @y)
    when 3
      Bullet.create(:x => @x - 15, :y => @y)
      Bullet.create(:x => @x, :y => @y)
      Bullet.create(:x => @x + 15, :y => @y)
    else
      Bullet.create(:x => @x, :y => @y)
    end

  end
  
  def fire_bullets
    if holding?(:space)
      after(500) { puts "ya" }
    elsif holding?(:space) == false
      
      puts "boo"
    end
    puts holding?(:space)
  end

  def move_left
    if @x <= (0 + (@player_image_width / 2))
      @x = (0 + (@player_image_width / 2))
    else
      @x = @x - @player_speed
    end
    @move_sound.play_pan(-100, 0.3, 2.0, false)

    @frame_name = :main
  end

  def move_right
    if @x >= ($window.width - (@player_image_width / 2))
      @x = ($window.width - (@player_image_width / 2))
    else
      @x = @x + @player_speed
    end
    @move_sound.play_pan(100, 0.3, 2.0, false)

    @frame_name = :main
  end

  def move_up
    if @y <= (0 + (@player_image_height / 2))
      @y = (0 + (@player_image_height / 2))
    else
      @y = @y - @player_speed
    end
    @move_sound.play_pan(0, 0.3, 2.0, false)

    @frame_name = :main
  end

  def move_down
    if @y >= ($window.height - (@player_image_height / 2))
      @y = ($window.height - (@player_image_height / 2))
    else
      @y = @y + @player_speed
    end
    @move_sound.play_pan(0, 0.3, 2.0, false)

    @frame_name = :main
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].next
    
    self.factor = 4

    #
    # If droid stands still, use the scanning animation
    #
    @frame_name = :main if @x == @last_x && @y == @last_y
    #@color = Color::BLUE
    
    
    
    @x, @y = @last_x, @last_y if outside_window?  # return to previous coordinates if outside window
    @last_x, @last_y = @x, @y                     # save current coordinates for possible use next time
  end
  
  def die!
    @life_points = @life_points - 20
    if @life_points == 0
      @color = Color::RED
    end
    #@image = Image["hit.png"]
    @hit_sound.play(0.8, 1.0, false)
  end
  
  def life_points
    @life_points
  end
  
  def life_bonus!
    @life_points = @life_points + 20
  end

  def reset!
    #@image = Image["player.png"]
    @x = ($window.width - (@player_image_width / 2)) / 2
    @y = ($window.height - @player_image_height)
  end
  
end