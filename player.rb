class Player < Chingu::GameObject
  traits :collision_detection, :bounding_circle, :timer
  attr_accessor :color
  
  def initialize(options = {})
    super
    @mode = :additive
    
#    @image = Image["player.png"]
    @hit_sound = Sound["no.ogg"]
    @player_speed = 10
    @player_image_width = 11
    @player_image_height = 15
    @x = ($window.width - (@player_image_width / 2)) / 2
    @y = ($window.height - @player_image_height)
    #@color = Color::BLUE

    # Load the full animation from tile-file media/droid.bmp
    @animation = Chingu::Animation.new(:file => "droid_11x15.bmp")
    @animation.frame_names = { :scan => 0..5, :up => 6..7, :down => 8..9, :left => 10..11, :right => 12..13 }
    
    # Start out by animation frames 0-5 (contained by @animation[:scan])
    @frame_name = :scan
  
    @last_x, @last_y = @x, @y
    update

    cache_bounding_circle # This does a lot for performance
    
  end
  
  def move_left
    if @x <= (0 + (@player_image_width / 2))
      @x = (0 + (@player_image_width / 2))
    else
      @x = @x - @player_speed
    end

    @frame_name = :left
  end

  def move_right
    if @x >= ($window.width - (@player_image_width / 2))
      @x = ($window.width - (@player_image_width / 2))
    else
      @x = @x + @player_speed
    end

    @frame_name = :right
  end

  def move_up
    if @y <= (0 + (@player_image_height / 2))
      @y = (0 + (@player_image_height / 2))
    else
      @y = @y - @player_speed
    end

    @frame_name = :up
  end

  def move_down
    if @y >= ($window.height - (@player_image_height / 2))
      @y = ($window.height - (@player_image_height / 2))
    else
      @y = @y + @player_speed
    end

    @frame_name = :down
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].next
    
    #
    # If droid stands still, use the scanning animation
    #
    @frame_name = :scan if @x == @last_x && @y == @last_y
    #@color = Color::BLUE
    
    @x, @y = @last_x, @last_y if outside_window?  # return to previous coordinates if outside window
    @last_x, @last_y = @x, @y                     # save current coordinates for possible use next time
  end
  
  def die!
    #@color = Color::RED
    #@image = Image["hit.png"]
    @hit_sound.play
  end
  
  def reset!
    #@image = Image["player.png"]
    @x = ($window.width - (@player_image_width / 2)) / 2
    @y = ($window.height - @player_image_height)
  end
  
end