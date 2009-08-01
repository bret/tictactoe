module TicTacToe

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
    # Returns the dimensions of the line through the row
    def line cell_size
      case type 
      when :across:
        row = cells[0][1]
        top = y2 = (0.5 + row) * cell_size
        left = 0.25 * cell_size
        x2 = 2.75 * cell_size
      end
      [left, top, x2, y2]
    end
  end

  class Board
    across = (0..2).map{|y| Row.new((0..2).map{|x| [x, y]}, :across)}
    down = (0..2).map{|x| Row.new((0..2).map{|y| [x, y]}, :down)}
    diagonal = [[[0,0], [1,1], [2,2]], [[0,2], [1,1], [2,0]]].map do |cells| 
      Row.new(cells, :diagonal)
    end
    @@rows = across + down + diagonal
    def initialize
      @cells = Array.new(3) {Array.new(3)}
    end
    def each
      @cells.each_with_index do |row, y|
        row.each_with_index do |contents, x|
          yield x, y, contents
        end
      end
    end
    def [] x, y
      @cells[y][x]
    end
    def []= x, y, value
      @cells[y][x] = value
    end
    def display_string_with separator
      display = {:x => 'X', :o => 'O', nil => '.'}
      result = ""
      @cells.each do | row |
        row.each do | value |
          result += display[value]
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
  end

  class Game
    attr_reader :whose_turn, :board
    def initialize
      @whose_turn = :x
      @board = Board.new
    end
    def play player, x, y
      raise NotYourTurn unless whose_turn == player
      raise SpaceNotEmpty unless board[x, y].nil?
      @board[x, y] = player
      @whose_turn = other_player
    end
    def other_player
      case @whose_turn
      when :x: :o
      when :o: :x
      end
    end
  end

  class NotYourTurn < Exception; end
  class SpaceNotEmpty < Exception; end
end
