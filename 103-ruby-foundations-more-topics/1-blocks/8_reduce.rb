array = [1, 2, 3, 4, 5]

def reduce(array, default = 0)
  counter = 0
  accumulator = default

  while counter < array.size
    accumulator = yield(accumulator, array[counter])
    counter += 1
  end

  accumulator
end

reduce(array) { |acc, num| acc + num }
