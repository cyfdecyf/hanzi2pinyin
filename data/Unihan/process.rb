#!/usr/bin/env ruby

# Runs with ruby 1.9

File.open("./kMandarin.txt") do |f|
  File.open('./unihan-codepoint2pinyin.txt', 'w') do |out|
    f.each_line do |line|
      cp2py = line.chomp.split()
      cp = cp2py[0]
      py = cp2py[1, cp2py.size].map do |py|
        py.downcase!
        # remove tone
        py = py[0, py.size - 1] if py[py.size - 1] =~ /\d/
      end
      py.uniq!

      hz = [cp.to_i(16)].pack('U')
      out.puts("#{hz} #{cp} #{py.join(' ')}")
    end
  end
end
