class StartMenu < Chingu::GameState
  traits :timer
  
  def initialize
    super
    self.input = { :f1 => :debug, [:q, :escape] => :exit, :return => :load }
    @song = Song["start_menu.ogg"]
    @select_sound = Sound["select.ogg"]
    after(1500) { @song.play(true) }
    
    # Get high scores from gamercv.com
    #
    # Check if exception, create dummy
    # text to let user know there was a problem
    begin
      @high_score_list = OnlineHighScoreList.load(:game_id => "31", :login => "galaxiod", :password => "misterbug", :limit => 6)
   rescue
      @high_score_list = HighScoreList.load(:size => 6)
 #     @high_score_list = [:name => "No Internet", :score => 0]
    end
  end
  
  def start_menu
    @title = "GALAXOID"
    @title_x = 205
    @title_y = 130
    @game_start = "Press Enter to Start!"
    @game_start_x = 250
    @game_start_y = 210
    @game_title = Text.create(@title, :font => "fonts/phaserbank.ttf", :size => 70,
                              :color => Color::GREEN,
                              :x => @title_x, :y => @title_y)
    @game_start = Text.create(@game_start, :font => "fonts/phaserbank.ttf", :size => 28,
                              :color => Color::WHITE,
                              :x => @game_start_x, :y => @game_start_y)
    fill_rect([100,100,600,400], Color::GREEN, 1)
    fill_rect([105,105,590,390], Color::BLUE, 2)
    fill_rect([110,110,580,380], Color::BLACK, 3)
  end

  def high_score_menu

    @high_score_list.each_with_index do |high_score, index|
      y = index * 25 + 310
      Text.create(high_score[:name], :font => "fonts/phaserbank.ttf", :x => 236, :y => y, :size => 20, :rotation_center => :top_left)
      Text.create(high_score[:score], :font => "fonts/phaserbank.ttf", :x => 566, :y => y, :size => 20, :rotation_center => :top_right)
    end

    @high_score_title_text = "-- High Scores --"
    @high_score_title_x = 315
    @high_score_title_y = 275
    @high_score_title = Text.create(@high_score_title_text, :font => "fonts/phaserbank.ttf", :size => 20,
                              :color => Color::GREEN,
                              :x => @high_score_title_x, :y => @high_score_title_y)
    fill_rect([200,260,400,220], Color::WHITE, 4)
    fill_rect([202,262,396,216], Color::BLACK, 6)
  end
  
  def debug   
    push_game_state(Chingu::GameStates::Debug.new)
  end
    
  def load
    @select_sound.play(0.4, 3.0, false)
    after(100) { push_game_state(Play) }
  end

  def finalize
    @song.stop
  end

  def draw
    start_menu
    high_score_menu
    $window.caption = "GALAXOID"
    super
  end

  def update
    super
  end  
end