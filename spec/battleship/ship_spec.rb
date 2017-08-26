RSpec.describe Battleship::Ship do
  let(:size)   { 5 }
  let(:ship) { described_class.new(size) }

  describe '#size' do
    subject { ship.size }
    it { is_expected.to eq(size) }
  end

  describe '#hit' do
    it 'removes 1 HP' do
      previous = ship.hit_points
      ship.hit
      expect(ship.hit_points).to eq(previous - 1)
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
      before { size.times { ship.hit } }
      it { is_expected.to eq(true) }
    end
  end
end
