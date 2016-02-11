[1, 2, 3].each do |num|
  puts num
end

# passing in a block to integer times method
3.times do |num|
  puts num
end

# passing in a block to the array map method
[1, 2, 3].map do |num|
  num + 1
end

# passing in a block to the file open method
File.open('tmp.txt', 'w') do |file|
  file.write('first line!')
end
