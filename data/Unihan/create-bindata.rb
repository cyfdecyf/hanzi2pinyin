#!/usr/bin/env ruby

pinyin_tbl = ["a", "ai", "an", "ang", "ao", "ba", "bai", "ban", "bang", "bao",
  "bei", "ben", "beng", "bi", "bian", "biao", "bie", "bin", "bing", "bo", "bu",
  "ca", "cai", "can", "cang", "cao", "ce", "cen", "ceng", "cha", "chai", "chan",
  "chang", "chao", "che", "chen", "cheng", "chi", "chong", "chou", "chu",
  "chua", "chuai", "chuan", "chuang", "chui", "chun", "chuo", "ci", "cong",
  "cou", "cu", "cuan", "cui", "cun", "cuo", "da", "dai", "dan", "dang", "dao",
  "de", "den", "deng", "di", "dia", "dian", "diao", "die", "ding", "diu",
  "dong", "dou", "du", "duan", "dui", "dun", "duo", "e", "ei", "en", "eng",
  "er", "fa", "fan", "fang", "fei", "fen", "feng", "fiao", "fo", "fou", "fu",
  "ga", "gai", "gan", "gang", "gao", "ge", "gei", "gen", "geng", "gong", "gou",
  "gu", "gua", "guai", "guan", "guang", "gui", "gun", "guo", "ha", "hai", "han",
  "hang", "hao", "he", "hei", "hen", "heng", "hm", "hong", "hou", "hu", "hua",
  "huai", "huan", "huang", "hui", "hun", "huo", "ji", "jia", "jian", "jiang",
  "jiao", "jie", "jin", "jing", "jiong", "jiu", "ju", "juan", "jue", "jun",
  "ka", "kai", "kan", "kang", "kao", "ke", "ken", "keng", "kong", "kou", "ku",
  "kua", "kuai", "kuan", "kuang", "kui", "kun", "kuo", "la", "lai", "lan",
  "lang", "lao", "le", "lei", "leng", "li", "lia", "lian", "liang", "liao",
  "lie", "lin", "ling", "liu", "long", "lou", "lu", "luan", "lun", "luo", "lv",
  "lve", "lü", "m", "ma", "mai", "man", "mang", "mao", "me", "mei", "men",
  "meng", "mi", "mian", "miao", "mie", "min", "ming", "miu", "mo", "mou", "mu",
  "n", "na", "nai", "nan", "nang", "nao", "ne", "nei", "nen", "neng", "ni",
  "nian", "niang", "niao", "nie", "nin", "ning", "niu", "nong", "nou", "nu",
  "nuan", "nun", "nuo", "nv", "nve", "nü", "o", "ou", "pa", "pai", "pan",
  "pang", "pao", "pei", "pen", "peng", "pi", "pian", "piao", "pie", "pin",
  "ping", "po", "pou", "pu", "qi", "qia", "qian", "qiang", "qiao", "qie", "qin",
  "qing", "qiong", "qiu", "qu", "quan", "que", "qun", "r", "ran", "rang", "rao",
  "re", "ren", "reng", "ri", "rong", "rou", "ru", "rua", "ruan", "rui", "run",
  "ruo", "sa", "sai", "san", "sang", "sao", "se", "sen", "seng", "sha", "shai",
  "shan", "shang", "shao", "she", "shen", "sheng", "shi", "shou", "shu", "shua",
  "shuai", "shuan", "shuang", "shui", "shun", "shuo", "si", "song", "sou", "su",
  "suan", "sui", "sun", "suo", "ta", "tai", "tan", "tang", "tao", "te", "teng",
  "ti", "tian", "tiao", "tie", "ting", "tong", "tou", "tu", "tuan", "tui",
  "tun", "tuo", "wa", "wai", "wan", "wang", "wei", "wen", "weng", "wo", "wu",
  "xi", "xia", "xian", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu",
  "xu", "xuan", "xue", "xun", "ya", "yan", "yang", "yao", "ye", "yi", "yin",
  "ying", "yo", "yong", "you", "yu", "yuan", "yue", "yun", "za", "zai", "zan",
  "zang", "zao", "ze", "zei", "zen", "zeng", "zha", "zhai", "zhan", "zhang",
  "zhao", "zhe", "zhen", "zheng", "zhi", "zhong", "zhou", "zhu", "zhua",
  "zhuai", "zhuan", "zhuang", "zhui", "zhun", "zhuo", "zi", "zong", "zou", "zu",
  "zuan", "zui", "zun", "zuo"]

pinyin_id = {}

pinyin_tbl.each_with_index do |py, id|
  pinyin_id[py] = id
end

next_cp = 0x4E00

def output_int_binary(out, i)
  # "s" for 16-bit signed integer, native endian
  # If need big-endian, use "n" which stands for 16-bit unsigned integer,
  # network (big-endian) byte order
  out.write([i].pack("s"))
end

File.open('./block1-codepoint2pinyin.txt') do |f|
  File.open('./pinyin.dat', 'w') do |out|
    f.each_line do |line|
      cp, py = line.split(' ')
      cp = cp.to_i(16)
      pyid = pinyin_id[py]

      if cp > next_cp
        (cp - next_cp).times do
          output_int_binary(out, 0xFFFF)
        end
      end

      output_int_binary(out, pyid)
      next_cp = cp + 1
    end
  end
end
