# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Battleship do
  it 'has a version number' do
    expect(Battleship::VERSION).not_to be nil
  end
end
