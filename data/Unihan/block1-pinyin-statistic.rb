#!/usr/bin/env ruby

# Extract all the possible pinyin combination

py_tbl = []
py_set = {}

multipy_cnt = 0 # 3651
# characters with less than or equal to 4 bytes pinyin
le4py_cnt = 0 # 15736
total_cnt = 0 # 20253
longest_pinyin = 0

File.open('./block1-codepoint2pinyin.txt') do |f|
  f.each_line do |line|
    arr = line.split(' ')

    cp = arr[0].to_i(16)
    py = arr[1, arr.size - 1]
    longest_pinyin = py[0].size if py[0].size > longest_pinyin

    multipy_cnt += 1 if py.size > 1
    # only consider the first pinyin
    le4py_cnt += 1 if py.size == 1 and py[0].size <= 4
    total_cnt += 1

    pyid = py_set[py]
    unless pyid
      #py_tbl << py
      py_tbl << py[0] # We have only one pinyin for each Hanzi in the input data
      py_set[py] = py_tbl.size
    end
  end
end

puts "Number of multi-pinyin characters: #{multipy_cnt}"
puts "Number of characters with less than or equal to 4 bytes pinyin: #{le4py_cnt}"
puts "Longest pinyin: #{longest_pinyin}"
puts "Total number of characters: #{total_cnt}"
puts "Total number of pinyin: #{py_tbl.size}"
p py_tbl.sort
