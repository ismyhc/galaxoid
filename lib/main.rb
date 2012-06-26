require 'rubygems' rescue nil
require 'chingu'
require File.expand_path "../play.rb", __FILE__
require File.expand_path "../player.rb", __FILE__
require File.expand_path "../enemy.rb", __FILE__
require File.expand_path "../bullet.rb", __FILE__
require File.expand_path "../life_bonus.rb", __FILE__
require File.expand_path "../score_bonus.rb", __FILE__
require File.expand_path "../start_menu.rb", __FILE__
require File.expand_path "../high_score.rb", __FILE__
require File.expand_path "../enter_name.rb", __FILE__
include Gosu
include Chingu

class Main < Chingu::Window
  def initialize
    super(800, 600, false)
    retrofy
    push_game_state(StartMenu)
  end
end

Main.new.show