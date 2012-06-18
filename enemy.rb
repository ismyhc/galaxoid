class Enemy < Chingu::GameObject
  traits :collision_detection, :bounding_circle, :timer
  attr_accessor :color
  
  def initialize(options ={})
    super
    @mode = :default
    
    @enemy_speed = rand(5...13)
    @enemy_image_width = 10 * 3
    @enemy_image_height = 10 * 3
    @x = rand($window.width - @enemy_image_width)
    @y = @enemy_image_height / 2
    @color = Color::YELLOW

    # Load the full animation from tile-file media/droid.bmp
    @animation = Chingu::Animation.new(:file => "enemy_10x10.png")
    @animation.frame_names = { :scan => 1...4 }
    
    # Start out by animation frames 0-5 (contained by @animation[:scan])
    @frame_name = :scan
  
    @last_x, @last_y = @x, @y
    update

    cache_bounding_circle # This does a lot for performance

  end
  
  def update
                
    if @y >= $window.height
      @y = 0
      @x = rand($window.width)
    else
      @y = @y + @enemy_speed
    end

    self.factor = 3
    @image = @animation[@frame_name].next

  end
  
  def die!
    @color = Color::RED
    self.reset!
    #@image = Image["hit.png"]
  end
  
  def reset!
    @color = Color::YELLOW
    @x = rand($window.width - @enemy_image_width)
    @y = 0
  end
  
end