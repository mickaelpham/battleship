# frozen_string_literal: true

# Handle the game initialization and turns between players.
class Battleship::Game
  ROWS    = 10
  COLS    = 10
  PLAYERS = 2

  attr_reader :players

  def initialize
    Battleship::Screen.start

    names = Battleship::Screen.players_prompt

    @players = names.each.with_object([]) do |name, players|
      players << Battleship::Player.new(name)
    end

    # TODO: find a cleaner way to set the opponents
    players[0].opponent = players[1]
    players[1].opponent = players[0]

    @players.each(&:setup)

    run
  rescue Interrupt
    puts "\n\nQuitting Battleship #{Battleship::VERSION} by Mickael Pham"
  end

  private

  def run
    current_player = players.first
    turn = 0
    until current_player.won?
      if current_player.turn == Battleship::Grid::Cell::MISS
        turn += 1
        current_player = players[turn % players.length]
      end

      current_player.screen.victory if current_player.won?
    end
  end
end
