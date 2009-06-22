require 'tictactoe'

GAME = TicTacToe::Game.new
BOARD = GAME.board
TILE_SIZE = 60
Shoes.app do
  def display
    clear do
    stack do
      display_board
      para "Turn: #{GAME.whose_turn.to_s.upcase}"
      @move = para "Move: "
      @error = para
    end
    end
  end
  def render_x
    line 15, 15, 45, 45
    line 45, 15, 15, 45
  end
  def render_o
    oval :radius => 15, :top => 15, :left => 15, :hidden => true
  end
  def display_board
    (0..2).each do |y|
      flow do    
        (0..2).each do |x|
          image :width => TILE_SIZE, :height => TILE_SIZE do
            strokewidth 2
            fill white
            rect 0,0,TILE_SIZE, TILE_SIZE
            render_o if BOARD[x, y] == :o
            render_x if BOARD[x, y] == :x
            click do 
              @move.text = "Move: #{x},#{y}"
              begin 
                GAME.play GAME.whose_turn, x, y
              rescue => e
                @error.replace e.message
              end
              display
            end
          end
        end
      end
    end
  end
  display
end
