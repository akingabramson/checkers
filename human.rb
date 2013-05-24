

class Human
  
  attr_reader :color

  class InvalidEntryError < ArgumentError
  end

  def initialize(color)
    @color = color
  end

  def get_move
    puts "Pick a from location and a to chain.  Format with space in between."
    puts "e.g.: 01 23 45"
    begin
      input = gets.chomp
      process_move(input)
    rescue InvalidEntryError => e
      puts e.message
      retry
    end

  end

  def process_move(input)
    if input.include?("8") || input.include?("9")
      raise InvalidEntryError.new("Must input rows on the board")
    end

    if !input.include?(" ")
      raise InvalidEntryError.new("Must include a space.")
    end

    final_move = []

    moves = input.strip.split(" ")

    moves.each do |move|
      if move.length < 2
        raise InvalidEntryError.new("Must input in clumps of 2")
      end
      if move =~ /\D/
        raise InvalidEntryError.new("Must input numbers")
      end

      final_move << [move[0].to_i, move[1].to_i]
    end
    final_move
  end

  #can't move other team's color
end
