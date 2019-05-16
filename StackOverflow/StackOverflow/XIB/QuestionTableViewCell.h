//
//  QuestionTableViewCell.h
//  Stackoverflow Lite
//
//  Created by Сергей Мирошниченко on 12/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QuestionTableViewCellDelegate <NSObject>

- (void)didClickOnAvatarAtIndex:(NSInteger)cellIndex;

@end


@interface QuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) id <QuestionTableViewCellDelegate> delegate;

@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *isAnswerCell;
@property (assign, nonatomic) NSNumber *shouldShowUserVC;
@property (assign, nonatomic) NSInteger cellIndex;

@end

NS_ASSUME_NONNULL_END
