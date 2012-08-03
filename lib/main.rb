require 'rubygems' rescue nil
require 'chingu'
require 'launchy'

require_relative "play"
require_relative "player"
require_relative "enemy"
require_relative "bullet"
require_relative "life_bonus"
require_relative "weapon_bonus"
require_relative "score_bonus"
require_relative "start_menu"
require_relative "high_score"
require_relative "enter_name"
require_relative "help"

include Gosu
include Chingu

class Main < Chingu::Window
  def initialize
    super(800, 600, false)
    Gosu::Image.autoload_dirs << File.expand_path("../images", __FILE__)
    Gosu::Sound.autoload_dirs << File.expand_path("../sounds", __FILE__)
    Gosu::Song.autoload_dirs << File.expand_path("../songs", __FILE__)
    Gosu::Font.autoload_dirs << File.expand_path("../fonts", __FILE__)
    $default_font = File.expand_path("../lib/fonts/phaserbank.ttf", File.dirname(__FILE__))
    $menu_font = File.expand_path("../lib/fonts/PetMe128.ttf", File.dirname(__FILE__))
    retrofy
    push_game_state(StartMenu)
  end
end

exit if defined? Ocra
Main.new.show
