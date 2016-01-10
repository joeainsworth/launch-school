require 'pry'

module TicTacToe
  module Display
    def clear_screen
      system 'clear'
    end
  end

  class Board
    include Display

    WINNING_LINES = [1, 2, 3], [4, 5, 6], [7, 8, 9],
                    [1, 4, 7], [2, 5, 8], [3, 6, 9],
                    [1, 5, 9], [7, 5, 3]

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
      square.select { |_, v| v.mark == ' ' }.keys
    end

    def empty_squares_msg
      empty_squares.join(', ')
    end

    def board_full?
      empty_squares.empty?
    end

    def winning_marker(human, computer)
      mark_count = nil
      WINNING_LINES.each do |line|
        if square.values_at(*line).map(&:mark).count(human.marker) == 3
          return human
        elsif square.values_at(*line).map(&:mark).count(computer.marker) == 3
          return computer
        end
      end
      nil
    end

    def set_marker!(square_no, marker)
      square[square_no].mark = marker
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

    def marker
      mark
    end
  end

  class Player
    include Display

    attr_accessor :name, :player_type, :marker, :score

    def initialize(player_type = :human, human_marker = nil)
      @player_type = player_type
      @score = 0
      set_name
      set_marker(human_marker)
    end

    def to_s
      name
    end

    def human?
      player_type == :human
    end

    def turn(board)
      if human?
        puts "Choose a square from #{board.empty_squares_msg}:"
        answer = nil
        loop do
          answer = gets.chomp.to_i
          break if board.empty_squares.include?(answer)
          puts 'Please enter a valid number.'
        end
        board.set_marker!(answer, marker)
      else
        board.set_marker!(board.empty_squares.sample, marker)
      end
    end

    private

      def set_marker(human_marker)
        if human?
          @marker = select_marker
        else
          mark = nil
          loop do
            mark = %w(! @ £ $ % ^ & * +).sample
            break unless mark == human_marker
          end
          @marker = mark
        end
      end

      def select_marker
        puts 'Please choose choose a marker:'
        answer = nil
        loop do
          answer = gets.chomp.upcase
          break if answer.length == 1
          puts 'You must choose a valid marker.'
        end
        answer
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
      clear_screen
    end
  end

  class Computer < Player
    def set_name
      self.name = %w(Alex Cathrine Greg Rachel).sample
    end
  end

  class GameEngine
    include Display

    TOTAL_ROUNDS = 2

    attr_accessor :board, :human, :computer, :current_player

    def initialize
      clear_screen
      @board = Board.new
      @human = Human.new
      @computer = Computer.new(:computer, human.marker)
      @current_player = human
    end

    def play
      display_welcome_msg
      loop do
        loop do
          loop do
            current_player_turn
            break if board_full? || winner?
          end
          board.display_board
          display_winner_msg
          display_stats_msg
          break if game_over?
          new_game
        end
        display_game_over_msg
        break unless play_again?
      end
    end

    def someone_won
      case board.winning_marker(human, computer)
      when human
        human.score += 1
        human
      when computer
        computer.score += 1
        computer
      end
    end

    def winner?
      board.winning_marker(human, computer)
    end

    private

      def display_game_over_msg
        if human_win?
          puts "#{human} won!"
        else
          puts "#{computer} won!"
        end
      end

      def game_over?
        human.score == 5 || computer.score == 5
      end

      def board_full?
        board.board_full?
      end

      def display_winner_msg§
        if winner?
          puts "#{someone_won} won!"
        else
          puts 'It was a tie!'
        end
        continue_game
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
        puts "#{human}'s marker is: #{human.marker}"
        sleep(1)
        puts "#{computer}'s marker is: #{computer.marker}"
        sleep(1)
        puts "First to #{TOTAL_ROUNDS} rounds wins!"
        continue_game
      end

      def display_stats_msg
        puts "#{human} has won #{human.score} rounds"
        puts "#{computer} has won #{computer.score} rounds"
        puts "=" * 25
        if human_win?
          puts "#{human} is winning!"
        else
          puts "#{computer} is winning!"
        end
        puts "=" * 25
        continue_game
      end

      def human_win?
        human.score > computer.score
      end

      def current_player_turn
        board.display_board
        current_player.turn(board)
        if current_player == human
          self.current_player = computer
        else
          self.current_player = human
        end
      end

      def continue_game
        puts ''
        puts 'Press [ENTER] to continue...'
        gets.chomp
        clear_screen
      end
  end
end

TicTacToe::GameEngine.new.play
