require 'colorize'

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

  def to_s
    name
  end
end

class Human < Player
  def set_name
    puts 'Please enter your name:'
    answer = nil
    loop do
      answer = gets.chomp.capitalize
      break unless answer.empty?
      puts 'Please enter a valid name.'.red
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
      puts 'Please enter a valid weapon.'.red
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
    # make it 10% less likely the computer chooses the weapon
    probabilities[adjusted_weapon.to_s] -= 1

    # find a new weapon to reassign the 10% to
    reassign_to_weapon = probabilities.keys.select { |weapon| weapon != adjusted_weapon }.sample

    # reassign the 10%
    probabilities[reassign_to_weapon] += 1
  end

  def change_weapon_weight
    # create a hash of all possible outcomes
    outcomes ||= {}
    Weapon::WEAPONS.each |weapon|
      outcomes[weapon.to_sym] = { won: 0, lost: 0, tied: 0 }
    end

    # insert results of previous rounds into hash
    history.each { |result, weapon| outcomes[weapon.to_sym][result.to_sym] += 1 }

    outcomes.each do |weapon, outcome|
      sum = outcome.values.reduce(:+)
      if sum > 0
        # if the probability of loosing when using weapon is greater than 60%
        if ((100 / sum) * outcome[:lost]) > 60
          # unless its probability is already 10% it cannot be lowered further
          adjust_weapon_weight(weapon) unless probabilities[weapon.to_s] == 1
        end
      end
    end
  end

  def equip_weapon
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
    puts "Hello #{human}, Welcome to Rock, Paper, Scissors"
  end

  def play_again?
    puts 'Would you like to play another round? (Y/n)'.yellow
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts 'Please enter a valid option.'.red
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
      computer.change_weapon_weight
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
    line_break
    if result == :human
      puts "#{human} beat #{computer}!".green
    elsif result == :computer
      puts "#{computer} beat #{human}!".red
    else
      puts "It's a tie!".yellow
    end
    line_break
  end

  def continue_game
    puts 'Press [ENTER] to continue...'
    gets.chomp
    system 'clear'
  end

  def calculate_round
    if human.weapon > computer.weapon
      :human
    elsif human.weapon < computer.weapon
      :computer
    else
      :tie
    end
  end

  def round_outcome
    result = calculate_round
    display_outcome_msg(result)
    record_outcome(result)
    self.round_count += 1
    continue_game
  end

  def who_is_winning
    if human.score > computer.score
      :human
    elsif human.score < computer.score
      :computer
    end
  end

  def display_score_msg
    human_msg = "#{human} has won #{human.score} round(s)"
    computer_msg = "#{computer} has won #{computer.score} round(s)"
    case who_is_winning
    when :human
      puts human_msg.green
      puts computer_msg.red
    when :computer
      puts human_msg.red
      puts computer_msg.green
    else
      puts human_msg.yellow
      puts computer_msg.yellow
    end
  end

  def display_moves_msg(player)
    puts "#{player}'s recent moves;"
    player.history.reverse_each { |result| puts "- #{result.join(' with ')}" }
  end

  def line_break
    puts "=" * 50
  end

  def display_stats_msg
    puts "First to win #{TOTAL_ROUNDS} rounds is the victor!"
    line_break
    display_score_msg
    line_break
    display_moves_msg(human)
    display_moves_msg(computer)
    line_break
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
      round_outcome
      display_stats_msg
      victor?
    end
    # display_goodbye_msg
  end
end

system 'clear'
RPSGame.new.play
