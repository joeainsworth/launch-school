# You are given the following code:

class Oracle
  def predict_the_future
    'You will ' + choices.sample
  end

  def choices
    ['eat a nice lunch', 'take a nap soon', 'stay at work late']
  end
end

# What is the result of calling

oracle = Oracle.new
oracle.predict_the_future

# A new object of the Oracle class is created
# Instance method is called on the oracle object which returns a random selection from the choices array
