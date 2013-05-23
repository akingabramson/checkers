require_relative "piece.rb"

class Board
  attr_accessor :rows

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

end



b = Board.new
b.make_board
b.display
p b[2,1].possible_slides
