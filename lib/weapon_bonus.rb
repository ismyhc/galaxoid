class WeaponBonus < Chingu::GameObject
  
  trait :bounding_box, :debug => false, :scale => 1.5
  traits :collision_detection, :timer

  def initialize(options)
    super(options.merge(:image => Image["bullet_3x3.png"]))
    
    @sound = Sound["weapons_upgrade.ogg"]
    #@sound.play(2.0, 1.0, false)
    @x = rand($window.width - 6)
    @y = 0
    
    self.factor = 6
    
    @color = Color::CYAN

    @speed = rand(10) + 3
  end
  
  def update
                
    if @y >= $window.height
      self.reset!
      @x = rand($window.width)
    else
      @y = @y + @speed
    end

  end
  
  def die!
    @sound.play(0.8)
    self.reset!
  end
  
  def reset!
    self.destroy!
    @y = 0
  end
  
end