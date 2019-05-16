//
//  WebApi.h
//  Stackoverflow Lite
//
//  Created by Сергей Мирошниченко on 08/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define STACK_SERVER_ADDRESS @"https://api.stackexchange.com/2.2"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const StackServerAddress;

@interface WebApi : NSObject

+ (void)request:(NSString *)request completion:(void (^)(NSDictionary *data))completion;

@end

NS_ASSUME_NONNULL_END
