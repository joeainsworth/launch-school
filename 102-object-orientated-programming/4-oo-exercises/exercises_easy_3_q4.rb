# When objects are created they are a seperate realization of a particular class.
# Given the class below, how do we create two different instances of this class, both with separate names and ages?

class AngryCat
  def initialize(age, name)
    @age = age
    @name = name
  end

  def to_s
    puts "#{name} is a tabby cat"
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hissss!!!"
  end
end

tigger = AngryCat.new(5, 'Tigger')
loopy = AngryCat.new(9, 'Loopy')

puts tigger
puts loopy
