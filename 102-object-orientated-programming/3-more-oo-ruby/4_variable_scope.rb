class Person
  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr']

  @@total_people = 0

  def self.total_people
    @@total_people
  end

  def initialize(n)
    @@total_people += 1
    @name = "#{TITLES.sample} #{n}"
  end

  def get_name
    @name
  end

  def total_people
    @@total_people
  end
end

Person.total_people # 0

bob = Person.new('bob')
joe = Person.new('joe')

Person.total_people # 2

puts bob.inspect
puts joe.inspect

# instance variable scope is at the object level
# thus instance variables can be used in any method of an object even if its not defined in that method

p bob.get_name

p Person.total_people

p Person.titles

# Constants should not be reassigned
