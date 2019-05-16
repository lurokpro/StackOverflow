//
//  Question.h
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 13/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface Question : NSObject

@property (assign, nonatomic, readonly) NSInteger identifier;
@property (strong, nonatomic, readonly) NSString *owner;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSArray *tags;
@property (strong, nonatomic, readonly) NSString *profileImage;

- (instancetype)initWithID:(NSInteger)identifier
                     owner:(NSString *)owner
                     title:(NSString *)title
                      tags:(NSArray *)tags
              profileImage:(NSString *)profileImage;

+ (instancetype)questionFromManagedObject:(NSManagedObject *)questionManagedObject;

- (void)updateManagedObject:(NSManagedObject **)questionManagedObject;

@end

NS_ASSUME_NONNULL_END
