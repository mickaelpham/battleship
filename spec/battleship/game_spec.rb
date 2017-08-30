# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Battleship::Game do
  let(:new_game)   { described_class.new }
  let(:player_one) { instance_double(Battleship::Player, 'player one') }
  let(:player_two) { instance_double(Battleship::Player, 'player two') }
  let(:names)      { %w[Jane John] }

  before do
    allow(Battleship::Screen).to receive(:start)
    allow(Battleship::Screen).to receive(:players_prompt).and_return(names)

    allow(Battleship::Player).
      to receive(:new).
      with('Jane').
      and_return(player_one)

    allow(Battleship::Player).
      to receive(:new).
      with('John').
      and_return(player_two)

    allow(player_one).to receive(:opponent=).with(player_two)
    allow(player_two).to receive(:opponent=).with(player_one)

    allow(player_one).to receive(:setup)
    allow(player_two).to receive(:setup)
  end

  describe '::new' do
    it 'shows the start screen' do
      expect(Battleship::Screen).to receive(:start)
      new_game
    end

    it 'prompts for the player names' do
      expect(Battleship::Screen).to receive(:players_prompt).and_return(names)
      new_game
    end

    it 'set each player as an opponent to each other' do
      expect(player_one).to receive(:opponent=).with(player_two)
      expect(player_two).to receive(:opponent=).with(player_one)
      new_game
    end

    it 'prompt each player to set up their grid' do
      expect(player_one).to receive(:setup)
      expect(player_two).to receive(:setup)
      new_game
    end

    context 'CTRL-C pressed' do
      before do
        allow(Battleship::Screen).
          to receive(:players_prompt).
          and_raise(Interrupt)
      end

      it 'shows the exit message and raise the Interrupt further' do
        expect(Battleship::Screen).to receive(:bye)
        expect { new_game }.to raise_error(Interrupt)
      end
    end
  end

  describe '#run' do
    let(:miss)      { Battleship::Grid::Cell::MISS }
    let(:hit)       { Battleship::Grid::Cell::HIT }
    let(:screen_p1) { instance_double(Battleship::Screen) }
    let(:screen_p2) { instance_double(Battleship::Screen) }

    subject(:run) { new_game.run }

    before do
      [player_one, player_two].each do |player|
        allow(player).to receive(:won?).and_return(false)
        allow(player).to receive(:turn).and_return(miss)
      end

      allow(player_one).to receive(:screen).and_return(screen_p1)
      allow(player_two).to receive(:screen).and_return(screen_p2)
    end

    context 'player one win' do
      before do
        allow(player_one).to receive(:won?).and_return(false, true, true)
        allow(player_one).to receive(:turn).and_return(hit)
      end

      it 'shows player one victory screen' do
        expect(screen_p1).to receive(:victory)
        run
      end
    end

    context 'player two win' do
      before do
        allow(player_two).to receive(:won?).and_return(false, true, true)
        allow(player_two).to receive(:turn).and_return(hit)
      end

      it 'switches player when they MISS' do
        expect(screen_p2).to receive(:victory)
        run
      end
    end

    context 'CTRL-C command pressed' do
      before do
        allow(player_one).to receive(:turn).and_raise(Interrupt)
      end

      it 'shows the exit message and re raise the Interrupt' do
        expect(Battleship::Screen).to receive(:bye)
        expect { run }.to raise_error(Interrupt)
      end
    end
  end
end
