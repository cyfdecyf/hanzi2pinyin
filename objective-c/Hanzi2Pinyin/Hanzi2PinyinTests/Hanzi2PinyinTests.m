//
//  Hanzi2PinyinTests.m
//  Hanzi2PinyinTests
//
//  Created by Chen Yufei on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Hanzi2PinyinTests.h"
#import "Hanzi2Pinyin.h"

@implementation Hanzi2PinyinTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testConvert
{
    NSString *py = [Hanzi2Pinyin convert:@"abc,love"];
    STAssertTrue([py isEqualToString:@"abc,love"], @"ASCII char should not convert");
    
    py = [Hanzi2Pinyin convert:@"你好"];
    STAssertTrue([py isEqualToString:@"ni hao"], @"pinyin not correct, got %@", py);

    py = [Hanzi2Pinyin convert:@"欢迎 world"];
    STAssertTrue([py isEqualToString:@"huan ying world"], @"pinyin not correct, got %@", py);
    
    py = [Hanzi2Pinyin convert:@"I欢迎world"];
    STAssertTrue([py isEqualToString:@"I huan ying world"], @"pinyin not correct, got %@", py);
    
    py = [Hanzi2Pinyin convert:@"Steve Jobs，祝福"];
    STAssertTrue([py isEqualToString:@"Steve Jobs， zhu fu"], @"pinyin not correct, got %@", py);
    
    py = [Hanzi2Pinyin convert:@"沈阳"];
    STAssertTrue([py isEqualToString:@"shen yang"], @"pinyin not correct, got %@", py);
}

- (void)testConvertAbbreviation
{
    NSString *py = [Hanzi2Pinyin convertToAbbreviation:@"abc,love"];
    STAssertTrue([py isEqualToString:@"abc,love"], @"ASCII char should not convert");
    
    py = [Hanzi2Pinyin convertToAbbreviation:@"你好"];
    STAssertTrue([py isEqualToString:@"nh"], @"pinyin not correct, got %@", py);
    
    py = [Hanzi2Pinyin convertToAbbreviation:@"欢迎 world"];
    STAssertTrue([py isEqualToString:@"hy world"], @"pinyin not correct, got %@", py);
    
    py = [Hanzi2Pinyin convertToAbbreviation:@"沈阳"];
    STAssertTrue([py isEqualToString:@"sy"], @"pinyin not correct, got %@", py);
}

@end
