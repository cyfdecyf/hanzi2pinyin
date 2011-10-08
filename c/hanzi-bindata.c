#include "hanzi.h"
#include <sys/mman.h>
#include <stdio.h>
#include <stdbool.h>

/* I use a 2-byte integer to store the index in the pinyin_tbl for each Hanzi.
 * This representation is compact and is easy to search (since the pinyin table
 * is just a array).
 * If need to support polyphone, I can use a unique index for each kind of
 * possible pinyin combination. In that case, the pinyin_tbl may be too big to
 * store directly in C code.
 */

static const char *data_path =
        "/Users/alex/programming/hanzi2pinyin/data/pinyin.dat";

static uint16_t *pinyin_data;

static const UTF32 START_CODEPOINT = 0x4E00;
static const UTF32 END_CODEPOINT = 0x9FFF;

/* Obtained from data/Unihan/block1-pinyin-statistic.rb */
static const char *pinyin_tbl[] = {
    "a", "ai", "an", "ang", "ao", "ba", "bai", "ban", "bang", "bao", "bei",
    "ben", "beng", "bi", "bian", "biao", "bie", "bin", "bing", "bo", "bu", "ca",
    "cai", "can", "cang", "cao", "ce", "cen", "ceng", "cha", "chai", "chan",
    "chang", "chao", "che", "chen", "cheng", "chi", "chong", "chou", "chu",
    "chua", "chuai", "chuan", "chuang", "chui", "chun", "chuo", "ci", "cong",
    "cou", "cu", "cuan", "cui", "cun", "cuo", "da", "dai", "dan", "dang", "dao",
    "de", "den", "deng", "di", "dia", "dian", "diao", "die", "ding", "diu",
    "dong", "dou", "du", "duan", "dui", "dun", "duo", "e", "ei", "en", "eng",
    "er", "fa", "fan", "fang", "fei", "fen", "feng", "fiao", "fo", "fou", "fu",
    "ga", "gai", "gan", "gang", "gao", "ge", "gei", "gen", "geng", "gong",
    "gou", "gu", "gua", "guai", "guan", "guang", "gui", "gun", "guo", "ha",
    "hai", "han", "hang", "hao", "he", "hei", "hen", "heng", "hm", "hong",
    "hou", "hu", "hua", "huai", "huan", "huang", "hui", "hun", "huo", "ji",
    "jia", "jian", "jiang", "jiao", "jie", "jin", "jing", "jiong", "jiu", "ju",
    "juan", "jue", "jun", "ka", "kai", "kan", "kang", "kao", "ke", "ken",
    "keng", "kong", "kou", "ku", "kua", "kuai", "kuan", "kuang", "kui", "kun",
    "kuo", "la", "lai", "lan", "lang", "lao", "le", "lei", "leng", "li", "lia",
    "lian", "liang", "liao", "lie", "lin", "ling", "liu", "long", "lou", "lu",
    "luan", "lun", "luo", "lv", "lve", "m", "ma", "mai", "man", "mang", "mao",
    "me", "mei", "men", "meng", "mi", "mian", "miao", "mie", "min", "ming",
    "miu", "mo", "mou", "mu", "n", "na", "nai", "nan", "nang", "nao", "ne",
    "nei", "nen", "neng", "ni", "nian", "niang", "niao", "nie", "nin", "ning",
    "niu", "nong", "nou", "nu", "nuan", "nun", "nuo", "nv", "nve", "o", "ou",
    "pa", "pai", "pan", "pang", "pao", "pei", "pen", "peng", "pi", "pian",
    "piao", "pie", "pin", "ping", "po", "pou", "pu", "qi", "qia", "qian",
    "qiang", "qiao", "qie", "qin", "qing", "qiong", "qiu", "qu", "quan", "que",
    "qun", "r", "ran", "rang", "rao", "re", "ren", "reng", "ri", "rong", "rou",
    "ru", "rua", "ruan", "rui", "run", "ruo", "sa", "sai", "san", "sang", "sao",
    "se", "sen", "seng", "sha", "shai", "shan", "shang", "shao", "she", "shen",
    "sheng", "shi", "shou", "shu", "shua", "shuai", "shuan", "shuang", "shui",
    "shun", "shuo", "si", "song", "sou", "su", "suan", "sui", "sun", "suo",
    "ta", "tai", "tan", "tang", "tao", "te", "teng", "ti", "tian", "tiao",
    "tie", "ting", "tong", "tou", "tu", "tuan", "tui", "tun", "tuo", "wa",
    "wai", "wan", "wang", "wei", "wen", "weng", "wo", "wu", "xi", "xia", "xian",
    "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu", "xu", "xuan", "xue",
    "xun", "ya", "yan", "yang", "yao", "ye", "yi", "yin", "ying", "yo", "yong",
    "you", "yu", "yuan", "yue", "yun", "za", "zai", "zan", "zang", "zao", "ze",
    "zei", "zen", "zeng", "zha", "zhai", "zhan", "zhang", "zhao", "zhe", "zhen",
    "zheng", "zhi", "zhong", "zhou", "zhu", "zhua", "zhuai", "zhuan", "zhuang",
    "zhui", "zhun", "zhuo", "zi", "zong", "zou", "zu", "zuan", "zui", "zun",
    "zuo"
};

static int init_data() {
    CALL_ONCE(0);

    FILE *data_file;
    data_file = fopen(data_path, "rb");
    if (!data_file) {
        fprintf(stderr, "Can't open pinyin data file\n");
        return -1;
    }

    fseek(data_file, 0, SEEK_END);
    size_t length = ftell(data_file);
    fseek(data_file, 0, SEEK_SET);

    int fd = fileno(data_file);
    off_t offset = 0;
    pinyin_data = mmap(NULL, length, PROT_READ, MAP_SHARED, fd, offset);
    if (pinyin_data == MAP_FAILED) {
        fprintf(stderr, "Can't mmap pinyin data file\n");
        fclose(data_file);
        data_file = NULL;
        return -1;
    }

    return 0;
}

const char *hz_pinyin_codepoint(UTF32 cp) {
    init_data();

    if (START_CODEPOINT <= cp && cp <= END_CODEPOINT) {
        uint16_t id = pinyin_data[cp - START_CODEPOINT];
        if (id == 0xFFFF)
            return NULL;
        else
            return pinyin_tbl[id];
    } else
        return NULL;
}
