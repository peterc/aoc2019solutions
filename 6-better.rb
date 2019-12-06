o={};$<.map{|q|r,s=q.scan(/\w+/);o[s]||=[];(o[r]||=[])<<s}
p o.map{|y,z|((ns||=[])<<y=y[0] while y=o.find{|_,z|z.index(y)})||[*ns].size}.sum