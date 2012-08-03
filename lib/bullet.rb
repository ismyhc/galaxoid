class Bullet < Chingu::GameObject
  
  trait :bounding_box, :debug => false, :scale => 3.0
  traits :collision_detection, :timer
  attr_accessor :bullet_angle

  def initialize(options)
    super(options.merge(:image => Image["bullet_3x3.png"]))
    
    @sound = Sound["laser.ogg"]
    @sound.play(0.4, 1.0, false)
    
    self.factor = 3
    
    @color = Color::YELLOW

    @bullet_speed = 15
  end

  # Move the bullet forward
  def update
    if bullet_angle == "left"
      @y -= @bullet_speed
      @x -= @bullet_speed - 10
    elsif bullet_angle == "right"
      @y -= @bullet_speed
      @x += @bullet_speed - 10
    else
      @y -= @bullet_speed
    end
  end
  
  def die!
    self.destroy!
  end
  
end