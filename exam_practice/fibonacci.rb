def fibonacci_sequence(max_num)
  sequence = [1, 2]
  loop do
    fibonacci = sequence[-2] + sequence[-1]
    break if fibonacci >= max_num
    sequence << fibonacci
  end
  sequence
end

# array size
max_num = 100
numbers = []
1.upto(max_num) { |num| numbers << num }

# select fibonacci numbers and assign array to variable
fibonacci_numbers = numbers.select { |num| fibonacci.include?(num) }
