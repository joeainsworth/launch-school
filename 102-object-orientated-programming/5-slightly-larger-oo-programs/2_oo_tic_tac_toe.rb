require 'pry'

class Board
  attr_accessor :square

  def initialize
    create_board
  end

  def create_board
    square = {}
    1.upto(9) { |n| square[n] = Square.new }
    self.square = square
  end

  def empty_squares
    square.select { |_,v| v.mark == ' ' }.keys
  end

  def empty_squares_msg
    empty_squares.join(', ')
  end

  def board_full?
    empty_squares.empty?
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
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_accessor :name

  def initialize
    set_name
  end

  def to_s
    name
  end

  def set_marker!(board, square_no, player)
    case player
    when :human
      board.square[square_no].mark = HUMAN_MARKER
    when :computer
      board.square[square_no].mark = COMPUTER_MARKER
    end
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

  def turn(board)
    puts "Choose a square from #{board.empty_squares_msg}:"
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if board.empty_squares.include?(answer)
      puts 'Please enter a valid number.'
    end
    set_marker!(board, answer, :human)
  end
end

class Computer < Player
  def set_name
    self.name = %w(Alex Cathrine Greg Rachel)
  end

  def turn(board)
    square = board.empty_squares.sample
    set_marker!(board, square, :computer)
  end
end

class GameEngine
  WINNING_LINES = [1, 2, 3], [4, 5, 6], [7, 8, 9],
                  [1, 4, 7], [2, 5, 8], [3, 6, 9],
                  [1, 5, 9], [7, 5, 3]

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

  def display_board
    puts '     |     |     '
    puts "  #{board.square[1]}  |  #{board.square[2]}  |  #{board.square[3]}  "
    puts '     |     |     '
    puts '-----------------'
    puts '     |     |     '
    puts "  #{board.square[4]}  |  #{board.square[5]}  |  #{board.square[6]}  "
    puts '     |     |     '
    puts '-----------------'
    puts '     |     |     '
    puts "  #{board.square[7]}  |  #{board.square[8]}  |  #{board.square[9]}  "
    puts '     |     |     '
    puts ''
  end

  def board_full?
    board.board_full?
  end

  def calculate_winner
    ['X', 'O'].each do |player|
      WINNING_LINES.each do |line|
        return player if line.count { |no| board.square[no].mark == player } == 3
      end
    end
    nil
  end


  def winner?
    calculate_winner
  end

  def play
    clear_screen
    loop do
      display_board
      human.turn(board)
      pry
      break if board_full? || winner?
      computer.turn(board)
      break if board_full? || winner?
    end
    display_board
  end

end

GameEngine.new.play
