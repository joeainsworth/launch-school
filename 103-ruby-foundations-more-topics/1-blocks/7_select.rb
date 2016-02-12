array = [1, 2, 3, 4, 5]

def select(array)
  counter = 0
  result = []

  while counter < array.size
    current_element = array[counter]
    result << current_element if yield(current_element)
    counter += 1
  end

  result
end

select(array) { |num| num.odd? }
