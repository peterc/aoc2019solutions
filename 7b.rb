mem = [3,8,1001,8,10,8,105,1,0,0,21,34,43,64,85,98,179,260,341,422,99999,3,9,1001,9,3,9,102,3,9,9,4,9,99,3,9,102,5,9,9,4,9,99,3,9,1001,9,2,9,1002,9,4,9,1001,9,3,9,1002,9,4,9,4,9,99,3,9,1001,9,3,9,102,3,9,9,101,4,9,9,102,3,9,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99]

def vm(mem)
  Fiber.new do
    mem = mem.dup
    pc = 0

    loop do
      opcode, o1, o2, o3 = mem[pc, 4]

      #puts "Running #{opcode}"

      op = opcode % 100
      modes = (opcode / 100).digits

      v1 = modes[0] == 1 ? o1 : mem[o1] if [1, 2, 5, 6, 7, 8].include?(op)
      v2 = modes[1] == 1 ? o2 : mem[o2] if [1, 2, 5, 6, 7, 8].include?(op)

      if op == 1     # addition
        mem[o3] = v1 + v2
        pc += 4
      elsif op == 2  # multiply
        mem[o3] = v1 * v2
        pc += 4
      elsif op == 3  # get input
        input = Fiber.yield :waiting
        raise unless input.is_a?(Integer)
        mem[o1] = input
        pc += 2
      elsif op == 4  # print output
        puts "OUT: #{mem[o1]}"
        pc += 2
        Fiber.yield mem[o1]
      elsif op == 5  # jump-if-true
        pc = v1 != 0 ? v2 : pc + 3
      elsif op == 6  # jump-if-false
        pc = v1 == 0 ? v2 : pc + 3
      elsif op == 7  # less than
        mem[o3] = v1 < v2 ? 1 : 0
        pc += 4
      elsif op == 8  # equals
        mem[o3] = v1 == v2 ? 1 : 0
        pc += 4
      elsif op == 99
        Fiber.yield :halt
      else
        raise "Unsupported opcode #{op}"
      end
    end
  end
end

p [5, 6, 7, 8, 9].to_a.permutation.map { |ss|
  puts "DOING PERMUTATION #{ss.inspect}"

  vms = ss.map do |i|
    vm = vm(mem)
    vm.resume           # Start the VM
    vm.resume(i)        # Give the initial phase setting
    vm
  end

  i = 0
  val = 0
  vms.cycle.each.with_index do |vm, idx|
    vmid = idx % 5

    i = vm.resume(i)    # Pass input
    vm.resume           # Let the VM keep running until it's next ready for input

    puts "VM #{vmid} returned #{i}"

    val = i if i.is_a?(Integer) && vmid == 4
    break if vmid == 4 && i == :halt
  end

  val
}.max
