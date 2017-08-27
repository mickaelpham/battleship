# frozen_string_literal: true

# A representation of the player screen, can also handle user prompts and
# various interactions such as game setup, turns and victory display.
class Battleship::Screen
  # Generic screen error
  class Error < StandardError; end

  # Position input error
  class PositionInputError < Error; end

  # Alignment input error
  class AlignmentInputError < Error; end

  SYMBOLS = {
    Battleship::Grid::Cell::EMPTY => ' ',
    Battleship::Grid::Cell::HIT   => 'X'.red,
    Battleship::Grid::Cell::MISS  => '/'.yellow,
    Battleship::Grid::Cell::SHIP  => '#'.green
  }.freeze

  # :reek:TooManyStatements { enabled: false }
  # :reek:DuplicateMethodCall { enabled: false }
  def self.start
    clear
    puts '+-----------------------------------+'
    puts '|        B A T T L E S H I P        |'
    puts '+-----------------------------------+'
    puts
    puts 'Press "Enter" to start a new game'
    gets
  end

  def self.players_prompt
    clear
    Battleship::Game::PLAYERS.times.with_object([]) do |player, names|
      puts "Player #{player + 1}’s name:"
      names << gets.chomp
      puts
    end
  end

  def self.clear
    if RUBY_PLATFORM.match?(/win32|win64|\.NET|windows|cygwing|mingw32/i)
      system 'cls'
    else
      system 'clear'
    end
  end

  def self.grid_headers
    print '  '
    Battleship::Game::COLS.times do |col|
      printf '%4d  ', col + 1
    end
    puts
  end

  # :reek:TooManyStatements { enabled: false }
  def self.grid_row(row, index)
    print "#{('A'.ord + index).chr} "
    row.each do |cell|
      symbol = if cell.is_a?(Battleship::Ship)
                 SYMBOLS[Battleship::Grid::Cell::SHIP]
               else
                 SYMBOLS[cell]
               end
      print "|  #{symbol}  "
    end
    print "|\n"
  end

  # :reek:TooManyStatements { enabled: false }
  def self.grid_masked_row(row, index)
    print "#{('A'.ord + index).chr} "
    row.each do |cell|
      symbol = if cell.is_a?(Battleship::Ship)
                 SYMBOLS[Battleship::Grid::Cell::EMPTY]
               else
                 SYMBOLS[cell]
               end
      print "|  #{symbol}  "
    end
    print "|\n"
  end

  def self.row_separator
    print '  +'
    print '-----+' * Battleship::Game::COLS
    print "\n"
  end

  attr_reader :player

  def initialize(player)
    @player = player
  end

  # :reek:DuplicateMethodCall { enabled: false }
  # :reek:TooManyStatements { enabled: false }
  def ship_prompt(ship)
    Battleship::Screen.clear
    display_current_player
    display_player_grid
    puts "\nEnter the starting position of your #{ship.name} with a size of " \
      "#{ship.size} cells (e.g., B3):"
    position = parse_position(gets.chomp)
    puts "\nPlace the ship (V)ertically or (H)orizontally?"
    input = gets.chomp
    alignment = if input.casecmp('v').zero?
                  Battleship::Ship::Alignment::VERTICAL
                elsif input.casecmp('h').zero?
                  Battleship::Ship::Alignment::HORIZONTAL
                else
                  raise AlignmentInputError
                end
    [position, alignment]
  end

  def switch_setup_next_player_prompt
    Battleship::Screen.clear
    display_current_player
    display_player_grid
    puts "\nPress \"Enter\" to switch to the other player or start the game"
    gets
  end

  def strike_prompt
    Battleship::Screen.clear
    display_current_player
    display_opponent_grid
    puts "\nStrike at (e.g., C4):"
    parse_position(gets.chomp)
  end

  # :reek:ControlParameter { enabled: false }
  # :reek:TooManyStatements { enabled: false }
  def strike_result(shot)
    Battleship::Screen.clear
    display_current_player
    display_opponent_grid

    if shot == Battleship::Grid::Cell::HIT
      puts "\nHIT YA!!\n\nPress \"Enter\" to fire another shot."
    else
      puts "\nMiss :(\n\nPress \"Enter\" to switch to the other player"
    end

    gets
  end

  def victory
    puts "\n\nWINNER WINNER CHICKEN DINNER!"
    puts "\n#{player.name} won the game!\n"
    gets
  end

  private

  def display_current_player
    puts "Player: #{player.name}\n\n"
  end

  # :reek:DuplicateMethodCall { enabled: false }
  def display_player_grid
    Battleship::Screen.grid_headers
    player.grid.matrix.each_with_index do |row, index|
      Battleship::Screen.row_separator
      Battleship::Screen.grid_row(row, index)
    end
    Battleship::Screen.row_separator
  end

  # :reek:DuplicateMethodCall { enabled: false }
  def display_opponent_grid
    Battleship::Screen.grid_headers
    player.opponent.grid.matrix.each_with_index do |row, index|
      Battleship::Screen.row_separator
      Battleship::Screen.grid_masked_row(row, index)
    end
    Battleship::Screen.row_separator
  end

  # :reek:FeatureEnvy { enabled: false }
  def parse_position(input)
    raise PositionInputError unless [2, 3].include?(input.length)
    letter = input[0].upcase
    # TODO: stronger user input validation
    row = letter.ord - 'A'.ord
    col = input[1..-1].to_i
    [row, col - 1]
  end
end