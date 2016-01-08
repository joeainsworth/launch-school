require 'pry'

module Display
  def clear_screen
    system 'clear'
  end
end

class Board
  include Display

  attr_accessor :square

  def initialize
    create_board
  end

  def create_board
    square = {}
    1.upto(9) { |n| square[n] = Square.new }
    self.square = square
  end

  def display_board
    clear_screen
    puts '     |     |     '
    puts "  #{square[1]}  |  #{square[2]}  |  #{square[3]}  "
    puts '     |     |     '
    puts '-----------------'
    puts '     |     |     '
    puts "  #{square[4]}  |  #{square[5]}  |  #{square[6]}  "
    puts '     |     |     '
    puts '-----------------'
    puts '     |     |     '
    puts "  #{square[7]}  |  #{square[8]}  |  #{square[9]}  "
    puts '     |     |     '
    puts
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
  INITIAL_MARKER = ' '

  attr_accessor :mark

  def initialize
    @mark = ' '
  end

  def to_s
    mark
  end

  def marked?
    marker != INITIAL_MARKER
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
    self.name = answer
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
    self.name = %w(Alex Cathrine Greg Rachel).sample
  end

  def turn(board)
    square = board.empty_squares.sample
    set_marker!(board, square, :computer)
  end
end

class GameEngine
  include Display

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

  def board_full?
    board.board_full?
  end

  def winning_marker
    mark_count = nil
    [Player::HUMAN_MARKER, Player::COMPUTER_MARKER].each do |player|
      WINNING_LINES.each do |line|
        mark_count = line.count { |no| board.square[no].mark == player }
        return player if mark_count == 3
      end
    end
    nil
  end

  def someone_won
    case winning_marker
    when Player::HUMAN_MARKER
      human
    when Player::COMPUTER_MARKER
      computer
    end
  end

  def winner?
    winning_marker
  end

  def display_winner_msg
    if winner?
      puts "#{someone_won} won!"
    else
      puts 'It was a tie!'
    end
  end

  def play_again?
    puts 'Would you like to play again? (Y/n)'
    answer = nil
    loop do
      answer = gets.chomp
      break if %w(y n).include?(answer)
      puts 'Please enter a valid option.'
    end
    answer == 'y'
  end

  def new_game
    self.board = Board.new
  end

  def display_welcome_msg
    clear_screen
    puts "Welcome to the Tic Tac Toe #{human}!"
    sleep(1)
    puts "#{human}'s marker is: #{Player::HUMAN_MARKER}"
    sleep(1)
    puts "#{computer}'s marker is: #{Player::COMPUTER_MARKER}"
    sleep(2)
  end

  def play
    display_welcome_msg
    loop do
      loop do
        board.display_board
        human.turn(board)
        break if board_full? || winner?
        computer.turn(board)
        break if board_full? || winner?
      end
      board.display_board
      display_winner_msg
      break unless play_again?
      new_game
    end
  end

end

GameEngine.new.play
