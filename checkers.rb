require_relative "piece.rb"

class Board
  attr_accessor :rows

  class InvalidMoveError < ArgumentError
  end

  def initialize(rows = 8)
    @rows = Array.new(rows) {Array.new(rows)}
    nil
  end

  def make_board
    rows1 = [1, 5, 7]
    rows2 = [0, 2, 6]

    @rows.each_with_index do |row, row_num|
      if rows1.include?(row_num)
        set_every_other(row, row_num, 0)
      elsif rows2.include?(row_num)
        set_every_other(row, row_num, 1)
      end
    end
  end

  def set_every_other(row, row_num, remainder)
    if row_num < 4
      row.each_with_index do |square, col_num|
        if col_num % 2 == remainder
          self[row_num, col_num] = Piece.new(:black, [row_num, col_num], self)
        end
      end
    else
      row.each_with_index do |square, col_num|
        if col_num % 2 == remainder
          self[row_num, col_num] = Piece.new(:red, [row_num, col_num], self)
        end
      end
    end
  end


  def [](row, col)
    @rows[row][col]
  end

  def []= (x, y, piece)
    @rows[x][y] = piece
  end

  def top_row
    print "   0 1 2 3 4 5 6 7\n"
  end

  def display
    top_row
    @rows.each_with_index do |row, row_num|
      print "#{row_num}: "
      row.each_with_index do |square, col_num|
        if (row_num - col_num).abs.odd?
          if square
            print "#{square}".black_on_blue
          else
            print " ".black_on_blue
          end
          print " "
        else
          print "  "
        end
      end
      puts " "
    end
    top_row
    nil
  end

  def on_board?(location)
    if location.any? {|loc| !(0..8).include?(loc)}
      return false
    else
      true
    end
  end

  def rows
    @rows.map(&:dup)
  end

  def deep_dup
    cloned_board = Board.new(rows)

    cloned_board.rows.each_with_index do |row, row_num|
      row.each_with_index do |piece, col_num|
        next if piece.nil?
        cloned_board[row_num, col_num] = piece.clone
        cloned_board[row_num, col_num].location = piece.location.clone
        cloned_board[row_num, col_num].board = cloned_board
      end
    end
        
    cloned_board
  end

  def perform_moves!(from, *to)
    from_row, from_col = from

    to.each do |to_loc|
      to_row, to_col = to_loc
      if !self[from_row, from_col].possible_moves.include?(to_loc)
        raise InvalidMoveError.new("Can't move there!")
        break
      else
        if self[from_row, from_col].add_jumps.include?(to_loc)
          self[((from_row + to_row) / 2), ((from_col + to_col) / 2)] = nil
        end
        self[to_row, to_col] = self[from_row, from_col]
        self[to_row, to_col].location = to_loc
        self[from_row, from_col] = nil
        from_row, from_col = to_loc
      end
    end

    unless self[from_row, from_col].add_jumps.empty?
      raise InvalidMoveError.new("You didn't go far enough!")
    end

    #check to to make sure it's the end of the road
  end

end


#need to interpret "to" into array of arrays?

b = Board.new

b[3,4] = Piece.new(:red, [3,4], b)
b[2,5] = Piece.new(:black, [2,5], b)
b[5,2] = Piece.new(:red, [5,2], b)
b[1,2] = Piece.new(:black, [1,2], b)

b.display

b.perform_moves!([2,5],[4,3],[6,1])
b.display




# b.display

# p b[3,2].possible_moves
# p b[4,3].possible_moves


