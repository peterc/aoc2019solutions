# Doing it this cheeky way as I can't be bothered splitting 14b.rb into
# a proper structure with methods, etc :-D

p (1..(1000000000000 / 200000)).bsearch { |i|
  puts i
  `ruby 14b.rb #{i}`.to_i > 1000000000000
} - 1