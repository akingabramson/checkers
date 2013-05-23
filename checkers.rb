require_relative "piece.rb"

class Checkers
  
  def initialize
    @colors = [:black, :red]
  end

  def human_v_human
    @player1 = Human.new
    @player2 = Human.new
    @board = Board.new
    play_loop
  end

  def play_loop
    until @board.game_over?
    end
  end

end


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
        cloned_board[row_num, col_num].location = [row_num, col_num]
        cloned_board[row_num, col_num].board = cloned_board
      end
    end
        
    cloned_board
  end

  #begin rescue end should really be in game loop
  def perform_moves(from, *to)
    fake_board = self.deep_dup
    begin 
      fake_board.do_each_move(from, to)
      do_each_move(from, to)      
    rescue InvalidMoveError => e
      puts e.message
    end
  end


  def do_each_move(from, to)
    can_slide = true
    to.each do |to_move|
      perform_moves!(from, to_move, can_slide)
      from = to_move
      can_slide = false
    end

    unless self[from[0], from[1]].add_jumps.empty?
      raise InvalidMoveError.new("You didn't go far enough!")
    end
  end

  def perform_moves!(from, to, can_slide)
    from_row, from_col = from
    to_row, to_col = to

    if !self[from_row, from_col].possible_moves.include?(to)
      raise InvalidMoveError.new("Can't move to #{to}!")
    end

    if self[from_row, from_col].add_jumps.include?(to)
      perform_jump(from_row, from_col, to_row, to_col)         
    else
      if can_slide
        move_piece(from_row, from_col, to_row, to_col)
      else
        raise InvalidMoveError.new("Can't slide after you've jumped!")
      end
    end

    if (to_row == 0||to_row == 7) && !self[to_row, to_col].is_king
      self[to_row, to_col].is_king = true
    end
  end

  def perform_jump(from_row, from_col, to_row, to_col)
    self[((from_row + to_row) / 2), ((from_col + to_col) / 2)] = nil
    puts "Jump! [#{from_row},#{from_col}] to [#{to_row}, #{to_col}]"
    move_piece(from_row, from_col, to_row, to_col) 
  end

  def move_piece(from_row, from_col, to_row, to_col)
    self[to_row, to_col] = self[from_row, from_col]
    self[to_row, to_col].location = [to_row, to_col]
    self[from_row, from_col] = nil
  end

  def game_over?
    reds = false
    blacks = false
    @rows.each_with_index do |row, row_num|
      row.each_with_index do |col, col_num|
        next unless col
        if col.color == :red
          reds = true
        else
          blacks = true
        end
    end

    if reds == false || blacks == false
      return true
    else
      false
    end
  end

end


#need to interpret "to" into array of arrays?

b = Board.new

b[3,4] = Piece.new(:red, [3,4], b)
b[2,5] = Piece.new(:black, [2,5], b)
b[2,5].is_king = true

b[5,2] = Piece.new(:red, [5,2], b)
b[5,4] = Piece.new(:red, [5,4], b)
b[4,3] = Piece.new(:black, [4,3], b)

b[1,2] = Piece.new(:black, [1,2], b)

b.display
b.perform_moves([4,3],[6,1])
p b.game_over?



# b.display

# p b[3,2].possible_moves
# p b[4,3].possible_moves


