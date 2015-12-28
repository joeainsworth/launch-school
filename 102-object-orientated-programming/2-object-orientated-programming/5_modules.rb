module Swim
  def swim
    'swimming!'
  end
end

class Pet
  include Swim
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class Mammals < Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'woof!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    'purrrr!'
  end
end

class Bulldog < Dog
  def swim
    'cannot swim!'
  end
end

class Fish < Pet
  include Swim
end

class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end
