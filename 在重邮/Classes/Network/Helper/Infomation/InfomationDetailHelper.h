//
//  InfomationDetailHelper.h
//  i重邮
//
//  Created by 谭培 on 2017/2/28.
//  Copyright © 2017年 周维康. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InfomationDetailModel;

@interface InfomationDetailHelper : NSObject

+(void)getInfomationDetailWithType:(NSString *)type andId:(NSString *)infomationId andCompletionBlock:(void(^)(NSError *erro,InfomationDetailModel *detail))completionBlock;

@end
