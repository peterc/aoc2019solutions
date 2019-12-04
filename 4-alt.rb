part_a = 0
part_b = 0

'382345'.upto('843167') do |n|
  # Find all groups of duplicated digits
  multiple_digits = n.scan(/(\d)\1/).flatten.uniq
  at_least_double_digit = multiple_digits.any?
  double_digit_only = multiple_digits.select { |digit| n.count(digit) == 2 }.any?
  never_decreasing = !n.chars.find.with_index { |a, i| a < n[i-1] && i > 0 }

  part_a += 1 if at_least_double_digit && never_decreasing
  part_b += 1 if double_digit_only && never_decreasing
end

puts part_a
puts part_b
