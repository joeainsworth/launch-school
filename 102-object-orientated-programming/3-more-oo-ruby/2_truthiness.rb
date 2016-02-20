puts 'TRUE'
p true.class
p true.nil?
p true.to_s
p true.methods

puts 'FALSE'
p false.class
p false.nil?
p false.to_s
p false.methods

if true
  puts 'hi'
else
  puts 'goodbye'
end

if false
  puts 'hi'
else
  puts 'goodbye'
end

num = 5
if num > 10
  puts 'small number'
else
  puts 'large number'
end

def some_method_call
  'cool method'
end

puts "It's true" if some_method_call

p true && true # true

p true && false # false

p num = 5 # 5

num < 10 && num.odd? # true

num > 10 && num.odd? # false

num < 10 && num.odd? && num > 0 # true

num < 10 && num.odd? && num > 0 && false # fasle

true || true # true

false || false # false

true || false # true

false || true # true

# short circuiting - as soon is one result is met the truthiness is returned

false && 3/0 # false

true || 3/0 # true

if num
  puts 'valid number'
else
  puts 'invalid number'
end

# does not mean contents of num variable = true
num == true # false

def find_name
  'Joe'
end

if name = find_name
  puts 'Found you!'
else
  puts 'No name here!'
end


