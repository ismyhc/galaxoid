class Enemy < Chingu::GameObject
  traits :collision_detection, :bounding_circle
  attr_accessor :color
  
  def initialize(options)
    super
    @mode = :additive
    
    @image = Image["enemy.png"]
    @enemy_image_width = 50
    @x = rand($window.width - @enemy_image_width)
    @y = 0
    @enemy_speed = rand(5...13)
    cache_bounding_circle # This does a lot for performance

  end
  
  def update
    if @y >= $window.height
      @y = 0
      @x = rand($window.width)
    else
      @y = @y + @enemy_speed
    end
  end
  
  def die!
    @image = Image["hit.png"]
  end
  
  def reset!
    @x = rand($window.width - @enemy_image_width)
    @y = 0
  end
  
end