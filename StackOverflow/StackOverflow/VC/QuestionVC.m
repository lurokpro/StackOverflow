//
//  QuestionVC.m
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 12/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "QuestionVC.h"
#import "WebApi.h"
#import "Config.h"
#import "QuestionTableViewCell.h"
#import "Question.h"
#import "AppDelegate.h"
#import "QuestionDetailVC.h"


@interface QuestionVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *questionTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray <Question *> *questions;
@property (nonatomic, strong) NSOperationQueue *imageDownloadOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
@property (strong, nonatomic) NSArray <Question *> *searchResults;
@property (nonatomic, strong) UISearchController *searchController;

@end


@implementation QuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Список вопросов";
    
    self.questionTableView.delegate = self;
    self.questionTableView.dataSource = self;
    
    self.questions = [NSMutableArray new];
    [self.questions removeAllObjects];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.questionTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[@"Пользователь", @"Вопрос"];
    self.searchController.searchBar.delegate = self;
    
    self.searchResults = [NSArray new];

    [self.questionTableView registerNib:[UINib nibWithNibName:GStackOverFlowNibName_QuestionTableViewCell bundle:nil] forCellReuseIdentifier:GStackOverflowReusableCellID_QuestionTableViewCellID];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.imageDownloadOperationQueue = [NSOperationQueue new];
    self.imageDownloadOperationQueue.maxConcurrentOperationCount = 4;
    self.imageCache = [NSCache new];

    [WebApi request:GStackOverflowAPIRequest_Questions completion:^(NSDictionary * _Nonnull data) {
        self.questions = [self prepareDataBeforeSavingIntoCoreData:[data valueForKey:@"items"]];
        [appDelegate saveQuestions:self.questions];
        [appDelegate loadQuestions];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.activityIndicator.hidden = YES;
            self.questionTableView.hidden = NO;
            [self.questionTableView reloadData];
        }];
    }];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)prepareDataBeforeSavingIntoCoreData:(NSMutableArray *)array {
    NSMutableArray <Question *> *questions = [NSMutableArray new];
    for (id object in array) {
        Question *question = [[Question alloc] initWithID:[[object valueForKey:@"question_id"] integerValue]
                                                    owner:[[object valueForKey:@"owner"] valueForKey:@"display_name"]
                                                    title:[object valueForKey:@"title"]
                                                     tags:[[object valueForKey:@"tags"] copy]
                                             profileImage:[[object valueForKey:@"owner"] valueForKey:@"profile_image"]];
        
        [questions addObject:question];
    }
    
    return questions;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:GStackOverflowSegueID_QuestionDetailSegueID]) {
        QuestionDetailVC *vc = [segue destinationViewController];
        vc.question = [self.questions objectAtIndex:[sender integerValue]];
        UIImage *profileImage = [self.imageCache objectForKey:[self.questions objectAtIndex:[sender integerValue]].profileImage];
        vc.profileImage = profileImage;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GStackOverflowReusableCellID_QuestionTableViewCellID forIndexPath:indexPath];
    NSMutableArray <Question *> *dataSource = [NSMutableArray new];
    if (self.searchController.isActive)
        dataSource = [self.searchResults mutableCopy];
    else
        dataSource = self.questions;
        
    cell.displayName = [dataSource objectAtIndex:indexPath.row].owner;
    cell.title = [dataSource objectAtIndex:indexPath.row].title;
    cell.tags = [dataSource objectAtIndex:indexPath.row].tags;
    cell.isAnswerCell = [NSNumber numberWithBool:NO];
    NSString *imageURL = dataSource[indexPath.row].profileImage;
    UIImage *imageFromCache = [self.imageCache objectForKey:imageURL];
    
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

    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive)
        return self.searchResults.count;
    else
        return self.questions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:GStackOverflowSegueID_QuestionDetailSegueID sender:@(indexPath.row)];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSPredicate *predicate = [NSPredicate new];
    switch ([scope integerValue]) {
        case 0:
            predicate = [NSPredicate predicateWithFormat:@"owner contains[c] %@", searchText];
            break;
            
        case 1:
            predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
            break;
        
//        case 2:
//            predicate = [NSPredicate predicateWithFormat:@"tags contains[c] %@", searchText];
    }
    
    self.searchResults = [appDelegate.questions filteredArrayUsingPredicate:predicate];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text.length > 0) {
        NSInteger scopeIndex = searchController.searchBar.selectedScopeButtonIndex;
        [self filterContentForSearchText:searchController.searchBar.text scope:[NSString stringWithFormat:@"%ld", scopeIndex]];
        [self.questionTableView reloadData];
    }
}
    
- (void)didDismissSearchController:(UISearchController *)searchController {
    [self.questionTableView reloadData];
}

- (IBAction)refreshQuestions:(id)sender {
    [self viewDidLoad];
}


@end
