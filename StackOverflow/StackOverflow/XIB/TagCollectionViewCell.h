//
//  TagCollectionViewCell.h
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 13/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *tagName;
@property (assign, nonatomic) CGFloat width;

@end

NS_ASSUME_NONNULL_END
