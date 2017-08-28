# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'a ship' do
  let(:ship) { described_class.new }

  describe '#size' do
    subject { ship.size }
    it { is_expected.to eq(expected_size) }
  end

  describe '#hit' do
    it 'removes 1 HP' do
      expect { ship.hit }.to change(ship, :hit_points).by(-1)
    end
  end

  describe '#destroy' do
    subject(:destroy) { ship.destroy }

    specify do
      expect { destroy }.to change(ship, :destroyed?).from(false).to(true)
    end
  end

  describe '#hit_points' do
    subject { ship.hit_points }
    it { is_expected.to eq(ship.size) }

    context 'until destroyed' do
      before { ship.size.times { ship.hit } }
      it { is_expected.to eq(0) }
    end
  end

  describe '#destroyed?' do
    subject { ship.destroyed? }
    it { is_expected.to eq(false) }

    context 'after one hit' do
      before { ship.hit }
      it { is_expected.to eq(false) }
    end

    context 'after enough hits' do
      before { ship.size.times { ship.hit } }
      it { is_expected.to eq(true) }
    end
  end

  describe '#name' do
    subject { ship.name }
    it { is_expected.to eq(expected_name) }
  end
end

RSpec.describe Battleship::Ship::Destroyer do
  let(:expected_size) { 2 }
  let(:expected_name) { 'Destroyer' }
  it_behaves_like 'a ship'
end

RSpec.describe Battleship::Ship::Submarine do
  let(:expected_size) { 3 }
  let(:expected_name) { 'Submarine' }
  it_behaves_like 'a ship'
end

RSpec.describe Battleship::Ship::Cruiser do
  let(:expected_size) { 3 }
  let(:expected_name) { 'Cruiser' }
  it_behaves_like 'a ship'
end

RSpec.describe Battleship::Ship::Warship do
  let(:expected_size) { 4 }
  let(:expected_name) { 'Warship' }
  it_behaves_like 'a ship'
end

RSpec.describe Battleship::Ship::Carrier do
  let(:expected_size) { 5 }
  let(:expected_name) { 'Carrier' }
  it_behaves_like 'a ship'
end
