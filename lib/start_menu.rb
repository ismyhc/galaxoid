class StartMenu < Chingu::GameState
  traits :timer
  
  class << self
    attr_accessor :g_message
    attr_accessor :g_version_message
    attr_accessor :g_update
  end
  
  def initialize(options ={})
    super
    @center_x = $window.width / 2
    @center_y = $window.height / 2

    $window.caption = "GALAXOID alpha-#{$galaxoid_version}"
    self.input = { :f1 => :debug, [:q, :escape] => :exit, :return => :load, :h => :help }
    @song = Song["start.ogg"]
    @background = Image["outerspace_pattern.jpg"]
    @select_sound = Sound["select.ogg"]
    after(500) { @song.play(true) }
    @g_message = "Apparently there is no connection to the Galaxoid System"
    @g_version_message = ""
    @g_update = false
    @help_info = "Press [h] for controls and other info"
    
    Text.create(@help_info, :font => $menu_font, :x => @center_x + 15, :y => 545, :size => 12,
                :rotation_center => :center, :color => Color::CYAN)

    begin
      @high_score_list = OnlineHighScoreList.load(:game_id => "35", :login => "ga03",
                                                  :password => "misterbug3", :limit => 6)
      $hs = @high_score_list[0][:score]
      $hs_name = @high_score_list[0][:name]
    rescue
      @high_score_list = HighScoreList.load(:size => 6)
    end
    
    begin
      @gmessage_resource = RestClient::Resource.new("http://gmessage.herokuapp.com/version/#{$galaxoid_version}",
                                                    :headers => {:user_agent => "Galaxoid - #{$galaxoid_version}"})
      res = @gmessage_resource.get
      data = Crack::XML.parse(res)

      if data["galaxoid"]
        if data["galaxoid"]["g_update"] === "true"
          @g_update = true
          @g_update_color = Color::RED
        elsif data["galaxoid"]["g_update"] === "false"
          @g_update = false
          @g_update_color = Color::GREEN
        end
        @g_version_message = data["galaxoid"]["g_version_message"]
        @g_message = data["galaxoid"]["g_message"]
        Help.g_update(@g_update)
        Help.g_version_message(@g_version_message)
        Help.g_message(@g_message)
        Text.create("#{@g_version_message} ", :font => $menu_font, :x => @center_x + 15, :y => 525, :size => 12,
                    :rotation_center => :center, :color => @g_update_color)
      end

    rescue
      Text.create(@g_message, :font => $menu_font, :x => @center_x + 15, :y => 525, :size => 12,
                  :rotation_center => :center, :color => Color::RED)

      Help.g_version_message("System Version: " + $galaxoid_version)
      Help.g_message(@g_message)
                  
    end
    
    start_menu
    high_score_menu

  end
  
  def help
    push_game_state(Help, :finalize => false)
  end
  
  def start_menu
    title = "GALAXOID"
    title_y = 120
    game_start = "Press Enter to Start!"
    game_start_y = 210
    
    Text.create(title, :font => $default_font, :size => 90,
                :color => Color::GREEN,
                :x => @center_x + 5, :y => title_y, :rotation_center => :center_top)

    Text.create(game_start, :font => $default_font, :size => 28,
                :color => Color::YELLOW,
                :x => @center_x, :y => game_start_y, :rotation_center => :center_top)
  end

  def high_score_menu

    high_score_title = "-- High Scores --"
    high_score_title_x = 315
    high_score_title_y = 275
  
    Text.create(high_score_title, :font => $default_font, :size => 20, :color => Color::GREEN,
                :x => @center_x, :y => high_score_title_y, :rotation_center => :center_top)
                                    
    @high_score_list.each_with_index do |high_score, index|
      y = index * 25 + 310
      Text.create(high_score[:name], :font => $default_font, :x => 226, :y => y, :size => 20,
                  :rotation_center => :top_left)
      Text.create(high_score[:score], :font => $default_font, :x => 576, :y => y, :size => 20,
                  :rotation_center => :top_right)
    end

  end
  
  def debug   
    push_game_state(Chingu::GameStates::Debug.new)
  end
    
  def load
    @select_sound.play(0.4, 3.0, false)
    after(200) { push_game_state(Play) }
  end

  def finalize
    @song.stop
  end

  def draw
    # Start menu boxes
    @start_green_rect = Rect.new(@center_x,@center_y,600,400)
    @start_green_rect.center=([@center_x,@center_y])
    fill_rect(@start_green_rect, Color::GREEN, 1)
    
    @start_blue_rect = Rect.new(@center_x,@center_y,590,390)
    @start_blue_rect.center=([@center_x,@center_y])
    fill_rect(@start_blue_rect, Color::BLUE, 2)
    
    @start_black_rect = Rect.new(@center_x,@center_y,580,380)
    @start_black_rect.center=([@center_x,@center_y])
    fill_rect(@start_black_rect, Color::BLACK, 3)

    # High score boxes
    @score_white_rect = Rect.new(@center_x,260,400,220)
    @score_white_rect.centerx=(@center_x)
    fill_rect(@score_white_rect, Color::WHITE, 4)

    @score_black_rect = Rect.new(@center_x,262,396,216)
    @score_black_rect.centerx=(@center_x)
    fill_rect(@score_black_rect, Color::BLACK, 6)
    
    #$window.caption = "FPS: #{$window.fps} - milliseconds_since_last_tick: #{$window.milliseconds_since_last_tick} - game objects# #{current_game_state.game_objects.size}"
    
    super
  end

end