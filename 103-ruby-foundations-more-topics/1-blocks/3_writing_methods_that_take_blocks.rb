def hello
  "Hello!"
end

def echo_with_yield(str)
  yield if block_given?
  str
end

# echo_with_yield { puts "Hello" }
puts echo_with_yield("Hello") { puts "world" }
puts echo_with_yield("Joe!")

def say(words)
  yield if block_given?
  puts "> " + words
end

say("hi there") do
  # system 'clear'
end


def increment(number)
  if block_given?
    yield(number + 1)
  else
    number + 1
  end
end

increment(5) do |num|
  puts num
end

def test
  yield(1)
end

test do |num1, num2|
  puts "#{num1} #{num2}"
end

def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

# method invocation
compare('hello') { |word| puts 'hi' }
