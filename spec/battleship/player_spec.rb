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
end
