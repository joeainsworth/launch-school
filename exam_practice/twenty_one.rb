require 'colorize'

module GameUtilities
  def clear_display
    system 'clear'
  end

  def question(msg)
    puts "=> #{msg}"
  end

  def won(msg)
    puts "#{msg}".green
  end

  def lost(msg)
    puts "#{msg}".red
  end

  def draw(msg)
    puts "#{msg}".yellow
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
    SUITS.product(RANKS) { |suit, rank| self.cards << Card.new(suit, rank) }
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

  def total
    total = 0
    hand.each { |card| total += card.value }
    hand.count { |card| card == 'A' }.times { total -= 10 if total > 21 }
    total
  end

  def total_msg(hide = false)
    if hide
      puts "Total: ?"
    else
      puts "Total: #{total}"
    end
    puts
  end

  def bust?
    total > 21
  end

  def blackjack?
    total == 21
  end

  def to_s
    "#{name}"
  end
end

class Dealer < Participant
  def set_name
    self.name = 'Dealer'
  end

  def display_hand(hide)
    puts "#{name}'s hand:"
    hand.each do |card|
      display_card "#{card}"
      if hide
        display_card "One hidden card"
        break
      end
    end
    total_msg(hide)
  end

  def hit_or_stay
    answer = nil
    if total < 17
      answer = 'h'
    else
      answer = 's'
    end
    sleep 1
    answer
  end
end

class Player < Participant
  def set_name
    question "Please enter your name:"
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

  def hit_or_stay
    answer = nil
    loop do
      question "Would you like to hit or stay? [h/s]"
      answer = gets.chomp.downcase
      break if %w(h s).include?(answer)
    end
    clear_display
    answer
  end
end

class Game
  include GameUtilities

  attr_accessor :deck, :dealer, :player

  def initialize
    welcome
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def welcome
    clear_display
    puts 'Welcome to Twenty One!'
    continue?
  end

  def deal_card(participant)
    participant.hand << deck.deal!
  end

  def deal_cards
    2.times do
      player.hand << deck.deal!
      dealer.hand << deck.deal!
    end
  end

  def display_hands(participant)
    if participant.name != 'Dealer'
      hide = true
    else
      hide = false
    end
    player.display_hand
    dealer.display_hand(hide)
  end

  def turn(participant)
    loop do
      display_hands(participant)
      break if participant.bust? || participant.blackjack?
      move = participant.hit_or_stay
      deal_card(participant) if move == 'h'
      break if move == 's'
      clear_display
    end
  end

  def game_decided_by_score_msg
    if player.total > dealer.total
      won "#{player} won, #{dealer} lost!"
    elsif dealer.total > player.total
      lost "#{dealer} won, #{player} lost!"
    elsif
      draw "Game was tied!"
    end
  end

  def game_outcome_msg
    if player.bust?
      lost "#{player} bust, #{dealer} won!"
    elsif player.blackjack?
      won "#{player} won, #{dealer} lost!"
    elsif dealer.bust?
      won "#{dealer} bust, #{player} won!"
    elsif dealer.blackjack?
      lost "#{dealer} won, #{player} lost!"
    elsif
      game_decided_by_score_msg
    end
  end

  def play_again?
    puts
    answer = nil
    loop do
      puts 'Would you like to play again? [y/n]'
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
    end
    return false if answer == 'n'
    answer
  end

  def new_game
    system 'clear'
    deck.shuffle_deck!
    player.hand.clear
    dealer.hand.clear
  end

  def play
    loop do
      deal_cards
      turn(player) unless player.blackjack?
      turn(dealer) unless player.bust? || player.blackjack?
      game_outcome_msg
      break unless play_again?
      new_game
    end
  end

end

Game.new.play
