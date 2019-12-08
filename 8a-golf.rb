_=$<.chars.each_slice(150).min_by{|v|v.count('0')}
p _.count('1')*_.count('2')