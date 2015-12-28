class Pet
  attr_accessor :name

  def initialize(name)
    @name = name
  end

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

class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

pete = Pet.new('Pete')
kitty = Cat.new('Kitty')
dave = Dog.new('Dave')
bud = Bulldog.new('Bud')

joe = Person.new('Joe')

joe.pets << bud
joe.pets << kitty

joe.pets.each do |pet|
  puts "#{pet.name} is #{pet.jump}"
end
