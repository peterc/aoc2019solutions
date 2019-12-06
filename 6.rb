# I REALLY HATE THIS SOLUTION
# BUT IT WORKS FOR NOW

input = File.readlines('6.txt').map(&:chomp)

orbits = Hash.new { |h, k| h[k] = [] }

input.each do |o|
  parent, child = o.split(')')
  orbits[child] ||= []
  orbits[parent] << child
end

orbits2 = orbits.map do |n, os|
  np = n
  ns = []

  loop do
    np = orbits.detect { |n2, os| os.include?(np) }
    if np
      np = np.first
      ns << np
    else
      break
    end
  end

  [n, [ns.length, 0].max]
end

p orbits2.inject(0) { |a, b| a + b[1] }