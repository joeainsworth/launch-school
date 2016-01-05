# What could we add to the class below to access the instance variable @volume?
# attr_reader :volume must be added to access this instance variable

class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end


big_cube = Cube.new('5000')
p big_cube.volume
