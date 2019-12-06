# I REALLY HATE THIS SOLUTION
# BUT IT WORKS FOR NOW

input = File.readlines('6.txt').map(&:chomp)

orbits = {}

input.each do |o|
  parent, child = o.split(')')
  orbits[child] ||= []
  orbits[parent] ||= []
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
  
  [n, ns]
end

orbits2 = orbits2.to_h

hcd = (orbits2['YOU'] & orbits2['SAN']).first

a = orbits2['YOU'].take_while { |x| x != hcd }.length
b = orbits2['SAN'].take_while { |x| x != hcd }.length

puts a + b