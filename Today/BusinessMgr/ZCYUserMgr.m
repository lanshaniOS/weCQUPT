//
//  ZCYUserMgr.m
//  在重邮
//
//  Created by 周维康 on 16/10/26.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYUserMgr.h"

@interface ZCYUserMgr() <NSCoding>

@end
@implementation ZCYUserMgr

static ZCYUserMgr *sharedMgr = nil;

+ (ZCYUserMgr *)sharedMgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMgr = [[self alloc] init];
//        sharedMgr.studentNumber = @"";
        sharedMgr.courseArray = [[NSArray alloc] init];
    });
    return sharedMgr;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.studentNumber forKey:@"STUDENTNUMBER"];
    [aCoder encodeObject:self.courseArray forKey:@"COURSEARRAY"];
//    [aCoder encodeObject:self.schoolName forKey:@"SCHOOLNAME"];
    [aCoder encodeObject:self.eduType forKey:@"EDUTYPE"];
//    [aCoder encodeObject:self.eduMajor forKey:@"EDUMAJOR"];
    [aCoder encodeObject:self.userName forKey:@"USERNAME"];
    [aCoder encodeObject:self.cardID forKey:@"CARDID"];
    [aCoder encodeObject:self.identityID forKey:@"IDENTITYID"];
    [aCoder encodeObject:self.collegeName forKey:@"COLLEGENAME"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [ZCYUserMgr sharedMgr];
    if (self)
    {
        self.studentNumber = [aDecoder decodeObjectForKey:@"STUDENTNUMBER"];
        self.courseArray = [aDecoder decodeObjectForKey:@"COURSEARRAY"];
        self.collegeName = [aDecoder decodeObjectForKey:@"COLLEGENAME"];
        self.eduType = [aDecoder decodeObjectForKey:@"EDUTYPE"];
//        self.eduMajor = [aDecoder decodeObjectForKey:@"EDUMAJOR"];
        self.userName = [aDecoder decodeObjectForKey:@"USERNAME"];
        self.cardID = [aDecoder decodeObjectForKey:@"CARDID"];
        self.identityID = [aDecoder decodeObjectForKey:@"IDENTITYID"];
    }
    return self;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
//             NSStringFromSelector(@selector(schoolName)) : @"school",
             NSStringFromSelector(@selector(collegeName)) : @"yxm",
             NSStringFromSelector(@selector(eduType)) : @"type",
             NSStringFromSelector(@selector(userName)) : @"name",
             NSStringFromSelector(@selector(studentNumber)) : @"xh",
             NSStringFromSelector(@selector(identityID)) : @"sfzh",
             NSStringFromSelector(@selector(cardID)) : @"ykt"
             };
}
@end
