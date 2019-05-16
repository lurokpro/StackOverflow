//
//  QuestionTableViewCell.m
//  Stackoverflow Lite
//
//  Created by Сергей Мирошниченко on 12/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "Config.h"
#import "TagCollectionViewCell.h"

@interface QuestionTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *tagsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsCollectionViewZeroHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTextViewHeightConstraint;

@end



@implementation QuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tagsCollectionView.delegate = self;
    self.tagsCollectionView.dataSource = self;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnUserAvatar:)];
    tgr.delegate = self;
    tgr.numberOfTapsRequired = 1;
    [self.profileImageView addGestureRecognizer:tgr];
    
    [self.tagsCollectionView registerNib:[UINib nibWithNibName:GStackOverflowNibName_TagCollectionViewCell bundle:nil] forCellWithReuseIdentifier:GStackOverflowReusableCellID_TagCollectionViewCellID];
    if (@available(iOS 10.0, *)) {
        self.layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    } else {
        self.layout.estimatedItemSize = CGSizeMake(1, 1);
    }
    
    [self.tagsCollectionView.collectionViewLayout invalidateLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleTextView.text = title;
    CGFloat fixedWidth = self.titleTextView.frame.size.width;
    CGSize newSize = [self.titleTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    self.titleTextViewHeightConstraint.constant = newSize.height;
}

- (void)setDisplayName:(NSString *)displayName {
    _displayName = displayName;
    self.displayNameLabel.text = displayName;
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    if (!self.isAnswerCell)
        [self.tagsCollectionView reloadData];
}

- (void)setProfileImage:(UIImage *)profileImage {
    _profileImage = profileImage;
    self.profileImageView.image = profileImage;
}

- (void)setIsAnswerCell:(NSNumber *)isAnswerCell {
    _isAnswerCell = isAnswerCell;
    if ([isAnswerCell boolValue]) {
        self.tagsCollectionViewZeroHeightConstraint.priority = 999;
    } else {
        self.tagsCollectionViewZeroHeightConstraint.priority = 998;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TagCollectionViewCell *cell = (TagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:GStackOverflowReusableCellID_TagCollectionViewCellID forIndexPath:indexPath];
    cell.tagName = [self.tags objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    if (self.tags.count)
        numberOfItems = self.tags.count;
    return numberOfItems;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)tapOnUserAvatar:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (   self.delegate
        && [self.delegate respondsToSelector:@selector(didClickOnAvatarAtIndex:)]
        && [self.shouldShowUserVC boolValue])
            [self.delegate didClickOnAvatarAtIndex:self.cellIndex];
}

@end
