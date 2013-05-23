require 'colored'
require 'debugger'

class Piece
  attr_accessor :color, :is_king, :location, :board

  DIRECTIONS = {
    :black => 1,
    :red => -1
  }

  SLIDE_TRANSFORMS = [[1, 1], [1, -1]]
  KING_SLIDE_TRANSFORMS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]


  #make transformers constant

  def initialize(color, location, board)
    @color = color
    @location = location
    @is_king = false
    @board = board
  end

  def to_s
    if @color == :red
      if @is_king == true
        "K".red_on_blue
      else
        "\u25CF".red_on_blue
      end
    else
       if @is_king == true
        "K".black_on_blue
      else
        "\u25CF".black_on_blue
      end
    end
  end

  def possible_moves
    possible_moves = []
    row, col = @location
    unless @is_king == true
      possible_moves += add_moves
      possible_moves += add_jumps
    else
      possible_moves += add_moves(KING_SLIDE_TRANSFORMS)
      possible_moves += add_jumps(KING_SLIDE_TRANSFORMS)
    end
    possible_moves
  end

  def add_moves(transforms = SLIDE_TRANSFORMS)
    slides = []
    row, col = @location
    transforms.each do |transform|
      drow = transform[0]*DIRECTIONS[@color]
      dcol = transform[1]

      new_loc = [(row + drow), (col + dcol)]
      if @board[(row + drow), (col + dcol)].nil? && @board.on_board?(new_loc)
        slides << new_loc
      end
    end
    slides
  end

  def add_enemy_spaces(transforms = SLIDE_TRANSFORMS)
    #finds all spaces one away with opposite color

    #when refactoring, I'll try to combine with move_spaces into one method
    slides = []
    row, col = @location

    transforms.each do |transform|
      drow = transform[0]*DIRECTIONS[@color]
      dcol = transform[1]

     new_loc = [(row + drow), (col + dcol)]
      if !@board[(row + drow), (col + dcol)].nil? && @board[(row + drow), (col + dcol)].color != @color
        slides << new_loc
      end
    end
    slides
  end


  def add_jumps(slide_transforms = SLIDE_TRANSFORMS)
    if @is_king
      slide_transforms = KING_SLIDE_TRANSFORMS
    end

    possible_jumps = []
    row, col = @location

    one_aways = add_enemy_spaces(slide_transforms)

    until one_aways.empty?
      one_away = one_aways.shift
      one_row, one_col = one_away
      new_row, new_col = [(2*one_row - row), (2*one_col - col)]
      new_loc = [new_row, new_col]
      #find location behind enemy spot

      #if it's empty and on the board, it's a possible move
      if @board[new_row, new_col].nil? && @board.on_board?([new_row, new_col])
        possible_jumps << new_loc
      end
    end
    possible_jumps
  end


  #takes in from array and to array

end

