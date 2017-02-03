SEPERATOR = '+'
LINE = '-'
HORIZ_SPACES = 5
VERTICAL_SPACES = 3

def create_board(dimentions)
  draw_upper_line(dimentions)
  puts
  (dimentions - 2).times do
    draw_middle_line(dimentions)
    puts
  end
  draw_lower_line(dimentions)
end

def draw_upper_line(dimentions)
  draw_left_upper_square(dimentions)
  (dimentions - 2).times do
    draw_middle_upper_square
  end
  draw_right_upper_square
end

def draw_left_upper_square(dimentions)
  draw_vertical_line(dimentions)
end

def draw_vertical_line(dimentions)
  (dimentions).times { puts ' ' * HORIZ_SPACES + '|' }

  #
  # puts ' ' * HORIZ_SPACES + '|' + ' ' * HORIZ_SPACES + '|'
  # puts ' ' * HORIZ_SPACES + '|' + ' ' * HORIZ_SPACES + '|'
  # puts ' ' * HORIZ_SPACES + '|' + ' ' * HORIZ_SPACES + '|'
end

def draw_middle_upper_square; end

def draw_right_upper_square; end

def draw_lower_line(dimentions)

end

def draw_middle_line(dimentions)

end

create_board(3)
