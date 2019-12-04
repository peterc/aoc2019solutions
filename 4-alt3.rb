# Not my solution but it's so good I want to keep it for posterity
# https://www.reddit.com/r/adventofcode/comments/e5u5fv/2019_day_4_solutions/f9m8jm9/

a = b = 0

'382345'.upto('843167') do |n|
  if n.chars.slice_when { |a, b| a <= b }.count == n.length
    a += 1 if n.chars.slice_when { |a, b| a != b }.count < n.length
    b += 1 if n.chars.slice_when { |a, b| a != b }.any? { |run| run.count == 2 }
  end
end

p a, b