p=$<.map{|o|o.scan(/\w+/).reverse}.to_h
i=%w{YOU SAN}.map{|i|((o||=[])<<i while i=p[i])||o}
p i.sum{|a|a.index(i.inject(:&)[0])}