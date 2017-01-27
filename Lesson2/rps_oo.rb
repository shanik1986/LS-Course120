class Player
  MAX_SCORE = 5

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
  LEARNING_THRESHOLD = 0.2
  ADJUSTMENT = 10

  attr_accessor :behaviour

  def initialize(behaviour = Rule.new)
    super()
    @behaviour = behaviour
  end

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    @move = Move.new(deduct_move)
  end

  def deduct_move
    rand_number = rand(0...100.0)
    # puts "#Debugging: The random number is #{rand_number}"
    # p @behaviour.percentages
    # p @behaviour.cdf
    @behaviour.cdf.find { |sub_arr| rand_number <= sub_arr.last }.first
  end

  def learn(history)
    @win_stats = calc_stats(history.wins(self))
    @lose_stats = calc_stats(history.losses(self))

    # puts "The winnings are: #{@win_stats}"
    # puts "The losses are: #{@lose_stats}"

    adjust_behaviour(@win_stats)
    adjust_behaviour(@lose_stats.sort, -1)
  end

  def adjust_behaviour(hash, multiplier = 1)
    delta = ADJUSTMENT * multiplier
    hash.each do |move, probability|
      behaviour.change!(move, delta) if probability > LEARNING_THRESHOLD
    end
  end

  private

  def calc_stats(arr)
    return reset_hash if arr.size.zero?

    Move::VALUES.each_with_object({}) do |move, result|
      move_count = arr.count { |hash| hash[:computer].value == move }
      result[move] = (move_count.to_f / arr.size)
    end
  end

  def reset_hash
    Move::VALUES.each_with_object({}) { |move, result| result[move] = 0 }
  end
end

class Rule
  attr_reader :percentages, :cdf

  def initialize
    @base_increment = 100.0 / Move::VALUES.size
    @percentages = reset_rule
    @cdf = update_cdf
  end

  def reset_rule
    Move::VALUES.each_with_object([]) do |option, arr|
      arr << [option, @base_increment]
    end
  end

  def change!(move, delta)
    changed_item = @percentages.find { |sub_arr| sub_arr.first == move }
    delta = adjust_delta(changed_item, delta)

    changed_item[1] += delta
    move_index = @percentages.index(changed_item)

    percentages_without_move = @percentages.select { |arr| arr != changed_item }
    compensated_items = compensate_percentages(percentages_without_move, delta)
    @percentages = compensated_items.insert(move_index, changed_item)
    @cdf = update_cdf
  end

  def compensate_percentages(arr, sum)
    return arr if sum.zero?

    needed_compensations = arr.count { |item| item.last != 0 }
    compensation = -(sum.to_f / needed_compensations)
    arr.map! do |item|
      move = item.first
      if item.last + compensation <= 0
        sum -= item.last
        [move, 0]
      else
        sum += compensation
        [move, item.last + compensation]
      end
    end

    compensate_percentages(arr, sum)
  end

  def update_cdf
    sum = 0

    @percentages.each_with_object([]) do |sub_arr, result|
      result << [sub_arr.first, sub_arr.last + sum]
      sum += sub_arr.last
    end
  end

  private

  def adjust_delta(changed_item, delta)
    if changed_item.last + delta >= 100
      100 - changed_item.last
    elsif changed_item.last + delta <= 0
      -changed_item.last
    else
      delta
    end
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
  attr_accessor :records

  def initialize
    @records = []
  end

  def wins(computer)
    @records.select { |hash| hash[:winner] == computer }
  end

  def losses(computer)
    @records.select do |hash|
      (hash[:winner] != computer) && (hash[:winner] != :Tie)
    end
  end

  def log_round(winner, human_move, computer_move)
    @records += [{ winner: winner, human: human_move, computer: computer_move }]
  end

  def display(arr = @records)
    arr.each_with_index do |round, i|
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
      # history.display
      computer.learn(history)
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
      :Tie
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
    when :Tie     then puts "It's a tie"
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
