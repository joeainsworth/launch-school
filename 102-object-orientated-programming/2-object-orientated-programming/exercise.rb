class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  private

    def parse_full_name(full_name)
      parts = full_name.split
      self.first_name = parts.first
      self.last_name = parts.size > 1 ? parts.last : ' '
    end
end

p bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
p bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

p bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'
