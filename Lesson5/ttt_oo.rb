class Array
  def joinor(delimeter = ', ', last_item_connection = 'or')
    return self[0].to_s if size == 1

    "#{self[0..-2].join(delimeter)} #{last_item_connection} #{self[-1]}"
  end
end

class Board
  attr_reader :unmarked_squares, :winning_marker

  WINNING_LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9], # Rows
    [1, 4, 7], [2, 5, 8], [3, 6, 9], # Columns
    [1, 5, 9], [3, 5, 7]             # Diagonals
  ].freeze

  INITIAL_MARKER = ' '.freeze

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
    puts
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| @squares[key] = INITIAL_MARKER }
    @unmarked_squares = @squares.keys
    @winning_marker = nil
  end

  def find_square(marker)
    WINNING_LINES.each do |line|
      if @squares.values_at(*line).count(marker) == 2
        chosen_square = @squares.find do |k, v|
                          line.include?(k) && v == INITIAL_MARKER
                        end

        return chosen_square.first unless chosen_square.nil?
      end
    end
    nil
  end

  def strategic_move
    strategic_square = (@squares.size + 1) / 2
    @squares[strategic_square] == INITIAL_MARKER ? strategic_square : false
  end

  def [](key)
    @squares[key]
  end

  def []=(key, obj)
    @squares[key] = obj
    unmarked_squares.delete(key)
  end

  def full?
    unmarked_squares.empty?
  end

  def player_won?(player_marker)
    @winning_marker = detect_winning_marker(player_marker)
    !!@winning_marker
  end

  def detect_winning_marker(player_marker)
    WINNING_LINES.each do |line|
      chosen_squares = @squares.values_at(*line)
      return player_marker if chosen_squares.count(player_marker) == 3
    end
    nil
  end
end

class Player
  @@markers = ['X', 'O']

  attr_reader :marker, :name
  attr_accessor :score, :opposing_marker

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class Human < Player
  def initialize
    @name = set_name

    marker = set_marker
    @@markers.delete(marker)

    super(marker)
  end

  def pick_move(board)
    options = board.unmarked_squares

    ask_for_number(options)
    get_valid_number(options)
  end

  private

  def set_marker
    puts "Would you like to be #{@@markers.joinor}?"
    answer = nil
    loop do
      answer = gets.chomp.upcase
      break if @@markers.include?(answer)
      puts "This marker doesn't exists. Please choose #{@@markers.joinor}"
    end
    answer
  end

  def set_name
    puts "So, what's your name?"
    name = ''

    loop do
      name = gets.chomp.strip
      break unless name.empty?
      puts "Sorry, you must enter some input"
    end
    name
  end

  def ask_for_number(options)
    puts "Pick one of the following: #{options.joinor}"
  end

  def get_valid_number(options)
    loop do
      result = gets.chomp.to_i
      return result if options.include?(result)
      puts "Invalid input! Please enter #{options.joinor}"
    end
  end
end

class Computer < Player
  NAMES = ['R2D2', 'JJ', 'John', 'Lucy'].freeze

  def initialize
    @name = NAMES.sample
    marker = @@markers.pop
    super(marker)
  end

  def pick_move(board)

    square = board.find_square(marker)          # Winning move
    return square unless !square

    square = board.find_square(opposing_marker) # Saving move
    return square unless !square

    square = board.strategic_move               # Strategic move
    return square unless !square

    board.unmarked_squares.sample               # Random move
  end
end

class TTTEngine
  @@markers = ['X', 'O']
  MAX_SCORE = 3

  attr_reader :board

  def initialize
    @board = Board.new
    @players = { human: Human.new, computer: Computer.new }
    make_adversaries(@players[:human], @players[:computer])

    @current_player = random_player
    @round_winner
  end

  def play_game
    display_welcome_message
    loop do
      while @players[:human].score < MAX_SCORE &&
            @players[:computer].score < MAX_SCORE
        clear_screen_and_display_board
        play_round
        reset_round
      end
      display_end_game_message
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end

  private

  def make_adversaries(player1, player2)
    player1.opposing_marker = player2.marker
    player2.opposing_marker = player1.marker
  end

  def random_player
    @players[@players.keys.sample]
  end

  def make_move
    square_number = @current_player.pick_move(board)
    board[square_number] = @current_player.marker
  end

  def display_end_game_message
    game_winner = determine_game_winner
    puts "#{game_winner} won the game!"
  end

  def determine_game_winner
    @players.values.find { |player| player.score >= MAX_SCORE }.name
  end

  def reset_game
    @players.each { |_, player| player.score = 0 }
  end

  def play_round
    loop do
      make_move
      clear_screen_and_display_board
      break if board.player_won?(@current_player.marker) || board.full?
      next_player
    end
    conclude_round
  end

  def clear
    system 'cls'
  end

  def reset_round
    prompt_for_next_round
    board.reset
    @current_player = random_player
    clear
  end

  def prompt_for_next_round
    puts "Enter any key when you're ready to continue"
    gets.chomp
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    answer = ''

    loop do
      answer = gets.chomp.downcase
      break if %w(y n yes no).include?(answer)
      puts "Sorry. Invalid input"
    end

    answer == 'y' || answer == 'yes'
  end

  def conclude_round
    @round_winner = determine_round_winner
    @round_winner.score += 1 if !!@round_winner

    clear_screen_and_display_board
    display_result
  end

  def determine_round_winner
    @players.each do |_, player|
      return player if board.winning_marker == player.marker
    end
    nil
  end

  def display_result
    puts !!@round_winner ? "#{@round_winner.name} won!" : "It's a tie!"
  end

  def display_welcome_message
    clear
    puts "Welcome to Tic-Tac-Toe! Enter any key to start playing"
    gets.chomp
  end

  def display_goodbye_message
    puts "Thanks for playing Tic-Tac-Toe!"
    puts
  end

  def next_player
    @current_player = if @current_player == @players[:human]
                        @players[:computer]
                      else
                        @players[:human]
                      end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_names
    puts "#{@players[:human].name} is the #{@players[:human].marker}. "\
      "#{@players[:computer].name} is the #{@players[:computer].marker}"
  end

  def display_scores
    puts "#{@players[:human].name}'s Score: #{@players[:human].score}"
    puts "#{@players[:computer].name}'s Score: #{@players[:computer].score}"
  end

  def display_board
    display_names
    puts
    display_scores
    puts
    board.draw
    puts
  end
end

game = TTTEngine.new
game.play_game
