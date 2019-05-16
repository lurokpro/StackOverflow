//
//  UserVC.h
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 14/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserVC : UIViewController

@property (strong, nonatomic) UIImage *profileImage;
@property (assign, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *displayName;

@end

NS_ASSUME_NONNULL_END
