# Load the map
chart = File.readlines(ARGV.first || 'map1').map(&:chomp).map(&:chars)

# Get x, y coördinates of every asteroid
asteroids = chart.map.with_index { |row, y| row.each_index.select { |x| row[x] == '#' }.map { |x| [x, y] } }.flatten(1)
results = []

matches = []

# Go over each asteroid and cross reference with every other asteroid
ax = 20
ay = 20

asteroids.each do |(bx, by)|
  # Don't count ourselves
  next if ax == bx && ay == by

  xdiff = bx - ax
  ydiff = by - ay

  # Figure out the smallest cartesian interval between asteroids of this slope
  dx = xdiff / xdiff.gcd(ydiff)
  dy = ydiff / xdiff.gcd(ydiff)
  visible = true

  angle = (1 - (1.0 - (bx-ax).to_f/((bx-ax).abs+(ay-by).abs)) * ((ay-by) <=> 0)) % 4

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

p matches[199]