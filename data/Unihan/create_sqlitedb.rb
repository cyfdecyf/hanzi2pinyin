#!/usr/bin/env ruby

require 'rubygems'
require 'sqlite3'

if ARGV.size != 1
  puts "Usage: #{$0} <codepoint2pinyin txt file>"
  exit 1
end

maptxt = ARGV[0]

db = SQLite3::Database.new("./codepoint2pinyin.db")

db.execute('create table codepoint2pinyin (codepoint integer, pinyin text);')
db.prepare("insert into codepoint2pinyin values (:codepoint, :pinyin)") do |stmt|
  File.open(maptxt) do |f|
    f.each_line do |line|
      arr = line.chomp.split(' ', 2)
      cp = arr[0].to_i(16)
      py = arr[1]

      stmt.execute(:codepoint => cp, :pinyin => py)
    end
  end
end

db.close
