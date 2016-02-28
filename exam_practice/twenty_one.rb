# Classes;
# Deck
# Player
# Dealer
# Card
#
# Deal
# Stay or Hit
# Display hand
# Outcome
#
# New game, shuffle cards, deal cards, display cards, loop hit or stay & outcome, loop dealer turn, outcome

require 'pry'

module GameUtilities
  def clear_display
    system 'clear'
  end

  def display(msg)
    puts "=> #{msg}"
  end

  def display_card(card)
    puts "- #{card}"
  end

  def continue?
    puts 'Press [enter] to continue'
    gets.chomp
    system 'clear'
  end
end

class Deck
  SUITS = %w(C D H S)
  RANKS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 'J', 'Q', 'K', 'A']

  attr_reader :cards

  def initialize
    @cards = []
    shuffle_deck!
  end

  def shuffle_deck!
    SUITS.each do |suit|
      RANKS.each do |rank|
        self.cards << Card.new(suit, rank)
      end
    end
    self.cards.shuffle!
  end

  def deal!
    self.cards.shift
  end
end

class Card
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def suit_msg
    case suit
    when 'C' then 'Clubs'
    when 'D' then 'Diamonds'
    when 'H' then 'Hearts'
    when 'S' then 'Spades'
    end
  end

  def value_msg
    case rank
    when 1..9 then rank
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    end
  end

  def value
    case rank
    when 1..9 then rank
    when 'J', 'Q', 'K' then 10
    when 'A' then 11
    end
  end

  def to_s
    "#{value_msg} of #{suit_msg}"
  end
end

class Participant
  include GameUtilities

  attr_accessor :name, :hand

  def initialize
    set_name
    @hand = []
  end

  def hand_total
    total = 0
    hand.each { |card| total += card.value }
    total
  end

  def total_msg(hide = false)
    if hide
      puts "Total: ?"
    else
      puts "Total: #{hand_total}"
    end
    puts
  end
end

class Dealer < Participant
  def set_name
    self.name = 'Dealer'
  end

  def display_hand(hide = true)
    puts "#{name}'s hand:"
    hand.each do |card|
      display_card "#{card}"
      if hide
        display_card "One hidden card"
        break
      end
    end
    total_msg(true)
  end
end

class Player < Participant
  def set_name
    display "Please enter your name:"
    name = nil
    loop do
      name = gets.chomp.capitalize
      break unless name.empty?
    end
    self.name = name
    clear_display
  end

  def display_hand
    puts "#{name}'s hand:"
    hand.each do |card|
      display_card "#{card}"
    end
    total_msg
  end
end

class Game
  include GameUtilities

  attr_accessor :deck, :dealer, :player

  def initialize
    # welcome
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def welcome
    clear_display
    display 'Welcome to Twenty One!'
    continue?
  end

  def deal_cards
    2.times do
      player.hand << deck.deal!
      dealer.hand << deck.deal!
    end
  end

  def display_hands
    player.display_hand
    dealer.display_hand
  end

  def play
    deal_cards
    display_hands
  end
end

Game.new.play
