module TicTacToe
  class Position
    attr_accessor :x, :y
    def initialize x, y
      @x = x
      @y = y
    end
  end
  class Board
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
    def inspect
      display = {:x => 'X', :o => 'O', nil => '.'}
      result = ""
      @cells.each do | row |
        row.each do | value |
          result += display[value]
        end
        result += "\n"
      end
      result
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
