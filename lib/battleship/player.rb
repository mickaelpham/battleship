# frozen_string_literal: true

# Keep track of the player's name, remaining ships, hits and misses on the
# opponent's fleet.
class Battleship::Player
  attr_reader :grid, :name, :ships, :screen

  attr_accessor :opponent

  def initialize(name)
    @name = name
    @grid = Battleship::Grid.new(Battleship::Game::ROWS, Battleship::Game::COLS)

    @ships = [
      Battleship::Ship::Carrier.new,
      Battleship::Ship::Warship.new,
      Battleship::Ship::Submarine.new,
      Battleship::Ship::Cruiser.new,
      Battleship::Ship::Destroyer.new
    ]

    @screen = Battleship::Screen.new(self)
  end

  def won?
    opponent.lost?
  end

  def lost?
    ships.all?(&:destroyed?)
  end

  def setup
    ships.each { |ship| setup_ship(ship) }
    screen.switch_setup_next_player_prompt
  end

  def turn
    position = screen.strike_prompt
    shot     = opponent.grid.strike(position[0], position[1])
    screen.strike_result(shot)
    shot
  rescue Battleship::Grid::Error, Battleship::Screen::Error
    Battleship::Screen.coordinates_error_prompt
    retry
  end

  private

  def setup_ship(ship)
    position, alignment = screen.ship_prompt(ship)
    if alignment == Battleship::Ship::Alignment::VERTICAL
      grid.place_vertically(ship, position)
    else
      grid.place_horizontally(ship, position)
    end
  rescue Battleship::Grid::Error, Battleship::Screen::Error
    Battleship::Screen.ship_off_the_grid
    retry
  end
end
