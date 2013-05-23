require 'colored'


class Piece
  attr_accessor :color, :is_king, :location

  #make transformers constant

  def initialize(color, location)
    @color = color
    @location = location
    @is_king = false
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

  

end

