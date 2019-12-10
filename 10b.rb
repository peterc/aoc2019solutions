# NO TRIGONOMETRY SOLUTION!

# Load the map
chart = File.readlines(ARGV.first || 'map1').map(&:chomp).map(&:chars)

# Get x, y coördinates of every asteroid
asteroids = chart.map.with_index { |row, y| row.each_index.select { |x| row[x] == '#' }.map { |x| [x, y] } }.flatten(1)

# Go over each asteroid and cross reference with every other asteroid
ax = 20
ay = 20

matches = (asteroids - [[ax, ay]]).map do |(bx, by)|
  # Figure out the smallest cartesian interval between asteroids of this slope
  xdiff = bx - ax
  ydiff = by - ay
  dx = xdiff / xdiff.gcd(ydiff)
  dy = ydiff / xdiff.gcd(ydiff)
  visible = true

  # Create a pseudo-angle, spun round so up = 0 (up-1º = 3.999)
  angle = xdiff.to_f/(xdiff.abs+(-ydiff).abs)
  angle = -angle + 2 if (-ydiff <=> 0) == -1
  angle %= 4

  # Check spots in between
  tx = ax + dx
  ty = ay + dy
  until (tx == bx && ty == by) do
    visible = false && break if chart[ty][tx] != '.'
    tx += dx
    ty += dy
  end

  [bx, by, angle] if visible
end

matched = matches.compact.sort_by { |m| m[2] }[199]
puts "#{matched[0] * 100 + matched[1]} should be 317"