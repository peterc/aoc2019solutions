part_a = 0
part_b = 0

382345.upto(843167) do |n|
  # Zero pad the number (e.g. 123 becomes 000123)
  str = sprintf("%06d", n)

  # Find all groups of duplicated digits
  multiple_digits = str.scan(/(\d)\1/).flatten.uniq

  at_least_double_digit = multiple_digits.any?
  double_digit_only = multiple_digits.select { |digit| str.count(digit) == 2 }.any?

  pc = '0'
  never_decreasing = true

  str.each_char do |c|
    if c < pc
      never_decreasing = false
      break
    end
    pc = c
  end

  if never_decreasing
    part_a += 1 if at_least_double_digit
    part_b += 1 if double_digit_only
  end
end

puts part_a
puts part_b
