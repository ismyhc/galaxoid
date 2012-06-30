class Enemy < Chingu::GameObject
  trait :bounding_box, :debug => true, :scale => 0.5
  traits :collision_detection, :timer
  attr_accessor :color
  
  def initialize(options ={})
    super
    @mode = :default
    
    @enemy_speed = rand(7) + 5
    @enemy_image_width = 10 * 3
    @enemy_image_height = 10 * 3
    @x = rand($window.width - @enemy_image_width)
    @y = @enemy_image_height / 2
    @color_array = [Gosu::Color.argb(0xff2CFF00), Gosu::Color.argb(0xff70ed3b), Gosu::Color.argb(0xff34D2AF)]
    @color = @color_array.sample

    # Load the full animation from vertical sprite strip
    @animation_delay = rand(400) + 100
    @animation = Chingu::Animation.new(:file => "enemy_10x10.png", :delay => @animation_delay)
    @animation.frame_names = { :main => 0...3 }
    
    # Start out by animation frames 0-3
    @frame_name = :main
  
    @last_x, @last_y = @x, @y
    update

    cache_bounding_box # This does a lot for performance

  end
  
  def update
           
    self.factor = 3
    if self.outside_window?
      self.reset!
    else
      @y = @y + @enemy_speed
    end
    
 #   if @y >= $window.height
  #    die!
   #   @x = rand($window.width)
  #  else
   #   @y = @y + @enemy_speed
  #  end

    @image = @animation[@frame_name].next

  end
  
  def die!
    self.reset!
  end
  
  def reset!
    @y = @enemy_image_height / 2
    @x = rand($window.width - @enemy_image_width)
  end
  
end