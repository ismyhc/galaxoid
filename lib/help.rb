class Help < Chingu::GameState
  traits :timer
  Chingu::Text.trait :asynchronous
  
  
  def initialize(options = {})
    super
    @white = Gosu::Color.new(255,255,255,255)
    @color = Gosu::Color.new(225,0,0,0)
    #@font = Gosu::Font[35]
    @label = Gosu::Font.new($window, $default_font, 30)
    @text = Gosu::Font.new($window, $menu_font, 12)
    @label_1 = "Controls"
    @text_1 = "- Move player with a,s,d,f or arrow keys"
    @text_2 = "- Fire with enter or space"
    @label_2 = "System Messages"
    @text_3 = "- #{Help.the_gmessage}"
    @testy = ""
    @testt = "You are going to be cool".scan(/./)
    self.input = { :d => :download_page }

  #  @testt.each do |i|
   #   @testy += i
  #  end
  end
  
  #Score keeper class
  class << self
    attr_accessor :gmessage, :the_gmessage
    def gmessage(gmessage)
      @the_gmessage = gmessage
    end
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
    @label.draw(@label_1, 10, 10, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::YELLOW)
    @text.draw(@text_1, 10, 40, Chingu::DEBUG_ZORDER + 1)
    @text.draw(@text_2, 10, 60, Chingu::DEBUG_ZORDER + 1)
    @label.draw(@label_2, 10, 100, Chingu::DEBUG_ZORDER + 1, 1, 1, Gosu::Color::YELLOW)
    @text.draw(@text_3, 10, 130, Chingu::DEBUG_ZORDER + 1)
    
  end
end