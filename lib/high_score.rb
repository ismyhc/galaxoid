class HighScore < Chingu::GameState
  traits :timer
  
  def setup
    super
    
    @center_x = $window.width / 2
    @center_y = $window.height / 2
    
    @song = Song["start.ogg"]
    after(100) { @song.play(true) }
    
    begin
      @high_score_list = OnlineHighScoreList.load(:game_id => "31", :login => "galaxoid",
                                                  :password => "misterbug", :limit => 16)
    rescue
      @high_score_list = HighScoreList.load(:size => 6)
    ensure
      #not sure why, but @the_score not set unless i wait?
      after(100) { create_text }
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
      Text.create(high_score[:name], :font => $default_font, :x => 236, :y => y, :size => 20, :rotation_center => :top_left)
      Text.create(high_score[:score], :font => $default_font, :x => 566, :y => y, :size => 20, :rotation_center => :top_right)
    end
    
    # Game over text
    game_over_y = 18
    game_over = "GAME OVER"
    Text.create(game_over, :font => $default_font, :size => 70,
                :color => Color::GREEN,
                :x => @center_x + 5, :y => game_over_y, :rotation_center => :top_center)
    # Player score text
    player_score_y = 72
    player_score_text = " Your score: <c=ffff00>#{HighScore.the_score.to_s}</c> "
    Text.create(player_score_text, :font => $default_font, :size => 40,
                :x => @center_x, :y => player_score_y, :rotation_center => :top_center)
    
    # High Score text       
    high_score_title_text = "-- High Scores --"
    high_score_title_y = 120
    Text.create(high_score_title_text, :font => $default_font, :size => 20,
                :color => Color::YELLOW,
                :x => @center_x, :y => high_score_title_y, :zorder => 8, :rotation_center => :top_center)

    # Display directions to enter name
    if !defined? @disable_enter_name
      enter_name_text = " - Press a to enter your name - "
    elsif @disable_enter_name == "true"
      enter_name_text = " - Press enter to try again! - "
    end

    # Enter name text
    enter_name_text_y = 560
    Text.create(enter_name_text, :font => $default_font, :size => 20,
                :color => Color::YELLOW,
                :x => @center_x, :y => enter_name_text_y, :zorder => 8, :rotation_center => :top_center)

  end

  def draw
    
    @score_white_rect = Rect.new(@center_x,148,400,400)
    @score_white_rect.centerx=(@center_x)
    fill_rect(@score_white_rect, Color::WHITE, 4)
    
    @score_black_rect = Rect.new(@center_x,150,396,396)
    @score_black_rect.centerx=(@center_x)
    fill_rect(@score_black_rect, Color::BLACK, 6)

    #$window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    $window.caption = "GALAXOID - GAME OVER"

    super
  end  
end