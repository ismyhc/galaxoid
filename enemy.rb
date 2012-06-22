class Enemy < Chingu::GameObject
  traits :collision_detection, :bounding_circle, :timer
  attr_accessor :color
  
  def initialize(options ={})
    super
    @mode = :default
    
    @enemy_speed = rand(5...12)
    @enemy_image_width = 10 * 3
    @enemy_image_height = 10 * 3
    @x = rand($window.width - @enemy_image_width)
    @y = @enemy_image_height / 2
    @color_array = [Gosu::Color.argb(0xff2CFF00), Gosu::Color.argb(0xff70ed3b), Gosu::Color.argb(0xff34D2AF)]
    @color = @color_array.sample

    # Load the full animation from vertical sprite strip
    @animation_delay = rand(100...500)
    @animation = Chingu::Animation.new(:file => "enemy_10x10.png", :delay => @animation_delay)
    @animation.frame_names = { :main => 0...3 }
    
    # Start out by animation frames 0-3
    @frame_name = :main
  
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
    self.reset!
    #@image = Image["hit.png"]
  end
  
  def reset!
    @x = rand($window.width - @enemy_image_width)
    @y = 0
  end
  
end