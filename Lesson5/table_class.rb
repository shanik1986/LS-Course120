class Table
  attr_reader :number_of_players

  MAX_PLAYERS = 6
  def initialize
    @number_of_players = 0
    @participants = []
  end

  def players
    @participants.select { |participant| participant.class == Player }
  end

  def set_table
    add_players
    participants << Dealer.new
  end

  def table_full?
    number_of_players <= MAX_PLAYERS
  end

  def add_players
    loop do
      @participants << Player.new
      @number_of_players += 1
      break if table_full? || !more_players?
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
  end


  def set_number
    answer = nil

    puts "How many players would like to play (maximum 6 players)?"
    loop do
      answer = gets.chomp.to_i
      break if (1..6).include?(answer)
      puts "Invalid input! Please enter a number between 1 and 6."
    end
  end
end
