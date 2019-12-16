class VM
  attr_reader :mem, :pc, :rb
  attr_accessor :debug

  def initialize(mem, pc = nil, rb = nil)
    @mem = mem.dup
    @vm = vm
    @pc = pc || 0
    @rb = rb || 0
    @finished = false
  end

  def state
    "cs: #{@mem.compact.sum} pc: #{@pc} rb: #{@rb}"
  end

  def copy
    VM.new(@mem, @pc, @rb)
  end

  def snapshot
    @snapshot_mem = @mem.dup
    @snapshot_pc = @pc
    @snapshot_rb = @rb
  end

  def rollback
    @pc = @snapshot_pc
    @mem = @snapshot_mem.dup
    @rb = @snapshot_rb
    @finished = false
    @vm = vm
  end

  def run(input = nil)
    return :finished if @finished
    if input
      @vm.resume(input)
    else
      @vm.resume
    end
  end

  def vm
    Fiber.new do |input|
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

      #puts "pc: #{@pc}"

      loop do
        opcode = @mem[@pc]
        op = opcode % 100

        raise "Unsupported opcode #{op}" unless ops[op]

        os = @mem[@pc + 1, ops[op][0].length]     # Get operands
        oos = os.dup

        # Sort out operands and their modes
        modes = (opcode / 100).digits
        os.map!.with_index { |o, i|
          # If this operand has "relative" mode, add the relative base to it
          o += @rb if modes[i] == 2

          # If we're in "immediate" mode OR this is a write-to operand, return the immediate value
          next o if modes[i] == 1 || ops[op][0][i] == 'W'
          
          # Otherwise return what's at the memory position requested (initialize to 0 if it doesn't exist yet)
          @mem[o] ||= 0
        }

        if self.debug
          description = ops[op][1].gsub(/A|B|C/) { |l| os[l.ord - 65] }
          puts "#{@pc.to_s.rjust(4)}: Running #{opcode.to_s.rjust(6)} opcode #{op.to_s.rjust(2)} | #{description.ljust(30)} | oos: #{oos.inspect} | os: #{os.inspect}"
        end
        
        @pc += ops[op][0].length + 1             # Advance program counter

        @mem[os[2]] ||= 0 if os[2]

        case op
        when 1  # addition        
          @mem[os[2]] = os[0] + os[1]
        when 2  # multiply
          @mem[os[2]] = os[0] * os[1]
        when 3  # get input
          @mem[os[0]] = Fiber.yield(:waiting)
          #input = nil
        when 4  # return output
          Fiber.yield os[0]
        when 5  # jump-if-true
          @pc = os[1] if os[0] != 0
        when 6  # jump-if-false
          @pc = os[1] if os[0] == 0
        when 7  # less than
          @mem[os[2]] = os[0] < os[1] ? 1 : 0
        when 8  # equals
          @mem[os[2]] = os[0] == os[1] ? 1 : 0
        when 9  # adjust relative base
          @rb += os[0]
        when 99 # halt
          break :halt
        else
          raise "Unsupported opcode #{op}"
        end
      end
      @finished = true
    end
  end
end