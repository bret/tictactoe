require 'tictactoe'

Shoes.app do
  def new_game
    @game = TicTacToe::Game.new
    display
  end
  def display
    clear do
      stack do
        button "New Game" do
          new_game
        end
        display_board
        para "Turn: #{@game.whose_turn.to_s.upcase}"
        if @last_move
          para "Move: #{@last_move.x}, #{@last_move.y}"
        end
        if @message
          para @message
        end
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
    rescue TicTacToe::SpaceNotEmpty => e
      @message = e.message
    end
    if @game.over?
      @message = @game.result
    end
    display
  end
  new_game
end
