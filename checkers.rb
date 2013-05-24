require_relative "piece.rb"
require_relative "board.rb"
require_relative "human.rb"

class Checkers

  def human_v_human
    @player1 = Human.new(:red)
    @player2 = Human.new(:black)
    @board = Board.new
    play_loop
  end

  def play_loop
    player = @player1
    @board.make_board

    until @board.game_over?
      begin
        @board.display
        puts "#{player.color.to_s.capitalize}, move!"        
        move = player.get_move
        
        rest = move[1..-1]
        to = []
        rest.each do |move|
          to << move
        end

        @board.perform_moves(player.color, move[0], to)
        player = switch_players(player)
      rescue InvalidMoveError => e
        puts e.message
        retry
      end
    end
    puts "Game Over!"
  end

  def switch_players(player)
    player == @player1 ? player = @player2 : player = @player1
  end
end

a = Checkers.new
a.human_v_human

#need to interpret "to" into array of arrays?

# b = Board.new

# b[3,4] = Piece.new(:red, [3,4], b)
# b[2,5] = Piece.new(:black, [2,5], b)
# b[2,5].is_king = true

# b[5,2] = Piece.new(:red, [5,2], b)
# b[5,4] = Piece.new(:red, [5,4], b)
# b[4,3] = Piece.new(:black, [4,3], b)

# b[1,2] = Piece.new(:black, [1,2], b)

# b.display
# p b.game_over?



# b.display

# p b[3,2].possible_moves
# p b[4,3].possible_moves


