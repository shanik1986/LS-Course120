require 'pry'

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

class Computer < Player
  @@LEARNING_THRESHOLD = 0.5

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
    puts "The random number is #{rand_number}"
    p @behaviour.percentages
    p @behaviour.cdf
    @behaviour.cdf.find { |sub_arr| rand_number <= sub_arr.last }.first
  end

  def learn(history)

  end

  private

  def choose_only_one_move(move)
    @behaviour.rule.map! do |sub_arr|
      if sub_arr.first == move
        [sub_arr.first, 100]
      else
        [sub_arr.first, 0]
      end
    end
  end
end

class Rule
  attr_reader :percentages, :cdf

  def initialize
    @base_increment = 100.0 / Move::VALUES.size
    @percentages = reset_rule
    @cdf = update_cdf!
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
    # puts "The index of #{move} is #{move_index}"
    @percentages = compensated_items.insert(move_index, changed_item)
    update_cdf!
  end

  def compensate_percentages(arr, sum)
    return arr if sum == 0

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

  def update_cdf!
    sum = 0
    # puts "Building probability array:"
    @cdf = @percentages.each_with_object([]) do |sub_arr, result|
             # puts "Probability for #{sub_arr.first} rock is #{sub_arr.last + sum}"
             result << [sub_arr.first, sub_arr.last + sum]
             sum += sub_arr.last
             # puts "Next probability would be #{sum} + #{sub_arr.last}"
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

computer = Computer.new
computer.choose
puts
computer.behaviour.change!('scissors', 90)
computer.choose
puts
computer.behaviour.change!('lizard', 20)
computer.choose
puts
computer.behaviour.change!('scissors', -90)
computer.choose
