# In RPS two players are playing against each other, and each of them chooses
# one possible move (rock, paper or scissors):
# 1) Rock beats Scissors
# 2) Scissors beat Paper
# 3) Paper beats Rock
#
# If two players choose the same move then its a tie
#
# *Classes:*
# Move Class Objects
#   1) rock
#   2) paper
#   3) scissors
#
# Player Class Objects
#   1) computer
#   2) human
#
# *Methods:*
#   1) compare
#   2) choose

class Player
  MAX_SCORE = 3

  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
  end

  def to_s
    name
  end
end

class Human < Player
  def set_name
    answer = ''
    loop do
      puts "What's your name?"
      answer = gets.chomp
      break unless answer.empty?
      puts 'Sorry, must enter value'
    end
    self.name = answer
  end

  def choose
    choice = ''
    loop do
      puts 'Please choose rock, paper, scissors, lizard or spock:'
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      puts 'Error, invalid choice'
    end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  attr_reader :value

  VALUES = %w(rock paper scissors lizard spock).freeze

  WINNING_CONDITIONS = {
    'rock'     =>   %w(scissors lizard),
    'paper'    =>   %w(rock spock),
    'scissors' =>   %w(paper lizard),
    'spock'    =>   %w(rock scissors),
    'lizard'   =>   %w(spock paper)
  }.freeze

  def to_s
    @value
  end

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_CONDITIONS[@value].include?(other_move.value)
  end

  def <(other_move)
    !WINNING_CONDITIONS[@value].include?(other_move.value) &&
      @value != other_move.value
  end
end

class MoveHistory
  attr_accessor :history

  def initialize
    @history = []
  end

  def log_round(winner, human_move, computer_move)
    @history += [{ winner: winner, human: human_move, computer: computer_move }]
  end

  def display
    @history.each_with_index do |round, i|
      puts "Round #{i + 1}: \tHuman Move: #{round[:human].value};\n\
           \tComputer Move: #{round[:computer].value};\n\
           \tWinner: #{round[:winner]}\n\n"
    end
  end
end

class RPSGame
  attr_accessor :human, :computer
  attr_reader :history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @history = MoveHistory.new
  end

  def play_game
    display_welcome_message

    loop do
      while (human.score < Player::MAX_SCORE) &&
            (computer.score < Player::MAX_SCORE)
        play_round
      end
      display_game_winner
      break unless play_again?
      human.score = 0
      computer.score = 0
      system 'cls'
      history.display
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors, Lizard, Spock!'
  end

  def display_goodbye_message
    puts 'Thanks for playing! Bye bye'
  end

  def decide_winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    else
      :tie
    end
  end

  def display_choices
    puts "#{human} chose: #{human.move}"
    puts "#{computer} chose: #{computer.move}"
  end

  def display_winner(winner)
    case winner
    when human    then puts "#{human} won!"
    when computer then puts "#{computer} won!"
    when :tie     then puts "It's a tie"
    end
  end

  def play_round
    human.choose
    computer.choose
    display_choices

    winner = decide_winner
    history.log_round(winner, human.move, computer.move)

    display_winner(winner)
    adjust_score(winner)
    display_score
  end

  def display_score
    puts "#{computer}: #{computer.score}\t;\t"\
         "#{human}: #{human.score}\n\n"
  end

  def adjust_score(winner)
    if winner == human
      human.score += 1
    elsif winner == computer
      computer.score += 1
    end
  end

  def display_game_winner
    if computer.score == Player::MAX_SCORE
      puts "#{computer} won the game!"
    else
      puts "#{human} won the game!"
    end
  end

  def play_again?
    answer = ''
    loop do
      puts 'Would you like to play again?'
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts 'Error, invalid input'
    end
    %w(y yes).include?(answer)
  end
end

RPSGame.new.play_game
