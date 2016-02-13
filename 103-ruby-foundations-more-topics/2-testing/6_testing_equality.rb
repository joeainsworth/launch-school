require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

class Car
  attr_accessor :wheels, :name

  def initialize
    @wheels = 4
  end

  def ==(other)
    name == other.name
  end
end

class CarTest < MiniTest::Test
  def test_value_equality
    car1 = Car.new
    car2 = Car.new

    car1.name = "Kim"
    car2.name = "Kim"

    assert_equal(car1, car2)
    assert_same(car1, car2)
  end
end
