#!/usr/bin/env ruby

require 'minitest/autorun'

class TestDB < MiniTest::Unit::TestCase
  def setup
    @@up = UniProcess.new
  end

  def test_Mandarin
    assert_equal "sang", @@up.extract_Mandarin("sang4")
    assert_equal "chen", @@up.extract_Mandarin("chen")

    assert_equal ["sang", "chen"],
      @@up.process_pinyin(["sang4", "chen"], :extract_Mandarin)
  end

  def test_HanyuPinlu
    assert_equal "yi", @@up.extract_HanyuPinlu("yi1(32747)")
    assert_equal "shang", @@up.extract_HanyuPinlu("shang4(12308)")

    assert_equal ["hai", "luo"],
      @@up.process_pinyin(["hai4(123)", "luo(55)"], :extract_HanyuPinlu)
  end

  def test_HanyuPinyin
    assert_equal ["san"], @@up.extract_HanyuPinyin("10004.030:sān")
    assert_equal ["shang", "shang"], @@up.extract_HanyuPinyin("10005.040:shàng,shǎng")

    assert_equal ["shang", "san"],
      @@up.process_pinyin(["10005.040:shàng,shǎng", "10004.030:sān"],
                         :extract_HanyuPinyin)
  end

  def test_XHC1983
    assert_equal "shang", @@up.extract_XHC1983("1002.050:shǎng")

    assert_equal ["shang", "san"],
      @@up.process_pinyin(["1002.050:shǎng", "10004.030:sān"],
                         :extract_XHC1983)
  end
end
