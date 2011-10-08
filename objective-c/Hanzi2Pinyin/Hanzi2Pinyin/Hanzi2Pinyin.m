//
//  Hanzi2Pinyin.m
//  Hanzi2Pinyin
//
//  Created by Chen Yufei on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Hanzi2Pinyin.h"
#import "hanzi.h"

@implementation Hanzi2Pinyin

+ (NSString *)convert:(NSString *)str {
    const char *utf32_str = [str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    uint32_t *utf32_arr = (uint32_t *)utf32_str;
    NSUInteger length = [str length];

    NSMutableString *m_str = [NSMutableString stringWithCapacity:(length * 4)];

    BOOL prev_is_pinyin = FALSE;
    
    for (NSUInteger i = 0; i < length; i++) {
//        NSLog(@"cp = %x\n", utf32_arr[i]);
        const char *pinyin = hz_pinyin_codepoint(utf32_arr[i]);
        NSRange range = {i, 1};
        NSString *cur_char = [str substringWithRange:range];
        
        // Consecutive pinyin and non-pinyin combination should add space.
        // Only both non-pinyin does not need space.
        if ((prev_is_pinyin || pinyin) && i != 0 && ![cur_char isEqualToString:@" "])
            [m_str appendString:@" "];

        // If no pinyin found, just copy that character
        if (pinyin) {
            [m_str appendString:[NSString stringWithUTF8String:pinyin]];
        } else {
            [m_str appendString:cur_char];
        }

        prev_is_pinyin = pinyin ? TRUE : FALSE;
    }

    return m_str;
}

@end
