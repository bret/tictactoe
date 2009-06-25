require 'tictactoe'

TILE_SIZE = 60
Shoes.app do
  @game = TicTacToe::Game.new
  def board
    @game.board
  end
  def display error = nil
    clear do
      stack do
        button "New Game" do
          @game = TicTacToe::Game.new
          display
        end
        display_board
        para "Turn: #{@game.whose_turn.to_s.upcase}"
        if @last_move
          @move = para "Move: #{@last_move[0]}, #{@last_move[1]}"
        end
        @error = para error
      end
    end
  end
  def display_board
    (0..2).each do |y|
      flow do    
        (0..2).each do |x|
          render_cell x, y
        end
      end
    end
  end
  def render_cell x, y
    image :width => TILE_SIZE, :height => TILE_SIZE do
      strokewidth 2
      fill white
      rect 0,0,TILE_SIZE, TILE_SIZE
      render_o if board[x, y] == :o
      render_x if board[x, y] == :x
      click do 
        @last_move = [x, y]
        error_message = nil
        begin 
          @game.play @game.whose_turn, x, y
        rescue TicTacToe::SpaceNotEmpty => e
          error_message = e.message
        end
        display error_message
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
  display
end
