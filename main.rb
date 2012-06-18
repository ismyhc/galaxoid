#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
require './play.rb'
require './end.rb'
require './player.rb'
require './enemy.rb'
require './life_bonus.rb'
require './score_bonus.rb'
require './start_menu.rb'
require './high_score.rb'
require './enter_name.rb'
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