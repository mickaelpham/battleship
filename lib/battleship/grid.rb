# frozen_string_literal: true

# A grid is either a representation of a player's fleet or their hit/miss
# tracking sheet.
class Battleship::Grid
  # Generic grid error
  class Error < StandardError; end

  # Out of position error
  class PositionError < Error; end

  # Trying to position a ship over another
  class CellNotEmptyError < Error; end

  module Cell
    EMPTY = 0
    MISS  = 1
    HIT   = 2
    SHIP  = 3
  end

  attr_reader :rows, :cols, :matrix, :ships

  def initialize(rows, cols)
    @rows   = rows
    @cols   = cols
    @matrix = Array.new(rows) { Array.new(cols, Cell::EMPTY) }
    @ships  = []
  end

  def place_horizontally(ship, at)
    bow   = at
    stern = ship.place_horizontally(at)
    raise PositionError if out?(bow) || out?(stern)
    place(bow, stern, ship)
    @ships << ship
  end

  def place_vertically(ship, at)
    bow   = at
    stern = ship.place_vertically(at)
    raise PositionError if out?(bow) || out?(stern)
    place(bow, stern, ship)
    @ships << ship
  end

  # :reek:TooManyStatements { enabled: false }
  # rubocop:disable Metrics/MethodLength
  def strike(row, col)
    raise PositionError if out?([row, col])

    rows = matrix[row]
    cell = rows[col]

    if cell == Cell::EMPTY
      rows[col] = Cell::MISS
    elsif cell.is_a?(Battleship::Ship)
      cell.hit
      rows[col] = Cell::HIT
    else
      cell
    end
  end
  # rubocop:enable Metrics/MethodLength

  def all_destroyed?
    @ships.all?(&:destroyed?)
  end

  private

  def out?(point)
    row = point[0]
    col = point[1]
    row.negative? || row >= rows || col.negative? || col >= cols
  end

  # :reek:NestedIterators { enabled: false }
  def place(bow, stern, ship)
    raise CellNotEmptyError if occupied?(bow, stern)
    (bow[0]..stern[0]).each do |row|
      (bow[1]..stern[1]).each do |col|
        matrix[row][col] = ship
      end
    end
  end

  # :reek:FeatureEnvy { enabled: false }
  # :reek:NestedIterators { enabled: false }
  def occupied?(bow, stern)
    (bow[0]..stern[0]).each do |row|
      (bow[1]..stern[1]).each do |col|
        return true if matrix[row][col] != Cell::EMPTY
      end
    end
    false
  end
end
