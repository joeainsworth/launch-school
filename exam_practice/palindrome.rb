# enter word
# strip spaces from word
# put characters into array
# put characters into another array
# reverse characters
# compare both arrays
# return false if chars dont match else return true

def reverse(word_arr)
  reverse = []
  index = word_arr.length
  until index == 0 do
    reverse << word_arr[index - 1]
    index -= 1
  end
  reverse
end

def is_palindrome?(word)
  word_arr = word.downcase.gsub(/ /,'').split('')
  true if word_arr == reverse(word_arr)
end

p is_palindrome?('Anna')
p is_palindrome?('Joe')
p is_palindrome?('Go dog')
