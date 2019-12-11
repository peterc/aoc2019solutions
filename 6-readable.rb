o = {}

ARGF.each do |q| 
  a, b = q.scan(/\w+/)
  o[b] ||= []
  (o[a] ||= []) << b
end

p o.map { |y, z| 
  ns = []

  while y = o.find { |_, z| z.index(y) }
    y = y[0]
    ns << y
  end

  ns.size
}.sum
