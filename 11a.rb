code = [3,8,1005,8,290,1106,0,11,0,0,0,104,1,104,0,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,28,1006,0,59,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,53,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,101,0,8,76,1006,0,81,1,1005,2,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,1002,8,1,105,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,126,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,148,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1001,8,0,171,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,193,1,1008,8,10,1,106,3,10,1006,0,18,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,225,1,1009,9,10,1006,0,92,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,254,2,1001,8,10,1,106,11,10,2,102,13,10,1006,0,78,101,1,9,9,1007,9,987,10,1005,10,15,99,109,612,104,0,104,1,21102,1,825594852136,1,21101,0,307,0,1106,0,411,21101,0,825326580628,1,21101,0,318,0,1105,1,411,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21102,179557207043,1,1,21101,0,365,0,1106,0,411,21101,0,46213012483,1,21102,376,1,0,1106,0,411,3,10,104,0,104,0,3,10,104,0,104,0,21101,988648727316,0,1,21102,399,1,0,1105,1,411,21102,988224959252,1,1,21101,0,410,0,1106,0,411,99,109,2,21201,-1,0,1,21101,0,40,2,21102,1,442,3,21101,432,0,0,1105,1,475,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,437,438,453,4,0,1001,437,1,437,108,4,437,10,1006,10,469,1102,0,1,437,109,-2,2105,1,0,0,109,4,2102,1,-1,474,1207,-3,0,10,1006,10,492,21101,0,0,-3,21202,-3,1,1,22102,1,-2,2,21101,0,1,3,21102,511,1,0,1105,1,516,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,539,2207,-4,-2,10,1006,10,539,21201,-4,0,-4,1106,0,607,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21101,558,0,0,1106,0,516,22101,0,1,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,577,21102,1,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,599,21201,-1,0,1,21101,0,599,0,105,1,474,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0]
DEBUG = false

def vm(code, initial = nil)
  Fiber.new do |input|
    mem = code.dup

    pc = 0
    rb = 0

    # op    operands  immed? 
    ops = {
      1   => ["RRW" ,  "[->C] = A + B"],
      2   => ["RRW" ,  "[->C] = A * B"],
      3   => ["W"   ,  "A = input"],
      4   => ["R"   ,  "output A"],
      5   => ["RR"  ,  "jmp B if A != 0"],
      6   => ["RR"  ,  "jmp B if A == 0"],
      7   => ["RRW" ,  "[->C] = A < B ? 1 : 0"],
      8   => ["RRW" ,  "[->C] = A == B ? 1 : 0"],
      9   => ["R"   ,  "rb += A"],
      99  => [""    ,  "halt"]
    }

    loop do
      opcode = mem[pc]
      op = opcode % 100

      raise "Unsupported opcode #{op}" unless ops[op]

      os = mem[pc + 1, ops[op][0].length]     # Get operands
      oos = os.dup

      # Sort out operands and their modes
      modes = (opcode / 100).digits
      os.map!.with_index { |o, i|
        # If this operand has "relative" mode, add the relative base to it
        o += rb if modes[i] == 2

        # If we're in "immediate" mode OR this is a write-to operand, return the immediate value
        next o if modes[i] == 1 || ops[op][0][i] == 'W'
        
        # Otherwise return what's at the memory position requested (initialize to 0 if it doesn't exist yet)
        mem[o] ||= 0
      }

      if DEBUG
        description = ops[op][1].gsub(/A|B|C/) { |l| os[l.ord - 65] }
        puts "#{pc.to_s.rjust(4)}: Running #{opcode.to_s.rjust(6)} opcode #{op.to_s.rjust(2)} | #{description.ljust(30)} | oos: #{oos.inspect} | os: #{os.inspect}"
      end
      
      pc += ops[op][0].length + 1             # Advance program counter


      mem[os[2]] ||= 0 if os[2]

      case op
      when 1  # addition        
        mem[os[2]] = os[0] + os[1]
      when 2  # multiply
        mem[os[2]] = os[0] * os[1]
      when 3  # get input
        mem[os[0]] = input || Fiber.yield(:waiting)
        input = nil
      when 4  # return output
        Fiber.yield os[0]
      when 5  # jump-if-true
        pc = os[1] if os[0] != 0
      when 6  # jump-if-false
        pc = os[1] if os[0] == 0
      when 7  # less than
        mem[os[2]] = os[0] < os[1] ? 1 : 0
      when 8  # equals
        mem[os[2]] = os[0] == os[1] ? 1 : 0
      when 9  # adjust relative base
        rb += os[0]
      when 99 # halt
        break :halt
      else
        raise "Unsupported opcode #{op}"
      end
    end
  end.tap { |vm| vm.resume(initial) if initial }
end

ship = Array.new(100) { Array.new(100) { nil } }
rx = 50
ry = 50
rd = 0   # 0 up, 1, right, 2 down, 3 left

ship[ry][rx] = 1

vm = vm(code)

puts "Program starting"
input = nil
state = :wait

loop do
  if input
    i = vm.resume(input)
    input = nil
  else
    i = vm.resume
  end

  puts "Output #{i}"

  if !i.is_a?(Symbol)
    if i.to_i > -1 && state == :paint
      puts "Painting [#{rx},#{ry}] to #{i}"
      ship[ry][rx] = i
      state = :turn
    elsif i.to_i > -1 && state == :turn
      rd += i == 1 ? 1 : -1
      rd %= 4
      puts "Turning robot #{i} (0 = left, 1 = right) - now facing #{rd}"
      rx += [0, 1, 0, -1][rd]
      ry += [-1, 0, 1, 0][rd]
      state = :wait
    end
  end

  break if i == :halt
  if i == :waiting
    puts "Inputting ship[#{rx},#{ry}] == #{ship[ry][rx]}"
    ship_color = ship[ry][rx]
    input = ship_color == nil ? 0 : ship_color
    state = :paint
  end
end

puts "Program ended"

puts ship.inject(0) { |a, b| a + b.count(0) + b.count(1) }

puts ship.map { |row| row.map { |el| el == 1 ? 'X' : ' ' }.join }.join("\n")