# ruby 6b-readable.rb 6.txt

planets = ARGF.map { |o| o.scan(/\w+/).reverse }.to_h

# Trace the path back through from YOU and SAN to the head of the tree
paths = ['YOU', 'SAN'].map { |i|
  o = []
  o << i while i = planets[i]
  o
}

# Find the first point both paths have in common
point_in_common = paths.inject(:&)[0]

# Add together the 'distance' to the common point in both paths
# So the total of the path from YOU to 'common' then 'common' to SAN
p paths.sum { |a| a.index(point_in_common) }
