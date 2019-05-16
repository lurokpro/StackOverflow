//
//  Config.m
//  Stackoverflow Lite
//
//  Created by Сергей Мирошниченко on 12/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "Config.h"


@implementation Config

NSString *const GStackOverflowAPIRequest_Questions = @"questions?page=1&order=desc&sort=week&site=stackoverflow";

NSString *const GStackOverflowAPIRequest_QuestionBodyDetail = @"questions/%@?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wwK4f";

NSString *const GStackOverflowAPIRequest_QuestionDetail = @"questions/%@/answers?order=desc&sort=votes&site=stackoverflow&filter=!9Z(-wzftf";

NSString *const GStackOverflowAPIRequest_User = @"users/%@?order=desc&sort=reputation&site=stackoverflow";

NSString *const GStackOverflowSegueID_QuestionDetailSegueID = @"QuestionDetailSegueID";

NSString *const GStackOverflowSegueID_UserSegueID = @"UserSegueID";

NSString *const GStackOverflowReusableCellID_QuestionTableViewCellID = @"QuestionTableViewCellID";

NSString *const GStackOverflowReusableCellID_TagCollectionViewCellID = @"TagCollectionViewCellID";

NSString *const GStackOverFlowNibName_QuestionTableViewCell = @"QuestionTableViewCell";

NSString *const GStackOverflowNibName_TagCollectionViewCell = @"TagCollectionViewCell";

NSString *const GStackOverflowCoreDataEntity_Question = @"Question";

NSString *const GStackOverflowCoreDataAttribute_Question_Identifier = @"identifier";

NSString *const GStackOverflowCoreDataAttribute_Question_Owner = @"owner";

NSString *const GStackOverflowCoreDataAttribute_Question_Title = @"title";

NSString *const GStackOverflowCoreDataAttribute_Question_Tags = @"tags";

NSString *const GStackOverflowCoreDataAttribute_Question_Profile_Image = @"profile_image";

NSString *const GStackOverflowSettingKey_QuestionsInCoreData = @"QuestionsInCoreData";

@end
