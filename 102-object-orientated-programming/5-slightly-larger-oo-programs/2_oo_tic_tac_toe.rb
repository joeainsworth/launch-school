require 'pry'

class Board
  attr_accessor :board

  def initialize
    create_board
  end

  def create_board
    board = {}
    1.upto(9) { |n| board[n] = Square.new }
    self.board = board
  end

  def display_board
    puts '     |     |     '
    puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
    puts '     |     |     '
    puts '-----------------'
    puts '     |     |     '
    puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
    puts '     |     |     '
    puts '-----------------'
    puts '     |     |     '
    puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
    puts '     |     |     '
  end

  def available_squares
    board.select { |s,v| v.mark == ' ' }.keys
  end
end

class Square
  attr_accessor :mark

  def initialize
    @mark = ' '
  end

  def to_s
    mark
  end
end

class Player
  attr_accessor :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    puts 'Please enter your name:'
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.empty?
      puts 'Please enter a valid name.'
    end
    self.name = name
  end

  def move
    puts 'Place your move:'
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if (1..9).include?(answer)
      puts 'Please enter a valid number.'
    end
    answer
  end
end

class Computer < Player
  def set_name
    self.name = %w(Alex Cathrine Greg Rachel)
  end
end

class GameEngine
  attr_accessor :board, :human, :computer

  def initialize
    clear_screen
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
  end

  def clear_screen
    system 'clear'
  end

  def play
    clear_screen
    loop do
      human.move
      pry
      break
    end
  end

end

GameEngine.new.play
