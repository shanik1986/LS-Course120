class Array
  def joinor(delimeter = ', ', last_item_connection = 'or')
    return self[0].to_s if size == 1 || size.zero?

    "#{self[0..-2].join(delimeter)} #{last_item_connection} #{self[-1]}"
  end
end

module Hand
  attr_reader :total, :hand, :adjusted_aces

  def <<(card)
    hand << card
  end

  def aces
    hand.count { |card| card.face == "Ace" }
  end

  def [](key)
    hand[key]
  end

  def cards
    hand.joinor(', ', 'and')
  end

  def hidden_cards
    "#{hand[0]} and an unknown card"
  end

  def calculate_total!
    @total = 0
    hand.each { |card| @total += card.value }
  end

  def update_total!(card)
    @total += card.value
  end

  def adjust_for_aces!
    while adjusted_aces < aces
      @total -= 10
      @adjusted_aces += 1
    end
  end

  def print_hand
    puts "#{name} has: #{cards}"
  end

  def reset
    @hand = []
    @total = 0
    @adjusted_aces = 0
  end
end

class Participant
  BUST_SUM = 21

  attr_reader :name

  include Hand

  def initialize(name)
    @name = name
    @hand = []
    @total = 0
    @adjusted_aces = 0
  end

  def hit!(card)
    hand << card
  end

  def busted?
    total > BUST_SUM
  end

  def add_and_process_card(card)
    hit!(card)
    update_total!(card)
    adjust_for_aces! if busted?
  end

  def initialize_round
    calculate_total!
  end

  def display_result(is_dealer_busted, dealer_total)
    return print_busted_prompt if busted?

    result = if is_dealer_busted || total > dealer_total
               "won"
             elsif total < dealer_total
               "lost"
             else
               "tied the dealer"
             end
    puts "#{name} #{result} with: #{cards}"
    puts
  end

  def print_busted_prompt
    puts "#{name} busted!\n\n"
  end
end

class Player < Participant
  def initialize
    name = set_name
    super(name)
  end

  def stay?
    answer = nil

    puts "#{name}, Hit or Stay?"
    loop do
      answer = gets.chomp.downcase
      break if %w(hit stay).include?(answer)
      puts "Invalid input! Please enter only 'hit' or 'stay'"
    end
    answer == 'stay' ? true : false
  end

  def set_name
    puts "What's the name of the player?"
    answer = nil
    loop do
      answer = gets.chomp.strip
      break unless answer.empty?
      puts "Invalid input, please enter a name"
    end

    answer
  end

  def can_still_draw?
    total < BUST_SUM
  end
end

class Dealer < Participant
  LIMIT = 17

  attr_reader :hidden, :status

  def initialize
    @hidden = true
    super("Dealer")
  end

  def cards
    hidden ? hidden_cards : super
  end

  def reset
    @hidden = true
    super
  end

  def hit!(card)
    puts "Dealer draws card" if hand.size > 1
    super
  end

  def can_still_draw?
    total < 17
  end

  def initialize_round
    @hidden = false
    print_hand
    super
  end

  def display_result
    return print_busted_prompt if busted?
    print_hand
    puts
  end
end

class Deck
  SUITS = ['Hearts', 'Diamonds', 'Clubs', 'Spades'].freeze
  FACES = ('2'..'10').to_a + ['Jack', 'Queen', 'King', 'Ace'].freeze
  ROYALTY_VALUE = 10
  ACE_VALUE = 11

  attr_reader :cards

  def initialize
    @cards = new_deck
  end

  def give_card!
    @cards.delete(@cards.sample)
  end

  def reset_deck
    @cards = new_deck
  end

  def new_deck
    FACES.each_with_object([]) do |face, result|
      SUITS.each do |suit|
        value = case face
                when ('1'..'10') then face.to_i
                when 'Ace'       then ACE_VALUE
                else                  ROYALTY_VALUE
                end

        result << Card.new(face, suit, value)
      end
    end
  end
end

class Card
  attr_reader :face, :value, :suit

  def initialize(face, suit, value)
    @face = face
    @suit = suit
    @value = value
  end

  def to_s
    face
  end
end

class Game
  attr_reader :participants, :deck, :players, :dealer, :table

  MAX_PLAYERS = 6

  def initialize
    @deck = Deck.new
    @participants = []
  end

  def start
    display_welcome_message
    set_table
    loop do
      initial_deal
      show_initial_cards
      play_turns
      show_results
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end

  private

  def reset_game
    deck.reset_deck
    participants.each(&:reset)
    clear_screen
  end

  def play_turns
    participants.each { |participant| play_round(participant) }
    puts "Enter any key to show the results"
    gets.chomp
  end

  def show_results
    clear_screen

    dealer.display_result
    players.each do |player|
      player.display_result(dealer.busted?, dealer.total)
    end
  end

  def initial_deal
    2.times do
      participants.each { |participant| participant.hit!(deck.give_card!) }
    end
  end

  def show_initial_cards
    dealer.print_hand
    puts "\n\n\n"

    players.each do |player|
      puts "#{player.name} has: #{player.cards}\n\n"
    end
    puts
  end

  def player_round?(participant)
    participant.class == Player
  end

  def play_round(participant)
    participant.initialize_round
    return if all_busted?

    while participant.can_still_draw?
      break if player_round?(participant) && participant.stay?

      participant.add_and_process_card(deck.give_card!)
      puts "#{participant.name} has: #{participant.cards}\n\n"
    end

    participant.print_busted_prompt if participant.busted?
  end

  def all_busted?
    players.all?(&:busted?)
  end

  def display_welcome_message
    puts "Welcome to 21! Enter any key to start the game"
    gets.chomp
    clear_screen
  end

  def clear_screen
    system 'cls'
  end

  def display_goodbye_message
    puts "Thanks for playing 21!"
  end

  def play_again?
    answer = nil

    puts "Would you like to play another round? ('y'/'n')"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid input! Please answer with a 'y' or a 'n'"
    end
    answer == 'y' ? true : false
  end

  def set_table
    add_players
    participants << Dealer.new
    clear_screen
  end

  def table_full?(number_of_players)
    number_of_players >= MAX_PLAYERS
  end

  def add_players
    number_of_players = 0
    loop do
      participants << Player.new
      number_of_players += 1
      break if table_full?(number_of_players) || !more_players?
    end
  end

  def more_players?
    answer = nil
    puts "Will there be more players joining us? (y/n)"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid input! Please answer with a 'y' or a 'n'"
    end
    answer == 'y' ? true : false
  end

  def players
    participants.select { |participant| participant.class == Player }
  end

  def dealer
    participants.find { |participant| participant.class == Dealer }
  end

  def set_number
    answer = nil

    puts "How many players would like to play (maximum 6 players)?"
    loop do
      answer = gets.chomp.to_i
      break if (1..6).cover?(answer)
      puts "Invalid input! Please enter a number between 1 and 6."
    end
  end
end

Game.new.start
