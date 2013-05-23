require 'colored'


class Piece
  attr_accessor :color, :is_king, :location

  DIRECTIONS = {
    :black => 1,
    :red => -1
  }
  SLIDE_TRANSFORMS = [[1, 1], [1, -1]]

  KING_SLIDE_TRANSFORMS = [
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ]

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

  def possible_slides
    possible_slides = []
    row, col = @location
    unless @is_king == true
      possible_slides += add_slide(SLIDE_TRANSFORMS, row, col)
    else
      possible_slides += add_slide(KING_SLIDE_TRANSFORMS, row, col)
    end
    possible_slides
  end

  def add_slide(constant, row, col)
    slides = []
    constant.each do |transform|
      drow = transform[0]*DIRECTIONS[@color]
      dcol = transform[1]
      
      new_loc = [(row + drow), (col + dcol)]
      if @board[(row + drow), (col + dcol)].nil?
        slides << new_loc
      end
    end
    slides
  end

  def possible_jumps

  end
  #takes in from array and to array

end

