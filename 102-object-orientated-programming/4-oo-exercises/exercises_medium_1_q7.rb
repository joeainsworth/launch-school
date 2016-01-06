# How could you change the method name below so that the method name is more clear and less repetitive?

class Light
  attr_accesor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    "I want to turn on the light with a brightness level of super high and a color of green"
  end

# remove light_information and use information. Because the method is a class method you have to call it with Light.light_information anyway so it now becomes Light.information
