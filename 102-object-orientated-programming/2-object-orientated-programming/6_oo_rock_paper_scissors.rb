require 'pry'

class Weapon
  WEAPONS = %w(rock paper scissors lizard spock)

  attr_reader :name, :beats, :loses

  def >(other)
    @beats.include?(other.to_s)
  end

  def <(other)
    @loses.include?(other.to_s)
  end

  def to_s
    name
  end
end

class Rock < Weapon
  def initialize
    @name = 'rock'
    @beats = %w(lizard scissors)
    @loses = %w(paper spock)
  end
end

class Paper < Weapon
  def initialize
    @name = 'paper'
    @beats = %w(rock spock)
    @loses = %w(scissors lizard)
  end
end

class Scissors < Weapon
  def initialize
    @name = 'scissors'
    @beats = %w(paper lizard)
    @loses = %w(rock spock)
  end
end

class Lizard < Weapon
  def initialize
    @name = 'lizard'
    @beats = %w(spock paper)
    @loses = %w(scissors rock)
  end
end

class Spock < Weapon
  def initialize
    @name = 'spock'
    @beats = %w(scissors rock)
    @loses = %w(lizard paper)
  end
end

class Player
  attr_accessor :name, :weapon, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end
end

class Human < Player
  def set_name
    puts 'Please enter your name:'
    answer = nil
    loop do
      answer = gets.chomp.capitalize
      break unless answer.empty?
      puts 'Please enter a valid name.'
    end
    self.name = answer
    system 'clear'
  end

  def equip_weapon
    puts "Please select a weapon from #{Weapon::WEAPONS.join(', ')}:"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if Weapon::WEAPONS.include?(answer)
      puts 'Please enter a valid weapon.'
    end
    self.weapon = Object.const_get(answer.capitalize).new
    system 'clear'
  end
end

class Computer < Player
  attr_accessor :probabilities

  # Establish player personalities and the chance they will pick a particular weapon
  # The higher the number the greater the chance that the weapon will be selected

  PERSONALITIES = {
    'R2D2' => {
      'rock'     => 0.1,
      'paper'    => 0.2,
      'scissors' => 0.3,
      'lizard'   => 0.4,
      'spock'    => 0.5
    }
  }


  def set_name
    self.name = PERSONALITIES.keys.to_a.sample
    self.probabilities = PERSONALITIES[name]
    pry
  end

  # get history of computer moves
  # for each move work out wh

  def equip_weapon(human_history)
    rand_no = rand(0.1..1)
    choice = nil
    probabilities.each do |weapon, prob|
      if prob > rand_no
        choice = weapon
        break
      end
    end
    puts choice
    self.weapon = Object.const_get(choice.capitalize).new
  end
end

class RPSGame
  TOTAL_ROUNDS = 5

  attr_accessor :human, :computer, :round_count

  def initialize
    @human = Human.new
    @computer = Computer.new
    @round_count = 0
  end

  def display_welcome_msg
    puts "Welcome to Rock, Paper, Scissors #{human.name}"
  end

  def play_again?
    puts 'Would you like to play another round? (Y/n)'
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts 'Please enter a valid option.'
    end
    answer == 'y' ? true : false
    system 'clear'
  end

  def display_weapon_msg
    puts "#{human.name} has selected #{human.weapon}"
    puts "#{computer.name} has seleceted #{computer.weapon}"
  end

  def record_outcome(result)
    if result == :human
      human.score += 1
      human.history << [:won, human.weapon.name]
      computer.history << [:lost, computer.weapon.name]
    elsif result == :computer
      computer.score += 1
      computer.history << [:won, computer.weapon.name]
      human.history << [:lost, human.weapon.name]
    else
      computer.history << [:tied, computer.weapon.name]
      human.history << [:tied, human.weapon.name]
    end
  end

  def display_outcome_msg(result)
    puts "=" * 25
    if result == :human
      puts "#{human.name} beat #{computer.name}!"
    elsif result == :computer
      puts "#{computer.name} beat #{human.name}!"
    else
      puts "It's a tie!"
    end
    puts "=" * 25
  end

  def continue_game
    puts 'Press [ENTER] to continue...'
    gets.chomp
    system 'clear'
  end

  def calculate_outcome
    if human.weapon > computer.weapon
      result = :human
    elsif human.weapon < computer.weapon
      result = :computer
    else
      result = :tie
    end
    display_outcome_msg(result)
    record_outcome(result)
    self.round_count += 1
    continue_game
  end

  def display_stats_msg
    puts "Round #{round_count} (first to #{TOTAL_ROUNDS} wins)".upcase
    puts '=' * 25
    puts "#{human.name} has won #{human.score} round(s)"
    puts "#{computer.name} has won #{computer.score} round(s)"
    puts "=" * 25
    puts "#{human.name}'s recent moves;"
    human.history.reverse_each { |move| puts "- #{move.join(' with ')}" }
    puts "#{computer.name}'s recent moves;"
    computer.history.reverse_each { |move| puts "- #{move.join(' with ')}" }
    puts '=' * 25
    continue_game
  end

  def victor?
    human.score == TOTAL_ROUNDS || computer.score == TOTAL_ROUNDS
  end

  def play
    display_welcome_msg
    loop do
      human.equip_weapon
      computer.equip_weapon(human.history)
      display_weapon_msg
      calculate_outcome
      display_stats_msg
      break if victor?
    end
    # display_goodbye_msg
  end
end

system 'clear'
RPSGame.new.play
