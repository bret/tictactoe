module TicTacToe

  module Player
    def self.display player
      display = {:x => 'X', :o => 'O', nil => '.'}
      display[player]
    end
  end
  
  class Position
    attr_accessor :x, :y
    def initialize x, y
      @x = x
      @y = y
    end
  end

  class Row
    attr_reader :cells, :type
    def initialize cells, type
      @cells = cells
      @type = type
    end
  end

  class AcrossRow < Row
    def initialize y
      super((0..2).map{|x| [x, y]}, :across)
      @row = y
    end
    # Returns the dimensions of the line through the row
    def line cell_size
      top = y2 = (0.5 + @row) * cell_size
      left = 0.25 * cell_size
      x2 = 2.75 * cell_size
      [left, top, x2, y2]
    end
  end

  class DownRow < Row
    def initialize x
      super((0..2).map{|y| [x, y]}, :down)
      @column = x
    end
    # Returns the dimensions of the line through the row
    def line cell_size
      left = x2 = (0.5 + @column) * cell_size
      top = 0.25 * cell_size
      y2 = 2.75 * cell_size
      [left, top, x2, y2]
    end
  end

  class DiagonalRow < Row
    def initialize cells
      super(cells, :diagonal)
    end
  end

  # \
  class BendRow < DiagonalRow
    def initialize
      super [[0,0], [1,1], [2,2]]
    end
    # Returns the dimensions of the line through the row
    def line cell_size
      left = 0.25 * cell_size
      top = 0.25 * cell_size
      x2 = 2.75 * cell_size
      y2 = 2.75 * cell_size
      [left, top, x2, y2]
    end
  end
  
  # /
  class BendSinisterRow < DiagonalRow
    def initialize
      super [[0,2], [1,1], [2,0]]
    end
    # Returns the dimensions of the line through the row
    def line cell_size
      left = 0.25 * cell_size
      top = 2.75 * cell_size
      x2 = 2.75 * cell_size
      y2 = 0.25 * cell_size
      [left, top, x2, y2]
    end
  end

  class Board
    across = (0..2).map{|y| AcrossRow.new y}
    down = (0..2).map{|x| DownRow.new x}
    diagonal = [BendRow.new, BendSinisterRow.new]
    @@rows = across + down + diagonal
    def initialize
      @cells = Array.new(3) {Array.new(3)}
    end
    def each_with_index
      @cells.each_with_index do |row, y|
        row.each_with_index do |contents, x|
          yield x, y, contents
        end
      end
    end
    def each
      each_with_index do | x, y, content |
        yield content
      end
    end
    def [] x, y
      @cells[y][x]
    end
    def []= x, y, value
      @cells[y][x] = value
    end
    def display_string_with separator
      result = ""
      @cells.each do | row |
        row.each do | value |
          result += Player.display(value)
        end
        result += separator
      end
      result
    end
    def inspect
      display_string_with ("/")
    end
    # Is there a three in a row for the player? If so, return the
    # row with the match. If not, return false.
    def three_in_a_row?(player)
      @@rows.detect do | row |
        (0..2).inject(true) {|memo, i| memo && self[*row.cells[i]] == player}
      end
    end
    include Enumerable
    def filled?
      self.inject(true) {|memo, content| memo && !content.nil?}
    end
  end

  class Game
    attr_reader :whose_turn, :result, :winning_row
    attr_accessor :board
    def initialize
      @whose_turn = :x
      @board = Board.new
      @result = nil
    end
    def play player, x, y
      raise GameOver if over?
      raise NotYourTurn unless whose_turn == player
      raise SpaceNotEmpty unless board[x, y].nil?
      @board[x, y] = player
      if @winning_row = @board.three_in_a_row?(player)
        self.result = "Three in a row. #{Player.display(player)} wins."
      elsif @board.filled?
        self.result = "Scratch Game."
      else
        @whose_turn = other_player
      end
    end
    def other_player
      case @whose_turn
      when :x: :o
      when :o: :x
      end
    end
    def result= message
      @result = message
      @whose_turn = nil
    end
    def over?
      !!@result
    end
  end

  class NotYourTurn < Exception; end
  class SpaceNotEmpty < Exception; end
  class GameOver < Exception; end
end
