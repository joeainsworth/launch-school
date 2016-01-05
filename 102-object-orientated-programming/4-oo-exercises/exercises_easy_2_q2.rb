# We have an Oracle class and a RoadTrip class that inherits from the Oracle class

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:

trip = RoadTrip.new
trip.predict_the_future

# A new object called trip is created using the RoadTrip class which inherits from the Oracle class
# predict_the_future uses the instance method in the roadtrip class
