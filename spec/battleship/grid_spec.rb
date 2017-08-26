# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Battleship::Grid do
  let(:rows) { 10 }
  let(:cols) { 10 }
  let(:grid) { described_class.new(rows, cols) }

  let(:ca) { Battleship::Ship::Carrier.new }
  let(:w)  { Battleship::Ship::Warship.new }
  let(:cr) { Battleship::Ship::Cruiser.new }
  let(:s)  { Battleship::Ship::Submarine.new }
  let(:d)  { Battleship::Ship::Destroyer.new }

  let(:empty_grid) do
    [
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0]
    ]
  end

  let(:grid_with_miss) do
    [
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  1,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0]
    ]
  end

  let(:grid_with_carrier) do
    [
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  ca, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  ca, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  ca, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  ca, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  ca, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0]
    ]
  end

  let(:filled_grid) do
    [
      [0,  ca, 0,  0,  0,  0,  0,  0,  0,  0],
      [0,  ca, 0,  0,  0,  0,  w,  w,  w,  w],
      [0,  ca, 0,  0,  0,  0,  0,  0,  0,  0],
      [0,  ca, 0,  0,  0,  0,  0,  0,  0,  0],
      [0,  ca, 0,  0,  cr, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  cr, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  cr, 0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  d,  d,  0],
      [s,  s,  s,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0]
    ]
  end

  let(:playing_grid) do
    [
      [1,  ca, 0,  0,  0,  0,  0,  1,  0,  0],
      [0,  ca, 0,  0,  0,  0,  w,  2,  2,  w],
      [0,  ca, 0,  0,  0,  0,  0,  0,  0,  0],
      [0,  ca, 0,  0,  0,  0,  0,  0,  0,  0],
      [0,  ca, 0,  0,  2,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  2,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  2,  1,  0,  0,  1,  0],
      [0,  0,  0,  0,  0,  0,  0,  d,  d,  0],
      [s,  s,  s,  0,  0,  0,  0,  0,  0,  0],
      [0,  0,  0,  0,  0,  0,  0,  0,  0,  0]
    ]
  end

  describe '#matrix' do
    subject { grid.matrix }

    context 'empty' do
      it { is_expected.to eq(empty_grid) }
    end

    context 'with one carrier' do
      before { grid.place_vertically(ca, [2, 4]) }
      it { is_expected.to eq(grid_with_carrier) }
    end

    context 'with all ships' do
      before do
        grid.place_vertically(ca,  [0, 1])
        grid.place_horizontally(w, [1, 6])
        grid.place_vertically(cr,  [4, 4])
        grid.place_horizontally(s, [8, 0])
        grid.place_horizontally(d, [7, 7])
      end

      it { is_expected.to eq(filled_grid) }
    end

    context 'after a few rounds' do
      before do
        grid.place_vertically(ca,  [0, 1])
        grid.place_horizontally(w, [1, 6])
        grid.place_vertically(cr,  [4, 4])
        grid.place_horizontally(s, [8, 0])
        grid.place_horizontally(d, [7, 7])

        grid.strike(0, 0)
        grid.strike(1, 7)
        grid.strike(0, 7)
        grid.strike(1, 8)
        grid.strike(6, 8)
        grid.strike(6, 4)
        grid.strike(6, 5)
        grid.strike(5, 4)
        grid.strike(4, 4)
      end

      it { is_expected.to eq(playing_grid) }
    end
  end

  describe '#all_destroyed?' do
    subject { grid.all_destroyed? }

    context 'without any ships' do
      it { is_expected.to eq(true) }
    end

    context 'with one ship' do
      before { grid.ships << ca }
      it { is_expected.to eq(false) }

      context 'destroyed' do
        before { ca.size.times { ca.hit } }
        it { is_expected.to eq(true) }
      end
    end

    context 'with two ships' do
      before do
        grid.ships << ca
        grid.ships << d
      end

      it { is_expected.to eq(false) }

      context 'one destroyed' do
        before { ca.size.times { ca.hit } }
        it { is_expected.to eq(false) }
      end

      context 'both destroyed' do
        before do
          ca.size.times { ca.hit }
          d.size.times { d.hit }
        end

        it { is_expected.to eq(true) }
      end
    end
  end

  describe '#place_vertically' do
    let(:ship) { ca }

    subject { grid.place_vertically(ship, [row, col]) }

    context 'out of bound ship' do
      let(:row) { 6 }
      let(:col) { 9 }

      specify do
        expect { subject }.to raise_error(Battleship::Grid::PositionError)
      end
    end

    context 'another ship present at position' do
      before { grid.place_horizontally(w, [1, 1]) }

      let(:row) { 0 }
      let(:col) { 2 }

      specify do
        expect { subject }.to raise_error(Battleship::Grid::CellNotEmptyError)
      end
    end
  end

  describe '#place_horizontally' do
    let(:ship) { ca }

    subject { grid.place_horizontally(ship, [row, col]) }

    context 'out of bound ship' do
      let(:row) { 0 }
      let(:col) { 6 }

      specify do
        expect { subject }.to raise_error(Battleship::Grid::PositionError)
      end
    end

    context 'another ship present at position' do
      before { grid.place_vertically(w, [1, 1]) }

      let(:row) { 2 }
      let(:col) { 0 }

      specify do
        expect { subject }.to raise_error(Battleship::Grid::CellNotEmptyError)
      end
    end
  end

  describe '#strike' do
    subject(:strike) { grid.strike(row, col) }

    context 'hit an empty cell' do
      let(:row) { 4 }
      let(:col) { 4 }

      it { is_expected.to eq(Battleship::Grid::Cell::MISS) }
    end

    context 'hit the same empty cell twice' do
      let(:row) { 4 }
      let(:col) { 4 }

      before { grid.strike(row, col) }

      it { is_expected.to eq(Battleship::Grid::Cell::MISS) }
    end

    context 'hit a ship' do
      let(:row) { 4 }
      let(:col) { 0 }

      before { grid.place_vertically(ca, [0, 0]) }

      it { is_expected.to eq(Battleship::Grid::Cell::HIT) }
    end

    context 'hit the ship twice at the same position' do
      let(:row) { 4 }
      let(:col) { 0 }

      before do
        grid.place_vertically(ca, [0, 0])
        grid.strike(row, col)
      end

      it { is_expected.to eq(Battleship::Grid::Cell::HIT) }
    end

    context 'hit the ship X+1 times at the same position (X = ship size)' do
      let(:row) { 4 }
      let(:col) { 0 }

      before do
        grid.place_vertically(ca, [0, 0])
        ca.size.times { grid.strike(row, col) }
      end

      it { is_expected.to eq(Battleship::Grid::Cell::HIT) }

      it 'does not destroy the ship' do
        strike
        expect(ca.destroyed?).to eq(false)
      end
    end

    context 'hit and destroy a ship (final blow)' do
      let(:row) { 4 }
      let(:col) { 0 }

      before do
        grid.place_vertically(ca, [0, 0])
        (0..3).each { |r| grid.strike(r, col) }
      end

      it { is_expected.to eq(Battleship::Grid::Cell::HIT) }

      it 'sink the ship' do
        strike
        expect(ca.destroyed?).to eq(true)
      end
    end
  end
end
