module Swim
  def enable_swimming
    @can_swim = true
  end
end

class Animal
  include Swim

  @@total_animals = 0

  def initialize(name)
    @@total_animals += 1
    @name = name
  end
end

class Dog < Animal
  def total_animals
    @@total_animals
  end

  def dog_name
    "bark! bark! #{@name} bark! bark!"
  end

  def swim
    "swimming!" if @can_swim
  end
end

teddy = Dog.new("Teddy")
puts teddy.dog_name # 'bark! bark! Teddy bark! bark!'
teddy.enable_swimming
puts teddy.swim

spike = Dog.new("Spike")
spike.total_animals

class Vehicle
  WHEELS = 4
end

class Car < Vehicle
  def self.wheels
    WHEELS
  end

  def wheels
    WHEELS
  end
end

p Car.wheels # 4
a_car = Car.new
p a_car.wheels # 4

# Constant can not be accessed from within a mixed in module
# Have to use the Car class e.g. Car::WHEELS

