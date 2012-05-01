//
//  Hanzi2Pinyin.h
//  Hanzi2Pinyin
//
//  Created by Chen Yufei on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hanzi2Pinyin : NSObject

// Retrun a new string with all Chinese characters convreted to pinyin.
// For 2 consecutive characters, if one is Chinese, separater will be added
// if the other is not space
+ (NSMutableString *)convert:(NSString *)str separater:(NSString *)sep;

+ (NSMutableString *)convert:(NSString *)str;

// Convert each Chinese character to the first letter of its pinyin.
+ (NSMutableString *)convertToAbbreviation:(NSString *)str;

@end
