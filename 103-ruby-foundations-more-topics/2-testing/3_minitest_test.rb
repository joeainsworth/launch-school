require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '3_minitest'

# exeception style syntax
describe 'Car#wheels' do
  it 'has four wheels' do
    car = Car.new
    car.wheels.must_equal 4
  end
end

# assertion style syntax
class CarTest < Minitest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end
end
