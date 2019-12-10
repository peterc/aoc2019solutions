puts File.read('8.sif')
      .chars
      .each_slice(25 * 6)      
      .inject { |a, b| 
        a.zip(b).map { |a, b| a == '2' ? b : a }
      }
      .map { |c| %w{` #}[c.to_i] }
      .each_slice(25).map(&:join).join("\n")