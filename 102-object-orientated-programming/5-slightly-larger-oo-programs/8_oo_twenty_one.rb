require 'colorize'

class Deck
  SUIT = %w(C D H S)
  RANK = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']

  attr_accessor :cards

  def initialize
    @cards = []
    setup_deck
    shuffle!
  end

  def setup_deck
    puts "Sorting cards..."
    sleep(1)
    SUIT.product(RANK) { |suit, rank| cards << Card.new(suit, rank) }
  end

  def deal_card!
    puts "Dealing card..."
    sleep(0.3)
    cards.shift
  end

  def shuffle!
    puts "Shuffling cards..."
    sleep(1)
    cards.shuffle!
  end
end

class Card
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def to_s
    "#{rank_msg} of #{suit_msg}"
  end

  def suit_msg
    case suit
    when 'C' then 'Clubs'
    when 'D' then 'Diamonds'
    when 'H' then 'Hearts'
    when 'S' then 'Spades'
    else
      suit
    end
  end

  def rank_msg
    case rank
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      rank
    end
  end

  def value
    case rank
    when 'J', 'Q', 'K' then 10
    when 'A' then 11
    else
      rank
    end
  end
end

class Participant
  attr_accessor :name, :hand, :hide_hand

  def initialize
    set_name
    @hand = []
    @hide_hand = false
    system 'clear'
  end

  def to_s
    name
  end

  def display_total_msg
    if hide_hand
      puts "#{name}'s hand;"
    else
      puts "#{name}'s hand, total of #{total};"
    end
  end

  def display_hand_msg(hide_dealer_hand = true)
    display_total_msg
    hand.each do |card|
      puts "- #{card}"
      if hide_dealer_hand
        puts '- One hidden card'
        break
      end
    end
    puts
  end

  def total
    total = 0
    hand.each { |card| total += card.value }
    hand.count { |card| card.rank == 'A' }.times { total -= 10 if total > 21 }
    total
  end

  def bust?
    total > 21
  end

  def blackjack?
    total == 21
  end

  def hit!(deck)
    hand << deck.deal_card!
  end
end

class Player < Participant
  def set_name
    puts 'Please enter your name:'
    answer = nil
    loop do
      answer = gets.chomp.capitalize
      break unless answer.empty?
      puts 'You must enter a name.'
    end
    @name = answer
  end

  def hit?
    puts "\nWould you like to hit or stay? [h/s]"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(h s).include?(answer)
      puts 'Please enter a valid option.'
    end
    answer == 'h'
  end
end

class Dealer < Participant
  def set_name
    @name = "Dealer"
  end

  def hit?
    total < 17
  end
end

class Game
  attr_accessor :deck, :player, :dealer

  def initialize
    system 'clear'
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def deal_cards
    2.times do
      player.hand << deck.deal_card!
      dealer.hand << deck.deal_card!
    end
  end

  def display_game_msg(hide_dealer_hand = true)
    system 'clear'
    player.display_hand_msg
    dealer.display_hand_msg(hide_dealer_hand)
  end

  def turn(participant, deck)
    loop do
      display_game_msg(false)
      break if participant.bust? || participant.blackjack?
      participant.hit? ? participant.hit!(deck) : break
    end
  end

  def display_win_loss_or_tie_by_total
    if player.total > dealer.total
      puts "#{player} beat #{dealer}!".green
    elsif player.total < dealer.total
      puts "#{dealer} beat #{player}!".red
    else
      puts "The round was a draw!".yellow
    end
  end

  def round_outcome(player, dealer)
    if player.bust?
      puts "#{player} bust, #{dealer} won!".red
    elsif player.blackjack?
      puts "#{player} got blackjack!".green
    elsif dealer.blackjack?
      puts "#{dealer} got blackjack!".red
    elsif dealer.bust?
      puts "#{dealer} bust, #{player} won!".green
    else
      display_win_loss_or_tie_by_total
    end
  end

  def play_again?
    puts "\nWould you like to play again? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts 'Please enter a valid option.'
    end
    answer == 'y'
  end

  def new_game
    system 'clear'
    player.hand.clear
    dealer.hand.clear
    self.deck = Deck.new
  end

  def play
    loop do
      deal_cards
      turn(player, deck) unless player.blackjack?
      turn(dealer, deck) unless player.bust? || player.blackjack?
      round_outcome(player, dealer)
      break unless play_again?
      new_game
    end
  end
end

Game.new.play
