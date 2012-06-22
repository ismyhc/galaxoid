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
    ensure
      #not sure why, but @the_score not set unless i wait?
      after(1000) { create_text }
    end
  end
  
  #Score keeper class
  class << self
    attr_accessor :score, :the_score
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
    ensure
      create_text
      @disable_enter_name = "true"
    end
    
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

    @high_score_list.each_with_index do |high_score, index|
      y = index * 25 + 151
      Text.create(high_score[:name], :font => "fonts/phaserbank.ttf", :x => 236, :y => y, :size => 20, :rotation_center => :top_left)
      Text.create(high_score[:score], :font => "fonts/phaserbank.ttf", :x => 566, :y => y, :size => 20, :rotation_center => :top_right)
    end

  end

  def draw
    @game_over_x = ($window.width / 2) + 5
    @game_over_y = 40
    @game_over = "GAME OVER"
    @game_title = Text.create(@game_over, :font => "fonts/phaserbank.ttf", :size => 70,
                              :color => Color::GREEN,
                              :x => @game_over_x, :y => @game_over_y, :rotation_center => :center)
                              
    @player_score_x = ($window.width / 2) + 5
    @player_score_y = 90
    @player_score_text = " Your score: <c=ffff00>#{HighScore.the_score.to_s}</c> "
    @player_score = Text.create(@player_score_text, :font => "fonts/phaserbank.ttf", :size => 40,
                              :x => @player_score_x, :y => @player_score_y, :rotation_center => :center)
                              
    @high_score_title_text = "-- High Scores --"
    @high_score_title_x = 315
    @high_score_title_y = 123
    @high_score_title = Text.create(@high_score_title_text, :font => "fonts/phaserbank.ttf", :size => 20,
                              :color => Color::WHITE,
                              :x => @high_score_title_x, :y => @high_score_title_y, :zorder => 8)

    fill_rect([200,148,400,400], Color::WHITE, 4)
    fill_rect([202,150,396,396], Color::BLACK, 6)
    
    if !defined? @disable_enter_name
      @enter_name_text = " - Press a to enter your name - "
    elsif @disable_enter_name == "true"
      @enter_name_text = " - Press enter to try again! - "
    end

    @enter_name_text_x = 246
    @enter_name_text_y = 565
    @high_score_title = Text.create(@enter_name_text, :font => "fonts/phaserbank.ttf", :size => 20,
                                    :color => Color::YELLOW,
                                    :x => @enter_name_text_x, :y => @enter_name_text_y, :zorder => 8)
    super
  end  
end