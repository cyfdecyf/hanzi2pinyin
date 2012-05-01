//
//  Hanzi2Pinyin.m
//  Hanzi2Pinyin
//
//  Created by Chen Yufei on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
// I want this Objecitv-C framework self contained and do not rely on C files.
// So many of the code in this file is copied from c/hanzi-bindata.c

#import "Hanzi2Pinyin.h"
#import <sys/mman.h>

/* Obtained from data/Unihan/block1-pinyin-statistic.rb */
static NSString *pinyinTbl[] = {
    @"a", @"ai", @"an", @"ang", @"ao", @"ba", @"bai", @"ban", @"bang", @"bao", @"bei",
    @"ben", @"beng", @"bi", @"bian", @"biao", @"bie", @"bin", @"bing", @"bo", @"bu", @"ca",
    @"cai", @"can", @"cang", @"cao", @"ce", @"cen", @"ceng", @"cha", @"chai", @"chan",
    @"chang", @"chao", @"che", @"chen", @"cheng", @"chi", @"chong", @"chou", @"chu",
    @"chua", @"chuai", @"chuan", @"chuang", @"chui", @"chun", @"chuo", @"ci", @"cong",
    @"cou", @"cu", @"cuan", @"cui", @"cun", @"cuo", @"da", @"dai", @"dan", @"dang", @"dao",
    @"de", @"den", @"deng", @"di", @"dia", @"dian", @"diao", @"die", @"ding", @"diu",
    @"dong", @"dou", @"du", @"duan", @"dui", @"dun", @"duo", @"e", @"ei", @"en", @"eng",
    @"er", @"fa", @"fan", @"fang", @"fei", @"fen", @"feng", @"fiao", @"fo", @"fou", @"fu",
    @"ga", @"gai", @"gan", @"gang", @"gao", @"ge", @"gei", @"gen", @"geng", @"gong",
    @"gou", @"gu", @"gua", @"guai", @"guan", @"guang", @"gui", @"gun", @"guo", @"ha",
    @"hai", @"han", @"hang", @"hao", @"he", @"hei", @"hen", @"heng", @"hm", @"hong",
    @"hou", @"hu", @"hua", @"huai", @"huan", @"huang", @"hui", @"hun", @"huo", @"ji",
    @"jia", @"jian", @"jiang", @"jiao", @"jie", @"jin", @"jing", @"jiong", @"jiu", @"ju",
    @"juan", @"jue", @"jun", @"ka", @"kai", @"kan", @"kang", @"kao", @"ke", @"ken",
    @"keng", @"kong", @"kou", @"ku", @"kua", @"kuai", @"kuan", @"kuang", @"kui", @"kun",
    @"kuo", @"la", @"lai", @"lan", @"lang", @"lao", @"le", @"lei", @"leng", @"li", @"lia",
    @"lian", @"liang", @"liao", @"lie", @"lin", @"ling", @"liu", @"long", @"lou", @"lu",
    @"luan", @"lun", @"luo", @"lv", @"lve", @"m", @"ma", @"mai", @"man", @"mang", @"mao",
    @"me", @"mei", @"men", @"meng", @"mi", @"mian", @"miao", @"mie", @"min", @"ming",
    @"miu", @"mo", @"mou", @"mu", @"n", @"na", @"nai", @"nan", @"nang", @"nao", @"ne",
    @"nei", @"nen", @"neng", @"ni", @"nian", @"niang", @"niao", @"nie", @"nin", @"ning",
    @"niu", @"nong", @"nou", @"nu", @"nuan", @"nun", @"nuo", @"nv", @"nve", @"o", @"ou",
    @"pa", @"pai", @"pan", @"pang", @"pao", @"pei", @"pen", @"peng", @"pi", @"pian",
    @"piao", @"pie", @"pin", @"ping", @"po", @"pou", @"pu", @"qi", @"qia", @"qian",
    @"qiang", @"qiao", @"qie", @"qin", @"qing", @"qiong", @"qiu", @"qu", @"quan", @"que",
    @"qun", @"r", @"ran", @"rang", @"rao", @"re", @"ren", @"reng", @"ri", @"rong", @"rou",
    @"ru", @"rua", @"ruan", @"rui", @"run", @"ruo", @"sa", @"sai", @"san", @"sang", @"sao",
    @"se", @"sen", @"seng", @"sha", @"shai", @"shan", @"shang", @"shao", @"she", @"shen",
    @"sheng", @"shi", @"shou", @"shu", @"shua", @"shuai", @"shuan", @"shuang", @"shui",
    @"shun", @"shuo", @"si", @"song", @"sou", @"su", @"suan", @"sui", @"sun", @"suo",
    @"ta", @"tai", @"tan", @"tang", @"tao", @"te", @"teng", @"ti", @"tian", @"tiao",
    @"tie", @"ting", @"tong", @"tou", @"tu", @"tuan", @"tui", @"tun", @"tuo", @"wa",
    @"wai", @"wan", @"wang", @"wei", @"wen", @"weng", @"wo", @"wu", @"xi", @"xia", @"xian",
    @"xiang", @"xiao", @"xie", @"xin", @"xing", @"xiong", @"xiu", @"xu", @"xuan", @"xue",
    @"xun", @"ya", @"yan", @"yang", @"yao", @"ye", @"yi", @"yin", @"ying", @"yo", @"yong",
    @"you", @"yu", @"yuan", @"yue", @"yun", @"za", @"zai", @"zan", @"zang", @"zao", @"ze",
    @"zei", @"zen", @"zeng", @"zha", @"zhai", @"zhan", @"zhang", @"zhao", @"zhe", @"zhen",
    @"zheng", @"zhi", @"zhong", @"zhou", @"zhu", @"zhua", @"zhuai", @"zhuan", @"zhuang",
    @"zhui", @"zhun", @"zhuo", @"zi", @"zong", @"zou", @"zu", @"zuan", @"zui", @"zun",
    @"zuo"
};

