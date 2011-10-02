#!/usr/bin/env ruby

require 'rubygems'
require 'sqlite3'
require 'minitest/autorun'

class TestDB < MiniTest::Unit::TestCase
  def setup
    db = SQLite3::Database.new("./codepoint2pinyin.db")
    @query = db.prepare("select pinyin from codepoint2pinyin where codepoint = ?")
  end

  def get_pinyin(c)
    @query.execute(c.codepoints.first) do |result|
      return result.next[0]
    end
  end

  def test_pinyin
    assert_equal "ni", get_pinyin('你')
    assert_equal "chen", get_pinyin('陈')
  end
end
