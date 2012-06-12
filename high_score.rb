class HighScore < Chingu::GameState
  traits :timer
  
  def setup
    self.input = {:esc => :exit, :a => :enter_name}
    #Text.create("Online Highscores", :x => $window.width/2, :y => 80, :size => 24, :rotation_center => :center)
    begin
      @high_score_list = OnlineHighScoreList.load(:game_id => "31", :login => "galaxiod", :password => "misterbug", :limit => 16)
    rescue
      @high_score_list = [:name => "No Internet", :score => 0]
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
  
  def add(name = nil)
    return unless name
    return unless name.size > 0
    data = {:name => name, :score => HighScore.the_score, :text => ""}
    position = @high_score_list.add(data)
    if HighScore.the_score >= @high_score_list[0][:score]
      #Text.create("YOU GOT THE HIGH SCORE", :x => 200, :y => 200, :size => 20)
    create_text
    else
    create_text
    end
  end

  def create_text
    
    Text.destroy_all #{ |text| text.size == 1 }
    @game_over_x = ($window.width / 2) + 5
    @game_over_y = 40
    @game_over = "GAME OVER"
    @game_title = Text.create(@game_over, :font => "fonts/phaserbank.ttf", :size => 70,
                              :color => Color::GREEN,
                              :x => @game_over_x, :y => @game_over_y, :rotation_center => :center)
    #
    # Iterate through all high scores and create the visual represenation of it
    #
    @high_score_list.each_with_index do |high_score, index|
      y = index * 25 + 100
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
  #fill_rect([205,255,390,190], Color::BLUE, 5)
  fill_rect([202,100,396,396], Color::BLACK, 6)
  #  create_text
    super
  end  
end