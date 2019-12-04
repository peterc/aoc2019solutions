# Trying to make the Ruby solution as short but oblique as possible

a = 0

'382345'.upto('843167') do |n|
  at_least_double_digit = n[/(\d)\1/]
  double_digit_only = n.gsub(/(\d)\1{2,}/,'')[/(\d)\1/]
  if n[/^0*1*2*3*4*5*6*7*8*9*$/]
    a += 1 if at_least_double_digit
    a += 1i if double_digit_only
  end
end

p a