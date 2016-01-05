# When we called the go_fast method from an instance of the Car class (as shown below) you might have noticed that the string printed when we go fast includes the name of the type of vehicle we are using. How is this done?

# self refers to the object
# self tells us its class using .class to tell us
# the go_fast method then prints the class using .to_s

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

ferrari = Car.new
ferrari.go_fast

lorry = Truck.new
lorry.go_fast
