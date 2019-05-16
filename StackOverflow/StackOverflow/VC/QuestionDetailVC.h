//
//  QuestionDetailVC.h
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 14/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionDetailVC : UIViewController

@property (strong, nonatomic) Question *question;

@property (strong, nonatomic) UIImage *profileImage;

@end

NS_ASSUME_NONNULL_END
