# frozen_string_literal: true

# A grid is either a representation of a player's fleet or their hit/miss
# tracking sheet.
class Battleship::Grid
  module Cell
    EMPTY    = ' '
    MISS     = '/'
    SHIP     = '#'
    SHIP_HIT = 'X'
  end

  attr_reader :rows, :cols, :matrix

  def initialize(rows, cols)
    @rows   = rows
    @cols   = cols
    @matrix = Array.new(rows) { Array.new(cols, Cell::EMPTY) }
  end
end
