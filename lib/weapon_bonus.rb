class WeaponBonus < Chingu::GameObject
  
  trait :bounding_box, :debug => true, :scale => 1.5
  traits :collision_detection, :timer

  def initialize(options)
    super(options.merge(:image => Image["bullet_3x3.png"]))
    
    @sound = Sound["life_bonus.ogg"]
    #@sound.play(2.0, 1.0, false)
    @x = rand($window.width / 2)
    @y = 0
    
    self.factor = 6
    
    @color = Color::RED

    @bullet_speed = rand(10) + 5
  end
  
  def update
                
    if @y >= $window.height
      self.reset!
      @x = rand($window.width)
    else
      @y = @y + @bullet_speed
    end

  end
  
  def die!
    @sound.play(0.8, 1.5)
    self.reset!
  end
  
  def reset!
    self.destroy!
    @y = 0
  end
  
end