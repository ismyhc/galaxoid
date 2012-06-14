class Enemy < Chingu::GameObject
  traits :collision_detection, :bounding_circle, :timer
  attr_accessor :color
  
  def initialize(optionsi ={})
    super
    @mode = :default
    
    #@image = Image["enemy.png"]
#    @enemy_image_width = 50
#    @x = rand($window.width - @enemy_image_width)
#    @y = 0
#    @enemy_speed = rand(5...13)
#    cache_bounding_circle # This does a lot for performance
    
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
                # save current coordinates for possible use next time
                # Move the animation forward by fetching the next frame and putting it into @image
                # @image is drawn by default by GameObject#draw
#                self.factor = 3
 #               @image = @animation[@frame_name].next

                #
                # If droid stands still, use the scanning animation
                #
                #@frame_name = :scan if @x == @last_x && @y == @last_y
                #@color = Color::BLUE

               # @x, @y = @last_x, @last_y if outside_window?  # return to previous coordinates if outside window
                #@last_x, @last_y = @x, @y
                
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