code = [3,8,1001,8,10,8,105,1,0,0,21,34,43,64,85,98,179,260,341,422,99999,3,9,1001,9,3,9,102,3,9,9,4,9,99,3,9,102,5,9,9,4,9,99,3,9,1001,9,2,9,1002,9,4,9,1001,9,3,9,1002,9,4,9,4,9,99,3,9,1001,9,3,9,102,3,9,9,101,4,9,9,102,3,9,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99]

def vm(code, initial = nil)
  Fiber.new do |input|
    mem = code.dup
    pc = 0

    # op    operands  immed? 
    ops = {
      1   => ["RRW" , true],
      2   => ["RRW" , true],
      3   => ["W"   , false],
      4   => ["R"   , false],
      5   => ["RR"  , true],
      6   => ["RR"  , true],
      7   => ["RRW" , true],
      8   => ["RRW" , true],
      99  => [""    , false]
    }

    loop do
      opcode = mem[pc]
      op = opcode % 100
      os = mem[pc + 1, ops[op][0].length]     # Get operands

      # If the operand supports immediate mode..
      if ops[op][1]
        modes = (opcode / 100).digits
        os.map!.with_index { |o, i| modes[i] == 1 || ops[op][0][i] == 'W' ? o : mem[o] }
      end
      
      pc += ops[op][0].length + 1             # Advance program counter

      case op
      when 1  # addition
        mem[os[2]] = os[0] + os[1]
      when 2  # multiply
        mem[os[2]] = os[0] * os[1]
      when 3  # get input
        mem[os[0]] = input || Fiber.yield(:waiting)
        input = nil
      when 4  # return output
        Fiber.yield mem[os[0]]
      when 5  # jump-if-true
        pc = os[1] if os[0] != 0
      when 6  # jump-if-false
        pc = os[1] if os[0] == 0
      when 7  # less than
        mem[os[2]] = os[0] < os[1] ? 1 : 0
      when 8  # equals
        mem[os[2]] = os[0] == os[1] ? 1 : 0
      when 99 # halt
        break :halt
      else
        raise "Unsupported opcode #{op}"
      end
    end
  end.tap { |vm| vm.resume(initial) if initial }
end

p [5, 6, 7, 8, 9].to_a.permutation.map { |ss|
  puts "DOING PERMUTATION #{ss.inspect}"

  # Create VMs
  vms = ss.map { |i| vm(code, i) }

  # Loop around the VMs, feeding the outputs from one to the other
  vms.cycle.each.with_index.inject(0) do |i, (vm, idx)| 
    i = vm.resume(i)                            # Pass input
    j = vm.resume until j.is_a?(Symbol)         # Let the VM keep running until it's next ready for input
    break i if (idx % 5) == 4 && j == :halt     # When the final VM halts, out we go
    next i
  end
}.max
