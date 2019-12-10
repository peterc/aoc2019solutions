# NO TRIGONOMETRY SOLUTION!

# Load the map
chart = File.readlines(ARGV.first || 'map1').map(&:chomp).map(&:chars)

# Get x, y coördinates of every asteroid
asteroids = chart.map.with_index { |row, y| row.each_index.select { |x| row[x] == '#' }.map { |x| [x, y] } }.flatten(1)

matches = []

# Go over each asteroid and cross reference with every other asteroid
ax = 20
ay = 20

asteroids.each do |(bx, by)|
  # Don't count ourselves
  next if ax == bx && ay == by

  xdiff = bx - ax
  ydiff = by - ay
  ydiff2 = ay - by

  # Figure out the smallest cartesian interval between asteroids of this slope
  dx = xdiff / xdiff.gcd(ydiff)
  dy = ydiff / xdiff.gcd(ydiff)
  visible = true

  # Create a pseudo-angle, spun round so up = 0 (up-1º = 3.999)
  angle = xdiff.to_f/(xdiff.abs+ydiff2.abs)
  angle = -angle + 2 if (ydiff2 <=> 0) == -1
  angle %= 4

  # Check spots in between
  tx = ax + dx
  ty = ay + dy
  until (tx == bx && ty == by) do
    visible = false if chart[ty][tx] != '.'
    tx += dx
    ty += dy
  end

  if visible
    matches << [bx, by, angle]
  end
  
  visible
end

matches = matches.sort_by { |m| m[2] }

res = matches[199]
res = res[0] * 100 + res[1]

puts "#{res} should be 317"