static uint16_t *pinyinData;

/* Only block1 in Unihan is covered. */                                                                                                                                              
static const uint32_t HANZI_START_CODEPOINT = 0x4E00;                                                                                                                                
static const uint32_t HANZI_END_CODEPOINT = 0x9FFF;                                                                                                                                  

static inline int isHanzi(uint32_t cp) {                                                                                                                                       
    return (HANZI_START_CODEPOINT <= cp && cp <= HANZI_END_CODEPOINT);                                                                                                               
}

static BOOL needSeparater(uint32_t prevcp, uint32_t curcp) {
    BOOL r = NO;
    if (isHanzi(curcp)) {
        r = isspace(prevcp) ? false : true;
    } else if (isspace(curcp)) {
        r = false;
    } else {
        r = isHanzi(prevcp) ? true : false;
    }
    return r;
}

static NSString *pinyinFromCodepoint(int cp) {
    if (!pinyinData)
        return nil;
    if (isHanzi(cp)) {
        uint16_t id = pinyinData[cp - HANZI_START_CODEPOINT];
        if (id == 0xFFFF)
            return nil;
        else
            return pinyinTbl[id];
    } else
        return nil;
}

@implementation Hanzi2Pinyin

+ (void)initialize {
    NSBundle* mainBundle;
    NSLog(@"bundle path is %@", [mainBundle bundlePath]);

    FILE *data_file = fopen("/Users/alex/programming/hanzi2pinyin/data/pinyin.dat", "rb");
    if (!data_file) {
        fprintf(stderr, "Can't open pinyin data file\n");
        return;
    }

    fseek(data_file, 0, SEEK_END);
    size_t length = ftell(data_file);
    fseek(data_file, 0, SEEK_SET);

    int fd = fileno(data_file);
    off_t offset = 0;
    pinyinData = mmap(NULL, length, PROT_READ, MAP_SHARED, fd, offset);
    if (pinyinData == MAP_FAILED) {
        fprintf(stderr, "Can't mmap pinyin data file\n");
        fclose(data_file);
        pinyinData = nil;
        return;
    }
}

+ (NSMutableString *)convert:(NSString *)str separater:(NSString *)sep {
    // Convert to codepoint first
    const uint32_t *cp = (const uint32_t *)([str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
    NSUInteger length = [str length];

    NSMutableString *pinyin = [NSMutableString stringWithCapacity:(length * 4)];

    uint32_t prevcp = ' ';
    for (NSUInteger i = 0; i < length; i++) {
        NSString *py = pinyinFromCodepoint(cp[i]);
        NSString *appendStr = py;
        if (!py) {
            // No pinyin found, add the original character in the string
            NSRange range = {i, 1};
            appendStr = [str substringWithRange:range];
        }
        if (needSeparater(prevcp, cp[i])) {
            [pinyin appendFormat:@"%@%@", sep, appendStr];
        } else {
            [pinyin appendString:appendStr];
        }
        prevcp = cp[i];
    }
    return pinyin;
}

+ (NSMutableString *)convert:(NSString *)str {
    return [self convert:str separater:@" "];
}

+ (NSMutableString *)convertToAbbreviation:(NSString *)str {
    // Convert to codepoint first
    const uint32_t *cp = (const uint32_t *)([str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]);
    NSUInteger length = [str length];
    
    NSMutableString *abbrev = [NSMutableString stringWithCapacity:(length)];
    
    for (NSUInteger i = 0; i < length; i++) {
        NSString *py = pinyinFromCodepoint(cp[i]);
        NSString *appendStr = py;
        if (py) {
            appendStr = [py substringToIndex:1];
        } else {
            // No pinyin found, add the original character in the string
            NSRange range = {i, 1};
            appendStr = [str substringWithRange:range];
        }
        [abbrev appendString:appendStr];
    }
    return abbrev;
}

@end
