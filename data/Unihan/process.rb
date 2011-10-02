#!/usr/bin/env ruby

# Runs with ruby 1.9

# As noted in ICU http://site.icu-project.org/design/alphabetic-index
# We should use the pinyin listed in Unihan_Readings.txt in the following order
# 1. kHanyuPinlu
# 2. kXHC1983
# 3. kHanyuPinyin
# 4. kMandarin
#
# I noticed that the pinyin file generated using only kMandarin has has weird
# pinyin for some hanzi that I do not know. Maybe they are used in some dialect,
# but I want to exclude them. The above order of fields order does give better
# results.

class UniProcess
  @@tone2char_tbl = [
    ['ā', 'a'], ['á', 'a'], ['ǎ', 'a'], ['à', 'a'],
    ['ō', 'o'], ['ó', 'o'], ['ǒ', 'o'], ['ò', 'o'],
    ['ē', 'e'], ['é', 'e'], ['ě', 'e'], ['è', 'e'],
    ['ī', 'i'], ['í', 'i'], ['ǐ', 'i'], ['ì', 'i'],
    ['ū', 'u'], ['ú', 'u'], ['ǔ', 'u'], ['ù', 'u'],
    ['ü', 'v'], ['ǘ', 'v'], ['ǚ', 'v'], ['ǜ', 'v'],
    ['ń', 'n'], ['ň', 'n'], ['ǹ', 'n'],
    ['ḿ', 'm'], ['m̄', 'm'], ['m̀', 'm'],
  ]

  def remove_tone(py)
    py[py.size - 1] =~ /\d/ ?  py[0, py.size - 1] : py
  end

  def remove_tonechar(py)
    @@tone2char_tbl.each { |tone, c| py.gsub!(tone, c) }
    # Check that if there's any tone character not removed
    # In this way I found some tone characters I do not know before
    # Manually editted U+6b38 and U+8a92 in the final output
    py.each_char do |c|
      puts "Tone character at #{@cp.to_s(16)} #{c}" if (not ('a' <= c and c <= 'z')) and c != ','
    end
    py
  end

  def extract_HanyuPinlu(py)
    # sang4(22) --> sang
    remove_tone py.sub(/\(\d*\)/, '')
  end

  def extract_HanyuPinyin(py)
    # 10028.020:gǔn,zhu --> [gun, zhu]
    py = py.sub(/^[^:]*:/, '')
    py = remove_tonechar py
    py_arr = py.split(',').map &method(:remove_tone)
  end

  def extract_XHC1983(py)
    # 10028.020:gǔn --> gun
    py = py.sub(/^[^:]*:/, '')
    remove_tone(remove_tonechar py)
  end

  def extract_Mandarin(py)
    # sang4 --> sang
    remove_tone py
  end

  def process_pinyin(py_arr, extract)
    py_arr = py_arr.map &method(extract)
    py_arr.flatten!
    py_arr.uniq!
    py_arr
  end

  def select_first_py(py_tbl)
    #p py_tbl
    py_tbl.each do |py|
      return py if py
    end
  end

  def write_output(out, cp, py_tbl)
    return if py_tbl == []
    hz = cp.chr('UTF-8')
    py = select_first_py(py_tbl)

    out.puts("#{hz} #{cp.to_s(16).upcase} #{py}")
    # clear the tbl for next character's use
    py_tbl.clear
  end

  def process
    File.open("./Unihan_Readings.txt") do |f|
      File.open('./unihan-codepoint2pinyin.txt', 'w') do |out|
        # store all possible 4 fields pinyin here
        py_tbl = []
        prev_cp = nil
        @count = 0

        f.each_line do |line|
          # skip comment
          next if line == "\n" or line[0] == '#'

          arr = line.chomp.split("\t")
          cp = arr[0]
          cp = cp[2, cp.size - 2].to_i(16)
          @cp = cp

          #puts "#{prev_cp.to_s(16)} #{cp.to_s(16)}" if prev_cp
          if prev_cp and cp != prev_cp
            write_output(out, prev_cp, py_tbl)
            @count += 1
            #exit if count >= 5
          end

          field = arr[1]
          pys = arr[2]
          if pys
            pys = pys.split(' ').map { |py| py.downcase }
          else
            next
          end

          case field
          when "kHanyuPinlu"
            py_arr = process_pinyin(pys, :extract_HanyuPinlu)
            py_tbl[0] = py_arr.join(' ')
          when "kXHC1983"
            py_arr = process_pinyin(pys, :extract_XHC1983)
            py_tbl[1] = py_arr.join(' ')
          when "kHanyuPinyin"
            py_arr = process_pinyin(pys, :extract_HanyuPinyin)
            py_tbl[2] = py_arr.join(' ')
          when "kMandarin"
            py_arr = process_pinyin(pys, :extract_Mandarin)
            py_tbl[3] = py_arr.join(' ')
          end

          prev_cp = cp
        end
      end
    end
  end
end

up = UniProcess.new
up.process

