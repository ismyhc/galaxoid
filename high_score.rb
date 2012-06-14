class HighScore < Chingu::GameState
  traits :timer
  
  def setup
    super
    @song = Song["end.ogg"]
    after(1500) { @song.play(true) }
    begin
      @high_score_list = OnlineHighScoreList.load(:game_id => "31", :login => "galaxoid", :password => "misterbug", :limit => 16)
    rescue
      @high_score_list = HighScoreList.load(:size => 6)
    end
    create_text
  end
  
  class << self
    attr_accessor :score, :the_score
    @the_score = 0
    def score(score)
      @the_score = score
    end
  end
  
  def enter_name
    push_game_state EnterName.new(:callback => method(:add) )
  end

  def restart_game
    push_game_state(StartMenu)
  end
  
  def finalize
    @song.stop
  end
  
  def disabled_enter_name
  end
  
  def add(name = nil)
    return unless name
    return unless name.size > 0
    data = {:name => name, :score => HighScore.the_score, :text => ""}
    
    begin
      position = @high_score_list.add(data)
    rescue
      puts "Didn't make the online Highscore list."
    end
    #if HighScore.the_score >= @high_score_list[0][:score]
      #Text.create("YOU GOT THE HIGH SCORE", :x => 200, :y => 200, :size => 20)
    #create_text
    #else
    create_text
    #end
    @disable_enter_name = "true"
  end
  
  def update
    
    if !defined? @disable_enter_name
      self.input = {:esc => :exit, :a => :enter_name, :return => :restart_game}
    elsif @disable_enter_name == "true"
      self.input = {:esc => :exit, :a => :disabled_enter_name, :return => :restart_game}
    end

  end

  def create_text
    
    Text.destroy_all
    
    @game_over_x = ($window.width / 2) + 5
    @game_over_y = 40
    @game_over = "GAME OVER"
    @game_title = Text.create(@game_over, :font => "fonts/phaserbank.ttf", :size => 70,
                              :color => Color::GREEN,
                              :x => @game_over_x, :y => @game_over_y, :rotation_center => :center)

    @high_score_list.each_with_index do |high_score, index|
      y = index * 25 + 101
      Text.create(high_score[:name], :font => "fonts/phaserbank.ttf", :x => 236, :y => y, :size => 20, :rotation_center => :top_left)
      Text.create(high_score[:score], :font => "fonts/phaserbank.ttf", :x => 566, :y => y, :size => 20, :rotation_center => :top_right)
    end

  end

  def draw
    @high_score_title_text = "-- High Scores --"
    @high_score_title_x = 315
    @high_score_title_y = 73
    @high_score_title = Text.create(@high_score_title_text, :font => "fonts/phaserbank.ttf", :size => 20,
                              :color => Color::WHITE,
                              :x => @high_score_title_x, :y => @high_score_title_y, :zorder => 8)

    fill_rect([200,98,400,400], Color::WHITE, 4)
    fill_rect([202,100,396,396], Color::BLACK, 6)
    
    if !defined? @disable_enter_name
      @enter_name_text = " - Press a to enter your name - "
    elsif @disable_enter_name == "true"
      @enter_name_text = " - Press enter to try again! - "
    end

    @enter_name_text_x = 246
    @enter_name_text_y = 520
    @high_score_title = Text.create(@enter_name_text, :font => "fonts/phaserbank.ttf", :size => 20,
                                    :color => Color::YELLOW,
                                    :x => @enter_name_text_x, :y => @enter_name_text_y, :zorder => 8)
    super
  end  
end