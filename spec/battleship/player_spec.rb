# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Battleship::Player do
  let(:name)   { 'John Doe' }
  let(:player) { described_class.new(name) }

  describe '#ships' do
    subject(:ships) { player.ships }

    it 'has 5 ships to start with' do
      expect(ships.size).to eq(5)
    end

    specify 'no ships are destroyed initially' do
      expect(ships.any?(&:destroyed?)).to eq(false)
    end
  end

  describe '#won?' do
    let(:opponent) { instance_double(Battleship::Player) }
    before         { player.opponent = opponent }
    subject(:won?) { player.won? }

    it 'checks if the opponent lost' do
      expect(opponent).to receive(:lost?)
      won?
    end
  end

  describe '#lost?' do
    subject { player.lost? }

    context 'no ship destroyed' do
      it { is_expected.to eq(false) }
    end

    context 'one ship destroyed' do
      before { player.ships.first.destroy }
      it { is_expected.to eq(false) }
    end

    context 'all ship destroyed' do
      before { player.ships.each(&:destroy) }
      it { is_expected.to eq(true) }
    end
  end

  describe '#setup' do
    let(:screen)       { instance_double(Battleship::Screen) }
    let(:grid)         { instance_double(Battleship::Grid) }
    let(:position)     { anything }
    let(:alignment)    { Battleship::Ship::Alignment::HORIZONTAL }
    let(:player_input) { [position, alignment] }

    before do
      expect(Battleship::Screen).to receive(:new).and_return(screen)
      expect(Battleship::Grid).to   receive(:new).and_return(grid)
    end

    subject(:setup) { player.setup }

    context 'each ship placed vertically' do
      let(:alignment) { Battleship::Ship::Alignment::VERTICAL }

      it 'prompts for coordinate and place it on the grid' do
        expect(screen).
          to receive(:ship_prompt).
          and_return(player_input).
          exactly(player.ships.size).
          times

        expect(grid).
          to receive(:place_vertically).
          exactly(player.ships.size).
          times

        expect(screen).to receive(:switch_setup_next_player_prompt)
        setup
      end
    end

    context 'each ship placed horizontally' do
      it 'prompts for coordinate and place it on the grid' do
        expect(screen).
          to receive(:ship_prompt).
          and_return(player_input).
          exactly(player.ships.size).
          times

        expect(grid).
          to receive(:place_horizontally).
          exactly(player.ships.size).
          times

        expect(screen).to receive(:switch_setup_next_player_prompt)
        setup
      end
    end

    context 'player input error' do
      before do
        will_raise = true
        allow(screen).to receive(:ship_prompt) do
          if will_raise
            will_raise = false
            raise Battleship::Screen::Error
          end
          player_input
        end

        allow(grid).to receive(:place_horizontally)
        allow(screen).to receive(:switch_setup_next_player_prompt)
      end

      it 'rescues and displays the error then retry' do
        expect(Battleship::Screen).to receive(:ship_off_the_grid).once
        expect { setup }.not_to raise_error
      end
    end
  end

  describe '#turn' do
    let(:screen)        { instance_double(Battleship::Screen) }
    let(:opponent_grid) { instance_double(Battleship::Grid) }
    let(:opponent)      { instance_double(Battleship::Player) }
    let(:shot)          { anything }
    let(:position)      { [anything, anything] }

    before do
      allow(Battleship::Screen).to receive(:new).and_return(screen)
      player.opponent = opponent
      allow(screen).to receive(:strike_prompt).and_return(position)
      allow(opponent).to receive(:grid).and_return(opponent_grid)
      allow(opponent_grid).to receive(:strike).and_return(shot)
      allow(screen).to receive(:strike_result)
    end

    subject(:turn) { player.turn }

    it 'prompts for a strike' do
      expect(screen).to receive(:strike_prompt).and_return(position)
      turn
    end

    it 'strikes opponent grid' do
      expect(opponent).to receive(:grid).and_return(opponent_grid)
      turn
    end

    it 'displays the shot result on the screen' do
      expect(screen).to receive(:strike_result).with(shot)
      turn
    end

    it { is_expected.to eq(shot) }

    context 'user input error' do
      before do
        will_raise = true
        allow(screen).to receive(:strike_prompt) do
          if will_raise
            will_raise = false
            raise Battleship::Screen::Error
          end
          position
        end
      end

      it 'displays an error message and retry' do
        expect(Battleship::Screen).to receive(:coordinates_error_prompt)
        expect { turn }.not_to raise_error
      end
    end
  end
end
