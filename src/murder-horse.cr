require "./murder-horse/*"

module Murder::Horse
  extend self

  private BOARDSIZE = 8

  struct Position
    property x, y

    def initialize(@x : Int32, @y : Int32)
    end

    private struct Vector
      property x, y

      def initialize(@x : Int32, @y : Int32)
      end
    end

    private TRANSITIONS = {Vector.new(2, 1), Vector.new(2, -1), Vector.new(1, -2), Vector.new(-1, -2),
                           Vector.new(-2, -1), Vector.new(-2, 1), Vector.new(-1, 2), Vector.new(1, 2)}

    def next_move_optimised
      self.next_move
          .sort { |a, b| a.next_move.size - b.next_move.size }
    end

    def next_move
      is_move_valid = ->(p : Position) { p.x >= 0 && p.x < BOARDSIZE && p.y >= 0 && p.y < BOARDSIZE }
      TRANSITIONS.map { |v| Position.new(@x + v.x, @y + v.y) }
                 .select(&is_move_valid)
    end
  end

  def find_solutions(p)
    find_solution_rec(p, Set(Position).new, [] of Position)
  end

  private def find_solution_rec(p, visited, path)
    is_complete = ->(p : Array(Position)) { p.size == BOARDSIZE*BOARDSIZE }

    visited.add(p)
    path.push(p)

    if is_complete.call(path)
      return {true, path}
    end

    p.next_move_optimised.select { |a| !visited.includes?(a) }.each do |a|
      success, result = find_solution_rec(a, visited, path)
      if success
        return {true, result}
      end
    end
    path.pop
    visited.delete(p)
    {false, [] of Position}
  end
end

def tester(i : (Int32 | String))
  result = case i
           when Int32
             "number"
           end
  result
end

puts tester("gekki")
puts tester(1234)

include Murder::Horse
require "kemal"
require "json"

get "/solution" do |env|
  env.response.content_type = "application/json"
  _, result = find_solutions(Position.new(0, 0))
  {solution: result.map { |p| {x: p.x, y: p.y} }}.to_json
end

get "/" do |env|
  env.response.status_code = 404
end

Kemal.run
