part_a = 0
part_b = 0

0.upto(999999) do |n|
  str = sprintf("%06d", n)

  double_digit = str =~ /(\d)\1/
  double_digit_only = str.scan(/(\d)\1/).flatten.uniq.select { |digit| str.count(digit) == 2 }.any?

  pc = '0'
  never_decreasing = true

  str.each_char do |c|
    if c < pc
      never_decreasing = false
      break
    end
    pc = c
  end

  if (382345..843167).include?(n) && never_decreasing
    part_a += 1 if double_digit
    part_b += 1 if double_digit_only
  end
end

puts part_a
puts part_b
