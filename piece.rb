require 'colored'


class Piece
  attr_accessor :color, :is_king, :location

  SLIDE_TRANSFORMS = [
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

    SLIDE_TRANSFORMS.each do |transform|
      drow, dcol = transform
      new_loc = [(row + drow), (col + dcol)]
      if @board[(row + drow), (col + dcol)].nil?
        possible_slides << new_loc
      end
    end
    possible_slides
  end

  def possible_jumps

  end
  #takes in from array and to array

end

