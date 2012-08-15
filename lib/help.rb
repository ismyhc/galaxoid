class Help < Chingu::GameState
  traits :timer
  
  def initialize(options ={})
    super
 
    @white = Gosu::Color.new(255,255,255,255)
    @color = Gosu::Color.new(225,0,0,0)
    #@font = Gosu::Font[35]
    @label = Gosu::Font.new($window, $default_font, 30)
    @text = Gosu::Font.new($window, $menu_font, 12)
    @label_controls = "Controls"
    @text_controls_1= "- Move ship with a,w,s,d or arrow keys"
    @text_controls_2 = "- Fire with enter or space"
    
    @label_how_to_play = "How to play"
    @text_how_to_play_1= "-> Dodge the enemies. Look out for life, weapon and score bonuses!"
    @text_how_to_play_2 = "-> Stacked enemies can take more life than you think!"

    @label_system = "System Messages"
    @text_system_1 = "-> #{Help.the_g_version_message}"
    @text_system_2 = "-> #{Help.the_g_message}"

    @label_start_y = 10

    self.input = { :d => :download_page }
    
    @update = Sound["update.ogg"]
        
    if Help.the_g_update
      play_update
      @update_color = Gosu::Color::RED
      @downloads_page = "Press [d] to go to the galaxoid downloads page!"
    else
      @update_color = Gosu::Color::GREEN
      @downloads_page = ""
    end
    
    if Help.the_g_message.nil?
      @text_system_2 = "-> Galaxoid systems have nothing to say..."
    end

  end
  
  #class to pass gmessage and gupdate
  class << self
    attr_accessor :g_message, :the_g_message
    attr_accessor :g_version_message, :the_g_version_message
    attr_accessor :g_update, :the_g_update
    def g_message(g_message)
      @the_g_message = g_message
    end

    def g_version_message(g_version_message)
      @the_g_version_message = g_version_message
    end
    
    def g_update(g_update)
      @the_g_update = g_update
    end
  end
  
  def play_update
    @update.play(1.0, 1.0, false)
  end
  
  def download_page
    Launchy.open("http://ismyhc.github.com/galaxoid/")
  end

  def button_up(id)
    pop_game_state(:setup => false) if id == Gosu::KbEscape   # Return the previous game state, dont call setup()
  end  
  
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    $window.draw_quad(  0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, Chingu::DEBUG_ZORDER)
                        
    #@font.draw(@text, ($window.width/2 - @font.text_width(@text)/2), $window.height/2 - @font.height, Chingu::DEBUG_ZORDER + 1)
    @label.draw(@label_controls, 10, 10, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::YELLOW)
    @text.draw(@text_controls_1, 10, 40, Chingu::DEBUG_ZORDER + 1)
    @text.draw(@text_controls_2, 10, 60, Chingu::DEBUG_ZORDER + 1)
    @label.draw(@label_how_to_play, 10, 100, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::YELLOW)
    @text.draw(@text_how_to_play_1, 10, 130, Chingu::DEBUG_ZORDER + 1)
    @text.draw(@text_how_to_play_2, 10, 150, Chingu::DEBUG_ZORDER + 1)
    @label.draw(@label_system, 10, 190, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::YELLOW)
    @text.draw(@text_system_1, 10, 220, Chingu::DEBUG_ZORDER + 1, 1, 1, @update_color)
    @text.draw(@text_system_2, 10, 240, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::GREEN)
    @text.draw(@downloads_page, ($window.width/2 - @text.text_width(@downloads_page)/2), $window.height - 40, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::CYAN)
    
  end
end