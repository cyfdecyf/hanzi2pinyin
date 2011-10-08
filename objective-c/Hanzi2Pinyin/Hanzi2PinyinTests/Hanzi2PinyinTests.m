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

- (void)testExample
{
    NSString *py = [Hanzi2Pinyin convert:@"abc,love"];
    STAssertTrue([py isEqualToString:@"abc,love"], @"ASCII char should not convert");
    
    py = [Hanzi2Pinyin convert:@"你好"];
    STAssertTrue([py isEqualToString:@"ni hao"], @"pinyin not correct, got %@", py);

    py = [Hanzi2Pinyin convert:@"欢迎 world"];
    STAssertTrue([py isEqualToString:@"huan ying world"], @"pinyin not correct, got %@", py);
    
    py = [Hanzi2Pinyin convert:@"Steve Jobs，祝福"];
    STAssertTrue([py isEqualToString:@"Steve Jobs， zhu fu"], @"pinyin not correct, got %@", py);    
}

@end
