#!/usr/bin/env ruby

File.open('./unihan-codepoint2pinyin.txt') do |f|
  File.open('./block1-codepoint2pinyin.txt', 'w') do |out|
    f.each_line do |line|
      # Calling split directly on will have problem for some line.
      # Maybe split can't work correctly on some unicode character?
      # eg. U+5009,A,B,C,D
      id = line.index(' ')
      arr = line[id, line.size - id].split(' ')
      cp = arr[0].to_i(16)
      if cp > 0x9FFF
        break
      elsif 0x4E00 <= cp and cp <= 0x9FFF
        # Only take the first pinyin, do not handle multi location pinyin now.
        out.puts("#{arr[0]} #{arr[1]}")
      end
    end
  end
end
