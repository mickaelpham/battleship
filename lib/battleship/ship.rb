# frozen_string_literal: true

# A ship has a size and a number of HP (Hit Points) which indicates if the
# ship is destroyed if they are down to 0.
class Battleship::Ship
  attr_reader :size, :hit_points, :origin, :alignment

  module Alignment
    HORIZONTAL = 0
    VERTICAL   = 1
  end

  # A carrier is a 5 cells ship
  class Carrier < Battleship::Ship
    def initialize
      super(5)
    end
  end

  # A warship is a 4 cells ship
  class Warship < Battleship::Ship
    def initialize
      super(4)
    end
  end

  # A cruiser is a 3 cells ship
  class Cruiser < Battleship::Ship
    def initialize
      super(3)
    end
  end

  # A submarine is a 3 cells ship
  class Submarine < Battleship::Ship
    def initialize
      super(3)
    end
  end

  # A destroyer is a 2 cells ship
  class Destroyer < Battleship::Ship
    def initialize
      super(2)
    end
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

  def name
    self.class.name.split('::').last.downcase
  end

  def place_horizontally(at)
    @origin    = at
    @alignment = Alignment::HORIZONTAL
    [at[0], at[1] + @size - 1]
  end

  def place_vertically(at)
    @origin    = at
    @alignment = Alignment::VERTICAL
    [at[0] + @size - 1, at[1]]
  end
end
