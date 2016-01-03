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
  # Personalities and the likelihood they choose a particular weapon are defined in this constant
  # Each integer value is multipled by 10 to give a percentage chance of selection
  # For example, 'rock' => 4 has a 40% chance of being selected from an array
  PERSONALITIES = {
    'R2D2' => {
      'rock'     => 3,
      'paper'    => 1,
      'scissors' => 2,
      'lizard'   => 1,
      'spock'    => 3
    },
    'Leah' => {
      'rock'     => 2,
      'paper'    => 1,
      'scissors' => 5,
      'lizard'   => 1,
      'spock'    => 1
    },
    'Felix' => {
      'rock'     => 1,
      'paper'    => 2,
      'scissors' => 2,
      'lizard'   => 4,
      'spock'    => 1
    }
  }

  attr_accessor :probabilities

  def initialize
    super
    set_probabilities
  end

  def set_name
    self.name = PERSONALITIES.keys.to_a.sample
  end

  def set_probabilities
    self.probabilities = PERSONALITIES[name]
  end

  def adjust_weapon_weight(adjusted_weapon)
    # make it less likely the computer chooses the weapon
    probabilities[adjusted_weapon.to_s] -= 1

    # find a new weapon to reassign the probability to
    reassign_to_weapon = probabilities.keys.select { |weapon| weapon != adjusted_weapon }.sample

    # reassign the probability to a different weapon
    probabilities[reassign_to_weapon] += 1
  end

  def weapon_weight
    outcomes ||= {}

    Weapon::WEAPONS.each do |weapon|
      outcomes[weapon.to_sym] = { won: 0, lost: 0, tied: 0 }
    end

    history.each { |result, weapon| outcomes[weapon.to_sym][result.to_sym] += 1 }

    outcomes.each do |weapon, outcome|
      sum = outcome.values.reduce(:+)
      if sum > 0
        # adjust weapon if the probability of loosing when using it is greater than 60%
        if ((100 / sum) * outcome[:lost]) > 60
          # unless its probability is already 10%
          adjust_weapon_weight(weapon) unless probabilities[weapon.to_s] == 1
        end
      end
    end
  end

  def equip_weapon
    weapon_weight
    choices = []
    probabilities.each do |weapon, prob|
      prob.times { choices << weapon }
    end
    self.weapon = Object.const_get(choices.sample.capitalize).new
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
      computer.equip_weapon
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
