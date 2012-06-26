class ScoreBonus < Chingu::GameObject
  trait :bounding_box, :debug => false, :scale => 0.6
  traits :collision_detection, :timer
  attr_accessor :color
  
  def initialize(options ={})
    super
    @mode = :default
    
    @score_bonus_sound = Sound["score_bonus.ogg"]
    @score_bonus_speed = rand(5...6)
    @score_bonus_image_width = 24
    @score_bonus_image_height = 24
    
    @x = rand($window.width - @score_bonus_image_width)
    @y = @score_bonus_image_height / 2

    # Load the full animation from vertical sprite strip
    @animation = Chingu::Animation.new(:file => "score_bonus.png", :delay => 400, :bounce => false)
    @animation.frame_names = { :main => 0...1 }
    @color = Color::YELLOW
    
    # Start out by animation frames 0-1
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
      @y = @y + @score_bonus_speed
    end

    @image = @animation[@frame_name].next

  end
  
  def die!
    @score_bonus_sound.play(0.8, 1.5)
    self.reset!
  end
  
  def reset!
    @y = 0
    self.destroy!
  end
  
end