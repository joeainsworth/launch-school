# Which of these two classes has an instance variable and how do you know?
# The Pizza class has an instance variable it. You know because it is prefixed with an @ symbol.

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

pepporoni = Pizza.new
p pepporoni.instance_variables

apple = Fruit.new
p apple.instance_variables
