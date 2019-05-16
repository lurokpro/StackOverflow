//
//  QuestionDetailVC.m
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 14/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "QuestionDetailVC.h"
#import "Config.h"
#import "QuestionTableViewCell.h"
#import "WebApi.h"
#import "UserVC.h"

@interface QuestionDetailVC () <UITableViewDelegate, UITableViewDataSource, QuestionTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *answersTableView;

@property (strong, nonatomic) NSOperationQueue *imageDownloadOperationQueue;

@property (strong, nonatomic) NSMutableArray *answersArray;

@property (strong, nonatomic) NSCache *imageCache;

@property (strong, nonatomic) NSString *bodyText;

@end


@implementation QuestionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Описание вопроса";
    
    self.answersTableView.delegate = self;
    self.answersTableView.dataSource = self;
    
    self.answersTableView.tableFooterView = [UIView new];
    
    self.answersArray = [NSMutableArray new];
    self.imageDownloadOperationQueue = [NSOperationQueue new];
    self.imageDownloadOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [NSCache new];
    self.bodyText = [NSString new];
    
    [self.answersTableView registerNib:[UINib nibWithNibName:GStackOverFlowNibName_QuestionTableViewCell bundle:nil] forCellReuseIdentifier:GStackOverflowReusableCellID_QuestionTableViewCellID];
    
    NSString *questionID = [NSString stringWithFormat:@"%ld", self.question.identifier];
    
    NSString *requestQuestionBodyDetail = [NSString stringWithFormat:GStackOverflowAPIRequest_QuestionBodyDetail, questionID];
    NSString *requestQuestionDetail = [NSString stringWithFormat:GStackOverflowAPIRequest_QuestionDetail, questionID];
    
    [WebApi request:requestQuestionBodyDetail completion:^(NSDictionary * _Nonnull data) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.bodyText = [[[data objectForKey:@"items"] objectAtIndex:0] objectForKey:@"body_markdown"];
            [self.answersTableView reloadData];
        }];
    }];
    
    [WebApi request:requestQuestionDetail completion:^(NSDictionary * _Nonnull data) {
        self.answersArray = [NSMutableArray new];
        self.answersArray = [data valueForKey:@"items"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.answersTableView reloadData];
        }];
    }];
    // Do any additional setup after loading the view.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GStackOverflowReusableCellID_QuestionTableViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.shouldShowUserVC = [NSNumber numberWithBool:YES];
    cell.cellIndex = indexPath.row;
    switch (indexPath.row) {
        case 0: {
            cell.displayName = self.question.owner;
            cell.profileImage = self.profileImage;
            cell.title = [NSString stringWithFormat:@"%@\n\n%@", self.question.title, self.bodyText];
            cell.tags = self.question.tags;
            break;
        }
            
        default:
            if (self.answersArray.count) {
                cell.isAnswerCell = [NSNumber numberWithBool:YES];
                NSString *imageURL = [[[self.answersArray objectAtIndex:indexPath.row - 1] valueForKey:@"owner"] valueForKey:@"profile_image"];
                UIImage *imageFromCache = [self.imageCache objectForKey:imageURL];
                cell.title = [[self.answersArray objectAtIndex:indexPath.row - 1] valueForKey:@"body_markdown"];
                if (imageFromCache)
                    cell.profileImage = imageFromCache;
                else {
                    cell.profileImage = [UIImage imageNamed:@"profileBlankIcon"];
                    [self.imageDownloadOperationQueue addOperationWithBlock:^{
                        UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                        if (profileImage != nil) {
                            [self.imageCache setObject:profileImage forKey:imageURL];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                QuestionTableViewCell *updateCell = (QuestionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                                if (updateCell)
                                    updateCell.profileImage = profileImage;
                            }];
                        }
                    }];
                }
                cell.displayName = [[[self.answersArray objectAtIndex:indexPath.row - 1] valueForKey:@"owner"] valueForKey:@"display_name"];
            }
            break;
    }
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
    if (self.answersArray.count)
        numberOfRows += self.answersArray.count;
    
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didClickOnAvatarAtIndex:(NSInteger)cellIndex {
    [self performSegueWithIdentifier:GStackOverflowSegueID_UserSegueID sender:@(cellIndex)];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:GStackOverflowSegueID_UserSegueID]) {
        UserVC *vc = [segue destinationViewController];
        NSInteger cellIndex = [sender integerValue];
        switch (cellIndex) {
            case 0:
                vc.profileImage = self.profileImage;
                vc.displayName = self.question.owner;
                break;
                
            default: {
                NSString *profileKey = [[[self.answersArray objectAtIndex:cellIndex - 1] valueForKey:@"owner"] valueForKey:@"profile_image"];
                vc.profileImage = [self.imageCache objectForKey:profileKey];
                vc.displayName = [[[self.answersArray objectAtIndex:cellIndex - 1] valueForKey:@"owner"] valueForKey:@"display_name"];
                vc.userID = [[[self.answersArray objectAtIndex:cellIndex - 1] valueForKey:@"owner"] valueForKey:@"user_id"];
                break;
            }
        }
    }
}

@end
