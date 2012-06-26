class Bullet < Chingu::GameObject
  
  trait :bounding_box, :debug => false, :scale => 1.0
  traits :collision_detection, :timer

  def initialize(options)
    super(options.merge(:image => Image["bullet_3x3.png"]))
    
    @sound = Sound["laser.ogg"]
    @sound.play(2.0, 1.0, false)
    
    self.factor = 3
    
    @color = Color::YELLOW

    @bullet_speed = 15
  end

  # Move the bullet forward
  def update
    @y -= @bullet_speed
  end
  
  def die!
    self.destroy!
  end
  
end