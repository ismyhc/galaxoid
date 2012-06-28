class EnterName < Chingu::GameState

  def initialize(options = {})
    super
    
    @title = options[:title] || "<u>Please enter your name</u>"
    Text.create(@title, :rotation_center => :top_center, :font => $default_font,
                :x => $window.width/2, :y => 30, :size => 30)

    on_input([:holding_up, :holding_w, :holding_gamepad_up], :up)
    on_input([:holding_down, :holding_s, :holding_gamepad_down], :down)
    on_input([:holding_left, :holding_a, :holding_gamepad_left], :left)
    on_input([:holding_right, :holding_d, :holding_gamepad_right], :right)
    on_input([:space, :x, :enter, :gamepad_button_1, :return], :action)
    on_input(:esc, :pop_game_state)
    
    @callback = options[:callback]
    @columns = options[:columns] || 11
    
    @string = []
    @texts = []
    @index = 0
    @letter_size = 40
    @letters = %w[ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z SPACE DEL ENTER ]

    @y = 180
    @x = ($window.width - 600)/2
    
    @letters.each_with_index do |letter, index|
      @texts << Text.create(letter, :font => $default_font, :x => @x, :y => @y, :size => @letter_size)
      @x += @texts.last.width + 20
      
      if (index+1) % @columns == 0
        @y += @letter_size
        @x = @texts.first.x
      end
    end
  
    @texts[@index].color = ::Gosu::Color::GREEN
    @name = Text.create("", :font => $default_font, :rotaion_center => :top_center, :x => $window.width/2, :y => 60, :size => 80)
  end

  # Move cursor 1 step to the left
  def left; move_cursor(-1); end
  
  # Move cursor 1 step to the right
  def right; move_cursor(1); end

  # Move cursor 1 step to the left
  def up; move_cursor(-@columns); end
  
  # Move cursor 1 step to the right
  def down; move_cursor(@columns); end

  # Move cursor any given value (positive or negative). Used by left() and right()
  def move_cursor(amount = 1)
    #
    # Curser will wrap
    #
    #@index += amount
    #@index = 0                if @index >= @letters.size
    #@index = @letters.size-1  if @index < 0
    
    #
    # Cursor won't wrap
    #
    new_value = @index + amount
    @index = new_value  if new_value < @letters.size && new_value >= 0
    
    @texts.each { |text| text.color = ::Gosu::Color::WHITE }
    @texts[@index].color = ::Gosu::Color::GREEN
    
    sleep(0.15)
  end

  def action
    case @letters[@index]
      when "DEL"      then  @string.pop
      when "SPACE"    then  @string << " "
      when "ENTER"    then  go
      else            @string << @letters[@index]
    end
    
    @name.text = @string.join
    @name.x = $window.width/2 - @name.width/2
  end
  
  def go
    @callback.call(@name.text)
    pop_game_state(:setup => true)
  end
  
end