# Load the map
chart = File.readlines(ARGV.first || 'map1').map(&:chomp).map(&:chars)

# Get x, y coördinates of every asteroid
asteroids = chart.map.with_index { |row, y| row.each_index.select { |x| row[x] == '#' }.map { |x| [x, y] } }.flatten(1)

results = []

# Go over each asteroid and cross reference with every other asteroid
asteroids.each do |(ax, ay)|
  seen = asteroids.count do |(bx, by)|
    # Don't count ourselves
    next if ax == bx && ay == by

    xdiff = bx - ax
    ydiff = by - ay

    # Figure out the smallest cartesian interval between asteroids of this slope
    dx = xdiff / xdiff.gcd(ydiff)
    dy = ydiff / xdiff.gcd(ydiff)
    visible = true

    # Check spots in between
    tx = ax + dx
    ty = ay + dy
    until (tx == bx && ty == by) do
      visible = false if chart[ty][tx] != '.'
      tx += dx
      ty += dy
    end
    
    visible
  end

  results << [ax, ay, seen]
end

r = results.max_by { |r| r[2] }
puts "Biggest X,Y = #{r[0]},#{r[1]} -- count is #{r[2]}"