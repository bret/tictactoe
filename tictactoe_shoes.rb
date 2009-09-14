require 'tictactoe'

Shoes.app do

  def new_game
    @game = TicTacToe::Game.new
    display
  end

  def display
    clear do
      stack do
        display_board
        button "New Game" do
          new_game
        end
        if @game.result
          para @game.result
        else
          para "Turn: #{TicTacToe::Player.display(@game.whose_turn)}"
        end
        if @last_move
          para "Move: #{@last_move.x}, #{@last_move.y}"
        end
      end
    end
  end

  def draw_stroke x1, y1, x2, y2
    dx = x2 <=> x1
    dy = y2 <=> y1
    animation = animate 36 do | frame |
      strokewidth 3
      # Note: multiplier (i.e. 5) must be a factor of the total length
      xz = x1 + frame*5*dx
      yz = y1 + frame*5*dy
      line x1, y1, xz, yz
      animation.stop if xz == x2 && yz == y2
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
    image :width => 60, :height => 60 do
      strokewidth 2
      fill white
      rect 0, 0, 60, 60
      render_o if @game.board[x, y] == :o
      render_x if @game.board[x, y] == :x
      click {click_cell x, y}
    end
  end

  def render_x
    line 15, 15, 45, 45
    line 45, 15, 15, 45
  end

  def render_o
    oval :radius => 15, :top => 15, :left => 15, :hidden => true
  end

  def click_cell x, y
    @last_move = TicTacToe::Position.new x, y
    @message = nil
    begin 
      player = @game.whose_turn
      @game.play player, x, y
    rescue TicTacToe::SpaceNotEmpty
    rescue TicTacToe::GameOver
    end
    if @game.winning_row
      draw_stroke *(@game.winning_row.line(60))
    end
    display
  end

  new_game
end
