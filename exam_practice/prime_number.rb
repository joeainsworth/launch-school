def is_prime?(number)
  2.upto(number - 1) do |divisor|
    return false if number % divisor == 0
  end
  true
end

puts is_prime?(13)
