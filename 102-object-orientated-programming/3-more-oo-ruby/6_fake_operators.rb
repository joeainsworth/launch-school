class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def >(other)
    age > other.age
  end
end

bob = Person.new('Bob', 49)
kim = Person.new('Kim', 33)

puts 'bob is older than kim' if bob > kim

class Team
  attr_accessor :name, :members

  def initialize(name)
    @name = name
    @members = []
  end

  def <<(person)
    members.push person
  end

  def +(other_team)
    temp_team = Team.new('Temporary Team')
    temp_team.members = members + other_team.members
    temp_team
  end

  def [](idx)
    members[idx]
  end

  def []=(idx, obj)
    members[idx] = obj
  end
end

cowboys = Team.new('Dallas Cowbobys')
emmitt = Person.new('Emmitt Smith', 46)
joe = Person.new('Joe Ainsworth', 27)
cowboys.members << Person.new('Troy Aikmen', 48)
cowboys << emmitt
cowboys << joe

niners = Team.new('San Francisco 49ers')
niners.members << Person.new("Joe Montana", 59)
niners.members << Person.new("Jerry Rice", 52)
niners.members << Person.new("Deion Sanders", 47)

p niners.members
p cowboys.members

dream_team = cowboys + niners

p dream_team.inspect

cowboys.members
cowboys[1]
cowboys[3] = Person.new("JJ", 72)
cowboys[3]
