class ScoreBonus < Chingu::GameObject
  traits :collision_detection, :bounding_circle, :timer
  attr_accessor :color
  
  def initialize(options ={})
    super
    @mode = :default
    
    @score_bonus_sound = Sound["score_bonus.ogg"]
    
    @score_bonus_speed = rand(5...13)
    @score_bonus_image_width = 10 * 3
    @score_bonus_image_height = 10 * 3
    @x = rand($window.width - @score_bonus_image_width)
    @y = @score_bonus_image_height / 2
    @color = Color::RED

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
      self.destroy!
      @x = rand($window.width)
    else
      @y = @y + @score_bonus_speed
    end

    self.factor = 3
    @image = @animation[@frame_name].next

  end
  
  def die!
    @score_bonus_sound.play
    @color = Color::RED
    self.reset!
  end
  
  def reset!
    @y = 0
    self.destroy!
  end
  
end