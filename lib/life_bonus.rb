class LifeBonus < Chingu::GameObject
  trait :bounding_box, :debug => false, :scale => 0.8
  traits :collision_detection, :timer
  attr_accessor :color
  
  def initialize(options ={})
    super
    @mode = :default
    
    @life_bonus_sound = Sound["life_bonus.ogg"]
    
    @life_bonus_speed = rand(5...8)
    @life_bonus_image_width = 10 * 3
    @life_bonus_image_height = 10 * 3
    @x = rand($window.width - @life_bonus_image_width)
    @y = @life_bonus_image_height / 2

    # Load the full animation from vertical sprite strip
    @animation = Chingu::Animation.new(:file => "life_bonus_10x10.png", :delay => 700)
    @animation.frame_names = { :main => 0...3 }
    
    # Start out by animation frames 0-3
    @frame_name = :main
  
    @last_x, @last_y = @x, @y
    update

    cache_bounding_box # This does a lot for performance

  end
  
  def update
                
    if @y >= $window.height
      self.destroy!
      @x = rand($window.width)
    else
      @y = @y + @life_bonus_speed
    end

    self.factor = 3
    @image = @animation[@frame_name].next

  end
  
  def die!
    @life_bonus_sound.play(0.4, 1.0)
    self.reset!
  end
  
  def reset!
    @y = 0
    self.destroy!
  end
  
end