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

  def self.start
    clear
    puts '+-----------------------------------+'
    puts '|        B A T T L E S H I P        |'
    puts '+-----------------------------------+'
    puts
    puts 'Press "Enter" to start a new game'.yellow
    gets
  end

  def self.players_prompt
    clear
    Battleship::Game::PLAYERS.times.with_object([]) do |player, names|
      puts "Player #{player + 1}’s name:".yellow
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
      printf '%4d  '.light_white, col + 1
    end
    puts
  end

  def self.grid_headers_with_enemy_ships
    print '  '
    Battleship::Game::COLS.times do |col|
      printf '%4d  '.light_white, col + 1
    end
    puts '      Enemy Ships'
  end

  def self.grid_row(row, index)
    print "#{('A'.ord + index).chr} ".light_white
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

  def self.grid_masked_row(row, index)
    print "#{('A'.ord + index).chr} ".light_white
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

  def self.grid_masked_row_with_ship(row, index, ship)
    print "#{('A'.ord + index).chr} ".light_white
    row.each do |cell|
      symbol = if cell.is_a?(Battleship::Ship)
                 SYMBOLS[Battleship::Grid::Cell::EMPTY]
               else
                 SYMBOLS[cell]
               end
      print "|  #{symbol}  "
    end
    print '|'

    if ship.destroyed?
      printf "     %-9s (destroyed)\n".red, ship.name
    elsif ship.hit_points < ship.size
      printf(
        "     %-9s   (HP: %d/%d)\n".yellow,
        ship.name,
        ship.hit_points,
        ship.size
      )
    else
      printf(
        "     %-9s   (HP: %d/%d)\n".green,
        ship.name,
        ship.hit_points,
        ship.size
      )
    end
  end

  def self.row_separator
    print '  +'
    print '-----+' * Battleship::Game::COLS
    print "\n"
  end

  def self.row_separator_header_with_enemy_ships
    print '  +'
    print '-----+' * Battleship::Game::COLS
    print "     =====================\n"
  end

  def self.row_separator_with_enemy_ships
    print '  +'
    print '-----+' * Battleship::Game::COLS
    print "     ---------------------\n"
  end

  def self.coordinates_error_prompt
    puts "Wrong coordinate for the strike.\n\nPress \"Enter\" to retry".yellow
    gets
  end

  def self.ship_off_the_grid
    puts "The ship (or part of it) is off the grid.\n\nPress \"Enter\" " \
      'to retry'.yellow
    gets
  end

  attr_reader :player

  def initialize(player)
    @player = player
  end

  def ship_prompt(ship)
    Battleship::Screen.clear
    display_current_player
    display_player_grid
    puts "\nEnter the starting position of your #{ship.name} with a size of " \
      "#{ship.size} cells (e.g., B3):".yellow
    position = parse_position(gets.chomp)
    puts "\nPlace the ship (V)ertically or (H)orizontally?".yellow
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
    puts "\nPress \"Enter\" to switch to the other player or start the " \
      'game'.yellow
    gets
  end

  def strike_prompt
    Battleship::Screen.clear
    display_current_player
    display_opponent_grid
    puts "\nStrike at (e.g., C4):".yellow
    parse_position(gets.chomp)
  end

  def strike_result(shot)
    Battleship::Screen.clear
    display_current_player
    display_opponent_grid

    if shot == Battleship::Grid::Cell::HIT
      puts "\nHIT YA!!!".green

      if player.won?
        puts "\n\nPress \"Enter\" to continue.".yellow
      else
        puts "\n\nPress \"Enter\" to fire another shot.".yellow
      end
    else
      puts "\nMiss :(\n\nPress \"Enter\" to switch to the other player".yellow
    end

    gets
  end

  def victory
    Battleship::Screen.clear
    puts "\n\n=== WINNER WINNER CHICKEN DINNER! ===".green
    print "\n--> ".green
    print player.name.light_white
    print " won the game!\n".green
    puts "\n\nPress \"Enter\" to quit"
    gets
  end

  private

  def display_current_player
    puts "Player: #{player.name.light_white}\n\n"
  end

  def display_player_grid
    Battleship::Screen.grid_headers
    player.grid.matrix.each_with_index do |row, index|
      Battleship::Screen.row_separator
      Battleship::Screen.grid_row(row, index)
    end
    Battleship::Screen.row_separator
  end

  def display_opponent_grid
    Battleship::Screen.grid_headers_with_enemy_ships
    player.opponent.grid.matrix.each_with_index do |row, index|
      if index.zero?
        Battleship::Screen.row_separator_header_with_enemy_ships
      elsif index < player.opponent.ships.size
        Battleship::Screen.row_separator_with_enemy_ships
      else
        Battleship::Screen.row_separator
      end

      if index < player.opponent.ships.size
        ship = player.opponent.ships[index]
        Battleship::Screen.grid_masked_row_with_ship(row, index, ship)
      else
        Battleship::Screen.grid_masked_row(row, index)
      end
    end
    Battleship::Screen.row_separator
  end

  def parse_position(input)
    raise PositionInputError unless [2, 3].include?(input.length)
    letter = input[0].upcase
    row = letter.ord - 'A'.ord
    col = input[1..-1].to_i
    [row, col - 1]
  end
end
