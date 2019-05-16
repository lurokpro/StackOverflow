//
//  TagCollectionViewCell.m
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 13/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "TagCollectionViewCell.h"

@interface TagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidthConstraint;

@end

@implementation TagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.tagLabel.layer.masksToBounds = YES;
//    self.tagLabel.layer.borderWidth = 1.0f;
//    self.tagLabel.layer.borderColor = [self colorWithHexValue:0x9A9A9A alpha:0.4].CGColor;
//    self.tagLabel.layer.cornerRadius = 3.0f;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cellWidthConstraint = [self.contentView.widthAnchor constraintEqualToConstant:0.f];
}

- (void)setTagName:(NSString *)tagName {
    _tagName = tagName;
    self.tagLabel.text = tagName;
}

- (void)setCellWidth:(CGFloat) width {
    self.cellWidthConstraint.constant = width;
    self.cellWidthConstraint.active = YES;
}

- (UIColor *)colorWithHexValue:(const UInt32)hexValue alpha:(const CGFloat)alpha {
    const CGFloat red   = ((hexValue >> 16) & 0xFF) / (CGFloat)255.0;
    const CGFloat green = ((hexValue >>  8) & 0xFF) / (CGFloat)255.0;
    const CGFloat blue  = ( hexValue        & 0xFF) / (CGFloat)255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
