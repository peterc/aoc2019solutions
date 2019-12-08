File.read('8.sif')
  .chars
  .each_slice(25 * 6)
  .min_by { |vs| vs.count('0') }
  .tap { |slice| puts slice.count('1') * slice.count('2') }