def pattern(offset)
  pattern =  [0] * offset +
             [1] * offset +
             [0] * offset +
            [-1] * offset

  pattern = pattern.cycle
  pattern.next
  pattern
end

digits = 20

digits.times do |i|
  pattern = pattern(i + 1)
  puts "#{i.to_s.rjust(3)}-" + digits.times.map { pattern.next.to_s.rjust(2) }.join(",")
end