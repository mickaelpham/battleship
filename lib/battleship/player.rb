# frozen_string_literal: true

# Keep track of the player's name, remaining ships, hits and misses on the
# opponent's fleet.
class Battleship::Player
  attr_reader :grid, :name, :ships, :screen

  # :reek:Attribute { enabled: false }
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

  def lost?
    ships.all?(&:destroyed?)
  end

  # :reek:DuplicateMethodCall { enabled: false }
  def setup
    # for each ship, prompt for an origin + orientation and add to the grid
    ships.each do |ship|
      position, alignment = screen.ship_prompt(ship)
      if alignment == Battleship::Ship::Alignment::VERTICAL
        grid.place_vertically(ship, position)
      else
        grid.place_horizontally(ship, position)
      end
    end
  end

  def turn
    position = screen.strike_prompt
    opponent.grid.strike_at(position[0], position[1])
    screen.victory if opponent.lost?
  end
end
