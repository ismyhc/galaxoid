class Player < Chingu::GameObject
  trait :bounding_box, :debug => false, :scale => 0.8
  traits :collision_detection, :timer
  attr_accessor :color
  attr_accessor :bullet_pattern
  
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
    @animation = Chingu::Animation.new(:file => "player_10x10.png", :delay => 300, :bounce => true)
    @animation.frame_names = { :main => 0..2 }
    @bullet_pattern = 1
    
    # Start out by animation frames 0-5 (contained by @animation[:scan])
    @frame_name = :main
  
    @last_x, @last_y = @x, @y
    update

    cache_bounding_box # This does a lot for performance
    
  end
  
  def life
    @life_points
  end

  def fire_bullet
    case @bullet_pattern
    when 1
      Bullet.create(:x => @x, :y => @y)
    when 2
      Bullet.create(:x => @x - 17, :y => @y)
      Bullet.create(:x => @x + 17, :y => @y)
    when 3
      Bullet.create(:x => @x - 17, :y => @y)
      Bullet.create(:x => @x, :y => @y)
      Bullet.create(:x => @x + 17, :y => @y)
    when 4
      left_bullet = Bullet.create(:x => @x - 17, :y => @y)
      left_bullet.bullet_angle=("left")
      Bullet.create(:x => @x, :y => @y)
      right_bullet = Bullet.create(:x => @x + 17, :y => @y)
      right_bullet.bullet_angle=("right")
    else
      Bullet.create(:x => @x, :y => @y)
    end
  end
  
  def move_left
    if @x <= (0 + (@player_image_width / 2))
      @x = (0 + (@player_image_width / 2))
    else
      @x = @x - @player_speed
    end
    @frame_name = :main
  end

  def move_right
    if @x >= ($window.width - (@player_image_width / 2))
      @x = ($window.width - (@player_image_width / 2))
    else
      @x = @x + @player_speed
    end
    @frame_name = :main
  end

  def move_up
    if @y <= (0 + (@player_image_height / 2))
      @y = (0 + (@player_image_height / 2))
    else
      @y = @y - @player_speed
    end
    @frame_name = :main
  end

  def move_down
    if @y >= ($window.height - (@player_image_height / 2))
      @y = ($window.height - (@player_image_height / 2))
    else
      @y = @y + @player_speed
    end
    @frame_name = :main
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].next
    
    self.factor = 4

    @frame_name = :main if @x == @last_x && @y == @last_y
    
    @x, @y = @last_x, @last_y if outside_window?  # return to previous coordinates if outside window
    @last_x, @last_y = @x, @y                     # save current coordinates for possible use next time
  end
  
  def die!
    @life_points = @life_points - 20
    if @life_points === 0
      # Need to fix this... Would like a better effect for player death!
      between(10,300) { self.angle += 30; @y += 800}.then { self.angle = 0}
    else
      between(10,300) { self.angle += 30}.then { self.angle = 0}
    end
    @hit_sound.play(0.6, 1.0, false)
  end
  
  def life_points
    @life_points
  end
  
  def life_bonus!
    if @life_points >= 100
    else
      @life_points = @life_points + 20
    end
  end

  def reset!
    @x = ($window.width - (@player_image_width / 2)) / 2
    @y = ($window.height - @player_image_height)
  end
  
end