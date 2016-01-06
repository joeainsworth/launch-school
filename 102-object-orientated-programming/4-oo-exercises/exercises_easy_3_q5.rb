# If I have the following class

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# What would happen if I called the methods like shown below?

tv = Television.new # create a new object and set it to equal tv
tv.manufacturer # method error
tv.model # doesn't return anything - nil

Television.manufacturer # doesn't return anything - nil
Television.model # method error
