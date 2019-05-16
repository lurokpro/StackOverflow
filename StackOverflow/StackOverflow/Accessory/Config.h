//
//  Config.h
//  Stackoverflow Lite
//
//  Created by Сергей Мирошниченко on 12/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Config : NSObject

extern NSString *const GStackOverflowAPIRequest_Questions;

extern NSString *const GStackOverflowAPIRequest_QuestionBodyDetail;

extern NSString *const GStackOverflowAPIRequest_QuestionDetail;

extern NSString *const GStackOverflowAPIRequest_User;

extern NSString *const GStackOverflowSegueID_QuestionDetailSegueID;

extern NSString *const GStackOverflowSegueID_UserSegueID;

extern NSString *const GStackOverflowReusableCellID_QuestionTableViewCellID;

extern NSString *const GStackOverflowReusableCellID_TagCollectionViewCellID;

extern NSString *const GStackOverFlowNibName_QuestionTableViewCell;

extern NSString *const GStackOverflowNibName_TagCollectionViewCell;

extern NSString *const GStackOverflowCoreDataEntity_Question;

extern NSString *const GStackOverflowCoreDataAttribute_Question_Identifier;

extern NSString *const GStackOverflowCoreDataAttribute_Question_Owner;

extern NSString *const GStackOverflowCoreDataAttribute_Question_Title;

extern NSString *const GStackOverflowCoreDataAttribute_Question_Tags;

extern NSString *const GStackOverflowCoreDataAttribute_Question_Profile_Image;

extern NSString *const GStackOverflowSettingKey_QuestionsInCoreData;

@end

NS_ASSUME_NONNULL_END
