//
//  UserVC.m
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 14/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "UserVC.h"
#import "WebApi.h"
#import "Config.h"

@interface UserVC ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldBadgeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverBadgeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzeBadgeNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gold;
@property (weak, nonatomic) IBOutlet UIImageView *silver;
@property (weak, nonatomic) IBOutlet UIImageView *bronze;


@end

@implementation UserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageView.image = self.profileImage;
    self.displayNameLabel.text = self.displayName;
    
    self.gold.layer.masksToBounds = YES;
    self.silver.layer.masksToBounds = YES;
    self.bronze.layer.masksToBounds = YES;
    
    self.gold.layer.cornerRadius = 8.0f;
    self.silver.layer.cornerRadius = 8.0f;
    self.bronze.layer.cornerRadius = 8.0f;
    
    NSString *request = [NSString stringWithFormat:GStackOverflowAPIRequest_User, [self.userID stringValue]];
    
    [WebApi request:request completion:^(NSDictionary * _Nonnull data) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSArray *badges = [[data objectForKey:@"items"] copy];
            if (badges && badges.count > 0) {
                self.goldBadgeNumberLabel.text = [[[badges[0] valueForKey:@"badge_counts"] valueForKey:@"gold"] stringValue];
                self.silverBadgeNumberLabel.text = [[[badges[0] valueForKey:@"badge_counts"] valueForKey:@"silver"] stringValue];
                self.bronzeBadgeNumberLabel.text = [[[badges[0] valueForKey:@"badge_counts"] valueForKey:@"bronze"] stringValue];
            }
        }];
    }];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
