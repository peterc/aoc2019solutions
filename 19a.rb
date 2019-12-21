# I forgot to keep part 1 separate, so this is just part 2! Part 1 was very easy though.

# My solution is not very efficient CPU wise but it works. It would be better to just keep
# checking the single 'opposite' spot of the spot rather than doing the entire strip each
# time but.. yeah.

require_relative 'vm'

mem = [109,424,203,1,21102,11,1,0,1106,0,282,21101,0,18,0,1106,0,259,1201,1,0,221,203,1,21102,1,31,0,1106,0,282,21101,0,38,0,1106,0,259,20102,1,23,2,21202,1,1,3,21101,1,0,1,21101,0,57,0,1105,1,303,2101,0,1,222,20101,0,221,3,21001,221,0,2,21102,1,259,1,21101,0,80,0,1105,1,225,21101,185,0,2,21102,91,1,0,1106,0,303,1202,1,1,223,21001,222,0,4,21102,259,1,3,21101,225,0,2,21102,1,225,1,21101,0,118,0,1106,0,225,20102,1,222,3,21102,1,131,2,21101,133,0,0,1106,0,303,21202,1,-1,1,22001,223,1,1,21101,148,0,0,1105,1,259,2101,0,1,223,21002,221,1,4,21002,222,1,3,21101,0,16,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21101,0,195,0,106,0,109,20207,1,223,2,20101,0,23,1,21102,1,-1,3,21101,0,214,0,1105,1,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,1201,-4,0,249,22101,0,-3,1,22101,0,-2,2,21201,-1,0,3,21101,0,250,0,1106,0,225,21201,1,0,-4,109,-5,2106,0,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2106,0,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,22102,1,-2,-2,109,-3,2105,1,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,21201,-2,0,3,21101,343,0,0,1106,0,303,1105,1,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,22101,0,-4,1,21102,384,1,0,1106,0,303,1105,1,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,21201,1,0,-4,109,-5,2106,0,0]

vm = VM.new(mem)
vm.snapshot

count = 0
map = Array.new(120) { Array.new(120, 0) }
min_x = 0
max_x = 100
min_y = 0
max_y = 10000
square_needed = 100
DO_MAP = false

min_xs = Array.new(100, 0)
max_xs = Array.new(100, 0)

searching = true

min_y.upto(max_y) do |y|
  found = 0

  min_x.upto(max_x + 10) do |x|
    vm.rollback
    vm.run
    vm.run(x)
    res = vm.run(y)

    if res == 1 && found == 0
      min_x = x
      min_xs[y] = x
      found = 1
    elsif res == 0 && found == 1
      found = 2
      max_x = x - 1
      max_xs[y] = x - 1
    end

    map[y][x] = res if DO_MAP
  end

  if min_x == (max_xs[y - square_needed + 1] - square_needed + 1) && searching
    searching = false
    map[y][min_x] = 2 if DO_MAP
    map[y - square_needed + 1][max_xs[y - square_needed + 1]] = 2 if DO_MAP
    map[y - square_needed + 1][max_xs[y - square_needed + 1] - square_needed + 1] = 2 if DO_MAP
    puts "x = #{max_xs[y - square_needed + 1] - square_needed + 1} y = #{y - square_needed + 1}"
    exit
  end
end

puts map.map { |row| row.map { |c| [' ', '.', 'O'][c] }.join }.join("\n") if DO_MAP