require 'tictactoe'

Spec::Matchers.define :look_like do |string|
  match do |board|
    string.remove_spaces!
    board.inspect == string
  end
end

class String
  def remove_spaces!
    self.gsub!(/ /, '')
  end
end

module TicTacToe
  describe Position do
    before {@position = Position.new 1, 2}
    it "should have an x and a y" do
      @position.x.should == 1
      @position.y.should == 2
    end
  end
  describe Board do
    before {@board = Board.new}
    it "should have nine cells" do
      count = 0
      @board.each {count += 1}
      count.should == 9
    end
    it "should allow you to access each cell's contents" do
      @board.each {|x, y, contents| contents.should == nil}
    end
    it "should allow you to access each cell's position" do
      positions = []
      @board.each {|x, y, contents| positions << [x, y]}
      require 'facets'
      expected = (0..2).to_a.product((0..2))
      positions.should include(*expected)
      positions.should have(9).items
    end
    it "should be able to create a board using a string" do
      @board = setup_board <<-END
        X..
        .X.
        ..X
      END
      @board.should look_like(<<-END)
        X..
        .X.
        ..X
      END
    end
    def setup_board string
      board = Board.new
      string.remove_spaces!
      board
    end
    class Board
      def should_look_like string
        string.remove_spaces!
        display_string_with("\n").should == string
      end
    end
    it "should be able to detect three-in-a-row" do
      @board = setup_board <<-END
        ...
        ...
        ...
      END
      @board.should be_three_in_a_row
    end
  end
  describe Game do
    before {@game = Game.new}
    def board_should_be string
      string.remove_spaces!
      @game.board.display_string_with("\n").should == string
    end
    it "should have a board" do
      @game.board.should be_a(Board)
    end
    it "should allow you to make a move (center)" do
      @game.play :x, 1, 1
      @game.board[1, 1].should == :x
      board_should_be <<-END
        ...
        .X.
        ...
      END
    end
    it "should allow you to make a move (corner)" do
      @game.play :x, 0, 2
      @game.board[0, 2].should == :x
      board_should_be <<-END
        ...
        ...
        X..
      END
    end
    it "should alternate turns" do
      @game.play :x, 1, 1
      @game.whose_turn.should == :o
      @game.play :o, 0,0
      @game.whose_turn.should == :x
    end
    it "should not allow you to play when its not your turn" do
      lambda {@game.play :o, 1, 1}.should raise_error(NotYourTurn)
    end
    it "should not allow you to play in a space that is filled" do
      @game.play :x, 1, 1
      lambda {@game.play :o, 1, 1}.should raise_error(SpaceNotEmpty)
    end
    describe "at start" do
      it "should start with X" do
        @game.whose_turn.should == :x
      end
      it "should have a blank board" do
        board_should_be <<-END
          ...
          ...
          ...
        END
      end
    end
  end
end
