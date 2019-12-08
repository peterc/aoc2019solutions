puts File.read('8.sif')
      .chars
      .each_slice(25 * 6)
      .inject { |a, b| 
        a.map.with_index { |pixel, idx|
          pixel == '2' ? b[idx] : pixel
        }
      }
      .map { |c| c == '1' ? 'X' : ' ' }
      .each_slice(25).map(&:join).join("\n")