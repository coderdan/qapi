require 'spec_helper'

class FooTest < Qapi::Model
  attribute :name
  attribute :email
end

RSpec.describe Qapi::Model do
  let(:connection) { double(:connection) }

  describe '::attrs' do
    specify 'that the class accessor is set' do
      expect(FooTest.attrs).to include('name')
      expect(FooTest.attrs).to include('email')
    end
  end

  describe '#initialize' do
    let(:attrs) { { 'name' => 'Dan', 'email' => 'dan@codehire.com' } }

    subject { FooTest.new(connection, attrs) }
    specify { expect(subject.name).to eq('Dan') }
    specify { expect(subject.email).to eq('dan@codehire.com') }
  end

  describe '#attribute' do
    subject { FooTest.new(connection) }
    before  { subject.name = 'Dan' }
    specify { expect(subject.name).to eq('Dan') }
  end

  describe '#connection' do
    subject { FooTest.new(connection) }
    specify { expect(subject.connection).to eq(connection) }
  end
end
