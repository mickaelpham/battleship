# frozen_string_literal: true

# A ship has a size and a number of HP (Hit Points) which indicates if the
# ship is destroyed if they are down to 0.
class Battleship::Ship
  attr_reader :size, :hit_points, :origin, :alignment

  module Alignment
    HORIZONTAL = 0
    VERTICAL   = 1
  end

  def initialize(size)
    @size       = size
    @hit_points = size
  end

  def destroyed?
    @hit_points.zero?
  end

  def hit
    @hit_points -= 1
  end

  def place_horizontally(at)
    @origin    = at
    @alignment = Alignment::HORIZONTAL
    [at[0] + @size, at[1]]
  end

  def place_vertically(at)
    @origin    = at
    @alignment = Alignment::VERTICAL
    [at[0], at[1] + @size]
  end
end
